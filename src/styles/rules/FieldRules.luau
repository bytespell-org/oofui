--!strict

local Rule = require(script.Parent.Parent.Rule)

local FieldRules = {}

function FieldRules.install(sheet: StyleSheet)
	Rule.create(sheet, "Field", ".oof-ui-field", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = "$CnOpacityClear",
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 0),
	})
	Rule.create(sheet, "FieldLayout", ".oof-ui-field-layout", {
		Padding = "$CnSpace2",
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
	Rule.create(sheet, "FieldHorizontalLayout", ".oof-ui-field-horizontal >> .oof-ui-field-layout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = "$CnSpace3",
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})
	Rule.create(sheet, "FieldLabelControl", ".oof-ui-field-label-control", {
		AutomaticSize = Enum.AutomaticSize.Y,
		AutoButtonColor = false,
		BackgroundTransparency = "$CnOpacityClear",
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 0),
	})
	Rule.create(sheet, "FieldLabel", ".oof-ui-field-label", {
		Font = "$CnFontMedium",
		TextColor3 = "$CnColorText",
		TextSize = "$CnTextSmall",
	})
	Rule.create(sheet, "FieldRequiredLabel", ".oof-ui-field-label-required", {
		TextColor3 = "$CnColorText",
	})
	Rule.create(sheet, "FieldHorizontalLabelControl", ".oof-ui-field-horizontal >> .oof-ui-field-label-control", {
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromOffset(0, 0),
	})
	Rule.create(sheet, "FieldDescription", ".oof-ui-field-description", { TextColor3 = "$CnColorSubtext" })
	Rule.create(sheet, "FieldError", ".oof-ui-field-error", { TextColor3 = "$CnColorTextDanger" })
	Rule.create(sheet, "FieldContent", ".oof-ui-field-content", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = "$CnOpacityClear",
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 0),
	})
	Rule.create(sheet, "FieldContentLayout", ".oof-ui-field-content-layout", {
		Padding = "$CnSpace1",
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
	Rule.create(sheet, "FieldHorizontalContent", ".oof-ui-field-horizontal >> .oof-ui-field-content", {
		Size = UDim2.fromOffset(0, 0),
	})
	Rule.create(sheet, "FieldHorizontalContentFlex", ".oof-ui-field-horizontal >> .oof-ui-field-content-flex", {
		FlexMode = Enum.UIFlexMode.Fill,
	})
	Rule.create(
		sheet,
		"FieldHorizontalContentLabelControl",
		".oof-ui-field-horizontal >> .oof-ui-field-content >> .oof-ui-field-label-control",
		{
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
		}
	)
	Rule.create(
		sheet,
		"FieldHorizontalContentLabel",
		".oof-ui-field-horizontal >> .oof-ui-field-content >> .oof-ui-field-label",
		{
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
		}
	)
	Rule.create(sheet, "FieldHorizontalTextFieldFlex", ".oof-ui-field-horizontal >> .oof-ui-text-field-flex", {
		FlexMode = Enum.UIFlexMode.Fill,
	})
	Rule.create(sheet, "FieldHorizontalTextField", ".oof-ui-field-horizontal >> .oof-ui-text-field", {
		Size = "$CnTextFieldHorizontalSize",
	})
	Rule.create(
		sheet,
		"FieldHorizontalMultilineTextField",
		".oof-ui-field-horizontal >> .oof-ui-text-field-multiline",
		{
			Size = "$CnTextFieldHorizontalMultilineSize",
		}
	)
	Rule.create(sheet, "FieldGroup", ".oof-ui-field-group", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = "$CnOpacityClear",
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 0),
	})
	Rule.create(sheet, "FieldGroupLayout", ".oof-ui-field-group-layout", {
		Padding = "$CnSpace4",
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
	Rule.create(
		sheet,
		"FieldDisabledText",
		".oof-ui-field-disabled >> .oof-ui-field-label, .oof-ui-field-disabled >> .oof-ui-field-description, .oof-ui-field-disabled >> .oof-ui-field-error",
		{
			TextColor3 = "$CnColorSubtext",
			TextTransparency = 0,
		}
	)
end

return FieldRules
