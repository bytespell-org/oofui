--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)
local MaterialLayer = require(script.Parent.Parent.internal.MaterialLayer)
local RadioGroupContext = require(script.Parent.Parent.internal.RadioGroupContext)
local SelectionImage = require(script.Parent.Parent.internal.SelectionImage)
local Tags = require(script.Parent.Parent.internal.Tags)
local Types = require(script.Parent.Parent.types)
local useChoiceControl = require(script.Parent.Parent.internal.useChoiceControl)

local React = Dependencies.React
local e = React.createElement

export type Props = Types.CommonControlProps & {
	value: string,
}

local function RadioGroupItem(props: Props): any
	local groupContext = React.useContext(RadioGroupContext)
	assert(groupContext ~= nil, "RadioGroupItem must be nested inside RadioGroup")
	local checked = groupContext.value == props.value

	local requestSelection = React.useCallback(function()
		groupContext.selectValue(props.value)
	end, { groupContext, props.value })
	local choice = useChoiceControl({
		disabled = props.disabled == true or groupContext.disabled,
		rootRef = props.rootRef,
		onActivated = requestSelection,
	})

	return e("TextButton", {
		[React.Tag] = Tags.join(
			"oof-ui-radio-group-item",
			Tags.when(checked, "oof-ui-radio-group-item-checked"),
			Tags.when(choice.focused, "oof-ui-radio-group-item-focused"),
			Tags.when(choice.invalid, "oof-ui-radio-group-item-invalid"),
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
			tag = "oof-ui-radio-group-item-material",
			size = UDim2.fromScale(1, 1),
		}),
		Corner = e("UICorner", { [React.Tag] = "oof-ui-radio-group-item-corner" }),
		Stroke = e("UIStroke", { [React.Tag] = "oof-ui-radio-group-item-stroke" }),
		Dot = e("Frame", {
			[React.Tag] = "oof-ui-radio-group-item-dot",
			Visible = checked,
		}, {
			Corner = e("UICorner", { [React.Tag] = "oof-ui-radio-group-item-dot-corner" }),
			Stroke = e("UIStroke", { [React.Tag] = "oof-ui-radio-group-item-dot-stroke" }),
			Gradient = e("UIGradient", { [React.Tag] = "oof-ui-radio-group-item-dot-gradient" }),
		}),
		FocusStroke = e("UIStroke", { [React.Tag] = "oof-ui-radio-group-item-focus-stroke" }),
		SelectionImage = e(SelectionImage, { rootRef = choice.selectionImageRef }),
	})
end

return RadioGroupItem
