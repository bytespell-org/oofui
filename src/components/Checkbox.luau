--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)
local MaterialLayer = require(script.Parent.Parent.internal.MaterialLayer)
local SelectionImage = require(script.Parent.Parent.internal.SelectionImage)
local Tags = require(script.Parent.Parent.internal.Tags)
local Text = require(script.Parent.Text)
local Types = require(script.Parent.Parent.types)
local useChoiceControl = require(script.Parent.Parent.internal.useChoiceControl)
local useControllableState = require(script.Parent.Parent.internal.useControllableState)

local React = Dependencies.React
local e = React.createElement

export type Props = Types.CommonControlProps & {
	checked: boolean?,
	defaultChecked: boolean?,
	indeterminate: boolean?,
	invalid: boolean?,
	onCheckedChanged: ((boolean) -> ())?,
}

local function Checkbox(props: Props): any
	local checked, setChecked =
		useControllableState(props.checked, props.defaultChecked == true, props.onCheckedChanged)
	local indeterminate = props.indeterminate == true

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
			"oof-ui-checkbox",
			Tags.when(checked, "oof-ui-checkbox-checked"),
			Tags.when(indeterminate, "oof-ui-checkbox-indeterminate"),
			Tags.when(choice.focused, "oof-ui-checkbox-focused"),
			Tags.when(choice.invalid, "oof-ui-checkbox-invalid"),
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
		Material = e(MaterialLayer, {
			tag = "oof-ui-checkbox-material",
			size = UDim2.fromScale(1, 1),
		}),
		Corner = e("UICorner", { [React.Tag] = "oof-ui-checkbox-corner" }),
		Stroke = e("UIStroke", { [React.Tag] = "oof-ui-checkbox-stroke" }),
		Mark = e(Text, {
			text = if indeterminate then "−" else "✓",
			tone = "onAccent",
			automaticSize = Enum.AutomaticSize.None,
			size = UDim2.fromScale(1, 1),
			textWrapped = false,
			textXAlignment = Enum.TextXAlignment.Center,
			visible = checked or indeterminate,
			tag = "oof-ui-checkbox-mark",
		}),
		FocusStroke = e("UIStroke", { [React.Tag] = "oof-ui-checkbox-focus-stroke" }),
		SelectionImage = e(SelectionImage, { rootRef = choice.selectionImageRef }),
	})
end

return Checkbox
