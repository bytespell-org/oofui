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

local function FieldError(props: Props): any
	return e(Text, {
		text = props.text,
		variant = "subtext",
		tone = "danger",
		layoutOrder = props.layoutOrder,
		tag = if props.tag == nil then "oof-ui-field-error" else "oof-ui-field-error " .. props.tag,
		rootRef = props.rootRef,
	})
end

return FieldError
