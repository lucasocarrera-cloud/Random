local Players           = game:GetService("Players")
local RS                = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")
local MarketplaceService= game:GetService("MarketplaceService")

local Remotes     = require(RS.Remotes)
local WhaleConfig = require(RS.Config.Whales)
local EggConfig   = require(RS.Config.Eggs)
local PassConfig  = require(RS.Config.GamePasses)
local SpinConfig  = require(RS.Config.SpinWheel)

local player    = Players.LocalPlayer
local playerGui = player.PlayerGui

-- ── STATE ────────────────────────────────────────────────────────────────────

local localCoins   = 0
local localGems    = 0
local localWhales  = {}
local localPlaced  = {}
local localPasses  = {}
local selectedEgg  = "Starter Egg"

-- ── UTILS ────────────────────────────────────────────────────────────────────

local function fmt(n)
	n = math.floor(n)
	if n >= 1e12 then return string.format("%.1fT", n/1e12)
	elseif n >= 1e9 then return string.format("%.1fB", n/1e9)
	elseif n >= 1e6 then return string.format("%.1fM", n/1e6)
	elseif n >= 1e3 then return string.format("%.1fK", n/1e3)
	else return tostring(n) end
end

local rarityColors = {
	Common    = Color3.fromRGB(180,180,180),
	Uncommon  = Color3.fromRGB(80,200,80),
	Rare      = Color3.fromRGB(80,140,255),
	Epic      = Color3.fromRGB(180,80,255),
	Legendary = Color3.fromRGB(255,200,0),
	Mythical  = Color3.fromRGB(255,60,60),
}

local function makeCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 10)
	c.Parent = parent
	return c
end

local function makePadding(parent, px)
	local p = Instance.new("UIPadding")
	p.PaddingLeft   = UDim.new(0,px); p.PaddingRight  = UDim.new(0,px)
	p.PaddingTop    = UDim.new(0,px); p.PaddingBottom = UDim.new(0,px)
	p.Parent = parent
end

local function newLabel(parent, text, size, bold, color)
	local l = Instance.new("TextLabel")
	l.Size = size or UDim2.new(1,0,1,0)
	l.BackgroundTransparency = 1
	l.Text = text or ""
	l.TextColor3 = color or Color3.new(1,1,1)
	l.TextScaled = true
	l.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
	l.Parent = parent
	return l
end

local function newBtn(parent, text, bgColor, size, pos)
	local b = Instance.new("TextButton")
	b.Size = size or UDim2.new(0,120,0,40)
	if pos then b.Position = pos end
	b.BackgroundColor3 = bgColor or Color3.fromRGB(40,120,255)
	b.BorderSizePixel = 0
	b.Text = text or ""
	b.TextColor3 = Color3.new(1,1,1)
	b.TextScaled = true
	b.Font = Enum.Font.GothamBold
	b.Parent = parent
	makeCorner(b, 8)
	return b
end

local function newFrame(parent, size, pos, color, transp)
	local f = Instance.new("Frame")
	f.Size = size or UDim2.new(1,0,1,0)
	if pos then f.Position = pos end
	f.BackgroundColor3 = color or Color3.fromRGB(20,20,40)
	f.BackgroundTransparency = transp or 0
	f.BorderSizePixel = 0
	f.Parent = parent
	return f
end

-- ── ROOT GUI ─────────────────────────────────────────────────────────────────

local root = Instance.new("ScreenGui")
root.Name = "HatchAWhaleGui"
root.ResetOnSpawn = false
root.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
root.Parent = playerGui

-- ═══════════════════════════════════════════════════════════════════════════
-- TOP BAR
-- ═══════════════════════════════════════════════════════════════════════════

local topBar = newFrame(root, UDim2.new(1,0,0,54), UDim2.new(0,0,0,0), Color3.fromRGB(10,10,25), 0.1)

