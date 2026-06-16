-- Income = coins/sec when placed on plot
-- Weight = hatch probability weight (higher = more common)
-- SellValue = coins earned when sold at Sell Store
return {
	-- ── COMMON ──────────────────────────────────────────────────────────────
	["Classic Whale"]  = { Rarity = "Common",   Income = 1,      Weight = 70, SellValue = 10 },
	["Blue Whale"]     = { Rarity = "Common",   Income = 2,      Weight = 65, SellValue = 20 },
	["Coral Whale"]    = { Rarity = "Common",   Income = 3,      Weight = 60, SellValue = 30 },
	["Sandy Whale"]    = { Rarity = "Common",   Income = 4,      Weight = 55, SellValue = 40 },
	["Tide Whale"]     = { Rarity = "Common",   Income = 5,      Weight = 50, SellValue = 50 },

	-- ── UNCOMMON ────────────────────────────────────────────────────────────
	["Ocean Whale"]    = { Rarity = "Uncommon", Income = 10,     Weight = 30, SellValue = 150 },
	["Reef Whale"]     = { Rarity = "Uncommon", Income = 18,     Weight = 27, SellValue = 250 },
	["Kelp Whale"]     = { Rarity = "Uncommon", Income = 28,     Weight = 24, SellValue = 400 },
	["Pearl Whale"]    = { Rarity = "Uncommon", Income = 40,     Weight = 21, SellValue = 600 },
	["Mist Whale"]     = { Rarity = "Uncommon", Income = 55,     Weight = 18, SellValue = 800 },

	-- ── RARE ────────────────────────────────────────────────────────────────
	["Crystal Whale"]  = { Rarity = "Rare",     Income = 100,    Weight = 10, SellValue = 2000 },
	["Emerald Whale"]  = { Rarity = "Rare",     Income = 160,    Weight = 9,  SellValue = 3500 },
	["Ruby Whale"]     = { Rarity = "Rare",     Income = 240,    Weight = 8,  SellValue = 5000 },
	["Sapphire Whale"] = { Rarity = "Rare",     Income = 350,    Weight = 7,  SellValue = 7500 },
	["Golden Whale"]   = { Rarity = "Rare",     Income = 500,    Weight = 6,  SellValue = 10000 },

	-- ── EPIC ────────────────────────────────────────────────────────────────
	["Cobalt Whale"]   = { Rarity = "Epic",     Income = 1000,   Weight = 3,  SellValue = 25000 },
	["Storm Whale"]    = { Rarity = "Epic",     Income = 1800,   Weight = 2.5,SellValue = 45000 },
	["Shadow Whale"]   = { Rarity = "Epic",     Income = 3000,   Weight = 2,  SellValue = 75000 },
	["Void Whale"]     = { Rarity = "Epic",     Income = 5000,   Weight = 1.5,SellValue = 125000 },
	["Thunder Whale"]  = { Rarity = "Epic",     Income = 8000,   Weight = 1,  SellValue = 200000 },

	-- ── LEGENDARY ───────────────────────────────────────────────────────────
	["Astral Whale"]   = { Rarity = "Legendary",Income = 20000,  Weight = 0.5,SellValue = 600000 },
	["Orbital Whale"]  = { Rarity = "Legendary",Income = 40000,  Weight = 0.4,SellValue = 1200000 },
	["Inferno Whale"]  = { Rarity = "Legendary",Income = 75000,  Weight = 0.3,SellValue = 2500000 },
	["Surge Whale"]    = { Rarity = "Legendary",Income = 130000, Weight = 0.2,SellValue = 4000000 },
	["Neon Whale"]     = { Rarity = "Legendary",Income = 200000, Weight = 0.1,SellValue = 7000000 },

	-- ── MYTHICAL ────────────────────────────────────────────────────────────
	["Cosmic Whale"]   = { Rarity = "Mythical", Income = 500000, Weight = 0.05, SellValue = 20000000 },
	["Phantom Whale"]  = { Rarity = "Mythical", Income = 900000, Weight = 0.04, SellValue = 35000000 },
	["Frosty Whale"]   = { Rarity = "Mythical", Income = 1500000,Weight = 0.03, SellValue = 60000000 },
	["Heavenly Whale"] = { Rarity = "Mythical", Income = 2500000,Weight = 0.02, SellValue = 100000000 },
	["Galaxy Whale"]   = { Rarity = "Mythical", Income = 5000000,Weight = 0.01, SellValue = 250000000 },
}
