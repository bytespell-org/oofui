import fs from 'node:fs/promises';
import embedded from './embedded.mjs';

const root = new URL('../', import.meta.url);
export async function asset(name) {
  if (embedded) {
    if (!Object.hasOwn(embedded, name)) throw Error('Missing bundled asset: ' + name);
    return Buffer.from(embedded[name], 'base64');
  }
  return fs.readFile(new URL(name, root));
}
export async function assetNames(prefix) {
  if (embedded) return Object.keys(embedded).filter(name => name.startsWith(prefix));
  // Enumerate with explicit relative paths on both Node and Bun.
  const result = [];
  async function visit(directory) {
    for (const file of await fs.readdir(new URL(directory, root), { withFileTypes: true })) {
      const name = directory + file.name;
      if (file.isDirectory()) await visit(name + '/');
      else if (file.isFile()) result.push(name);
    }
  }
  await visit(prefix);
  return result;
}
