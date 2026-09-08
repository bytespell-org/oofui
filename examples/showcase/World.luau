--!strict
-- Shared walkable sets for live play and deterministic third-person previews.
-- Keep layout independent of UI theme; no clock, unseeded randomness or animation.
local World = {}
World.spawnCFrame = CFrame.new(0, 3, 22)
World.cameraCFrame = CFrame.lookAt(Vector3.new(0, 8, 36), Vector3.new(0, 4.5, 22))
World.fieldOfView = 70

local V = Vector3.new
local RGB = Color3.fromRGB
local M = Enum.Material
local wood = RGB(121, 88, 59)
local timber = RGB(77, 64, 48)
local stone = RGB(157, 162, 139)
local metal = RGB(58, 71, 82)
local cream = RGB(228, 214, 176)
local cyan = RGB(91, 191, 205)
local amber = RGB(231, 166, 65)

local PremiumWorlds = require(script.Parent.PremiumWorlds)
local Props = require(script.Parent.WorldProps)
local setback = Props.destinationSetback
local box, ball, cylinder, wedge = Props.box, Props.ball, Props.cylinder, Props.wedge
local beam, assembly = Props.beam, Props.assembly
local crate, barrel, lantern, fence, tree, plant =
	Props.crate, Props.barrel, Props.lantern, Props.fence, Props.tree, Props.plant

local function landscape(parent, farm)
	box(parent, "Ground", V(240, 2, 240), V(0, -1, 0), if farm then RGB(133, 155, 92) else RGB(107, 138, 86), M.Grass)
	-- A low continuous trail stays walkable; uneven edge slabs and pavers add wear.
	box(parent, "Trail", V(9, 0.08, 100), V(0, 0.04, 12), RGB(171, 151, 112), M.Ground)
	for i = 1, 26 do
		local z = -30 + i * 3
		for _, side in { -1, 1 } do
			local x = side * (4.6 + i % 3 * 0.2)
			ball(
				parent,
				"PathEdge",
				V(2 + i % 2 * 0.4, 0.15, 5),
				V(x, 0.05, z),
				RGB(171 + i % 3 * 4, 151, 113),
				M.Ground
			)
			if i % 2 == 0 then
				plant(parent, V(side * (6 + i % 4), 0, z), 0.6 + i % 3 * 0.2, farm or i % 4 == 0)
			end
		end
		if i % 3 ~= 0 then
			box(
				parent,
				"WornPaver",
				V(1.6 + i % 3 * 0.2, 0.12, 1.2),
				V((i % 3 - 1) * 2.4, 0.1, z),
				RGB(181, 177, 150),
				M.Slate,
				CFrame.Angles(0, i * 1.3, 0)
			)
		end
	end
	for i, t in
		{
			{ -17, 20, 1 },
			{ 20, 17, 1.1 },
			{ -24, -3, 1.2 },
			{ 29, -16, 1.5 },
			{ -30, -32, 1.6 },
			{ 34, -47, 1.8 },
			{ -43, 18, 1.8 },
			{ 45, 28, 1.7 },
			{ -17, -58, 1.5 },
			{ 15, -62, 1.7 },
		}
	do
		tree(parent, t[1], t[2], t[3], farm and i % 3 ~= 0, i)
	end
	for i = 1, 15 do
		ball(
			parent,
			"DistantHill",
			V(58, 35 + i % 4 * 9, 50),
			V(-115 + i * 15, 4, -100 - i % 3 * 14),
			RGB(113 + i % 3 * 8, 140 + i % 4 * 6, 116 + i % 3 * 7),
			M.Grass
		)
	end
	for i = 1, 25 do
		local x = (if i % 2 == 0 then -1 else 1) * (10 + i % 6 * 5)
		local z = -40 + i * 2.7
		local rock = box(
			parent,
			"Fieldstone",
			V(1.4 + i % 3, 0.7 + i % 2, 1.8),
			V(x, 0.2, z),
			stone,
			M.Rock,
			CFrame.Angles(i * 0.15, i, i * 0.2)
		)
		rock.CanCollide = false
		plant(parent, V(x + 1.7, 0, z), 1 + i % 3 * 0.3, farm and i % 3 == 0)
	end
end

