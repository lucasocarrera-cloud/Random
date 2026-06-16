local Players       = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService    = game:GetService("RunService")
local RS            = game:GetService("ReplicatedStorage")

local GameConfig    = require(RS.Config.GameConfig)
local WhaleConfig   = require(RS.Config.Whales)
local EggConfig     = require(RS.Config.Eggs)
local PassConfig    = require(RS.Config.GamePasses)
local SpinConfig    = require(RS.Config.SpinWheel)
local Remotes       = require(RS.Remotes)

local DataStore     = DataStoreService:GetDataStore(GameConfig.DataStoreKey)

-- ── DATA ─────────────────────────────────────────────────────────────────────

local playerData = {}

local function newData()
	return {
		Coins          = GameConfig.StartingCoins,
		Gems           = GameConfig.StartingGems,
		OwnedWhales    = {},   -- { [whaleName] = count }
		PlacedWhales   = {},   -- { [slotIndex] = whaleName }
		MutationStars  = {},   -- { [whaleName] = stars }
		Rebirths       = 0,
		RebirthMult    = 1,
		LastSpinTime   = 0,    -- os.time() of last free spin
		LastLeaveTime  = 0,    -- for offline earnings
		OwnedPasses    = {},   -- { [passKey] = true }
		TempMultiplier = 1,    -- from wheel spin, resets on expiry
		TempMultExpiry = 0,
		ThiefLastUsed  = 0,    -- os.time() of last Whale Thief use
		Initialized    = false,-- has the free starter whale been granted?
	}
end

-- Total number of whales a player owns (across all types)
local function totalOwned(data)
	local n = 0
	for _, count in pairs(data.OwnedWhales) do n = n + (count or 0) end
	return n
end

-- Is this whale currently placed on the plot?
local function isPlaced(data, whaleName)
	for _, name in pairs(data.PlacedWhales) do
		if name == whaleName then return true end
	end
	return false
end

local function loadData(player)
	local data
	local ok, err = pcall(function()
		data = DataStore:GetAsync("Player_" .. player.UserId)
	end)
	if not ok then warn("Load failed for", player.Name, err) end
	local d = data or newData()
	-- ensure all keys exist for old saves
	for k, v in pairs(newData()) do
		if d[k] == nil then d[k] = v end
	end
	return d
end

local function saveData(player)
	local data = playerData[player]
	if not data then return end
	data.LastLeaveTime = os.time()
	local ok, err = pcall(function()
		DataStore:SetAsync("Player_" .. player.UserId, data)
	end)
	if not ok then warn("Save failed for", player.Name, err) end
end

-- ── HELPERS ──────────────────────────────────────────────────────────────────

local function push(player)
	local d = playerData[player]
	if not d then return end
	Remotes.UpdateCurrency:FireClient(player, d.Coins, d.Gems)
	Remotes.UpdateWhales:FireClient(player, d.OwnedWhales, d.PlacedWhales)
end

local function notify(player, msg, color)
	Remotes.ShowNotification:FireClient(player, msg, color or Color3.fromRGB(100,255,150))
end

local function hasPerm(player, passKey)
	local d = playerData[player]
	return d and d.OwnedPasses[passKey] == true
end

local function calcIncome(data)
	local total = 0
	for _, whaleName in pairs(data.PlacedWhales) do
		local whale = WhaleConfig[whaleName]
		if whale then
			local stars = data.MutationStars[whaleName] or 0
			local starMult = 1 + 0.25 * stars
			total = total + whale.Income * starMult
		end
	end
	-- Apply rebirth multiplier
	total = total * data.RebirthMult
	-- Apply temp multiplier (wheel spin)
	if os.time() < data.TempMultExpiry then
		total = total * data.TempMultiplier
	end
	-- Apply pass multipliers
	if data.OwnedPasses.DoubleCoins  then total = total * 2 end
	if data.OwnedPasses.TripleCoins  then total = total * 3 end
	if data.OwnedPasses.FiveXCoins   then total = total * 5 end
	if data.OwnedPasses.VIP          then total = total * 10 end
	return total
end

-- ── WEIGHTED RNG ─────────────────────────────────────────────────────────────

