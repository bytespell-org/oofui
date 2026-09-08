--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)
local Tags = require(script.Parent.Parent.internal.Tags)

local React = Dependencies.React
local e = React.createElement

export type Props = {
	layoutOrder: number?,
	tag: string?,
	rootRef: any?,
	children: any?,
}

local function FieldContent(props: Props): any
	return e("Frame", {
		[React.Tag] = Tags.join("oof-ui-field-content", props.tag),
		ref = props.rootRef,
		LayoutOrder = props.layoutOrder,
	}, {
		Flex = e("UIFlexItem", { [React.Tag] = "oof-ui-field-content-flex" }),
		Layout = e("UIListLayout", { [React.Tag] = "oof-ui-field-content-layout" }),
		Content = e(React.Fragment, nil, props.children),
	})
end

return FieldContent