local function expedition(parent)
	landscape(parent, false)
	assembly(parent, "ForgottenGate", V(0, 0, -20 - setback), 0, function(m)
		for i = 1, 3 do
			box(m, "ApproachStep", V(18 - i, 0.4, 3), V(0, i * 0.2, 9 - i * 2), stone, M.Slate)
		end
		box(m, "Ruins", V(19, 1, 14), V(0, 0.5, 0), stone, M.Slate)
		for _, x in { -6, 6 } do
			box(m, "Plinth", V(4.8, 1, 4.8), V(x, 1.5, 0), RGB(128, 139, 122), M.Slate)
			for level = 1, 5 do
				box(
					m,
					"WeatheredMasonry",
					V(3.5, 2.35, 3.6),
					V(x + level % 2 * 0.12, 1.4 + level * 2.4, 0),
					RGB(164 + level * 4, 171 + level * 3, 143 + level * 3),
					M.Limestone,
					CFrame.Angles(0, math.rad(level % 2 * 3), 0)
				)
			end
			for _, y in { 3, 11.1, 14.4 } do
				box(m, "CarvedBand", V(4.1, 0.4, 4.1), V(x, y, 0), RGB(131, 146, 128), M.Slate)
			end
			box(m, "InlaidRune", V(0.55, 1.3, 0.12), V(x, 9, 1.89), cyan, M.Neon, CFrame.Angles(0, 0, math.pi / 4))
			for i = 1, 6 do
				ball(
					m,
					"CreepingMoss",
					V(1.7, 0.7, 1.4),
					V(x - 1.5 + i % 2, 15.7 - i * 0.65, 1.8),
					RGB(66, 107 + i * 4, 57),
					M.Grass
				)
			end
		end
		box(m, "Lintel", V(18, 2, 4.5), V(0, 15.5, 0), RGB(183, 190, 157), M.Limestone)
		box(m, "Cornice", V(19, 0.6, 5), V(0, 16.7, 0), stone, M.Slate)
		box(m, "Keystone", V(2.3, 3, 5), V(0, 15.2, 0), RGB(138, 154, 135), M.Slate)
		box(m, "GateSigil", V(0.9, 0.9, 0.14), V(0, 15.4, 2.58), cyan, M.Neon, CFrame.Angles(0, 0, math.pi / 4))
		box(m, "Portal", V(7.7, 11.6, 0.4), V(0, 7, -0.9), RGB(49, 138, 142), M.Glass)
		for _, x in { -3.75, 3.75 } do
			box(m, "PortalEdge", V(0.12, 11.5, 0.15), V(x, 7, -0.6), cyan, M.Neon)
		end
		for i = 1, 5 do
			box(
				m,
				"PortalGlyph",
				V(0.22, 0.22, 0.1),
				V(math.sin(i * 2.1) * 2, 3 + i * 1.5, -0.6),
				RGB(147, 222, 202),
				M.Neon,
				CFrame.Angles(0, 0, math.pi / 4)
			)
		end
	end)
	-- Excavation walls and collapsed masonry give the gate a larger history.
	for _, side in { -1, 1 } do
		for row = 1, 3 do
			for i = 1, 4 do
				box(
					parent,
					"RuinedBoundary",
					V(3.6, 1.5, 2.8),
					V(side * (12 + i * 3.2), row * 1.5 - 0.2, -25 - row % 2 - setback),
					stone,
					M.Limestone,
					CFrame.Angles(0, side * 0.08, 0)
				)
			end
		end
		lantern(parent, V(side * 8, 0, -3), true)
	end
	assembly(parent, "ExpeditionCamp", V(14, 0, -3), -14, function(m)
		for _, x in { -4.5, 4.5 } do
			box(m, "AwningPost", V(0.3, 6.8, 0.3), V(x, 3.4, 0), timber, M.Wood)
			beam(m, "GuyRope", V(x, 6.8, 0), V(x * 1.35, 0.15, 2), 0.07, cream, M.Fabric)
		end
		box(
			m,
			"CanvasAwning",
			V(10, 0.16, 7),
			V(0, 6.8, -2.5),
			RGB(199, 168, 107),
			M.Fabric,
			CFrame.Angles(math.rad(-9), 0, 0)
		)
		box(m, "MapTable", V(6, 0.3, 2.6), V(0, 2.4, -1), wood, M.WoodPlanks)
		for _, x in { -2.5, 2.5 } do
			box(m, "TableLeg", V(0.25, 2.4, 2), V(x, 1.2, -1), timber, M.Wood)
		end
		box(m, "UnrolledMap", V(3.2, 0.04, 1.8), V(-0.6, 2.58, -1), cream, M.Fabric, CFrame.Angles(0, 0.15, 0))
		box(
			m,
			"MapRoute",
			V(1.9, 0.05, 0.08),
			V(-0.5, 2.61, -0.8),
			RGB(167, 78, 56),
			M.SmoothPlastic,
			CFrame.Angles(0, -0.4, 0)
		)
		lantern(m, V(2, 2.6, -1), false)
		crate(m, V(-3, 0, 2.1), 0.8, 8, false)
		barrel(m, V(3.6, 0, -3), 0.9)
		crate(m, V(2.9, 0, 1.3), 0.65, -12, false)
	end)
	assembly(parent, "SurveyScaffold", V(-12, 0, -21 - setback), 0, function(m)
		for _, x in { -2.6, 2.6 } do
			for _, z in { -1.8, 1.8 } do
				box(m, "ScaffoldPost", V(0.3, 11, 0.3), V(x, 5.5, z), timber, M.Wood)
			end
		end
		for _, y in { 4.5, 9 } do
			box(m, "PlankDeck", V(6.2, 0.25, 4.4), V(0, y, 0), wood, M.WoodPlanks)
			beam(m, "CrossBrace", V(-2.6, y - 4, 1.8), V(2.6, y, 1.8), 0.18, cream, M.Wood)
		end
		for i = 1, 10 do
			box(m, "LadderRung", V(1.5, 0.12, 0.15), V(2.6, i * 0.8, 2.1), cream, M.Wood)
		end
		for _, x in { 1.8, 3.4 } do
			box(m, "LadderRail", V(0.18, 9, 0.18), V(x, 4.5, 2.1), wood, M.Wood)
		end
	end)
	assembly(parent, "TrailSupplies", V(9, 0, 14), 12, function(m)
		crate(m, V(0, 0, 0), 0.7, 0, false)
		crate(m, V(0, 1.95, 0), 0.5, -8, false)
		barrel(m, V(2.5, 0, -1), 0.8)
		box(m, "RolledBedroll", V(1.5, 0.7, 0.7), V(-1.8, 0.4, 0), RGB(101, 128, 113), M.Fabric)
		beam(m, "RestingShovel", V(-0.9, 0, -0.9), V(-1.5, 3.5, -0.9), 0.12, wood, M.Wood)
		box(m, "ShovelBlade", V(0.6, 0.75, 0.15), V(-0.9, 0.4, -0.9), metal, M.Metal)
	end)
	for i = 1, 8 do
		box(
			parent,
			"FallenMasonry",
			V(2.4, 1.3, 2),
			V(-9 - i % 3 * 3, 0.6, -9 - i * 1.8),
			stone,
			M.Slate,
			CFrame.Angles(0.1 * i, i * 0.8, 0.1)
		)
	end
	fence(parent, V(-10, 0, 6), 8, 90)
