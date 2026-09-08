--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)
local MaterialLayer = require(script.Parent.MaterialLayer)
local SelectionImage = require(script.Parent.SelectionImage)

local React = Dependencies.React
local e = React.createElement

export type Props = {
	prefix: string,
	content: { [string]: any },
	selectionImageRef: (GuiObject?) -> (),
}

local function ControlChrome(props: Props): any
	local prefix = props.prefix
	local children = {
		RootCorner = e("UICorner", {
			[React.Tag] = prefix .. "-root-corner",
		}),
		Depth = e("Frame", {
			[React.Tag] = prefix .. "-depth",
		}, {
			Corner = e("UICorner", { [React.Tag] = prefix .. "-depth-corner" }),
		}),
		Surface = e("Frame", {
			[React.Tag] = prefix .. "-surface",
		}, {
			Corner = e("UICorner", { [React.Tag] = prefix .. "-corner" }),
			Stroke = e("UIStroke", { [React.Tag] = prefix .. "-stroke" }),
			Gradient = e("UIGradient", { [React.Tag] = prefix .. "-gradient" }),
		}),
		Material = e(MaterialLayer, { tag = prefix .. "-material", size = UDim2.fromScale(1, 1) }),
		OutlineAccent = e("Frame", {
			[React.Tag] = prefix .. "-outline-accent",
		}, {
			Corner = e("UICorner", { [React.Tag] = prefix .. "-outline-accent-corner" }),
			Stroke = e("UIStroke", { [React.Tag] = prefix .. "-outline-accent-stroke" }),
		}),
		FocusStroke = e("UIStroke", {
			[React.Tag] = prefix .. "-focus-stroke",
		}),
		SelectionImage = e(SelectionImage, {
			rootRef = props.selectionImageRef,
		}),
	}

	for name, child in props.content do
		children[name] = child
	end

	return children
end

return ControlChrome
