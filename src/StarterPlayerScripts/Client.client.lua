local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Remotes = require(ReplicatedStorage.Remotes)
local EggConfig = require(ReplicatedStorage.Config.Eggs)
local WhaleConfig = require(ReplicatedStorage.Config.Whales)

local player = Players.LocalPlayer
local playerGui = player.PlayerGui

-- Track local state
local localCoins = 0
local localOwned = {}
local localEquipped = {}

-- ─── HUD ────────────────────────────────────────────────────────────────────

local hudGui = Instance.new("ScreenGui")
hudGui.Name = "HUD"
hudGui.ResetOnSpawn = false
hudGui.Parent = playerGui

local coinFrame = Instance.new("Frame")
coinFrame.Size = UDim2.new(0, 200, 0, 50)
coinFrame.Position = UDim2.new(0, 16, 0, 16)
coinFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
coinFrame.BackgroundTransparency = 0.3
coinFrame.BorderSizePixel = 0
coinFrame.Parent = hudGui

local coinCorner = Instance.new("UICorner")
coinCorner.CornerRadius = UDim.new(0, 10)
coinCorner.Parent = coinFrame

local coinLabel = Instance.new("TextLabel")
coinLabel.Size = UDim2.new(1, 0, 1, 0)
coinLabel.BackgroundTransparency = 1
coinLabel.Text = "🪙 0 Coins"
coinLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
coinLabel.TextScaled = true
coinLabel.Font = Enum.Font.GothamBold
coinLabel.Parent = coinFrame

-- ─── SHOP GUI ───────────────────────────────────────────────────────────────

local shopGui = Instance.new("ScreenGui")
shopGui.Name = "ShopGui"
shopGui.ResetOnSpawn = false
shopGui.Parent = playerGui

-- Shop toggle button (bottom centre)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 140, 0, 50)
toggleBtn.Position = UDim2.new(0.5, -70, 1, -70)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 255)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "🥚 Shop"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = shopGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggleBtn

-- Shop panel
local shopPanel = Instance.new("Frame")
shopPanel.Size = UDim2.new(0, 340, 0, 420)
shopPanel.Position = UDim2.new(0.5, -170, 0.5, -210)
shopPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
shopPanel.BackgroundTransparency = 0.1
shopPanel.BorderSizePixel = 0
shopPanel.Visible = false
shopPanel.Parent = shopGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 14)
panelCorner.Parent = shopPanel

-- Title
local shopTitle = Instance.new("TextLabel")
shopTitle.Size = UDim2.new(1, 0, 0, 50)
shopTitle.BackgroundTransparency = 1
shopTitle.Text = "🛒 Egg Shop"
shopTitle.TextColor3 = Color3.new(1, 1, 1)
shopTitle.TextScaled = true
shopTitle.Font = Enum.Font.GothamBold
shopTitle.Parent = shopPanel

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -44, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = shopPanel

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- Egg card for Starter Egg
local eggCard = Instance.new("Frame")
eggCard.Size = UDim2.new(1, -40, 0, 280)
eggCard.Position = UDim2.new(0, 20, 0, 60)
eggCard.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
eggCard.BorderSizePixel = 0
eggCard.Parent = shopPanel

local eggCardCorner = Instance.new("UICorner")
eggCardCorner.CornerRadius = UDim.new(0, 12)
eggCardCorner.Parent = eggCard

local eggIcon = Instance.new("TextLabel")
eggIcon.Size = UDim2.new(1, 0, 0, 100)
eggIcon.Position = UDim2.new(0, 0, 0, 10)
eggIcon.BackgroundTransparency = 1
eggIcon.Text = "🥚"
eggIcon.TextScaled = true
eggIcon.Font = Enum.Font.GothamBold
eggIcon.Parent = eggCard

local eggName = Instance.new("TextLabel")
eggName.Size = UDim2.new(1, 0, 0, 36)
eggName.Position = UDim2.new(0, 0, 0, 110)
eggName.BackgroundTransparency = 1
eggName.Text = "Starter Egg"
eggName.TextColor3 = Color3.new(1, 1, 1)
eggName.TextScaled = true
eggName.Font = Enum.Font.GothamBold
eggName.Parent = eggCard

local eggCost = Instance.new("TextLabel")
eggCost.Size = UDim2.new(1, 0, 0, 30)
eggCost.Position = UDim2.new(0, 0, 0, 150)
eggCost.BackgroundTransparency = 1
eggCost.Text = "🪙 100 Coins"
eggCost.TextColor3 = Color3.fromRGB(255, 215, 0)
eggCost.TextScaled = true
eggCost.Font = Enum.Font.Gotham
eggCost.Parent = eggCard

local hatchBtn = Instance.new("TextButton")
hatchBtn.Size = UDim2.new(1, -40, 0, 50)
hatchBtn.Position = UDim2.new(0, 20, 0, 200)
hatchBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
hatchBtn.BorderSizePixel = 0
hatchBtn.Text = "Hatch!"
hatchBtn.TextColor3 = Color3.new(1, 1, 1)
hatchBtn.TextScaled = true
hatchBtn.Font = Enum.Font.GothamBold
hatchBtn.Parent = eggCard

