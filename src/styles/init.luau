--!strict

local Theme = require(script.Theme)

return {
	createTheme = Theme.create,
	defaultThemeTokens = Theme.defaults,
	themes = Theme.themes,
	defaultTheme = Theme.defaultTheme,
	themeIds = Theme.themeIds,
	-- Compatibility with applications using the original preset API.
	presets = Theme.presets,
	defaultPreset = Theme.defaultPreset,
	presetIds = Theme.presetIds,
	createStyleSheet = require(script.StyleSheet).create,
	StyleProvider = require(script.StyleProvider),
}
