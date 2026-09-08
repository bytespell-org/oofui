--!strict
-- Distinct game sets, all composed in the same player/camera coordinate system.
local P = require(script.Parent.WorldProps)
local setback = P.destinationSetback
local V, RGB, M = Vector3.new, Color3.fromRGB, Enum.Material
local box, ball, cylinder, wedge = P.box, P.ball, P.cylinder, P.wedge
local beam, assembly, crate, barrel, lantern, tree, plant =
	P.beam, P.assembly, P.crate, P.barrel, P.lantern, P.tree, P.plant
local wood, darkWood = RGB(136, 101, 67), RGB(72, 60, 48)
local iron, pale = RGB(50, 60, 65), RGB(221, 211, 183)

local function light(parent, position, color, size)
	local panel = box(parent, "CeilingLamp", V(size, 0.2, size), position, color, M.Neon)
	local source = Instance.new("SurfaceLight")
	source.Name, source.Face, source.Angle = "WorkLight", Enum.NormalId.Bottom, 150
	source.Color, source.Brightness, source.Range, source.Shadows = color, 2, 45, false
	source.Parent = panel
end

local function bench(parent, position, yaw)
	assembly(parent, "GardenBench", position, yaw, function(m)
		for _, x in { -2.3, 2.3 } do
			box(m, "Leg", V(0.35, 2, 1.9), V(x, 1, 0), iron, M.Metal)
			box(m, "BackPost", V(0.3, 3.6, 0.3), V(x, 1.8, -0.8), iron, M.Metal)
		end
		for i = 0, 3 do
			box(m, "SeatSlat", V(5.6, 0.22, 0.4), V(0, 2, -0.6 + i * 0.45), wood, M.Wood)
		end
		for i = 0, 2 do
			box(m, "BackSlat", V(5.6, 0.4, 0.2), V(0, 2.6 + i * 0.5, -0.8), wood, M.Wood)
		end
	end)
end

local function pot(parent, position, scale)
	cylinder(
		parent,
		"TerracottaPot",
		V(1.4, 1.7, 1.7) * scale,
		position + V(0, 0.7, 0) * scale,
		RGB(166, 99, 69),
		M.Slate
	)
	cylinder(parent, "PotRim", V(0.25, 1.95, 1.95) * scale, position + V(0, 1.4, 0) * scale, RGB(188, 122, 85), M.Slate)
	cylinder(parent, "Soil", V(0.08, 1.65, 1.65) * scale, position + V(0, 1.55, 0) * scale, RGB(66, 55, 39), M.Ground)
	plant(parent, position + V(0, 1.55, 0) * scale, scale * 1.2, true)
end

