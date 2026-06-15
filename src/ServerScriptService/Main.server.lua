local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local WhaleConfig = require(ReplicatedStorage.Config.Whales)
local EggConfig = require(ReplicatedStorage.Config.Eggs)
local Remotes = require(ReplicatedStorage.Remotes)

local DataStore = DataStoreService:GetDataStore(GameConfig.DataStoreKey)

-- Active player data in memory
local playerData = {}

-- Default data for new players
local function newData()
	return {
		Coins = GameConfig.StartingCoins,
		OwnedWhales = {},   -- { whaleName = count }
		EquippedWhales = {}, -- ordered list of whale names (max MaxEquippedWhales)
	}
end

-- Load from DataStore; fall back to new data on failure
local function loadData(player)
	local data
	local ok, err = pcall(function()
		data = DataStore:GetAsync("Player_" .. player.UserId)
	end)
	if not ok then
		warn("Failed to load data for", player.Name, ":", err)
	end
	return data or newData()
end

-- Save to DataStore
local function saveData(player)
	local data = playerData[player]
	if not data then return end
	local ok, err = pcall(function()
		DataStore:SetAsync("Player_" .. player.UserId, data)
	end)
	if not ok then
		warn("Failed to save data for", player.Name, ":", err)
	end
end

-- Pick a random whale from an egg using weighted RNG (server-side, exploit-proof)
local function rollWhale(eggName)
	local egg = EggConfig[eggName]
	if not egg then return nil end

	local totalWeight = 0
	for _, whaleName in ipairs(egg.PossibleWhales) do
		local whale = WhaleConfig[whaleName]
		if whale then
			totalWeight = totalWeight + whale.Weight
		end
	end

	local roll = math.random(1, totalWeight)
	local cumulative = 0
	for _, whaleName in ipairs(egg.PossibleWhales) do
		local whale = WhaleConfig[whaleName]
		if whale then
			cumulative = cumulative + whale.Weight
			if roll <= cumulative then
				return whaleName
			end
		end
	end
end

-- Calculate total coins/sec from a player's equipped whales
local function calcIncome(data)
	local total = 0
	for _, whaleName in ipairs(data.EquippedWhales) do
		local whale = WhaleConfig[whaleName]
		if whale then
			total = total + whale.Income
		end
	end
	return total
end

-- Player join
Players.PlayerAdded:Connect(function(player)
	local data = loadData(player)
	playerData[player] = data

	-- Send initial state to client once their scripts load
	player.CharacterAdded:Connect(function()
		Remotes.UpdateCurrency:FireClient(player, data.Coins)
		Remotes.UpdateWhales:FireClient(player, data.OwnedWhales, data.EquippedWhales)
	end)
end)

-- Player leave
Players.PlayerRemoving:Connect(function(player)
	saveData(player)
	playerData[player] = nil
end)

-- Hatch egg remote (RemoteFunction — returns result directly to client)
Remotes.HatchEgg.OnServerInvoke = function(player, eggName)
	local data = playerData[player]
	if not data then return nil, "No data" end

	local egg = EggConfig[eggName]
	if not egg then return nil, "Unknown egg" end

	if data.Coins < egg.Cost then
		return nil, "Not enough coins"
	end

	local whaleName = rollWhale(eggName)
	if not whaleName then return nil, "Roll failed" end

	-- Deduct cost and award whale
	data.Coins = data.Coins - egg.Cost
	data.OwnedWhales[whaleName] = (data.OwnedWhales[whaleName] or 0) + 1

	-- Auto-equip if slots available
	if #data.EquippedWhales < GameConfig.MaxEquippedWhales then
		-- Only equip if not already in the list
		local alreadyEquipped = false
		for _, name in ipairs(data.EquippedWhales) do
			if name == whaleName then alreadyEquipped = true break end
		end
		if not alreadyEquipped then
			table.insert(data.EquippedWhales, whaleName)
		end
	end

	-- Push updates to client
	Remotes.UpdateCurrency:FireClient(player, data.Coins)
	Remotes.UpdateWhales:FireClient(player, data.OwnedWhales, data.EquippedWhales)

	return whaleName
end

-- Equip/unequip remote
Remotes.SetEquipped.OnServerEvent:Connect(function(player, whaleName, equip)
	local data = playerData[player]
	if not data then return end
	if not WhaleConfig[whaleName] then return end
	if not data.OwnedWhales[whaleName] then return end

	if equip then
		if #data.EquippedWhales >= GameConfig.MaxEquippedWhales then return end
		for _, name in ipairs(data.EquippedWhales) do
			if name == whaleName then return end -- already equipped
		end
		table.insert(data.EquippedWhales, whaleName)
	else
		for i, name in ipairs(data.EquippedWhales) do
			if name == whaleName then
				table.remove(data.EquippedWhales, i)
				break
			end
		end
	end

	Remotes.UpdateWhales:FireClient(player, data.OwnedWhales, data.EquippedWhales)
end)

-- Income loop: pay out every IncomeInterval seconds
local incomeTimer = 0
RunService.Heartbeat:Connect(function(dt)
	incomeTimer = incomeTimer + dt
	if incomeTimer < GameConfig.IncomeInterval then return end
	incomeTimer = 0

	for player, data in pairs(playerData) do
		local income = calcIncome(data)
		if income > 0 then
			data.Coins = data.Coins + income
			Remotes.UpdateCurrency:FireClient(player, data.Coins)
		end
	end
end)

-- Auto-save all players every 60 seconds
task.spawn(function()
	while true do
		task.wait(60)
		for player in pairs(playerData) do
			saveData(player)
		end
	end
end)
