# Hatch a Whale — Full Game Plan
*Inspired by Hatch a Cow by Alpha Dog Studios*

---

## Research Summary: How Hatch a Cow Works

### Core Loop
1. **HATCH** — Buy eggs with Cash, get random whale (weighted RNG by rarity)
2. **PLACE** — Put whales on your plot → earn Cash/sec passively (even offline)
3. **PETS** — Equip luck pets to improve hatch chances
4. **MUTATE** — Place whales on Mutation Stands to add Mutation Stars (boosts income)
5. **REBIRTH** — Reset for permanent multiplier boosts + access to better eggs

### Two Currencies
- **Coins** (our version of Cash) — earned from whales, spent on eggs
- **Gems** — premium currency, used for luck upgrades, offline boosts, egg discounts, mutation stands

### Egg Progression (early → late game)
1. Starter Egg
2. Ocean Egg
3. Runic Egg
4. Obsidian Egg
5. Mutation Egg
6. Astral Egg
7. Galaxy Egg

### Whale Rarity Tiers (our version of cow rarities)
| Tier | Colour | Example Names |
|---|---|---|
| Common | Grey | Classic Whale, Blue Whale |
| Uncommon | Green | Ocean Whale, Coral Whale |
| Rare | Blue | Emerald Whale, Crystal Whale |
| Epic | Purple | Cobalt Whale, Storm Whale |
| Legendary | Gold | Astral Whale, Orbital Whale |
| Mythical | Red/Rainbow | Cosmic Whale, Heavenly Whale |

### Mutation System
- **Mutation Stands** = special pads in the world where you drag a whale to upgrade it
- Each upgrade adds a **Mutation Star** to that whale
- More stars = more Coins/sec from that whale
- Small fail chance on each upgrade attempt
- Stars carry over through rebirth (critical: farm stars BEFORE rebirthing)

### Pet System
- Pets give **Luck** stat
- Higher Luck = better chance of hatching rarer whales
- Pets are hatched separately or found through other means
- Equipped pets are active while hatching

### Rebirth System
- Costs a certain amount (coins or stars threshold)
- You LOSE: current coins, owned whales (non-starred)
- You KEEP: mutation stars on whales (partially)
- You GAIN: permanent multiplier (e.g. 1.5x income forever)
- You UNLOCK: access to next tier of eggs
- Strategy: farm mutation stars first, THEN rebirth

### Game Passes (confirmed from research)
| Pass | Price | Effect |
|---|---|---|
| Auto Hatch | 299 Robux | Automatically hatches eggs continuously |
| x8 Hatching | TBD | Hatch 8 eggs at once instead of 1 |
| Quick Hatch | TBD | Faster hatch animation |
| VIP | TBD | Bonus income multiplier |

### UI Layout
- **Top bar**: Coin/Gem display
- **Bottom**: Egg shop button, inventory button
- **Right side**: Settings (gear icon) with code redemption box
- **World**: Player's plot with placed whales + mutation stands
- **Settings → Codes**: type code → press Claim

### Working Promo Codes (for our game to have equivalent)
Hatch a Cow codes gave: Gems, Mutation Eggs, Cash, Rebirths, Spins
We'll create equivalent whale codes at launch milestones.

---

## Our Game: Hatch a Whale — Feature List

### Phase 1 — Core Engine ✅ DONE
- [x] Coins currency
- [x] Starter Egg + hatching
- [x] Weighted RNG hatch (server-side)
- [x] Income loop (coins/sec)
- [x] Equip system (max 3 whales)
- [x] DataStore saving
- [x] Basic Shop UI + HUD
- [x] Hatch popup with rarity colours

### Phase 2 — Plot & World
- [ ] Player plot system (each player has their own area)
- [ ] Place whales on plot visually
- [ ] Offline earnings (income accrues while offline, cap at 8h)
- [ ] Whale model display on plot

### Phase 3 — Mutation System
- [ ] Gems currency
- [ ] Mutation Stands (interactive pads in world)
- [ ] Mutation Stars on whales
- [ ] Star boost to income
- [ ] Fail chance system

### Phase 4 — Pet System
- [ ] Pet config (types, luck values)
- [ ] Pet inventory
- [ ] Equip pet UI
- [ ] Luck stat affects hatch RNG

### Phase 5 — Rebirth System
- [ ] Rebirth requirements (star count threshold)
- [ ] Rebirth screen UI
- [ ] Permanent multiplier stacking
- [ ] Unlock new egg tiers on rebirth