local hatchCorner = Instance.new("UICorner")
hatchCorner.CornerRadius = UDim.new(0, 10)
hatchCorner.Parent = hatchBtn

-- Result label (shown below the card after hatching)
local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(1, -40, 0, 50)
resultLabel.Position = UDim2.new(0, 20, 0, 360)
resultLabel.BackgroundTransparency = 1
resultLabel.Text = ""
resultLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
resultLabel.TextScaled = true
resultLabel.Font = Enum.Font.GothamBold
resultLabel.Parent = shopPanel

-- ─── HATCH RESULT POPUP ─────────────────────────────────────────────────────

local popupGui = Instance.new("ScreenGui")
popupGui.Name = "HatchPopup"
popupGui.ResetOnSpawn = false
popupGui.Parent = playerGui

local popup = Instance.new("Frame")
popup.Size = UDim2.new(0, 300, 0, 180)
popup.Position = UDim2.new(0.5, -150, 0.5, -90)
popup.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
popup.BackgroundTransparency = 0.05
popup.BorderSizePixel = 0
popup.Visible = false
popup.ZIndex = 10
popup.Parent = popupGui

local popupCorner = Instance.new("UICorner")
popupCorner.CornerRadius = UDim.new(0, 16)
popupCorner.Parent = popup

local popupTitle = Instance.new("TextLabel")
popupTitle.Size = UDim2.new(1, 0, 0, 50)
popupTitle.BackgroundTransparency = 1
popupTitle.Text = "You hatched..."
popupTitle.TextColor3 = Color3.new(1, 1, 1)
popupTitle.TextScaled = true
popupTitle.Font = Enum.Font.Gotham
popupTitle.ZIndex = 10
popupTitle.Parent = popup

local popupWhale = Instance.new("TextLabel")
popupWhale.Size = UDim2.new(1, 0, 0, 80)
popupWhale.Position = UDim2.new(0, 0, 0, 50)
popupWhale.BackgroundTransparency = 1
popupWhale.Text = ""
popupWhale.TextColor3 = Color3.fromRGB(100, 220, 255)
popupWhale.TextScaled = true
popupWhale.Font = Enum.Font.GothamBold
popupWhale.ZIndex = 10
popupWhale.Parent = popup

local popupRarity = Instance.new("TextLabel")
popupRarity.Size = UDim2.new(1, 0, 0, 40)
popupRarity.Position = UDim2.new(0, 0, 0, 135)
popupRarity.BackgroundTransparency = 1
popupRarity.Text = ""
popupRarity.TextScaled = true
popupRarity.Font = Enum.Font.GothamBold
popupRarity.ZIndex = 10
popupRarity.Parent = popup

local rarityColors = {
	Common = Color3.fromRGB(180, 180, 180),
	Uncommon = Color3.fromRGB(100, 220, 100),
	Rare = Color3.fromRGB(80, 140, 255),
	Epic = Color3.fromRGB(180, 80, 255),
	Legendary = Color3.fromRGB(255, 180, 0),
}

local function showHatchPopup(whaleName)
	local whale = WhaleConfig[whaleName]
	popupWhale.Text = "🐋 " .. whaleName
	popupRarity.Text = whale and whale.Rarity or ""
	popupRarity.TextColor3 = (whale and rarityColors[whale.Rarity]) or Color3.new(1,1,1)
	popup.Visible = true

	-- Auto-close after 3 seconds
	task.delay(3, function()
		popup.Visible = false
	end)
end

-- ─── LOGIC ──────────────────────────────────────────────────────────────────

local isHatching = false

hatchBtn.MouseButton1Click:Connect(function()
	if isHatching then return end
	isHatching = true
	hatchBtn.Text = "Hatching..."
	hatchBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

	local whaleName, err = Remotes.HatchEgg:InvokeServer("Starter Egg")

	hatchBtn.Text = "Hatch!"
	hatchBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
	isHatching = false

	if whaleName then
		showHatchPopup(whaleName)
	else
		resultLabel.Text = "❌ " .. (err or "Failed")
		task.delay(2, function() resultLabel.Text = "" end)
	end
end)

toggleBtn.MouseButton1Click:Connect(function()
	shopPanel.Visible = not shopPanel.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
	shopPanel.Visible = false
end)

-- ─── REMOTE LISTENERS ───────────────────────────────────────────────────────

Remotes.UpdateCurrency.OnClientEvent:Connect(function(coins)
	localCoins = coins
	coinLabel.Text = "🪙 " .. tostring(math.floor(coins)) .. " Coins"
end)

Remotes.UpdateWhales.OnClientEvent:Connect(function(owned, equipped)
	localOwned = owned
	localEquipped = equipped
end)
