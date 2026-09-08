// Refresh the public CLI's vendored Core after editing src/. Paid payloads are
// absent from this repository and must never be fetched by a public build.
import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { createHash } from 'node:crypto';
const root=fileURLToPath(new URL('../',import.meta.url));
const registry=path.join(root,'cli/registry');
const index=JSON.parse(await fs.readFile(path.join(registry,'index.json')));
const manifest=await fs.readFile(path.join(root,'wally.toml'),'utf8');
const allowed=new Set([...manifest.split('include = [')[1].split(']')[0].matchAll(/"([^"]+)"/g)].map(match=>match[1]));
for(const item of index.items.filter(item=>item.tier==='free')) {
 const file=path.join(registry,item.id+'.json');
 const bundle=JSON.parse(await fs.readFile(file));
 if(bundle.id!==item.id || bundle.tier!=='free') throw Error('Invalid public registry metadata');
 for(const entry of bundle.files) {
  const source='src/'+entry.path.replace(/(^|\/)entry\.luau$/,'$1init.luau');
  if(!allowed.has(source)) throw Error('Unapproved public source: '+source);
  const bytes=await fs.readFile(path.join(root,source));
  entry.content=bytes.toString('base64');
  entry.sha256=createHash('sha256').update(bytes).digest('hex');
 }
 await fs.writeFile(file,JSON.stringify(bundle,null,2)+'\n');
}
console.log('Refreshed the public CLI from approved Core source.');
