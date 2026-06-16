return {
	-- Currency
	StartingCoins = 100,
	StartingGems = 0,

	-- Plot
	MaxPlotSlots = 9,          -- 3×3 grid, expandable with pass

	-- Income
	IncomeInterval = 1,        -- seconds between payouts

	-- Offline earnings
	MaxOfflineHours = 8,       -- cap at 8h; 2x pass doubles to 16h

	-- Equip
	MaxEquippedPets = 3,       -- base; Pet Master pass adds 2

	-- Rebirth: keep whales, only lose coins & unplaced eggs
	RebirthKeepWhales = true,
	RebirthMultiplierPerRebirth = 1.5, -- income × 1.5 per rebirth (stacking)

	-- Spin wheel
	FreeSpinIntervalMinutes = 15,
	SpinsPerRobuxPack = 3,     -- 3 spins for 49 Robux (DevProduct)

	-- Sell store: base sell multiplier (coins = Income × SellMultiplier)
	SellMultiplier = 10,

	-- DataStore
	DataStoreKey = "PlayerData_v3",
}
