--!strict
-- oof/ui starter HUD. Press Play in Studio to see it, then make it yours.
--
--   oofui list            every component
--   oofui docs button     props and an example for one component
--   oofui add switch      install more (then require it as Ui.Switch)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Ui = require(ReplicatedStorage.OofUi)
local e = React.createElement

local function Hud(props: { onSwitchTheme: () -> () })
	local xp, setXp = React.useState(40)

	return e(Ui.Container, {
		variant = "raised",
		anchorPoint = Vector2.new(0.5, 1),
		position = UDim2.new(0.5, 0, 1, -24),
		size = UDim2.fromOffset(340, 0),
		contentPadding = UDim.new(0, 16),
	}, {
		Title = e(Ui.Text, { text = "Level 3", variant = "heading", layoutOrder = 1 }),
		Detail = e(Ui.Text, { text = `{xp} / 100 XP`, variant = "subtext", layoutOrder = 2 }),
		Progress = e(Ui.ProgressBar, { value = xp, maximum = 100, layoutOrder = 3 }),
		Actions = e("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			LayoutOrder = 4,
		}, {
			Layout = e("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
			GainXp = e(Ui.Button, {
				text = "Gain XP",
				layoutOrder = 1,
				onActivated = function()
					setXp(function(current)
						return if current >= 100 then 0 else math.min(current + 15, 100)
					end)
				end,
			}),
			SwitchTheme = e(Ui.Button, {
				text = "Switch theme",
				variant = "outline",
				layoutOrder = 2,
				onActivated = props.onSwitchTheme,
			}),
		}),
	})
end

-- Ui.mount creates the ScreenGui, theme and style sheet for you.
local themeIds = Ui.styles.themeIds()
local themeIndex = 1
local ui
ui = Ui.mount(
	e(Hud, {
		onSwitchTheme = function()
			themeIndex = themeIndex % #themeIds + 1
			ui:setTheme(themeIds[themeIndex])
		end,
	}),
	{ theme = themeIds[themeIndex] }
)
