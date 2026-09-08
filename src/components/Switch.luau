--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)
local MaterialLayer = require(script.Parent.Parent.internal.MaterialLayer)
local SelectionImage = require(script.Parent.Parent.internal.SelectionImage)
local Tags = require(script.Parent.Parent.internal.Tags)
local Types = require(script.Parent.Parent.types)
local useChoiceControl = require(script.Parent.Parent.internal.useChoiceControl)
local useControllableState = require(script.Parent.Parent.internal.useControllableState)

local React = Dependencies.React
local e = React.createElement

export type Props = Types.CommonControlProps & {
	checked: boolean?,
	defaultChecked: boolean?,
	invalid: boolean?,
	onCheckedChanged: ((boolean) -> ())?,
}

local function Switch(props: Props): any
	local checked, setChecked =
		useControllableState(props.checked, props.defaultChecked == true, props.onCheckedChanged)

	local requestToggle = React.useCallback(function()
		setChecked(not checked)
	end, { checked, setChecked })
	local choice = useChoiceControl({
		disabled = props.disabled,
		invalid = props.invalid,
		rootRef = props.rootRef,
		onActivated = requestToggle,
	})

	return e("TextButton", {
		[React.Tag] = Tags.join(
			"oof-ui-switch",
			Tags.when(checked, "oof-ui-switch-checked"),
			Tags.when(choice.focused, "oof-ui-switch-focused"),
			Tags.when(choice.invalid, "oof-ui-switch-invalid"),
			props.tag
		),
		ref = choice.rootRef,
		AutoButtonColor = false,
		Interactable = not choice.disabled,
		LayoutOrder = props.layoutOrder,
		Selectable = not choice.disabled,
		SelectionOrder = props.selectionOrder,
		Text = "",
		[React.Event.Activated] = choice.activate,
		[React.Event.SelectionGained] = choice.onSelectionGained,
		[React.Event.SelectionLost] = choice.onSelectionLost,
	}, {
		Track = e("Frame", {
			[React.Tag] = "oof-ui-switch-track",
			ClipsDescendants = true,
		}, {
			Corner = e("UICorner", { [React.Tag] = "oof-ui-switch-track-corner" }),
			Stroke = e("UIStroke", { [React.Tag] = "oof-ui-switch-track-stroke" }),
			Gradient = e("UIGradient", { [React.Tag] = "oof-ui-switch-track-gradient" }),
			Material = e(MaterialLayer, {
				tag = "oof-ui-switch-material",
				size = UDim2.fromScale(1, 1),
			}, {}),
			Content = e("Frame", {
				[React.Tag] = "oof-ui-switch-content",
			}, {
				Padding = e("UIPadding", { [React.Tag] = "oof-ui-switch-track-padding" }),
				Layout = e("UIListLayout", { [React.Tag] = "oof-ui-switch-track-layout" }),
				Thumb = e("Frame", {
					[React.Tag] = "oof-ui-switch-thumb",
				}, {
					Corner = e("UICorner", { [React.Tag] = "oof-ui-switch-thumb-corner" }),
					Stroke = e("UIStroke", { [React.Tag] = "oof-ui-switch-thumb-stroke" }),
					Gradient = e("UIGradient", { [React.Tag] = "oof-ui-switch-thumb-gradient" }),
				}),
			}),
		}),
		FocusStroke = e("UIStroke", { [React.Tag] = "oof-ui-switch-focus-stroke" }),
		SelectionImage = e(SelectionImage, { rootRef = choice.selectionImageRef }),
	})
end

return Switch
