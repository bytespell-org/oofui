--!strict

local AdvancedRules = require(script.Parent.rules.AdvancedRules)
local ButtonRules = require(script.Parent.rules.ButtonRules)
local ContainerRules = require(script.Parent.rules.ContainerRules)
local DialogRules = require(script.Parent.rules.DialogRules)
local FieldRules = require(script.Parent.rules.FieldRules)
local ProgressRules = require(script.Parent.rules.ProgressRules)
local SelectionRules = require(script.Parent.rules.SelectionRules)
local TextFieldRules = require(script.Parent.rules.TextFieldRules)
local Theme = require(script.Parent.Theme)
local TypographyRules = require(script.Parent.rules.TypographyRules)

local StyleSheetFactory = {}

function StyleSheetFactory.create(theme: StyleSheet?): StyleSheet
	local sheet = Instance.new("StyleSheet")
	sheet.Name = "OofUiPrimitivesStyleSheet"
	sheet:SetAttribute("OofUiPrimitivesVersion", 1)

	local derive = Instance.new("StyleDerive")
	derive.Name = "Theme"
	derive.StyleSheet = theme or Theme.create()
	derive.Parent = sheet

	-- Semantic typography is the base layer. Component recipes installed after
	-- it may specialize the same Text primitive without fighting rule order.
	TypographyRules.install(sheet)
	ButtonRules.install(sheet)
	ContainerRules.install(sheet)
	ProgressRules.install(sheet)
	DialogRules.install(sheet)
	TextFieldRules.install(sheet)
	FieldRules.install(sheet)
	SelectionRules.install(sheet)
	AdvancedRules.install(sheet)

	-- Private Pro Plus installs its composition rules alongside the core rules.
	local kits = script.Parent.Parent:FindFirstChild("kits")
	if kits then
		require(kits.internal.StyleRules).install(sheet)
	end

	return sheet
end

return StyleSheetFactory
