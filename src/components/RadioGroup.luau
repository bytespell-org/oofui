--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)
local FieldContext = require(script.Parent.Parent.internal.FieldContext)
local RadioGroupContext = require(script.Parent.Parent.internal.RadioGroupContext)
local Tags = require(script.Parent.Parent.internal.Tags)
local Types = require(script.Parent.Parent.types)
local useControllableState = require(script.Parent.Parent.internal.useControllableState)

local React = Dependencies.React
local e = React.createElement

export type Props = {
	value: string?,
	defaultValue: string?,
	disabled: boolean?,
	orientation: Types.Orientation?,
	onValueChanged: ((string) -> ())?,
	layoutOrder: number?,
	tag: string?,
	rootRef: any?,
	children: any?,
}

local function RadioGroup(props: Props): any
	local fieldContext = React.useContext(FieldContext)
	local value, setValue = useControllableState(props.value, props.defaultValue or "", props.onValueChanged)
	local disabled = props.disabled == true or (fieldContext ~= nil and fieldContext.disabled)
	local orientation = props.orientation or "vertical"

	local selectValue = React.useCallback(function(nextValue: string)
		if not disabled then
			setValue(nextValue)
		end
	end, { disabled, setValue })

	local contextValue = React.useMemo(function()
		return {
			value = value,
			disabled = disabled,
			selectValue = selectValue,
		}
	end, { value, disabled, selectValue })

	return e("Frame", {
		[React.Tag] = Tags.join(
			"oof-ui-radio-group",
			"oof-ui-radio-group-" .. orientation,
			Tags.when(disabled, "oof-ui-radio-group-disabled"),
			props.tag
		),
		ref = props.rootRef,
		LayoutOrder = props.layoutOrder,
	}, {
		Layout = e("UIListLayout", { [React.Tag] = "oof-ui-radio-group-layout" }),
		Content = e(RadioGroupContext.Provider, { value = contextValue }, props.children),
	})
end

return RadioGroup
