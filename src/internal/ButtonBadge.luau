--!strict

local React = require(script.Parent.Parent.Dependencies).React
local Tags = require(script.Parent.Tags)
local e = React.createElement

export type Props = {
	value: (boolean | number)?,
	maximum: number?,
	overlay: boolean?,
}

-- A non-interactive ornament: it never adds another selection or input target.
local function ButtonBadge(props: Props): any
	local value = props.value
	if value == nil or value == false then
		return nil
	end
	local text = ""
	if typeof(value) == "number" then
		assert(value == value and math.abs(value) < math.huge, "badge must be a finite count")
		local count = math.floor(value)
		if count <= 0 then
			return nil
		end
		local maximum = props.maximum or 99
		assert(maximum >= 1 and maximum < math.huge and maximum % 1 == 0, "badgeMax must be a positive integer")
		text = if count > maximum then tostring(maximum) .. "+" else tostring(count)
	end
	return e("TextLabel", {
		[React.Tag] = Tags.join(
			"oof-ui-button-badge",
			Tags.when(value == true, "oof-ui-button-badge-dot"),
			Tags.when(props.overlay == true, "oof-ui-button-badge-overlay")
		),
		Active = false,
		Interactable = false,
		Selectable = false,
		LayoutOrder = 4,
		Text = text,
	}, {
		Corner = e("UICorner", { [React.Tag] = "oof-ui-button-badge-corner" }),
		Stroke = e("UIStroke", { [React.Tag] = "oof-ui-button-badge-stroke" }),
		Padding = if value ~= true then e("UIPadding", { [React.Tag] = "oof-ui-button-badge-padding" }) else nil,
	})
end

return ButtonBadge
