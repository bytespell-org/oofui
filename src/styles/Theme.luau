--!strict

export type Overrides = { [string]: any }
export type Preset = {
	id: string,
	label: string,
	tier: string,
}
export type Theme = Preset
export type Options = {
	theme: Theme?,
	preset: Preset?,
	overrides: Overrides?,
}

type PresetData = {
	preset: Preset,
	tokens: Overrides,
}

local registry = require(script.Parent.presets.registry)
local shared = require(script.Parent.SharedTokens)
local presetDataById: { [string]: PresetData } = {}
local descriptors: { [string]: Preset } = {}
local ids: { string } = {}

for _, entry in registry.themes do
	assert(type(entry.id) == "string" and string.match(entry.id, "^[a-z][a-z0-9%-]*$"), "Invalid preset id")
	assert(descriptors[entry.id] == nil, "Duplicate preset " .. entry.id)
	assert(type(entry.label) == "string" and entry.label ~= "", "Preset needs a label")
	local module = script.Parent.presets:FindFirstChild(entry.id)
	-- The free distribution omits Pro modules; previews and the Pro archive install them.
	assert(entry.tier == "free" or entry.tier == "pro", "Invalid theme tier " .. entry.id)
	if module == nil and entry.tier == "pro" then
		continue
	end
	assert(module ~= nil and module:IsA("ModuleScript"), "Missing preset module " .. entry.id)
	local descriptor = table.freeze({ id = entry.id, label = entry.label, tier = entry.tier })
	local tokens = table.clone(shared)
	for key, value in require(module) do
		tokens[key] = value
	end
	descriptors[entry.id] = descriptor
	table.insert(ids, entry.id)
	presetDataById[entry.id] = { preset = descriptor, tokens = tokens }
end
assert(descriptors[registry.defaultTheme] ~= nil, "Unknown default preset")
local defaultPreset = descriptors[registry.defaultTheme]
local Theme = {
	themes = table.freeze(descriptors),
	defaultTheme = defaultPreset,
	presets = descriptors,
	defaultPreset = defaultPreset,
}

local function resolvePreset(preset: any): PresetData
	assert(type(preset) == "table", "oof-ui theme preset must be a preset descriptor")
	local data = presetDataById[preset.id]
	assert(data ~= nil, string.format("Unknown oof-ui preset %q", tostring(preset.id)))
	return data
end

local canonicalTokens = presetDataById.default.tokens
for _, preset in presetDataById do
	for key, canonicalValue in canonicalTokens do
		local value = preset.tokens[key]
		assert(value ~= nil, string.format("Preset %s is missing token %s", preset.preset.id, key))
		assert(
			typeof(value) == typeof(canonicalValue),
			string.format("Preset %s token %s differs from the canonical type", preset.preset.id, key)
		)
	end
	for key in preset.tokens do
		assert(canonicalTokens[key] ~= nil, string.format("Preset %s has unknown token %s", preset.preset.id, key))
	end
end

local function resolve(options: Options?): (PresetData, Overrides?)
	local resolved = options or {
		preset = defaultPreset,
	}
	assert(type(resolved) == "table", "oof-ui theme options must be a table")
	for key in resolved do
		assert(
			key == "theme" or key == "preset" or key == "overrides",
			string.format("Unknown oof-ui theme option %q", tostring(key))
		)
	end
	assert(resolved.theme == nil or resolved.preset == nil, "Use theme or the legacy preset option, not both")
	return resolvePreset(resolved.theme or resolved.preset or defaultPreset), resolved.overrides
end

function Theme.create(options: Options?): StyleSheet
	local preset, overrides = resolve(options)
	local defaults = table.clone(preset.tokens)
	local theme = Instance.new("StyleSheet")
	theme.Name = "OofUiPrimitivesTheme_" .. preset.preset.id
	theme:SetAttribute("OofUiThemeId", preset.preset.id)
	theme:SetAttribute("OofUiPresetId", preset.preset.id)
	for key, value in overrides or {} do
		local defaultValue = defaults[key]
		assert(defaultValue ~= nil, string.format("Unknown oof-ui theme token %q", key))
		assert(
			typeof(value) == typeof(defaultValue),
			string.format("Theme token %s expects %s, received %s", key, typeof(defaultValue), typeof(value))
		)
		defaults[key] = value
	end
	for key, value in defaults do
		theme:SetAttribute(key, value)
	end
	return theme
end

function Theme.defaults(options: Options?): Overrides
	local preset, overrides = resolve(options)
	assert(overrides == nil, "defaultThemeTokens does not accept token overrides")
	return table.clone(preset.tokens)
end

function Theme.presetIds(): { string }
	return table.clone(ids)
end

Theme.themeIds = Theme.presetIds

return Theme
