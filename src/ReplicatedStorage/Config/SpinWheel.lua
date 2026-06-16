-- Each reward: Type (Coins/Gems/Egg/Multiplier), Value, Weight, Label, Color
return {
	{ Type = "Coins",      Value = 500,          Weight = 30, Label = "500 Coins",          Color = Color3.fromRGB(255, 215, 0) },
	{ Type = "Coins",      Value = 2000,         Weight = 25, Label = "2,000 Coins",        Color = Color3.fromRGB(255, 215, 0) },
	{ Type = "Coins",      Value = 10000,        Weight = 18, Label = "10,000 Coins",       Color = Color3.fromRGB(255, 215, 0) },
	{ Type = "Gems",       Value = 5,            Weight = 12, Label = "5 Gems",             Color = Color3.fromRGB(100, 200, 255) },
	{ Type = "Gems",       Value = 25,           Weight = 7,  Label = "25 Gems",            Color = Color3.fromRGB(100, 200, 255) },
	{ Type = "Gems",       Value = 100,          Weight = 4,  Label = "100 Gems",           Color = Color3.fromRGB(80, 140, 255) },
	{ Type = "Egg",        Value = "Ocean Egg",  Weight = 2,  Label = "Ocean Egg 🥚",       Color = Color3.fromRGB(50, 180, 255) },
	{ Type = "Egg",        Value = "Runic Egg",  Weight = 1,  Label = "Runic Egg ✨",       Color = Color3.fromRGB(150, 80, 255) },
	{ Type = "Multiplier", Value = 2, Duration = 3600, Weight = 1, Label = "2× Coins (1hr)", Color = Color3.fromRGB(255, 100, 50) },
}