local function rollWhale(eggName, luck)
	local egg = EggConfig[eggName]
	if not egg then return nil end
	luck = luck or 0

	local totalWeight = 0
	for _, name in ipairs(egg.PossibleWhales) do
		local w = WhaleConfig[name]
		if w then
			-- Luck reduces common weight slightly, making rares more likely
			local adj = w.Rarity == "Common" and math.max(1, w.Weight - luck * 0.1) or w.Weight + luck * 0.05
			totalWeight = totalWeight + adj
		end
	end

	local roll = math.random() * totalWeight
	local cum = 0
	for _, name in ipairs(egg.PossibleWhales) do
		local w = WhaleConfig[name]
		if w then
			local adj = w.Rarity == "Common" and math.max(1, w.Weight - luck * 0.1) or w.Weight + luck * 0.05
			cum = cum + adj
			if roll <= cum then return name end
		end
	end
	return egg.PossibleWhales[1]
end

-- ── PASS CHECKING ────────────────────────────────────────────────────────────

local function checkPasses(player, data)
	for key, pass in pairs(PassConfig) do
		if pass.Id and pass.Id ~= 0 then
			local ok, owns = pcall(function()
				return MarketplaceService:UserOwnsGamePassAsync(player.UserId, pass.Id)
			end)
			if ok and owns then
				data.OwnedPasses[key] = true
			end
		end
	end
	Remotes.UpdatePasses:FireClient(player, data.OwnedPasses)
end

-- ── PLAYER JOIN / LEAVE ───────────────────────────────────────────────────────

Players.PlayerAdded:Connect(function(player)
	local data = loadData(player)
	playerData[player] = data

	-- Grant a free starter whale on first join (auto-placed so they always earn)
	if not data.Initialized then
		data.Initialized = true
		data.OwnedWhales["Classic Whale"] = (data.OwnedWhales["Classic Whale"] or 0) + 1
		data.PlacedWhales["1"] = "Classic Whale"
	end

	-- Offline earnings
	if data.LastLeaveTime > 0 then
		local elapsed = os.time() - data.LastLeaveTime
		local cap = GameConfig.MaxOfflineHours * 3600
		if data.OwnedPasses.DoubleOffline then cap = cap * 2 end
		elapsed = math.min(elapsed, cap)
		local earned = math.floor(calcIncome(data) * elapsed)
		if earned > 0 then
			data.Coins = data.Coins + earned
			task.delay(3, function()
				notify(player, "Welcome back! You earned " .. tostring(earned) .. " coins while away! 🐋", Color3.fromRGB(255,215,0))
			end)
		end
	end

	checkPasses(player, data)
	push(player)
end)

Players.PlayerRemoving:Connect(function(player)
	saveData(player)
	playerData[player] = nil
end)

-- ── HATCH EGG ────────────────────────────────────────────────────────────────

Remotes.HatchEgg.OnServerInvoke = function(player, eggName, quantity)
	local data = playerData[player]
	if not data then return nil, "No data" end
	local egg = EggConfig[eggName]
	if not egg then return nil, "Unknown egg" end
	if egg.UnlockRebirth and data.Rebirths < egg.UnlockRebirth then
		return nil, "Requires " .. egg.UnlockRebirth .. " rebirths"
	end

	quantity = (data.OwnedPasses.EightXHatch and 8 or 1)
	local gemCost = (egg.GemCost or 0) * quantity
	local coinCost = (egg.Cost or 0) * quantity

	if gemCost > 0 and data.Gems < gemCost then return nil, "Not enough gems" end
	if coinCost > 0 and data.Coins < coinCost then return nil, "Not enough coins" end

	if gemCost > 0 then data.Gems = data.Gems - gemCost end
	if coinCost > 0 then data.Coins = data.Coins - coinCost end

	local luck = 0
	if data.OwnedPasses.LuckyCharm then luck = luck + 50 end
	if data.OwnedPasses.MegaLucky  then luck = luck + 150 end

	local results = {}
	for i = 1, quantity do
		local whaleName = rollWhale(eggName, luck)
		if whaleName then
			data.OwnedWhales[whaleName] = (data.OwnedWhales[whaleName] or 0) + 1
			table.insert(results, whaleName)
		end
	end

	push(player)
	return results
