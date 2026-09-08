--!strict

-- One semantic palette supplies the native component recipes. Fill and ink
-- roles stay separate: a colorful control fill is not necessarily readable text.
export type Palette = {
	canvas: Color3,
	surface: Color3,
	raised: Color3,
	hover: Color3,
	press: Color3,
	border: Color3,
	borderStrong: Color3,
	ink: Color3,
	muted: Color3,
	accent: Color3,
	accentPress: Color3,
	accentHover: Color3,
	onAccent: Color3,
	success: Color3,
	successInk: Color3,
	warning: Color3,
	warningInk: Color3,
	danger: Color3,
	dangerPress: Color3,
	dangerHover: Color3,
	dangerInk: Color3,
	disabled: Color3,
	focus: Color3,
	backdrop: Color3,
}

local roles = {
	canvas = "CnColorCanvas",
	surface = "CnColorSurface",
	raised = "CnColorSurfaceRaised",
	hover = "CnColorSurfaceHover",
	press = "CnColorSurfacePress",
	border = "CnColorBorder",
	borderStrong = "CnColorBorderStrong",
	ink = "CnColorText",
	muted = "CnColorSubtext",
	accent = "CnColorAccent",
	accentPress = "CnColorAccentStrong",
	accentHover = "CnColorAccentHover",
	onAccent = "CnColorOnAccent",
	success = "CnColorSuccess",
	successInk = "CnColorTextSuccess",
	warning = "CnColorWarning",
	warningInk = "CnColorTextWarning",
	danger = "CnColorDanger",
	dangerPress = "CnColorDangerStrong",
	dangerHover = "CnColorDangerHover",
	dangerInk = "CnColorTextDanger",
	disabled = "CnColorDisabled",
	focus = "CnColorFocus",
	backdrop = "CnColorBackdrop",
}
local aliases = {
	CnColorDisabledSurface = "raised",
	CnColorDisabledText = "muted",
	CnBadgeColor = "danger",
	CnBadgeTextColor = "onAccent",
	CnBadgeStrokeColor = "canvas",
	CnSeparatorTrackColor = "border",
	CnSwitchInvalidStrokeColor = "danger",
	CnContainerStrokeColor = "border",
	CnContainerAccentTextColor = "ink",
	CnTextFieldStrokeColor = "border",
	CnColorAccentEdge = "accent",
	CnButtonSecondaryTextColor = "ink",
	CnProgressTrackColor = "raised",
	CnProgressTrackStrokeColor = "borderStrong",
	CnProgressFillColor = "accent",
	CnProgressFillStrokeColor = "accentPress",
	CnSwitchTrackColor = "hover",
	CnSwitchTrackCheckedColor = "accent",
	CnSwitchTrackHoverColor = "raised",
	CnSwitchTrackCheckedHoverColor = "accentHover",
	CnSwitchTrackPressColor = "press",
	CnSwitchTrackCheckedPressColor = "accentPress",
	CnSwitchTrackStrokeColor = "borderStrong",
	CnSwitchTrackCheckedStrokeColor = "accent",
	CnSwitchThumbColor = "ink",
	CnSwitchThumbCheckedColor = "onAccent",
	CnSwitchThumbStrokeColor = "ink",
	CnSwitchThumbCheckedStrokeColor = "onAccent",
	CnRadioDotColor = "accent",
	CnRadioDotStrokeColor = "accentPress",
	CnRadialTrackColor = "hover",
	CnRadialFillColor = "accent",
	CnRadialCompleteColor = "success",
	CnRadialEdgeColor = "accent",
	CnRadialCenterColor = "surface",
	CnRadialCenterStrokeColor = "borderStrong",
	CnRadialTipColor = "onAccent",
	CnRadialTipStrokeColor = "accent",
}
local gradients = {
	CnProgressTrackGradient = "raised",
	CnSwitchTrackGradient = "hover",
	CnSwitchTrackCheckedGradient = "accent",
	CnSwitchThumbGradient = "ink",
	CnSwitchThumbCheckedGradient = "onAccent",
	CnRadioDotGradient = "accent",
	CnRadialTrackGradient = "hover",
	CnRadialFillGradient = "accent",
	CnRadialCompleteGradient = "success",
}

local Palette = {}
function Palette.create(colors: Palette): { [string]: any }
	local tokens: { [string]: any } = {}
	for role, token in roles do
		assert(typeof((colors :: any)[role]) == "Color3", "Palette needs Color3 role " .. role)
		tokens[token] = (colors :: any)[role]
	end
	for role in colors do
		assert((roles :: any)[role] ~= nil, "Unknown palette role " .. role)
	end
	for token, role in aliases do
		tokens[token] = (colors :: any)[role]
	end
	for token, role in gradients do
		tokens[token] = ColorSequence.new((colors :: any)[role])
	end
	tokens.CnAccentGradient = ColorSequence.new(colors.accentHover, colors.accentPress)
	tokens.CnProgressFillGradient = tokens.CnAccentGradient
	return tokens
end
return Palette
