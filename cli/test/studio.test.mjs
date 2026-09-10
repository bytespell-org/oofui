import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import { spawn, execFile } from 'node:child_process';
import { promisify } from 'node:util';
import { fileURLToPath } from 'node:url';

const exec = promisify(execFile);
const cli = fileURLToPath(new URL('../bin/oofui.mjs', import.meta.url));

test('Studio status and close recover a replacement PID without closing another session', { skip: process.platform === 'win32' }, async t => {
  const root = await fs.mkdtemp(path.join(os.tmpdir(), 'oofui-studio-'));
  t.after(() => fs.rm(root, { recursive: true, force: true }));
  const binary = path.join(root, 'RobloxStudio');
  // Real OS processes simulate the updater handoff; this is not native UI proof.
  await fs.link(process.execPath, binary).catch(() => fs.copyFile(process.execPath, binary));
  const place = path.join(root, 'owned place/game.rbxlx');
  const children = [];
  t.after(() => { for (const child of children) if (child.exitCode === null && child.signalCode === null) child.kill(); });
  async function launch(source, parentPid) {
    const launchArgs = parentPid ? ['-launchIntentString', JSON.stringify({ task: 'EditFile', localplacefile: source }), '-parentPid', String(parentPid)] : ['--localPlaceFile', source];
    const child = spawn(binary, ['-e', 'setInterval(() => {}, 1000)', '--', ...launchArgs], { stdio: 'ignore' });
    children.push(child);
    await new Promise((resolve, reject) => { child.once('spawn', resolve); child.once('error', reject); });
    return child;
  }
  const unrelated = await launch(place + '.other');
  const replacement = await launch(place, unrelated.pid);
  const config = path.join(root, 'config'), stateFile = path.join(config, 'studio/session.json');
  await fs.mkdir(path.dirname(stateFile), { recursive: true });
  await fs.writeFile(stateFile, JSON.stringify({ pid: unrelated.pid, project: root, sessionPlace: place, sha256: 'test' }));
  const run = args => exec(process.execPath, [cli, 'studio', ...args, '--cwd', root, '--json'], { env: { ...process.env, OOFUI_CONFIG_DIR: config } });
  const status = JSON.parse((await run(['status'])).stdout);
  assert.equal(status.status, 'open');
  assert.equal(status.pid, replacement.pid);
  assert.equal(JSON.parse(await fs.readFile(stateFile)).pid, replacement.pid);
  await assert.rejects(run(['open']), /already open/);
  assert.equal(JSON.parse((await run(['close'])).stdout).status, 'closed');
  assert.equal(JSON.parse((await run(['status'])).stdout).status, 'closed');
  assert.throws(() => process.kill(replacement.pid, 0), /ESRCH/);
  assert.doesNotThrow(() => process.kill(unrelated.pid, 0));
});