end

-- ── SELL WHALE ───────────────────────────────────────────────────────────────

Remotes.SellWhale.OnServerInvoke = function(player, whaleName)
	local data = playerData[player]
	if not data then return 0, "No data" end
	local whale = WhaleConfig[whaleName]
	if not whale then return 0, "Unknown whale" end
	if not data.OwnedWhales[whaleName] or data.OwnedWhales[whaleName] < 1 then
		return 0, "You don't own this whale"
	end

	-- Anti soft-lock: never let a player sell their very last whale
	if totalOwned(data) <= 1 then
		return 0, "Can't sell your last whale!"
	end

	-- Must remove from plot before selling (keeps your income source safe)
	if isPlaced(data, whaleName) and (data.OwnedWhales[whaleName] or 0) <= 1 then
		return 0, "Remove this whale from your plot first"
	end

	-- Remove from owned (not from plot)
	data.OwnedWhales[whaleName] = data.OwnedWhales[whaleName] - 1
	if data.OwnedWhales[whaleName] <= 0 then
		data.OwnedWhales[whaleName] = nil
	end

	local earned = whale.SellValue
	data.Coins = data.Coins + earned
	push(player)
	return earned
end

-- ── SPIN WHEEL ───────────────────────────────────────────────────────────────

Remotes.SpinWheel.OnServerInvoke = function(player)
	local data = playerData[player]
	if not data then return nil, "No data" end

	local now = os.time()
	local interval = GameConfig.FreeSpinIntervalMinutes * 60
	local spinsAvailable = data.OwnedPasses.ExtraDailySpin and 3 or 1

	if now - data.LastSpinTime < interval then
		local remaining = interval - (now - data.LastSpinTime)
		local mins = math.ceil(remaining / 60)
		return nil, "Free spin available in " .. mins .. " min"
	end

	data.LastSpinTime = now

	-- Weighted roll
	local total = 0
	for _, r in ipairs(SpinConfig) do total = total + r.Weight end
	local roll = math.random() * total
	local cum = 0
	local reward
	for _, r in ipairs(SpinConfig) do
		cum = cum + r.Weight
		if roll <= cum then reward = r break end
	end

	if not reward then reward = SpinConfig[1] end

	if reward.Type == "Coins" then
		data.Coins = data.Coins + reward.Value
	elseif reward.Type == "Gems" then
		data.Gems = data.Gems + reward.Value
		if data.OwnedPasses.DoubleGems then data.Gems = data.Gems + reward.Value end
	elseif reward.Type == "Egg" then
		-- Give player the egg as a hatch
		local whaleName = rollWhale(reward.Value, 0)
		if whaleName then
			data.OwnedWhales[whaleName] = (data.OwnedWhales[whaleName] or 0) + 1
		end
	elseif reward.Type == "Multiplier" then
		data.TempMultiplier = reward.Value
		data.TempMultExpiry = now + (reward.Duration or 3600)
	end

	push(player)
	return reward
end

-- ── WHALE THIEF ───────────────────────────────────────────────────────────────

