-- Cost: coins unless GemCost is set
-- UnlockRebirth: how many rebirths needed to see this egg in shop
return {
	["Starter Egg"] = {
		Cost = 100,
		UnlockRebirth = 0,
		PossibleWhales = { "Classic Whale", "Blue Whale", "Coral Whale", "Sandy Whale", "Tide Whale", "Ocean Whale" },
	},
	["Ocean Egg"] = {
		Cost = 1000,
		UnlockRebirth = 0,
		PossibleWhales = { "Ocean Whale", "Reef Whale", "Kelp Whale", "Pearl Whale", "Mist Whale", "Crystal Whale" },
	},
	["Runic Egg"] = {
		Cost = 10000,
		UnlockRebirth = 1,
		PossibleWhales = { "Crystal Whale", "Emerald Whale", "Ruby Whale", "Sapphire Whale", "Golden Whale", "Cobalt Whale" },
	},
	["Obsidian Egg"] = {
		Cost = 100000,
		UnlockRebirth = 2,
		PossibleWhales = { "Cobalt Whale", "Storm Whale", "Shadow Whale", "Void Whale", "Thunder Whale", "Astral Whale" },
	},
	["Mutation Egg"] = {
		Cost = 0,
		GemCost = 50,
		UnlockRebirth = 3,
		PossibleWhales = { "Astral Whale", "Orbital Whale", "Inferno Whale", "Surge Whale", "Neon Whale" },
	},
	["Astral Egg"] = {
		Cost = 0,
		GemCost = 200,
		UnlockRebirth = 5,
		PossibleWhales = { "Surge Whale", "Neon Whale", "Cosmic Whale", "Phantom Whale", "Frosty Whale" },
	},
	["Galaxy Egg"] = {
		Cost = 0,
		GemCost = 750,
		UnlockRebirth = 8,
		PossibleWhales = { "Frosty Whale", "Heavenly Whale", "Galaxy Whale" },
	},
}
