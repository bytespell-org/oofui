--!strict

local RunService = game:GetService("RunService")
local Dependencies = require(script.Parent.Parent.Dependencies)
local MaterialLayer = require(script.Parent.Parent.internal.MaterialLayer)
local Math = require(script.Parent.Parent.internal.Math)
local Tags = require(script.Parent.Parent.internal.Tags)
local Types = require(script.Parent.Parent.types)
local useReducedMotion = require(script.Parent.Parent.internal.useReducedMotion)

local React = Dependencies.React
local e = React.createElement

type Orientation = Types.Orientation

export type Props = {
	value: number?,
	minimum: number?,
	maximum: number?,
	orientation: Orientation?,
	reversed: boolean?,
	indeterminate: boolean?,
	layoutOrder: number?,
	tag: string?,
	rootRef: any?,
}

local SEGMENT_FRACTION = 0.28

local function ProgressBar(props: Props): any
	local orientation = props.orientation or "horizontal"
	local reversed = props.reversed == true
	local indeterminate = props.indeterminate == true
	local fraction = Math.normalize(props.value, props.minimum, props.maximum)
	local reducedMotion = useReducedMotion()
	local fillRef = React.useRef(nil :: Frame?)
	local tags = Tags.join(
		"oof-ui-progress-bar",
		"oof-ui-progress-bar-" .. orientation,
		Tags.when(reversed, "oof-ui-progress-bar-reversed"),
		Tags.when(indeterminate, "oof-ui-progress-bar-indeterminate"),
		props.tag
	)

	local fillAnchor: Vector2
	local fillPosition: UDim2
	local fillSize: UDim2
	if orientation == "horizontal" then
		fillAnchor = if reversed then Vector2.new(1, 0) else Vector2.zero
		fillPosition = if reversed then UDim2.fromScale(1, 0) else UDim2.fromScale(0, 0)
		fillSize = UDim2.fromScale(if indeterminate then SEGMENT_FRACTION else fraction, 1)
	else
		fillAnchor = if reversed then Vector2.zero else Vector2.new(0, 1)
		fillPosition = if reversed then UDim2.fromScale(0, 0) else UDim2.fromScale(0, 1)
		fillSize = UDim2.fromScale(1, if indeterminate then SEGMENT_FRACTION else fraction)
	end

	React.useEffect(function()
		if not indeterminate then
			return nil
		end
		local fill = fillRef.current
		if fill == nil then
			return nil
		end
		if reducedMotion then
			fill.AnchorPoint = Vector2.new(0.5, 0.5)
			fill.Position = UDim2.fromScale(0.5, 0.5)
			return nil
		end
		local startedAt = os.clock()
		local connection = RunService.Heartbeat:Connect(function()
			local raw = (os.clock() - startedAt) / 1.15
			local progress = raw - math.floor(raw)
			local travel = 1 + SEGMENT_FRACTION
			local coordinate = -SEGMENT_FRACTION + progress * travel
			if reversed then
				coordinate = 1 - coordinate
			end
			if orientation == "horizontal" then
				fill.AnchorPoint = Vector2.zero
				fill.Position = UDim2.fromScale(coordinate, 0)
			else
				fill.AnchorPoint = Vector2.zero
				fill.Position = UDim2.fromScale(0, coordinate)
			end
		end)
		return function()
			connection:Disconnect()
		end
	end, { indeterminate, orientation, reducedMotion, reversed })

	return e("Frame", {
		[React.Tag] = tags,
		ref = props.rootRef,
		LayoutOrder = props.layoutOrder,
	}, {
		Track = e("Frame", {
			[React.Tag] = "oof-ui-progress-bar-track",
			ClipsDescendants = true,
		}, {
			Corner = e("UICorner", { [React.Tag] = "oof-ui-progress-bar-track-corner" }),
			Stroke = e("UIStroke", { [React.Tag] = "oof-ui-progress-bar-track-stroke" }),
			Gradient = e("UIGradient", { [React.Tag] = "oof-ui-progress-bar-track-gradient" }),
			Material = e(MaterialLayer, {
				tag = "oof-ui-progress-bar-track-material",
				size = UDim2.fromScale(1, 1),
			}),
			Fill = e("Frame", {
				[React.Tag] = "oof-ui-progress-bar-fill",
				ref = fillRef,
				AnchorPoint = fillAnchor,
				Position = fillPosition,
				Size = fillSize,
				Visible = indeterminate or fraction > 0,
			}, {
				Corner = e("UICorner", { [React.Tag] = "oof-ui-progress-bar-fill-corner" }),
				Stroke = e("UIStroke", { [React.Tag] = "oof-ui-progress-bar-fill-stroke" }),
				Gradient = e("UIGradient", { [React.Tag] = "oof-ui-progress-bar-fill-gradient" }),
				Material = e(MaterialLayer, {
					tag = "oof-ui-progress-bar-fill-material",
					size = UDim2.fromScale(1, 1),
				}),
			}),
		}),
	})
end

return ProgressBar
