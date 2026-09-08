--!strict

local tokens = require(script.Parent.Parent.Palette).create({
	canvas = Color3.fromRGB(247, 248, 251),
	surface = Color3.fromRGB(255, 255, 255),
	raised = Color3.fromRGB(240, 242, 247),
	hover = Color3.fromRGB(221, 225, 234),
	press = Color3.fromRGB(204, 209, 220),
	border = Color3.fromRGB(221, 225, 234),
	borderStrong = Color3.fromRGB(204, 209, 220),
	ink = Color3.fromRGB(24, 27, 34),
	muted = Color3.fromRGB(91, 98, 114),
	accent = Color3.fromRGB(105, 76, 246),
	accentPress = Color3.fromRGB(78, 51, 205),
	accentHover = Color3.fromRGB(115, 84, 244),
	onAccent = Color3.fromRGB(255, 255, 255),
	success = Color3.fromRGB(22, 145, 94),
	successInk = Color3.fromRGB(20, 107, 69),
	warning = Color3.fromRGB(190, 123, 13),
	warningInk = Color3.fromRGB(136, 83, 4),
	danger = Color3.fromRGB(214, 54, 69),
	dangerPress = Color3.fromRGB(166, 35, 49),
	dangerHover = Color3.fromRGB(205, 53, 69),
	dangerInk = Color3.fromRGB(174, 31, 49),
	disabled = Color3.fromRGB(169, 174, 187),
	focus = Color3.fromRGB(28, 119, 235),
	backdrop = Color3.fromRGB(20, 23, 30),
})
tokens.CnProgressFillGradient = ColorSequence.new(Color3.fromRGB(130, 101, 255), Color3.fromRGB(82, 55, 211))
tokens.CnAccentGradient = ColorSequence.new(Color3.fromRGB(130, 101, 255), Color3.fromRGB(82, 55, 211))
tokens.CnControlHighlightGradient = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(225, 219, 255))
-- UIGradient multiplies its parent color; keep the surface neutral.
tokens.CnProgressFillColor = Color3.new(1, 1, 1)
return tokens
