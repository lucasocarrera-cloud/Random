-- Builds physical shop stands + simple NPCs with ProximityPrompts.
-- Walk up to one and press E → fires OpenShop to that player.
-- Normal Claude can replace the blocky NPCs with real models later (keep the names).

local RS = game:GetService("ReplicatedStorage")
local World = require(RS.Config.World)
local Remotes = require(RS.Remotes)

local folder = workspace:FindFirstChild("ShopStands")
if folder then folder:Destroy() end
folder = Instance.new("Folder")
folder.Name = "ShopStands"
folder.Parent = workspace

local function makePart(name, size, pos, color, parent)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Position = pos
	p.Anchored = true
	p.Color = color
	p.Material = Enum.Material.SmoothPlastic
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

local function buildStand(key, info)
	local base = info.Pos
	local model = Instance.new("Model")
	model.Name = key
	model.Parent = folder

	-- Counter/stall
	makePart("Counter", Vector3.new(8, 4, 3), base + Vector3.new(0, 2, 0), Color3.fromRGB(120, 85, 60), model)
	-- Striped roof
	makePart("Roof", Vector3.new(10, 1, 5), base + Vector3.new(0, 7, 0), info.NpcColor, model)

	-- Simple blocky NPC behind the counter (placeholder)
	local npc = Instance.new("Model")
	npc.Name = "NPC"
	npc.Parent = model
	local torso = makePart("Torso", Vector3.new(2, 2, 1), base + Vector3.new(0, 5.5, -2), info.NpcColor, npc)
	makePart("Head", Vector3.new(1.4, 1.4, 1.4), base + Vector3.new(0, 7.2, -2), Color3.fromRGB(245, 205, 150), npc)

	-- Floating label
	local bb = Instance.new("BillboardGui")
	bb.Size = UDim2.new(0, 200, 0, 50)
	bb.StudsOffset = Vector3.new(0, 4, 0)
	bb.AlwaysOnTop = true
	bb.Adornee = torso
	bb.Parent = torso
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = info.Label
	lbl.TextColor3 = Color3.new(1, 1, 1)
	lbl.TextStrokeTransparency = 0
	lbl.TextScaled = true
	lbl.Font = Enum.Font.FredokaOne
	lbl.Parent = bb

	-- ProximityPrompt on the counter
	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Open"
	prompt.ObjectText = info.Label
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 12
	prompt.RequiresLineOfSight = false
	prompt.Parent = torso

	prompt.Triggered:Connect(function(player)
		Remotes.OpenShop:FireClient(player, info.Shop)
	end)
end

for key, info in pairs(World.Stands) do
	buildStand(key, info)
end
