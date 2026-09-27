# React-Luau composition

Use `oofui info --json` for the actual installed components. The CLI maps free
and private source into one `ReplicatedStorage.OofUi` tree for Rojo.

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Ui = require(ReplicatedStorage.OofUi)
local e = React.createElement

local function Hud()
    -- Install with: oofui add container progressbar
    return e(Ui.Container, {
        size = UDim2.fromOffset(300, 0),
        position = UDim2.fromOffset(24, 24),
        contentPadding = UDim.new(0, 12),
    }, {
        Bar = e(Ui.ProgressBar, { value = 65, minimum = 0, maximum = 100 }),
    })
end

-- Creates a correctly configured ScreenGui, theme, style sheet and React root.
local ui = Ui.mount(e(Hud), { theme = "default", name = "GameUI" })
-- ui:render(element)  ui:setTheme(id, overrides?)  ui:unmount()
```

Prefer `Ui.mount`. Mount manually only when the game already owns a ScreenGui:
create it with `ZIndexBehavior = Enum.ZIndexBehavior.Sibling`,
`ScreenInsets = CoreUISafeInsets` and `SafeAreaCompatibility = None`, then render
`e(Ui.styles.StyleProvider, { styleSheet = Ui.styles.createStyleSheet(Ui.styles.createTheme({ theme = "default" })) }, children)`
into a `ReactRoblox.createRoot(gui)`. Destroy the sheet and theme on unmount.

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
