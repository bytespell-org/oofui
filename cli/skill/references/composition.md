# React-Luau composition

Use `oofui info --json` for the actual installed components. The CLI maps free
and private source into one `ReplicatedStorage.OofUi` tree for Rojo.

```lua
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local Ui = require(ReplicatedStorage.OofUi)
local e = React.createElement

local gui = Instance.new("ScreenGui")
gui.Name = "GameUI"
gui.ResetOnSpawn = false
gui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets
gui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local theme = Ui.styles.createTheme({ theme = Ui.styles.themes.default })
local sheet = Ui.styles.createStyleSheet(theme)
local root = ReactRoblox.createRoot(gui)
root:render(e(Ui.styles.StyleProvider, { styleSheet = sheet }, {
    -- Install with: oofui add container progressbar
    Progress = e(Ui.Container, {
        size = UDim2.fromOffset(300, 64),
        automaticSize = Enum.AutomaticSize.None,
        position = UDim2.fromOffset(24, 24),
    }, {
        Bar = e(Ui.ProgressBar, { value = 65, minimum = 0, maximum = 100 }),
    }),
}))
```

For a Pro Plus inventory, install `oofui kit add inventory`, inspect
`oofui view inventory` and the installed `.oofui/private/kits/types.luau`, then
compose `e(Ui.kits.Inventory, { items = ..., capacity = ..., onItemAction = ... })`.
The component handles search, categories, selection and narrow navigation.
Pass item art as `image` or `renderPreview`; use application-owned models for
ViewportFrames. Inventory actions should request a server change and render the
server's resulting state. A controlled `selectedId` is selection, not ownership.

Read each component's supported props before setting sizes. `ProgressBar` sizes
come from theme rules, so place it in a Container or layout. A plain Frame's
native props use `Size` and `Position`; a library Container uses `size` and
`position`. Never put `StyleProvider` directly under PlayerGui.
