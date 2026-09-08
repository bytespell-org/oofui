--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)

local React = Dependencies.React
local e = React.createElement

export type Props = {
	tag: string,
	size: UDim2?,
}

local function MaterialLayer(props: Props): any
	return e("ImageLabel", {
		[React.Tag] = props.tag,
		AutomaticSize = Enum.AutomaticSize.None,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = props.size,
	})
end

return MaterialLayer
