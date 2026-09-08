--!strict

local Rule = require(script.Parent.Parent.Rule)

local SelectionRules = {}

local function installCheckbox(sheet: StyleSheet)
	local checkbox = Rule.create(sheet, "Checkbox", ".oof-ui-checkbox", {
		AutoButtonColor = false,
		BackgroundColor3 = "$CnColorSurface",
		BackgroundTransparency = "$CnCheckboxSurfaceTransparency",
		BorderSizePixel = 0,
		Size = "$CnCheckboxSize",
	})
	Rule.transition(checkbox, {
		BackgroundColor3 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	})
	Rule.create(sheet, "CheckboxCorner", ".oof-ui-checkbox-corner", { CornerRadius = "$CnRadiusSmall" })
	local stroke = Rule.create(sheet, "CheckboxStroke", ".oof-ui-checkbox-stroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = "$CnColorBorder",
		Thickness = "$CnStrokeSubtle",
		Transparency = "$CnCheckboxStrokeTransparency",
	})
	Rule.transition(stroke, {
		Color = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		Thickness = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	})
	local material = Rule.create(sheet, "CheckboxMaterial", ".oof-ui-checkbox >> .oof-ui-checkbox-material", {
		Image = "$CnCheckboxMaterialImage",
		ImageColor3 = "$CnCheckboxMaterialColor",
		ImageTransparency = "$CnCheckboxMaterialTransparency",
		ScaleType = "$CnCheckboxMaterialScaleType",
		SliceCenter = "$CnCheckboxMaterialSliceCenter",
		SliceScale = "$CnCheckboxMaterialSliceScale",
		Visible = "$CnCheckboxMaterialVisible",
		ZIndex = "$CnLayerSurface",
	})
	Rule.transition(material, {
		ImageColor3 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		ImageTransparency = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	})
	Rule.create(sheet, "CheckboxMark", ".oof-ui-checkbox-mark", {
		BackgroundTransparency = "$CnOpacityClear",
		Font = "$CnFontStrong",
		Size = UDim2.fromScale(1, 1),
		TextColor3 = "$CnColorOnAccent",
		TextSize = "$CnCheckboxMarkTextSize",
		ZIndex = "$CnLayerContent",
	})
	Rule.create(sheet, "CheckboxFocus", ".oof-ui-checkbox-focus-stroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = "$CnColorFocus",
		Thickness = "$CnStrokeFocus",
		Transparency = "$CnOpacityFocusHidden",
	})
	Rule.create(sheet, "CheckboxChecked", ".oof-ui-checkbox-checked, .oof-ui-checkbox-indeterminate", {
		BackgroundColor3 = "$CnColorAccent",
	})
	Rule.create(
		sheet,
		"CheckboxCheckedMaterial",
		".oof-ui-checkbox-checked >> .oof-ui-checkbox-material, .oof-ui-checkbox-indeterminate >> .oof-ui-checkbox-material",
		{
			Image = "$CnCheckboxCheckedMaterialImage",
		}
	)
	Rule.create(
		sheet,
		"CheckboxCheckedStroke",
		".oof-ui-checkbox-checked >> .oof-ui-checkbox-stroke, .oof-ui-checkbox-indeterminate >> .oof-ui-checkbox-stroke",
		{
			Color = "$CnColorAccentEdge",
		}
	)
	Rule.create(sheet, "CheckboxInvalidMaterial", ".oof-ui-checkbox-invalid >> .oof-ui-checkbox-material", {
		Image = "$CnCheckboxInvalidMaterialImage",
		ImageColor3 = "$CnCheckboxInvalidMaterialColor",
		ScaleType = "$CnCheckboxInvalidMaterialScaleType",
		SliceCenter = "$CnCheckboxInvalidMaterialSliceCenter",
		SliceScale = "$CnCheckboxInvalidMaterialSliceScale",
	})
	Rule.create(sheet, "CheckboxHover", ".oof-ui-checkbox:Hover", {
		BackgroundColor3 = "$CnColorSurfaceRaised",
	})
	Rule.create(sheet, "CheckboxMaterialHover", ".oof-ui-checkbox:Hover >> .oof-ui-checkbox-material", {
		ImageColor3 = "$CnCheckboxMaterialHoverColor",
	})
	Rule.create(
		sheet,
		"CheckboxInvalidMaterialHover",
		".oof-ui-checkbox-invalid:Hover >> .oof-ui-checkbox-material",
		{ ImageColor3 = "$CnCheckboxInvalidMaterialHoverColor" }
	)
	Rule.create(sheet, "CheckboxCheckedHover", ".oof-ui-checkbox-checked:Hover, .oof-ui-checkbox-indeterminate:Hover", {
		BackgroundColor3 = "$CnColorAccentHover",
	})
	Rule.create(sheet, "CheckboxPress", ".oof-ui-checkbox:Press", {
		BackgroundColor3 = "$CnColorSurfacePress",
	})
	Rule.create(sheet, "CheckboxMaterialPress", ".oof-ui-checkbox:Press >> .oof-ui-checkbox-material", {
		ImageColor3 = "$CnCheckboxMaterialPressColor",
	})
	Rule.create(
		sheet,
		"CheckboxInvalidMaterialPress",
		".oof-ui-checkbox-invalid:Press >> .oof-ui-checkbox-material",
		{ ImageColor3 = "$CnCheckboxInvalidMaterialPressColor" }
	)
	Rule.create(sheet, "CheckboxCheckedPress", ".oof-ui-checkbox-checked:Press, .oof-ui-checkbox-indeterminate:Press", {
		BackgroundColor3 = "$CnColorAccentStrong",
	})
	Rule.create(sheet, "CheckboxFocused", ".oof-ui-checkbox-focused >> .oof-ui-checkbox-focus-stroke", {
		Transparency = "$CnOpacityFocusVisible",
	})
	Rule.create(sheet, "CheckboxInvalid", ".oof-ui-checkbox-invalid >> .oof-ui-checkbox-stroke", {
		Color = "$CnColorDanger",
		Thickness = "$CnStrokeStrong",
		Transparency = "$CnCheckboxInvalidStrokeTransparency",
	})
	Rule.create(sheet, "CheckboxDisabled", ".oof-ui-checkbox:NonInteractable", {
		BackgroundColor3 = "$CnColorDisabled",
	})
	Rule.create(sheet, "CheckboxDisabledMark", ".oof-ui-checkbox:NonInteractable >> .oof-ui-checkbox-mark", {
		TextTransparency = "$CnOpacityDisabled",
	})
	Rule.create(sheet, "CheckboxDisabledMaterial", ".oof-ui-checkbox:NonInteractable >> .oof-ui-checkbox-material", {
		ImageTransparency = "$CnCheckboxMaterialDisabledTransparency",
	})