local function woodland(parent)
	box(parent, "ForestFloor", V(240, 2, 240), V(0, -1, 0), RGB(77, 108, 71), M.Grass)
	-- The boardwalk leads through an inhabited botanical research garden.
	for i = 0, 67 do
		box(
			parent,
			"BoardwalkPlank",
			V(10, 0.18, 1.15),
			V(0, 0.09, 44 - i * 1.2),
			RGB(132 + i % 4 * 5, 113 + i % 3 * 4, 79),
			M.WoodPlanks
		)
	end
	for _, side in { -1, 1 } do
		for i = 0, 4 do
			local x, z = side * (17 + i % 2 * 9), 22 - i * 20
			tree(parent, x, z, 1.8 + i % 3 * 0.25, false, i + side)
			ball(parent, "MossyBoulder", V(7, 3, 5), V(x * 0.7, 0.8, z - 4), RGB(98, 119, 88), M.Slate)
		end
		for i = 1, 15 do
			plant(parent, V(side * (7 + i % 4 * 2), 0, 30 - i * 4), 0.7 + i % 3 * 0.3, i % 4 == 0)
		end
	end
	for i = 0, 8 do
		local x = -64 + i * 16
		ball(parent, "ForestRise", V(30, 10 + i % 3 * 3, 28), V(x, 1, -70), RGB(79, 111, 74), M.Grass)
		tree(parent, x, -60 - i % 2 * 14, 1.8 + i % 3 * 0.3, false, i)
	end

	assembly(parent, "MosslightConservatory", V(0, 0, -26 - setback), 0, function(m)
		local frame = RGB(63, 98, 79)
		box(m, "Foundation", V(27, 0.4, 23), V(0, 0.2, 0), RGB(155, 157, 127), M.Cobblestone)
		for _, x in { -12, 12 } do
			box(m, "DwarfWall", V(0.6, 2, 21), V(x, 1, 0), RGB(134, 147, 119), M.Brick)
			for z = -10, 10, 4 do
				box(m, "IronUpright", V(0.25, 11, 0.25), V(x, 5.5, z), frame, M.Metal)
				beam(m, "Rafter", V(x, 11, z), V(0, 16, z), 0.25, frame, M.Metal)
			end
			for _, y in { 3, 7, 11 } do
				box(m, "GlazingBar", V(0.3, 0.18, 20), V(x, y, 0), frame, M.Metal)
			end
			local glass = box(m, "SideGlazing", V(0.08, 9, 20), V(x, 6.5, 0), RGB(172, 209, 176), M.Glass)
			glass.Transparency = 0.68
			local roof = box(
				m,
				"RoofGlazing",
				V(13, 0.08, 20),
				V(x / 2, 13.5, 0),
				RGB(158, 193, 167),
				M.Glass,
				CFrame.Angles(0, 0, -math.sign(x) * math.atan(5 / 12))
			)
			roof.Transparency = 0.75
		end
		box(m, "Ridge", V(0.4, 0.4, 23), V(0, 16, 0), frame, M.Metal)
		for _, z in { -10, 10 } do
			for _, x in { -8, -4, 4, 8 } do
				box(m, "FrontMullion", V(0.25, 11, 0.25), V(x, 5.5, z), frame, M.Metal)
			end
			box(m, "Lintel", V(24, 0.35, 0.35), V(0, 11, z), frame, M.Metal)
			box(m, "DoorTransom", V(8, 0.3, 0.3), V(0, 8, z), frame, M.Metal)
		end
		for _, x in { -8, 8 } do
			box(m, "PlantingTable", V(4, 2.1, 17), V(x, 1.45, 0), darkWood, M.WoodPlanks)
			for i = 0, 4 do
				pot(m, V(x, 2.5, -7 + i * 3.5), 1)
			end
		end
		light(m, V(0, 12, -2), RGB(236, 236, 185), 2)
	end)
	assembly(parent, "IrrigationPond", V(13, 0, -12), 0, function(m)
		cylinder(m, "PondBasin", V(0.65, 7, 7), V(0, 0.3, 0), RGB(140, 149, 120), M.Slate)
		cylinder(m, "StillWater", V(0.04, 6.3, 6.3), V(0, 0.65, 0), RGB(106, 157, 141), M.SmoothPlastic)
		for i = 1, 3 do
			cylinder(m, "LilyPad", V(0.05, 0.9, 0.9), V(-1 + i % 2 * 2, 0.71, i - 2), RGB(80, 128, 81), M.Grass)
		end
	end)

	assembly(parent, "SeedlingStation", V(12, 0, 2), -12, function(m)
		box(m, "Worktop", V(7, 0.4, 3.5), V(0, 3, 0), wood, M.WoodPlanks)
		for _, x in { -2.8, 2.8 } do
			box(m, "Trestle", V(0.5, 3, 3), V(x, 1.5, 0), darkWood, M.Wood)
		end
		for i = -2, 2 do
			pot(m, V(i * 1.25, 3.2, 0), 0.55)
		end
		box(m, "SeedTray", V(2, 0.4, 1.4), V(1, 0.3, 2.8), wood, M.Wood)
		crate(m, V(-3.7, 0, 1), 0.7, 15, false)
	end)
	bench(parent, V(-10, 0, -3), 25)
	lantern(parent, V(7, 0, 15), true)
	lantern(parent, V(-7, 0, -9), true)
	for i = 0, 6 do
		pot(parent, V(8 + i % 2 * 2, 0, -9 - i * 4), 0.8 + i % 2 * 0.25)
	end
end

local function cabinet(parent, position, yaw, color)
	assembly(parent, "ArcadeCabinet", position, yaw, function(m)
		box(m, "Cabinet", V(3, 5.5, 2.4), V(0, 2.75, 0), RGB(40, 39, 65), M.Metal)
		box(m, "Marquee", V(3.2, 1, 0.3), V(0, 5.8, 1.3), color, M.Neon)
		box(m, "ScreenBezel", V(2.65, 2.2, 0.25), V(0, 3.85, 1.28), RGB(13, 19, 33))
		box(m, "Screen", V(2.2, 1.6, 0.1), V(0, 3.9, 1.43), RGB(55, 118, 145), M.Neon)
		for i = 1, 5 do
			box(m, "Pixel", V(0.22, 0.22, 0.05), V(-0.8 + i * 0.28, 3.4 + i % 3 * 0.3, 1.5), pale, M.Neon)
		end
		box(m, "ControlDeck", V(3.2, 0.35, 1), V(0, 2.55, 1.4), color, M.Metal)
		cylinder(m, "Joystick", V(0.45, 0.12, 0.12), V(-0.7, 2.95, 1.5), iron)
		ball(m, "JoystickTop", V(0.4, 0.4, 0.4), V(-0.7, 3.2, 1.5), color)
		for i = 0, 1 do
			cylinder(m, "Button", V(0.1, 0.28, 0.28), V(0.5 + i * 0.45, 2.78, 1.5), pale, M.Neon)
		end
		box(m, "CoinSlot", V(0.55, 0.8, 0.1), V(0, 1.2, 1.3), iron)
	end)
