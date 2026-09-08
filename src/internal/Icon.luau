--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)
local Types = require(script.Parent.Parent.types)

local React = Dependencies.React
local e = React.createElement

type IconSpec = Types.IconSpec

export type Props = {
	icon: IconSpec?,
	tag: string,
	visible: boolean?,
	layoutOrder: number?,
}

local function Icon(props: Props): any
	local icon = props.icon
	if icon == nil then
		return nil
	end
	local image = if type(icon) == "string" then icon else icon.image
	local rectOffset = if type(icon) == "table" then icon.imageRectOffset or Vector2.zero else Vector2.zero
	local rectSize = if type(icon) == "table" then icon.imageRectSize or Vector2.zero else Vector2.zero
	local scaleType = if type(icon) == "table" then icon.scaleType or Enum.ScaleType.Fit else Enum.ScaleType.Fit

	return e("ImageLabel", {
		[React.Tag] = props.tag,
		BackgroundTransparency = 1,
		Image = image,
		ImageRectOffset = rectOffset,
		ImageRectSize = rectSize,
		LayoutOrder = props.layoutOrder,
		ScaleType = scaleType,
		Visible = props.visible ~= false,
	})
end

return Icon
