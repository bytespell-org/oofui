#!/usr/bin/env node
import fs from 'node:fs/promises';
import path from 'node:path';
import { parseArgs } from 'node:util';
import { setupTools, toolStatus } from '../lib/tools.mjs';
import { init, install, skill, info, build, dev } from '../lib/project.mjs';
import { index, findItem, loadItem, login, logout, normalize } from '../lib/registry.mjs';
import { docs, formatDocs } from '../lib/docs.mjs';
import { formatList, formatDoctor, formatInit, formatAdd } from '../lib/format.mjs';
import { studio, executable } from '../lib/studio.mjs';

const help = `oofui ${index.version} — editable native Roblox UI components

Get started
  oofui init                     New Rojo game with a starter HUD (--bare to skip the HUD)
  oofui build                    Install Wally packages and build build/game.rbxlx
  oofui studio open              Open the build in Studio, then press Play
  oofui dev                      Live-sync edits into Studio with rojo serve

Components
  oofui list [query]             Browse components and themes
  oofui docs <item>              Props and a copy-paste example
  oofui add <items...>           Add components; dependencies come along
  oofui view <item>              Print an item's source before installing

Project
  oofui doctor                   Check Rojo, Wally and Studio
  oofui setup [--yes]            Install the pinned Rojo and Wally tools
  oofui info --json              Project context for agents
  oofui skill add                Install the agent skill at .agents/skills/oofui
  oofui studio status|close      Manage the Studio window oofui opened

Pro themes and kits
  oofui theme add <name>         oofui kit add <name>
  oofui auth login --origin <URL> --token-stdin
  oofui auth logout

Options: --cwd <dir> --project <rojo.json> --path <source-dir> --bare
         --dry-run --overwrite --json --registry <origin> --help --version

Your local edits are protected: preview updates with --dry-run, and nothing
you changed is replaced without --overwrite. Paid code lives in ignored .oofui/private.
Docs and installer: https://oofui.bytespell.com
`;
let structured = false;
async function installedIds(root) {
  try { return (await info(root)).installed.map(item => item.id); } catch { return []; }
}
try {
  const { values, positionals } = parseArgs({ allowPositionals: true, options: {
    cwd: { type: 'string' }, project: { type: 'string' }, path: { type: 'string' }, registry: { type: 'string' }, origin: { type: 'string' },
    'dry-run': { type: 'boolean' }, overwrite: { type: 'boolean' }, json: { type: 'boolean' },
    yes: { type: 'boolean' }, bare: { type: 'boolean' }, 'token-stdin': { type: 'boolean' }, help: { type: 'boolean', short: 'h' }, version: { type: 'boolean', short: 'v' },
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
    result = index.items.filter(i => i.kind !== 'internal' && normalize(i.id + ' ' + i.module + ' ' + i.description).includes(query));
  } else if (command === 'info') result = await info(root);
  else if (command === 'docs') {
    if (args.length !== 1) throw Error('Choose one item, for example oofui docs button.');
    result = await docs(args[0], await installedIds(root));
  } else if (command === 'view') {
    if (args.length !== 1) throw Error('Choose one item, for example oofui view button.');
    result = await loadItem(findItem(args[0]), values.registry);
  } else if (command === 'build') result = await build(root);
  else if (command === 'dev') { await dev(root); process.exit(0); }
  else if (command === 'studio') result = await studio(root, args[0]);
  else if (command === 'doctor') {
    result = { platform: process.platform, tools: toolStatus(root), studio: await studio(root, 'status'),
      studioPath: await executable().catch(() => null) };
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
    console.log(formatDocs(result));
  } else if (!structured && command === 'view') {
    for (const file of result.files) {
      if (file.path.endsWith('.luau') || file.path.endsWith('.md')) console.log('\n--- ' + file.path + ' ---\n' + Buffer.from(file.content, 'base64').toString());
      else console.log(file.path + ' (' + file.sha256.slice(0, 12) + ')');
    }
  } else if (!structured && command === 'list') console.log(formatList(result, await installedIds(root)));
  else if (!structured && command === 'doctor') console.log(formatDoctor(result));
  else if (!structured && command === 'init' && result.changes && !options.dryRun) console.log(formatInit(result));
  else if (!structured && command === 'add' && !options.dryRun) console.log(formatAdd(result));
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