### Phase 6 — Full Egg Lineup
- [ ] Ocean Egg
- [ ] Runic Egg
- [ ] Obsidian Egg
- [ ] Mutation Egg
- [ ] Astral Egg
- [ ] Galaxy Egg

### Phase 7 — Game Passes
- [ ] Auto Hatch pass
- [ ] x8 Hatching pass
- [ ] Quick Hatch pass
- [ ] VIP (income multiplier) pass
- [ ] Game pass UI with real icons from Roblox

### Phase 8 — Polish & Social
- [ ] Leaderboard (top earners, most rebirths)
- [ ] Promo codes system
- [ ] Trade system (optional)
- [ ] Daily rewards
- [ ] Hatch animation (tween/particle)
- [ ] Sound effects
- [ ] Tutorial for new players
- [ ] Settings menu with music/sfx toggles

### Phase 9 — 74 Whales
- [ ] Design all 74 whales with names, rarities, income values
- [ ] Add models for each whale
- [ ] Balance income curve across all tiers

---

## Day-by-Day Build Plan (10 weeks)

### Week 1 — Plot System & World
- Day 1: Player plot assignment (each player owns a grid area)
- Day 2: Place whale on plot (client drags whale from inventory to plot)
- Day 3: Whale model spawning on plot
- Day 4: Remove/swap whale from plot
- Day 5: Offline earnings system (timestamp on leave, calculate on join)

### Week 2 — Inventory UI
- Day 1: Whale collection viewer (scrolling frame, show all owned whales)
- Day 2: Whale card design (name, rarity, income, star count, equip button)
- Day 3: Equip/unequip from inventory screen
- Day 4: Sort inventory by rarity / income
- Day 5: "New!" badge on newly hatched whales

### Week 3 — Gems & Mutation System
- Day 1: Gems currency (earn from codes, game passes, daily rewards)
- Day 2: Mutation Stand object in world (interactable pad)
- Day 3: Drag whale to stand mechanic
- Day 4: Mutation star logic (success/fail RNG, boost calculation)
- Day 5: Star display on whale cards in inventory

### Week 4 — Pet System
- Day 1: Pet config table (pet names, luck values, rarity)
- Day 2: Pet hatching (separate egg type or found via code)
- Day 3: Pet inventory UI
- Day 4: Equip pet → Luck stat updates
- Day 5: Luck stat affects hatch RNG weight calculation

### Week 5 — Rebirth System
- Day 1: Rebirth requirements check (minimum stars/coins)
- Day 2: Rebirth confirmation UI screen
- Day 3: Rebirth execution (wipe coins/whales, keep stars, grant multiplier)
- Day 4: Permanent multiplier applied to income loop
- Day 5: Rebirth unlocks next egg tier in shop

### Week 6 — Full Egg Shop
- Day 1: Ocean Egg + unlock condition
- Day 2: Runic + Obsidian Eggs
- Day 3: Mutation + Astral Eggs
- Day 4: Galaxy Egg (late game, gem cost)
- Day 5: Multi-egg purchase (buy 1 / buy 10 buttons)

### Week 7 — Game Passes
- Day 1: Auto Hatch pass (server loop hatches automatically)
- Day 2: x8 Hatch pass (hatch 8 at once)
- Day 3: Quick Hatch pass (skip animation)
- Day 4: VIP income multiplier pass
- Day 5: Game pass UI panel with icons + purchase prompts

### Week 8 — Social & Promo
- Day 1: Code redemption system (Settings → enter code)
- Day 2: Define 10 launch codes
- Day 3: Leaderboard (top coins, top rebirths)
- Day 4: Daily reward popup (login streak → gems/eggs)
- Day 5: Trade system (basic: offer whale ↔ whale)

### Week 9 — Polish
- Day 1: Hatch animation (egg shakes → cracks → whale reveal tween)
- Day 2: Particle effects on Legendary/Mythical hatch
- Day 3: Sound effects (coin jingle, hatch sound, button clicks)
- Day 4: Tutorial system (arrow pointing at egg shop for new players)
- Day 5: Settings menu (music toggle, SFX toggle, graphics quality)

### Week 10 — 74 Whales & Launch Prep
- Day 1-3: Finalize all 74 whale designs + add to config
- Day 4: Balance pass (income curve, hatch weights, egg costs)
- Day 5: Full playtest + bug fixes + publish

---

## Master To-Do List (200 Items)

