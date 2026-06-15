-- Creates RemoteEvents/RemoteFunctions on the server; clients access them by name
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = {}

local function getOrCreate(className, name)
	local existing = ReplicatedStorage:FindFirstChild(name)
	if existing then return existing end
	local obj = Instance.new(className)
	obj.Name = name
	obj.Parent = ReplicatedStorage
	return obj
end

-- Server → Client: push updated coin balance
Remotes.UpdateCurrency = getOrCreate("RemoteEvent", "UpdateCurrency")

-- Server → Client: push updated whale list
Remotes.UpdateWhales = getOrCreate("RemoteEvent", "UpdateWhales")

-- Client → Server → Client: request a hatch; returns whaleName or nil
Remotes.HatchEgg = getOrCreate("RemoteFunction", "HatchEgg")

-- Client → Server: equip/unequip a whale by name
Remotes.SetEquipped = getOrCreate("RemoteEvent", "SetEquipped")

return Remotes
