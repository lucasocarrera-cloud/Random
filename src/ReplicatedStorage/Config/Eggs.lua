-- Each egg: display name, coin cost, list of whales that can hatch from it
return {
	["Starter Egg"] = {
		Cost = 100,
		-- Whales must match keys in Whales.lua; weights are pulled from there
		PossibleWhales = {
			"Classic Whale",
			"Ocean Whale",
			"Golden Whale",
		},
	},
}
