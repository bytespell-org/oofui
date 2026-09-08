--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)
local React = Dependencies.React

local function useControllableState<T>(
	controlledValue: T?,
	defaultValue: T,
	onValueChanged: ((T) -> ())?
): (T, (T | ((T) -> T)) -> ())
	local internalValue, setInternalValue = React.useState(defaultValue)
	local value = if controlledValue ~= nil then controlledValue else internalValue

	local setValue = React.useCallback(function(nextValue: T | ((T) -> T))
		local resolved = if type(nextValue) == "function" then (nextValue :: any)(value) else nextValue
		if resolved == value then
			return
		end
		if controlledValue == nil then
			setInternalValue(resolved)
		end
		if onValueChanged ~= nil then
			onValueChanged(resolved)
		end
	end, { controlledValue, value, onValueChanged })

	return value, setValue
end

return useControllableState