Remotes.StealWhale.OnServerInvoke = function(player, targetPlayer)
	local data = playerData[player]
	if not data then return nil, "No data" end
	if not data.OwnedPasses.WhaleThief then return nil, "You need the Whale Thief pass" end

	local cooldown = 86400 -- 24 hours
	if os.time() - data.ThiefLastUsed < cooldown then
		local h = math.ceil((cooldown - (os.time() - data.ThiefLastUsed)) / 3600)
		return nil, "Whale Thief resets in " .. h .. "h"
	end

	local targetData = playerData[targetPlayer]
	if not targetData then return nil, "Target not online" end

	-- Find a random whale from target's non-plot inventory
	local stealable = {}
	for name, count in pairs(targetData.OwnedWhales) do
		if count and count > 0 then
			table.insert(stealable, name)
		end
	end
	if #stealable == 0 then return nil, "Target has no whales to steal" end

	local stolen = stealable[math.random(#stealable)]
	targetData.OwnedWhales[stolen] = targetData.OwnedWhales[stolen] - 1
	if targetData.OwnedWhales[stolen] <= 0 then targetData.OwnedWhales[stolen] = nil end

	data.OwnedWhales[stolen] = (data.OwnedWhales[stolen] or 0) + 1
	data.ThiefLastUsed = os.time()

	notify(targetPlayer, "😱 " .. player.Name .. " stole your " .. stolen .. "!", Color3.fromRGB(255,80,80))
	push(player)
	push(targetPlayer)
	return stolen
end

-- ── REBIRTH ──────────────────────────────────────────────────────────────────

Remotes.DoRebirth.OnServerEvent:Connect(function(player)
	local data = playerData[player]
	if not data then return end

	local minStars = 5 + data.Rebirths * 3
	local totalStars = 0
	for _, s in pairs(data.MutationStars) do totalStars = totalStars + s end
	if totalStars < minStars then
		notify(player, "Need " .. minStars .. " total mutation stars to rebirth.", Color3.fromRGB(255,100,100))
		return
	end

	-- Keep coins partially if pass owned
	local keepCoins = 0
	if data.OwnedPasses.RebirthKeeper then
		keepCoins = math.floor(data.Coins * 0.5)
	end

	-- Keep ALL whales (your design decision)
	data.Coins = keepCoins
	data.Gems = data.Gems  -- keep gems
	-- OwnedWhales and PlacedWhales kept as-is
	data.Rebirths = data.Rebirths + 1
	data.RebirthMult = data.RebirthMult * GameConfig.RebirthMultiplierPerRebirth

	push(player)
	notify(player, "🔄 Reborn! You now earn " .. string.format("%.1f", data.RebirthMult) .. "× coins!", Color3.fromRGB(150,100,255))
end)

-- ── PLOT ─────────────────────────────────────────────────────────────────────

Remotes.PlaceWhale.OnServerEvent:Connect(function(player, whaleName, slotIndex)
	local data = playerData[player]
	if not data then return end
	if not WhaleConfig[whaleName] then return end
	if not data.OwnedWhales[whaleName] or data.OwnedWhales[whaleName] < 1 then return end

	local maxSlots = GameConfig.MaxPlotSlots
	if data.OwnedPasses.ExtraPlotSlots then maxSlots = maxSlots + 6 end
	if data.OwnedPasses.VIP then maxSlots = maxSlots + 3 end

	-- Count placed slots
	local placed = 0
	for _ in pairs(data.PlacedWhales) do placed = placed + 1 end
	if placed >= maxSlots and not data.PlacedWhales[tostring(slotIndex)] then return end

	data.PlacedWhales[tostring(slotIndex)] = whaleName
	push(player)
end)

Remotes.RemoveFromPlot.OnServerEvent:Connect(function(player, slotIndex)
	local data = playerData[player]
	if not data then return end
	data.PlacedWhales[tostring(slotIndex)] = nil
	push(player)
end)

-- ── INCOME LOOP ───────────────────────────────────────────────────────────────

local incomeTimer = 0
RunService.Heartbeat:Connect(function(dt)
	incomeTimer = incomeTimer + dt
	if incomeTimer < GameConfig.IncomeInterval then return end
	incomeTimer = 0
	for player, data in pairs(playerData) do
		local income = calcIncome(data)
		if income > 0 then
			data.Coins = data.Coins + income
			Remotes.UpdateCurrency:FireClient(player, data.Coins, data.Gems)
		end
	end
end)

-- ── AUTO-SAVE ─────────────────────────────────────────────────────────────────

task.spawn(function()
	while true do
		task.wait(60)
		for player in pairs(playerData) do saveData(player) end
	end
end)

-- ── GAME PASS PURCHASE HANDLER ────────────────────────────────────────────────

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, passId, purchased)
	if not purchased then return end
	local data = playerData[player]
	if not data then return end
	for key, pass in pairs(PassConfig) do
		if pass.Id == passId then
			data.OwnedPasses[key] = true
			Remotes.UpdatePasses:FireClient(player, data.OwnedPasses)
			notify(player, "✅ " .. pass.Name .. " activated!", Color3.fromRGB(100,255,150))
			break
		end
	end
end)