### 🏗️ INFRASTRUCTURE
1. Set up Rojo project (✅ done)
2. Create default.project.json (✅ done)
3. Set up DataStore saving (✅ done)
4. Set up RemoteEvents/Functions (✅ done)
5. Set up GameConfig module (✅ done)
6. Add auto-save every 60 seconds (✅ done)
7. Add pcall error handling on all DataStore calls (✅ done)
8. Create DataStore versioning (v1, v2 migration logic)
9. Add server-side anti-exploit validation on all remotes
10. Set up a Logger module for debug output

### 🐋 WHALE CONFIG
11. Define all rarity tiers (Common/Uncommon/Rare/Epic/Legendary/Mythical)
12. Add Classic Whale (Common, 1/sec) (✅ done)
13. Add Ocean Whale (Uncommon, 5/sec) (✅ done)
14. Add Golden Whale (Rare, 25/sec) (✅ done)
15. Add Coral Whale (Common, 2/sec)
16. Add Blue Whale (Common, 3/sec)
17. Add Tide Whale (Uncommon, 8/sec)
18. Add Reef Whale (Uncommon, 12/sec)
19. Add Crystal Whale (Rare, 40/sec)
20. Add Emerald Whale (Rare, 60/sec)
21. Add Cobalt Whale (Epic, 150/sec)
22. Add Storm Whale (Epic, 250/sec)
23. Add Shadow Whale (Epic, 400/sec)
24. Add Astral Whale (Legendary, 1000/sec)
25. Add Orbital Whale (Legendary, 2000/sec)
26. Add Inferno Whale (Legendary, 3500/sec)
27. Add Surge Whale (Legendary, 5000/sec)
28. Add Cosmic Whale (Mythical, 15000/sec)
29. Add Phantom Whale (Mythical, 25000/sec)
30. Add Frosty Whale (Mythical, 40000/sec)
31. Add Heavenly Whale (Mythical, 75000/sec)
32-74. Add remaining 43 whales (to be designed by you)
75. Balance-check all income values against egg costs

### 🥚 EGG CONFIG
76. Starter Egg (100 coins) (✅ done)
77. Ocean Egg (500 coins, unlocked from start)
78. Runic Egg (2,500 coins, unlocked after 1 rebirth)
79. Obsidian Egg (10,000 coins, unlocked after 2 rebirths)
80. Mutation Egg (50,000 coins OR gems, unlocked after 3 rebirths)
81. Astral Egg (250,000 coins, unlocked after 5 rebirths)
82. Galaxy Egg (1,000,000 coins OR 500 gems, late game)
83. Define which whales can hatch from each egg
84. Add "buy 10" bulk hatch option per egg
85. Add egg unlock conditions (rebirth count gate)

### 💰 CURRENCY SYSTEM
86. Coins income loop (✅ done)
87. Add Gems as second currency
88. Add Gems field to DataStore
89. Display Gems in HUD next to Coins
90. Earn gems from: codes, game passes, daily login, achievements
91. Spend gems: luck upgrades, offline boost, egg discounts, mutation stands

### 🗺️ PLOT SYSTEM
92. Design plot layout (grid of slots, e.g. 3x3 = 9 slots)
93. Assign each player a plot area in the world
94. Create PlotManager server module
95. Save placed whale positions per player
96. Load and respawn placed whales on rejoin
97. Add "Place Whale" button in inventory
98. Add "Remove from Plot" option
99. Cap plot size (expandable with gems/passes)
100. Show empty slot indicators on plot

### 🔁 OFFLINE EARNINGS
101. Record timestamp when player leaves (DataStore)
102. On join, calculate time elapsed since last session
103. Calculate coins earned while offline (income/sec × seconds)
104. Cap offline earnings at 8 hours
105. Show "Welcome back! You earned X coins while away" popup
106. Gems upgrade to extend offline cap to 24h

### ⭐ MUTATION SYSTEM
107. Add Mutation Stars field to each whale in DataStore
108. Create MutationStand object in workspace
109. Make stand interactable (ProximityPrompt)
110. UI: select which whale to mutate
111. Server: roll success/fail (e.g. 80% success)
112. On success: add star, recalculate income
113. On fail: show fail message, no penalty
114. Star income formula: base × (1 + 0.25 × stars)
115. Cap mutation stars per whale (e.g. max 10)
116. Display star count on whale card in inventory

