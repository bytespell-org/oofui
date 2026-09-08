import fs from 'node:fs/promises';
import path from 'node:path';
import { createHash, randomUUID } from 'node:crypto';

export const hash = bytes => createHash('sha256').update(bytes).digest('hex');
export const json = value => JSON.stringify(value, null, 2) + '\n';
export async function read(file) {
  try { return await fs.readFile(file); } catch (error) { if (error.code === 'ENOENT') return null; throw error; }
}
export function relativeName(name) {
  if (typeof name !== 'string' || !name || name.includes('\\') || name.includes(':') || /[\x00-\x1f\x7f]/.test(name) || path.posix.isAbsolute(name)
      || name.split('/').some(part => !part || part === '.' || part === '..') || name.split('/').some(part => part.toLowerCase() === '.git' || part.endsWith('.') || part.endsWith(' '))) {
    throw Error('Unsafe project path: ' + name);
  }
  return name;
}
export async function destination(root, name) {
  relativeName(name);
  let current = root;
  for (const part of name.split('/')) {
    current = path.join(current, part);
    try { if ((await fs.lstat(current)).isSymbolicLink()) throw Error('Refusing symlink: ' + name); }
    catch (error) { if (error.code !== 'ENOENT') throw error; }
  }
  return current;
}
async function replace(target, bytes) {
  const temporary = path.join(path.dirname(target), '.oofui-' + randomUUID() + '.tmp');
  try {
    await fs.writeFile(temporary, bytes, { flag: 'wx' });
    await fs.rename(temporary, target);
  } finally { await fs.rm(temporary, { force: true }); }
}

// Validate every write first. Never partially install a component over a conflict.
export async function apply(root, writes, { dryRun = false, overwrite = false, managed = {} } = {}) {
  const plan = [];
  for (const [name, value] of [...writes].sort(([a], [b]) => a.localeCompare(b))) {
    const target = await destination(root, name), next = Buffer.from(value), previous = await read(target);
    if (previous?.equals(next)) continue;
    if (previous && !overwrite && managed[name] !== hash(previous)) throw Error('Local changes in ' + name + '. Review them before using --overwrite. No files changed.');
    plan.push({ name, target, next, previous });
  }
  if (!dryRun) {
    const done = [];
    try {
      for (const change of plan) {
        await fs.mkdir(path.dirname(change.target), { recursive: true });
        await replace(change.target, change.next);
        done.push(change);
      }
    } catch (error) {
      for (const change of done.reverse()) {
        if (change.previous) await replace(change.target, change.previous);
        else await fs.unlink(change.target);
      }
      throw error;
    }
  }
  return plan.map(p => ({ path: p.name, action: p.previous ? 'update' : 'create', bytes: p.next.length }));
}
