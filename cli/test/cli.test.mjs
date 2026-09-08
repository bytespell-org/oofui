import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { execFile } from 'node:child_process';
import { promisify } from 'node:util';
import { createServer } from 'node:http';
import { apply, hash } from '../lib/files.mjs';
import { origin } from '../lib/registry.mjs';

const exec = promisify(execFile), cli = fileURLToPath(new URL('../bin/oofui.mjs', import.meta.url));
async function temporary(t) {
  const root = await fs.mkdtemp(path.join(os.tmpdir(), 'oofui-cli-'));
  t.after(() => fs.rm(root, { recursive: true, force: true }));
  return root;
}
const run = (root, args, env = {}) => exec(process.execPath, [cli, ...args, '--cwd', root, '--json'], { env: { ...process.env, ...env } });
async function contents(root) {
  const result = {};
  for (const name of await fs.readdir(root, { recursive: true })) {
    const p = path.join(root, name); if ((await fs.lstat(p)).isFile()) result[name] = hash(await fs.readFile(p));
  }
  return result;
}
test('fresh init, component alias, dependency closure and repeated installs work', async t => {
  const root = await temporary(t);
  await run(root, ['init']);
  await run(root, ['component', 'add', 'progressbar', 'hold-button']);
  assert.match(await fs.readFile(path.join(root, 'vendor/oofui/entry.luau'), 'utf8'), /Ui.ProgressBar/);
  assert.ok((await fs.stat(path.join(root, '.agents/skills/oofui/SKILL.md'))).isFile());
  const before = await contents(root);
  await run(root, ['add', 'progress-bar', 'hold-button']);
  assert.deepEqual(await contents(root), before);
  const config = JSON.parse(await fs.readFile(path.join(root, 'oofui.json')));
  assert.ok(config.installed.includes('radial-progress'));
  assert.ok(config.installed.includes('text'));
  assert.ok(!Object.keys(before).some(n => n.includes('/kits/') || n.endsWith('/circuit.luau')));
});
test('dry run and a local-edit conflict leave the entire project intact', async t => {
  const root = await temporary(t); await run(root, ['init']); await run(root, ['add', 'button']);
  const file = path.join(root, 'vendor/oofui/components/Button.luau');
  await fs.appendFile(file, '\n-- local customization\n');
  const before = await contents(root);
  await run(root, ['add', 'progressbar', '--dry-run']);
  assert.deepEqual(await contents(root), before);
  await assert.rejects(run(root, ['add', 'button', 'text-field']), /Local changes/);
  assert.deepEqual(await contents(root), before);
});
test('initialization previews the complete install and does not partially write over an existing skill', async t => {
  const root = await temporary(t);
  const preview = JSON.parse((await run(root, ['init', '--dry-run'])).stdout);
  assert.ok(preview.changes.some(c => c.path.endsWith('/styles/Theme.luau')));
  assert.deepEqual(await fs.readdir(root), []);
  await fs.mkdir(path.join(root, '.agents/skills/oofui'), { recursive: true });
  await fs.writeFile(path.join(root, '.agents/skills/oofui/SKILL.md'), 'Local skill customization');
  const before = await contents(root);
  await assert.rejects(run(root, ['init']), /Local changes/);
  assert.deepEqual(await contents(root), before);
});
test('merges existing game mappings and Wally dependencies without replacing game code', async t => {
  const root = await temporary(t);
  await fs.writeFile(path.join(root, 'default.project.json'), JSON.stringify({ name: 'existing', tree: { $className: 'DataModel', ServerScriptService: { $path: 'server' } } }));
  await fs.writeFile(path.join(root, 'wally.toml'), '[package]\nname="test/game"\nversion="1.0.0"\nrealm="shared"\nregistry="https://github.com/UpliftGames/wally-index"\n[dependencies]\nSignal="sleitnick/signal@2.0.3"\n');
  await run(root, ['init']);
  assert.equal(JSON.parse(await fs.readFile(path.join(root, 'default.project.json'))).tree.ServerScriptService.$path, 'server');
  assert.match(await fs.readFile(path.join(root, 'wally.toml'), 'utf8'), /Signal="sleitnick\/signal@2.0.3"/);
  assert.equal(await fs.access(path.join(root, 'src/client/init.client.luau')).then(() => true, () => false), false);
});
test('traversal and symlink destinations cannot escape the project', async t => {
  const root = await temporary(t), outside = await temporary(t);
  await fs.symlink(outside, path.join(root, 'linked'), process.platform === 'win32' ? 'junction' : 'dir');
  for (const name of ['../outside', 'linked/evil.luau', '/absolute', 'x/../../escape', '.git/config', '.GIT/config', '.git./config', 'C:\\escape']) {
    await assert.rejects(apply(root, new Map([[name, 'bad']])));
  }
  assert.deepEqual(await fs.readdir(outside), []);
});
test('credentials require a pinned secure origin', () => {
  for (const value of ['http://store.example', 'https://user:pass@store.example', 'https://store.example/path', 'https://store.example?token=x']) assert.throws(() => origin(value));
  assert.equal(origin('https://store.example'), 'https://store.example');
  assert.equal(origin('http://127.0.0.1:8787'), 'http://127.0.0.1:8787');
});
test('paid responses are verified and private source is ignored, never installed into free source', async t => {
  const root = await temporary(t), auth = await temporary(t);
  await run(root, ['init']);
  const data = Buffer.from('return {}\n'); let corrupt = false;
  const server = createServer((req, res) => {
    if (req.headers.authorization !== 'Bearer ' + 'c'.repeat(64)) { res.writeHead(403).end(); return; }
    res.setHeader('content-type', 'application/json');
    if (req.url === '/api/cli/account') { res.end(JSON.stringify({ productId: 'oof-ui-pro' })); return; }
    res.end(JSON.stringify({ schemaVersion: 1, version: '0.1.0', id: 'circuit', tier: 'pro', dependencies: ['_base'], files: [{ path: 'styles/presets/circuit.luau', encoding: 'base64', content: data.toString('base64'), sha256: corrupt ? 'f'.repeat(64) : hash(data) }] }));
  });
  await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
  t.after(() => new Promise(resolve => server.close(resolve)));
  const url = 'http://127.0.0.1:' + server.address().port;
  // Seed a local credential only for this protocol test. Production login is covered separately.
  await fs.writeFile(path.join(auth, 'auth.json'), JSON.stringify({ origin: url, token: 'c'.repeat(64) }));
  const env = { OOFUI_CONFIG_DIR: auth };
  corrupt = true;
  const before = await contents(root);
  await assert.rejects(run(root, ['theme', 'add', 'circuit'], env), /checksum mismatch/);
  assert.deepEqual(await contents(root), before);
  corrupt = false; await run(root, ['theme', 'add', 'circuit'], env);
  assert.equal(await fs.readFile(path.join(root, '.oofui/private/styles/presets/circuit.luau'), 'utf8'), data.toString());
  assert.match(await fs.readFile(path.join(root, '.gitignore'), 'utf8'), /\/\.oofui\/private\//);
  assert.equal(await fs.access(path.join(root, 'vendor/oofui/styles/presets/circuit.luau')).then(() => true, () => false), false);
  const project = JSON.parse(await fs.readFile(path.join(root, 'default.project.json')));
  assert.equal(project.tree.ReplicatedStorage.OofUi.styles.presets.circuit.$path, '.oofui/private/styles/presets/circuit.luau');
  await t.test('Rojo emits one style module and a real StarterPlayerScripts container', async () => {
    await fs.mkdir(path.join(root, 'Packages'));
    await exec('rojo', ['build', 'default.project.json', '-o', 'game.rbxlx'], { cwd: root });
    await exec('rojo', ['sourcemap', 'default.project.json', '--output', 'tree.json'], { cwd: root });
    const tree = JSON.parse(await fs.readFile(path.join(root, 'tree.json')));
    const child = (node, name) => {
      const matches = node.children.filter(n => n.name === name);
      assert.equal(matches.length, 1, 'Expected exactly one ' + name);
      return matches[0];
    };
    const scripts = child(child(tree, 'StarterPlayer'), 'StarterPlayerScripts');
    assert.equal(scripts.className, 'StarterPlayerScripts');
    assert.equal(child(scripts, 'Client').className, 'LocalScript');
    const styles = child(child(child(tree, 'ReplicatedStorage'), 'OofUi'), 'styles');
    assert.equal(styles.className, 'ModuleScript');
    assert.equal(child(child(styles, 'presets'), 'circuit').className, 'ModuleScript');
  });
});

test('rejects generated dependency paths on case-insensitive filesystems before writing', async t => {
  const root = await temporary(t);
  for (const value of ['Packages', 'packages/cli', 'DevPackages/ui', '.OOFUI/private']) {
    await assert.rejects(run(root, ['init', '--path', value]), /editable source/);
    assert.deepEqual(await fs.readdir(root), []);
  }
  await assert.rejects(run(root, ['init', '--project', 'nested/default.project.json']), /game root/);
  assert.deepEqual(await fs.readdir(root), []);
});