end

local function installSwitch(sheet: StyleSheet)
	Rule.create(sheet, "Switch", ".oof-ui-switch", {
		AutoButtonColor = false,
		BackgroundTransparency = "$CnOpacityClear",
		BorderSizePixel = 0,
		Size = "$CnSwitchSize",
	})
	local track = Rule.create(sheet, "SwitchTrack", ".oof-ui-switch-track", {
		BackgroundColor3 = "$CnSwitchTrackColor",
		BackgroundTransparency = "$CnSwitchTrackSurfaceTransparency",
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = "$CnLayerBase",
	})
	Rule.transition(track, {
		BackgroundColor3 = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	})
	Rule.create(sheet, "SwitchTrackCorner", ".oof-ui-switch-track-corner", { CornerRadius = "$CnSwitchCornerRadius" })
	Rule.create(sheet, "SwitchTrackGradient", ".oof-ui-switch-track-gradient", {
		Color = "$CnSwitchTrackGradient",
		Enabled = "$CnSwitchTrackGradientEnabled",
		Rotation = 90,
	})
	Rule.create(sheet, "SwitchContent", ".oof-ui-switch-content", {
		BackgroundTransparency = "$CnOpacityClear",
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = "$CnLayerContent",
	})
	Rule.create(sheet, "SwitchTrackPadding", ".oof-ui-switch-track-padding", {
		PaddingBottom = "$CnSwitchThumbInset",
		PaddingLeft = "$CnSwitchThumbInset",
		PaddingRight = "$CnSwitchThumbInset",
		PaddingTop = "$CnSwitchThumbInset",
	})
	Rule.create(sheet, "SwitchTrackLayout", ".oof-ui-switch-track-layout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})
	local trackStroke = Rule.create(sheet, "SwitchTrackStroke", ".oof-ui-switch-track-stroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = "$CnSwitchTrackStrokeColor",
		Thickness = "$CnSwitchTrackStrokeThickness",
		Transparency = "$CnOpacityOpaque",
	})
	Rule.transition(trackStroke, {
		Color = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		Thickness = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	})
	local thumb = Rule.create(sheet, "SwitchThumb", ".oof-ui-switch-thumb", {
		BackgroundColor3 = "$CnSwitchThumbColor",
		BackgroundTransparency = "$CnOpacityOpaque",
		BorderSizePixel = 0,
		Size = "$CnSwitchThumbSize",
		ZIndex = "$CnLayerContent",
	})
	Rule.transition(thumb, {
		BackgroundColor3 = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	})
	Rule.create(sheet, "SwitchThumbCorner", ".oof-ui-switch-thumb-corner", {
		CornerRadius = "$CnSwitchThumbCornerRadius",
	})
	local thumbStroke = Rule.create(sheet, "SwitchThumbStroke", ".oof-ui-switch-thumb-stroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = "$CnSwitchThumbStrokeColor",
		Thickness = "$CnSwitchThumbStrokeThickness",
		Transparency = "$CnSwitchThumbStrokeTransparency",
	})
	Rule.transition(thumbStroke, {
		Color = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	})
	Rule.create(sheet, "SwitchThumbGradient", ".oof-ui-switch-thumb-gradient", {
		Color = "$CnSwitchThumbGradient",
		Enabled = "$CnSwitchThumbGradientEnabled",
		Rotation = 90,
	})
	local material = Rule.create(sheet, "SwitchMaterial", ".oof-ui-switch-material", {
		Image = "$CnSwitchMaterialImage",
		ImageColor3 = "$CnSwitchMaterialColor",
		ImageTransparency = "$CnSwitchMaterialTransparency",
		ScaleType = "$CnSwitchMaterialScaleType",
		SliceCenter = "$CnSwitchMaterialSliceCenter",
		SliceScale = "$CnSwitchMaterialSliceScale",
		Visible = "$CnSwitchMaterialVisible",
		ZIndex = "$CnLayerSurface",
	})
	Rule.transition(material, {
		ImageColor3 = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		ImageTransparency = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	})
	Rule.create(sheet, "SwitchFocus", ".oof-ui-switch-focus-stroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = "$CnColorFocus",
		Thickness = "$CnStrokeFocus",
		Transparency = "$CnOpacityFocusHidden",
	})
	Rule.create(sheet, "SwitchCheckedTrack", ".oof-ui-switch-checked >> .oof-ui-switch-track", {
		BackgroundColor3 = "$CnSwitchTrackCheckedColor",
	})
	Rule.create(sheet, "SwitchCheckedGradient", ".oof-ui-switch-checked >> .oof-ui-switch-track-gradient", {
		Color = "$CnSwitchTrackCheckedGradient",
	})
	Rule.create(sheet, "SwitchCheckedStroke", ".oof-ui-switch-checked >> .oof-ui-switch-track-stroke", {
		Color = "$CnSwitchTrackCheckedStrokeColor",
	})
	Rule.create(sheet, "SwitchCheckedThumb", ".oof-ui-switch-checked >> .oof-ui-switch-thumb", {
		BackgroundColor3 = "$CnSwitchThumbCheckedColor",
	})
	Rule.create(sheet, "SwitchCheckedThumbStroke", ".oof-ui-switch-checked >> .oof-ui-switch-thumb-stroke", {
		Color = "$CnSwitchThumbCheckedStrokeColor",
	})
	Rule.create(sheet, "SwitchCheckedThumbGradient", ".oof-ui-switch-checked >> .oof-ui-switch-thumb-gradient", {
		Color = "$CnSwitchThumbCheckedGradient",
	})
	Rule.create(sheet, "SwitchInvalidThumb", ".oof-ui-switch-invalid >> .oof-ui-switch-thumb", {
		BackgroundColor3 = "$CnSwitchThumbColor",
	})
	Rule.create(sheet, "SwitchInvalidThumbStroke", ".oof-ui-switch-invalid >> .oof-ui-switch-thumb-stroke", {
		Color = "$CnSwitchThumbStrokeColor",
	})
	Rule.create(sheet, "SwitchInvalidThumbGradient", ".oof-ui-switch-invalid >> .oof-ui-switch-thumb-gradient", {
		Color = "$CnSwitchThumbGradient",
	})
	Rule.create(sheet, "SwitchCheckedMaterial", ".oof-ui-switch-checked >> .oof-ui-switch-material", {
		Image = "$CnSwitchCheckedMaterialImage",
		SliceCenter = "$CnSwitchCheckedMaterialSliceCenter",
		SliceScale = "$CnSwitchCheckedMaterialSliceScale",
	})
	Rule.create(sheet, "SwitchInvalidMaterial", ".oof-ui-switch-invalid >> .oof-ui-switch-material", {
		Image = "$CnSwitchInvalidMaterialImage",
		ImageColor3 = "$CnSwitchInvalidMaterialColor",
		ScaleType = "$CnSwitchInvalidMaterialScaleType",
		SliceCenter = "$CnSwitchInvalidMaterialSliceCenter",
		SliceScale = "$CnSwitchInvalidMaterialSliceScale",
	})
	Rule.create(sheet, "SwitchCheckedLayout", ".oof-ui-switch-checked >> .oof-ui-switch-track-layout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
	})
	Rule.create(sheet, "SwitchHover", ".oof-ui-switch:Hover >> .oof-ui-switch-track", {
		BackgroundColor3 = "$CnSwitchTrackHoverColor",
	})
	Rule.create(sheet, "SwitchMaterialHover", ".oof-ui-switch:Hover >> .oof-ui-switch-material", {
		ImageColor3 = "$CnSwitchMaterialHoverColor",
	})
	Rule.create(
		sheet,
		"SwitchInvalidMaterialHover",
		".oof-ui-switch-invalid:Hover >> .oof-ui-switch-material",
		{ ImageColor3 = "$CnSwitchInvalidMaterialHoverColor" }
	)
	Rule.create(sheet, "SwitchCheckedHover", ".oof-ui-switch-checked:Hover >> .oof-ui-switch-track", {
		BackgroundColor3 = "$CnSwitchTrackCheckedHoverColor",
	})
	Rule.create(sheet, "SwitchPress", ".oof-ui-switch:Press >> .oof-ui-switch-track", {
		BackgroundColor3 = "$CnSwitchTrackPressColor",
	})
	Rule.create(sheet, "SwitchMaterialPress", ".oof-ui-switch:Press >> .oof-ui-switch-material", {
		ImageColor3 = "$CnSwitchMaterialPressColor",
	})
	Rule.create(
		sheet,
		"SwitchInvalidMaterialPress",
		".oof-ui-switch-invalid:Press >> .oof-ui-switch-material",
		{ ImageColor3 = "$CnSwitchInvalidMaterialPressColor" }
	)
	Rule.create(sheet, "SwitchCheckedPress", ".oof-ui-switch-checked:Press >> .oof-ui-switch-track", {
		BackgroundColor3 = "$CnSwitchTrackCheckedPressColor",
	})
	Rule.create(sheet, "SwitchFocused", ".oof-ui-switch-focused >> .oof-ui-switch-focus-stroke", {
		Transparency = "$CnOpacityFocusVisible",
	})
	Rule.create(sheet, "SwitchInvalid", ".oof-ui-switch-invalid >> .oof-ui-switch-track-stroke", {
		Color = "$CnSwitchInvalidStrokeColor",
		Thickness = "$CnSwitchTrackStrokeThickness",
		Transparency = "$CnSwitchInvalidStrokeTransparency",
	})
	Rule.create(sheet, "SwitchDisabled", ".oof-ui-switch:NonInteractable >> .oof-ui-switch-track", {
		BackgroundColor3 = "$CnColorDisabled",
	})
	Rule.create(sheet, "SwitchDisabledThumb", ".oof-ui-switch:NonInteractable >> .oof-ui-switch-thumb", {
		BackgroundTransparency = "$CnOpacityDisabled",
	})
	Rule.create(sheet, "SwitchDisabledMaterial", ".oof-ui-switch:NonInteractable >> .oof-ui-switch-material", {
		ImageTransparency = "$CnSwitchMaterialDisabledTransparency",
	})
