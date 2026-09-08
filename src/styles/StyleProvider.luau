--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)
local React = Dependencies.React
local e = React.createElement

export type Props = {
	styleSheet: StyleSheet,
	children: any?,
}

local function validateMount(link: StyleLink?)
	if link ~= nil and link.Parent ~= nil then
		assert(
			not link.Parent:IsA("PlayerGui"),
			"oof/ui StyleProvider must be inside a ScreenGui, not directly under PlayerGui. Mount the ScreenGui first."
		)
	end
end

local function StyleProvider(props: Props): any
	-- Roblox only resolves linked StyleSheets that live in the DataModel. Keep
	-- the public factory ergonomic by attaching newly-created sheets on demand.
	for _, child in props.styleSheet:GetChildren() do
		if child:IsA("StyleDerive") and child.StyleSheet ~= nil and child.StyleSheet.Parent == nil then
			child.StyleSheet.Parent = script
		end
	end
	if props.styleSheet.Parent == nil then
		props.styleSheet.Parent = script
	end

	return e(React.Fragment, nil, {
		Styles = e("StyleLink", { StyleSheet = props.styleSheet, ref = validateMount }),
		Content = e(React.Fragment, nil, props.children),
	})
end

return StyleProvider
