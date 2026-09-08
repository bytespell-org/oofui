--!strict
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameShowcase = require(ReplicatedStorage.OofUiExamples.showcase.GameShowcase)
local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local Scenes = require(ReplicatedStorage.OofUiExamples.showcase.Scenes)
local Ui = require(ReplicatedStorage.OofUiPrimitives)
local World = require(ReplicatedStorage.OofUiExamples.showcase.World)
local e = React.createElement
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
local screen = Instance.new("ScreenGui")
screen.Name = "OofGameShowcase"
screen.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets
screen.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
screen.ClipToDeviceSafeArea = true
screen.ResetOnSpawn = false
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local function App()
	local themeId, setThemeId = React.useState("default")
	local scene = Scenes.worldForTheme(themeId)
	local scale, setScale = React.useState(1)
	local canvasWidth, setCanvasWidth = React.useState(1280)
	local columns, setColumns = React.useState(5)
	local themeIds = Ui.styles.themeIds()
	local pickerHeight = math.ceil(#themeIds / columns) * 40
	local ref = React.useRef(nil :: Frame?)
	React.useEffect(function()
		local previousClockTime = Lighting.ClockTime
		Lighting.ClockTime = Scenes.worlds[scene].clockTime
		local model = Instance.new("Model")
		model.Name = "ShowcaseWorld"
		model:SetAttribute("Scene", scene)
		World.build(model, scene)
		model.Parent = workspace
		local player = Players.LocalPlayer
		local function placeCharacter(character: Model)
			local humanoid = character:WaitForChild("Humanoid") :: Humanoid
			character:WaitForChild("HumanoidRootPart")
			character:PivotTo(World.spawnCFrame)
			local camera = workspace.CurrentCamera
			if camera then
				camera.CameraType = Enum.CameraType.Custom
				camera.CameraSubject = humanoid
				camera.FieldOfView = World.fieldOfView
				camera.CFrame = World.cameraCFrame
			end
			player.CameraMode = Enum.CameraMode.Classic
		end
		local connection = player.CharacterAdded:Connect(placeCharacter)
		if player.Character then
			task.spawn(placeCharacter, player.Character)
		end
		return function()
			connection:Disconnect()
			model:Destroy()
			Lighting.ClockTime = previousClockTime
		end
	end, { scene })
	local style = React.useMemo(function()
		local theme = Ui.styles.createTheme({ theme = Ui.styles.themes[themeId] })
		return { theme = theme, sheet = Ui.styles.createStyleSheet(theme) }
	end, { themeId })
	React.useEffect(function()
		return function()
			style.sheet:Destroy()
			style.theme:Destroy()
		end
	end, { style })
	React.useEffect(function()
		local host = ref.current
		if not host then
			return nil
		end
		local function resize()
			local nextColumns = math.clamp(math.floor(host.AbsoluteSize.X / 118), 1, 5)
			setColumns(nextColumns)
			local footerHeight = math.ceil(#themeIds / nextColumns) * 40 + 16
			local nextScale =
				math.max(0.1, math.min(host.AbsoluteSize.X / 1280, (host.AbsoluteSize.Y - footerHeight) / 720))
			setScale(nextScale)
			-- Fit height without pulling both HUD edges toward the center.
			setCanvasWidth(host.AbsoluteSize.X / nextScale)
		end
		resize()
		local connection = host:GetPropertyChangedSignal("AbsoluteSize"):Connect(resize)
		return function()
			connection:Disconnect()
		end
	end, {})
	local buttons = {
		Layout = e("UIGridLayout", {
			CellSize = UDim2.fromOffset(110, 32),
			CellPadding = UDim2.fromOffset(8, 8),
			FillDirectionMaxCells = columns,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
		}),
	}
	for index, id in themeIds do
		buttons[id] = e(Ui.Button, {
			text = Ui.styles.themes[id].label,
			fullWidth = true,
			variant = if id == themeId then "primary" else "outline",
			size = "small",
			layoutOrder = index,
			onActivated = function()
				setThemeId(id)
			end,
		})
	end
	return e(Ui.styles.StyleProvider, { styleSheet = style.sheet }, {
		Host = e("Frame", {
			ref = ref,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		}, {
			Scene = e("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0),
				Size = UDim2.fromOffset(canvasWidth, 720),
			}, {
				Scale = e("UIScale", { Scale = math.max(0.1, scale) }),
				Game = e(GameShowcase, { themeId = themeId, liveWorld = true }),
			}),
			Themes = e("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 1, -pickerHeight - 8),
				Size = UDim2.new(1, 0, 0, pickerHeight),
			}, buttons),
		}),
	})
end
ReactRoblox.createRoot(screen):render(e(App))