-- Coin display (left)
local coinBox = newFrame(topBar, UDim2.new(0,160,0,40), UDim2.new(0,8,0,7), Color3.fromRGB(20,20,40), 0.2)
makeCorner(coinBox)
local coinLbl = newLabel(coinBox, "🪙 0", nil, true, Color3.fromRGB(255,215,0))

-- Gem display (left of coin)
local gemBox = newFrame(topBar, UDim2.new(0,130,0,40), UDim2.new(0,176,0,7), Color3.fromRGB(20,20,40), 0.2)
makeCorner(gemBox)
local gemLbl = newLabel(gemBox, "💎 0", nil, true, Color3.fromRGB(100,200,255))

-- ── TOP-CENTRE TELEPORT BUTTONS ──────────────────────────────────────────────

local function makeTeleportBtn(text, bgCol, xOffset)
	local btn = newBtn(topBar, text, bgCol, UDim2.new(0,148,0,40),
		UDim2.new(0.5, xOffset, 0, 7))
	return btn
end

local tpSell = makeTeleportBtn("💰 Sell",  Color3.fromRGB(220,80,80),  -230)
local tpPlot = makeTeleportBtn("🗺️ Plot",  Color3.fromRGB(40,140,40),  -74)
local tpShop = makeTeleportBtn("🥚 Eggs",  Color3.fromRGB(40,100,220),  82)

-- Rebirth count badge (right)
local rebirthBox = newFrame(topBar, UDim2.new(0,130,0,40), UDim2.new(1,-138,0,7), Color3.fromRGB(150,80,255), 0.1)
makeCorner(rebirthBox)
local rebirthLbl = newLabel(rebirthBox, "🔄 Rebirths: 0", nil, true)

-- ═══════════════════════════════════════════════════════════════════════════
-- BOTTOM BAR BUTTONS
-- ═══════════════════════════════════════════════════════════════════════════

-- Spin button (bottom left)
local spinBtn = newBtn(root, "🎡 Spin", Color3.fromRGB(200,60,200),
	UDim2.new(0,130,0,50), UDim2.new(0,12,1,-62))

-- Inventory button (bottom centre-left)
local invBtn = newBtn(root, "📦 Whales", Color3.fromRGB(40,100,200),
	UDim2.new(0,130,0,50), UDim2.new(0.5,-135,1,-62))

-- Hatch button (bottom centre-right)
local hatchQuickBtn = newBtn(root, "🥚 Hatch", Color3.fromRGB(50,180,80),
	UDim2.new(0,130,0,50), UDim2.new(0.5,5,1,-62))

-- Robux Shop button (bottom right) — dedicated icon
local robuxBtn = newBtn(root, "🛍️ Shop", Color3.fromRGB(255,140,0),
	UDim2.new(0,130,0,50), UDim2.new(1,-142,1,-62))

-- ═══════════════════════════════════════════════════════════════════════════
-- PANEL HELPER
-- ═══════════════════════════════════════════════════════════════════════════

local function makePanel(w, h)
	local bg = newFrame(root, UDim2.new(0,w,0,h),
		UDim2.new(0.5,-w/2,0.5,-h/2), Color3.fromRGB(12,12,28), 0.05)
	makeCorner(bg, 16)
	bg.Visible = false
	bg.ZIndex = 5

	-- Title bar
	local titleBar = newFrame(bg, UDim2.new(1,0,0,46), UDim2.new(0,0,0,0), Color3.fromRGB(20,20,45))
	makeCorner(titleBar, 16)
	local title = newLabel(titleBar, "Panel", nil, true)
	title.ZIndex = 6

	-- Close btn
	local x = newBtn(titleBar, "✕", Color3.fromRGB(200,50,50), UDim2.new(0,36,0,36),
		UDim2.new(1,-42,0,5))
	x.ZIndex = 7
	makeCorner(x, 6)

	-- Scroll area
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1,-10,1,-56)
	scroll.Position = UDim2.new(0,5,0,51)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 4
	scroll.ZIndex = 6
	scroll.Parent = bg

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0,8)
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.Parent = scroll

	x.MouseButton1Click:Connect(function() bg.Visible = false end)

	return bg, title, scroll, layout