end

local function arcade(parent)
	local purple, pink, blue = RGB(83, 60, 132), RGB(240, 111, 204), RGB(90, 222, 232)
	box(parent, "Plaza", V(180, 2, 180), V(0, -1, -12), RGB(51, 50, 72), M.Concrete)
	box(parent, "NightCircuit", V(18, 0.08, 130), V(0, 0.04, -12), RGB(34, 36, 51), M.Asphalt)
	for _, side in { -1, 1 } do
		box(parent, "NeonCurb", V(0.25, 0.3, 120), V(side * 9.3, 0.15, -12), if side == 1 then pink else blue, M.Neon)
		for i = 0, 3 do
			local z, x = -45 + i * 19, side * 26
			assembly(parent, "ArcadeFrontage", V(x, 0, z), -side * 90, function(m)
				local h = 18 + i % 2 * 6
				box(m, "Building", V(16, h, 14), V(0, h / 2, 0), RGB(68 + i * 6, 59, 94 + i * 7), M.Brick)
				box(m, "Canopy", V(17, 0.8, 5), V(0, 7, 9), purple, M.Metal)
				box(m, "CanopyEdge", V(17, 0.2, 0.2), V(0, 7, 11.5), if i % 2 == 0 then pink else blue, M.Neon)
				for j = -1, 1 do
					box(m, "StoreWindow", V(4.2, 4.5, 0.2), V(j * 5, 3.2, 7.1), RGB(40, 71, 96), M.Glass)
					box(m, "WindowGlow", V(3.7, 0.15, 0.3), V(j * 5, 5.4, 7.2), blue, M.Neon)
					for y = 11, h - 3, 5 do
						box(m, "UpperWindow", V(3, 2.2, 0.1), V(j * 5, y, 7.1), RGB(158, 130 + j * 15, 162), M.Neon)
					end
				end
			end)
		end
		for i = 0, 4 do
			local z = 23 - i * 15
			box(parent, "LightPole", V(0.35, 9, 0.35), V(side * 11, 4.5, z), iron, M.Metal)
			light(parent, V(side * 11, 9, z), if side == 1 then pink else blue, 1.7)
		end
	end
	assembly(parent, "NightCircuitStart", V(0, 0, -17 - setback), 0, function(m)
		for _, x in { -10, 10 } do
			box(m, "GatePillar", V(1.8, 12, 2), V(x, 6, 0), purple, M.Metal)
			box(m, "VerticalGlow", V(0.2, 10, 0.2), V(x, 6, 1.05), pink, M.Neon)
		end
		box(m, "Header", V(23, 3, 2), V(0, 12, 0), purple, M.Metal)
		for x = -10, 10, 2 do
			for row = 0, 1 do
				box(
					m,
					"CheckeredGate",
					V(1.8, 1, 0.12),
					V(x, 11.5 + row, 1.1),
					if (x / 2 + row) % 2 == 0 then pale else iron
				)
			end
		end
		for i = -1, 1 do
			ball(
				m,
				"StartingSignal",
				V(0.8, 0.8, 0.4),
				V(i * 2, 9, 1.2),
				if i == 1 then RGB(130, 240, 165) else pink,
				M.Neon
			)
		end
	end)
	for i = 0, 2 do
		cabinet(parent, V(15, 0, 6 - i * 4), -65, if i % 2 == 0 then pink else blue)
	end
	assembly(parent, "PlayerKart", V(7, 0, -4), -22, function(m)
		box(m, "Chassis", V(3.3, 0.7, 5.6), V(0, 1, 0), purple, M.Metal)
		box(m, "Hood", V(3.1, 0.65, 2), V(0, 1.7, -1.7), pink, M.Metal)
		box(m, "Seat", V(2, 0.3, 1.6), V(0, 1.6, 0.4), iron)
		box(m, "SeatBack", V(2, 1.6, 0.35), V(0, 2.2, 1.1), iron)
		for _, x in { -1.9, 1.9 } do
			for _, z in { -1.7, 1.7 } do
				cylinder(m, "Tire", V(0.9, 1.5, 1.5), V(x, 0.85, z), RGB(25, 25, 32), M.Rubber, CFrame.identity)
				cylinder(m, "Hub", V(0.95, 0.8, 0.8), V(x, 0.85, z), blue, M.Metal, CFrame.identity)
			end
		end
		beam(m, "SteeringColumn", V(0, 1.6, -0.2), V(0, 2.5, -0.7), 0.2, iron, M.Metal)
		box(m, "SteeringWheel", V(1.3, 0.15, 0.7), V(0, 2.5, -0.7), iron)
		box(m, "Spoiler", V(4.3, 0.2, 0.9), V(0, 2.3, 2.4), blue, M.Metal)
	end)
	bench(parent, V(-13, 0, 7), 75)
	for i = 0, 14 do
		box(parent, "RoadDash", V(0.2, 0.03, 2.5), V(0, 0.1, 31 - i * 6), pale)
	end
	box(parent, "DistantArcade", V(50, 28, 16), V(0, 14, -65), purple, M.Brick)
	for i = -2, 2 do
		box(
			parent,
			"BillboardBars",
			V(4, 5 + i % 3 * 3, 0.2),
			V(i * 7, 18, -56.8),
			if i % 2 == 0 then pink else blue,
			M.Neon
		)
	end
