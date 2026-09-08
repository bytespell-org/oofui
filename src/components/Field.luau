--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)
local FieldContext = require(script.Parent.Parent.internal.FieldContext)
local Tags = require(script.Parent.Parent.internal.Tags)

local React = Dependencies.React
local e = React.createElement

export type Orientation = "vertical" | "horizontal"

export type Props = {
	disabled: boolean?,
	invalid: boolean?,
	orientation: Orientation?,
	layoutOrder: number?,
	tag: string?,
	rootRef: any?,
	children: any?,
}

local function Field(props: Props): any
	local disabled = props.disabled == true
	local invalid = props.invalid == true
	local orientation = props.orientation or "vertical"
	local controlRef = React.useRef(nil :: GuiObject?)
	local activationRef = React.useRef(nil :: (() -> ())?)

	local registerControl = React.useCallback(function(control: GuiObject?, activate: (() -> ())?)
		controlRef.current = control
		activationRef.current = activate
	end, {})

	local activateControl = React.useCallback(function()
		if disabled then
			return
		end
		if activationRef.current ~= nil then
			activationRef.current()
			return
		end
		local control = controlRef.current
		if control ~= nil and control:IsA("TextBox") and control.TextEditable then
			control:CaptureFocus()
		end
	end, { disabled })

	local contextValue = React.useMemo(function()
		return {
			disabled = disabled,
			invalid = invalid,
			activateControl = activateControl,
			registerControl = registerControl,
		}
	end, { disabled, invalid, activateControl, registerControl })

	return e("Frame", {
		[React.Tag] = Tags.join(
			"oof-ui-field",
			"oof-ui-field-" .. orientation,
			Tags.when(disabled, "oof-ui-field-disabled"),
			Tags.when(invalid, "oof-ui-field-invalid"),
			props.tag
		),
		ref = props.rootRef,
		LayoutOrder = props.layoutOrder,
	}, {
		Layout = e("UIListLayout", { [React.Tag] = "oof-ui-field-layout" }),
		Content = e(FieldContext.Provider, { value = contextValue }, props.children),
	})
end

return Field
