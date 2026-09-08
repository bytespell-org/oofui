--!strict
local V = Vector3.new
local RGB = Color3.fromRGB
local M = Enum.Material
local wood = RGB(121, 88, 59)
local timber = RGB(77, 64, 48)
local metal = RGB(58, 71, 82)
local cream = RGB(228, 214, 176)
local amber = RGB(231, 166, 65)

local function box(parent, name, size, position, color, material, rotation)
	local p = Instance.new("Part")
	p.Name, p.Anchored = name, true
	p.Size, p.Color, p.Material = size, color, material or M.SmoothPlastic
	p.TopSurface, p.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
	p.CFrame = CFrame.new(position) * (rotation or CFrame.identity)
	p.Parent = parent
	return p
end
local function ball(parent, name, size, position, color, material)
	local p = box(parent, name, size, position, color, material)
	p.Shape = Enum.PartType.Ball
	return p
end
local function cylinder(parent, name, size, position, color, material, rotation)
	local p = box(parent, name, size, position, color, material, rotation or CFrame.Angles(0, 0, math.pi / 2))
	p.Shape = Enum.PartType.Cylinder
	return p
end
local function wedge(parent, name, size, position, color, rotation)
	local p = Instance.new("WedgePart")
	p.Name, p.Anchored, p.Size, p.Color, p.Material = name, true, size, color, M.Metal
	p.CFrame = CFrame.new(position) * (rotation or CFrame.identity)
	p.Parent = parent
	return p
end
local function beam(parent, name, a, b, width, color, material)
	return box(
		parent,
		name,
		V(width, width, (b - a).Magnitude),
		(a + b) / 2,
		color,
		material,
		CFrame.lookAt(a, b).Rotation
	)
end
local function assembly(parent, name, position, yaw, build)
	local model = Instance.new("Model")
	model.Name = name
	build(model)
	local origin = CFrame.new(position) * CFrame.Angles(0, math.rad(yaw), 0)
	for _, node in model:GetDescendants() do
		if node:IsA("BasePart") then
			node.CFrame = origin * node.CFrame
		end
	end
	model.Parent = parent
	return model
end

local function crate(parent, position, scale, yaw, industrial)
	assembly(parent, if industrial then "FreightCase" else "SupplyCrate", position, yaw, function(m)
		local color = if industrial then RGB(101, 122, 131) else wood
		box(
			m,
			"Body",
			V(2.8, 2.6, 2.8) * scale,
			V(0, 1.3, 0) * scale,
			color,
			if industrial then M.Metal else M.WoodPlanks
		)
		for _, x in { -1, 1 } do
			box(
				m,
				"Strap",
				V(0.18, 2.75, 2.95) * scale,
				V(x, 1.3, 0) * scale,
				if industrial then metal else cream,
				M.Metal
			)
		end
		for _, y in { 0.18, 2.42 } do
			box(m, "Edge", V(2.95, 0.2, 2.95) * scale, V(0, y, 0) * scale, if industrial then metal else timber, M.Wood)
		end
		box(m, "Latch", V(0.6, 0.6, 0.15) * scale, V(0, 1.5, 1.5) * scale, amber, M.Metal)
		if not industrial then
			beam(m, "Brace", V(-1.15, 0.4, 1.46) * scale, V(1.15, 2.2, 1.46) * scale, 0.2 * scale, cream, M.Wood)
		end
	end)
end
local function barrel(parent, position, scale)
	assembly(parent, "Barrel", position, 0, function(m)
		cylinder(m, "Staves", V(3, 2.3, 2.3) * scale, V(0, 1.5, 0) * scale, wood, M.WoodPlanks)
		for _, y in { 0.3, 1.5, 2.7 } do
			cylinder(m, "Hoop", V(0.15, 2.4, 2.4) * scale, V(0, y, 0) * scale, metal, M.Metal)
		end
	end)
