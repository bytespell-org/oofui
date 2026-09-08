--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)
local FieldContext = require(script.Parent.Parent.internal.FieldContext)
local Tags = require(script.Parent.Parent.internal.Tags)
local Text = require(script.Parent.Text)

local React = Dependencies.React
local e = React.createElement

export type Props = {
	text: string,
	required: boolean?,
	disabled: boolean?,
	layoutOrder: number?,
	tag: string?,
	rootRef: any?,
}

local function FieldLabel(props: Props): any
	local context = React.useContext(FieldContext)
	local disabled = props.disabled == true or (context ~= nil and context.disabled)

	local onActivated = React.useCallback(function()
		if disabled then
			return
		end
		if context ~= nil then
			context.activateControl()
		end
	end, { context, disabled })

	return e("TextButton", {
		[React.Tag] = Tags.join(
			"oof-ui-field-label-control",
			Tags.when(props.required == true, "oof-ui-field-label-required"),
			Tags.when(disabled, "oof-ui-field-label-disabled"),
			props.tag
		),
		ref = props.rootRef,
		AutoButtonColor = false,
		Interactable = not disabled,
		LayoutOrder = props.layoutOrder,
		Selectable = false,
		Text = "",
		[React.Event.Activated] = onActivated,
	}, {
		Text = e(Text, {
			text = if props.required == true then props.text .. " *" else props.text,
			variant = "subtext",
			tone = "default",
			tag = "oof-ui-field-label",
		}),
	})
end

return FieldLabel
