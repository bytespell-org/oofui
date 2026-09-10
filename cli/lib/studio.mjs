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
function ownedProcess(state) {
  if (!state || !Number.isInteger(state.pid) || typeof state.sessionPlace !== 'string') return null;
  // Studio's updater can replace the launcher PID. The unique disposable place,
  // together with the executable name, identifies the session across a relaunch.
  const place = new RegExp('(?:^|[\\s"])' + state.sessionPlace.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + '(?:[\\s"]|$)');
  if (process.platform === 'win32') {
    const p = spawnSync('powershell', ['-NoProfile', '-Command', "Get-CimInstance Win32_Process -Filter \"Name = 'RobloxStudioBeta.exe' OR Name = 'RobloxStudio.exe'\" | Select-Object ProcessId,CommandLine | ConvertTo-Json -Compress"], { encoding: 'utf8', timeout: 15000 });
    if (p.status !== 0) throw Error('Could not inspect Studio processes. The owned session record was preserved.');
    const rows = p.stdout.trim() ? JSON.parse(p.stdout) : [];
    const match = [rows].flat().find(row => Number.isInteger(row.ProcessId) && place.test(row.CommandLine || ''));
    return match ? { ...state, pid: match.ProcessId } : null;
  }
  const p = spawnSync('ps', ['-ww', '-axo', 'pid=,command='], { encoding: 'utf8', timeout: 15000 });
  if (p.status !== 0) throw Error('Could not inspect Studio processes. The owned session record was preserved.');
  for (const line of p.stdout.split('\n')) {
    const row = line.trim().match(/^(\d+)\s+(.+)$/);
    if (!row || !place.test(row[2])) continue;
    const pid = Number(row[1]);
    const binary = spawnSync('ps', ['-p', String(pid), '-o', 'comm='], { encoding: 'utf8', timeout: 15000 });
    if (binary.status === 0 && /^RobloxStudio(?:Beta)?$/.test(path.basename(binary.stdout.trim()))) return { ...state, pid };
  }
  return null;
}
export async function studio(root, action) {
  const stateDir = path.join(process.env.OOFUI_CONFIG_DIR || path.join(os.homedir(), '.config/oofui'), 'studio');
  const statePath = path.join(stateDir, 'session.json');
  const bytes = await read(statePath), recorded = bytes ? JSON.parse(bytes) : null;
  const state = ownedProcess(recorded);
  if (state && state.pid !== recorded.pid) await fs.writeFile(statePath, json(state));
  if (action === 'status') return state ? { status: 'open', ...state } : { status: 'closed' };
  if (action === 'close') {
    if (state) {
      if (process.platform === 'win32') spawnSync('taskkill', ['/PID', String(state.pid), '/T', '/F']);
      else {
        process.kill(state.pid, 'SIGTERM');
        for (let i = 0; i < 20 && ownedProcess(state); i++) await new Promise(resolve => setTimeout(resolve, 250));
        const remaining = ownedProcess(state);
        if (remaining) process.kill(remaining.pid, 'SIGKILL');
      }
      for (let i = 0; i < 20 && ownedProcess(state); i++) await new Promise(resolve => setTimeout(resolve, 100));
      if (ownedProcess(state)) throw Error('Studio is still running. The owned session record was preserved; try oofui studio close again.');
    }
    await fs.rm(statePath, { force: true });
    return { status: 'closed' };
  }
  if (action !== 'open') throw Error('Use oofui studio open, status, or close. Save wanted Studio edits before closing the disposable copy.');
  if (state) throw Error('An owned Studio is already open: ' + state.project + '. Save wanted edits, then oofui studio close.');
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
