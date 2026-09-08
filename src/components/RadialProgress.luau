--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)
local Math = require(script.Parent.Parent.internal.Math)
local Tags = require(script.Parent.Parent.internal.Tags)
local useReducedMotion = require(script.Parent.Parent.internal.useReducedMotion)

local React = Dependencies.React
local e = React.createElement
local RunService = game:GetService("RunService")

export type Props = {
	value: number?,
	minimum: number?,
	maximum: number?,
	startAngle: number?,
	direction: "clockwise" | "counterclockwise"?,
	indeterminate: boolean?,
	showTrack: boolean?,
	children: any?,
	layoutOrder: number?,
	tag: string?,
	rootRef: any?,
}

local CENTER = Vector2.new(0.5, 0.5)
local RADIUS = 0.42

local function tangentFor(angleRadians: number, magnitude: number, direction: number): Vector2
	return Vector2.new(-math.sin(angleRadians), math.cos(angleRadians)) * magnitude * direction
end

local function arcControlPoints(startAngle: number, sweepAngle: number): { Path2DControlPoint }
	local segmentCount = math.max(1, math.ceil(math.abs(sweepAngle) / 90))
	local segmentSweep = sweepAngle / segmentCount
	local segmentRadians = math.rad(segmentSweep)
	local direction = if segmentSweep >= 0 then 1 else -1
	local tangentMagnitude = (4 / 3) * math.tan(math.abs(segmentRadians) / 4) * RADIUS
	local points: { Path2DControlPoint } = {}

	for index = 0, segmentCount do
		local angle = math.rad(startAngle + segmentSweep * index)
		local point = CENTER + Vector2.new(math.cos(angle), math.sin(angle)) * RADIUS
		local tangent = tangentFor(angle, tangentMagnitude, direction)
		local leftTangent = if index > 0 then -tangent else Vector2.zero
		local rightTangent = if index < segmentCount then tangent else Vector2.zero
		points[index + 1] = Path2DControlPoint.new(
			UDim2.fromScale(point.X, point.Y),
			UDim2.fromScale(leftTangent.X, leftTangent.Y),
			UDim2.fromScale(rightTangent.X, rightTangent.Y)
		)
	end

	return points
end

local function setArc(path: Path2D?, startAngle: number, sweepAngle: number)
	if path == nil then
		return
	end
	path:SetControlPoints(arcControlPoints(startAngle, sweepAngle))
end

local function setTip(tip: Frame?, angleDegrees: number)
	if tip == nil then
		return
	end
	local angle = math.rad(angleDegrees)
	local point = CENTER + Vector2.new(math.cos(angle), math.sin(angle)) * RADIUS
	tip.Position = UDim2.fromScale(point.X, point.Y)
end

