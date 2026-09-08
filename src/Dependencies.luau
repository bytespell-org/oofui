--!strict

local packageRoot = script.Parent
local container = packageRoot.Parent
local packages = container:FindFirstChild("Packages") or container

local ReactModule = packages:FindFirstChild("React")
local ReactRobloxModule = packages:FindFirstChild("ReactRoblox")

assert(ReactModule ~= nil, "oof/ui primitives requires a sibling React Wally package")
assert(ReactRobloxModule ~= nil, "oof/ui primitives requires a sibling ReactRoblox Wally package")

return {
	React = require(ReactModule),
	ReactRoblox = require(ReactRobloxModule),
}
