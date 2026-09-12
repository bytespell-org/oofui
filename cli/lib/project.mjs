import fs from 'node:fs/promises';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { apply, read, json, hash, relativeName, destination } from './files.mjs';
import { closure, loadItem, index, findItem, credentials, purchaseRequired } from './registry.mjs';
import { asset, assetNames } from './assets.mjs';
import { resolveTool } from './tools.mjs';

export const privateRoot = '.oofui/private';
const configName = 'oofui.json';
const ignored = ['/.oofui/private/', '/.oofui/studio/', '/Packages/', '/DevPackages/', '/build/'];
export async function config(root) {
  const bytes = await read(await destination(root, configName));
  if (!bytes) throw Error('Run oofui init in this project first.');
  const value = JSON.parse(bytes);
  if (value.schemaVersion !== 1 || !Array.isArray(value.installed) || typeof value.managed !== 'object') throw Error('Invalid oofui.json');
  relativeName(value.path); relativeName(value.project);
  if (/^(packages|devpackages|\.oofui)(\/|$)/i.test(value.path)) throw Error('Use an editable source directory for the free library.');
  return value;
}
function run(tool, args, cwd) {
  const result = spawnSync(resolveTool(tool, cwd).path, args, { cwd, encoding: 'utf8', shell: false, timeout: 120000 });
  if (result.error || result.status !== 0) throw Error(`${tool} failed. ${result.error?.message || result.stderr || result.stdout}`);
  return result.stdout;
}
function managedChange(writes, previous, name, bytes) {
  writes.set(name, bytes);
  // Existing config/mapping is merged below, not blindly replaced with a template.
  if (previous) return hash(previous);
  return undefined;
}
async function addIgnored(root, writes, managed) {
  const name = '.gitignore', previous = await read(await destination(root, name));
  let value = (previous?.toString() || '').replace(/\n?# oofui managed ignores\n[\s\S]*?# end oofui managed ignores\n?/g, '').trimEnd();
  value += (value ? '\n\n' : '') + '# oofui managed ignores\n' + ignored.join('\n') + '\n# end oofui managed ignores\n';
  managed[name] = managedChange(writes, previous, name, value);
}
async function projectMapping(root, c, installed, writes, managed) {
  const previous = await read(await destination(root, c.project));
  if (!previous) throw Error('Rojo project missing: ' + c.project);
  const project = JSON.parse(previous);
  if (project.tree?.$className !== 'DataModel') throw Error('Select a Rojo game project with a DataModel root.');
  project.tree.ReplicatedStorage ??= { $className: 'ReplicatedStorage' };
  const storage = project.tree.ReplicatedStorage;
  if (storage.OofUi && ![c.path, c.path + '/entry.luau'].includes(storage.OofUi.$path)) throw Error('ReplicatedStorage.OofUi already maps another library.');
  // Rojo adds explicit children alongside directory-backed children; it does
  // not overlay same-named modules. Map files explicitly before adding paid
  // presets so there is exactly one styles module in the resulting DataModel.
  const node = await sourceTree(root, c.path, writes);
  const paidThemes = installed.map(findItem).filter(i => i.kind === 'theme' && i.tier !== 'free');
  for (const item of paidThemes) node.styles.presets[item.id] = { $path: privateRoot + '/styles/presets/' + item.id + '.luau' };
  if (installed.some(id => findItem(id).kind === 'kit')) node.kits = { $path: privateRoot + '/kits' };
  storage.OofUi = node;
  if (storage.Packages && storage.Packages.$path !== 'Packages') throw Error('ReplicatedStorage.Packages uses another path; map React and ReactRoblox before installing.');
  storage.Packages ??= { $path: 'Packages' };
  managed[c.project] = managedChange(writes, previous, c.project, json(project));
}
async function sourceTree(root, folder, writes) {
  const files = new Set([...writes.keys()].filter(name => name.startsWith(folder + '/')));
  const base = await destination(root, folder);
  for (const name of await fs.readdir(base, { recursive: true }).catch(error => {
    if (error.code === 'ENOENT') return []; throw error;
  })) {
    const file = folder + '/' + name.split(path.sep).join('/');
    const stat = await fs.lstat(await destination(root, file));
    if (stat.isFile()) files.add(file);
  }
  const tree = { $className: 'Folder' };
  for (const file of [...files].sort()) {
    const relative = file.slice(folder.length + 1);
    if (!/\.(luau|lua|json)$/.test(relative)) continue;
    const pieces = relative.split('/'), leaf = pieces.pop();
    let node = tree;
    for (const piece of pieces) node = node[piece] ??= { $className: 'Folder' };
    const name = leaf.replace(/\.(luau|lua|json)$/, '');
    if (name === 'entry') { delete node.$className; node.$path = file; }
    else node[name] = { $path: file };
  }
  return tree;
}
export async function install(root, names, options = {}) {
  const c = await config(root), writes = new Map(), managed = { ...c.managed };
  const paid = names.map(findItem).find(item => item.tier !== 'free');
  if (paid && !await credentials()) throw Error(purchaseRequired(paid));
  const items = closure(names);
  if (items.some(i => i.tier !== 'free')) {
    const tracked = spawnSync('git', ['ls-files', '--', privateRoot], { cwd: root, encoding: 'utf8' });
    if (tracked.status === 0 && tracked.stdout.trim()) throw Error('Paid source is already tracked by Git. Remove it from the index before installing.');
  }
  // Resolve and verify the complete set before making any changes.
  for (const item of items) {
    const bundle = await loadItem(item, options.registry || c.registry);
    for (const file of bundle.files) {
      const name = (item.tier === 'free' ? c.path : privateRoot) + '/' + file.path;
      const bytes = Buffer.from(file.content, 'base64');
      if (writes.has(name) && !writes.get(name).equals(bytes)) throw Error('Registry files disagree: ' + name);
      writes.set(name, bytes);
    }
  }
  const installed = [...new Set([...c.installed, ...items.map(i => i.id)])].sort();
  const modules = installed.map(findItem).filter(i => i.kind === 'component');
  let source = '--!strict\n-- Installed by oofui. Implementation files are yours to edit.\nlocal Ui = { styles = require(script.styles), types = require(script.types) }\n';
  for (const m of modules) source += `Ui.${m.module} = require(script.components.${m.module})\n`;
  const kits = installed.map(findItem).filter(i => i.kind === 'kit');
  if (kits.length) {
    source += 'Ui.kits = require(script.kits)\n';
    writes.set(privateRoot + '/kits/init.luau', '--!strict\nlocal Kits = { types = require(script.types) }\n' + kits.map(i => `Kits.${i.module} = require(script.${i.module})`).join('\n') + '\nreturn Kits\n');
  }
  writes.set(c.path + '/entry.luau', source + 'return Ui\n');
  await addIgnored(root, writes, managed);
  await projectMapping(root, c, installed, writes, managed);
  for (const [name, bytes] of writes) c.managed[name] = hash(bytes);
  c.installed = installed;
  if (options.registry) c.registry = options.registry;
  const oldConfig = await read(path.join(root, configName));
  managed[configName] = hash(oldConfig);
  writes.set(configName, json(c));
  const changes = await apply(root, writes, { ...options, managed });
  return { installed: installed.filter(id => !id.startsWith('_')), changes, dryRun: !!options.dryRun };
}

async function skillWrites() {
  const writes = new Map();
  for (const name of await assetNames('skill/')) writes.set('.agents/skills/oofui/' + name.slice(6), await asset(name));
  return writes;
}
export async function skill(root, options = {}) {
  const writes = await skillWrites();
  return { skill: '.agents/skills/oofui/SKILL.md', changes: await apply(root, writes, options) };
}

export async function init(root, options = {}) {
  if (!options.dryRun) await fs.mkdir(root, { recursive: true });
  if (await read(path.join(root, configName))) return { initialized: true, config: await config(root), note: 'Already initialized; use oofui add to install components.' };
  const writes = new Map(), managed = {};
  const projectName = relativeName(options.project || 'default.project.json');
  if (projectName.includes('/')) throw Error('Choose a project filename in the game root; use --cwd to select another game directory.');
  const sourcePath = relativeName(options.path || 'vendor/oofui');
  if (/^(packages|devpackages|\.oofui)(\/|$)/i.test(sourcePath)) throw Error('Choose an editable source path outside Packages and .oofui.');
  let projectBytes = await read(await destination(root, projectName));
  if (!projectBytes) {
    const project = { name: 'oofui-game', tree: { $className: 'DataModel',
      ReplicatedStorage: { $className: 'ReplicatedStorage', Packages: { $path: 'Packages' } },
      StarterPlayer: { StarterPlayerScripts: { $className: 'StarterPlayerScripts', Client: { $path: 'src/client' } } },
      Workspace: { $properties: { FilteringEnabled: true }, Baseplate: { $className: 'Part', $properties: { Anchored: true, Size: [512, 1, 512], Position: [0, -0.5, 0], Color: [0.22, 0.3, 0.27] } }, SpawnLocation: { $className: 'SpawnLocation', $properties: { Anchored: true, Position: [0, 1, 0], Size: [6, 1, 6], Neutral: true } } } } };
    projectBytes = Buffer.from(json(project)); writes.set(projectName, projectBytes);
    writes.set('src/client/init.client.luau', '--!strict\n-- Ask your agent to compose a UI with the installed oofui skill.\nprint("oofui project ready")\n');
  }
  const project = JSON.parse(projectBytes);
  if (project.tree?.$className !== 'DataModel') throw Error('Choose a Rojo game project, not the library model.');
  if (project.tree.ReplicatedStorage?.OofUi) throw Error('OofUi is already mapped. Inspect that integration before initializing.');
  project.tree.ReplicatedStorage ??= { $className: 'ReplicatedStorage' };
  if (project.tree.ReplicatedStorage.Packages && project.tree.ReplicatedStorage.Packages.$path !== 'Packages') throw Error('ReplicatedStorage.Packages uses another path; reconcile that mapping first.');
  project.tree.ReplicatedStorage.Packages ??= { $path: 'Packages' };
  project.tree.ReplicatedStorage.OofUi = { $path: sourcePath + '/entry.luau' };
  const oldProject = await read(await destination(root, projectName));
  managed[projectName] = managedChange(writes, oldProject, projectName, json(project));
  const oldWally = await read(await destination(root, 'wally.toml'));
  let wally = oldWally?.toString() || '[package]\nname = "local/oofui-game"\nversion = "0.1.0"\nrealm = "shared"\nregistry = "https://github.com/UpliftGames/wally-index"\nprivate = true\n';
  if (!/^\[dependencies\]\s*$/m.test(wally)) wally += '\n[dependencies]\n';
  for (const [name, value] of [['React', 'jsdotlua/react@17.2.1'], ['ReactRoblox', 'jsdotlua/react-roblox@17.2.1']]) {
    const section = wally.match(/^\[dependencies\]\s*\n([\s\S]*?)(?=^\[|$(?![\s\S]))/m)?.[1] || '';
    const existing = section.match(new RegExp('^' + name + '\\s*=\\s*"([^"\\n]+)"', 'm'))?.[1];
    if (existing && existing !== value) throw Error(`${name} is already ${existing}; reconcile React dependencies before initialization.`);
    if (!existing) wally = wally.replace(/^\[dependencies\]\s*$/m, `[dependencies]\n${name} = "${value}"`);
  }
  managed['wally.toml'] = managedChange(writes, oldWally, 'wally.toml', wally);
  if (!await read(path.join(root, 'rokit.toml'))) writes.set('rokit.toml', await asset('templates/rokit.toml'));
  const c = { schemaVersion: 1, version: index.version, path: sourcePath, project: projectName, registry: options.registry || null, installed: ['_base'], managed: {} };
  const base = await loadItem(findItem('_base'));
  for (const file of base.files) writes.set(sourcePath + '/' + file.path, Buffer.from(file.content, 'base64'));
  writes.set(sourcePath + '/entry.luau', '--!strict\n-- Installed by oofui. Implementation files are yours to edit.\nlocal Ui = { styles = require(script.styles), types = require(script.types) }\nreturn Ui\n');
  await addIgnored(root, writes, managed);
  for (const [name, bytes] of await skillWrites()) writes.set(name, bytes);
  for (const [name, value] of writes) c.managed[name] = hash(value);
  project.tree.ReplicatedStorage.OofUi = await sourceTree(root, sourcePath, writes);
  writes.set(projectName, json(project));
  c.managed[projectName] = hash(json(project));
  writes.set(configName, json(c));
  const changes = await apply(root, writes, { ...options, managed });
  return { initialized: !options.dryRun, dryRun: !!options.dryRun, changes, next: 'Run oofui add progressbar; oofui build; oofui studio open.' };
}
export async function info(root) {
  const c = await config(root);
  return { ...c, managed: undefined, installed: c.installed.filter(id => !id.startsWith('_')).map(findItem),
    privateSource: privateRoot, skill: '.agents/skills/oofui/SKILL.md', import: 'require(game:GetService("ReplicatedStorage").OofUi)',
    note: 'Installed item names are not entitlement. Paid downloads require server verification.' };
}
export async function build(root) {
  const c = await config(root);
  run('wally', ['install'], root);
  await fs.mkdir(path.join(root, 'build'), { recursive: true });
  run('rojo', ['build', c.project, '-o', 'build/game.rbxlx'], root);
  return { built: 'build/game.rbxlx', executed: false, next: 'oofui studio open' };
}
