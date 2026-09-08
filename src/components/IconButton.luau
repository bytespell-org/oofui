--!strict

local ButtonBadge = require(script.Parent.Parent.internal.ButtonBadge)
local ControlChrome = require(script.Parent.Parent.internal.ControlChrome)
local Dependencies = require(script.Parent.Parent.Dependencies)
local Icon = require(script.Parent.Parent.internal.Icon)
local Tags = require(script.Parent.Parent.internal.Tags)
local Text = require(script.Parent.Text)
local Types = require(script.Parent.Parent.types)
local useSelectionState = require(script.Parent.Parent.internal.useSelectionState)

local React = Dependencies.React
local e = React.createElement

type IconSpec = Types.IconSpec
type ControlSize = Types.ControlSize
type ControlVariant = Types.ControlVariant

export type Props = Types.CommonControlProps & {
	badge: (boolean | number)?,
	badgeMax: number?,
	icon: IconSpec,
	label: string,
	variant: ControlVariant?,
	size: ControlSize?,
	shape: "rounded" | "circle" | "square"?,
	loading: boolean?,
	onActivated: ((InputObject, number) -> ())?,
	onSecondaryActivated: ((InputObject) -> ())?,
}

local function IconButton(props: Props): any
	assert(props.label ~= "", "IconButton.label must describe the icon-only action")
	local variant = props.variant or "secondary"
	local size = props.size or "medium"
	local shape = props.shape or "rounded"
	local loading = props.loading == true
	local unavailable = props.disabled == true or loading
	local selection = useSelectionState(props.rootRef)
	local tags = Tags.join(
		"oof-ui-icon-button",
		Tags.when(props.disabled == true, "oof-ui-icon-button-disabled"),
		"oof-ui-icon-button-" .. variant,
		"oof-ui-icon-button-" .. size,
		"oof-ui-icon-button-" .. shape,
		Tags.when(loading, "oof-ui-icon-button-loading"),
		Tags.when(selection.focusVisible, "oof-ui-icon-button-focused"),
		props.tag
	)

	return e(
		"ImageButton",
		{
			[React.Tag] = tags,
			ref = selection.rootRef,
			AutoButtonColor = false,
			Image = "",
			Interactable = not unavailable,
			LayoutOrder = props.layoutOrder,
			Selectable = not unavailable,
			SelectionOrder = props.selectionOrder,
			[React.Event.Activated] = if unavailable then nil else props.onActivated,
			[React.Event.SecondaryActivated] = if unavailable then nil else props.onSecondaryActivated,
			[React.Event.SelectionGained] = selection.onSelectionGained,
			[React.Event.SelectionLost] = selection.onSelectionLost,
		},
		ControlChrome({
			prefix = "oof-ui-icon-button",
			selectionImageRef = selection.selectionImageRef,
			content = {
				Badge = e(ButtonBadge, { value = props.badge, maximum = props.badgeMax, overlay = true }),
				Icon = e(Icon, {
					icon = props.icon,
					tag = "oof-ui-icon-button-icon",
					visible = not loading,
				}),
				Loading = e("Frame", {
					[React.Tag] = "oof-ui-icon-button-loading-indicator",
					Visible = loading,
				}, {
					Corner = e("UICorner", { [React.Tag] = "oof-ui-icon-button-loading-indicator-corner" }),
					Stroke = e("UIStroke", { [React.Tag] = "oof-ui-icon-button-loading-indicator-stroke" }),
				}),
				AccessibleLabel = e(Text, {
					text = props.label,
					visible = false,
					tag = "oof-ui-icon-button-accessible-label",
				}),
			},
		})
	)
end

return IconButton
