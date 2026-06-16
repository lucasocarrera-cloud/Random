local RS = game:GetService("ReplicatedStorage")

local function event(name)
	local e = RS:FindFirstChild(name) or Instance.new("RemoteEvent")
	e.Name = name; e.Parent = RS; return e
end
local function func(name)
	local f = RS:FindFirstChild(name) or Instance.new("RemoteFunction")
	f.Name = name; f.Parent = RS; return f
end

return {
	-- Server → Client pushes
	UpdateCurrency    = event("UpdateCurrency"),    -- (coins, gems)
	UpdateWhales      = event("UpdateWhales"),      -- (ownedWhales, placedWhales)
	UpdatePasses      = event("UpdatePasses"),      -- (ownedPasses table)
	ShowNotification  = event("ShowNotification"),  -- (message, color)
	WheelResult       = event("WheelResult"),       -- (rewardLabel)
	OpenShop          = event("OpenShop"),          -- (shopType) server→client when NPC prompt triggered

	-- Client → Server requests (RemoteFunction returns result)
	HatchEgg          = func("HatchEgg"),           -- (eggName) → whaleName, errMsg
	SellWhale         = func("SellWhale"),          -- (whaleName) → coinsEarned, errMsg
	SpinWheel         = func("SpinWheel"),          -- () → reward table, errMsg
	StealWhale        = func("StealWhale"),         -- (targetPlayer) → whaleName, errMsg

	-- Client → Server fire-and-forget
	PlaceWhale        = event("PlaceWhale"),        -- (whaleName, slotIndex)
	RemoveFromPlot    = event("RemoveFromPlot"),    -- (slotIndex)
	DoRebirth         = event("DoRebirth"),
}
