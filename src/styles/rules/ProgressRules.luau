--!strict

local Rule = require(script.Parent.Parent.Rule)

local ProgressRules = {}

function ProgressRules.install(sheet: StyleSheet)
	Rule.create(sheet, "ProgressBar", ".oof-ui-progress-bar", {
		BackgroundTransparency = "$CnOpacityClear",
		BorderSizePixel = 0,
		Size = "$CnProgressSizeHorizontal",
	})
	Rule.create(sheet, "ProgressBarHorizontal", ".oof-ui-progress-bar-horizontal", {
		Size = "$CnProgressSizeHorizontal",
	})
	Rule.create(sheet, "ProgressBarVertical", ".oof-ui-progress-bar-vertical", {
		Size = "$CnProgressSizeVertical",
	})
	Rule.create(sheet, "ProgressTrack", ".oof-ui-progress-bar-track", {
		BackgroundColor3 = "$CnProgressTrackColor",
		BackgroundTransparency = "$CnProgressTrackSurfaceTransparency",
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = "$CnLayerBase",
	})
	Rule.create(sheet, "ProgressTrackCorner", ".oof-ui-progress-bar-track-corner", {
		CornerRadius = "$CnProgressCornerRadius",
	})
	Rule.create(sheet, "ProgressTrackStroke", ".oof-ui-progress-bar-track-stroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = "$CnProgressTrackStrokeColor",
		Thickness = "$CnProgressTrackStrokeThickness",
		Transparency = "$CnProgressTrackStrokeTransparency",
	})
	Rule.create(sheet, "ProgressTrackGradient", ".oof-ui-progress-bar-track-gradient", {
		Color = "$CnProgressTrackGradient",
		Enabled = "$CnProgressTrackGradientEnabled",
		Rotation = 90,
	})
	Rule.create(sheet, "ProgressTrackMaterial", ".oof-ui-progress-bar-track-material", {
		Image = "$CnProgressTrackMaterialImage",
		ImageColor3 = "$CnProgressTrackMaterialColor",
		ImageTransparency = "$CnProgressTrackMaterialTransparency",
		ScaleType = "$CnProgressTrackMaterialScaleType",
		SliceCenter = "$CnProgressTrackMaterialSliceCenter",
		SliceScale = "$CnProgressTrackMaterialSliceScale",
		Visible = "$CnProgressTrackMaterialVisible",
		ZIndex = "$CnLayerSurface",
	})
	Rule.create(sheet, "ProgressFill", ".oof-ui-progress-bar-fill", {
		BackgroundColor3 = "$CnProgressFillColor",
		BackgroundTransparency = "$CnProgressFillSurfaceTransparency",
		BorderSizePixel = 0,
		ZIndex = "$CnLayerSurface",
	})
	Rule.create(sheet, "ProgressFillCorner", ".oof-ui-progress-bar-fill-corner", {
		CornerRadius = "$CnProgressCornerRadius",
	})
	Rule.create(sheet, "ProgressFillStroke", ".oof-ui-progress-bar-fill-stroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = "$CnProgressFillStrokeColor",
		Thickness = "$CnProgressFillStrokeThickness",
		Transparency = "$CnProgressFillStrokeTransparency",
	})
	Rule.create(sheet, "ProgressFillGradient", ".oof-ui-progress-bar-fill-gradient", {
		Color = "$CnProgressFillGradient",
		Enabled = "$CnProgressFillGradientEnabled",
		Rotation = 90,
	})
	Rule.create(sheet, "ProgressFillMaterial", ".oof-ui-progress-bar-fill-material", {
		Image = "$CnProgressFillMaterialImage",
		ImageColor3 = "$CnProgressFillMaterialColor",
		ImageTransparency = "$CnProgressFillMaterialTransparency",
		ScaleType = "$CnProgressFillMaterialScaleType",
		SliceCenter = "$CnProgressFillMaterialSliceCenter",
		SliceScale = "$CnProgressFillMaterialSliceScale",
		Visible = "$CnProgressFillMaterialVisible",
		ZIndex = "$CnLayerContent",
	})
end

return ProgressRules
