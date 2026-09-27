// Human-readable output. Every command still returns structured data with --json.

const groups = [
  ['component', 'free', 'Components (free, MIT)'],
  ['theme', 'free', 'Themes (free)'],
  ['theme', 'pro', 'Pro themes (paid)'],
  ['kit', 'pro-plus', 'Pro Plus game kits (paid)'],
];

export function formatList(items, installed = []) {
  if (!items.length) return 'No matches. Run oofui list to see everything.';
  const width = Math.max(...items.map(i => i.id.length)) + 2;
  const lines = [];
  for (const [kind, tier, title] of groups) {
    const group = items.filter(i => i.kind === kind && i.tier === tier).sort((a, b) => a.id.localeCompare(b.id));
    if (!group.length) continue;
    lines.push(title);
    for (const item of group) lines.push(`  ${installed.includes(item.id) ? '✓' : ' '} ${item.id.padEnd(width)}${item.description}`);
    lines.push('');
  }
  lines.push('✓ installed · oofui docs <name> for props and an example · oofui add <names...> to install');
  return lines.join('\n');
}

export function formatDoctor(result) {
  const lines = [];
  for (const [name, tool] of Object.entries(result.tools)) {
    lines.push(tool.available ? `  ok   ${name.padEnd(7)} ${tool.version}${tool.managed ? ' (managed by oofui)' : ''}` : `  miss ${name.padEnd(7)} ${tool.error}`);
  }
  lines.push(result.studioPath ? `  ok   studio  ${result.studioPath}` : '  miss studio  Roblox Studio not found. Install it, or set OOFUI_STUDIO to its executable.');
  if (result.studio.status === 'open') lines.push(`       an oofui Studio session is open for ${result.studio.project}`);
  const missingTools = Object.values(result.tools).some(t => !t.available);
  lines.push('', missingTools ? 'Run oofui setup --yes to install the missing tools.' : 'Ready to build.');
  return lines.join('\n');
}

export function formatInit(result) {
  const lines = [`Initialized. ${result.changes.length} files written.`];
  if (result.installed?.length) lines.push('Installed: ' + result.installed.join(', '));
  if (result.created && result.installed?.length) {
    lines.push('', 'Starter HUD: src/client/init.client.luau', '', 'Next:', '  oofui build', '  oofui studio open    then press Play', '',
      'Or live-sync with oofui dev and the Rojo Studio plugin.');
  } else lines.push('', 'Next: ' + result.next);
  lines.push('Agent skill: .agents/skills/oofui/SKILL.md');
  return lines.join('\n');
}

export function formatAdd(result) {
  if (!result.changes.length) return 'Already up to date.';
  const modules = result.modules?.length ? '\nUse: ' + result.modules.map(m => 'Ui.' + m).join(', ') + '   (local Ui = require(ReplicatedStorage.OofUi))' : '';
  const what = result.added.length ? 'Added ' + result.added.join(', ') : 'Updated ' + result.installed.join(', ');
  return `${what}. ${result.changes.length} files written.${modules}\nProps and examples: oofui docs <name>`;
}
