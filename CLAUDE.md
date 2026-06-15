# HatchAWhale — Roblox Project

## Project structure

This is a **Rojo**-managed Roblox game project. Source files in `src/` map to Roblox services defined in `default.project.json`.

| Folder | Roblox service |
|---|---|
| `src/ServerScriptService/` | ServerScriptService |
| `src/StarterPlayerScripts/` | StarterPlayer > StarterPlayerScripts |
| `src/ReplicatedStorage/` | ReplicatedStorage |

Files follow Rojo naming conventions:
- `*.server.lua` → Script (server)
- `*.client.lua` → LocalScript (client)
- `*.lua` → ModuleScript

## How to sync changes into Roblox Studio

1. Install the [Rojo CLI](https://rojo.space/docs/v7/installation/) if not already installed.
2. In this repo directory, run:
   ```
   rojo serve
   ```
3. In Roblox Studio, open the Rojo plugin and click **Connect**.
4. Changes to files in `src/` will sync into Studio instantly.

## How to add a new whale

Open `src/ReplicatedStorage/Config/Whales.lua` and add an entry:

```lua
["Your Whale Name"] = {
    Rarity = "Common",   -- Common, Uncommon, Rare, Epic, Legendary
    Income = 10,         -- coins per second when equipped
    Weight = 30,         -- higher = hatches more often
},
```

That's it — no other files need to change.

## How to add a new egg

Open `src/ReplicatedStorage/Config/Eggs.lua` and add an entry:

```lua
["Ocean Egg"] = {
    Cost = 500,
    PossibleWhales = {
        "Classic Whale",
        "Ocean Whale",
        "Golden Whale",
    },
},
```

Then add the egg to the shop UI in `src/StarterPlayerScripts/Client.client.lua`.

## Rarity tiers (planned)

| Rarity | Colour | Suggested weight range |
|---|---|---|
| Common | Grey | 50–70 |
| Uncommon | Green | 20–30 |
| Rare | Blue | 5–15 |
| Epic | Purple | 1–5 |
| Legendary | Gold | 0.1–1 |

## Game pass IDs

Add your game pass IDs here once created on Roblox:

```lua
-- Example (fill in real IDs after creating on roblox.com)
GamePasses = {
    DoubleCoins  = 0,  -- replace 0 with real ID
    AutoHatch    = 0,
    ExtraSlot    = 0,
}
```

## Build plan checklist

- [x] Phase 1 — Core engine (hatch, income, DataStore, equip)
- [ ] Phase 2 — Inventory / whale collection UI
- [ ] Phase 3 — Multiple eggs in shop
- [ ] Phase 4 — Game passes
- [ ] Phase 5 — 74 whales + rebirth system
