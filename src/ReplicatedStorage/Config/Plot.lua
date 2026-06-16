-- Plot layout & progression rules.
--   Start with 4 usable stables; +1 per rebirth.
--   Each floor holds 8 stables in a 4×2 grid.
--   Once a floor is fully unlocked, the next rebirth starts a new story (max 5).
return {
	BaseStables   = 4,    -- usable stables at 0 rebirths
	SlotsPerFloor = 8,    -- 4×2 grid per floor
	GridCols      = 4,
	GridRows      = 2,
	MaxFloors     = 5,    -- caps at 40 stables

	-- Geometry (studs)
	FloorSize   = 40,     -- platform width
	FloorDepth  = 24,     -- platform depth
	PadSize     = 7,      -- each stable pad
	PadSpacing  = 9,      -- distance between pad centres
	FloorHeight = 16,     -- vertical gap between stories
	WallHeight  = 12,

	-- World placement: each player's plot sits this far apart along X
	PlotSpacing = 260,
	Origin      = Vector3.new(0, 0, 300),
}
