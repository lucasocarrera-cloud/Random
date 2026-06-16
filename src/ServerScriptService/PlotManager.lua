-- Procedurally builds each player's multi-story plot: floors, 4×2 stable pads,
-- climbable ladders between stories, and whale placeholder blocks.
-- Whale models are coloured blocks for now — swap by name later in Studio.

local RS = game:GetService("ReplicatedStorage")
local Plot   = require(RS.Config.Plot)
local Whales = require(RS.Config.Whales)

local PlotManager = {}

local MAX_SLOTS = Plot.SlotsPerFloor * Plot.MaxFloors

local rarityColors = {
	Common    = Color3.fromRGB(180,180,180),
	Uncommon  = Color3.fromRGB(80,200,80),
	Rare      = Color3.fromRGB(80,140,255),
	Epic      = Color3.fromRGB(180,80,255),
	Legendary = Color3.fromRGB(255,200,0),
	Mythical  = Color3.fromRGB(255,60,60),
}

local plots = {}     -- [player] = { model, base, index }
local usedIndex = {} -- [index] = true
local getData, pushFn

function PlotManager.Init(opts)
	getData = opts.getData
	pushFn  = opts.push
end

-- ── RULES ────────────────────────────────────────────────────────────────────

local function maxSlotsFor(data)
	local bonus = 0
	if data.OwnedPasses.ExtraPlotSlots then bonus = bonus + 6 end
	if data.OwnedPasses.VIP then bonus = bonus + 3 end
	return math.clamp(Plot.BaseStables + data.Rebirths + bonus, Plot.BaseStables, MAX_SLOTS)
end
PlotManager.MaxSlotsFor = maxSlotsFor

local function placedCount(data, whaleName)
	local n = 0
	for _, name in pairs(data.PlacedWhales) do
		if name == whaleName then n = n + 1 end
	end
	return n
end

-- ── PART HELPERS ─────────────────────────────────────────────────────────────

local function part(name, size, pos, color, parent, material)
	local p = Instance.new("Part")
	p.Name = name; p.Size = size; p.Position = pos
	p.Anchored = true; p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

-- Local 4×2 offset for a slot index within its floor (1..8)
local function padOffset(slotInFloor)
	local i = slotInFloor - 1
	local col = i % Plot.GridCols       -- 0..3
	local row = math.floor(i / Plot.GridCols) -- 0..1
	local x = (col - (Plot.GridCols - 1) / 2) * Plot.PadSpacing
	local z = (row - (Plot.GridRows - 1) / 2) * Plot.PadSpacing
	return Vector3.new(x, 0, z)
end

-- ── BUILD ────────────────────────────────────────────────────────────────────

