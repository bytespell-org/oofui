--!strict

local Rule = require(script.Parent.Parent.Rule)

local ButtonRules = {}

local function installControlAndButton(sheet: StyleSheet)
	Rule.create(sheet, "ButtonBadge", ".oof-ui-button-badge", {
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = "$CnBadgeColor",
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Font = "$CnFontStrong",
		Size = "$CnBadgeSize",
		TextColor3 = "$CnBadgeTextColor",
		TextSize = "$CnBadgeTextSize",
		TextWrapped = false,
		ZIndex = "$CnLayerContent",
	})
	Rule.create(sheet, "ButtonBadgeOverlay", ".oof-ui-button-badge-overlay", {
		AnchorPoint = Vector2.new(1, 0),
		Position = "$CnBadgePosition",
	})
	Rule.create(sheet, "ButtonBadgeDot", ".oof-ui-button-badge-dot", {
		AutomaticSize = Enum.AutomaticSize.None,
		Size = "$CnBadgeDotSize",
	})
	Rule.create(sheet, "ButtonBadgeCorner", ".oof-ui-button-badge-corner", {
		CornerRadius = "$CnBadgeCornerRadius",
	})
	Rule.create(sheet, "ButtonBadgeDotCorner", ".oof-ui-button-badge-dot >> .oof-ui-button-badge-corner", {
		CornerRadius = "$CnRadiusPill",
	})
	Rule.create(sheet, "ButtonBadgeStroke", ".oof-ui-button-badge-stroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = "$CnBadgeStrokeColor",
		Thickness = "$CnBadgeStrokeThickness",
		Transparency = 0,
	})
	Rule.create(sheet, "ButtonBadgePadding", ".oof-ui-button-badge-padding", {
		PaddingLeft = "$CnBadgePadding",
		PaddingRight = "$CnBadgePadding",
	})
	for _, entry in
		{
			{ "oof-ui-button", "leading-icon" },
			{ "oof-ui-button", "trailing-icon" },
			{ "oof-ui-icon-button", "icon" },
		}
	do
		local prefix, part = entry[1], entry[2]
		local icon = "." .. prefix .. "-" .. part
		Rule.create(sheet, prefix .. part .. "Ink", icon, { ImageColor3 = "$CnColorOnAccent" })
		for _, variant in { "secondary", "outline", "ghost" } do
			Rule.create(sheet, prefix .. part .. variant .. "Ink", "." .. prefix .. "-" .. variant .. " >> " .. icon, {
				ImageColor3 = "$CnColorText",
			})
		end
		Rule.create(sheet, prefix .. part .. "DisabledInk", "." .. prefix .. "-disabled >> " .. icon, {
			ImageColor3 = "$CnColorDisabledText",
			ImageTransparency = 0,
		})
	end

	Rule.create(sheet, "Control", ".oof-ui-button, .oof-ui-icon-button", {
		AutoButtonColor = false,
		BackgroundTransparency = "$CnOpacityClear",
		BorderSizePixel = 0,
	})
	Rule.create(sheet, "ButtonFixedSmall", ".oof-ui-button-fixed-small", {
		AutomaticSize = Enum.AutomaticSize.X,
		Size = "$CnButtonSizeSmall",
	})
	Rule.create(sheet, "ButtonFixedMedium", ".oof-ui-button-fixed-medium", {
		AutomaticSize = Enum.AutomaticSize.X,
		Size = "$CnButtonSizeMedium",
	})
	Rule.create(sheet, "ButtonFixedLarge", ".oof-ui-button-fixed-large", {
		AutomaticSize = Enum.AutomaticSize.X,
		Size = "$CnButtonSizeLarge",
	})
	Rule.create(sheet, "ButtonFullWidthSmall", ".oof-ui-button-full-width-small", {
		AutomaticSize = Enum.AutomaticSize.None,
		Size = "$CnButtonFullWidthSmall",
	})
	Rule.create(sheet, "ButtonFullWidthMedium", ".oof-ui-button-full-width-medium", {
		AutomaticSize = Enum.AutomaticSize.None,
		Size = "$CnButtonFullWidthMedium",
	})
	Rule.create(sheet, "ButtonFullWidthLarge", ".oof-ui-button-full-width-large", {
		AutomaticSize = Enum.AutomaticSize.None,
		Size = "$CnButtonFullWidthLarge",
	})
	Rule.create(sheet, "ControlDepth", ".oof-ui-button-depth, .oof-ui-icon-button-depth", {
		BackgroundColor3 = "$CnColorAccentStrong",
		BackgroundTransparency = "$CnControlDepthTransparency",
		BorderSizePixel = 0,
		Position = "$CnControlDepthPosition",
		Size = UDim2.fromScale(1, 1),
		ZIndex = "$CnLayerBase",
	})
	Rule.create(sheet, "ControlDepthCorner", ".oof-ui-button-depth-corner, .oof-ui-icon-button-depth-corner", {
		CornerRadius = "$CnRadiusMedium",
	})
	Rule.create(sheet, "ControlRootCorner", ".oof-ui-button-root-corner, .oof-ui-icon-button-root-corner", {
		CornerRadius = "$CnRadiusMedium",
	})
	local surface = Rule.create(sheet, "ControlSurface", ".oof-ui-button-surface, .oof-ui-icon-button-surface", {
		BackgroundColor3 = "$CnColorAccent",
		BackgroundTransparency = "$CnOpacityOpaque",
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 1),
		ZIndex = "$CnLayerSurface",
	})
	Rule.transition(surface, {
		BackgroundColor3 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		BackgroundTransparency = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	})
	Rule.create(
		sheet,
		"ControlCorner",
		".oof-ui-button-corner, .oof-ui-icon-button-corner",
		{ CornerRadius = "$CnRadiusMedium" }
	)
	Rule.create(sheet, "ControlStroke", ".oof-ui-button-stroke, .oof-ui-icon-button-stroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = "$CnColorAccentStrong",
		Thickness = "$CnStrokeSubtle",
		Transparency = "$CnControlStrokeTransparency",
	})
	Rule.create(sheet, "ControlGradient", ".oof-ui-button-gradient, .oof-ui-icon-button-gradient", {
		Enabled = "$CnControlGradientEnabled",
		Color = "$CnControlHighlightGradient",
		Rotation = 90,
		Transparency = NumberSequence.new(0),
	})
	Rule.create(sheet, "ControlOutlineAccent", ".oof-ui-button-outline-accent, .oof-ui-icon-button-outline-accent", {
		BackgroundTransparency = "$CnOpacityClear",
		Position = UDim2.fromOffset(3, 3),
		Size = UDim2.new(1, -6, 1, -6),
		Visible = false,
		ZIndex = "$CnLayerContent",
	})
	Rule.create(
		sheet,
		"ControlOutlineAccentCorner",
		".oof-ui-button-outline-accent-corner, .oof-ui-icon-button-outline-accent-corner",
		{ CornerRadius = "$CnRadiusMedium" }
	)
	Rule.create(
		sheet,
		"ControlOutlineAccentStroke",
		".oof-ui-button-outline-accent-stroke, .oof-ui-icon-button-outline-accent-stroke",
		{
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = "$CnControlOutlineAccentColor",
			Thickness = "$CnControlOutlineAccentThickness",
			Transparency = "$CnControlOutlineAccentTransparency",
		}
	)
	local material = Rule.create(
		sheet,
		"ControlPrimaryMaterial",
		".oof-ui-button-primary >> .oof-ui-button-material, .oof-ui-icon-button-primary >> .oof-ui-icon-button-material",
		{
			Image = "$CnControlPrimaryMaterialImage",
			ImageColor3 = "$CnControlPrimaryMaterialColor",
			ImageTransparency = "$CnControlPrimaryMaterialTransparency",
			Position = UDim2.fromScale(0, 0),
			ScaleType = "$CnControlPrimaryMaterialScaleType",
			SliceCenter = "$CnControlPrimaryMaterialSliceCenter",
			SliceScale = "$CnControlPrimaryMaterialSliceScale",
			Visible = "$CnControlPrimaryMaterialVisible",
			ZIndex = "$CnLayerSurface",
		}
	)
	Rule.transition(material, {
		ImageColor3 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		ImageTransparency = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	})
	local secondaryMaterial = Rule.create(
		sheet,
		"ControlSecondaryMaterial",
		".oof-ui-button-secondary >> .oof-ui-button-material, .oof-ui-icon-button-secondary >> .oof-ui-icon-button-material",
		{
			Image = "$CnControlSecondaryMaterialImage",
			ImageColor3 = "$CnControlSecondaryMaterialColor",
			ImageTransparency = "$CnControlSecondaryMaterialTransparency",
			Position = UDim2.fromScale(0, 0),
			ScaleType = "$CnControlSecondaryMaterialScaleType",
			SliceCenter = "$CnControlSecondaryMaterialSliceCenter",
			SliceScale = "$CnControlSecondaryMaterialSliceScale",
			Visible = "$CnControlSecondaryMaterialVisible",
			ZIndex = "$CnLayerSurface",
		}
	)
	Rule.transition(secondaryMaterial, {
		ImageColor3 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		ImageTransparency = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	})
	local destructiveMaterial = Rule.create(
		sheet,
		"ControlDestructiveMaterial",
		".oof-ui-button-destructive >> .oof-ui-button-material, .oof-ui-icon-button-destructive >> .oof-ui-icon-button-material",
		{
			Image = "$CnControlDestructiveMaterialImage",
			ImageColor3 = "$CnControlDestructiveMaterialColor",
			ImageTransparency = "$CnControlDestructiveMaterialTransparency",
			Position = UDim2.fromScale(0, 0),
			ScaleType = "$CnControlDestructiveMaterialScaleType",
			SliceCenter = "$CnControlDestructiveMaterialSliceCenter",
			SliceScale = "$CnControlDestructiveMaterialSliceScale",
			Visible = "$CnControlDestructiveMaterialVisible",
			ZIndex = "$CnLayerSurface",
		}
	)
	Rule.transition(destructiveMaterial, {
		ImageColor3 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		ImageTransparency = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	})
	Rule.create(
		sheet,
		"IconButtonDestructiveMaterialScale",
		".oof-ui-icon-button-destructive >> .oof-ui-icon-button-material",
		{ SliceScale = "$CnIconButtonDestructiveMaterialSliceScale" }
	)
	-- Intrinsic content owns the root width, matching the usual height-plus-
	-- horizontal-padding button contract. Full-width is the only mode that
	-- centers content inside width supplied by the parent.
	Rule.create(sheet, "ButtonContent", ".oof-ui-button-content", {
		AnchorPoint = Vector2.new(0, 0.5),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = "$CnOpacityClear",
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.new(0, 0, 1, -6),
		ZIndex = "$CnLayerContent",
	})
	Rule.create(sheet, "ButtonFullWidthContent", ".oof-ui-button-full-width >> .oof-ui-button-content", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		AutomaticSize = Enum.AutomaticSize.None,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 0, 1, -6),
	})
	Rule.create(sheet, "ButtonContentPadding", ".oof-ui-button-content-padding", {
		PaddingLeft = "$CnButtonContentInsetX",
		PaddingRight = "$CnButtonContentInsetX",
	})
	Rule.create(sheet, "ButtonPrimaryContentPadding", ".oof-ui-button-primary >> .oof-ui-button-content-padding", {
		PaddingLeft = "$CnButtonPrimaryContentInsetX",
		PaddingRight = "$CnButtonPrimaryContentInsetX",
	})
	Rule.create(sheet, "ButtonSecondaryContentPadding", ".oof-ui-button-secondary >> .oof-ui-button-content-padding", {
		PaddingLeft = "$CnButtonSecondaryContentInsetX",
		PaddingRight = "$CnButtonSecondaryContentInsetX",
	})
	Rule.create(
		sheet,
		"ButtonDestructiveContentPadding",
		".oof-ui-button-destructive >> .oof-ui-button-content-padding",
		{
			PaddingLeft = "$CnButtonDestructiveContentInsetX",
			PaddingRight = "$CnButtonDestructiveContentInsetX",
		}
	)
	Rule.create(sheet, "ButtonContentLayout", ".oof-ui-button-content-layout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Padding = "$CnSpace2",
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})
	Rule.create(sheet, "ButtonLabel", ".oof-ui-button-label", {
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = "$CnOpacityClear",
		Font = "$CnFontStrong",
		Size = UDim2.fromScale(0, 1),
		TextColor3 = "$CnColorOnAccent",
		TextSize = "$CnButtonTextMedium",
		ZIndex = "$CnLayerContent",
	})
	Rule.create(sheet, "ButtonLabelSmall", ".oof-ui-button-small >> .oof-ui-button-label", {
		TextSize = "$CnButtonTextSmall",
	})
	Rule.create(sheet, "ButtonLabelMedium", ".oof-ui-button-medium >> .oof-ui-button-label", {
		TextSize = "$CnButtonTextMedium",
	})
	Rule.create(sheet, "ButtonLabelLarge", ".oof-ui-button-large >> .oof-ui-button-label", {
		TextSize = "$CnButtonTextLarge",
	})
	Rule.create(sheet, "ButtonLeadingIcon", ".oof-ui-button-leading-icon", {
		Size = "$CnIconMedium",
		ZIndex = "$CnLayerContent",
	})
	Rule.create(sheet, "ButtonTrailingIcon", ".oof-ui-button-trailing-icon", {
		Size = "$CnIconMedium",
		ZIndex = "$CnLayerContent",
	})
	Rule.create(sheet, "ButtonIconSmall", ".oof-ui-button-small >> .oof-ui-button-leading-icon", {
		Size = "$CnIconSmall",
	})
	Rule.create(sheet, "ButtonTrailingIconSmall", ".oof-ui-button-small >> .oof-ui-button-trailing-icon", {
		Size = "$CnIconSmall",
	})
	Rule.create(sheet, "ButtonIconLarge", ".oof-ui-button-large >> .oof-ui-button-leading-icon", {
		Size = "$CnIconLarge",
	})
	Rule.create(sheet, "ButtonTrailingIconLarge", ".oof-ui-button-large >> .oof-ui-button-trailing-icon", {
		Size = "$CnIconLarge",
	})
	Rule.create(sheet, "ButtonLoadingIndicator", ".oof-ui-button-loading-indicator", {
		BackgroundTransparency = "$CnOpacityClear",
		Size = "$CnIconMedium",
		ZIndex = "$CnLayerContent",
	})
	Rule.create(sheet, "ButtonLoadingIndicatorSmall", ".oof-ui-button-small >> .oof-ui-button-loading-indicator", {
		Size = "$CnIconSmall",
	})
	Rule.create(sheet, "ButtonLoadingIndicatorLarge", ".oof-ui-button-large >> .oof-ui-button-loading-indicator", {
		Size = "$CnIconLarge",
	})
	Rule.create(
		sheet,
		"ControlLoadingCorner",
		".oof-ui-button-loading-indicator-corner, .oof-ui-icon-button-loading-indicator-corner",
		{
			CornerRadius = "$CnRadiusPill",
		}
	)
	Rule.create(
		sheet,
		"ControlLoadingStroke",
		".oof-ui-button-loading-indicator-stroke, .oof-ui-icon-button-loading-indicator-stroke",
		{
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = "$CnColorOnAccent",
			Thickness = "$CnStrokeStrong",
			Transparency = 0.25,
		}
	)
	Rule.create(sheet, "ControlFocusStroke", ".oof-ui-button-focus-stroke, .oof-ui-icon-button-focus-stroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = "$CnColorFocus",
		Thickness = "$CnStrokeFocus",
		Transparency = "$CnOpacityFocusHidden",
	})
	Rule.create(
		sheet,
		"ControlFocused",
		".oof-ui-button-focused >> .oof-ui-button-focus-stroke, .oof-ui-icon-button-focused >> .oof-ui-icon-button-focus-stroke",
		{ Transparency = "$CnOpacityFocusVisible" }
	)
	Rule.create(
		sheet,
		"ControlSecondary",
		".oof-ui-button-secondary >> .oof-ui-button-surface, .oof-ui-icon-button-secondary >> .oof-ui-icon-button-surface",
		{
			BackgroundColor3 = "$CnColorSurfaceRaised",
		}
	)
	Rule.create(
		sheet,
		"ControlSecondaryDepth",
		".oof-ui-button-secondary >> .oof-ui-button-depth, .oof-ui-icon-button-secondary >> .oof-ui-icon-button-depth",
		{
			BackgroundColor3 = "$CnColorSurfacePress",
		}
	)
	Rule.create(
		sheet,
		"ControlSecondaryStroke",
		".oof-ui-button-secondary >> .oof-ui-button-stroke, .oof-ui-icon-button-secondary >> .oof-ui-icon-button-stroke",
		{
			Color = "$CnColorBorder",
		}
	)
	Rule.create(sheet, "ButtonSecondaryLabel", ".oof-ui-button-secondary >> .oof-ui-button-label", {
		TextColor3 = "$CnButtonSecondaryTextColor",
	})
	Rule.create(
		sheet,
		"ControlOutline",
		".oof-ui-button-outline >> .oof-ui-button-surface, .oof-ui-icon-button-outline >> .oof-ui-icon-button-surface",
		{
			BackgroundColor3 = "$CnColorSurface",
		}
	)
	Rule.create(
		sheet,
		"ControlOutlineDepth",
		".oof-ui-button-outline >> .oof-ui-button-depth, .oof-ui-icon-button-outline >> .oof-ui-icon-button-depth",
		{
			BackgroundColor3 = "$CnColorSurfacePress",
		}
	)
	Rule.create(
		sheet,
		"ControlOutlineStroke",
		".oof-ui-button-outline >> .oof-ui-button-stroke, .oof-ui-icon-button-outline >> .oof-ui-icon-button-stroke",
		{
			Color = "$CnColorBorder",
			Transparency = "$CnOpacityOpaque",
		}
	)
	Rule.create(
		sheet,
		"ControlOutlineGradient",
		".oof-ui-button-outline >> .oof-ui-button-gradient, .oof-ui-icon-button-outline >> .oof-ui-icon-button-gradient",
		{
			Color = "$CnControlOutlineGradient",
			Enabled = "$CnControlOutlineGradientEnabled",
		}
	)
	Rule.create(
		sheet,
		"ControlOutlineAccentVisible",
		".oof-ui-button-outline >> .oof-ui-button-outline-accent, .oof-ui-icon-button-outline >> .oof-ui-icon-button-outline-accent",
		{ Visible = "$CnControlOutlineAccentVisible" }
	)
	Rule.create(sheet, "ButtonOutlineLabel", ".oof-ui-button-outline >> .oof-ui-button-label", {
		TextColor3 = "$CnColorText",
	})
	Rule.create(
		sheet,
		"ControlGhostDepth",
		".oof-ui-button-ghost >> .oof-ui-button-depth, .oof-ui-icon-button-ghost >> .oof-ui-icon-button-depth",
		{
			BackgroundTransparency = "$CnOpacityClear",
		}
	)
	Rule.create(
		sheet,
		"ControlGhostSurface",
		".oof-ui-button-ghost >> .oof-ui-button-surface, .oof-ui-icon-button-ghost >> .oof-ui-icon-button-surface",
		{
			BackgroundColor3 = "$CnColorSurfaceHover",
			BackgroundTransparency = "$CnOpacityClear",
		}
	)
	Rule.create(
		sheet,
		"ControlGhostStroke",
		".oof-ui-button-ghost >> .oof-ui-button-stroke, .oof-ui-icon-button-ghost >> .oof-ui-icon-button-stroke",
		{
			Transparency = "$CnOpacityClear",
		}
	)
	Rule.create(sheet, "ButtonGhostLabel", ".oof-ui-button-ghost >> .oof-ui-button-label", {
		TextColor3 = "$CnColorText",
	})
	Rule.create(
		sheet,
		"ControlNeutralLoadingStroke",
		".oof-ui-button-secondary >> .oof-ui-button-loading-indicator-stroke, .oof-ui-button-outline >> .oof-ui-button-loading-indicator-stroke, .oof-ui-button-ghost >> .oof-ui-button-loading-indicator-stroke, .oof-ui-icon-button-secondary >> .oof-ui-icon-button-loading-indicator-stroke, .oof-ui-icon-button-outline >> .oof-ui-icon-button-loading-indicator-stroke, .oof-ui-icon-button-ghost >> .oof-ui-icon-button-loading-indicator-stroke",
		{
			Color = "$CnColorText",
		}
	)
	Rule.create(
		sheet,
		"ControlDestructive",
		".oof-ui-button-destructive >> .oof-ui-button-surface, .oof-ui-icon-button-destructive >> .oof-ui-icon-button-surface",
		{
			BackgroundColor3 = "$CnColorDanger",
		}
	)
	Rule.create(
		sheet,
		"ControlDestructiveDepth",
		".oof-ui-button-destructive >> .oof-ui-button-depth, .oof-ui-icon-button-destructive >> .oof-ui-icon-button-depth",
		{
			BackgroundColor3 = "$CnColorDangerStrong",
		}
	)
	Rule.create(
		sheet,
		"ControlDestructiveStroke",
		".oof-ui-button-destructive >> .oof-ui-button-stroke, .oof-ui-icon-button-destructive >> .oof-ui-icon-button-stroke",
		{
			Color = "$CnColorDangerStrong",
		}
	)
	Rule.create(
		sheet,
		"ControlPrimarySurface",
		".oof-ui-button-primary >> .oof-ui-button-surface, .oof-ui-icon-button-primary >> .oof-ui-icon-button-surface",
		{ BackgroundTransparency = "$CnControlPrimarySurfaceTransparency" }
	)
	Rule.create(
		sheet,
		"ControlSecondaryMaterialSurface",
		".oof-ui-button-secondary >> .oof-ui-button-surface, .oof-ui-icon-button-secondary >> .oof-ui-icon-button-surface",
		{ BackgroundTransparency = "$CnControlSecondarySurfaceTransparency" }
	)
	Rule.create(
		sheet,
		"ControlDestructiveMaterialSurface",
		".oof-ui-button-destructive >> .oof-ui-button-surface, .oof-ui-icon-button-destructive >> .oof-ui-icon-button-surface",
		{ BackgroundTransparency = "$CnControlDestructiveSurfaceTransparency" }
	)
	Rule.create(
		sheet,
		"ControlPrimaryHover",
		".oof-ui-button-primary:Hover >> .oof-ui-button-surface, .oof-ui-icon-button-primary:Hover >> .oof-ui-icon-button-surface",
		{ BackgroundColor3 = "$CnColorAccentHover" }
	)
	Rule.create(
		sheet,
		"ControlPrimaryMaterialHover",
		".oof-ui-button-primary:Hover >> .oof-ui-button-material, .oof-ui-icon-button-primary:Hover >> .oof-ui-icon-button-material",
		{ ImageColor3 = "$CnControlPrimaryMaterialHoverColor" }
	)
	Rule.create(
		sheet,
		"ControlSecondaryMaterialHover",
		".oof-ui-button-secondary:Hover >> .oof-ui-button-material, .oof-ui-icon-button-secondary:Hover >> .oof-ui-icon-button-material",
		{ ImageColor3 = "$CnControlSecondaryMaterialHoverColor" }
	)
	Rule.create(
		sheet,
		"ControlDestructiveMaterialHover",
		".oof-ui-button-destructive:Hover >> .oof-ui-button-material, .oof-ui-icon-button-destructive:Hover >> .oof-ui-icon-button-material",
		{ ImageColor3 = "$CnControlDestructiveMaterialHoverColor" }
	)
	Rule.create(
		sheet,
		"ControlSecondaryHover",
		".oof-ui-button-secondary:Hover >> .oof-ui-button-surface, .oof-ui-icon-button-secondary:Hover >> .oof-ui-icon-button-surface",
		{
			BackgroundColor3 = "$CnColorSurfaceHover",
		}
	)
	Rule.create(
		sheet,
		"ControlOutlineHover",
		".oof-ui-button-outline:Hover >> .oof-ui-button-surface, .oof-ui-icon-button-outline:Hover >> .oof-ui-icon-button-surface",
		{
			BackgroundColor3 = "$CnColorSurfaceHover",
		}
	)
	Rule.create(
		sheet,
		"ControlGhostHover",
		".oof-ui-button-ghost:Hover >> .oof-ui-button-surface, .oof-ui-icon-button-ghost:Hover >> .oof-ui-icon-button-surface",
		{
			BackgroundColor3 = "$CnColorSurfaceHover",
			BackgroundTransparency = "$CnOpacityOpaque",
		}
	)
	Rule.create(
		sheet,
		"ControlDestructiveHover",
		".oof-ui-button-destructive:Hover >> .oof-ui-button-surface, .oof-ui-icon-button-destructive:Hover >> .oof-ui-icon-button-surface",
		{
			BackgroundColor3 = "$CnColorDangerHover",
		}
	)
	Rule.create(
		sheet,
		"ControlPrimaryPress",
		".oof-ui-button-primary:Press >> .oof-ui-button-surface, .oof-ui-icon-button-primary:Press >> .oof-ui-icon-button-surface",
		{
			BackgroundColor3 = "$CnColorAccentStrong",
		}
	)
	Rule.create(
		sheet,
		"ControlPrimaryMaterialPress",
		".oof-ui-button-primary:Press >> .oof-ui-button-material, .oof-ui-icon-button-primary:Press >> .oof-ui-icon-button-material",
		{ ImageColor3 = "$CnControlPrimaryMaterialPressColor" }
	)
	Rule.create(
		sheet,
		"ControlSecondaryMaterialPress",
		".oof-ui-button-secondary:Press >> .oof-ui-button-material, .oof-ui-icon-button-secondary:Press >> .oof-ui-icon-button-material",
		{ ImageColor3 = "$CnControlSecondaryMaterialPressColor" }
	)
	Rule.create(
		sheet,
		"ControlDestructiveMaterialPress",
		".oof-ui-button-destructive:Press >> .oof-ui-button-material, .oof-ui-icon-button-destructive:Press >> .oof-ui-icon-button-material",
		{ ImageColor3 = "$CnControlDestructiveMaterialPressColor" }
	)
	Rule.create(
		sheet,
		"ControlSecondaryPress",
		".oof-ui-button-secondary:Press >> .oof-ui-button-surface, .oof-ui-icon-button-secondary:Press >> .oof-ui-icon-button-surface",
		{
			BackgroundColor3 = "$CnColorSurfacePress",
		}
	)
	Rule.create(
		sheet,
		"ControlOutlinePress",
		".oof-ui-button-outline:Press >> .oof-ui-button-surface, .oof-ui-icon-button-outline:Press >> .oof-ui-icon-button-surface",
		{
			BackgroundColor3 = "$CnColorSurfacePress",
		}
	)
	Rule.create(
		sheet,
		"ControlGhostPress",
		".oof-ui-button-ghost:Press >> .oof-ui-button-surface, .oof-ui-icon-button-ghost:Press >> .oof-ui-icon-button-surface",
		{
			BackgroundColor3 = "$CnColorSurfacePress",
			BackgroundTransparency = "$CnOpacityOpaque",
		}
	)
	Rule.create(
		sheet,
		"ControlDestructivePress",
		".oof-ui-button-destructive:Press >> .oof-ui-button-surface, .oof-ui-icon-button-destructive:Press >> .oof-ui-icon-button-surface",
		{
			BackgroundColor3 = "$CnColorDangerStrong",
		}
	)
	-- Both loading and disabled block input, but only disabled uses this palette.
	for _, prefix in { "oof-ui-button", "oof-ui-icon-button" } do
		local selector = "." .. prefix .. "-disabled >> ." .. prefix
		Rule.create(sheet, prefix .. "DisabledSurface", selector .. "-surface", {
			BackgroundColor3 = "$CnColorDisabledSurface",
			BackgroundTransparency = 0,
		})
		for _, variant in { "Primary", "Secondary", "Destructive" } do
			Rule.create(
				sheet,
				prefix .. variant .. "DisabledMaterial",
				"."
					.. prefix
					.. "-disabled."
					.. prefix
					.. "-"
					.. string.lower(variant)
					.. " >> ."
					.. prefix
					.. "-material",
				{
					ImageTransparency = "$CnControl" .. variant .. "MaterialDisabledTransparency",
				}
			)
		end
		Rule.create(sheet, prefix .. "DisabledGradient", selector .. "-gradient", { Enabled = false })
		Rule.create(sheet, prefix .. "DisabledDepth", selector .. "-depth", { BackgroundTransparency = 1 })
		Rule.create(sheet, prefix .. "DisabledAccent", selector .. "-outline-accent", { Visible = false })
		Rule.create(sheet, prefix .. "DisabledStroke", selector .. "-stroke", {
			Color = "$CnColorBorder",
			Transparency = 0,
		})
		Rule.create(sheet, prefix .. "DisabledLoadingStroke", selector .. "-loading-indicator-stroke", {
			Color = "$CnColorDisabledText",
		})
	end
	Rule.create(sheet, "ButtonDisabledLabel", ".oof-ui-button-disabled >> .oof-ui-button-label", {
		TextColor3 = "$CnColorDisabledText",
		TextTransparency = 0,
	})