end

local function vault(parent)
	local stone, gold, ink = RGB(93, 90, 99), RGB(195, 160, 91), RGB(42, 41, 51)
	box(parent, "ArchiveFloor", V(70, 2, 150), V(0, -1, -15), stone, M.Slate)
	for x = -30, 30, 6 do
		for z = -55, 35, 6 do
			box(
				parent,
				"FloorSlab",
				V(5.9, 0.08, 5.9),
				V(x, 0.04, z),
				if (x + z) % 4 == 0 then RGB(106, 102, 112) else stone,
				M.Marble
			)
		end
	end
	box(parent, "ArchiveRunner", V(8, 0.03, 66 + setback), V(0, 0.1, 7 - setback / 2), RGB(67, 50, 60), M.Fabric)
	for _, x in { -3.7, 3.7 } do
		box(parent, "RunnerBorder", V(0.12, 0.02, 66 + setback), V(x, 0.12, 7 - setback / 2), gold, M.Fabric)
	end
	for z = -20 - setback, 35, 8 do
		box(parent, "InlaidSeal", V(1.2, 0.02, 1.2), V(0, 0.13, z), gold, M.Metal, CFrame.Angles(0, math.pi / 4, 0))
	end

	box(parent, "VaultCeiling", V(70, 2, 150), V(0, 30, -15), ink, M.Slate)
	for _, side in { -1, 1 } do
		box(parent, "ArchiveWall", V(3, 32, 150), V(side * 34, 14, -15), ink, M.Brick)
		for i = 0, 4 do
			local x, z = side * 16, 20 - i * 15
			box(parent, "ColumnFoot", V(4, 1, 4), V(x, 0.5, z), gold, M.Marble)
			box(parent, "FlutedColumn", V(2.8, 20, 2.8), V(x, 11, z), RGB(79, 77, 87), M.Marble)
			for _, dx in { -1, 1 } do
				box(parent, "ColumnFlute", V(0.15, 17, 0.15), V(x + dx, 11, z + 1.5), gold, M.Metal)
			end
			box(parent, "Capital", V(4.8, 1.5, 4.8), V(x, 21, z), gold, M.Marble)
			beam(parent, "VaultHaunch", V(x, 21, z), V(side * 7, 28, z), 1.3, stone, M.Marble)
			light(parent, V(x * 0.6, 24, z), RGB(255, 219, 161), 2)
		end
	end
	assembly(parent, "KeeperDoor", V(0, 0, -29 - setback), 0, function(m)
		box(m, "StoneFacade", V(33, 23, 4), V(0, 11.5, -2), RGB(71, 69, 80), M.Marble)
		cylinder(m, "DoorDisk", V(0.8, 17, 17), V(0, 10, 0.5), ink, M.Metal, CFrame.Angles(0, math.pi / 2, 0))
		for i = 0, 31 do
			local a = i * math.pi / 16
			box(
				m,
				"GildedDoorRing",
				V(1.8, 0.5, 0.4),
				V(math.sin(a) * 8.4, 10 + math.cos(a) * 8.4, 1.1),
				gold,
				M.Metal,
				CFrame.Angles(0, 0, -a)
			)
		end
		for i = 0, 7 do
			local a = i * math.pi / 4
			beam(
				m,
				"SealSpoke",
				V(math.sin(a) * 2, 10 + math.cos(a) * 2, 1.2),
				V(math.sin(a) * 6.8, 10 + math.cos(a) * 6.8, 1.2),
				0.28,
				gold,
				M.Metal
			)
		end
		box(
			m,
			"AmethystSeal",
			V(2.3, 2.3, 0.6),
			V(0, 10, 1.5),
			RGB(161, 141, 201),
			M.Neon,
			CFrame.Angles(0, 0, math.pi / 4)
		)
		box(m, "Threshold", V(24, 0.3, 5), V(0, 0.15, 2), gold, M.Marble)
	end)
	for _, side in { -1, 1 } do
		for row = 0, 1 do
			assembly(parent, "ArchiveShelves", V(side * 23, 0, -8 - row * 17), -side * 65, function(m)
				box(m, "ShelfBack", V(9, 12, 1), V(0, 6, -1), darkWood, M.Wood)
				for y = 1, 11, 3 do
					box(m, "Shelf", V(9, 0.3, 3), V(0, y, 0), gold, M.Metal)
					for i = 0, 10 do
						box(
							m,
							"BoundLedger",
							V(0.6, 1.6 + i % 3 * 0.3, 1.4),
							V(-3.8 + i * 0.75, y + 1.2, 0),
							RGB(71 + i % 4 * 20, 63 + i % 3 * 9, 79 + i % 2 * 30),
							M.Fabric
						)
					end
				end
			end)
		end
		cylinder(parent, "BrazierStem", V(3, 0.8, 0.8), V(side * 9, 1.5, -14), gold, M.Metal)
		cylinder(parent, "BrazierBowl", V(0.8, 2.8, 2.8), V(side * 9, 3.3, -14), gold, M.Metal)
		ball(parent, "FrozenSoulFlame", V(1.1, 2, 1.1), V(side * 9, 4.4, -14), RGB(218, 184, 255), M.Neon)
	end
	assembly(parent, "ArchivistDesk", V(11, 0, 7), -15, function(m)
		box(m, "Desk", V(6, 3, 3), V(0, 1.5, 0), darkWood, M.WoodPlanks)
		for i = 0, 2 do
			box(m, "LedgerStack", V(1.9, 0.35, 1.5), V(1, 3.2 + i * 0.35, 0), RGB(113, 79 + i * 15, 87), M.Fabric)
		end
		box(m, "OpenPage", V(2, 0.08, 1.5), V(-1.3, 3.1, 0.4), pale)
		lantern(m, V(-2, 3, -0.7), false)
	end)
