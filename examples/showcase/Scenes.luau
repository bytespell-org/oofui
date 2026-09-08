--!strict
-- One theme/world pairing drives the live demo and native screenshot fixture.
local registry = require(game:GetService("ReplicatedStorage").OofUiPrimitives.styles.presets.registry)
local worlds = require(script.Parent.worlds)
local byTheme: { [string]: string } = {}
local proWorlds: { [string]: boolean } = {}
for _, theme in registry.themes do
	assert(worlds[theme.heroScene] ~= nil, "Theme needs a registered showcase world: " .. theme.id)
	if theme.tier == "pro" then
		assert(not proWorlds[theme.heroScene], "Each Pro theme needs its own showcase world")
		proWorlds[theme.heroScene] = true
	end
	byTheme[theme.id] = theme.heroScene
end
local Scenes = { worlds = worlds }
function Scenes.worldForTheme(themeId: string): string
	local scene = byTheme[themeId]
	assert(scene ~= nil, "Unknown showcase theme: " .. themeId)
	return scene
end
return Scenes
