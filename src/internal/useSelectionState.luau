--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)
local Refs = require(script.Parent.Refs)

local React = Dependencies.React
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local NAVIGATION_INPUT_TYPES = {
	[Enum.UserInputType.Keyboard] = true,
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true,
	[Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true,
	[Enum.UserInputType.Gamepad8] = true,
}

export type State = {
	selected: boolean,
	isSelected: () -> boolean,
	focusVisible: boolean,
	rootRef: (GuiObject?) -> (),
	selectionImageRef: (GuiObject?) -> (),
	onSelectionGained: () -> (),
	onSelectionLost: () -> (),
}

local function isNavigationInput(inputType: Enum.UserInputType): boolean
	return NAVIGATION_INPUT_TYPES[inputType] == true
end

local function useSelectionState(externalRootRef: any?): State
	local selected, setSelected = React.useState(false)
	local focusVisible, setFocusVisible = React.useState(false)
	local rootInstanceRef = React.useRef(nil :: GuiObject?)
	local selectionImageInstanceRef = React.useRef(nil :: GuiObject?)

	local rootRef = React.useCallback(function(root: GuiObject?)
		rootInstanceRef.current = root
		Refs.assign(externalRootRef, root)
		if root ~= nil then
			root.SelectionImageObject = selectionImageInstanceRef.current
		end
	end, { externalRootRef })

	local selectionImageRef = React.useCallback(function(selectionImage: GuiObject?)
		selectionImageInstanceRef.current = selectionImage
		local root = rootInstanceRef.current
		if root ~= nil then
			root.SelectionImageObject = selectionImage
		end
	end, {})

	local isSelected = React.useCallback(function()
		return rootInstanceRef.current ~= nil and GuiService.SelectedObject == rootInstanceRef.current
	end, {})

	local onSelectionGained = React.useCallback(function()
		setSelected(true)
		setFocusVisible(isNavigationInput(UserInputService:GetLastInputType()))
	end, {})
	local onSelectionLost = React.useCallback(function()
		setSelected(false)
		setFocusVisible(false)
	end, {})

	React.useEffect(function()
		if not selected then
			return nil
		end
		local connection = UserInputService.LastInputTypeChanged:Connect(function(inputType)
			setFocusVisible(isNavigationInput(inputType))
		end)
		return function()
			connection:Disconnect()
		end
	end, { selected })

	return {
		selected = selected,
		isSelected = isSelected,
		focusVisible = focusVisible,
		rootRef = rootRef,
		selectionImageRef = selectionImageRef,
		onSelectionGained = onSelectionGained,
		onSelectionLost = onSelectionLost,
	}
end

return useSelectionState