end

local function installRadioGroup(sheet: StyleSheet)
	Rule.create(sheet, "RadioGroup", ".oof-ui-radio-group", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = "$CnOpacityClear",
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 0),
	})
	Rule.create(sheet, "RadioGroupLayout", ".oof-ui-radio-group-layout", {
		Padding = "$CnSpace3",
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
	Rule.create(sheet, "RadioGroupHorizontalLayout", ".oof-ui-radio-group-horizontal >> .oof-ui-radio-group-layout", {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})
	Rule.create(sheet, "RadioGroupItem", ".oof-ui-radio-group-item", {
		AutoButtonColor = false,
		BackgroundColor3 = "$CnColorSurface",
		BackgroundTransparency = "$CnRadioSurfaceTransparency",
		BorderSizePixel = 0,
		Size = "$CnRadioIndicatorSize",
	})
	Rule.create(sheet, "RadioGroupItemCorner", ".oof-ui-radio-group-item-corner", {
		CornerRadius = "$CnRadiusPill",
	})
	local stroke = Rule.create(sheet, "RadioGroupItemStroke", ".oof-ui-radio-group-item-stroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = "$CnColorBorder",
		Thickness = "$CnStrokeSubtle",
		Transparency = "$CnRadioStrokeTransparency",
	})
	Rule.transition(stroke, {
		Color = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		Thickness = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	})
	Rule.create(sheet, "RadioGroupItemDot", ".oof-ui-radio-group-item-dot", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = "$CnRadioDotColor",
		BackgroundTransparency = "$CnOpacityOpaque",
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = "$CnRadioDotSize",
		ZIndex = "$CnLayerContent",
	})
	Rule.create(sheet, "RadioGroupItemDotCorner", ".oof-ui-radio-group-item-dot-corner", {
		CornerRadius = "$CnRadiusPill",
	})
	Rule.create(sheet, "RadioGroupItemDotStroke", ".oof-ui-radio-group-item-dot-stroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = "$CnRadioDotStrokeColor",
		Thickness = "$CnRadioDotStrokeThickness",
		Transparency = "$CnRadioDotStrokeTransparency",
	})
	Rule.create(sheet, "RadioGroupItemDotGradient", ".oof-ui-radio-group-item-dot-gradient", {
		Color = "$CnRadioDotGradient",
		Enabled = "$CnRadioDotGradientEnabled",
		Rotation = 90,
	})
	local material = Rule.create(sheet, "RadioGroupItemMaterial", ".oof-ui-radio-group-item-material", {
		Image = "$CnRadioMaterialImage",
		ImageColor3 = "$CnRadioMaterialColor",
		ImageTransparency = "$CnRadioMaterialTransparency",
		ScaleType = "$CnRadioMaterialScaleType",
		SliceCenter = "$CnRadioMaterialSliceCenter",
		SliceScale = "$CnRadioMaterialSliceScale",
		Visible = "$CnRadioMaterialVisible",
		ZIndex = "$CnLayerSurface",
	})
	Rule.transition(material, {
		ImageColor3 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		ImageTransparency = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	})
	Rule.create(sheet, "RadioGroupItemFocus", ".oof-ui-radio-group-item-focus-stroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = "$CnColorFocus",
		Thickness = "$CnStrokeFocus",
		Transparency = "$CnOpacityFocusHidden",
	})
	Rule.create(
		sheet,
		"RadioGroupItemCheckedStroke",
		".oof-ui-radio-group-item-checked >> .oof-ui-radio-group-item-stroke",
		{
			Color = "$CnColorAccentEdge",
			Thickness = "$CnStrokeStrong",
		}
	)
	Rule.create(
		sheet,
		"RadioGroupItemCheckedMaterial",
		".oof-ui-radio-group-item-checked >> .oof-ui-radio-group-item-material",
		{
			Image = "$CnRadioCheckedMaterialImage",
		}
	)
	Rule.create(sheet, "RadioGroupItemHover", ".oof-ui-radio-group-item:Hover", {
		BackgroundColor3 = "$CnColorSurfaceRaised",
	})
	Rule.create(
		sheet,
		"RadioGroupItemMaterialHover",
		".oof-ui-radio-group-item:Hover >> .oof-ui-radio-group-item-material",
		{
			ImageColor3 = "$CnRadioMaterialHoverColor",
		}
	)
	Rule.create(sheet, "RadioGroupItemPress", ".oof-ui-radio-group-item:Press", {
		BackgroundColor3 = "$CnColorSurfacePress",
	})
	Rule.create(
		sheet,
		"RadioGroupItemMaterialPress",
		".oof-ui-radio-group-item:Press >> .oof-ui-radio-group-item-material",
		{
			ImageColor3 = "$CnRadioMaterialPressColor",
		}
	)
	Rule.create(
		sheet,
		"RadioGroupItemFocused",
		".oof-ui-radio-group-item-focused >> .oof-ui-radio-group-item-focus-stroke",
		{
			Transparency = "$CnOpacityFocusVisible",
		}
	)
	Rule.create(sheet, "RadioGroupItemInvalid", ".oof-ui-radio-group-item-invalid >> .oof-ui-radio-group-item-stroke", {
		Color = "$CnColorDanger",
		Thickness = "$CnStrokeStrong",
	})
	Rule.create(sheet, "RadioGroupItemDisabled", ".oof-ui-radio-group-item:NonInteractable", {
		BackgroundColor3 = "$CnColorDisabled",
	})
	Rule.create(
		sheet,
		"RadioGroupItemDisabledDot",
		".oof-ui-radio-group-item:NonInteractable >> .oof-ui-radio-group-item-dot",
		{
			BackgroundTransparency = "$CnOpacityDisabled",
		}
	)
	Rule.create(
		sheet,
		"RadioGroupItemDisabledMaterial",
		".oof-ui-radio-group-item:NonInteractable >> .oof-ui-radio-group-item-material",
		{
			ImageTransparency = "$CnRadioMaterialDisabledTransparency",
		}
	)
