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
	text: string?,
	children: any?,
	leadingIcon: IconSpec?,
	trailingIcon: IconSpec?,
	variant: ControlVariant?,
	size: ControlSize?,
	loading: boolean?,
	loadingText: string?,
	fullWidth: boolean?,
	onActivated: ((InputObject, number) -> ())?,
	onSecondaryActivated: ((InputObject) -> ())?,
}

local function Button(props: Props): any
	assert(props.text ~= nil or props.children ~= nil, "oof-ui Button requires text or children")

	local variant = props.variant or "primary"
	local size = props.size or "medium"
	local loading = props.loading == true
	local unavailable = props.disabled == true or loading
	local selection = useSelectionState(props.rootRef)
	local hasCustomContent = props.children ~= nil
	local tags = Tags.join(
		"oof-ui-button",
		Tags.when(props.disabled == true, "oof-ui-button-disabled"),
		"oof-ui-button-" .. variant,
		"oof-ui-button-" .. size,
		Tags.when(props.fullWidth ~= true, "oof-ui-button-fixed-" .. size),
		Tags.when(loading, "oof-ui-button-loading"),
		Tags.when(props.fullWidth == true, "oof-ui-button-full-width"),
		Tags.when(props.fullWidth == true, "oof-ui-button-full-width-" .. size),
		Tags.when(selection.focusVisible, "oof-ui-button-focused"),
		props.tag
	)

	return e(
		"TextButton",
		{
			[React.Tag] = tags,
			ref = selection.rootRef,
			AutoButtonColor = false,
			Interactable = not unavailable,
			LayoutOrder = props.layoutOrder,
			Selectable = not unavailable,
			SelectionOrder = props.selectionOrder,
			Text = "",
			[React.Event.Activated] = if unavailable then nil else props.onActivated,
			[React.Event.SecondaryActivated] = if unavailable then nil else props.onSecondaryActivated,
			[React.Event.SelectionGained] = selection.onSelectionGained,
			[React.Event.SelectionLost] = selection.onSelectionLost,
		},
		ControlChrome({
			prefix = "oof-ui-button",
			selectionImageRef = selection.selectionImageRef,
			content = {
				Content = e("Frame", {
					[React.Tag] = "oof-ui-button-content",
				}, {
					Padding = e("UIPadding", { [React.Tag] = "oof-ui-button-content-padding" }),
					Layout = e("UIListLayout", { [React.Tag] = "oof-ui-button-content-layout" }),
					Badge = e(ButtonBadge, { value = props.badge, maximum = props.badgeMax }),
					LeadingIcon = if not hasCustomContent and not loading
						then e(Icon, {
							icon = props.leadingIcon,
							tag = "oof-ui-button-leading-icon",
							layoutOrder = 1,
							visible = true,
						})
						else nil,
					Loading = e("Frame", {
						[React.Tag] = "oof-ui-button-loading-indicator",
						LayoutOrder = 1,
						Visible = loading,
					}, {
						Corner = e("UICorner", { [React.Tag] = "oof-ui-button-loading-indicator-corner" }),
						Stroke = e("UIStroke", { [React.Tag] = "oof-ui-button-loading-indicator-stroke" }),
					}),
					Label = if not hasCustomContent or loading
						then e(Text, {
							text = if loading then props.loadingText or props.text or "" else props.text or "",
							tone = if variant == "primary" or variant == "destructive" then "onAccent" else "default",
							automaticSize = Enum.AutomaticSize.X,
							layoutOrder = 2,
							size = UDim2.fromScale(0, 1),
							textWrapped = false,
							tag = "oof-ui-button-label",
						})
						else nil,
					CustomContent = if hasCustomContent and not loading
						then e(React.Fragment, nil, props.children)
						else nil,
					TrailingIcon = if not hasCustomContent and not loading
						then e(Icon, {
							icon = props.trailingIcon,
							tag = "oof-ui-button-trailing-icon",
							layoutOrder = 3,
							visible = true,
						})
						else nil,
				}),
			},
		})
	)
end

return Button
