import { findItem, loadItem } from './registry.mjs';

const site = 'https://oofui.bytespell.com/#/';
const decode = file => Buffer.from(file.content, 'base64').toString();

// Single-line string unions such as `export type Variant = "a" | "b"`.
function unions(source) {
  const result = {};
  for (const [, name, value] of source.matchAll(/^(?:export )?type (\w+) =\s*("[^\n]+)$/gm)) result[name] = value.trim();
  return result;
}
function propsOf(source, aliases) {
  const match = source.match(/^export type Props = ([^{\n]*)\{\n([\s\S]*?)\n\}/m);
  if (!match) return null;
  const props = [], common = [];
  if (/CommonControlProps/.test(match[1])) {
    common.push({ name: 'disabled', type: 'boolean?' }, { name: 'layoutOrder', type: 'number?' },
      { name: 'selectionOrder', type: 'number?' }, { name: 'tag', type: 'string?' }, { name: 'rootRef', type: 'any?' });
  }
  for (const line of match[2].split('\n')) {
    const field = line.trim().match(/^(\w+):\s*(.+?),?$/);
    if (!field) continue;
    const [, name, raw] = field;
    const optional = raw.endsWith('?');
    const base = raw.replace(/\?$/, '').replace(/^Types\./, '');
    const expanded = aliases[base] ? aliases[base] + (optional ? '  (optional)' : '') : raw;
    props.push({ name, type: expanded, required: !optional });
  }
  // Component-specific props first; shared control props last.
  return [...props, ...common.filter(c => !props.some(p => p.name === c.name))];
}

export function reference(item) {
  return site + (item.kind === 'kit' ? 'kits/' + item.id : item.kind === 'theme' ? 'themes?section=' + item.id : 'components/' + item.id);
}
export function usage(item) {
  if (item.example) return item.example;
  if (item.kind === 'kit') return `e(Ui.kits.${item.module}, props)`;
  if (item.kind === 'theme') return `Ui.mount(e(App), { theme = "${item.id}" })`;
  return `e(Ui.${item.module}, props)`;
}

export async function docs(name, installed = []) {
  const item = findItem(name);
  const result = {
    ...item, files: undefined, add: 'oofui add ' + item.id, api: 'oofui view ' + item.id,
    usage: usage(item), reference: reference(item), installed: installed.includes(item.id), props: null,
    guidance: 'Props are lowercase; native Roblox instance props keep Roblox casing. Mount with Ui.mount, or put StyleProvider inside a ScreenGui with ZIndexBehavior = Sibling. Paid kits emit intent callbacks; validate ownership, currency and rewards on the server.',
  };
  if (item.kind === 'component' && item.tier === 'free') {
    const bundle = await loadItem(item);
    const base = await loadItem(findItem('_base'));
    const file = bundle.files.find(f => f.path === `components/${item.module}.luau`);
    const shared = base.files.find(f => f.path === 'types.luau');
    if (file) {
      const source = decode(file);
      result.props = propsOf(source, { ...unions(shared ? decode(shared) : ''), ...unions(source) });
    }
  }
  return result;
}

export function formatDocs(result) {
  const tier = result.tier === 'free' ? 'free' : result.tier === 'pro-plus' ? 'Pro Plus' : 'Pro';
  const lines = [`${result.module || result.id} · ${tier} ${result.kind}`, result.description, ''];
  lines.push('Example', ...result.usage.split('\n').map(l => '  ' + l.replace(/\t/g, '  ')), '');
  if (result.props) {
    const width = Math.max(...result.props.map(p => p.name.length));
    lines.push('Props');
    for (const p of result.props) lines.push(`  ${p.name.padEnd(width)}  ${p.type}${p.required ? '  (required)' : ''}`);
    lines.push('');
  }
  const use = result.kind === 'theme' ? `theme = "${result.id}"` : result.kind === 'kit' ? `Ui.kits.${result.module}` : `Ui.${result.module}`;
  lines.push(result.installed ? `Installed. Use it as ${use}.` : `Install:   ${result.add}`);
  lines.push(`Source:    ${result.api}`, `Reference: ${result.reference}`);
  return lines.join('\n');
}
