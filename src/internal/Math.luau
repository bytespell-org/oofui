--!strict

local Math = {}

function Math.normalize(value: number?, minimum: number?, maximum: number?): number
	local minValue = minimum or 0
	local maxValue = maximum or 1
	local actual = value or minValue
	local range = maxValue - minValue
	if range <= 0 then
		return 0
	end
	return math.clamp((actual - minValue) / range, 0, 1)
end

function Math.clampAndSnap(value: number, minimum: number, maximum: number, step: number?): number
	local low = math.min(minimum, maximum)
	local high = math.max(minimum, maximum)
	local actualStep = math.max(step or 0, 0)
	local clamped = math.clamp(value, low, high)
	if actualStep <= 0 then
		return clamped
	end
	local snapped = low + math.round((clamped - low) / actualStep) * actualStep
	return math.clamp(snapped, low, high)
end

function Math.valueFromFraction(
	fraction: number,
	minimum: number,
	maximum: number,
	step: number?,
	reversed: boolean?
): number
	local normalized = math.clamp(fraction, 0, 1)
	if reversed == true then
		normalized = 1 - normalized
	end
	return Math.clampAndSnap(minimum + (maximum - minimum) * normalized, minimum, maximum, step)
end

return Math
