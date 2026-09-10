import fs from 'node:fs/promises';
import path from 'node:path';
import os from 'node:os';
import { hash, relativeName, json, read } from './files.mjs';

export const packageRoot = new URL('../', import.meta.url);
export const index = JSON.parse(await fs.readFile(new URL('registry/index.json', packageRoot), 'utf8'));
export const normalize = name => name.toLowerCase().replace(/[-_ ]/g, '');
export function findItem(name) {
  const item = index.items.find(i => normalize(i.id) === normalize(name));
  if (!item) throw Error('Unknown item ' + name + '. Run oofui list to see available items.');
  return item;
}
export function origin(value) {
  const url = new URL(value);
  if (url.username || url.password || url.search || url.hash || url.pathname !== '/') throw Error('Use an origin without credentials, paths, query, or fragment.');
  if (url.protocol !== 'https:' && !(url.protocol === 'http:' && ['localhost', '127.0.0.1', '[::1]'].includes(url.hostname))) throw Error('Registry credentials require HTTPS (loopback is allowed for local testing).');
  return url.origin;
}
const authDir = () => process.env.OOFUI_CONFIG_DIR || path.join(os.homedir(), '.config/oofui');
export const authFile = () => path.join(authDir(), 'auth.json');
export async function credentials() { const bytes = await read(authFile()); return bytes ? JSON.parse(bytes) : null; }
export async function request(url, token) {
  const response = await fetch(url, { headers: { Authorization: 'Bearer ' + token }, redirect: 'error', signal: AbortSignal.timeout(30000) });
  if (!response.ok) throw Error(response.status === 401 || response.status === 403 ? 'This purchase does not include this item, or access was revoked. Run oofui auth login or check your purchase.' : `Registry request failed (${response.status}).`);
  const chunks = []; let size = 0;
  for await (const chunk of response.body) {
    size += chunk.length;
    if (size > 48 * 1024 * 1024) throw Error('Registry response exceeds the 48 MB limit.');
    chunks.push(chunk);
  }
  return JSON.parse(Buffer.concat(chunks));
}
export async function login(value, token) {
  const registry = origin(value);
  if (!/^[a-f0-9]{64}$/.test(token)) throw Error('Enter the 64-character purchase access code.');
  const account = await request(registry + '/api/cli/account', token);
  if (!['oof-ui-pro', 'oof-ui-pro-plus'].includes(account.productId)) throw Error('Invalid entitlement response.');
  await fs.mkdir(authDir(), { recursive: true, mode: 0o700 });
  await fs.writeFile(authFile(), json({ origin: registry, token }), { mode: 0o600 });
  await fs.chmod(authFile(), 0o600);
  return { origin: registry, productId: account.productId };
}
export async function logout() { await fs.rm(authFile(), { force: true }); }
export function purchaseRequired(item) {
  const edition = item.tier === 'pro-plus' ? 'Pro Plus' : 'Pro';
  return `${item.module || item.id} requires ${edition}. Get access at https://oofui.bytespell.com/#/pro. If you already purchased, run oofui auth login --origin https://oofui.bytespell.com --token-stdin and supply your saved access code on stdin.`;
}
export async function loadItem(item, configuredOrigin) {
  let bundle;
  if (item.tier === 'free') bundle = JSON.parse(await fs.readFile(new URL('registry/' + item.id + '.json', packageRoot), 'utf8'));
  else {
    const auth = await credentials();
    if (!auth) throw Error(purchaseRequired(item));
    const expected = configuredOrigin ? origin(configuredOrigin) : auth.origin;
    if (auth.origin !== expected) throw Error('The project registry differs from the saved account. Authenticate that origin explicitly.');
    bundle = await request(expected + '/api/cli/registry/' + index.version + '/' + item.id, auth.token);
  }
  if (bundle.schemaVersion !== 1 || bundle.version !== index.version || bundle.id !== item.id || bundle.tier !== item.tier
      || JSON.stringify(bundle.dependencies) !== JSON.stringify(item.dependencies) || !Array.isArray(bundle.files) || bundle.files.length > 400) throw Error('Invalid or incompatible registry item: ' + item.id);
  const names = new Set();
  for (const file of bundle.files) {
    relativeName(file.path);
    if (names.has(file.path) || file.encoding !== 'base64' || typeof file.content !== 'string') throw Error('Invalid registry file');
    names.add(file.path);
    if (hash(Buffer.from(file.content, 'base64')) !== file.sha256) throw Error('Registry checksum mismatch: ' + file.path);
    if (item.tier === 'free' && (file.path.startsWith('kits/') || file.path.startsWith('assets/') || /presets\/(adventure|bloom|circuit|grove|arcade|obsidian|tide|ember)\.luau$/.test(file.path))) throw Error('Paid content in public registry');
  }
  return bundle;
}
export function closure(names) {
  const resolved = new Map(), visiting = new Set();
  function visit(name) {
    const item = findItem(name);
    if (resolved.has(item.id)) return;
    if (visiting.has(item.id)) throw Error('Cyclic registry dependency: ' + name);
    visiting.add(item.id);
    item.dependencies.forEach(visit);
    visiting.delete(item.id); resolved.set(item.id, item);
  }
  names.forEach(visit);
  return [...resolved.values()];
}
