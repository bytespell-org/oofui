--!strict

local Rule = require(script.Parent.Parent.Rule)

local TextFieldRules = {}

function TextFieldRules.install(sheet: StyleSheet)
	Rule.create(sheet, "TextField", ".oof-ui-text-field", {
		BackgroundTransparency = "$CnOpacityClear",
		BorderSizePixel = 0,
		Size = "$CnTextFieldSize",
	})
	local surface = Rule.create(sheet, "TextFieldSurface", ".oof-ui-text-field-surface", {
		BackgroundColor3 = "$CnColorSurface",
		BackgroundTransparency = "$CnTextFieldSurfaceTransparency",
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
	})
	Rule.transition(surface, {
		BackgroundColor3 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	})
	Rule.create(sheet, "TextFieldMultilineSurface", ".oof-ui-text-field-multiline >> .oof-ui-text-field-surface", {
		Size = UDim2.fromScale(1, 1),
	})
	Rule.create(sheet, "TextFieldMultiline", ".oof-ui-text-field-multiline", {
		Size = "$CnTextFieldMultilineSize",
	})
	Rule.create(sheet, "TextFieldCorner", ".oof-ui-text-field-corner", {
		CornerRadius = "$CnRadiusMedium",
	})
	local stroke = Rule.create(sheet, "TextFieldStroke", ".oof-ui-text-field-stroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = "$CnTextFieldStrokeColor",
		Thickness = "$CnStrokeSubtle",
		Transparency = "$CnTextFieldStrokeTransparency",
	})
	Rule.transition(stroke, {
		Color = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		Thickness = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	})
	Rule.create(sheet, "TextFieldMaterial", ".oof-ui-text-field-material", {
		Image = "$CnTextFieldMaterialImage",
		ImageColor3 = "$CnTextFieldMaterialColor",
		ImageTransparency = "$CnTextFieldMaterialTransparency",
		Position = UDim2.fromScale(0, 0),
		ScaleType = "$CnTextFieldMaterialScaleType",
		SliceCenter = "$CnTextFieldMaterialSliceCenter",
		SliceScale = "$CnTextFieldMaterialSliceScale",
		Visible = "$CnTextFieldMaterialVisible",
		ZIndex = "$CnLayerSurface",
	})
	Rule.create(sheet, "TextFieldInput", ".oof-ui-text-field-input", {
		BackgroundTransparency = "$CnOpacityClear",
		BorderSizePixel = 0,
		ClearTextOnFocus = false,
		Font = "$CnFontRegular",
		PlaceholderColor3 = "$CnColorSubtext",
		Size = UDim2.fromScale(1, 1),
		TextColor3 = "$CnColorText",
		TextSize = "$CnTextBody",
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextWrapped = false,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		ZIndex = "$CnLayerContent",
	})
	Rule.create(sheet, "TextFieldMultilineInput", ".oof-ui-text-field-multiline >> .oof-ui-text-field-input", {
		TextTruncate = Enum.TextTruncate.None,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
	})
	Rule.create(sheet, "TextFieldInputPadding", ".oof-ui-text-field-input-padding", {
		PaddingBottom = "$CnSpace3",
		PaddingLeft = "$CnSpace3",
		PaddingRight = "$CnSpace3",
		PaddingTop = "$CnSpace3",
	})
	Rule.create(sheet, "TextFieldFocusedSurface", ".oof-ui-text-field-focused >> .oof-ui-text-field-surface", {
		BackgroundColor3 = "$CnColorSurfaceRaised",
	})
	Rule.create(sheet, "TextFieldFocusedStroke", ".oof-ui-text-field-focused >> .oof-ui-text-field-stroke", {
		Color = "$CnColorAccent",
		Thickness = "$CnStrokeStrong",
		Transparency = "$CnOpacityOpaque",
	})
	Rule.create(sheet, "TextFieldInvalidStroke", ".oof-ui-text-field-invalid >> .oof-ui-text-field-stroke", {
		Color = "$CnColorDanger",
		Thickness = "$CnStrokeStrong",
		Transparency = "$CnOpacityOpaque",
	})
	Rule.create(sheet, "TextFieldReadOnlySurface", ".oof-ui-text-field-read-only >> .oof-ui-text-field-surface", {
		BackgroundColor3 = "$CnColorSurfaceRaised",
	})
	Rule.create(sheet, "TextFieldReadOnlyInput", ".oof-ui-text-field-read-only >> .oof-ui-text-field-input", {
		TextColor3 = "$CnColorSubtext",
	})
	Rule.create(sheet, "TextFieldDisabledSurface", ".oof-ui-text-field-disabled >> .oof-ui-text-field-surface", {
		BackgroundColor3 = "$CnColorDisabledSurface",
		BackgroundTransparency = 0,
	})
	Rule.create(sheet, "TextFieldDisabledStroke", ".oof-ui-text-field-disabled >> .oof-ui-text-field-stroke", {
		Transparency = "$CnOpacityDisabled",
	})
	Rule.create(sheet, "TextFieldDisabledMaterial", ".oof-ui-text-field-disabled >> .oof-ui-text-field-material", {
		ImageTransparency = "$CnTextFieldMaterialDisabledTransparency",
	})
	Rule.create(sheet, "TextFieldDisabledInput", ".oof-ui-text-field-disabled >> .oof-ui-text-field-input", {
		TextColor3 = "$CnColorDisabledText",
		TextTransparency = 0,
	})
end

return TextFieldRules
