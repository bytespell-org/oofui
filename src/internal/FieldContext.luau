--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)

local React = Dependencies.React

export type Value = {
	disabled: boolean,
	invalid: boolean,
	activateControl: () -> (),
	registerControl: (GuiObject?, (() -> ())?) -> (),
}

return React.createContext(nil :: Value?)
