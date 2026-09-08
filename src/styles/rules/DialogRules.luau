--!strict

local Rule = require(script.Parent.Parent.Rule)

local DialogRules = {}

function DialogRules.install(sheet: StyleSheet)
	Rule.create(sheet, "Dialog", ".oof-ui-dialog", {
		BackgroundTransparency = "$CnOpacityClear",
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 1),
		ZIndex = "$CnLayerModal",
	})
	Rule.create(sheet, "DialogBackdrop", ".oof-ui-dialog-backdrop", {
		AutoButtonColor = false,
		BackgroundColor3 = "$CnColorBackdrop",
		BackgroundTransparency = "$CnOpacityBackdrop",
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Text = "",
		ZIndex = "$CnLayerModal",
	})
	Rule.create(sheet, "DialogSurface", ".oof-ui-dialog-surface", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = "$CnOpacityClear",
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = "$CnDialogSize",
		ZIndex = "$CnLayerModalSurface",
	})
	Rule.create(sheet, "DialogConstraint", ".oof-ui-dialog-constraint", {
		MaxSize = "$CnDialogMaxSize",
		MinSize = "$CnDialogMinSize",
	})
	Rule.create(sheet, "DialogContainer", ".oof-ui-dialog-container", {
		ZIndex = "$CnLayerModalSurface",
	})
	Rule.create(sheet, "DialogContainerSurface", ".oof-ui-dialog-container >> .oof-ui-container-surface", {
		ZIndex = "$CnLayerModalSurface",
	})
	Rule.create(sheet, "DialogContainerMaterial", ".oof-ui-dialog-container >> .oof-ui-container-material", {
		ZIndex = "$CnLayerModalSurface",
	})
	Rule.create(sheet, "DialogContainerContent", ".oof-ui-dialog-container >> .oof-ui-container-content", {
		ZIndex = "$CnLayerModalContent",
	})
	Rule.create(sheet, "DialogPadding", ".oof-ui-dialog-container >> .oof-ui-container-padding", {
		PaddingBottom = "$CnDialogPadding",
		PaddingLeft = "$CnDialogPadding",
		PaddingRight = "$CnDialogPadding",
		PaddingTop = "$CnDialogPadding",
	})
	Rule.create(sheet, "DialogLayout", ".oof-ui-dialog-container >> .oof-ui-container-layout", {
		Padding = "$CnSpace4",
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
	Rule.create(sheet, "DialogHeader", ".oof-ui-dialog-header", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = "$CnOpacityClear",
		LayoutOrder = 1,
		Size = UDim2.fromScale(1, 0),
		ZIndex = "$CnLayerModalContent",
	})
	Rule.create(sheet, "DialogHeaderLayout", ".oof-ui-dialog-header-layout", {
		Padding = "$CnSpace2",
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
	Rule.create(sheet, "DialogTitleRow", ".oof-ui-dialog-title-row", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = "$CnOpacityClear",
		LayoutOrder = 1,
		Size = UDim2.fromScale(1, 0),
	})
	Rule.create(sheet, "DialogTitleRowLayout", ".oof-ui-dialog-title-row-layout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		Padding = "$CnSpace2",
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})
	Rule.create(sheet, "DialogTitleContainer", ".oof-ui-dialog-title-container", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = "$CnOpacityClear",
		LayoutOrder = 1,
		Size = UDim2.fromOffset(0, 0),
	})
	Rule.create(sheet, "DialogTitleFlex", ".oof-ui-dialog-title-flex", {
		FlexMode = Enum.UIFlexMode.Fill,
	})
	Rule.create(sheet, "DialogTitle", ".oof-ui-dialog-title", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = "$CnOpacityClear",
		Font = "$CnFontDisplay",
		Size = UDim2.fromScale(1, 0),
		TextColor3 = "$CnColorText",
		TextSize = "$CnTextHeading",
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	Rule.create(sheet, "DialogDescription", ".oof-ui-dialog-description", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = "$CnOpacityClear",
		Font = "$CnFontRegular",
		LayoutOrder = 2,
		Size = UDim2.fromScale(1, 0),
		TextColor3 = "$CnColorSubtext",
		TextSize = "$CnTextBody",
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	Rule.create(sheet, "DialogClose", ".oof-ui-dialog-close", {
		LayoutOrder = 2,
		Size = "$CnDialogCloseSize",
		ZIndex = "$CnLayerModalContent",
	})
	Rule.create(
		sheet,
		"DialogCloseLayers",
		".oof-ui-dialog-close >> .oof-ui-icon-button-depth, .oof-ui-dialog-close >> .oof-ui-icon-button-surface, .oof-ui-dialog-close >> .oof-ui-icon-button-material, .oof-ui-dialog-close >> .oof-ui-icon-button-outline-accent, .oof-ui-dialog-close >> .oof-ui-icon-button-loading-indicator",
		{ ZIndex = "$CnLayerModalContent" }
	)
	Rule.create(sheet, "DialogCloseIcon", ".oof-ui-dialog-close >> .oof-ui-icon-button-icon", {
		Size = "$CnIconSmall",
		ZIndex = "$CnLayerModalContent",
	})
	Rule.create(sheet, "DialogContent", ".oof-ui-dialog-content", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = "$CnOpacityClear",
		LayoutOrder = 2,
		Size = UDim2.fromScale(1, 0),
		ZIndex = "$CnLayerModalContent",
	})
	Rule.create(sheet, "DialogFooter", ".oof-ui-dialog-footer", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = "$CnOpacityClear",
		LayoutOrder = 3,
		Size = UDim2.fromScale(1, 0),
		ZIndex = "$CnLayerModalContent",
	})
	Rule.create(sheet, "DialogFooterLayout", ".oof-ui-dialog-footer-layout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		Padding = "$CnSpace2",
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Wraps = false,
	})
	-- Global-Z ScreenGuis otherwise place default-Z footer controls behind the
	-- modal backdrop. Keep the entire surface subtree above the backdrop.
	Rule.create(sheet, "DialogDescendantLayers", ".oof-ui-dialog-surface >> GuiObject", {
		ZIndex = "$CnLayerModalContent",
	})
end

return DialogRules
