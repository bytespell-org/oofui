--!strict

local Refs = {}

function Refs.assign(ref: any?, value: Instance?)
	if ref == nil then
		return
	end
	if type(ref) == "function" then
		ref(value)
	elseif type(ref) == "table" then
		ref.current = value
	end
end

return Refs