local function RadialProgress(props: Props): any
	local minimum = props.minimum or 0
	local maximum = props.maximum or 1
	local startAngle = props.startAngle or -90
	local direction = props.direction or "clockwise"
	local directionMultiplier = if direction == "clockwise" then 1 else -1
	local fraction = Math.normalize(props.value or minimum, minimum, maximum)
	local indeterminate = props.indeterminate == true
	local reducedMotion = useReducedMotion()
	local trackEdgeRef = React.useRef(nil :: Path2D?)
	local trackRef = React.useRef(nil :: Path2D?)
	local fillEdgeRef = React.useRef(nil :: Path2D?)
	local fillRef = React.useRef(nil :: Path2D?)
	local tipRef = React.useRef(nil :: Frame?)

	React.useEffect(function()
		setArc(trackEdgeRef.current, startAngle, 360 * directionMultiplier)
		setArc(trackRef.current, startAngle, 360 * directionMultiplier)
	end, { directionMultiplier, startAngle })

	React.useEffect(function()
		if indeterminate then
			return nil
		end
		if fraction > 0 then
			local sweep = 360 * fraction * directionMultiplier
			setArc(fillEdgeRef.current, startAngle, sweep)
			setArc(fillRef.current, startAngle, sweep)
			setTip(tipRef.current, startAngle + sweep)
		end
		return nil
	end, { directionMultiplier, fraction, indeterminate, startAngle })

	React.useEffect(function()
		if not indeterminate then
			return nil
		end

		if reducedMotion then
			setArc(fillEdgeRef.current, startAngle, 90 * directionMultiplier)
			setArc(fillRef.current, startAngle, 90 * directionMultiplier)
			setTip(tipRef.current, startAngle + 90 * directionMultiplier)
			return nil
		end

		local startedAt = os.clock()
		local connection = RunService.Heartbeat:Connect(function()
			local rotation = ((os.clock() - startedAt) * 180) % 360
			local animatedStart = startAngle + rotation * directionMultiplier
			local sweep = 90 * directionMultiplier
			setArc(fillEdgeRef.current, animatedStart, sweep)
			setArc(fillRef.current, animatedStart, sweep)
			setTip(tipRef.current, animatedStart + sweep)
		end)
		return function()
			connection:Disconnect()
		end
	end, { directionMultiplier, indeterminate, reducedMotion, startAngle })

	return e("Frame", {
		[React.Tag] = Tags.join(
			"oof-ui-radial-progress",
			"oof-ui-radial-progress-" .. direction,
			Tags.when(indeterminate, "oof-ui-radial-progress-indeterminate"),
			Tags.when(fraction >= 1, "oof-ui-radial-progress-complete"),
			props.tag
		),
		ref = props.rootRef,
		LayoutOrder = props.layoutOrder,
	}, {
		AspectRatio = e("UIAspectRatioConstraint", {
			AspectRatio = 1,
			AspectType = Enum.AspectType.FitWithinMaxSize,
		}),
		TrackEdge = if props.showTrack ~= false
			then e("Path2D", {
				[React.Tag] = "oof-ui-radial-progress-track-edge",
				ref = trackEdgeRef,
				Closed = false,
			})
			else nil,
		Track = if props.showTrack ~= false
			then e("Path2D", {
				[React.Tag] = "oof-ui-radial-progress-track",
				ref = trackRef,
				Closed = false,
			}, {
				Gradient = e("UIGradient", { [React.Tag] = "oof-ui-radial-progress-track-gradient" }),
			})
			else nil,
		FillEdge = e("Path2D", {
			[React.Tag] = "oof-ui-radial-progress-fill-edge",
			ref = fillEdgeRef,
			Closed = false,
			Visible = indeterminate or fraction > 0,
		}),
		Fill = e("Path2D", {
			[React.Tag] = "oof-ui-radial-progress-fill",
			ref = fillRef,
			Closed = false,
			Visible = indeterminate or fraction > 0,
		}, {
			Gradient = e("UIGradient", { [React.Tag] = "oof-ui-radial-progress-fill-gradient" }),
		}),
		Center = e("Frame", { [React.Tag] = "oof-ui-radial-progress-center" }, {
			Surface = e("Frame", { [React.Tag] = "oof-ui-radial-progress-center-surface" }, {
				Corner = e("UICorner", { [React.Tag] = "oof-ui-radial-progress-center-corner" }),
				Stroke = e("UIStroke", { [React.Tag] = "oof-ui-radial-progress-center-stroke" }),
			}),
			Content = e("Frame", { [React.Tag] = "oof-ui-radial-progress-center-content" }, props.children),
		}),
		TipPosition = e("Frame", {
			[React.Tag] = "oof-ui-radial-progress-tip-position",
			ref = tipRef,
			Visible = indeterminate or fraction > 0,
		}, {
			Gem = e("Frame", { [React.Tag] = "oof-ui-radial-progress-tip" }, {
				Corner = e("UICorner", { [React.Tag] = "oof-ui-radial-progress-tip-corner" }),
				Stroke = e("UIStroke", { [React.Tag] = "oof-ui-radial-progress-tip-stroke" }),
			}),
		}),
	})
end

return RadialProgress
