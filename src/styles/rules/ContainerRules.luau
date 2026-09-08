--!strict

local Rule = require(script.Parent.Parent.Rule)

local ContainerRules = {}

function ContainerRules.install(sheet: StyleSheet)
	Rule.create(sheet, "Container", ".oof-ui-container", {
		BackgroundTransparency = "$CnOpacityClear",
		BorderSizePixel = 0,
	})
	Rule.create(sheet, "ContainerSurface", ".oof-ui-container-surface", {
		BackgroundColor3 = "$CnColorSurface",
		BackgroundTransparency = "$CnContainerSurfaceTransparency",
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 1),
		ZIndex = "$CnLayerBase",
	})
	Rule.create(sheet, "ContainerRaisedSurface", ".oof-ui-container-variant-raised >> .oof-ui-container-surface", {
		BackgroundColor3 = "$CnColorSurfaceRaised",
	})
	Rule.create(sheet, "ContainerMutedSurface", ".oof-ui-container-variant-muted >> .oof-ui-container-surface", {
		BackgroundColor3 = "$CnColorSurfaceHover",
	})
	Rule.create(sheet, "ContainerAccentSurface", ".oof-ui-container-variant-accent >> .oof-ui-container-surface", {
		BackgroundColor3 = "$CnColorSurfaceRaised",
		BackgroundTransparency = "$CnControlSecondarySurfaceTransparency",
	})
	Rule.create(
		sheet,
		"ContainerDestructiveSurface",
		".oof-ui-container-variant-destructive >> .oof-ui-container-surface",
		{
			BackgroundColor3 = "$CnColorDanger",
			BackgroundTransparency = "$CnControlDestructiveSurfaceTransparency",
		}
	)
	Rule.create(sheet, "ContainerGradient", ".oof-ui-container-gradient", {
		Enabled = "$CnContainerGradientEnabled",
		Color = "$CnContainerGradient",
		Rotation = 90,
	})
	Rule.create(sheet, "ContainerInset", ".oof-ui-container-inset", {
		BackgroundTransparency = "$CnOpacityClear",
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(6, 6),
		Visible = "$CnContainerInsetVisible",
		ZIndex = "$CnLayerContent",
	})
	Rule.create(sheet, "ContainerInsetCorner", ".oof-ui-container-inset-corner", {
		CornerRadius = "$CnContainerInsetCornerRadius",
	})
	Rule.create(sheet, "ContainerInsetStroke", ".oof-ui-container-inset-stroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = "$CnContainerInsetColor",
		Transparency = "$CnContainerInsetTransparency",
		Thickness = "$CnContainerInsetThickness",
	})
	Rule.create(sheet, "ContainerCorner", ".oof-ui-container-corner", {
		CornerRadius = "$CnRadiusLarge",
	})
	Rule.create(sheet, "ContainerStroke", ".oof-ui-container-stroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = "$CnContainerStrokeColor",
		Thickness = "$CnStrokeSubtle",
		Transparency = "$CnContainerStrokeTransparency",
	})
	Rule.create(
		sheet,
		"ContainerDestructiveStroke",
		".oof-ui-container-variant-destructive >> .oof-ui-container-stroke",
		{
			Color = "$CnColorDangerStrong",
		}
	)
	Rule.create(sheet, "ContainerMaterial", ".oof-ui-container-material", {
		Image = "$CnContainerMaterialImage",
		ImageColor3 = "$CnContainerMaterialColor",
		ImageTransparency = "$CnContainerMaterialTransparency",
		Position = UDim2.fromScale(0, 0),
		ScaleType = "$CnContainerMaterialScaleType",
		SliceCenter = "$CnContainerMaterialSliceCenter",
		SliceScale = "$CnContainerMaterialSliceScale",
		Visible = "$CnContainerMaterialVisible",
		ZIndex = "$CnLayerContent",
	})
	Rule.create(sheet, "ContainerAccentMaterial", ".oof-ui-container-variant-accent >> .oof-ui-container-material", {
		Image = "$CnControlSecondaryMaterialImage",
		ImageColor3 = "$CnControlSecondaryMaterialColor",
		ImageTransparency = "$CnControlSecondaryMaterialTransparency",
		ScaleType = "$CnControlSecondaryMaterialScaleType",
		SliceCenter = "$CnControlSecondaryMaterialSliceCenter",
		SliceScale = "$CnControlSecondaryMaterialSliceScale",
		Visible = "$CnControlSecondaryMaterialVisible",
	})
	Rule.create(
		sheet,
		"ContainerDestructiveMaterial",
		".oof-ui-container-variant-destructive >> .oof-ui-container-material",
		{
			Image = "$CnControlDestructiveMaterialImage",
			ImageColor3 = "$CnControlDestructiveMaterialColor",
			ImageTransparency = "$CnControlDestructiveMaterialTransparency",
			ScaleType = "$CnControlDestructiveMaterialScaleType",
			SliceCenter = "$CnControlDestructiveMaterialSliceCenter",
			SliceScale = "$CnControlDestructiveMaterialSliceScale",
			Visible = "$CnControlDestructiveMaterialVisible",
		}
	)
	Rule.create(sheet, "ContainerContent", ".oof-ui-container-content", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = "$CnOpacityClear",
		Size = UDim2.fromScale(1, 0),
		ZIndex = "$CnLayerModal",
	})
	Rule.create(sheet, "ContainerPadding", ".oof-ui-container-padding", {
		PaddingBottom = "$CnContainerPadding",
		PaddingLeft = "$CnContainerPadding",
		PaddingRight = "$CnContainerPadding",
		PaddingTop = "$CnContainerPadding",
	})
	Rule.create(sheet, "ContainerLayout", ".oof-ui-container-layout", {
		Padding = "$CnSpace3",
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
end

return ContainerRules