end
local function lantern(parent, position, post)
	assembly(parent, "Lantern", position, 0, function(m)
		local y = if post then 5.6 else 0.8
		if post then
			box(m, "Post", V(0.3, 5.2, 0.3), V(0, 2.6, 0), timber, M.Wood)
			box(m, "Crossarm", V(1.6, 0.25, 0.3), V(0.5, 5.2, 0), timber, M.Wood)
		end
		box(m, "WarmGlass", V(0.85, 1.1, 0.85), V(0, y, 0), RGB(255, 216, 143), M.Neon)
		for _, top in { -0.65, 0.65 } do
			box(m, "Cap", V(1.2, 0.2, 1.2), V(0, y + top, 0), metal, M.Metal)
		end
		for _, x in { -0.45, 0.45 } do
			for _, z in { -0.45, 0.45 } do
				box(m, "Frame", V(0.1, 1.3, 0.1), V(x, y, z), metal, M.Metal)
			end
		end
	end)
end
local function fence(parent, position, length, yaw)
	assembly(parent, "Fence", position, yaw, function(m)
		for x = -length / 2, length / 2, 4 do
			box(m, "Post", V(0.45, 2.7, 0.45), V(x, 1.35, 0), wood, M.Wood)
			box(m, "Cap", V(0.6, 0.18, 0.6), V(x, 2.7, 0), cream, M.Wood)
		end
		for _, y in { 0.9, 1.9 } do
			box(m, "Rail", V(length, 0.3, 0.25), V(0, y, 0), cream, M.Wood)
		end
	end)
end
local function tree(parent, x, z, scale, pink, index)
	assembly(parent, "Tree", V(x, 0, z), index * 31, function(m)
		cylinder(m, "Trunk", V(10, 1.35, 1.35) * scale, V(0, 5, 0) * scale, timber, M.Wood)
		for branch = 1, 3 do
			local angle = branch * math.pi * 2 / 3
			local endPoint = V(math.cos(angle) * 3, 10 + branch, math.sin(angle) * 3) * scale
			beam(m, "Bough", V(0, 6, 0) * scale, endPoint, 0.65 * scale, wood, M.Wood)
		end
		for i = 1, 7 do
			local a = i * 2.4
			local color = if pink
				then RGB(204 + i * 5, 130 + i * 7, 142 + i * 6)
				else RGB(55 + i * 5, 100 + i * 6, 59 + i * 3)
			ball(
				m,
				"Leaves",
				V(6.5, 5.5, 6.5) * scale,
				V(math.cos(a) * 3, 10 + i % 3 * 2, math.sin(a) * 2.5) * scale,
				color,
				M.Grass
			)
		end
		for i = 1, 3 do
			beam(
				m,
				"Root",
				V(0, 0.9, 0) * scale,
				V(math.cos(i * 2.1) * 2, 0.1, math.sin(i * 2.1) * 2) * scale,
				0.5 * scale,
				timber,
				M.Wood
			)
		end
	end)
end
local function plant(parent, position, scale, flower)
	assembly(parent, "WildPlants", position, position.X * 13, function(m)
		for i = 1, 4 do
			local a = i * math.pi / 2
			local p = ball(
				m,
				"Leaf",
				V(0.45, 0.18, 1.8) * scale,
				V(math.cos(a) * 0.55, 0.3 + i % 2 * 0.25, math.sin(a) * 0.55) * scale,
				RGB(61 + i * 7, 113 + i * 9, 58),
				M.Grass
			)
			p.CFrame *= CFrame.Angles(0, -a + math.pi / 2, math.rad(20))
			p.CanCollide = false
		end
		if flower then
			beam(m, "Stem", V(0, 0, 0), V(0.1, 1.2, 0) * scale, 0.1 * scale, RGB(88, 127, 61), M.Grass)
			for i = 1, 5 do
				ball(
					m,
					"Petal",
					V(0.4, 0.16, 0.4) * scale,
					V(math.cos(i * 1.26) * 0.24, 1.2, math.sin(i * 1.26) * 0.24) * scale,
					cream
				)
			end
			ball(m, "Pollen", V(0.3, 0.2, 0.3) * scale, V(0, 1.25, 0) * scale, amber)
		end
	end)
end

return {
	-- Keep destinations beyond the end of the three-second walking take.
	destinationSetback = 20,
	box = box,
	ball = ball,
	cylinder = cylinder,
	wedge = wedge,
	beam = beam,
	assembly = assembly,
	crate = crate,
	barrel = barrel,
	lantern = lantern,
	fence = fence,
	tree = tree,
	plant = plant,
}
