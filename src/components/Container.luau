--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)
local MaterialLayer = require(script.Parent.Parent.internal.MaterialLayer)
local Refs = require(script.Parent.Parent.internal.Refs)
local Tags = require(script.Parent.Parent.internal.Tags)

local React = Dependencies.React
local e = React.createElement

local function logicalSize(instance: GuiObject): Vector2
	-- AbsoluteSize includes every ancestor UIScale. Offset sizes are local, so
	-- convert back before measuring decorative layers or they get scaled twice.
	local scale = 1
	local ancestor: Instance? = instance
	while ancestor ~= nil do
		local uiScale = ancestor:FindFirstChildWhichIsA("UIScale")
		if uiScale ~= nil then
			scale *= uiScale.Scale
		end
		ancestor = ancestor.Parent
	end
	return if scale > 0 then instance.AbsoluteSize / scale else Vector2.zero
end

export type Variant = "surface" | "raised" | "muted" | "accent" | "destructive"

export type Props = {
	variant: Variant?,
	size: UDim2?,
	automaticSize: Enum.AutomaticSize?,
	anchorPoint: Vector2?,
	position: UDim2?,
	zIndex: number?,
	layoutOrder: number?,
	contentPadding: UDim?,
	contentPaddingTop: UDim?,
	contentPaddingRight: UDim?,
	contentPaddingBottom: UDim?,
	contentPaddingLeft: UDim?,
	tag: string?,
	rootRef: any?,
	children: any?,
}

local function Container(props: Props): any
	local variant = props.variant or "surface"
	local automaticSize = props.automaticSize or Enum.AutomaticSize.Y
	assert(
		automaticSize == Enum.AutomaticSize.Y or automaticSize == Enum.AutomaticSize.None,
		"oof-ui Container automaticSize supports Y or None"
	)

	local rootRef = React.useRef(nil :: Frame?)
	local contentRef = React.useRef(nil :: Frame?)
	local contentSize, setContentSize = React.useState(Vector2.zero)
	local rootSize, setRootSize = React.useState(Vector2.zero)

	local assignRoot = React.useCallback(function(root: Frame?)
		rootRef.current = root
		Refs.assign(props.rootRef, root)
	end, { props.rootRef })

	React.useEffect(function()
		local root = rootRef.current
		local content = contentRef.current
		if root == nil or content == nil then
			return nil
		end

		local function updateRootSize()
			setRootSize(logicalSize(root))
		end
		local function updateContentSize()
			setContentSize(logicalSize(content))
		end
		updateRootSize()
		updateContentSize()

		local rootConnection = root:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateRootSize)
		local contentConnection = content:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateContentSize)
		return function()
			rootConnection:Disconnect()
			contentConnection:Disconnect()
		end
	end, {})

	-- Decorative descendants must never participate in automatic measurement.
	-- Content owns automatic height; fixed containers mirror their root bounds.
	local overlayBounds = if automaticSize == Enum.AutomaticSize.Y then contentSize else rootSize
	local overlaySize = UDim2.fromOffset(math.round(overlayBounds.X), math.round(overlayBounds.Y))

	return e("Frame", {
		[React.Tag] = Tags.join("oof-ui-container", "oof-ui-container-variant-" .. variant, props.tag),
		ref = assignRoot,
		AutomaticSize = automaticSize,
		AnchorPoint = props.anchorPoint,
		LayoutOrder = props.layoutOrder,
		Position = props.position,
		Size = props.size or UDim2.fromScale(1, 0),
		ZIndex = props.zIndex,
	}, {
		Surface = e("Frame", {
			[React.Tag] = "oof-ui-container-surface",
		}, {
			Corner = e("UICorner", { [React.Tag] = "oof-ui-container-corner" }),
			Stroke = e("UIStroke", { [React.Tag] = "oof-ui-container-stroke" }),
			Gradient = e("UIGradient", { [React.Tag] = "oof-ui-container-gradient" }),
			Inset = e("Frame", {
				[React.Tag] = "oof-ui-container-inset",
				-- Fixed measured bounds keep inset chrome out of automatic height.
				Size = UDim2.fromOffset(math.max(0, overlayBounds.X - 12), math.max(0, overlayBounds.Y - 12)),
			}, {
				Corner = e("UICorner", { [React.Tag] = "oof-ui-container-inset-corner" }),
				Stroke = e("UIStroke", { [React.Tag] = "oof-ui-container-inset-stroke" }),
			}),
			Material = e(MaterialLayer, {
				tag = "oof-ui-container-material",
				size = overlaySize,
			}),
		}),
		Content = e("Frame", {
			[React.Tag] = "oof-ui-container-content",
			ref = contentRef,
		}, {
			Padding = e("UIPadding", {
				[React.Tag] = "oof-ui-container-padding",
				PaddingTop = props.contentPaddingTop or props.contentPadding,
				PaddingRight = props.contentPaddingRight or props.contentPadding,
				PaddingBottom = props.contentPaddingBottom or props.contentPadding,
				PaddingLeft = props.contentPaddingLeft or props.contentPadding,
			}),
			Layout = e("UIListLayout", { [React.Tag] = "oof-ui-container-layout" }),
			Children = e(React.Fragment, nil, props.children),
		}),
	})
end

return Container
