--!strict

local Primitives = {
	styles = require(script.styles),
	types = require(script.types),
}

Primitives.Button = require(script.components.Button)
Primitives.Container = require(script.components.Container)
Primitives.IconButton = require(script.components.IconButton)
Primitives.ProgressBar = require(script.components.ProgressBar)
Primitives.RadialProgress = require(script.components.RadialProgress)
Primitives.HoldButton = require(script.components.HoldButton)
Primitives.Dialog = require(script.components.Dialog)
Primitives.TextField = require(script.components.TextField)
Primitives.Field = require(script.components.Field)
Primitives.FieldLabel = require(script.components.FieldLabel)
Primitives.FieldDescription = require(script.components.FieldDescription)
Primitives.FieldError = require(script.components.FieldError)
Primitives.FieldContent = require(script.components.FieldContent)
Primitives.FieldGroup = require(script.components.FieldGroup)
Primitives.Checkbox = require(script.components.Checkbox)
Primitives.Switch = require(script.components.Switch)
Primitives.RadioGroup = require(script.components.RadioGroup)
Primitives.RadioGroupItem = require(script.components.RadioGroupItem)
Primitives.Separator = require(script.components.Separator)
Primitives.Text = require(script.components.Text)

return Primitives
