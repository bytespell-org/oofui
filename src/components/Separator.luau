--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)
local Tags = require(script.Parent.Parent.internal.Tags)
local Types = require(script.Parent.Parent.types)

local React = Dependencies.React
local e = React.createElement

export type Props = {
	orientation: Types.Orientation?,
	layoutOrder: number?,
	tag: string?,
	rootRef: any?,
}

local function Separator(props: Props): any
	local orientation = props.orientation or "horizontal"

	return e("Frame", {
		[React.Tag] = Tags.join("oof-ui-separator", "oof-ui-separator-" .. orientation, props.tag),
		ref = props.rootRef,
		LayoutOrder = props.layoutOrder,
	}, {
		Track = e("Frame", { [React.Tag] = "oof-ui-separator-track" }, {
			Gradient = e("UIGradient", { [React.Tag] = "oof-ui-separator-track-gradient" }),
		}),
		Highlight = e("Frame", { [React.Tag] = "oof-ui-separator-highlight" }, {
			Gradient = e("UIGradient", { [React.Tag] = "oof-ui-separator-highlight-gradient" }),
		}),
		Ornament = e("Frame", { [React.Tag] = "oof-ui-separator-ornament" }, {
			Corner = e("UICorner", { [React.Tag] = "oof-ui-separator-ornament-corner" }),
			Stroke = e("UIStroke", { [React.Tag] = "oof-ui-separator-ornament-stroke" }),
			Gem = e("Frame", { [React.Tag] = "oof-ui-separator-ornament-gem" }, {
				Corner = e("UICorner", { [React.Tag] = "oof-ui-separator-ornament-gem-corner" }),
			}),
		}),
	})
end

return Separator
