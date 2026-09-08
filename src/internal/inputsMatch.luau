--!strict

-- Keyboard/mouse releases can arrive as a different InputObject. Touch identity
-- is the contact: all fingers otherwise share Touch + KeyCode.Unknown.
return function(activeInput: InputObject?, endedInput: InputObject): boolean
	if activeInput == nil then
		return false
	end
	if activeInput == endedInput then
		return true
	end
	if activeInput.UserInputType == Enum.UserInputType.Touch then
		return false
	end
	return activeInput.UserInputType == endedInput.UserInputType and activeInput.KeyCode == endedInput.KeyCode
end