end

local function harbor(parent)
	local blue, white, red = RGB(60, 119, 143), RGB(223, 219, 198), RGB(186, 86, 64)
	box(parent, "Sea", V(300, 2, 300), V(0, -3, -20), RGB(65, 142, 163), M.SmoothPlastic)
	for i = 0, 35 do
		box(
			parent,
			"WaterRipple",
			V(4 + i % 5 * 3, 0.03, 0.15),
			V((i * 29 % 120) - 60, -1.97, 30 - i * 3.6),
			RGB(126, 185, 189)
		)
	end
	-- Every plank has a supporting deck; the start remains at the shared y=0.
	box(parent, "PierFoundation", V(16, 0.6, 62 + setback), V(0, -0.4, 14 - setback / 2), darkWood, M.Wood)
	for i = 0, 49 + math.ceil(setback / 1.25) do
		box(
			parent,
			"PierPlank",
			V(16, 0.16, 1.2),
			V(0, -0.02, 40 - i * 1.25),
			RGB(133 + i % 3 * 6, 111 + i % 4 * 3, 81),
			M.WoodPlanks
		)
	end
	box(parent, "MarketPier", V(70, 0.5, 24), V(0, -0.3, -10 - setback), wood, M.WoodPlanks)
	for _, side in { -1, 1 } do
		for z = -18 - setback, 32, 10 do
			cylinder(parent, "MooringPost", V(5, 0.8, 0.8), V(side * 8, -0.7, z), darkWood, M.Wood)
			cylinder(parent, "RopeBand", V(0.5, 1, 1), V(side * 8, 1, z), pale, M.Fabric)
		end
	end
	assembly(parent, "HarbormasterHut", V(-19, 0, -16 - setback), 12, function(m)
		box(m, "Weatherboard", V(12, 9, 11), V(0, 4.5, 0), blue, M.WoodPlanks)
		for _, x in { -6, 6 } do
			box(m, "CornerTrim", V(0.35, 9, 0.35), V(x, 4.5, 5.5), white, M.Wood)
		end
		box(m, "Door", V(3, 6.5, 0.2), V(2.7, 3.25, 5.6), darkWood, M.WoodPlanks)
		box(m, "WindowTrim", V(4.5, 3.5, 0.2), V(-2.5, 5, 5.6), white, M.Wood)
		box(m, "Window", V(4, 3, 0.2), V(-2.5, 5, 5.75), RGB(136, 185, 188), M.Glass)
		box(
			m,
			"Roof",
			V(14, 0.6, 13),
			V(0, 9.5, 0),
			RGB(89, 111, 116),
			M.CorrodedMetal,
			CFrame.Angles(math.rad(8), 0, 0)
		)
		cylinder(m, "LifeRing", V(0.3, 2.8, 2.8), V(6.25, 4, 1), red, M.Plastic, CFrame.identity)
		cylinder(m, "RingCenter", V(0.35, 1.7, 1.7), V(6.3, 4, 1), blue, M.Plastic, CFrame.identity)
		barrel(m, V(-5, 0, 8), 0.85)
		lantern(m, V(4.8, 5, 5.9), false)
	end)
	assembly(parent, "MorningFishMarket", V(20, 0, -11 - setback), -12, function(m)
		for _, x in { -5, 5 } do
			for _, z in { -3, 3 } do
				box(m, "AwningPost", V(0.3, 8, 0.3), V(x, 4, z), white, M.Wood)
			end
		end
		for i = 0, 7 do
			box(
				m,
				"StripedAwning",
				V(1.5, 0.15, 8),
				V(-5.25 + i * 1.5, 8, 0),
				if i % 2 == 0 then blue else white,
				M.Fabric,
				CFrame.Angles(math.rad(7), 0, 0)
			)
		end
		box(m, "FishCounter", V(10, 2.5, 4), V(0, 1.25, 0), wood, M.WoodPlanks)
		for i = 0, 2 do
			box(m, "IceTray", V(2.8, 0.4, 3), V(-3.2 + i * 3.2, 2.8, 0), white, M.Ice)
			for j = 0, 2 do
				ball(
					m,
					"Catch",
					V(0.55, 0.35, 1.4),
					V(-3.9 + i * 3.2 + j * 0.7, 3.2, 0),
					RGB(127, 163 + i * 15, 165 + j * 10),
					M.Metal
				)
			end
		end
		crate(m, V(5.5, 0, 4), 0.9, 8, false)
	end)
	assembly(parent, "FishingTrawler", V(1, -1, -40 - setback), 0, function(m)
		box(m, "Hull", V(11, 3, 20), V(0, 0, 0), blue, M.WoodPlanks)
		wedge(m, "Bow", V(11, 3, 5), V(0, 0, 12.5), blue, CFrame.Angles(0, math.pi, 0))
		box(m, "Gunwale", V(11.5, 0.4, 20.5), V(0, 1.5, 0), white, M.Wood)
		box(m, "Deck", V(10, 0.15, 19), V(0, 1.8, 0), wood, M.WoodPlanks)
		box(m, "Wheelhouse", V(7, 5.5, 7), V(0, 4.5, -3), white, M.WoodPlanks)
		box(m, "Windscreen", V(6, 2, 0.15), V(0, 5.3, 0.6), RGB(95, 144, 162), M.Glass)
		box(m, "CabinRoof", V(8.3, 0.4, 8), V(0, 7.4, -3), red, M.Metal)
		cylinder(m, "Mast", V(15, 0.35, 0.35), V(0, 9, -8), white, M.Metal)
		beam(m, "Rigging", V(0, 16.5, -8), V(-5, 2, 6), 0.08, pale, M.Fabric)
		beam(m, "Rigging", V(0, 16.5, -8), V(5, 2, 6), 0.08, pale, M.Fabric)
		box(m, "Pennant", V(3, 1.4, 0.08), V(1.5, 15, -8), red, M.Fabric)
		for _, x in { -5.5, 5.5 } do
			for z = -8, 8, 4 do
				cylinder(m, "Fender", V(0.5, 1.6, 1.6), V(x, 0.8, z), iron, M.Rubber, CFrame.identity)
			end
		end
		crate(m, V(-2.5, 1.9, 5), 0.75, 10, false)
	end)
	box(
		parent,
		"Gangplank",
		V(3.5, 0.18, 8),
		V(0, 0.55, -24 - setback),
		wood,
		M.WoodPlanks,
		CFrame.Angles(math.rad(-8), 0, 0)
	)
	assembly(parent, "HarborCrane", V(28, 0, -18 - setback), -15, function(m)
		box(m, "CraneFoot", V(4, 0.6, 4), V(0, 0.3, 0), iron, M.Metal)
		box(m, "CranePost", V(0.8, 13, 0.8), V(0, 6.5, 0), wood, M.Wood)
		beam(m, "Boom", V(0, 13, 0), V(-8, 13, 0), 0.6, wood, M.Wood)
		beam(m, "Brace", V(0, 8, 0), V(-5, 13, 0), 0.4, iron, M.Metal)
		beam(m, "HoistRope", V(-8, 13, 0), V(-8, 4, 0), 0.1, pale, M.Fabric)
		cylinder(m, "Winch", V(2, 1.4, 1.4), V(0, 4, 1), pale, M.Fabric, CFrame.identity)
		box(m, "Hook", V(0.5, 0.8, 0.2), V(-8, 3.6, 0), iron, M.Metal)
	end)
	assembly(parent, "MooredSkiff", V(17, -0.7, 9), 8, function(m)
		box(m, "BoatBottom", V(4.5, 0.5, 9), V(0, 0, 0), blue, M.WoodPlanks)
		for _, x in { -2.2, 2.2 } do
			box(m, "BoatSide", V(0.3, 1.5, 9), V(x, 0.7, 0), white, M.WoodPlanks)
		end
		for _, z in { -4.5, 4.5 } do
			box(m, "BoatEnd", V(4.5, 1.5, 0.3), V(0, 0.7, z), blue, M.WoodPlanks)
		end
		for _, z in { -2, 2 } do
			box(m, "RowingSeat", V(4.5, 0.2, 1), V(0, 1.1, z), wood, M.Wood)
		end
		beam(m, "Oar", V(-1, 1.5, -3), V(2, 1.5, 3), 0.13, wood, M.Wood)
		box(m, "OarBlade", V(0.7, 0.1, 1.5), V(2.2, 1.5, 3.5), pale, M.Wood, CFrame.Angles(0, math.rad(25), 0))
	end)

	assembly(parent, "FishingGear", V(10, 0, 13), 0, function(m)
		crate(m, V(0, 0, 0), 0.9, 8, false)
		barrel(m, V(2.8, 0, 0), 0.75)
		beam(m, "FishingRod", V(0, 1, 1), V(-0.8, 8, -0.6), 0.08, darkWood, M.Wood)
		beam(m, "FishingLine", V(-0.8, 8, -0.6), V(-2, -1.5, -3), 0.03, pale, M.Fabric)
	end)
	for i = 0, 5 do
		ball(parent, "CoastalCliff", V(25, 12 + i % 3 * 9, 20), V(-70 + i * 28, 2, -90), RGB(155, 163, 143), M.Rock)
	end
	assembly(parent, "Lighthouse", V(32, 0, -60 - setback), 0, function(m)
		cylinder(m, "Foundation", V(4, 14, 14), V(0, 0, 0), RGB(153, 157, 141), M.Rock)
		for i = 0, 3 do
			cylinder(
				m,
				"TowerBand",
				V(5, 7 - i * 0.5, 7 - i * 0.5),
				V(0, 4 + i * 5, 0),
				if i % 2 == 0 then white else red,
				M.Brick
			)
		end
		cylinder(m, "LanternDeck", V(0.5, 8, 8), V(0, 22, 0), iron, M.Metal)
		cylinder(m, "Beacon", V(3, 4.5, 4.5), V(0, 23.7, 0), RGB(255, 230, 165), M.Neon)
		cylinder(m, "LanternRoof", V(0.6, 7, 7), V(0, 25.5, 0), red, M.Metal)
	end)
