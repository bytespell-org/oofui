--!strict

local Tags = {}

function Tags.join(...: string?): string
	local values = { ... }
	local result = ""
	for _, value in values do
		if value ~= nil and value ~= "" then
			result = if result == "" then value else result .. " " .. value
		end
	end
	return result
end

function Tags.when(condition: boolean, value: string): string?
	return if condition then value else nil
end

return Tags
