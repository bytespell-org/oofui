--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Primitives = require(ReplicatedStorage:WaitForChild("OofUiPrimitives"))
local React = require(Packages:WaitForChild("React"))

local e = React.createElement

export type Props = {
	title: string,
	description: string,
	image: string,
	price: string,
	currencyIcon: string,
	availabilityLabel: string,
	availability: number,
	discountLabel: string?,
	onPurchase: ((InputObject, number) -> ())?,
	size: UDim2?,
	layoutOrder: number?,
}

local function OfferCard(props: Props): any
	return e(Primitives.Container, {
		contentPadding = UDim.new(0, 20),
		layoutOrder = props.layoutOrder,
		size = props.size or UDim2.fromOffset(352, 0),
	}, {
		Hero = e("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 210),
		}, {
			Artwork = e("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = props.image,
				Position = UDim2.fromScale(0.5, 0.5),
				ScaleType = Enum.ScaleType.Crop,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 1,
			}),
			Discount = if props.discountLabel ~= nil
				then e(Primitives.Container, {
					variant = "destructive",
					automaticSize = Enum.AutomaticSize.Y,
					anchorPoint = Vector2.new(1, 0),
					position = UDim2.new(1, -10, 0, 10),
					size = UDim2.fromOffset(70, 0),
					contentPadding = UDim.new(0, 7),
					zIndex = 2,
				}, {
					Label = e(Primitives.Text, {
						text = props.discountLabel,
						variant = "heading",
						tone = "onAccent",
						textXAlignment = Enum.TextXAlignment.Center,
						zIndex = 3,
					}),
				})
				else nil,
		}),
		Title = e(Primitives.Container, {
			variant = "accent",
			contentPadding = UDim.new(0, 8),
			layoutOrder = 2,
		}, {
			Label = e(Primitives.Text, {
				text = string.upper(props.title),
				variant = "display",
				tone = "onContainerAccent",
				textXAlignment = Enum.TextXAlignment.Center,
			}),
		}),
		Description = e(Primitives.Text, {
			text = props.description,
			variant = "subtext",
			layoutOrder = 3,
		}),
		Separator = e(Primitives.Separator, { layoutOrder = 4 }),
		AvailabilityLabel = e(Primitives.Text, {
			text = props.availabilityLabel,
			variant = "caption",
			tone = "muted",
			layoutOrder = 5,
			textXAlignment = Enum.TextXAlignment.Right,
		}),
		Availability = e(Primitives.ProgressBar, {
			value = props.availability,
			layoutOrder = 6,
		}),
		Purchase = e(Primitives.Button, {
			fullWidth = true,
			layoutOrder = 7,
			onActivated = props.onPurchase,
			size = "large",
		}, {
			Buy = e(Primitives.Text, {
				text = "BUY",
				variant = "heading",
				tone = "onAccent",
				automaticSize = Enum.AutomaticSize.XY,
				layoutOrder = 1,
				size = UDim2.fromOffset(0, 0),
				textWrapped = false,
				zIndex = 3,
			}),
			Currency = e("ImageLabel", {
				BackgroundTransparency = 1,
				Image = props.currencyIcon,
				LayoutOrder = 2,
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.fromOffset(28, 28),
				ZIndex = 3,
			}),
			Price = e(Primitives.Text, {
				text = props.price,
				variant = "heading",
				tone = "onAccent",
				automaticSize = Enum.AutomaticSize.XY,
				layoutOrder = 3,
				size = UDim2.fromOffset(0, 0),
				textWrapped = false,
				zIndex = 3,
			}),
		}),
	})
end

return OfferCard
