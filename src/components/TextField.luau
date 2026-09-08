--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)
local FieldContext = require(script.Parent.Parent.internal.FieldContext)
local MaterialLayer = require(script.Parent.Parent.internal.MaterialLayer)
local Refs = require(script.Parent.Parent.internal.Refs)
local Tags = require(script.Parent.Parent.internal.Tags)
local Types = require(script.Parent.Parent.types)
local useControllableState = require(script.Parent.Parent.internal.useControllableState)

local React = Dependencies.React
local e = React.createElement

export type Props = Types.CommonControlProps & {
	text: string?,
	defaultText: string?,
	placeholder: string?,
	invalid: boolean?,
	readOnly: boolean?,
	multiLine: boolean?,
	clearTextOnFocus: boolean?,
	inputRef: any?,
	onTextChanged: ((string) -> ())?,
	onFocused: (() -> ())?,
	onFocusLost: ((boolean, InputObject) -> ())?,
	onSubmitted: ((string) -> ())?,
}

local function TextField(props: Props): any
	local fieldContext = React.useContext(FieldContext)
	local text, setText = useControllableState(props.text, props.defaultText or "", props.onTextChanged)
	local focused, setFocused = React.useState(false)
	local disabled = props.disabled == true or (fieldContext ~= nil and fieldContext.disabled)
	local readOnly = props.readOnly == true
	local invalid = props.invalid == true or (fieldContext ~= nil and fieldContext.invalid)
	local registerControl = if fieldContext ~= nil then fieldContext.registerControl else nil
	local tags = Tags.join(
		"oof-ui-text-field",
		Tags.when(focused, "oof-ui-text-field-focused"),
		Tags.when(invalid, "oof-ui-text-field-invalid"),
		Tags.when(disabled, "oof-ui-text-field-disabled"),
		Tags.when(readOnly, "oof-ui-text-field-read-only"),
		Tags.when(props.multiLine == true, "oof-ui-text-field-multiline"),
		props.tag
	)

	local onChanged = React.useCallback(function(textBox: TextBox)
		if not disabled and not readOnly then
			setText(textBox.Text)
		end
	end, { disabled, readOnly, setText })

	local onFocused = React.useCallback(function(_textBox: TextBox)
		setFocused(true)
		if props.onFocused ~= nil then
			props.onFocused()
		end
	end, { props.onFocused })

	local onFocusLost = React.useCallback(function(textBox: TextBox, enterPressed: boolean, input: InputObject)
		setFocused(false)
		if props.onFocusLost ~= nil then
			props.onFocusLost(enterPressed, input)
		end
		if enterPressed and props.onSubmitted ~= nil then
			props.onSubmitted(textBox.Text)
		end
	end, { props.onFocusLost, props.onSubmitted })

	local inputRef = React.useCallback(function(textBox: TextBox?)
		Refs.assign(props.inputRef, textBox)
		if registerControl ~= nil then
			registerControl(textBox, nil)
		end
	end, { props.inputRef, registerControl })

	return e("Frame", {
		[React.Tag] = tags,
		ref = props.rootRef,
		LayoutOrder = props.layoutOrder,
	}, {
		Flex = e("UIFlexItem", { [React.Tag] = "oof-ui-text-field-flex" }),
		Field = e("Frame", {
			[React.Tag] = "oof-ui-text-field-surface",
		}, {
			Corner = e("UICorner", { [React.Tag] = "oof-ui-text-field-corner" }),
			Stroke = e("UIStroke", { [React.Tag] = "oof-ui-text-field-stroke" }),
			Material = e(MaterialLayer, {
				tag = "oof-ui-text-field-material",
				size = UDim2.fromScale(1, 1),
			}),
			Input = e("TextBox", {
				[React.Tag] = "oof-ui-text-field-input",
				ref = inputRef,
				ClearTextOnFocus = props.clearTextOnFocus == true,
				Interactable = not disabled,
				MultiLine = props.multiLine == true,
				PlaceholderText = props.placeholder or "",
				Selectable = not disabled,
				SelectionOrder = props.selectionOrder,
				Text = text,
				TextEditable = not disabled and not readOnly,
				[React.Change.Text] = onChanged,
				[React.Event.Focused] = onFocused,
				[React.Event.FocusLost] = onFocusLost,
			}, {
				Padding = e("UIPadding", { [React.Tag] = "oof-ui-text-field-input-padding" }),
			}),
		}),
	})
end

return TextField
