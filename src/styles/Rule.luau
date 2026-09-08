--!strict

local Rule = {}

function Rule.create(parent: StyleBase, name: string, selector: string, properties: { [string]: any }?): StyleRule
	local item = Instance.new("StyleRule")
	item.Name = name
	item.Selector = selector
	if properties ~= nil then
		item:SetProperties(properties)
	end
	item:SetAttribute("OofUiRule", true)
	-- Flat component rules intentionally share one priority so base, variant,
	-- state, and descendant declarations compose instead of replacing each
	-- other as whole rules.
	item.Parent = parent
	return item
end

function Rule.transition(item: StyleRule, properties: { [string]: any })
	pcall(function()
		item:SetPropertyTransitions(properties)
	end)
end

return Rule
