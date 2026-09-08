--!strict
-- Capture-only avatar fixture. The playable game uses Players' normal spawning.
local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local fixture = require(script.Parent.avatar)
local Avatar = {}
local cached: Model? = nil
local snapshot: any = nil

local properties = {
	"Face",
	"Head",
	"Torso",
	"LeftArm",
	"RightArm",
	"LeftLeg",
	"RightLeg",
	"Shirt",
	"Pants",
	"GraphicTShirt",
	"BodyTypeScale",
	"DepthScale",
	"HeadScale",
	"HeightScale",
	"ProportionScale",
	"WidthScale",
	"ClimbAnimation",
	"FallAnimation",
	"IdleAnimation",
	"JumpAnimation",
	"RunAnimation",
	"SwimAnimation",
	"WalkAnimation",
}
local colors = { "HeadColor", "TorsoColor", "LeftArmColor", "RightArmColor", "LeftLegColor", "RightLegColor" }

function Avatar.prepare(): any
	if cached then
		return snapshot
	end
	local model: Model
	if fixture.properties then
		local description: any = Instance.new("HumanoidDescription")
		for _, name in properties do
			description[name] = fixture.properties[name]
		end
		for _, name in colors do
			local rgb = fixture.colors[name]
			description[name] = Color3.new(rgb[1], rgb[2], rgb[3])
		end
		local accessories = {}
		for _, accessory in fixture.accessories do
			local item = table.clone(accessory)
			item.AccessoryType = Enum.AccessoryType[item.AccessoryType]
			for _, name in { "Position", "Rotation", "Scale" } do
				if item[name] then
					item[name] = Vector3.new(table.unpack(item[name]))
				end
			end
			table.insert(accessories, item)
		end
		description:SetAccessories(accessories, true)
		model = Players:CreateHumanoidModelFromDescriptionAsync(description, Enum.HumanoidRigType[fixture.rigType])
		description:Destroy()
		snapshot = fixture
	else
		-- Used once when intentionally refreshing the fixture from the Studio account.
		local userId = game:GetService("StudioService"):GetUserId()
		assert(userId > 0, "Sign into Studio to capture its default avatar")
		model = Players:CreateHumanoidModelFromUserIdAsync(userId)
		local humanoid = model:FindFirstChildOfClass("Humanoid") :: Humanoid
		local description: any = humanoid:GetAppliedDescription()
		snapshot = {
			schemaVersion = 1,
			userId = userId,
			rigType = humanoid.RigType.Name,
			properties = {},
			colors = {},
			accessories = {},
		}
		for _, name in properties do
			snapshot.properties[name] = description[name]
		end
		for _, name in colors do
			local color = description[name]
			snapshot.colors[name] = { color.R, color.G, color.B }
		end
		for _, accessory in description:GetAccessories(true) do
			local item = table.clone(accessory)
			item.AccessoryType = item.AccessoryType.Name
			for name, value in item do
				if typeof(value) == "Vector3" then
					item[name] = { value.X, value.Y, value.Z }
				end
			end
			table.insert(snapshot.accessories, item)
		end
		description:Destroy()
	end
	ContentProvider:PreloadAsync({ model })
	model.Name = "PlayerAvatar"
	for _, node in model:GetDescendants() do
		if node:IsA("BasePart") then
			-- Anchoring limbs prevents Roblox from assembling the imported joints.
			node.Anchored = node.Name == "HumanoidRootPart"
		elseif node:IsA("BaseScript") then
			node:Destroy()
		end
	end
	cached = model
	return snapshot
end

function Avatar.clone(): Model
	Avatar.prepare()
	assert(cached, "Roblox avatar did not load")
	return cached:Clone()
end

function Avatar.mount(parent: Instance, spawnCFrame: CFrame): Model
	local character = Avatar.clone()
	character.Parent = parent
	local humanoid = character:FindFirstChildOfClass("Humanoid") :: Humanoid
	local root = character:FindFirstChild("HumanoidRootPart") :: BasePart
	local head = character:FindFirstChild("Head") :: BasePart
	character.PrimaryPart = root
	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	local height = humanoid.HipHeight + root.Size.Y / 2
	if humanoid.RigType == Enum.HumanoidRigType.R6 then
		height += 2
	end
	character:PivotTo(spawnCFrame + Vector3.new(0, height - spawnCFrame.Y, 0))
	local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator")
	animator.Parent = humanoid
	local animation = Instance.new("Animation")
	-- Roblox's shipped Animate defaults, used when the avatar has no idle override.
	local animationId = snapshot.properties.IdleAnimation
	if animationId == 0 then
		animationId = if humanoid.RigType == Enum.HumanoidRigType.R15 then 507766388 else 180435571
	end
	animation.AnimationId = "rbxassetid://" .. tostring(animationId)
	ContentProvider:PreloadAsync({ animation })
	local track = animator:LoadAnimation(animation)
	track:Play(0, 1, 0)
	local deadline = os.clock() + 10
	repeat
		task.wait()
	until track.Length > 0 or os.clock() > deadline
	assert(track.Length > 0, "Roblox's default idle animation did not load")
	track.TimePosition = math.min(0.8, track.Length / 2)
	if not RunService:IsRunning() then
		animator:StepAnimations(0)
	end
	-- WorldModel must resolve the neck joint before the compositor can capture it.
	local neck = character:FindFirstChild("Neck", true)
	assert(neck ~= nil, "Avatar neck joint is missing")
	local function attached()
		local fromBody: CFrame
		local fromHead: CFrame
		if neck:IsA("AnimationConstraint") and neck.Attachment0 and neck.Attachment1 then
			fromBody = neck.Attachment0.WorldCFrame * neck.Transform
			fromHead = neck.Attachment1.WorldCFrame
		elseif neck:IsA("Motor6D") and neck.Part0 and neck.Part1 then
			fromBody = neck.Part0.CFrame * neck.C0 * neck.Transform
			fromHead = neck.Part1.CFrame * neck.C1
		else
			return false
		end
		return (fromBody.Position - fromHead.Position).Magnitude < 0.02
			and (head.Position - root.Position).Magnitude < 4
	end
	repeat
		task.wait()
	until attached() or os.clock() > deadline
	assert(attached(), "Avatar head did not assemble onto the body")
	local animated = false
	for _, node in character:GetDescendants() do
		if (node:IsA("Motor6D") or node:IsA("AnimationConstraint")) and node.Transform ~= CFrame.identity then
			animated = true
		end
	end
	assert(animated, "Roblox idle animation did not pose the avatar")
	assert(head.Transparency < 1 and head.LocalTransparencyModifier < 1, "Avatar head is hidden")
	character:SetAttribute("CaptureIdleAnimation", animationId)
	character:SetAttribute("CaptureIdleTime", track.TimePosition)
	animation:Destroy()
	return character
end

return Avatar
