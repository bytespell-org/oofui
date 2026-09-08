--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ActionRail = require(script.Parent.ActionRail)
local Avatar = require(script.Parent.Avatar)
local React = require(ReplicatedStorage.Packages.React)
local Ui = require(ReplicatedStorage.OofUiPrimitives)
local World = require(script.Parent.World)
local e = React.createElement
local paidHudModule = script.Parent:FindFirstChild("PaidHud")
local PaidHud = if paidHudModule then require(paidHudModule) else nil

local Scenes = require(script.Parent.Scenes)

local icons = {
	inventory = "rbxasset://textures/ui/TopBar/inventoryOff@3x.png",
	journal = "rbxasset://textures/ui/Menu/Hamburger@2x.png",
	rewards = "rbxasset://textures/ui/InspectMenu/ico_favorite@3x.png",
	settings = "rbxasset://textures/ui/Settings/MenuBarIcons/GameSettingsTab@2x.png",
}

local function label(text: string, order: number, variant: string?, tone: string?)
	return e(Ui.Text, { text = text, layoutOrder = order, variant = variant, tone = tone })
end

local function View(props: { scene: string }): any
	local ref = React.useRef(nil :: ViewportFrame?)
	React.useEffect(function()
		local viewport = ref.current
		if not viewport then
			return nil
		end
		local model = Instance.new("WorldModel")
		model.Parent = viewport
		World.build(model, props.scene)
		local camera = Instance.new("Camera")
		camera.FieldOfView = World.fieldOfView
		camera.CFrame = World.cameraCFrame
		viewport:SetAttribute("OofAvatarReady", false)
		Avatar.mount(model, World.spawnCFrame)
		viewport:SetAttribute("OofAvatarReady", true)
		camera.Parent = viewport
		viewport.CurrentCamera = camera
		return function()
			model:Destroy()
			camera:Destroy()
		end
	end, { props.scene })
	return e("ViewportFrame", {
		ref = ref,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Ambient = Color3.fromRGB(190, 190, 200),
		LightColor = Color3.fromRGB(255, 241, 218),
		LightDirection = Vector3.new(-1, -1, -0.5),
		ZIndex = 1,
	})
end