end

local function forge(parent)
	local brick, soot, copper = RGB(128, 70, 49), RGB(61, 56, 54), RGB(186, 110, 60)
	box(parent, "FoundryYard", V(180, 2, 180), V(0, -1, -10), RGB(124, 111, 95), M.Cobblestone)
	for i = 0, 28 do
		box(parent, "CartTrackSleeper", V(6, 0.1, 0.5), V(-13, 0.1, 34 - i * 3), darkWood, M.Wood)
	end
	for _, x in { -15, -11 } do
		box(parent, "CartRail", V(0.2, 0.15, 90), V(x, 0.2, -8), iron, M.Metal)
	end
	assembly(parent, "IronrootFoundry", V(0, 0, -29 - setback), 0, function(m)
		box(m, "FoundryBack", V(32, 19, 2), V(0, 9.5, -7), brick, M.Brick)
		for _, x in { -11, 11 } do
			box(m, "FurnacePier", V(9, 16, 13), V(x, 8, -1), brick, M.Brick)
			box(m, "IronLintel", V(10, 1, 14), V(x, 16, -1), soot, M.Metal)
			for y = 3, 13, 5 do
				box(m, "IronBand", V(9.2, 0.45, 13.2), V(x, y, -1), soot, M.Metal)
			end
		end
		box(m, "FurnaceArch", V(14, 4, 12), V(0, 13.5, -1), brick, M.Brick)
		box(m, "FireBed", V(12, 0.5, 8), V(0, 0.3, -2), RGB(233, 103, 30), M.Neon)
		box(m, "FireBack", V(11, 8, 0.1), V(0, 4, -5.9), RGB(244, 137, 54), M.Neon)
		for i = -2, 2 do
			box(m, "Grate", V(0.3, 7, 0.3), V(i * 2, 3.5, 5.2), soot, M.Metal)
			ball(m, "Coal", V(1.8, 1.2, 2), V(i * 1.8, 0.9, 2), soot, M.Basalt)
		end
		for i = -1, 1 do
			local x, h = i * 10, 27 - math.abs(i) * 4
			box(m, "Chimney", V(4, h, 5), V(x, h / 2, -11), brick, M.Brick)
			box(m, "ChimneyCap", V(5, 0.8, 6), V(x, h, -11), soot, M.Metal)
		end
		for _, x in { -16, 16 } do
			cylinder(m, "BoilerPipe", V(16, 1, 1), V(x, 8, 3), copper, M.Metal)
			cylinder(m, "PipeFlange", V(0.3, 1.6, 1.6), V(x, 5, 3), iron, M.Metal)
		end
		light(m, V(0, 10, 3), RGB(255, 187, 109), 3)
	end)
	assembly(parent, "Smithy", V(24, 0, -12), -10, function(m)
		box(m, "Workshop", V(13, 9, 15), V(0, 4.5, -2), RGB(171, 143, 111), M.Plaster)
		box(m, "Roof", V(17, 0.5, 19), V(0, 10, -2), soot, M.CorrodedMetal, CFrame.Angles(0, 0, math.rad(-8)))
		for _, x in { -5.5, 5.5 } do
			box(m, "TimberPost", V(0.5, 9, 0.5), V(x, 4.5, 5.5), darkWood, M.Wood)
		end
		box(m, "OpenWorkshop", V(8, 6.5, 0.1), V(0, 3.3, 5.6), soot)
		box(m, "WorkBench", V(9, 2.5, 3), V(0, 1.25, 7), wood, M.WoodPlanks)
		for i = -2, 2 do
			box(m, "ToolHandle", V(0.15, 2.1, 0.15), V(i * 1.4, 5, 5.8), wood, M.Wood)
			box(m, "HammerHead", V(0.9, 0.4, 0.5), V(i * 1.4, 5.8, 5.8), iron, M.Metal)
		end
		lantern(m, V(5, 5.5, 6), false)
	end)
	for _, side in { -1, 1 } do
		for i = 0, 4 do
			box(
				parent,
				"YardRetainingWall",
				V(6, 2.6, 1.2),
				V(side * 25, 1.3, 25 - i * 6),
				soot,
				M.Cobblestone,
				CFrame.Angles(0, math.pi / 2, 0)
			)
		end
	end
	assembly(parent, "FuelStore", V(18, 0, 17), -12, function(m)
		for row = 0, 2 do
			for i = 0, 4 - row do
				cylinder(
					m,
					"DryLog",
					V(4, 0.8, 0.8),
					V(-1.8 + i * 0.85 + row * 0.4, 0.5 + row * 0.7, 0),
					wood,
					M.Wood,
					CFrame.Angles(0, math.pi / 2, 0)
				)
			end
		end
		for _, x in { -2.7, 2.7 } do
			box(m, "RackPost", V(0.3, 3, 0.3), V(x, 1.5, 1.8), iron, M.Metal)
		end
		box(m, "RackRoof", V(6, 0.2, 5), V(0, 3.2, 0), soot, M.CorrodedMetal)
	end)

	assembly(parent, "AnvilStation", V(10, 0, 5), -18, function(m)
		cylinder(m, "OakStump", V(2.5, 3.2, 3.2), V(0, 1.25, 0), darkWood, M.Wood)
		box(m, "AnvilFoot", V(2.5, 0.35, 1.8), V(0, 2.7, 0), iron, M.Metal)
		box(m, "AnvilWaist", V(1.5, 0.8, 1), V(0, 3.25, 0), iron, M.Metal)
		box(m, "AnvilFace", V(3.5, 0.5, 1.7), V(0, 3.9, 0), RGB(110, 113, 111), M.Metal)
		wedge(m, "AnvilHorn", V(1.4, 0.5, 2), V(0, 3.9, -1.5), iron, CFrame.identity)
		beam(m, "HammerHandle", V(1.8, 0.2, 0), V(1.8, 2.5, 0.7), 0.2, wood, M.Wood)
		box(m, "Hammer", V(1.2, 0.6, 0.7), V(1.8, 2.5, 0.7), iron, M.Metal)
		barrel(m, V(3.5, 0, -2), 0.8)
	end)
	assembly(parent, "OreCart", V(-13, 0, -3), 0, function(m)
		box(m, "CartBed", V(4.5, 0.4, 6), V(0, 1.2, 0), iron, M.Metal)
		for _, x in { -2.2, 2.2 } do
			box(m, "CartSide", V(0.3, 2.2, 6), V(x, 2.3, 0), copper, M.Metal)
			for _, z in { -2, 2 } do
				cylinder(m, "Wheel", V(0.5, 1.5, 1.5), V(x, 0.9, z), iron, M.Metal, CFrame.identity)
			end
		end
		for _, z in { -3, 3 } do
			box(m, "CartEnd", V(4.5, 2.2, 0.3), V(0, 2.3, z), copper, M.Metal)
		end
		for i = 0, 9 do
			ball(
				m,
				"IronOre",
				V(1.7, 1.3, 1.8),
				V(-1.3 + i % 3 * 1.3, 2.4 + i % 2 * 0.7, -2 + math.floor(i / 3) * 1.3),
				RGB(97 + i % 3 * 12, 84, 70),
				M.Rock
			)
		end
	end)
	for i = 0, 9 do
		ball(
			parent,
			"MountainRidge",
			V(22, 28 + i % 3 * 9, 20),
			V(-65 + i * 15, 8, -70 - i % 2 * 12),
			RGB(105 + i % 3 * 8, 98, 93),
			M.Rock
		)
	end
	for i = 0, 4 do
		crate(parent, V(13 + i % 2 * 4, 0, -4 - i * 4), 0.8 + i % 2 * 0.25, i * 13, false)
	end
	lantern(parent, V(-7, 0, 14), true)
	lantern(parent, V(7, 0, -14), true)
end

return { woodland = woodland, arcade = arcade, vault = vault, harbor = harbor, forge = forge }
