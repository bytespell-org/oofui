--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)

local React = Dependencies.React
local e = React.createElement

export type Props = {
	rootRef: (GuiObject?) -> (),
}

local function SelectionImage(props: Props): any
	return e("Frame", {
		ref = props.rootRef,
		Active = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Selectable = false,
		Size = UDim2.fromScale(1, 1),
	})
end

return SelectionImage
