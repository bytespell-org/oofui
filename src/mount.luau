--!strict

-- One-call setup: creates a correctly configured ScreenGui, theme, style sheet,
-- StyleProvider and React root. Use it instead of wiring those by hand.
--
--   local ui = Ui.mount(e(App), { theme = "light" })
--   ui:setTheme("default")
--   ui:render(e(App, { coins = 10 }))
--   ui:unmount()

local Players = game:GetService("Players")
local Dependencies = require(script.Parent.Dependencies)
local StyleProvider = require(script.Parent.styles.StyleProvider)
local StyleSheet = require(script.Parent.styles.StyleSheet)
local Theme = require(script.Parent.styles.Theme)

local React = Dependencies.React
local ReactRoblox = Dependencies.ReactRoblox

export type ThemeInput = string | Theme.Theme
export type Options = {
	-- Theme id ("default", "light", ...) or a descriptor from Ui.styles.themes.
	theme: ThemeInput?,
	-- Token overrides, for example { CnColorAccent = Color3.fromRGB(84, 116, 255) }.
	overrides: Theme.Overrides?,
	-- ScreenGui name. Defaults to "OofUi".
	name: string?,
	displayOrder: number?,
	-- Defaults to the local player's PlayerGui.
	parent: Instance?,
}
export type Handle = {
	screenGui: ScreenGui,
	render: (self: Handle, element: any) -> (),
	setTheme: (self: Handle, theme: ThemeInput, overrides: Theme.Overrides?) -> (),
	unmount: (self: Handle) -> (),
}

local OPTION_KEYS = { theme = true, overrides = true, name = true, displayOrder = true, parent = true }

local function mount(element: any, options: Options?): Handle
	local resolved: Options = options or {}
	for key in resolved :: any do
		assert(OPTION_KEYS[key], string.format("Unknown Ui.mount option %q", tostring(key)))
	end

	local parent = resolved.parent
	if parent == nil then
		local player = Players.LocalPlayer
		assert(player ~= nil, "Ui.mount runs in a LocalScript; pass options.parent elsewhere")
		parent = player:WaitForChild("PlayerGui")
	end

	-- These settings are required for correct layering and safe areas; see README.
	local screen = Instance.new("ScreenGui")
	screen.Name = resolved.name or "OofUi"
	screen.ResetOnSpawn = false
	screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screen.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets
	screen.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
	screen.DisplayOrder = resolved.displayOrder or 0
	screen.Parent = parent

	local root = ReactRoblox.createRoot(screen)
	local theme: StyleSheet? = nil
	local sheet: StyleSheet? = nil
	local current = element
	local mounted = true

	-- React commits asynchronously, so the previous generation stays alive until
	-- the next change. Destroying it immediately could flash unstyled controls.
	local retired: { StyleSheet } = {}
	local function retire(instance: StyleSheet?)
		if instance then
			table.insert(retired, instance)
		end
	end
	local function destroyRetired()
		for _, instance in retired do
			instance:Destroy()
		end
		table.clear(retired)
	end

	local function draw()
		root:render(React.createElement(StyleProvider, { styleSheet = sheet }, { App = current }))
	end

	local handle = { screenGui = screen }

	function handle.setTheme(_self: Handle, input: ThemeInput, overrides: Theme.Overrides?)
		assert(mounted, "oof/ui root was unmounted")
		destroyRetired()
		retire(sheet)
		retire(theme)
		theme = Theme.create({ theme = input, overrides = overrides })
		sheet = StyleSheet.create(theme)
		draw()
	end

	function handle.render(_self: Handle, nextElement: any)
		assert(mounted, "oof/ui root was unmounted")
		current = nextElement
		draw()
	end

	function handle.unmount(_self: Handle)
		if not mounted then
			return
		end
		mounted = false
		root:unmount()
		retire(sheet)
		retire(theme)
		destroyRetired()
		screen:Destroy()
	end

	handle.setTheme(handle :: any, resolved.theme or Theme.defaultTheme, resolved.overrides)
	return (handle :: any) :: Handle
end

return mount
