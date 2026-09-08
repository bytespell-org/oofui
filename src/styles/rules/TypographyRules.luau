--!strict

local Rule = require(script.Parent.Parent.Rule)

local TypographyRules = {}

function TypographyRules.install(sheet: StyleSheet)
	Rule.create(sheet, "Text", ".oof-ui-text", {
		BackgroundTransparency = "$CnOpacityClear",
		BorderSizePixel = 0,
	})
	Rule.create(sheet, "TextDisplay", ".oof-ui-text-display", {
		Font = "$CnFontDisplay",
		TextSize = "$CnTextDisplay",
	})
	Rule.create(sheet, "TextHeading", ".oof-ui-text-heading", {
		Font = "$CnFontStrong",
		TextSize = "$CnTextHeading",
	})
	Rule.create(sheet, "TextBody", ".oof-ui-text-body", {
		Font = "$CnFontRegular",
		TextSize = "$CnTextBody",
	})
	Rule.create(sheet, "TextSubtext", ".oof-ui-text-subtext", {
		Font = "$CnFontRegular",
		TextSize = "$CnTextSmall",
	})
	Rule.create(sheet, "TextCaption", ".oof-ui-text-caption", {
		Font = "$CnFontMedium",
		TextSize = "$CnTextCaption",
	})
	Rule.create(sheet, "TextToneDefault", ".oof-ui-text-tone-default", { TextColor3 = "$CnColorText" })
	Rule.create(sheet, "TextToneMuted", ".oof-ui-text-tone-muted", { TextColor3 = "$CnColorSubtext" })
	Rule.create(sheet, "TextToneSuccess", ".oof-ui-text-tone-success", { TextColor3 = "$CnColorTextSuccess" })
	Rule.create(sheet, "TextToneWarning", ".oof-ui-text-tone-warning", { TextColor3 = "$CnColorTextWarning" })
	Rule.create(sheet, "TextToneDanger", ".oof-ui-text-tone-danger", { TextColor3 = "$CnColorTextDanger" })
	Rule.create(sheet, "TextToneOnAccent", ".oof-ui-text-tone-onAccent", { TextColor3 = "$CnColorOnAccent" })
	Rule.create(
		sheet,
		"TextToneOnContainerAccent",
		".oof-ui-text-tone-onContainerAccent",
		{ TextColor3 = "$CnContainerAccentTextColor" }
	)
end

return TypographyRules