end

local function installSeparator(sheet: StyleSheet)
	Rule.create(sheet, "Separator", ".oof-ui-separator", {
		BackgroundTransparency = "$CnOpacityClear",
		BorderSizePixel = 0,
	})
	Rule.create(sheet, "SeparatorHorizontal", ".oof-ui-separator-horizontal", {
		Size = "$CnSeparatorHorizontalSize",
	})
	Rule.create(sheet, "SeparatorVertical", ".oof-ui-separator-vertical", {
		Size = "$CnSeparatorVerticalSize",
	})
	Rule.create(sheet, "SeparatorTrack", ".oof-ui-separator-track", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = "$CnSeparatorTrackColor",
		BackgroundTransparency = "$CnSeparatorTrackTransparency",
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		ZIndex = "$CnLayerBase",
	})
	Rule.create(sheet, "SeparatorHorizontalTrack", ".oof-ui-separator-horizontal >> .oof-ui-separator-track", {
		Size = "$CnSeparatorHorizontalTrackSize",
	})
	Rule.create(sheet, "SeparatorVerticalTrack", ".oof-ui-separator-vertical >> .oof-ui-separator-track", {
		Size = "$CnSeparatorVerticalTrackSize",
	})
	Rule.create(sheet, "SeparatorTrackGradient", ".oof-ui-separator-track-gradient", {
		Color = "$CnSeparatorTrackGradient",
		Enabled = "$CnSeparatorTrackGradientEnabled",
		Transparency = "$CnSeparatorGradientTransparency",
	})
	Rule.create(
		sheet,
		"SeparatorVerticalTrackGradient",
		".oof-ui-separator-vertical >> .oof-ui-separator-track-gradient",
		{ Rotation = 90 }
	)
	Rule.create(sheet, "SeparatorHighlight", ".oof-ui-separator-highlight", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = "$CnSeparatorHighlightColor",
		BackgroundTransparency = "$CnSeparatorHighlightTransparency",
		BorderSizePixel = 0,
		Visible = "$CnSeparatorHighlightVisible",
		ZIndex = "$CnLayerSurface",
	})
	Rule.create(sheet, "SeparatorHorizontalHighlight", ".oof-ui-separator-horizontal >> .oof-ui-separator-highlight", {
		Position = UDim2.new(0.5, 0, 0.5, -1),
		Size = "$CnSeparatorHorizontalHighlightSize",
	})
	Rule.create(sheet, "SeparatorVerticalHighlight", ".oof-ui-separator-vertical >> .oof-ui-separator-highlight", {
		Position = UDim2.new(0.5, -1, 0.5, 0),
		Size = "$CnSeparatorVerticalHighlightSize",
	})
	Rule.create(sheet, "SeparatorHighlightGradient", ".oof-ui-separator-highlight-gradient", {
		Color = ColorSequence.new(Color3.new(1, 1, 1)),
		Transparency = "$CnSeparatorGradientTransparency",
	})
	Rule.create(
		sheet,
		"SeparatorVerticalHighlightGradient",
		".oof-ui-separator-vertical >> .oof-ui-separator-highlight-gradient",
		{ Rotation = 90 }
	)
	Rule.create(sheet, "SeparatorOrnament", ".oof-ui-separator-ornament", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = "$CnSeparatorOrnamentColor",
		BackgroundTransparency = "$CnOpacityOpaque",
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Rotation = 45,
		Size = "$CnSeparatorOrnamentSize",
		Visible = "$CnSeparatorOrnamentVisible",
		ZIndex = "$CnLayerContent",
	})
	Rule.create(sheet, "SeparatorOrnamentCorner", ".oof-ui-separator-ornament-corner", {
		CornerRadius = "$CnSeparatorOrnamentCornerRadius",
	})
	Rule.create(sheet, "SeparatorOrnamentStroke", ".oof-ui-separator-ornament-stroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = "$CnSeparatorOrnamentStrokeColor",
		Thickness = "$CnSeparatorOrnamentStrokeThickness",
		Transparency = "$CnOpacityOpaque",
	})
	Rule.create(sheet, "SeparatorOrnamentGem", ".oof-ui-separator-ornament-gem", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = "$CnSeparatorOrnamentGemColor",
		BackgroundTransparency = "$CnSeparatorOrnamentGemTransparency",
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.42, 0.42),
	})
	Rule.create(sheet, "SeparatorOrnamentGemCorner", ".oof-ui-separator-ornament-gem-corner", {
		CornerRadius = "$CnSeparatorOrnamentCornerRadius",
	})
end

function SelectionRules.install(sheet: StyleSheet)
	installCheckbox(sheet)
	installSwitch(sheet)
	installRadioGroup(sheet)
	installSeparator(sheet)
end

return SelectionRules