end

local function farm(parent)
	landscape(parent, true)
	assembly(parent, "MeadowCottage", V(-1, 0, -23 - setback), 0, function(m)
		box(m, "Foundation", V(19, 1.2, 15), V(0, 0.6, 0), stone, M.Cobblestone)
		box(m, "Cottage", V(17, 10, 12), V(0, 6, 0), RGB(227, 202, 149), M.Plaster)
		for _, side in { -1, 1 } do
			local gable = wedge(
				m,
				"Gable",
				V(12, 4.9, 8.5),
				V(side * 4.25, 13.05, 0),
				RGB(227, 202, 149),
				CFrame.Angles(0, -side * math.pi / 2, 0)
			)
			gable.Material = M.Plaster
		end
		box(m, "GableUpright", V(0.28, 4.2, 0.3), V(0, 12.8, 6.2), timber, M.Wood)
		for _, x in { -8.4, 8.4 } do
			box(m, "CornerTimber", V(0.4, 10.5, 12.3), V(x, 6, 0), timber, M.Wood)
		end
		for _, y in { 1.5, 10.5 } do
			box(m, "FacadeBeam", V(17.5, 0.4, 0.4), V(0, y, 6.2), timber, M.Wood)
		end
		for _, side in { -1, 1 } do
			local roofRotation = CFrame.Angles(0, 0, math.rad(-side * 30))
			box(m, "Roof", V(11, 0.65, 16), V(side * 4.6, 12.6, 0), RGB(143, 72, 59), M.WoodPlanks, roofRotation)
			-- Overlapping terracotta courses read at the hero camera distance.
			for row = 1, 5 do
				for tile = 1, 8 do
					local localPosition = V((row - 3) * 2.1, 0.4, (tile - 4.5) * 1.95)
					box(
						m,
						"RoofTile",
						V(2.18, 0.16, 1.84),
						V(side * 4.6, 12.6, 0) + roofRotation:VectorToWorldSpace(localPosition),
						RGB(153 + tile % 3 * 7, 79 + row % 2 * 8, 63),
						M.Brick,
						roofRotation
					)
				end
			end
		end
		box(m, "Ridge", V(0.8, 0.45, 16.5), V(0, 15.6, 0), RGB(166, 94, 71), M.Brick)
		box(m, "Chimney", V(2.1, 7, 2.3), V(5, 13, -2), RGB(129, 96, 79), M.Brick)
		box(m, "ChimneyCap", V(2.8, 0.5, 3), V(5, 16.6, -2), stone, M.Slate)
		box(m, "DoorFrame", V(4.2, 7.2, 0.35), V(0, 4.6, 6.2), timber, M.Wood)
		box(m, "Door", V(3.4, 6.5, 0.4), V(0, 4.3, 6.4), RGB(66, 113, 106), M.WoodPlanks)
		ball(m, "Doorknob", V(0.23, 0.23, 0.23), V(1.1, 4, 6.7), amber, M.Metal)
		for _, x in { -5.6, 5.6 } do
			box(m, "WindowTrim", V(3.7, 3.7, 0.4), V(x, 6.1, 6.2), cream, M.Wood)
			box(m, "WindowGlass", V(3.2, 3.2, 0.2), V(x, 6.1, 6.45), RGB(160, 196, 192), M.Glass)
			box(m, "Mullion", V(0.13, 3.3, 0.18), V(x, 6.1, 6.6), cream, M.Wood)
			box(m, "Transom", V(3.3, 0.13, 0.18), V(x, 6.1, 6.6), cream, M.Wood)
			for _, side in { -1, 1 } do
				box(m, "Shutter", V(0.8, 3.7, 0.25), V(x + side * 2.2, 6.1, 6.4), RGB(79, 116, 106), M.WoodPlanks)
			end
			box(m, "WindowBox", V(4, 0.8, 1), V(x, 3.9, 6.7), wood, M.WoodPlanks)
			for i = -1, 1 do
				plant(m, V(x + i, 4.2, 6.8), 0.65, true)
			end
		end
		box(m, "Porch", V(11, 0.4, 4), V(0, 0.9, 8), wood, M.WoodPlanks)
		for i = 1, 3 do
			box(m, "PorchStep", V(5.2, 0.25, 1), V(0, 0.8 - i * 0.2, 9.5 + i * 0.8), stone, M.Cobblestone)
		end
		for _, x in { -5, 5 } do
			box(m, "PorchPost", V(0.3, 6.8, 0.3), V(x, 4.4, 9.5), cream, M.Wood)
		end
		box(
			m,
			"PorchCanopy",
			V(11.8, 0.3, 4.4),
			V(0, 8, 8.2),
			RGB(137, 74, 58),
			M.WoodPlanks,
			CFrame.Angles(math.rad(-12), 0, 0)
		)
		lantern(m, V(-3.7, 1.1, 8.5), false)
	end)
	-- Planted beds, harvest boxes and irrigation make this a working garden.
	for index, x in { 12, 17.5, 23 } do
		assembly(parent, "KitchenGarden", V(x, 0, 1), 0, function(m)
			box(m, "Soil", V(4, 0.4, 16), V(0, 0.2, 0), RGB(90, 68, 48), M.Ground)
			for _, side in { -1, 1 } do
				box(m, "BedSide", V(0.2, 0.65, 16.4), V(side * 2, 0.35, 0), wood, M.Wood)
				box(m, "BedEnd", V(4, 0.65, 0.2), V(0, 0.35, side * 8), wood, M.Wood)
			end
			for z = -6, 6, 3 do
				for _, xOffset in { -0.9, 0.9 } do
					if index == 1 then
						for lobe = 1, 5 do
							ball(
								m,
								"Pumpkin",
								V(0.75, 0.95, 0.75),
								V(xOffset + math.cos(lobe * 1.26) * 0.27, 0.8, z + math.sin(lobe * 1.26) * 0.27),
								RGB(211 + lobe * 4, 119 + lobe * 4, 46),
								M.SmoothPlastic
							)
						end
						box(m, "PumpkinStem", V(0.15, 0.35, 0.15), V(xOffset, 1.4, z), timber, M.Wood)
					elseif index == 2 then
						plant(m, V(xOffset, 0.45, z), 1, false)
						ball(m, "Cabbage", V(0.85, 0.65, 0.85), V(xOffset, 0.9, z), RGB(140, 170, 88), M.Grass)
					else
						box(m, "BeanStake", V(0.08, 2.8, 0.08), V(xOffset, 1.8, z), cream, M.Wood)
						plant(m, V(xOffset, 0.5, z), 0.8, false)
						plant(m, V(xOffset, 1.4, z), 0.65, false)
					end
				end
			end
		end)
	end
	fence(parent, V(19, 0, 12), 16, 0)
	fence(parent, V(27, 0, 0), 24, 90)
	fence(parent, V(-20, 0, -7), 20, 0)
	assembly(parent, "HarvestCart", V(10, 0, 15), -18, function(m)
		box(m, "CartBed", V(3.5, 0.25, 4), V(0, 1.6, 0), wood, M.WoodPlanks)
		for _, x in { -1.7, 1.7 } do
			box(m, "CartSide", V(0.15, 1.2, 4), V(x, 2.2, 0), wood, M.WoodPlanks)
			cylinder(m, "Wheel", V(0.3, 1.6, 1.6), V(x * 1.15, 0.8, 0.5), metal, M.Metal, CFrame.identity)
			box(m, "Handle", V(0.15, 0.15, 3.5), V(x * 0.75, 1.7, 3), timber, M.Wood)
		end
		crate(m, V(0, 1.8, -0.3), 0.65, 0, false)
		for i = 1, 3 do
			ball(m, "Harvest", V(0.75, 0.7, 0.75), V(-0.9 + i * 0.5, 3.5, -0.3), RGB(221, 143, 57))
		end
	end)
	assembly(parent, "PottingBench", V(15, 0, -14), -5, function(m)
		box(m, "Workbench", V(6, 0.25, 2.6), V(0, 2.4, 0), wood, M.WoodPlanks)
		for _, x in { -2.5, 2.5 } do
			box(m, "Leg", V(0.25, 2.4, 2.2), V(x, 1.2, 0), timber, M.Wood)
		end
		for i = -1, 1 do
			cylinder(m, "TerracottaPot", V(0.8, 0.8, 0.8), V(i * 1.5, 2.95, 0), RGB(164, 95, 68), M.ClayRoofTiles)
			plant(m, V(i * 1.5, 3.2, 0), 0.6, true)
		end
		barrel(m, V(4.5, 0, 0), 0.9)
		crate(m, V(-2, 0, 0), 0.65, 0, false)
	end)
	assembly(parent, "LaundryLine", V(-19, 0, -13), 10, function(m)
		for _, x in { -5, 5 } do
			box(m, "LinePost", V(0.22, 5, 0.22), V(x, 2.5, 0), wood, M.Wood)
		end
		beam(m, "Clothesline", V(-5, 4.8, 0), V(5, 4.8, 0), 0.045, cream, M.Fabric)
		for i = 1, 4 do
			box(
				m,
				"DryingCloth",
				V(1.6, 2.1 + i % 2 * 0.5, 0.04),
				V(-5 + i * 2, 3.7, 0),
				if i % 2 == 0 then cream else RGB(112, 153, 168),
				M.Fabric,
				CFrame.Angles(0, 0, math.rad(i - 2))
			)
		end
	end)
	assembly(parent, "Woodpile", V(-11, 0, -13), 0, function(m)
		for row = 1, 3 do
			for i = 1, 4 - row do
				cylinder(
					m,
					"SplitLog",
					V(2.8, 0.7, 0.7),
					V(i * 0.8 + row * 0.4, row * 0.65, 0),
					wood,
					M.Wood,
					CFrame.Angles(0, math.pi / 2, 0)
				)
			end
		end
	end)
	assembly(parent, "OrchardWindmill", V(23, 0, -43), 0, function(m)
		box(m, "Tower", V(6, 15, 6), V(0, 7.5, 0), RGB(201, 190, 155), M.Plaster)
		box(m, "MillRoof", V(8, 1, 8), V(0, 15, 0), RGB(137, 78, 59), M.WoodPlanks)
		for i = 1, 4 do
			local a = i * math.pi / 2 + 0.4
			beam(m, "SailSpar", V(0, 12, 3.5), V(math.cos(a) * 9, 12 + math.sin(a) * 9, 3.5), 0.25, timber, M.Wood)
			box(
				m,
				"Sail",
				V(6, 1.4, 0.15),
				V(math.cos(a) * 5.7, 12 + math.sin(a) * 5.7, 3.5),
				cream,
				M.Fabric,
				CFrame.Angles(0, 0, a)
			)
		end
		cylinder(m, "Hub", V(0.8, 1.3, 1.3), V(0, 12, 3.7), timber, M.Wood, CFrame.Angles(0, math.pi / 2, 0))
	end)
