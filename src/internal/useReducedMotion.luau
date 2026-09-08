--!strict

local GuiService = game:GetService("GuiService")
local Dependencies = require(script.Parent.Parent.Dependencies)
local React = Dependencies.React

local function readPreference(): boolean
	local ok, value = pcall(function()
		return GuiService.ReducedMotionEnabled
	end)
	return ok and value == true
end

local function useReducedMotion(): boolean
	local reducedMotion, setReducedMotion = React.useState(readPreference)

	React.useEffect(function()
		local ok, signal = pcall(function()
			return GuiService:GetPropertyChangedSignal("ReducedMotionEnabled")
		end)
		if not ok then
			return nil
		end
		local connection = signal:Connect(function()
			setReducedMotion(readPreference())
		end)
		return function()
			connection:Disconnect()
		end
	end, {})

	return reducedMotion
end

return useReducedMotion
