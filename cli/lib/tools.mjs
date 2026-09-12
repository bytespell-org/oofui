import fs from 'node:fs';
import fsp from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import releases from './tool-releases.json' with { type: 'json' };

export const installRoot = () => process.env.OOFUI_HOME || (process.platform === 'win32'
  ? path.join(process.env.LOCALAPPDATA || os.homedir(), 'oofui') : path.join(os.homedir(), '.local/share/oofui'));
const digest = bytes => createHash('sha256').update(bytes).digest('hex');
const platform = () => process.platform + '-' + process.arch;
function record(tool) {
  const release = releases[tool], target = release?.targets[platform()];
  if (!target) throw Error(`Automatic ${tool} setup is unavailable on ${platform()}. Install ${tool} ${release?.version} on PATH.`);
  return { ...target, version: release.version, directory: path.join(installRoot(), 'tools', `${tool}-${release.version}-${platform()}`) };
}
function probe(binary, cwd) {
  const result = spawnSync(binary, ['--version'], { cwd, encoding: 'utf8', timeout: 15000, windowsHide: true });
  return result.status === 0 ? result.stdout.trim() : null;
}
export function resolveTool(tool, cwd = process.cwd()) {
  const existing = probe(tool, cwd), required = releases[tool].version;
  // Respect project-specific Rokit shims, but do not silently use untested versions.
  if (existing?.match(/\d+\.\d+\.\d+/)?.[0] === required) return { path: tool, version: existing, managed: false };
  const r = record(tool), binary = path.join(r.directory, r.executable);
  if (fs.existsSync(binary) && digest(fs.readFileSync(binary)) === r.binarySha256) {
    const version = probe(binary, cwd);
    if (version?.match(/\d+\.\d+\.\d+/)?.[0] === required) return { path: binary, version, managed: true };
  }
  throw Error(`${tool} ${required} is missing or incompatible. Run oofui setup --yes.${r.requiresRosetta ? ' The upstream Wally build requires Rosetta on Apple silicon.' : ''}`);
}
export function toolStatus(cwd) {
  return Object.fromEntries(Object.keys(releases).map(tool => {
    try { return [tool, { available: true, ...resolveTool(tool, cwd) }]; }
    catch (error) { return [tool, { available: false, error: error.message }]; }
  }));
}
export async function setupTools(cwd, yes) {
  const status = toolStatus(cwd), missing = Object.keys(status).filter(tool => !status[tool].available);
  if (!missing.length) return { tools: status };
  if (!yes) return { tools: status, next: 'Run oofui setup --yes to download checksum-verified Rojo and Wally into your user directory.' };
  const root = installRoot(), marker = path.join(root, '.oofui-install');
  if (fs.existsSync(root) && !fs.existsSync(marker)) throw Error('Refusing an unrecognized tool installation directory: ' + root);
  if (fs.existsSync(marker) && fs.readFileSync(marker, 'utf8').trim() !== 'oofui-installer-v1') throw Error('Invalid installation marker.');
  await fsp.mkdir(root, { recursive: true });
  await fsp.writeFile(marker, 'oofui-installer-v1\n');
  for (const tool of missing) {
    const r = record(tool), parent = path.dirname(r.directory);
    await fsp.mkdir(parent, { recursive: true });
    const stage = await fsp.mkdtemp(path.join(parent, '.download-'));
    try {
      const response = await fetch(r.url, { signal: AbortSignal.timeout(120000) });
      if (!response.ok) throw Error(`${tool} download failed (${response.status}).`);
      const chunks = []; let size = 0;
      for await (const chunk of response.body) {
        size += chunk.length;
        if (size > 64 * 1024 * 1024) throw Error('Tool archive exceeds size limit.');
        chunks.push(chunk);
      }
      const data = Buffer.concat(chunks);
      if (digest(data) !== r.sha256) throw Error(`${tool} archive checksum mismatch.`);
      const archive = path.join(stage, 'tool.zip');
      await fsp.writeFile(archive, data);
      const extracted = path.join(stage, 'extracted');
      await fsp.mkdir(extracted);
      // Only authenticated, pinned upstream archives reach the native extractor.
      const result = process.platform === 'win32'
        ? spawnSync('powershell.exe', ['-NoProfile', '-NonInteractive', '-Command', 'Add-Type -AssemblyName System.IO.Compression.FileSystem; [IO.Compression.ZipFile]::ExtractToDirectory($env:OOFUI_TOOL_ARCHIVE, $env:OOFUI_TOOL_DEST)'], { env: { ...process.env, OOFUI_TOOL_ARCHIVE: archive, OOFUI_TOOL_DEST: extracted }, encoding: 'utf8', timeout: 30000, windowsHide: true })
        : spawnSync('unzip', ['-q', archive, r.executable, '-d', extracted], { encoding: 'utf8', timeout: 30000 });
      if (result.status !== 0) throw Error('Could not extract ' + tool + ': ' + (result.error?.message || result.stderr));
      const binary = path.join(extracted, r.executable);
      if (digest(await fsp.readFile(binary)) !== r.binarySha256) throw Error(`${tool} executable checksum mismatch.`);
      await fsp.chmod(binary, 0o755);
      if (!probe(binary, cwd)) throw Error(`${tool} could not run.${r.requiresRosetta ? ' Install Apple Rosetta, then rerun oofui setup --yes.' : ''}`);
      // Never replace a directory belonging to a different installation.
      try { await fsp.rename(extracted, r.directory); }
      catch (error) {
        if (!['EEXIST', 'ENOTEMPTY'].includes(error.code)) throw error;
        resolveTool(tool, cwd); // A concurrent install must be valid; corruption is not overwritten.
      }
    } finally { await fsp.rm(stage, { recursive: true, force: true }); }
  }
  return { tools: toolStatus(cwd) };
}
