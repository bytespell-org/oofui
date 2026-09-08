--!strict

local Rule = require(script.Parent.Parent.Rule)

local AdvancedRules = {}

local function installRadialProgress(sheet: StyleSheet)
	Rule.create(sheet, "RadialProgress", ".oof-ui-radial-progress", {
		BackgroundTransparency = "$CnOpacityClear",
		BorderSizePixel = 0,
		Size = "$CnRadialSize",
	})
	Rule.create(sheet, "RadialProgressTrackEdge", ".oof-ui-radial-progress-track-edge", {
		Color3 = "$CnRadialEdgeColor",
		Thickness = "$CnRadialEdgeThickness",
		Visible = "$CnRadialEdgeVisible",
		ZIndex = "$CnLayerBase",
	})
	Rule.create(sheet, "RadialProgressTrack", ".oof-ui-radial-progress-track", {
		Color3 = "$CnRadialTrackColor",
		Thickness = "$CnRadialTrackThickness",
		Transparency = "$CnOpacityOpaque",
		ZIndex = "$CnLayerSurface",
	})
	Rule.create(sheet, "RadialProgressTrackGradient", ".oof-ui-radial-progress-track-gradient", {
		Color = "$CnRadialTrackGradient",
		Enabled = "$CnRadialTrackGradientEnabled",
		Rotation = 90,
	})
	Rule.create(sheet, "RadialProgressFillEdge", ".oof-ui-radial-progress-fill-edge", {
		Color3 = "$CnRadialEdgeColor",
		Thickness = "$CnRadialEdgeThickness",
		Visible = "$CnRadialEdgeVisible",
		ZIndex = "$CnLayerSurface",
	})
	Rule.create(sheet, "RadialProgressFill", ".oof-ui-radial-progress-fill", {
		Color3 = "$CnRadialFillColor",
		Thickness = "$CnRadialFillThickness",
		Transparency = "$CnOpacityOpaque",
		ZIndex = "$CnLayerContent",
	})
	Rule.create(sheet, "RadialProgressFillGradient", ".oof-ui-radial-progress-fill-gradient", {
		Color = "$CnRadialFillGradient",
		Enabled = "$CnRadialFillGradientEnabled",
		Rotation = 90,
	})
	Rule.create(sheet, "RadialProgressComplete", ".oof-ui-radial-progress-complete >> .oof-ui-radial-progress-fill", {
		Color3 = "$CnRadialCompleteColor",
	})
	Rule.create(
		sheet,
		"RadialProgressCompleteGradient",
		".oof-ui-radial-progress-complete >> .oof-ui-radial-progress-fill-gradient",
		{ Color = "$CnRadialCompleteGradient" }
	)
	Rule.create(
		sheet,
		"RadialProgressCompleteEdge",
		".oof-ui-radial-progress-complete >> .oof-ui-radial-progress-fill-edge",
		{ Color3 = "$CnRadialEdgeColor" }
	)
	Rule.create(sheet, "RadialProgressCenter", ".oof-ui-radial-progress-center", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = "$CnOpacityClear",
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = "$CnRadialCenterSize",
		ZIndex = "$CnLayerSurface",
	})
	Rule.create(sheet, "RadialProgressCenterSurface", ".oof-ui-radial-progress-center-surface", {
		BackgroundColor3 = "$CnRadialCenterColor",
		BackgroundTransparency = "$CnRadialCenterTransparency",
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 1),
		ZIndex = "$CnLayerSurface",
	})
	Rule.create(sheet, "RadialProgressCenterCorner", ".oof-ui-radial-progress-center-corner", {
		CornerRadius = "$CnRadiusPill",
	})
	Rule.create(sheet, "RadialProgressCenterStroke", ".oof-ui-radial-progress-center-stroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = "$CnRadialCenterStrokeColor",
		Thickness = "$CnRadialCenterStrokeThickness",
		Transparency = "$CnRadialCenterStrokeTransparency",
	})
	Rule.create(sheet, "RadialProgressCenterContent", ".oof-ui-radial-progress-center-content", {
		BackgroundTransparency = "$CnOpacityClear",
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 1),
		ZIndex = "$CnLayerContent",
	})
	Rule.create(sheet, "RadialProgressTipPosition", ".oof-ui-radial-progress-tip-position", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = "$CnOpacityClear",
		BorderSizePixel = 0,
		Size = "$CnRadialTipSize",
		ZIndex = "$CnLayerContent",
	})
	Rule.create(sheet, "RadialProgressTip", ".oof-ui-radial-progress-tip", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = "$CnRadialTipColor",
		BackgroundTransparency = "$CnOpacityOpaque",
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Rotation = 45,
		Size = UDim2.fromScale(0.72, 0.72),
		Visible = "$CnRadialTipVisible",
		ZIndex = "$CnLayerContent",
	})
	Rule.create(sheet, "RadialProgressTipCorner", ".oof-ui-radial-progress-tip-corner", {
		CornerRadius = UDim.new(0, 2),
	})
	Rule.create(sheet, "RadialProgressTipStroke", ".oof-ui-radial-progress-tip-stroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = "$CnRadialTipStrokeColor",
		Thickness = "$CnRadialTipStrokeThickness",
		Transparency = "$CnOpacityOpaque",
	})
