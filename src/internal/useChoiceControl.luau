--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)
local FieldContext = require(script.Parent.FieldContext)
local Refs = require(script.Parent.Refs)
local useSelectionState = require(script.Parent.useSelectionState)

local React = Dependencies.React

export type Options = {
	disabled: boolean?,
	invalid: boolean?,
	rootRef: any?,
	onActivated: () -> (),
}

export type State = {
	disabled: boolean,
	invalid: boolean,
	focused: boolean,
	rootRef: (TextButton?) -> (),
	selectionImageRef: (GuiObject?) -> (),
	activate: () -> (),
	onSelectionGained: () -> (),
	onSelectionLost: () -> (),
}

local function useChoiceControl(options: Options): State
	local fieldContext = React.useContext(FieldContext)
	local disabled = options.disabled == true or (fieldContext ~= nil and fieldContext.disabled)
	local invalid = options.invalid == true or (fieldContext ~= nil and fieldContext.invalid)
	local registerControl = if fieldContext ~= nil then fieldContext.registerControl else nil
	local disabledRef = React.useRef(disabled)
	local activationRef = React.useRef(options.onActivated)
	disabledRef.current = disabled
	activationRef.current = options.onActivated

	local activate = React.useCallback(function()
		if not disabledRef.current then
			activationRef.current()
		end
	end, {})

	local controlRootRef = React.useCallback(function(button: TextButton?)
		Refs.assign(options.rootRef, button)
		if registerControl ~= nil then
			registerControl(button, activate)
		end
	end, { options.rootRef, registerControl, activate })
	local selection = useSelectionState(controlRootRef)

	return {
		disabled = disabled,
		invalid = invalid,
		focused = selection.focusVisible,
		rootRef = selection.rootRef,
		selectionImageRef = selection.selectionImageRef,
		activate = activate,
		onSelectionGained = selection.onSelectionGained,
		onSelectionLost = selection.onSelectionLost,
	}
end

return useChoiceControl
