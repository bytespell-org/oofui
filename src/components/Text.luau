--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)
local Refs = require(script.Parent.Parent.internal.Refs)
local Tags = require(script.Parent.Parent.internal.Tags)
local useTextHeight = require(script.Parent.Parent.internal.useTextHeight)

local React = Dependencies.React
local e = React.createElement

export type Variant = "display" | "heading" | "body" | "subtext" | "caption"
export type Tone = "default" | "muted" | "success" | "warning" | "danger" | "onAccent" | "onContainerAccent"

export type Props = {
	text: string,
	variant: Variant?,
	tone: Tone?,
	size: UDim2?,
	automaticSize: Enum.AutomaticSize?,
	textWrapped: boolean?,
	textXAlignment: Enum.TextXAlignment?,
	textYAlignment: Enum.TextYAlignment?,
	anchorPoint: Vector2?,
	position: UDim2?,
	zIndex: number?,
	visible: boolean?,
	layoutOrder: number?,
	tag: string?,
	rootRef: any?,
}

local function Text(props: Props): any
	local variant = props.variant or "body"
	local tone = props.tone or if variant == "subtext" or variant == "caption" then "muted" else "default"

	local ref = React.useRef(nil)
	local automaticSize = props.automaticSize or Enum.AutomaticSize.Y
	local wrapped = props.textWrapped ~= false
	local height = useTextHeight(ref, props.text, automaticSize == Enum.AutomaticSize.Y and wrapped)
	local size = props.size or UDim2.fromScale(1, 0)
	if height > 0 then
		size = UDim2.new(size.X, UDim.new(size.Y.Scale, math.max(size.Y.Offset, height)))
	end
	local assign = React.useCallback(function(node)
		ref.current = node
		Refs.assign(props.rootRef, node)
	end, { props.rootRef })
	return e("TextLabel", {
		[React.Tag] = Tags.join("oof-ui-text", "oof-ui-text-" .. variant, "oof-ui-text-tone-" .. tone, props.tag),
		ref = assign,
		AutomaticSize = automaticSize,
		LayoutOrder = props.layoutOrder,
		AnchorPoint = props.anchorPoint,
		Position = props.position,
		ZIndex = props.zIndex,
		Visible = props.visible ~= false,
		Size = size,
		Text = props.text,
		TextWrapped = if props.textWrapped == nil then true else props.textWrapped,
		TextXAlignment = props.textXAlignment or Enum.TextXAlignment.Left,
		TextYAlignment = props.textYAlignment or Enum.TextYAlignment.Center,
	})
end

return Text
