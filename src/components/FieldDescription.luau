--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)
local Text = require(script.Parent.Text)

local React = Dependencies.React
local e = React.createElement

export type Props = {
	text: string,
	layoutOrder: number?,
	tag: string?,
	rootRef: any?,
}

local function FieldDescription(props: Props): any
	return e(Text, {
		text = props.text,
		variant = "subtext",
		tone = "muted",
		layoutOrder = props.layoutOrder,
		tag = if props.tag == nil then "oof-ui-field-description" else "oof-ui-field-description " .. props.tag,
		rootRef = props.rootRef,
	})
end

return FieldDescription