function PlotManager.Build(player, data)
	local entry = plots[player]
	if not entry then return end
	if entry.model then entry.model:Destroy() end

	local base = entry.base
	local model = Instance.new("Model")
	model.Name = "Plot_" .. player.UserId
	model.Parent = workspace
	entry.model = model

	local maxSlots = maxSlotsFor(data)
	local floorsBuilt = math.ceil(maxSlots / Plot.SlotsPerFloor)

	-- Nameplate
	local sign = part("Sign", Vector3.new(12,3,1), base + Vector3.new(0, 4, -Plot.FloorDepth/2 - 2), Color3.fromRGB(90,60,40), model)
	local bb = Instance.new("BillboardGui")
	bb.Size = UDim2.new(0,260,0,60); bb.StudsOffset = Vector3.new(0,3,0)
	bb.AlwaysOnTop = true; bb.Adornee = sign; bb.Parent = sign
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1
	lbl.Text = player.Name .. "'s Plot"; lbl.TextColor3 = Color3.new(1,1,1)
	lbl.TextStrokeTransparency = 0; lbl.TextScaled = true
	lbl.Font = Enum.Font.FredokaOne; lbl.Parent = bb

	for floor = 1, floorsBuilt do
		local floorY = (floor - 1) * Plot.FloorHeight + 1
		local floorCenter = base + Vector3.new(0, floorY, 0)

		-- Platform
		part("Floor" .. floor, Vector3.new(Plot.FloorSize, 1, Plot.FloorDepth),
			floorCenter, Color3.fromRGB(120, 200, 120), model, Enum.Material.Grass)

		-- Pads on this floor
		for i = 1, Plot.SlotsPerFloor do
			local slot = (floor - 1) * Plot.SlotsPerFloor + i
			local unlocked = slot <= maxSlots
			local padPos = floorCenter + padOffset(i) + Vector3.new(0, 0.6, 0)
			local padColor = unlocked and Color3.fromRGB(70,70,90) or Color3.fromRGB(40,20,20)
			local pad = part("Pad" .. slot, Vector3.new(Plot.PadSize, 0.4, Plot.PadSize), padPos, padColor, model)

			local whaleName = data.PlacedWhales[tostring(slot)]
			if whaleName and Whales[whaleName] then
				-- Whale placeholder block
				local whale = Whales[whaleName]
				local block = part("Whale_" .. slot, Vector3.new(4,4,4),
					padPos + Vector3.new(0, 2.4, 0), rarityColors[whale.Rarity] or Color3.new(1,1,1), model)
				local wbb = Instance.new("BillboardGui")
				wbb.Size = UDim2.new(0,160,0,40); wbb.StudsOffset = Vector3.new(0,3,0)
				wbb.AlwaysOnTop = true; wbb.Adornee = block; wbb.Parent = block
				local wlbl = Instance.new("TextLabel")
				wlbl.Size = UDim2.new(1,0,1,0); wlbl.BackgroundTransparency = 1
				wlbl.Text = whaleName; wlbl.TextColor3 = Color3.new(1,1,1)
				wlbl.TextStrokeTransparency = 0; wlbl.TextScaled = true
				wlbl.Font = Enum.Font.GothamBold; wlbl.Parent = wbb

				-- Remove prompt
				local prompt = Instance.new("ProximityPrompt")
				prompt.ActionText = "Remove"; prompt.ObjectText = whaleName
				prompt.KeyboardKeyCode = Enum.KeyCode.E; prompt.HoldDuration = 0.3
				prompt.MaxActivationDistance = 10; prompt.RequiresLineOfSight = false
				prompt.Parent = block
				prompt.Triggered:Connect(function(plr)
					if plr ~= player then return end
					PlotManager.Remove(player, getData(player), slot)
				end)
			elseif not unlocked then
				-- Locked marker
				local lockBb = Instance.new("BillboardGui")
				lockBb.Size = UDim2.new(0,80,0,30); lockBb.StudsOffset = Vector3.new(0,2,0)
				lockBb.AlwaysOnTop = true; lockBb.Adornee = pad; lockBb.Parent = pad
				local llbl = Instance.new("TextLabel")
				llbl.Size = UDim2.new(1,0,1,0); llbl.BackgroundTransparency = 1
				llbl.Text = "🔒"; llbl.TextScaled = true; llbl.Parent = lockBb
			end
		end

		-- Ladder up to next floor (climbable truss)
		if floor < floorsBuilt then
			local ok, truss = pcall(function() return Instance.new("TrussPart") end)
			if ok and truss then
				truss.Name = "Ladder" .. floor
				truss.Anchored = true
				truss.Size = Vector3.new(2, Plot.FloorHeight, 2)
				truss.Position = floorCenter + Vector3.new(Plot.FloorSize/2 - 2, Plot.FloorHeight/2, 0)
				truss.Color = Color3.fromRGB(90,90,90)
				truss.Parent = model
			end
		end
	end
end

-- ── PLACE / REMOVE ───────────────────────────────────────────────────────────

-- Places a whale into the first free unlocked slot. Returns slot or nil, err.
function PlotManager.PlaceNext(player, data, whaleName)
	if not Whales[whaleName] then return nil, "Unknown whale" end
	local owned = data.OwnedWhales[whaleName] or 0
	if owned < 1 then return nil, "You don't own this whale" end
	if placedCount(data, whaleName) >= owned then
		return nil, "All your " .. whaleName .. " are already placed"
	end

	local maxSlots = maxSlotsFor(data)
	for slot = 1, maxSlots do
		if data.PlacedWhales[tostring(slot)] == nil then
			data.PlacedWhales[tostring(slot)] = whaleName
			PlotManager.Build(player, data)
			if pushFn then pushFn(player) end
			return slot
		end
	end
	return nil, "No free stables — rebirth to unlock more!"
end

function PlotManager.Remove(player, data, slot)
	data.PlacedWhales[tostring(slot)] = nil
	PlotManager.Build(player, data)
	if pushFn then pushFn(player) end
end

-- ── ASSIGNMENT ───────────────────────────────────────────────────────────────

function PlotManager.Assign(player)
	local index = 0
	while usedIndex[index] do index = index + 1 end
	usedIndex[index] = true
	local base = Plot.Origin + Vector3.new(index * Plot.PlotSpacing, 0, 0)
	plots[player] = { model = nil, base = base, index = index }
	return base
end

function PlotManager.GetSpawn(player)
	local entry = plots[player]
	if not entry then return nil end
	return entry.base + Vector3.new(0, 6, Plot.FloorDepth/2 + 6)
end

function PlotManager.Cleanup(player)
	local entry = plots[player]
	if entry then
		if entry.model then entry.model:Destroy() end
		usedIndex[entry.index] = nil
		plots[player] = nil
	end
end

return PlotManager