end

-- ═══════════════════════════════════════════════════════════════════════════
-- EGG SHOP PANEL
-- ═══════════════════════════════════════════════════════════════════════════

local eggPanel, eggTitle, eggScroll, eggLayout = makePanel(360, 500)
eggTitle.Text = "🥚 Egg Shop"

local function buildEggShop()
	for _, c in ipairs(eggScroll:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end

	for eggName, egg in pairs(EggConfig) do
		local locked = egg.UnlockRebirth and egg.UnlockRebirth > 0
		local card = newFrame(eggScroll, UDim2.new(1,-8,0,110), nil, Color3.fromRGB(25,25,55))
		makeCorner(card)
		card.ZIndex = 6

		local nameL = newLabel(card, "🥚 " .. eggName, UDim2.new(1,0,0,30), true)
		nameL.Position = UDim2.new(0,0,0,6); nameL.ZIndex = 7

		local costStr
		if egg.GemCost and egg.GemCost > 0 then
			costStr = "💎 " .. egg.GemCost .. " Gems"
		else
			costStr = "🪙 " .. fmt(egg.Cost)
		end
		local costL = newLabel(card, costStr, UDim2.new(1,0,0,24), false, Color3.fromRGB(255,215,0))
		costL.Position = UDim2.new(0,0,0,36); costL.ZIndex = 7

		if locked then
			local lockL = newLabel(card, "🔒 Requires " .. egg.UnlockRebirth .. " rebirths",
				UDim2.new(1,0,0,22), false, Color3.fromRGB(200,100,100))
			lockL.Position = UDim2.new(0,0,0,62); lockL.ZIndex = 7
		else
			local hBtn = newBtn(card, "Hatch 1", Color3.fromRGB(50,180,80),
				UDim2.new(0.45,0,0,32), UDim2.new(0,6,0,62))
			hBtn.ZIndex = 7
			hBtn.MouseButton1Click:Connect(function()
				hBtn.Text = "..."
				local results, err = Remotes.HatchEgg:InvokeServer(eggName)
				hBtn.Text = "Hatch 1"
				if results and #results > 0 then
					showHatchPopup(results)
				else
					showNotif("❌ " .. (err or "Failed"), Color3.fromRGB(255,80,80))
				end
			end)

			local h10Btn = newBtn(card, "Hatch 10", Color3.fromRGB(40,140,220),
				UDim2.new(0.45,0,0,32), UDim2.new(0.52,0,0,62))
			h10Btn.ZIndex = 7
			h10Btn.MouseButton1Click:Connect(function()
				h10Btn.Text = "..."
				-- Fire 10 sequential hatches
				local allResults = {}
				for i = 1, 10 do
					local r, e = Remotes.HatchEgg:InvokeServer(eggName)
					if r then for _, n in ipairs(r) do table.insert(allResults, n) end
					else break end
				end
				h10Btn.Text = "Hatch 10"
				if #allResults > 0 then showHatchPopup(allResults) end
			end)
		end
	end
	eggScroll.CanvasSize = UDim2.new(0,0,0, eggLayout.AbsoluteContentSize.Y + 16)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- INVENTORY PANEL
-- ═══════════════════════════════════════════════════════════════════════════

local invPanel, invTitle, invScroll, invLayout = makePanel(380, 520)
invTitle.Text = "🐋 Your Whales"

local function buildInventory()
	for _, c in ipairs(invScroll:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end

	local hasAny = false
	for whaleName, count in pairs(localWhales) do
		if count and count > 0 then
			hasAny = true
			local whale = WhaleConfig[whaleName]
			if not whale then continue end
			local rCol = rarityColors[whale.Rarity] or Color3.new(1,1,1)

			local card = newFrame(invScroll, UDim2.new(1,-8,0,90), nil, Color3.fromRGB(25,25,55))
			makeCorner(card)
			card.ZIndex = 6

			-- Rarity stripe
			local stripe = newFrame(card, UDim2.new(0,6,1,0), UDim2.new(0,0,0,0), rCol)
			makeCorner(stripe, 4); stripe.ZIndex = 7

			local nameL = newLabel(card, whaleName, UDim2.new(0.55,0,0,28), true)
			nameL.Position = UDim2.new(0,12,0,4); nameL.TextXAlignment = Enum.TextXAlignment.Left; nameL.ZIndex = 7

			local rarL = newLabel(card, whale.Rarity, UDim2.new(0.4,0,0,22), false, rCol)
			rarL.Position = UDim2.new(0,12,0,32); rarL.TextXAlignment = Enum.TextXAlignment.Left; rarL.ZIndex = 7

			local incL = newLabel(card, "💰 " .. fmt(whale.Income) .. "/sec", UDim2.new(0.5,0,0,22), false, Color3.fromRGB(255,215,0))
			incL.Position = UDim2.new(0,12,0,56); incL.TextXAlignment = Enum.TextXAlignment.Left; incL.ZIndex = 7

			local cntL = newLabel(card, "×" .. count, UDim2.new(0.2,0,0,28), true, Color3.fromRGB(200,200,200))
			cntL.Position = UDim2.new(0.78,0,0,4); cntL.ZIndex = 7

			-- Sell button
			local sellBtn2 = newBtn(card, "Sell\n🪙" .. fmt(whale.SellValue), Color3.fromRGB(200,60,60),
				UDim2.new(0.18,0,0,50), UDim2.new(0.81,0,0,30))
			sellBtn2.ZIndex = 7
			sellBtn2.MouseButton1Click:Connect(function()
				local earned, err = Remotes.SellWhale:InvokeServer(whaleName)
				if earned and earned > 0 then
					showNotif("Sold " .. whaleName .. " for 🪙" .. fmt(earned), Color3.fromRGB(255,215,0))
					buildInventory()
				else
					showNotif("❌ " .. (err or "Can't sell"), Color3.fromRGB(255,80,80))
				end
			end)
		end
	end

	if not hasAny then
		local empty = newLabel(invScroll, "No whales yet! Hatch some eggs 🥚", UDim2.new(1,0,0,60), false, Color3.fromRGB(150,150,150))
		empty.ZIndex = 6
	end

	invScroll.CanvasSize = UDim2.new(0,0,0, invLayout.AbsoluteContentSize.Y + 16)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- SELL STORE PANEL
-- ═══════════════════════════════════════════════════════════════════════════

local sellPanel, sellTitle, sellScroll, sellLayout = makePanel(380, 520)
sellTitle.Text = "💰 Sell Store"

local function buildSellStore()
	for _, c in ipairs(sellScroll:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end

	local hasAny = false
	for whaleName, count in pairs(localWhales) do
		if not count or count < 1 then continue end
		local whale = WhaleConfig[whaleName]
		if not whale then continue end
		hasAny = true

		local card = newFrame(sellScroll, UDim2.new(1,-8,0,70), nil, Color3.fromRGB(35,18,18))
		makeCorner(card); card.ZIndex = 6

		local rCol = rarityColors[whale.Rarity] or Color3.new(1,1,1)
		local nameL = newLabel(card, "🐋 " .. whaleName, UDim2.new(0.6,0,0,30), true)
		nameL.Position = UDim2.new(0,10,0,4); nameL.TextXAlignment = Enum.TextXAlignment.Left; nameL.ZIndex = 7

		local valL = newLabel(card, "🪙 " .. fmt(whale.SellValue), UDim2.new(0.55,0,0,24), false, Color3.fromRGB(255,215,0))
		valL.Position = UDim2.new(0,10,0,36); valL.TextXAlignment = Enum.TextXAlignment.Left; valL.ZIndex = 7

		local ownL = newLabel(card, "×" .. count, UDim2.new(0.15,0,0,28), true)
		ownL.Position = UDim2.new(0.6,0,0,4); ownL.ZIndex = 7

		local sb = newBtn(card, "SELL", Color3.fromRGB(200,50,50), UDim2.new(0.18,0,0,44), UDim2.new(0.81,0,0,13))
		sb.ZIndex = 7
		sb.MouseButton1Click:Connect(function()
			local earned, err = Remotes.SellWhale:InvokeServer(whaleName)
			if earned and earned > 0 then
				showNotif("Sold for 🪙" .. fmt(earned), Color3.fromRGB(255,215,0))
				buildSellStore()
			else
				showNotif("❌ " .. (err or "Failed"), Color3.fromRGB(255,80,80))
			end
		end)
	end

	if not hasAny then
		local e = newLabel(sellScroll, "No whales in inventory to sell.", UDim2.new(1,0,0,60), false, Color3.fromRGB(150,150,150))
		e.ZIndex = 6
	end

	sellScroll.CanvasSize = UDim2.new(0,0,0, sellLayout.AbsoluteContentSize.Y + 16)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- ROBUX SHOP PANEL (Game Passes)
-- ═══════════════════════════════════════════════════════════════════════════

local shopPanel, shopTitle, shopScroll, shopLayout = makePanel(400, 540)
shopTitle.Text = "🛍️ Robux Shop"

local function buildRobuxShop()
	for _, c in ipairs(shopScroll:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end

	for key, pass in pairs(PassConfig) do
		local owned = localPasses[key]
		local card = newFrame(shopScroll, UDim2.new(1,-8,0,100), nil,
			owned and Color3.fromRGB(20,50,20) or Color3.fromRGB(25,20,40))
		makeCorner(card); card.ZIndex = 6

		local nameL = newLabel(card, pass.Name, UDim2.new(0.7,0,0,28), true,
			owned and Color3.fromRGB(80,255,80) or Color3.new(1,1,1))
		nameL.Position = UDim2.new(0,10,0,4); nameL.TextXAlignment = Enum.TextXAlignment.Left; nameL.ZIndex = 7

		local descL = newLabel(card, pass.Description, UDim2.new(0.75,0,0,40), false, Color3.fromRGB(200,200,200))
		descL.Position = UDim2.new(0,10,0,34); descL.TextXAlignment = Enum.TextXAlignment.Left
		descL.TextScaled = false; descL.TextSize = 12; descL.TextWrapped = true; descL.ZIndex = 7

		if owned then
			local ownedL = newLabel(card, "✅ Owned", UDim2.new(0.22,0,0,40), true, Color3.fromRGB(80,255,80))
			ownedL.Position = UDim2.new(0.77,0,0,30); ownedL.ZIndex = 7
		else
			local priceBtn = newBtn(card, "R$ " .. pass.Price, Color3.fromRGB(0,162,255),
				UDim2.new(0.21,0,0,40), UDim2.new(0.78,0,0,30))
			priceBtn.ZIndex = 7
			priceBtn.MouseButton1Click:Connect(function()
				if pass.Id and pass.Id ~= 0 then
					MarketplaceService:PromptGamePassPurchase(player, pass.Id)
				else
					showNotif("⚠️ Pass not set up yet — add ID to GamePasses.lua", Color3.fromRGB(255,180,50))
				end
			end)
		end
	end

	shopScroll.CanvasSize = UDim2.new(0,0,0, shopLayout.AbsoluteContentSize.Y + 16)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- SPIN WHEEL PANEL
-- ═══════════════════════════════════════════════════════════════════════════

local spinPanel = newFrame(root, UDim2.new(0,340,0,460),
	UDim2.new(0.5,-170,0.5,-230), Color3.fromRGB(12,10,28), 0.05)
makeCorner(spinPanel, 16); spinPanel.Visible = false; spinPanel.ZIndex = 5

local spinTitle = newLabel(spinPanel, "🎡 Spin Wheel", UDim2.new(1,0,0,44), true)
spinTitle.ZIndex = 6

local closeSpinBtn = newBtn(spinPanel, "✕", Color3.fromRGB(200,50,50), UDim2.new(0,36,0,36),
	UDim2.new(1,-42,0,4)); closeSpinBtn.ZIndex = 7
closeSpinBtn.MouseButton1Click:Connect(function() spinPanel.Visible = false end)

-- Spin timer label
local spinTimerLbl = newLabel(spinPanel, "Free spin ready!", UDim2.new(1,0,0,28), false, Color3.fromRGB(100,255,150))
spinTimerLbl.Position = UDim2.new(0,0,0,44); spinTimerLbl.ZIndex = 6

-- Reward list preview
local rewardList = newFrame(spinPanel, UDim2.new(1,-20,0,220), UDim2.new(0,10,0,78), Color3.fromRGB(20,15,40))
makeCorner(rewardList); rewardList.ZIndex = 6
local rlLayout = Instance.new("UIListLayout")
rlLayout.Padding = UDim.new(0,3); rlLayout.Parent = rewardList
makePadding(rewardList, 6)
for _, r in ipairs(SpinConfig) do
	local row = newLabel(rewardList, r.Label, UDim2.new(1,0,0,20), false, r.Color)
	row.TextXAlignment = Enum.TextXAlignment.Left; row.ZIndex = 7
end

-- Result label
local spinResultLbl = newLabel(spinPanel, "", UDim2.new(1,-20,0,40), true, Color3.fromRGB(255,215,0))
spinResultLbl.Position = UDim2.new(0,10,0,305); spinResultLbl.ZIndex = 6

-- Free spin button
local freeSpinBtn = newBtn(spinPanel, "🎡 FREE SPIN", Color3.fromRGB(180,30,180),
	UDim2.new(0.9,0,0,44), UDim2.new(0.05,0,0,356))
freeSpinBtn.ZIndex = 7

-- Buy spins button
local buySpinsBtn = newBtn(spinPanel, "R$49 — 3 Spins", Color3.fromRGB(0,162,255),
	UDim2.new(0.9,0,0,40), UDim2.new(0.05,0,0,408))
buySpinsBtn.ZIndex = 7

freeSpinBtn.MouseButton1Click:Connect(function()
	freeSpinBtn.Text = "Spinning..."
	local reward, err = Remotes.SpinWheel:InvokeServer()
	freeSpinBtn.Text = "🎡 FREE SPIN"
	if reward then
		spinResultLbl.Text = "🎉 " .. reward.Label .. "!"
	else
		spinResultLbl.Text = "⏳ " .. (err or "Not ready")
	end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- HATCH POPUP
-- ═══════════════════════════════════════════════════════════════════════════

local popupGui = Instance.new("ScreenGui")
popupGui.Name = "HatchPopup"; popupGui.ResetOnSpawn = false; popupGui.Parent = playerGui

local popup = newFrame(popupGui, UDim2.new(0,320,0,200), UDim2.new(0.5,-160,0.5,-100), Color3.fromRGB(10,10,25), 0.05)
makeCorner(popup, 18); popup.Visible = false; popup.ZIndex = 20

local popupTitle = newLabel(popup, "You hatched...", UDim2.new(1,0,0,44), false)
popupTitle.ZIndex = 21

local popupWhale = newLabel(popup, "", UDim2.new(1,0,0,80), true, Color3.fromRGB(100,220,255))
popupWhale.Position = UDim2.new(0,0,0,44); popupWhale.ZIndex = 21

local popupRarity = newLabel(popup, "", UDim2.new(1,0,0,36), true)
popupRarity.Position = UDim2.new(0,0,0,128); popupRarity.ZIndex = 21

local popupClose = newBtn(popup, "Continue ✓", Color3.fromRGB(50,180,80), UDim2.new(0.5,0,0,36), UDim2.new(0.25,0,0,160))
popupClose.ZIndex = 22
popupClose.MouseButton1Click:Connect(function() popup.Visible = false end)

function showHatchPopup(results)
	-- Show one at a time (last result or best)
	local best = results[1]
	for _, n in ipairs(results) do
		local w = WhaleConfig[n]
		local b = WhaleConfig[best]
		if w and b then
			local tiers = {Common=1,Uncommon=2,Rare=3,Epic=4,Legendary=5,Mythical=6}
			if (tiers[w.Rarity] or 0) > (tiers[b.Rarity] or 0) then best = n end
		end
	end
	local whale = WhaleConfig[best]
	popupWhale.Text = "🐋 " .. best
	popupRarity.Text = (whale and whale.Rarity or "")
	popupRarity.TextColor3 = whale and (rarityColors[whale.Rarity] or Color3.new(1,1,1)) or Color3.new(1,1,1)
	if #results > 1 then
		popupTitle.Text = "You hatched " .. #results .. " whales! Best:"
	else
		popupTitle.Text = "You hatched..."
	end
	popup.Visible = true
	task.delay(5, function() popup.Visible = false end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- NOTIFICATION TOAST
-- ═══════════════════════════════════════════════════════════════════════════

local notifGui = Instance.new("ScreenGui")
notifGui.Name = "Notifications"; notifGui.ResetOnSpawn = false; notifGui.Parent = playerGui

local notifFrame = newFrame(notifGui, UDim2.new(0,300,0,50), UDim2.new(0.5,-150,0,70), Color3.fromRGB(20,20,40), 0.1)
makeCorner(notifFrame); notifFrame.Visible = false; notifFrame.ZIndex = 30
local notifLbl = newLabel(notifFrame, "", nil, true)
notifLbl.ZIndex = 31

function showNotif(msg, color)
	notifLbl.Text = msg
	notifLbl.TextColor3 = color or Color3.new(1,1,1)
	notifFrame.Visible = true
	task.delay(3, function() notifFrame.Visible = false end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- PANEL TOGGLES
-- ═══════════════════════════════════════════════════════════════════════════

local function closeAll()
	eggPanel.Visible = false; invPanel.Visible = false
	sellPanel.Visible = false; shopPanel.Visible = false; spinPanel.Visible = false
end

tpShop.MouseButton1Click:Connect(function()
	closeAll(); buildEggShop(); eggPanel.Visible = true
end)
tpSell.MouseButton1Click:Connect(function()
	closeAll(); buildSellStore(); sellPanel.Visible = true
end)
invBtn.MouseButton1Click:Connect(function()
	closeAll(); buildInventory(); invPanel.Visible = true
end)
hatchQuickBtn.MouseButton1Click:Connect(function()
	closeAll(); buildEggShop(); eggPanel.Visible = true
end)
robuxBtn.MouseButton1Click:Connect(function()
	closeAll(); buildRobuxShop(); shopPanel.Visible = true
end)
spinBtn.MouseButton1Click:Connect(function()
	closeAll(); spinPanel.Visible = true
end)
tpPlot.MouseButton1Click:Connect(function()
	closeAll()
	-- Teleport logic: move character to the plot area (server handles plot positions)
	showNotif("Teleporting to your plot...", Color3.fromRGB(100,255,150))
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- REMOTE LISTENERS
-- ═══════════════════════════════════════════════════════════════════════════

Remotes.UpdateCurrency.OnClientEvent:Connect(function(coins, gems)
	localCoins = coins or 0; localGems = gems or 0
	coinLbl.Text = "🪙 " .. fmt(localCoins)
	gemLbl.Text  = "💎 " .. fmt(localGems)
end)

Remotes.UpdateWhales.OnClientEvent:Connect(function(owned, placed)
	localWhales = owned or {}; localPlaced = placed or {}
end)

Remotes.UpdatePasses.OnClientEvent:Connect(function(passes)
	localPasses = passes or {}
	-- Count rebirths shown via HUD — passes updated, no rebirth count here
end)

Remotes.ShowNotification.OnClientEvent:Connect(function(msg, color)
	showNotif(msg, color)
end)