### 🐾 PET SYSTEM
117. Create Pets config (pet names, luck values, rarity)
118. Add 5 starter pets (e.g. Clownfish, Starfish, Crab, Seahorse, Dolphin)
119. Add 5 rare pets (e.g. Shark, Manta Ray, Jellyfish, Anglerfish, Narwhal)
120. Pet hatching from a separate "Pet Egg"
121. Pet inventory UI (separate from whale inventory)
122. Equip up to 3 pets at once
123. Active pets sum their Luck stat
124. Luck stat modifies hatch weight calculation server-side
125. Display active Luck value in HUD
126. Pets saved in DataStore

### 🔄 REBIRTH SYSTEM
127. Define rebirth requirements (e.g. minimum 10 mutation stars total)
128. Create Rebirth button in UI
129. Rebirth confirmation popup ("Are you sure? You will lose all coins and whales")
130. Server: execute rebirth (wipe coins/whales, keep stars, increment rebirth count)
131. Grant permanent income multiplier (e.g. ×1.5 per rebirth, stacking)
132. Save rebirth count + multiplier in DataStore
133. Apply multiplier to income loop
134. Unlock next egg tier based on rebirth count
135. Show rebirth count badge on player's name/plot
136. Rebirth leaderboard

### 🎟️ GAME PASSES
137. Create Auto Hatch pass on Roblox (get ID)
138. Code Auto Hatch logic (server hatches every X seconds automatically)
139. Create x8 Hatch pass on Roblox (get ID)
140. Code x8 Hatch (fire hatch 8 times, return array of results)
141. Create Quick Hatch pass (skip animation)
142. Create VIP pass (1.5× income multiplier)
143. Code VIP multiplier in income loop
144. Game pass panel UI (icons, descriptions, price, buy button)
145. Fetch pass icons from MarketplaceService:GetProductInfo
146. Handle PromptGamePassPurchaseFinished to grant pass live
147. Check pass ownership on join (UserOwnsGamePassAsync)
148. Save pass ownership in DataStore (cache to avoid API spam)

### 🖥️ UI — HUD
149. Coins display top-left (✅ done)
150. Gems display next to coins
151. Income/sec display ("▲ 1,250/sec")
152. Rebirth count badge
153. Active luck stat display
154. Top-right: Settings button (gear icon)
155. Number formatting (1,000 → 1K, 1,000,000 → 1M, 1B, 1T)

### 🛒 UI — SHOP
156. Shop button bottom-centre (✅ done)
157. Egg cards in scrolling frame
158. Each egg card: name, cost, possible whales preview, Hatch/Buy10 buttons
159. Lock icon on eggs not yet unlocked (show rebirth requirement)
160. Gems cost display for premium eggs
161. "Most Popular" or "Best Value" badge on mid-tier egg
162. Animate egg card on hover

### 📦 UI — INVENTORY
163. Inventory button (bottom bar)
164. Scrolling grid of whale cards
165. Each card: whale name, rarity colour, income/sec, star count
166. Filter by rarity
167. Sort by income / name / stars
168. "Place on Plot" button per card
169. "Mutate" button per card
170. "NEW" badge for freshly hatched whales

### 🥚 UI — HATCH SCREEN
171. Egg shake animation before reveal (✅ basic popup done)
172. Crack particle effect
173. Whale name reveal with rarity glow colour
174. Income preview ("This whale earns 25/sec!")
175. "Hatch Again" button
176. Confetti/particles on Legendary+ hatch
177. Sound effect on hatch

### ⚙️ UI — SETTINGS
178. Settings panel (gear icon, right side)
179. Music toggle
180. SFX toggle
181. Graphics quality slider
182. Code redemption input + Claim button
183. Credits (your name + "Inspired by Hatch a Cow")

### 🏆 SOCIAL FEATURES
184. Global leaderboard: top 10 by coins/sec
185. Global leaderboard: top 10 by rebirth count
186. BillboardGui over each player showing their name + rebirth count
187. Code system: define codes table server-side
188. Launch codes: WELCOMEWHALE, MOO, FIRSTHATCH (etc.)
189. Code gives gems/eggs/coins
190. Daily login streak (day 1→7 increasing reward)
191. Achievement system (e.g. "Hatch 10 whales", "Reach 1000 coins/sec")

### 🎨 POLISH
192. Hatch sound effect
193. Coin earn jingle (tick sound)
194. Button click sounds
195. Background ocean ambient music
196. Animated ocean/wave map background
197. Tutorial arrow pointing at egg shop for new players
198. First-time tooltip: "Click here to hatch your first whale!"
199. Loading screen with game logo
200. Mobile UI scaling (test on phone-sized screen)
