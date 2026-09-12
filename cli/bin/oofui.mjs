#!/usr/bin/env node
import fs from 'node:fs/promises';
import path from 'node:path';
import { parseArgs } from 'node:util';
import { setupTools, toolStatus } from '../lib/tools.mjs';
import { init, install, skill, info, build } from '../lib/project.mjs';
import { index, findItem, loadItem, login, logout, normalize } from '../lib/registry.mjs';
import { studio } from '../lib/studio.mjs';

const help = `oofui ${index.version} — editable native Roblox UI

  oofui init                         Set up a new or existing Rojo game + agent skill
  oofui add progressbar button       Add components and their dependencies
  oofui component add progressbar    Explicit component alias
  oofui theme add circuit            Install a purchased theme
  oofui kit add inventory            Install a Pro Plus kit
  oofui skill add                    Install .agents/skills/oofui into this project
  oofui list [query]                 Discover free and paid components
  oofui view <item>                  Inspect source before installing
  oofui docs <item>                  Read the item's API and usage guidance
  oofui info --json                  Project-aware context for agents
  oofui setup [--yes]                Check or install the pinned Roblox build tools
  oofui doctor                      Check Roblox build tools and Studio
  oofui build                        Install Wally dependencies and build the game
  oofui studio open|status|close     Manage one disposable Studio session
  oofui auth login --origin <URL> --token-stdin
  oofui auth logout                  Remove the saved purchase credential

Options: --cwd <dir> --project <rojo.json> --path <source-dir>
         --dry-run --overwrite --json --registry <origin> --help --version

Install or update the standalone CLI: https://oofui.bytespell.com/#/docs/installation
The standalone executable requires no Node, npm, or Bun installation.
Paid code belongs in .oofui/private, which the CLI excludes from Git.
To refresh source after updating the CLI, preview oofui add <items...> --dry-run,
then repeat without --dry-run. Review and merge local edits before --overwrite.
Update guide: https://oofui.bytespell.com/#/docs/cli?section=updating
`;
let structured = false;
try {
  const { values, positionals } = parseArgs({ allowPositionals: true, options: {
    cwd: { type: 'string' }, project: { type: 'string' }, path: { type: 'string' }, registry: { type: 'string' }, origin: { type: 'string' },
    'dry-run': { type: 'boolean' }, overwrite: { type: 'boolean' }, json: { type: 'boolean' },
    yes: { type: 'boolean' }, 'token-stdin': { type: 'boolean' }, help: { type: 'boolean', short: 'h' }, version: { type: 'boolean', short: 'v' },
  } });
  structured = !!values.json;
  if (values.version) { console.log(index.version); process.exit(0); }
  if (values.help || !positionals.length) { console.log(help); process.exit(0); }
  const root = path.resolve(values.cwd || '.'), options = { ...values, dryRun: values['dry-run'] };
  let [command, ...args] = positionals, kind;
  if (['component', 'theme', 'kit'].includes(command)) { kind = command; command = args.shift(); if (command !== 'add') throw Error('Use ' + kind + ' add <name>.'); }
  let result;
  if (command === 'init') result = await init(root, options);
  else if (command === 'add') {
    if (!args.length) throw Error('Choose an item, for example oofui add progressbar.');
    if (kind && args.some(name => findItem(name).kind !== kind)) throw Error('The requested item is not a ' + kind + '.');
    if (args.some(name => findItem(name).kind === 'internal')) throw Error('Internal dependencies are installed automatically.');
    result = await install(root, args, options);
  } else if (command === 'skill' && args[0] === 'add') result = await skill(root, options);
  else if (command === 'list') {
    const query = normalize(args.join(' '));
    result = index.items.filter(i => i.kind !== 'internal' && normalize(i.id + ' ' + i.description).includes(query));
  } else if (command === 'info') result = await info(root);
  else if (command === 'view' || command === 'docs') {
    if (args.length !== 1) throw Error('Choose one item.');
    const item = findItem(args[0]);
    if (command === 'docs') {
      result = { ...item, files: undefined, add: 'oofui add ' + item.id, api: 'oofui view ' + item.id,
        usage: item.kind === 'kit' ? `React.createElement(Ui.kits.${item.module}, props)` : item.kind === 'theme' ? `Ui.styles.createTheme({ theme = Ui.styles.themes.${item.id} })` : `React.createElement(Ui.${item.module}, props)`,
        reference: `https://oofui.bytespell.com/#/${item.kind === 'kit' ? 'kits/' + item.id : item.kind === 'theme' ? 'themes?section=' + item.id : 'components/' + item.id}`,
        guidance: 'Use lowercase component props. Mount StyleProvider inside a ScreenGui with ZIndexBehavior = Enum.ZIndexBehavior.Sibling. Read the source Props type with view before composing. Paid kits expose intent callbacks; game servers validate ownership, currency, rewards, and requests.' };
    } else result = await loadItem(item, values.registry);
  } else if (command === 'build') result = await build(root);
  else if (command === 'studio') result = await studio(root, args[0]);
  else if (command === 'doctor') {
    result = { platform: process.platform, tools: toolStatus(root), studio: await studio(root, 'status') };
    if (Object.values(result.tools).some(t => !t.available)) process.exitCode = 1;
  } else if (command === 'setup') {
    result = await setupTools(root, values.yes);
    if (Object.values(result.tools).some(tool => !tool.available)) process.exitCode = 1;
  } else if (command === 'auth' && args[0] === 'login') {
    if (!values.origin || !values['token-stdin']) throw Error('Use oofui auth login --origin <store URL> --token-stdin. Pipe the access code securely; never put it in command arguments.');
    let text = '';
    for await (const chunk of process.stdin) { text += chunk; if (text.length > 256) throw Error('Invalid access code.'); }
    result = await login(values.origin, text.trim());
  } else if (command === 'auth' && args[0] === 'logout') { await logout(); result = { signedOut: true }; }
  else throw Error('Unknown command. Run oofui --help.');
  if (!structured && command === 'docs') {
    console.log(`${result.module || result.id} · ${result.tier === 'free' ? 'Core (free)' : result.tier === 'pro-plus' ? 'Pro Plus' : 'Pro'}\n${result.description}\n\nInstall: ${result.add}\nUse: ${result.usage}\n\nAPI reference: ${result.reference}\nInspect Props and source: ${result.api}\n\n${result.guidance}`);
  } else if (!structured && command === 'view') {
    for (const file of result.files) {
      if (file.path.endsWith('.luau') || file.path.endsWith('.md')) console.log('\n--- ' + file.path + ' ---\n' + Buffer.from(file.content, 'base64').toString());
      else console.log(file.path + ' (' + file.sha256.slice(0, 12) + ')');
    }
  } else if (!structured && command === 'list') for (const item of result) console.log(`${item.id.padEnd(22)} ${item.kind.padEnd(10)} ${item.tier}`);
  else if (!structured && result.changes) {
    if (options.dryRun) {
      console.log('Preview only — no files changed.');
      for (const change of result.changes) console.log(`  ${change.action.padEnd(6)} ${change.path}`);
    } else {
      console.log(result.changes.length ? `Ready. ${result.changes.length} files added or updated.` : 'Already up to date.');
      if (result.installed) console.log('Installed: ' + result.installed.join(', '));
      if (result.skill) console.log('Skill: ' + result.skill);
      if (result.next) console.log('Next: ' + result.next);
    }
  } else if (!structured && result.initialized && result.config) console.log('Already initialized. Use oofui add <items...> to install components, or oofui info --json to inspect this project.');
  else if (!structured && result.built) console.log(`Built ${result.built}\nNext: ${result.next}\nPress Play to verify runtime and interactions.`);
  else if (!structured && result.productId) console.log(`Connected to ${result.origin}\nAccess: ${result.productId}`);
  else console.log(JSON.stringify(result, null, 2));
} catch (error) {
  if (structured) console.error(JSON.stringify({ error: error.message }));
  else console.error('oofui: ' + error.message);
  process.exitCode = 1;
}
