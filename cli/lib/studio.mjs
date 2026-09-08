import fs from 'node:fs/promises';
import path from 'node:path';
import os from 'node:os';
import { spawn, spawnSync } from 'node:child_process';
import { randomUUID } from 'node:crypto';
import { read, json, hash } from './files.mjs';

async function executable() {
  const paths = process.env.OOFUI_STUDIO ? [process.env.OOFUI_STUDIO] : process.platform === 'darwin'
    ? ['/Applications/RobloxStudio.app/Contents/MacOS/RobloxStudio'] : [];
  if (process.platform === 'win32' && process.env.LOCALAPPDATA) {
    const versions = path.join(process.env.LOCALAPPDATA, 'Roblox/Versions');
    for (const name of await fs.readdir(versions).catch(() => [])) paths.push(path.join(versions, name, 'RobloxStudioBeta.exe'));
  }
  for (const file of paths.reverse()) if (await fs.access(file).then(() => true, () => false)) return file;
  throw Error('Roblox Studio was not found. Set OOFUI_STUDIO to its executable. Studio runtime proof requires an authenticated Windows or macOS desktop.');
}
function alive(state) {
  if (!state || !Number.isInteger(state.pid) || typeof state.sessionPlace !== 'string') return false;
  const p = process.platform === 'win32' ? spawnSync('powershell', ['-NoProfile', '-Command', `Get-CimInstance Win32_Process -Filter 'ProcessId = ${state.pid}' | Select-Object -ExpandProperty CommandLine`], { encoding: 'utf8' })
    : spawnSync('ps', ['-p', String(state.pid), '-o', 'command='], { encoding: 'utf8' });
  return p.status === 0 && p.stdout.includes(state.sessionPlace) && p.stdout.includes('RobloxStudio');
}
export async function studio(root, action) {
  const stateDir = path.join(process.env.OOFUI_CONFIG_DIR || path.join(os.homedir(), '.config/oofui'), 'studio');
  const statePath = path.join(stateDir, 'session.json');
  const bytes = await read(statePath), state = bytes ? JSON.parse(bytes) : null;
  if (action === 'status') return alive(state) ? { status: 'open', ...state } : { status: 'closed' };
  if (action === 'close') {
    if (alive(state)) {
      if (process.platform === 'win32') spawnSync('taskkill', ['/PID', String(state.pid), '/T', '/F']);
      else {
        process.kill(state.pid, 'SIGTERM');
        for (let i = 0; i < 20 && alive(state); i++) await new Promise(resolve => setTimeout(resolve, 250));
        if (alive(state)) process.kill(state.pid, 'SIGKILL');
      }
    }
    await fs.rm(statePath, { force: true });
    return { status: 'closed' };
  }
  if (action !== 'open') throw Error('Use oofui studio open, status, or close. Save wanted Studio edits before closing the disposable copy.');
  if (alive(state)) throw Error('An owned Studio is already open: ' + state.project + '. Save wanted edits, then oofui studio close.');
  const source = await read(path.join(root, 'build/game.rbxlx'));
  if (!source) throw Error('Run oofui build before opening Studio.');
  const binary = await executable(), session = path.join(stateDir, randomUUID());
  await fs.mkdir(session, { recursive: true });
  const place = path.join(session, 'game.rbxlx'), log = path.join(session, 'studio.log');
  await fs.writeFile(place, source);
  const output = await fs.open(log, 'w');
  const child = spawn(binary, ['--task', 'EditFile', '--localPlaceFile', place], { detached: true, stdio: ['ignore', output.fd, output.fd] });
  await new Promise((resolve, reject) => { child.once('spawn', resolve); child.once('error', reject); });
  await output.close(); child.unref();
  const current = { pid: child.pid, project: root, sessionPlace: place, log, sha256: hash(source) };
  await fs.writeFile(statePath, json(current));
  return { status: 'open', ...current, next: 'Press Play. Inspect the UI and client Output. Save wanted edits before oofui studio close.' };
}
