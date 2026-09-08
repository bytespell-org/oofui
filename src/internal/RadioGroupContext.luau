--!strict

local Dependencies = require(script.Parent.Parent.Dependencies)

local React = Dependencies.React

export type Value = {
	value: string,
	disabled: boolean,
	selectValue: (string) -> (),
}

return React.createContext(nil :: Value?)
