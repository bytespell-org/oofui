--!strict

local tokens = require(script.Parent.Parent.Palette).create({
	canvas = Color3.fromRGB(10, 12, 18),
	surface = Color3.fromRGB(24, 27, 34),
	raised = Color3.fromRGB(34, 38, 48),
	hover = Color3.fromRGB(45, 51, 64),
	press = Color3.fromRGB(18, 20, 26),
	border = Color3.fromRGB(45, 51, 64),
	borderStrong = Color3.fromRGB(18, 20, 26),
	ink = Color3.fromRGB(247, 248, 252),
	muted = Color3.fromRGB(176, 183, 201),
	accent = Color3.fromRGB(65, 86, 204),
	accentPress = Color3.fromRGB(47, 66, 178),
	accentHover = Color3.fromRGB(79, 100, 222),
	onAccent = Color3.fromRGB(255, 255, 255),
	success = Color3.fromRGB(62, 201, 138),
	successInk = Color3.fromRGB(62, 201, 138),
	warning = Color3.fromRGB(244, 181, 66),
	warningInk = Color3.fromRGB(244, 181, 66),
	danger = Color3.fromRGB(188, 46, 65),
	dangerPress = Color3.fromRGB(146, 30, 44),
	dangerHover = Color3.fromRGB(202, 55, 72),
	dangerInk = Color3.fromRGB(247, 105, 115),
	disabled = Color3.fromRGB(102, 108, 124),
	focus = Color3.fromRGB(255, 218, 92),
	backdrop = Color3.fromRGB(5, 6, 9),
})
tokens.CnSwitchTrackStrokeColor = Color3.fromRGB(45, 51, 64)
tokens.CnControlHighlightGradient = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(220, 228, 255))
-- UIGradient multiplies its parent color; keep the surface neutral.
tokens.CnProgressFillColor = Color3.new(1, 1, 1)
return tokens