local function GameShowcase(props: {
	themeId: string?,
	tokens: { [string]: any }?,
	liveWorld: boolean?,
	safeInsets: { top: number, bottom: number, left: number, right: number }?,
}): any
	local scene = Scenes.worldForTheme(props.themeId or "default")
	-- Live hosts already use CoreUISafeInsets. Full-bleed recordings provide the
	-- actual inset in canvas units; static captures reserve a desktop top bar.
	local insets = props.safeInsets or { top = if props.liveWorld then 0 else 58, bottom = 0, left = 0, right = 0 }
	local f = Scenes.worlds[scene]
	assert(f, "Unknown showcase scene")
	local pinned, setPinned = React.useState(false)
	local sound, setSound = React.useState(true)
	local settingsOpen, setSettingsOpen = React.useState(false)
	local equipped, setEquipped = React.useState(1)
	local journalOpen, setJournalOpen = React.useState(true)
	local panel, setPanel = React.useState("")
	local claimed, setClaimed = React.useState(false)
	React.useEffect(function()
		if not props.liveWorld or PaidHud then
			return nil
		end
		local input = game:GetService("UserInputService")
		local keys =
			{ [Enum.KeyCode.One] = 1, [Enum.KeyCode.Two] = 2, [Enum.KeyCode.Three] = 3, [Enum.KeyCode.Four] = 4 }
		local connection = input.InputBegan:Connect(function(event, processed)
			if processed or input:GetFocusedTextBox() ~= nil then
				return
			end
			local slot = keys[event.KeyCode]
			if slot then
				setEquipped(slot)
			end
		end)
		return function()
			connection:Disconnect()
		end
	end, { props.liveWorld })
	local health, setHealth = React.useState({ current = 100, maximum = 100 })
	React.useEffect(function()
		if not props.liveWorld then
			return nil
		end
		local player = game:GetService("Players").LocalPlayer
		local connections = {}
		local active = true
		local function bind(character: Model)
			for _, connection in connections do
				connection:Disconnect()
			end
			table.clear(connections)
			local humanoid = character:WaitForChild("Humanoid") :: Humanoid
			if not active then
				return
			end
			local function update()
				setHealth({ current = humanoid.Health, maximum = humanoid.MaxHealth })
			end
			table.insert(connections, humanoid.HealthChanged:Connect(update))
			table.insert(connections, humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(update))
			update()
		end
		local added = player.CharacterAdded:Connect(bind)
		if player.Character then
			task.spawn(bind, player.Character)
		end
		return function()
			active = false
			added:Disconnect()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { props.liveWorld })
	local slots = {
		Layout = e("UIGridLayout", {
			CellSize = UDim2.fromOffset(86, 48),
			CellPadding = UDim2.fromOffset(8, 0),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	}
	for index, name in { "Map", "Lantern", "Journal", "Bag" } do
		slots[name] = e(Ui.Button, {
			text = tostring(index) .. "  " .. name,
			size = "small",
			fullWidth = true,
			variant = if equipped == index then "primary" else "outline",
			layoutOrder = index,
			onActivated = function()
				setEquipped(index)
			end,
		})
	end
	return e("Frame", {
		BackgroundColor3 = Color3.fromRGB(table.unpack(f.color)),
		BackgroundTransparency = if props.liveWorld then 1 else 0,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ClipsDescendants = true,
	}, {
		Gradient = if not props.liveWorld
			then e(
				"UIGradient",
				{ Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(200, 215, 225)), Rotation = 90 }
			)
			else nil,
		World = if not props.liveWorld then e(View, { scene = scene }) else nil,
		SafeHUD = e("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Position = UDim2.fromOffset(insets.left, insets.top),
			Size = UDim2.new(1, -insets.left - insets.right, 1, -insets.top - insets.bottom),
		}, {
			PaidHud = if PaidHud
				then e(PaidHud, {
					themeId = props.themeId,
					world = f,
					health = health,
					equipped = equipped,
					keyboardEnabled = props.liveWorld and not settingsOpen and panel == "",
					onEquip = setEquipped,
					onInventory = function()
						setPanel("inventory")
					end,
					onProfile = function()
						setPanel("profile")
					end,
					onRewards = function()
						setPanel("rewards")
					end,
				})
				else nil,
			Heading = e(
				Ui.Container,
				{ position = UDim2.fromOffset(24, 24), size = UDim2.fromOffset(304, 0), zIndex = 3 },
				{
					Name = label(f.name, 1, "heading"),
					Region = label(f.location .. "  /  " .. f.time, 2, "caption"),
				}
			),
			Quest = if journalOpen
				then e(
					Ui.Container,
					{ position = UDim2.fromOffset(108, 158), size = UDim2.fromOffset(304, 0), zIndex = 3 },
					{
						Eyebrow = label(f.journal, 1, "display"),
						Title = label(f.quest, 2, "heading"),
						Objective = label(f.objective, 3, "body"),
						Progress = e(Ui.ProgressBar, { value = 2 / 3, layoutOrder = 4 }),
						ProgressLabel = label(f.progress, 5, "subtext", "success"),
						Action = e(Ui.Button, {
							text = if pinned then "Pinned to your map" else f.action,
							fullWidth = true,
							size = "medium",
							layoutOrder = 6,
							onActivated = function()
								setPinned(not pinned)
							end,
						}),
					}
				)
				else nil,
			Rail = e(ActionRail, {
				position = UDim2.fromOffset(24, 174),
				activeId = if settingsOpen
					then "settings"
					elseif panel ~= "" then panel
					elseif journalOpen then "journal"
					else nil,
				items = {
					{ id = "inventory", label = "Inventory", icon = icons.inventory },
					{ id = "journal", label = f.journal, icon = icons.journal },
					{ id = "rewards", label = "Daily rewards", icon = icons.rewards, badge = if claimed then 0 else 1 },
					{ id = "settings", label = "Settings", icon = icons.settings },
				},
				onActivated = function(id)
					if id == "journal" then
						setJournalOpen(not journalOpen)
					elseif id == "settings" then
						setSettingsOpen(true)
					else
						setPanel(id)
					end
				end,
			}),
			Resources = if not PaidHud
				then e(Ui.Container, {
					anchorPoint = Vector2.new(1, 0),
					position = UDim2.new(1, -24, 0, 24),
					size = UDim2.fromOffset(184, 0),
					contentPadding = UDim.new(0, 18),
					zIndex = 3,
				}, {
					Row = e("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 46) }, {
						Amount = e(
							Ui.Text,
							{ text = f.balance, variant = "display", size = UDim2.fromOffset(108, 30) }
						),
						Currency = e(
							Ui.Text,
							{ text = string.upper(f.currency), variant = "caption", position = UDim2.fromOffset(0, 31) }
						),
						Rewards = e("Frame", {
							BackgroundTransparency = 1,
							Position = UDim2.new(1, -32, 0, 7),
							Size = UDim2.fromOffset(32, 32),
						}, {
							Button = e(Ui.IconButton, {
								icon = icons.rewards,
								label = "View rewards",
								size = "small",
								variant = "outline",
								onActivated = function()
									setPanel("rewards")
								end,
							}),
						}),
					}),
				})
				else nil,
			Vitals = if not PaidHud
				then e(Ui.Container, {
					anchorPoint = Vector2.new(0, 1),
					position = UDim2.new(0, 24, 1, -24),
					size = UDim2.fromOffset(240, 0),
					zIndex = 3,
				}, {
					Name = label(string.upper(f.status), 1, "caption"),
					Health = e(
						Ui.ProgressBar,
						{ value = health.current / math.max(1, health.maximum), layoutOrder = 2 }
					),
					Status = label(
						string.format("%d / %d HP", math.ceil(health.current), math.ceil(health.maximum)),
						3,
						"caption",
						"success"
					),
				})
				else nil,
			Hotbar = if not PaidHud
				then e(Ui.Container, {
					anchorPoint = Vector2.new(0.5, 1),
					position = UDim2.new(0.5, 0, 1, -24),
					size = UDim2.fromOffset(424, 0),
					zIndex = 3,
				}, {
					Slots = e("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 48) }, slots),
				})
				else nil,
			Inventory = e(Ui.Dialog, {
				open = panel == "inventory",
				title = "Your satchel",
				description = "Everything you need for the trail.",
				onOpenChange = function(open)
					if not open then
						setPanel("")
					end
				end,
				footer = {
					Done = e(Ui.Button, {
						text = "Back to game",
						onActivated = function()
							setPanel("")
						end,
					}),
				},
				children = {
					Grid = e("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 154) }, {
						Layout = e("UIGridLayout", {
							CellSize = UDim2.new(0.5, -6, 0, 70),
							CellPadding = UDim2.fromOffset(12, 12),
							SortOrder = Enum.SortOrder.LayoutOrder,
						}),
						Map = e(Ui.Button, {
							text = if PaidHud then "Wayfinder blade" else "Weathered map",
							variant = if equipped == 1 then "primary" else "outline",
							fullWidth = true,
							layoutOrder = 1,
							onActivated = function()
								setEquipped(1)
							end,
						}),
						Lantern = e(Ui.Button, {
							text = if PaidHud then "Harbor shield" else "Brass lantern",
							variant = if equipped == 2 then "primary" else "outline",
							fullWidth = true,
							layoutOrder = 2,
							onActivated = function()
								setEquipped(2)
							end,
						}),
						Journal = e(Ui.Button, {
							text = if PaidHud then "Healing tonic" else "Travel journal",
							variant = if equipped == 3 then "primary" else "outline",
							fullWidth = true,
							layoutOrder = 3,
							onActivated = function()
								setEquipped(3)
							end,
						}),
						Bag = e(Ui.Button, {
							text = if PaidHud then "Wayfinder compass" else "Gathering bag",
							variant = if equipped == 4 then "primary" else "outline",
							fullWidth = true,
							layoutOrder = 4,
							onActivated = function()
								setEquipped(4)
							end,
						}),
					}),
				},
			}),
			Rewards = e(Ui.Dialog, {
				open = panel == "rewards",
				title = "A little something for today",
				description = "Day 3 · Explorer's supplies",
				onOpenChange = function(open)
					if not open then
						setPanel("")
					end
				end,
				children = {
					Summary = e(Ui.Container, { variant = "accent" }, {
						Title = label(
							if claimed then "All collected!" else "Your daily supply crate",
							1,
							"heading",
							"onContainerAccent"
						),
						Detail = label(
							if claimed
								then "Come back tomorrow for your next reward."
								else "A trail ration, a repair kit, and a little luck.",
							2,
							"body",
							"onContainerAccent"
						),
					}),
				},
				footer = {
					Claim = e(Ui.Button, {
						text = if claimed then "Collected" else "Collect supplies",
						disabled = claimed,
						onActivated = function()
							setClaimed(true)
						end,
					}),
					Done = e(Ui.Button, {
						text = "Back to game",
						variant = "outline",
						onActivated = function()
							setPanel("")
						end,
					}),
				},
			}),
			Profile = e(Ui.Dialog, {
				open = panel == "profile",
				title = "NovaRanger",
				description = "Level 12 · " .. f.location,
				onOpenChange = function(open)
					if not open then
						setPanel("")
					end
				end,
				children = {
					Progress = label("640 / 1,000 XP to level 13", 1, "heading"),
					Bar = e(Ui.ProgressBar, { value = 640, maximum = 1000, layoutOrder = 2 }),
					Stats = label("28 discoveries · 16 quests completed", 3, "body"),
				},
				footer = {
					Done = e(Ui.Button, {
						text = "Back to game",
						onActivated = function()
							setPanel("")
						end,
					}),
				},
			}),
			Settings = e(Ui.Dialog, {
				open = settingsOpen,
				title = "Game settings",
				description = "Make yourself comfortable.",
				onOpenChange = setSettingsOpen,
				footer = {
					Done = e(Ui.Button, {
						text = "Done",
						onActivated = function()
							setSettingsOpen(false)
						end,
					}),
				},
				children = {
					Sound = e(Ui.Field, { orientation = "horizontal" }, {
						Content = e(
							Ui.FieldContent,
							{ layoutOrder = 1 },
							{ Label = e(Ui.FieldLabel, { text = "Ambient sound" }) }
						),
						Toggle = e(Ui.Switch, { checked = sound, onCheckedChanged = setSound, layoutOrder = 2 }),
					}),
				},
			}),
		}),
	})
end
return GameShowcase
