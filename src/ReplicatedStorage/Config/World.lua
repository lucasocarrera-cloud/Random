-- Shared world layout: positions for shop stands & NPCs.
-- Used by the server (to build them) and the client (to teleport to them).
return {
	Stands = {
		EggShop  = { Pos = Vector3.new( 30, 0,  0), NpcColor = Color3.fromRGB(40,100,220),  Label = "🥚 Egg Shop",   Shop = "Egg" },
		SellShop = { Pos = Vector3.new(-30, 0,  0), NpcColor = Color3.fromRGB(220,70,70),    Label = "💰 Sell Shop",  Shop = "Sell" },
		SpinShop = { Pos = Vector3.new(-46, 0,  0), NpcColor = Color3.fromRGB(190,60,190),   Label = "🎡 Spin Wheel", Shop = "Spin" },
		RobuxShop= { Pos = Vector3.new( 46, 0,  0), NpcColor = Color3.fromRGB(255,150,0),    Label = "🛍️ Robux Shop", Shop = "Robux" },
	},
	PlotCenter = Vector3.new(0, 0, 30),  -- where the "Plot" teleport sends you
}