end

local function installHoldButton(sheet: StyleSheet)
	Rule.create(sheet, "HoldButton", ".oof-ui-hold-button", {
		AutoButtonColor = false,
	})
	Rule.create(sheet, "HoldButtonHoldingSurface", ".oof-ui-hold-button-holding >> .oof-ui-button-surface", {
		BackgroundColor3 = "$CnColorAccentHover",
	})
	for _, state in { { "complete", "Success" }, { "cancelled", "Warning" } } do
		local selector = ".oof-ui-hold-button.oof-ui-hold-button-" .. state[1]
		local ink = "$CnColorText" .. state[2]
		Rule.create(sheet, "Hold" .. state[2] .. "Surface", selector .. " >> .oof-ui-button-surface", {
			BackgroundColor3 = "$CnColorSurface",
			BackgroundTransparency = 0,
		})
		Rule.create(sheet, "Hold" .. state[2] .. "Label", selector .. " >> .oof-ui-button-label", { TextColor3 = ink })
		Rule.create(
			sheet,
			"Hold" .. state[2] .. "Icon",
			selector .. " >> .oof-ui-button-leading-icon",
			{ ImageColor3 = ink }
		)
		Rule.create(
			sheet,
			"Hold" .. state[2] .. "Stroke",
			selector .. " >> .oof-ui-button-stroke",
			{ Color = ink, Transparency = 0 }
		)
		Rule.create(
			sheet,
			"Hold" .. state[2] .. "Material",
			selector .. " >> .oof-ui-button-material",
			{ Visible = false }
		)
		Rule.create(
			sheet,
			"Hold" .. state[2] .. "Gradient",
			selector .. " >> .oof-ui-button-gradient",
			{ Enabled = false }
		)
	end
	Rule.create(sheet, "HoldButtonLinearProgress", ".oof-ui-hold-button-linear-progress", {
		AnchorPoint = Vector2.new(0, 1),
		Position = "$CnHoldLinearProgressPosition",
		Size = "$CnHoldLinearProgressSize",
		ZIndex = "$CnLayerContent",
	})
	Rule.create(sheet, "HoldButtonRadialProgress", ".oof-ui-hold-button-radial-progress", {
		AnchorPoint = Vector2.zero,
		Position = UDim2.fromScale(0, 0),
		Size = "$CnHoldRadialSize",
		ZIndex = "$CnLayerContent",
	})
end

function AdvancedRules.install(sheet: StyleSheet)
	installRadialProgress(sheet)
	installHoldButton(sheet)
end

return AdvancedRules
