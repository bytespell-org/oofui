--!strict
-- A composition of existing primitives, kept out of the core control API.
local RS = game:GetService("ReplicatedStorage")
local React = require(RS.Packages.React)
local Ui = require(RS.OofUiPrimitives)
local e = React.createElement

export type Item = { id: string, label: string, icon: string, badge: (boolean | number)? }
export type Props = {
	items: { Item },
	activeId: string?,
	onActivated: (string) -> (),
	position: UDim2?,
}

local function Action(props)
	local ref = React.useRef(nil :: ImageButton?)
	local hovered, setHovered = React.useState(false)
	local focused, setFocused = React.useState(false)
	React.useEffect(function()
		local button = ref.current
		if not button then
			return nil
		end
		local connections = {
			button.MouseEnter:Connect(function()
				setHovered(true)
			end),
			button.MouseLeave:Connect(function()
				setHovered(false)
			end),
			button.SelectionGained:Connect(function()
				setFocused(true)
			end),
			button.SelectionLost:Connect(function()
				setFocused(false)
			end),
		}
		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, {})
	local hint = (hovered or focused) and not props.active
	return e("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(60, 60),
		LayoutOrder = props.order,
		ZIndex = if hint then 8 else 5,
	}, {
		Control = e("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(48, 48) }, {
			Scale = e("UIScale", { Scale = 1.25 }),
			Button = e(Ui.IconButton, {
				rootRef = ref,
				icon = props.item.icon,
				label = props.item.label,
				badge = props.item.badge,
				size = "large",
				variant = if props.active then "primary" else "secondary",
				selectionOrder = props.order,
				onActivated = function()
					props.onActivated(props.item.id)
				end,
			}),
		}),
		Hint = if hint
			then e(Ui.Container, {
				position = UDim2.fromOffset(72, 8),
				size = UDim2.fromOffset(152, 0),
				contentPadding = UDim.new(0, 12),
				zIndex = 8,
			}, { Label = e(Ui.Text, { text = props.item.label, variant = "body" }) })
			else nil,
	})
end

local function ActionRail(props: Props): any
	local children = {
		Layout = e("UIListLayout", { Padding = UDim.new(0, 16), SortOrder = Enum.SortOrder.LayoutOrder }),
	}
	for index, item in props.items do
		children[item.id] = e(Action, {
			item = item,
			order = index,
			active = props.activeId == item.id,
			onActivated = props.onActivated,
		})
	end
	return e("Frame", {
		BackgroundTransparency = 1,
		Position = props.position,
		Size = UDim2.fromOffset(60, #props.items * 76 - 16),
		ZIndex = 5,
	}, children)
end
return ActionRail