end

local function installIconButton(sheet: StyleSheet)
	Rule.create(sheet, "IconButtonSmall", ".oof-ui-icon-button-small", {
		Size = "$CnIconButtonSizeSmall",
	})
	Rule.create(sheet, "IconButtonMedium", ".oof-ui-icon-button-medium", {
		Size = "$CnIconButtonSizeMedium",
	})
	Rule.create(sheet, "IconButtonLarge", ".oof-ui-icon-button-large", {
		Size = "$CnIconButtonSizeLarge",
	})
	Rule.create(sheet, "IconButtonCircle", ".oof-ui-icon-button-circle >> .oof-ui-icon-button-corner", {
		CornerRadius = "$CnRadiusPill",
	})
	Rule.create(sheet, "IconButtonCircleDepth", ".oof-ui-icon-button-circle >> .oof-ui-icon-button-depth-corner", {
		CornerRadius = "$CnRadiusPill",
	})
	Rule.create(sheet, "IconButtonCircleRoot", ".oof-ui-icon-button-circle >> .oof-ui-icon-button-root-corner", {
		CornerRadius = "$CnRadiusPill",
	})
	Rule.create(
		sheet,
		"IconButtonCircleOutlineAccent",
		".oof-ui-icon-button-circle >> .oof-ui-icon-button-outline-accent-corner",
		{ CornerRadius = "$CnRadiusPill" }
	)
	Rule.create(sheet, "IconButtonSquare", ".oof-ui-icon-button-square >> .oof-ui-icon-button-corner", {
		CornerRadius = UDim.new(0, 0),
	})
	Rule.create(sheet, "IconButtonSquareDepth", ".oof-ui-icon-button-square >> .oof-ui-icon-button-depth-corner", {
		CornerRadius = UDim.new(0, 0),
	})
	Rule.create(sheet, "IconButtonSquareRoot", ".oof-ui-icon-button-square >> .oof-ui-icon-button-root-corner", {
		CornerRadius = UDim.new(0, 0),
	})
	Rule.create(
		sheet,
		"IconButtonSquareOutlineAccent",
		".oof-ui-icon-button-square >> .oof-ui-icon-button-outline-accent-corner",
		{ CornerRadius = UDim.new(0, 0) }
	)
	Rule.create(sheet, "IconButtonIcon", ".oof-ui-icon-button-icon", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = "$CnIconMedium",
		ZIndex = "$CnLayerContent",
	})
	Rule.create(sheet, "IconButtonIconSmall", ".oof-ui-icon-button-small >> .oof-ui-icon-button-icon", {
		Size = "$CnIconSmall",
	})
	Rule.create(sheet, "IconButtonIconLarge", ".oof-ui-icon-button-large >> .oof-ui-icon-button-icon", {
		Size = "$CnIconLarge",
	})
	Rule.create(sheet, "IconButtonLoading", ".oof-ui-icon-button-loading-indicator", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = "$CnOpacityClear",
		Position = UDim2.fromScale(0.5, 0.5),
		Size = "$CnIconMedium",
		ZIndex = "$CnLayerContent",
	})
end

function ButtonRules.install(sheet: StyleSheet)
	installControlAndButton(sheet)
	installIconButton(sheet)
end

return ButtonRules