end

local function hangar(parent)
	box(parent, "HangarFloor", V(76, 2, 160), V(0, -1, -16), RGB(46, 55, 66), M.Metal)
	for row = 1, 17 do
		for column = -3, 3 do
			box(
				parent,
				"DeckPanel",
				V(9.85, 0.08, 7.85),
				V(column * 10, 0.03, 52 - row * 8),
				RGB(58 + row % 3 * 2, 67 + column % 2 * 3, 78 + row % 2 * 3),
				M.Metal
			)
		end
	end
	for _, side in { -1, 1 } do
		box(parent, "HangarWall", V(3, 30, 152), V(side * 36, 15, -18), RGB(37, 46, 59), M.Metal)
		for z = -70, 30, 16 do
			box(parent, "StructuralRib", V(3, 28, 1.5), V(side * 33.5, 14, z), RGB(88, 102, 117), M.Metal)
			beam(parent, "Haunch", V(side * 33, 21, z), V(side * 23, 28, z), 1.2, metal, M.Metal)
			box(parent, "WallInset", V(0.15, 10, 11), V(side * 34.3, 10, z + 7), RGB(48, 61, 73), M.DiamondPlate)
			box(parent, "StripLampHousing", V(0.7, 0.6, 9), V(side * 32, 18, z + 7), metal, M.Metal)
			box(parent, "StripLamp", V(0.3, 0.25, 8), V(side * 31.6, 17.8, z + 7), RGB(187, 218, 218), M.Neon)
			box(parent, "GuardRail", V(0.18, 0.18, 14), V(side * 28, 2.8, z + 7), amber, M.Metal)
			box(parent, "GuardPost", V(0.2, 2.8, 0.2), V(side * 28, 1.4, z), metal, M.Metal)
		end
		for y = 1, 3 do
			cylinder(
				parent,
				"UtilityPipe",
				V(135, 0.45, 0.45),
				V(side * 32, 5 + y, -15),
				if y == 2 then RGB(153, 104, 60) else metal,
				M.Metal,
				CFrame.Angles(0, math.pi / 2, 0)
			)
		end
		box(parent, "RunwayStripe", V(0.18, 0.1, 132), V(side * 8, 0.1, -14), RGB(136, 181, 180), M.SmoothPlastic)
		for z = -60, 30, 10 do
			box(parent, "FloorLight", V(0.28, 0.12, 1.5), V(side * 8.3, 0.12, z), cyan, M.Neon)
		end
	end
	box(parent, "Ceiling", V(74, 1, 145), V(0, 30, -18), RGB(30, 40, 51), M.Metal)
	for z = -65, 15, 20 do
		box(parent, "CeilingTruss", V(68, 1.6, 1), V(0, 28.5, z), metal, M.Metal)
		for _, x in { -17, 17 } do
			local fixture = box(parent, "CeilingLight", V(8, 0.2, 1.3), V(x, 28, z), RGB(172, 205, 214), M.Neon)
			-- Neon is visible in previews, but does not illuminate a playable room.
			local light = Instance.new("SurfaceLight")
			light.Name = "WorkLight"
			light.Face = Enum.NormalId.Bottom
			light.Angle, light.Range, light.Brightness = 140, 40, 2.2
			light.Color = RGB(204, 221, 231)
			light.Shadows = false
			light.Parent = fixture
		end
	end
	for z = -60, 18, 9 do
		box(parent, "RunwayMark", V(0.45, 0.1, 2.8), V(0, 0.11, z), cream)
	end
	-- A recessed maintenance pad breaks up the floor without blocking navigation.
	box(parent, "ServicePad", V(36, 0.12, 30), V(0, 0.12, -28 - setback), RGB(76, 84, 90), M.DiamondPlate)
	for _, padZ in { -12, -44 } do
		local z = padZ - setback
		box(parent, "SafetyBand", V(39, 0.08, 1.2), V(0, 0.22, z), RGB(35, 43, 50))
		for x = -18, 18, 2 do
			box(
				parent,
				"HazardStripe",
				V(0.75, 0.1, 1.4),
				V(x, 0.28, z),
				amber,
				M.SmoothPlastic,
				CFrame.Angles(0, -0.45, 0)
			)
		end
	end
	assembly(parent, "SurveyShuttle", V(0, 0, -28 - setback), 0, function(m)
		box(m, "Keel", V(5, 2, 22), V(0, 2.8, 0), metal, M.Metal)
		box(m, "Fuselage", V(7, 3.2, 17), V(0, 5, 0), RGB(182, 192, 193), M.Metal)
		wedge(m, "Nose", V(7, 3.2, 7), V(0, 5, -12), RGB(182, 192, 193))
		wedge(m, "RearSlope", V(7, 2.5, 5), V(0, 6.7, 6), RGB(148, 166, 171), CFrame.Angles(0, math.pi, 0))
		wedge(m, "Cockpit", V(4.8, 2.5, 6), V(0, 7.7, -4), RGB(49, 105, 124))
		box(m, "CanopyFrame", V(5.1, 0.22, 0.25), V(0, 9, -1), metal, M.Metal)
		for _, side in { -1, 1 } do
			wedge(
				m,
				"SweptWing",
				V(10, 0.9, 13),
				V(side * 8, 4.5, 1),
				RGB(101, 135, 148),
				CFrame.Angles(0, 0, side * 0.08)
			)
			box(m, "WingStripe", V(1.5, 0.15, 10), V(side * 8, 5.05, 1), amber, M.Metal)
			cylinder(
				m,
				"EngineHousing",
				V(10, 4.3, 4.3),
				V(side * 8.5, 4.4, 3),
				metal,
				M.Metal,
				CFrame.Angles(0, math.pi / 2, 0)
			)
			for z = 0, 6, 3 do
				cylinder(
					m,
					"EngineBand",
					V(0.35, 4.5, 4.5),
					V(side * 8.5, 4.4, z),
					RGB(126, 149, 155),
					M.Metal,
					CFrame.Angles(0, math.pi / 2, 0)
				)
			end
			cylinder(
				m,
				"ExhaustRim",
				V(0.5, 4.8, 4.8),
				V(side * 8.5, 4.4, 8),
				RGB(118, 139, 149),
				M.Metal,
				CFrame.Angles(0, math.pi / 2, 0)
			)
			cylinder(
				m,
				"Exhaust",
				V(0.52, 3.5, 3.5),
				V(side * 8.5, 4.4, 8.2),
				RGB(32, 45, 53),
				M.Metal,
				CFrame.Angles(0, math.pi / 2, 0)
			)
			cylinder(
				m,
				"EngineCore",
				V(0.55, 2.1, 2.1),
				V(side * 8.5, 4.4, 8.3),
				cyan,
				M.Neon,
				CFrame.Angles(0, math.pi / 2, 0)
			)
			wedge(m, "TailFin", V(0.6, 5, 6), V(side * 4, 8, 5), RGB(112, 141, 155), CFrame.Angles(0, 0, side * -0.18))
			beam(m, "LandingStrut", V(side * 2.5, 3, 5), V(side * 4, 0.7, 6), 0.4, metal, M.Metal)
			box(m, "LandingFoot", V(2.2, 0.5, 3.5), V(side * 4, 0.5, 6), RGB(38, 44, 50), M.Metal)
		end
		box(m, "RearHatch", V(3.5, 2.1, 0.2), V(0, 4.7, 8.6), RGB(71, 93, 105), M.Metal)
		box(
			m,
			"BoardingRamp",
			V(3.5, 0.25, 6),
			V(0, 1.7, 11),
			RGB(98, 116, 126),
			M.DiamondPlate,
			CFrame.Angles(math.rad(22), 0, 0)
		)
	end)
	box(parent, "BayDoorFrame", V(65, 27, 2), V(0, 13.5, -80), RGB(90, 103, 113), M.Metal)
	box(parent, "BayDoor", V(57, 23, 2.1), V(0, 11.5, -78.8), RGB(40, 53, 65), M.Metal)
	for x = -24, 24, 8 do
		box(parent, "DoorPanel", V(7.7, 21, 0.15), V(x, 11, -77.6), RGB(50, 65, 78), M.Metal)
	end
	box(parent, "DoorHeaderLight", V(55, 0.25, 0.2), V(0, 23.5, -77.4), cyan, M.Neon)
	-- Physical seven-segment bay numerals also render inside ViewportFrames.
	for digit, segments in { { 1, 2, 3, 5, 6, 7 }, { 2, 3, 4, 6 } } do
		local poses = {
			{ offset = Vector2.new(0, 3), horizontal = true },
			{ offset = Vector2.new(1.5, 1.5), horizontal = false },
			{ offset = Vector2.new(1.5, -1.5), horizontal = false },
			{ offset = Vector2.new(0, 0), horizontal = true },
			{ offset = Vector2.new(-1.5, -1.5), horizontal = false },
			{ offset = Vector2.new(-1.5, 1.5), horizontal = false },
			{ offset = Vector2.new(0, -3), horizontal = true },
		}
		for _, segment in segments do
			local p = poses[segment]
			box(
				parent,
				"BayNumber",
				if p.horizontal then V(2.5, 0.35, 0.12) else V(0.35, 2.5, 0.12),
				V(-7 + digit * 4.8 + p.offset.X, 17 + p.offset.Y, -77.3),
				cream
			)
		end
	end
	for _, side in { -1, 1 } do
		assembly(parent, "CargoRack", V(side * 23, 0, -21), 0, function(m)
			for _, x in { -4.5, 4.5 } do
				for _, z in { -2.5, 2.5 } do
					box(m, "Upright", V(0.35, 11, 0.35), V(x, 5.5, z), metal, M.Metal)
				end
			end
			for level = 0, 2 do
				box(m, "Shelf", V(10, 0.2, 6), V(0, level * 4 + 0.3, 0), RGB(134, 111, 74), M.Metal)
				for _, x in { -2, 2 } do
					crate(m, V(x, level * 4 + 0.4, 0), 0.9, 0, true)
				end
			end
		end)
	end
	assembly(parent, "FlightOperations", V(20, 0, -3), -18, function(m)
		box(m, "Console", V(7, 2.7, 3.5), V(0, 1.35, 0), metal, M.Metal)
		box(
			m,
			"ConsoleFace",
			V(7.2, 0.25, 3.7),
			V(0, 2.9, 0),
			RGB(91, 112, 125),
			M.Metal,
			CFrame.Angles(math.rad(18), 0, 0)
		)
		for _, x in { -1.8, 1.8 } do
			box(m, "DisplayFrame", V(3, 2.2, 0.3), V(x, 4.2, -0.8), RGB(26, 38, 48), M.Metal)
			box(m, "Display", V(2.6, 1.8, 0.12), V(x, 4.2, -0.59), RGB(29, 91, 106), M.Neon)
			for i = 1, 3 do
				box(m, "Telemetry", V(0.8 + i % 2 * 0.9, 0.1, 0.08), V(x - 0.2, 3.7 + i * 0.3, -0.5), cyan, M.Neon)
			end
		end
		for i = 1, 6 do
			box(
				m,
				"Switch",
				V(0.3, 0.2, 0.35),
				V(-2.4 + i * 0.7, 3.4, 0.7),
				if i % 3 == 0 then amber else cyan,
				M.SmoothPlastic
			)
		end
	end)
	assembly(parent, "MaintenanceTrolley", V(12, 0, 13), -14, function(m)
		for _, x in { -1.7, 1.7 } do
			for _, z in { -1.1, 1.1 } do
				cylinder(m, "Caster", V(0.25, 0.65, 0.65), V(x, 0.35, z), RGB(29, 34, 39), M.Rubber, CFrame.identity)
			end
		end
		box(m, "Cabinet", V(3.5, 2.3, 2.4), V(0, 1.7, 0), RGB(150, 87, 53), M.Metal)
		for i = 1, 3 do
			box(m, "Drawer", V(3.1, 0.6, 0.1), V(0, 0.5 + i * 0.65, 1.26), RGB(174, 112, 65), M.Metal)
			box(m, "Handle", V(1.1, 0.08, 0.12), V(0, 0.65 + i * 0.65, 1.38), metal, M.Metal)
		end
		box(m, "Worktop", V(3.9, 0.2, 2.8), V(0, 2.95, 0), metal, M.Metal)
		box(m, "Tool", V(1.8, 0.1, 0.2), V(0, 3.1, 0), RGB(164, 177, 178), M.Metal, CFrame.Angles(0, 0.5, 0))
		crate(m, V(3.8, 0, -1), 0.75, 12, true)
	end)
	assembly(parent, "RefuelingStation", V(-19, 0, 0), 0, function(m)
		box(m, "Pump", V(3, 4.5, 2.5), V(0, 2.25, 0), RGB(151, 116, 65), M.Metal)
		box(m, "PumpDisplay", V(2.2, 1, 0.2), V(0, 3.5, 1.3), cyan, M.Neon)
		for i = 1, 3 do
			cylinder(m, "GasBottle", V(4, 1.1, 1.1), V(2 + i * 1.5, 2, 0), RGB(89, 125, 132), M.Metal)
			box(m, "Valve", V(0.5, 0.3, 0.3), V(2 + i * 1.5, 4.1, 0), amber, M.Metal)
		end
		for i = 1, 10 do
			local a, b = (i - 1) * 0.4, i * 0.4
			beam(
				m,
				"CoiledHose",
				V(2 + math.sin(a) * 3, 0.18, 4 + math.cos(a) * 2),
				V(2 + math.sin(b) * 3, 0.18, 4 + math.cos(b) * 2),
				0.16,
				RGB(29, 36, 40),
				M.Rubber
			)
		end
	end)
end

function World.build(parent: Instance, scene: string)
	if scene == "outpost" then
		hangar(parent)
	elseif scene == "homestead" then
		farm(parent)
	elseif scene == "island" then
		expedition(parent)
	else
		local build = PremiumWorlds[scene]
		assert(build ~= nil, "Unknown showcase world: " .. scene)
		build(parent)
	end
end
return World
