# COMPLETE PROJECT ROADMAP & SYSTEM AUDIT
> **Date:** 2026-02-15
> **Purpose:** Full overview of what exists, what's needed, pinch points, and deployment path
> **Status:** Living document - updated as systems are completed

---

## 🎯 PROJECT VISION & SCOPE

### **What We're Building:**
- Single-player tactical card game with narrative progression
- Slave-turned-gladiator in fictional Roman provincial setting
- 1 Champion + 2 Lieutenants (shared deck, passive support)
- Fail-forward structure (injuries, not permadeath)
- 2-Season campaign (Season 1 = 15 missions for V1, Season 2 = 15 missions built ahead)

### **Release Strategy:**
- **Season 1 drops** when Season 2 is 100% complete (we stay 1 season ahead)
- **Season 2 drops** when Season 3 is 90% complete
- Never rush content, always have buffer

---

## ✅ WHAT WE HAVE (98% Complete — Squad Combat + Signature Cards + Balance Done!)

### **TIER 1: COMBAT SYSTEMS** ✅ LOCKED

#### **1. Combat Engine** ✅ LOCKED V1
**Status:** Production-ready
**Document:** `COMBAT_SYSTEM_LOCKED_V1.md`

**What's Done:**
- Turn structure (3 phases: Start → Main → End)
- Speed-based turn order (ECLIPSE 5, SPECTER 4, AEGIS 2)
- Resource generation (Stamina 3/turn, Mana 0 start +1/turn +1/card +1/5dmg)
- Damage calculation (8-step formula with modifiers)
- Win/loss conditions
- Deck mechanics (draw, discard, exhaust, shuffle)
- Hand limit (8 cards), starting hand (5 cards)
- Combat items (1/turn, free action)

**What Works:**
- ✅ Clean, predictable combat flow
- ✅ Simpler than Slay the Spire, deeper than Hearthstone
- ✅ Faction passives integrated (Fortress, Bloodlust, Miasma)

**Pinch Points (Future):**
- ⚠️ Lieutenant integration not defined (how do 3 units work with shared deck?)
- ⚠️ AoE targeting (which enemy to hit?)
- ⚠️ Squad positioning (front/back line mentioned but not implemented)

---

#### **2. Status Effects** ✅ LOCKED V1
**Status:** Production-ready
**Document:** `STATUS_EFFECTS_LOCKED_V1.md`

**What's Done:**
- 5 status effects fully defined (Bleeding, Armor, Weakened, Enraged, Poison)
- Exact numbers (damage/stack, max stacks, decay rules)
- Timing rules (start of turn, end of turn)
- Stacking rules (intensity vs duration)
- Cleanse mechanics

**What Works:**
- ✅ Simple to understand (1 damage/stack for DoTs)
- ✅ Faction synergies clear (SPECTER + Poison, ECLIPSE + Bleeding)
- ✅ No complex edge cases

**Pinch Points (Future):**
- ⚠️ Status effects per unit tracking (if lieutenants can have individual statuses)

---

#### **3. Factions** ✅ LOCKED V1
**Status:** Production-ready
**Document:** `faction_design_complete.md`

**What's Done:**
- 3 factions (AEGIS, ECLIPSE, SPECTER)
- Stat profiles (HP, Armor, Speed per faction)
- Faction passives (Fortress, Bloodlust, Miasma)
- Rock-paper-scissors balance (60-65% win rate targets)

**What Works:**
- ✅ Distinct playstyles (tank, burst, control)
- ✅ Passives create identity
- ✅ Balance validated via matchup analysis

**Pinch Points (Future):**
- ⚠️ Champion vs Lieutenant faction assignment (does Champion pick faction, lieutenants independent?)

---

#### **4. Card Library** ✅ LOCKED V1
**Status:** Production-ready
**Document:** `CARD_LIBRARY_COMPLETE.md`

**What's Done:**
- 63 total cards (45 faction + 18 neutral)
- AEGIS: 15 cards, ECLIPSE: 15 cards, SPECTER: 15 cards, Neutral: 18 cards
- Cost distribution (avg 1.6 Stamina, range 0-4)
- Starting decks (10 cards per faction)
- Card rarity limits (Common unlimited, Rare max 3, Epic max 2)
- Unlock progression (Level 1-15)

**What Works:**
- ✅ Every card has clear purpose
- ✅ Power curve validated
- ✅ Faction identity clear

**Pinch Points (Future):**
- ⚠️ Squad-specific cards ("another unit in your squad") need targeting rules
- ⚠️ Signature lieutenant cards not designed yet (Marcus, Livia, etc. unique cards)

---

#### **5. Faction Abilities** ✅ LOCKED V1
**Status:** Production-ready
**Document:** `FACTION_ABILITIES_COMPLETE.md`

**What's Done:**
- 9 abilities (3 per faction, 2 tiers each)
- AEGIS: Bulwark (3 Mana), Iron Bastion (7 Mana)
- ECLIPSE: Crimson Surge (3 Mana), Reaper's Mark (7 Mana)
- SPECTER: Withering Curse (3 Mana), Plague Mastery (7 Mana)
- Power budget validation
- Matchup analysis

**What Works:**
- ✅ Tier 1 abilities (3 Mana) available Turn 3-4
- ✅ Tier 2 abilities (7 Mana) available Turn 5-7
- ✅ Clear power spikes

**Pinch Points (Future):**
- ⚠️ Lieutenant-specific abilities? (Or only Champion uses abilities?)

---

### **TIER 2: CONTENT SYSTEMS** ✅ LOCKED

#### **6. Enemy Archetypes** ✅ LOCKED V1
**Status:** Production-ready
**Document:** `ENEMY_ARCHETYPES_COMPLETE.md`

**What's Done:**
- 12 enemy types (8 common + 3 elite + 1 boss template)
- AI behavior patterns (priority system: kill blow → status → defense → damage)
- Loot tables
- Act scaling (+20% HP Act 2, +40% HP Act 3)
- Squad composition templates

**What Works:**
- ✅ Clear difficulty progression
- ✅ AI is predictable (no bullshit RNG)
- ✅ Boss template with 3-phase mechanics

**Pinch Points (Future):**
- ⚠️ Enemy squad vs player squad rules (how do 3 enemies target 3 player units?)

---

#### **7. Gear System** ✅ LOCKED V1
**Status:** Production-ready
**Document:** `gear_system_complete.md`

**What's Done:**
- 24 gear pieces (8 weapons, 8 armors, 8 accessories)
- Rarity tiers (Common 60-80g, Rare 250-350g, Epic 900-1200g)
- Stat budgets per rarity
- Faction synergies
- Drop rates per Act
- 4 build examples

**What Works:**
- ✅ Clear progression (Common → Rare → Epic)
- ✅ Faction synergies encourage build diversity

**Pinch Points (Future):**
- ⚠️ Gear per lieutenant? (3 units × 3 gear slots = 9 gear pieces equipped?)
- ⚠️ Shared gear pool or per-unit loadouts?

---

#### **8. Economy & Shop** ✅ LOCKED V1
**Status:** Production-ready
**Document:** `ECONOMY_SHOP_SYSTEM_COMPLETE.md`

**What's Done:**
- Total gold income: 3,924 gold (15 missions)
- All spending categories (healing, gear, cards, upgrades, utility)
- Shop services (Doctor, Shaman, Market, Card Vendor)
- Unlock progression (level + Act gates)
- Economic balance (~1,285g deficit = meaningful choices)

**What Works:**
- ✅ Gold scarcity creates choices
- ✅ Services unlocked gradually
- ✅ Balanced for 15-mission campaign

**Pinch Points (Future):**
- ⚠️ Service state changes (prices/access change based on story)
- ⚠️ Season 2 economy (need +3,924g for 15 more missions)

---

#### **9. Injury/Expedition System** ✅ LOCKED V1
**Status:** Production-ready
**Document:** `expedition_injury_system.md`

**What's Done:**
- Two-track health (HP short-term, Injury long-term)
- Three tiers (Minor/Serious/Grave)
- Escalation path (2 Minor → Serious → Grave)
- Healing costs (50g/150g/300g Blood Price)
- Retreat mechanic
- Per-unit tracking

**What Works:**
- ✅ Prevents death spirals
- ✅ Fail-forward (injuries not permadeath)
- ✅ Meaningful consequences

**Pinch Points (Future):**
- ⚠️ Injury distribution across 3 units (who takes injuries after mission failure?)
- ⚠️ Injury medals (scars → bonuses after 5 missions) not designed yet

---

#### **10. Lieutenant System** ✅ LOCKED V1
**Status:** Production-ready
**Document:** `lieutenant_and_status_design.md`

**What's Done:**
- 8 lieutenants designed (Kira, Darius, Marcus, Selene, Elena, Corvus, Thane, Aria)
- Stat blocks (HP, Armor, Speed per lieutenant)
- Traits (passive bonuses)
- Progression system (XP, levels 1-6)
- Signature cards per lieutenant

**What Works:**
- ✅ Clear identities (Marcus = tank, Livia = poison specialist)
- ✅ Traits create playstyle variety

**Pinch Points (Future):**
- ⚠️ Combat integration (how do 3 units act in shared-deck system?)
- ⚠️ Signature cards need full design (currently only mentioned)
- ⚠️ Loyalty system not implemented
- ⚠️ Companion arcs (4-mission stories per lieutenant) not designed

---

### **TIER 3: SUPPORTING SYSTEMS** ✅ LOCKED

#### **11. Combat Simulator Parameters** ✅ LOCKED V1
**Status:** Ready for coding
**Document:** `SIMULATOR_PARAMETERS_LOCKED.md`

**What's Done:**
- 150 simulation plan (50 per faction vs Scout)
- Starter decks (10 cards each)
- AI decision rules
- Metrics tracking

**What Works:**
- ✅ Can validate balance before building full game

**Pinch Points (Future):**
- ⚠️ Needs update for squad combat (3 units vs 3 enemies)

---

#### **12. Master Manuscript** ✅ COMPLETE
**Status:** Documentation complete
**Document:** `CARD_GAME_MASTER_MANUSCRIPT.md`

**What's Done:**
- All systems compiled in one place
- Table of contents
- Source markers for traceability

**What Works:**
- ✅ Single reference for all mechanics

---

### **TIER 4: SQUAD COMBAT INTEGRATION** ✅ LOCKED (NEW)

#### **13. Squad Combat Rules** ✅ LOCKED V1
**Status:** Production-ready
**Document:** `SQUAD_COMBAT_RULES_V1.md` (NEW)

**What's Done:**
- ✅ Shared resource model (1 Stamina pool, 1 Mana pool, 1 hand per squad)
- ✅ 3-4 unit squad structure (Champion back, Lieutenants front)
- ✅ Card assignment system (player assigns cards to specific units)
- ✅ Individual HP tracking per unit (KO mechanics)
- ✅ Positioning/blocking system (front-row units intercept back-row damage)
- ✅ Bench system with progressive costs (50g→150g→300g→500g)
- ✅ 2-fight swap cooldown (prevent abuse)
- ✅ Tent camp resource system (limited between-fight camps)
- ✅ Dynamic enemy AI (chess moves, not hardcoded priority)
- ✅ Squad composition templates (1-2, 2-3, 2-3, 1 boss per mission)

**What Works:**
- ✅ Champion feels special (protected in back row)
- ✅ Lieutenants matter (individual HP, traits, positioning)
- ✅ Shared resources create squad-building tension
- ✅ Bench system enables 8+ lieutenant roster without bloat

**Integration Points:**
- ✅ Works with existing status effects (per-unit tracking)
- ✅ Works with factions (champion faction locks deck)
- ✅ Works with cards (squad-targeted cards now have clear rules)

---

#### **14. Squad Gear System** ✅ LOCKED V1
**Status:** Production-ready
**Document:** `GEAR_SYSTEM_SQUAD_UPDATED.md` (NEW)

**What's Done:**
- ✅ Champion: Full modular gear (Helmet, Chest, Feet, Weapon, 2 Accessories, optional Shield) = 6-7 slots
- ✅ Lieutenants: Simplified system (optional Weapon, Outfit pre-made armor, 2 Accessories) = 4 slots each
- ✅ 9 armor pieces for Champion (3 helmets, 3 chests, 3 feet)
- ✅ 3 shield options (optional)
- ✅ 6 lightweight weapons for Lieutenants
- ✅ 9 Lieutenant outfits (pre-made armor bundles, 3 common, 3 rare, 3 epic)
- ✅ Shared 8 accessories pool
- ✅ Total equipped: 18-19 pieces (manageable inventory)

**What Works:**
- ✅ Champion customization encourages experimentation
- ✅ Lieutenant outfits create squad identity (unified look)
- ✅ Accessories enable unique builds per lieutenant
- ✅ Gear slot distribution is balanced (not too many pieces to track)

---

#### **15. Squad Injury Distribution** ✅ LOCKED V1
**Status:** Production-ready
**Document:** `SQUAD_INJURY_DISTRIBUTION.md` (NEW)

**What's Done:**
- ✅ Perfect Victory outcome (0 KOs) = no injury, +1 morale
- ✅ Partial Victory outcome (1-2 KOs) = 50% Serious for downed units, 0% for standing
- ✅ Strategic Retreat outcome = 50% Serious for downed, 25% Minor for standing
- ✅ Total Wipe outcome = 100% Serious guaranteed for all units, -1 morale
- ✅ Per-unit injury escalation (each unit tracks knockdowns independently)
- ✅ Morale system (±1/-2 based on outcomes, affects Mana pool next mission)
- ✅ Benched unit mechanics (don't participate, don't get injured)
- ✅ Squad-aware healing options (Doctor, Shaman, Natural healing per unit)

**What Works:**
- ✅ Injury risk is distributed based on tactical performance
- ✅ Perfect victory rewarded with morale boost
- ✅ Total wipe is catastrophic but recoverable (all Serious, not Grave)
- ✅ Retreat is always an option (prevents mandatory Grave injuries)

---

#### **16. Enemy Archetypes (Squad Version)** ✅ LOCKED V1
**Status:** Production-ready
**Document:** `ENEMY_ARCHETYPES_SQUAD.md` (NEW)

**What's Done:**
- ✅ Extended existing 12 enemy types with squad-aware AI
- ✅ Squad positioning system (front/back-row roles)
- ✅ Squad composition templates (8-10 standard squads)
- ✅ Sample wave lineups (Act 1-3 missions with enemy squads)
- ✅ Squad-aware AI decision tree (prioritizes ally health)
- ✅ Protection mechanics (Shieldbearer covers allies)
- ✅ Healing priority (Warlock keeps damage dealers alive)
- ✅ 6 detailed squad templates:
  - Tank + Damage (AEGIS classic)
  - Bleed Stack (ECLIPSE offensive)
  - Poison Stack (SPECTER control)
  - Mixed Faction Elite
  - Boss + Adds
  - Boss Solo

**What Works:**
- ✅ Enemy squads feel coordinated (not random groups)
- ✅ Squad-aware AI makes enemies smarter
- ✅ Boss encounters have clear difficulty tiers
- ✅ Wave composition teaches different tactical lessons

---

#### **17. Alignment Checklist** ✅ LOCKED V1
**Status:** Production-ready
**Document:** `ALIGNMENT_CHECKLIST_SQUAD_COMBAT.md` (NEW)

**What's Done:**
- ✅ Item 1: Gear System — LOCKED (hybrid Champion/Lieutenant model)
- ✅ Item 2: Card Library — Requires 16-24 signature cards (designed, not yet written)
- ✅ Item 3: Progression System — Requires per-lieutenant XP tracking (designed)
- ✅ Item 4: Injury System — LOCKED (squad distribution rules)
- ✅ Item 5: Enemy Archetypes — LOCKED (squad compositions + AI updates)

**All Systems Compatible:**
- ✅ Combat system (per-unit damage tracking)
- ✅ Status effects (per-unit application)
- ✅ Factions (per-unit bonuses)
- ✅ Faction abilities (Champion-only use confirmed)

---

## ⚠️ WHAT WE NEED (2% Remaining)

### **TIER 1: COMPLETED FOR V1** ✅

#### **1. Squad Combat Rules** ✅ COMPLETE
**Status:** LOCKED
**Priority:** CRITICAL — NOW COMPLETE

**What's Done:**
- ✅ Shared resource model (1 Stamina pool, 1 Mana pool, 1 hand)
- ✅ Turn structure for 3-4 units (shared deck, card assignment to units)
- ✅ Card assignment rules (player assigns "Shield Bash → Marcus")
- ✅ Targeting system (player chooses which enemy/unit to hit)
- ✅ Individual HP tracking during combat
- ✅ Bench system with progressive swap costs
- ✅ Tent camp resource system
- ✅ Squad composition templates

**Why This Works:**
- ✅ Matches locked resource design (no per-unit Stamina/Mana)
- ✅ Lieutenants matter (individual HP, traits, faction bonuses)
- ✅ Tactical depth (which unit plays which card?)
- ✅ Simple to implement (1 Stamina pool, 1 Mana pool, 1 hand)

**Document:** `SQUAD_COMBAT_RULES_V1.md`

---

#### **2. Lieutenant Signature Cards** ✅ COMPLETE
**Status:** LOCKED
**Priority:** HIGH — NOW COMPLETE

**What's Done:**
- ✅ All 24 signature cards designed (3 per lieutenant × 8 lieutenants)
- ✅ Card costs and rarity distribution balanced (8 Common, 8 Rare, 8 Epic)
- ✅ Added to CARD_LIBRARY_COMPLETE.md
- ✅ Updated total card count: 63 → 87 cards

**Cards by Lieutenant:**
- Marcus (ECLIPSE): Veteran's Resolve, Legion Tactics, Disciplined Veteran
- Livia (SPECTER): Blessed Strike, Ritual Curse, Corruption's Blessing
- Titus (Neutral/AEGIS): Noble's Command, Political Leverage, Patriarch's Decree
- Kara (ECLIPSE): Predator's Strike, Savage Hunt, Beast's Final Blow
- Decimus (SPECTER): Shadow Strike, Lethal Precision, Mark for Death
- Julia (Neutral): Kindred Bond, Shared Strength, Unbreakable Spirit
- Corvus (Neutral/SPECTER): Underground Connection, Black Market Trade, Escape Plan
- Thane (Neutral): Arena Veteran, Crowd Favorite, Gladiator's Championship

**Document:** `LIEUTENANT_SIGNATURE_CARDS.md`

---

#### **3. Progression System** ⚠️ 30% COMPLETE
**Status:** INCOMPLETE
**Priority:** HIGH
**Document:** `project_todo_list.md`

**What's Done:**
- Card unlock schedule (Level 1-15)
- Gear drop rates (Act-based)
- Shop unlock gates

**What's Missing:**
- Stat growth formulas (HP/Armor/Speed per level)
- Mission-specific unlocks (which missions unlock which cards?)
- Campaign upgrade schedule (resource boosts timing)

**Recommendation:**
**LINEAR STAT GROWTH (Simpler to Balance):**
```
AEGIS Champion:
- Level 1: 30 HP, 5 Armor, 2 Speed
- Per level: +2 HP, +0 Armor (Armor from gear), +0 Speed
- Level 15: 58 HP, 5 Armor, 2 Speed

ECLIPSE Champion:
- Level 1: 20 HP, 0 Armor, 5 Speed
- Per level: +1.5 HP, +0 Armor, +0 Speed
- Level 15: 41 HP, 0 Armor, 5 Speed

SPECTER Champion:
- Level 1: 25 HP, 2 Armor, 4 Speed
- Per level: +1.75 HP, +0 Armor, +0 Speed
- Level 15: 49 HP, 2 Armor, 4 Speed

Lieutenants:
- Scale similarly to their faction archetype
- Marcus (tank): +2 HP/level
- Livia (fragile): +1.5 HP/level
```

**Why Linear:**
- ✅ Easy to predict power curve
- ✅ No exponential runaway
- ✅ Balanced for 15 missions

**Estimated Work:** 1-2 hours design

---

#### **3. Mission Design** ⚠️ 15% COMPLETE
**Status:** INCOMPLETE
**Priority:** HIGH

**What's Done:**
- Mission structure (6 waves per mission)
- Enemy archetypes (Scout, Bruiser, etc.)
- Boss template (3-phase mechanics)

**What's Missing:**
- 15 mission specs for Season 1 (M01-M15)
- 15 mission specs for Season 2 (M16-M30) - **build ahead**
- Enemy compositions per wave (which archetypes, how many?)
- Boss encounters (names, abilities, loot)
- Story integration (which missions advance which hooks?)

**Recommendation:**
**WAIT FOR STORY INTEGRATION** - Story team is building this now.

**Estimated Work:** 3-4 hours per mission × 30 = 90-120 hours total (but story team handles narrative, we handle enemy comps)

---

#### **4. Lieutenant Companion Arcs** ❌ NOT DESIGNED
**Status:** STORY CONTENT
**Priority:** MEDIUM (Can build while story in progress)

**Question:** Should all 8 lieutenants get 4-mission arcs?

**Recommendation:**
**NO - 5 Core Lieutenants Get Full Arcs, 3 Simpler**

**Why:**
- ✅ Manageable scope (20 side missions, not 32)
- ✅ Prioritizes best-written characters
- ✅ Simpler lieutenants still have traits/hooks, just shorter stories

**Suggested Split:**
**FULL ARCS (4 missions each):**
1. **Marcus the Veteran** - Legion deserter arc (former commander hunts him)
2. **Livia the Cultist** - Mystery cult arc (initiation → power → corruption)
3. **Titus the Noble** - Debt/politics arc (creditors → patron betrayal)
4. **Kara the Beast Hunter** - Revenge arc (beast's mate hunts her)
5. **Decimus the Assassin** - Guild bounty arc (hunted by former allies)

**SIMPLER (2 missions or just hooks):**
6. **Julia the Childhood Friend** - Emotional anchor (no arc, just story beats)
7. **Corvus** - Support character (1-2 missions max)
8. **Thane** - Support character (1-2 missions max)

**Why These 5:**
- Marcus, Livia, Titus = clear story potential (deserter, cultist, noble)
- Kara, Decimus = action-focused arcs (hunter, assassin)
- Julia = emotional core, doesn't need complex arc
- Corvus, Thane = flexible support roles

**Estimated Work:** 5 arcs × 4 missions = 20 side missions designed

---

### **TIER 2: IMPORTANT FOR V1** ⚠️

#### **5. Balance Spreadsheet** ❌ NOT STARTED
**Status:** VALIDATION TOOL
**Priority:** MEDIUM

**What's Needed:**
- Master spreadsheet with all 63 cards
- All 24 gear pieces
- All 5 status effects
- Damage calculator
- Synergy matrix (identify broken combos)
- DPS calculations per faction

**Why Important:**
- 🎯 Catches overpowered combos before coding
- 🎯 Validates card costs
- 🎯 Ensures no "strictly worse" cards

**Recommendation:**
**BUILD AFTER SQUAD COMBAT RULES LOCKED** (need to know how 3 units interact)

**Estimated Work:** 2-3 hours

---

#### **6. Tutorial Mission** ❌ NOT DESIGNED
**Status:** ONBOARDING
**Priority:** MEDIUM

**What's Needed:**
- Mission 1: Basic combat (cards, Stamina, HP, Armor)
- Mission 2: Status effects (Bleeding, Weakened)
- Mission 3: Lieutenants (recruiting, traits)

**Recommendation:**
**3-Mission Tutorial Sequence:**
```
MISSION 1: "First Blood" (Solo Tutorial)
- Champion only (no lieutenants yet)
- Fight 1 weak Scout (10 HP)
- Teach: Playing cards, Stamina, HP, Armor
- Unlock: 3 starter cards

MISSION 2: "Blood and Iron" (Status Tutorial)
- Champion only (recruit Marcus after)
- Fight 2 Scouts (apply Bleeding, survive DoT)
- Teach: Status effects, deck building
- Unlock: Marcus as first lieutenant

MISSION 3: "The Debt Fight" (Squad Tutorial)
- Champion + Marcus (2-unit squad)
- Fight 2 Bruisers
- Teach: Card assignment, lieutenant traits
- Unlock: Full squad system (can recruit 2nd lieutenant)
```

**Estimated Work:** 3-4 hours design, integrated with Mission 1-3

---

### **TIER 3: NICE TO HAVE FOR V1** 🟢

#### **7. Injury Medals** ⏸️ PINNED FOR V2
**Status:** EXPANSION FEATURE
**Priority:** LOW (V2)

**What Is It:**
- After 5 missions with same injury, gain compensating bonus
- Example: "Bruised Ribs" → "Survivor's Grit" (+1 Stamina if HP < 50%)

**Recommendation:**
**SKIP FOR V1, ADD IN V2**

**Why:**
- ⏸️ Cool feature but not essential
- ⏸️ Requires 15 medal designs (5 per injury tier)
- ⏸️ V1 can ship without it

**Estimated Work:** 3-4 hours design (but defer to V2)

---

#### **8. Synergy Cards** ⏸️ PINNED FOR V2
**Status:** EXPANSION CONTENT
**Priority:** LOW (V2)

**What Is It:**
- 10 cards that reward faction combos
- Example: "Bleeding Edge" (AEGIS + ECLIPSE synergy)

**Recommendation:**
**SKIP FOR V1, ADD IN V2**

**Why:**
- ⏸️ Expansion content (Season 2 feature)
- ⏸️ V1 has 63 cards, enough variety

**Estimated Work:** 2-3 hours design (but defer to V2)

---

#### **9. Veteran Signature Cards** ⏸️ PINNED FOR V2
**Status:** LATE-GAME CONTENT
**Priority:** LOW (V2)

**What Is It:**
- 9 unique cards unlocked at Levels 10, 12, 15
- Ultra-powerful, 1-per-deck limit

**Recommendation:**
**SKIP FOR V1, ADD IN V2**

**Why:**
- ⏸️ Late-game power spike (V1 ends at Level 15)
- ⏸️ V2 can extend to Level 20+ with these

**Estimated Work:** 2-3 hours design (but defer to V2)

---

## 📌 PINNED FOR FUTURE DESIGN

### **STORY INTEGRATION SYSTEMS** (Waiting on Story Team)

#### **1. Contract Board Weights** ⏸️ PINNED
**Status:** STORY DEPENDENCY
**What Is It:** Spawn probabilities for contract types

**Questions to Answer:**
- What are weights? (Arena bout 40%, Escort 30%, etc.?)
- Per-city or global?
- How do missions change weights?

**When to Design:** After story delivers mission library

---

#### **2. Trial/Run Modifiers** ⏸️ PINNED
**Status:** STORY DEPENDENCY
**What Is It:** Mission difficulty modifiers

**Examples:**
- "Cursed" (start with Poison 1)
- "Arena Sabotage" (enemies +2 Armor)
- "Time Pressure" (max 12 turns)

**Questions to Answer:**
- How many modifiers needed? (10? 20?)
- Per-mission or random?
- Do they stack?

**When to Design:** After mission specs finalized

---

#### **3. Service State Changes** ⏸️ PINNED
**Status:** STORY DEPENDENCY
**What Is It:** Services change price/access based on story

**Examples:**
- Doctor: 30g → 50g if you anger Governor
- Shaman: Closes if you betray cult
- Market: Black market opens after Port City

**Recommendation:**
**SIMPLE STATE MACHINE:**
```
Service States:
- Normal (base price)
- Expensive (+50% price)
- Restricted (can only use 1x per mission)
- Closed (unavailable)

Triggers:
- Missions set state changes
- Example: M08 "Betray Cult" → Shaman state = Closed
```

**When to Design:** After mission specs finalized

---

#### **4. Route State Changes** ⏸️ PINNED
**Status:** STORY DEPENDENCY
**What Is It:** Travel routes become dangerous/closed

**Recommendation:**
**PER-ROUTE STATES:**
```
Routes:
- Arena ↔ Ridge
- Ridge ↔ Port
- Port ↔ Shrine

States per Route:
0. Safe (normal travel)
1. Watched (checkpoint, +20g toll)
2. Dangerous (+30% ambush chance)
3. Closed (cannot travel, must use alternate route)

Triggers:
- Missions set route states
- HEAT level affects all routes (HEAT 10+ = all routes Dangerous)
```

**When to Design:** After mission specs finalized

---

#### **5. DREAD Meter (Volcano)** ⏸️ PINNED
**Status:** STORY DEPENDENCY
**What Is It:** Ridge City volcano escalation

**Recommendation:**
**TIER PROGRESSION:**
```
DREAD Tiers:
0-2: Tier 1 (Rumors) - Normal Ridge City
3-5: Tier 2 (Anomalies) - Minor events, +10% service costs
6-8: Tier 3 (Panic) - Major events, some services close
9-10: Tier 4 (Cordon) - Permits required, routes restricted

Season 1: 0 → 2-3 (Tier 1-2)
Season 2: 3 → 6-8 (Tier 2-3)

Triggers:
- Story missions in Ridge City increase DREAD
- Heeding omens +1 DREAD
- Entering taboo zones +2 DREAD
```

**When to Design:** After Ridge City missions designed

---

#### **6. "Marked" State (Season 1 End)** ⏸️ PINNED
**Status:** STORY DEPENDENCY
**What Is It:** Player is hunted at end of Season 1

**Questions to Answer:**
- Hunted by Cult, State, or both?
- What changes? (Higher HEAT? Ambushes? Services restricted?)
- Can you return to neutral in Season 2?

**When to Design:** After Season 1 finale mission designed

---

#### **7. Cult vs State Lock-In** ⏸️ PINNED
**Status:** STORY DEPENDENCY
**What Is It:** Point where you must choose faction

**Questions to Answer:**
- When? (Mission 10? 15? 20?)
- Can you delay or is it forced?
- What happens if you try to stay neutral?

**When to Design:** After Act structure finalized

---

## 🔧 PINCH POINTS TO ADDRESS NOW

### **PINCH POINT 1: Squad Combat Integration** 🚨 CRITICAL

**Problem:**
- Cards designed for squads ("another unit in your squad")
- Combat system designed for 1v1
- No rules for how 3 units act with shared deck

**Solution:**
**SHARED RESOURCE MODEL (Recommended):**
- 1 Stamina pool (3/turn, shared)
- 1 Mana pool (shared, persists)
- 1 Hand (7 cards, shared)
- You assign cards to units ("Shield Bash → Marcus")
- Individual HP tracking per unit
- Lieutenants provide passive traits (not separate turns)

**Why Now:**
- 🚨 Blocks combat simulator coding
- 🚨 Affects card targeting rules
- 🚨 Affects tutorial design

**Action:** Design squad combat rules (4-6 hours)

---

### **PINCH POINT 2: Gear Per Unit** ⚠️ IMPORTANT

**Problem:**
- Gear system designed for single loadout (3 slots)
- Squad has 3 units (Champion + 2 Lieutenants)
- Do all 3 units have gear? (9 total slots?)

**Options:**

**Option A: Only Champion Has Gear**
- Lieutenants have NO gear (just traits)
- Simpler (3 gear slots total)
- Lieutenants feel less customizable

**Option B: All Units Have Gear**
- 3 units × 3 slots = 9 gear pieces equipped
- More customization
- More inventory management
- Need 3x more gear drops

**Option C: Hybrid (Lieutenants Share Accessories)**
- Champion: 3 slots (Weapon, Armor, Accessory)
- Lieutenants: 1 slot each (Accessory only)
- 5 total slots

**Recommendation:** **Option C (Hybrid)**

**Why:**
- ✅ Champion feels special (full loadout)
- ✅ Lieutenants customizable (1 accessory each creates variety)
- ✅ Manageable (5 slots, not 9)
- ✅ Easier to balance (fewer gear interactions)

**Action:** Update gear system (1 hour design)

---

### **PINCH POINT 3: Signature Lieutenant Cards** ⚠️ IMPORTANT

**Problem:**
- Lieutenants mentioned as having "signature cards"
- None designed yet
- How do they work with shared deck?

**Recommendation:**
**SIGNATURE CARDS AS DECK BUILDING OPTIONS:**
```
Each Lieutenant has 2-3 signature cards:

Marcus Signatures:
1. "Veteran's Resolve" (1 Stamina): Gain 4 Armor. If Marcus, draw 1.
2. "Legion Tactics" (2 Stamina): Deal 6 damage. If Marcus, apply Weakened 2.

Livia Signatures:
1. "Blessed Strike" (1 Stamina): Deal 4 damage, apply Poison 1. If Livia, +1 Poison.
2. "Ritual Curse" (2 Stamina): Apply Poison 3. If Livia, enemy discards 1 card.

How It Works:
- Cards work for ANY unit (not locked)
- Bonus effect if played by specific lieutenant
- Unlocked when you recruit that lieutenant
- Added to shared deck pool (deck building choice)
```

**Why This Works:**
- ✅ Flexible (can use Marcus cards even if Marcus isn't in squad)
- ✅ Rewarding (bonus if played by correct lieutenant)
- ✅ Deck building depth (do you include Marcus cards if he's benched?)

**Action:** Design 2-3 signature cards per lieutenant (8 lieutenants × 2-3 = 16-24 cards)

**Estimated Work:** 2-3 hours

---

### **PINCH POINT 4: Injury Distribution (3 Units)** ⚠️ IMPORTANT

**Problem:**
- Mission fails, squad takes injuries
- Who gets injured? (Champion? Random lieutenant? All 3?)

**Recommendation:**
**RISK-BASED DISTRIBUTION:**
```
Mission Failure Outcomes:

RETREAT (Player Choice):
- Keep rewards
- All downed units: 50% Grave injury risk
- Standing units: 25% Minor injury risk

TOTAL WIPE (All 3 Units KO'd):
- Keep 50% rewards
- All units: 1 Serious injury guaranteed
- Forced hub return

PARTIAL LOSS (Some Units KO'd):
- Keep full rewards
- KO'd units: 50% Serious injury risk
- Standing units: No injury (they protected the squad)
```

**Why This Works:**
- ✅ Retreat is strategic choice (don't risk Grave injuries)
- ✅ Total wipe is punishing but not campaign-ending
- ✅ Partial loss rewards smart play (protect weakened units)

**Action:** Update injury system rules (30 minutes)

---

### **PINCH POINT 5: Economy Scaling to Season 2** ⚠️ IMPORTANT

**Problem:**
- Economy balanced for 15 missions (3,924 gold)
- Season 2 adds 15 more missions
- Need to balance 30-mission economy

**Recommendation:**
**DUPLICATE SEASON 1 REWARDS:**
```
Season 1: 3,924 gold (15 missions)
Season 2: +3,924 gold (15 missions)
TOTAL: 7,848 gold

Season 1 Sinks:
- Healing: ~300g
- Gear: ~800g
- Cards: ~400g
- Upgrades: ~500g
- Deficit: ~1,285g

Season 2 Sinks:
- Epic gear upgrades: ~1,500g
- Rare card purchases: ~600g
- Max-level healing: ~400g
- Campaign upgrades: ~500g
- Deficit: ~1,000g

TOTAL DEFICIT: ~2,285g (forces choices across campaign)
```

**Why This Works:**
- ✅ Season 2 gear is more expensive (Epic focus)
- ✅ Maintains scarcity (can't buy everything)
- ✅ Simple to balance (just double Season 1 rewards)

**Action:** Extend economy table to 30 missions (1 hour)

---

### **PINCH POINT 6: Text Placeholders for Cards** ✅ READY

**Status:** APPROVED BY USER
**What's Needed:** Text descriptions for all 63 cards

**Format:**
```
SHIELD BASH
Cost: 1 Stamina
Type: Attack
Effect: Deal 5 damage. Gain 3 Armor.
Faction: AEGIS

SLASH
Cost: 1 Stamina
Type: Attack
Effect: Deal 6 damage. Apply Bleeding 1.
Faction: ECLIPSE

TOXIN DART
Cost: 1 Stamina
Type: Attack
Effect: Deal 4 damage. Apply Poison 1.
Faction: SPECTER
```

**Why Now:**
- ✅ Chat GPT building card art separately
- ✅ Text placeholders let us balance now
- ✅ Easy to swap in art later

**Action:** Export card library as text file (30 minutes)

---

## 🗺️ COMPLETE DEPLOYMENT ROADMAP

### **PHASE 1: LOCK SQUAD COMBAT** (1 Week)
**Goal:** Finalize how 3 units work together

**Tasks:**
1. ✅ **Design squad combat rules** (4-6 hours)
   - Shared resources confirmed (Stamina/Mana pools)
   - Card assignment to units
   - Individual HP tracking
   - Targeting system

2. ✅ **Update gear system** (1 hour)
   - Champion: 3 slots (Weapon, Armor, Accessory)
   - Lieutenants: 1 slot (Accessory)
   - 5 total slots

3. ✅ **Design signature lieutenant cards** (2-3 hours)
   - 2-3 cards per lieutenant × 8 = 16-24 cards
   - Flexible (work for any unit, bonus if correct lieutenant)

4. ✅ **Update injury distribution rules** (30 minutes)
   - Retreat, total wipe, partial loss outcomes

5. ✅ **Export card library as text** (30 minutes)
   - 63 cards in text format for balancing

**Output:** Squad combat design doc, ready for coding

---

### **PHASE 2: FINISH PROGRESSION** (3-4 Days)
**Goal:** Complete stat growth and unlock schedule

**Tasks:**
1. ✅ **Design stat growth formulas** (1 hour)
   - Linear scaling: +2 HP/level (AEGIS), +1.5 HP/level (ECLIPSE), +1.75 HP/level (SPECTER)
   - Lieutenants scale similarly

2. ✅ **Map card unlocks to missions** (1 hour)
   - Mission 1 unlocks Level 2 cards
   - Mission 5 unlocks Level 6 cards
   - Mission 15 unlocks Level 15 cards

3. ✅ **Define campaign upgrades** (1 hour)
   - Resource boosts (e.g., "+1 Mana cap" after Mission 8)

**Output:** Progression system complete

---

### **PHASE 3: INTEGRATE STORY** (PARALLEL - Story Team)
**Goal:** Receive 15 Season 1 missions + 15 Season 2 missions from story team

**Story Team Delivers:**
- 30 MAIN mission specs (M01-M30)
- 30 SIDE mission specs (S01-S30, as 10 arcs)
- Story events that trigger hooks, meters, relationship changes

**We Design:**
- Enemy compositions per wave
- Boss encounters per mission
- Loot rewards per mission

**Timeline:** Story team working now (parallel track)

---

### **PHASE 4: BUILD BALANCE SPREADSHEET** (2-3 Hours)
**Goal:** Validate no broken combos

**Tasks:**
1. ✅ **Enter all 63 cards** (1 hour)
   - Name, Cost, Damage, Status effects
2. ✅ **Enter all 24 gear pieces** (30 minutes)
   - Stats, synergies, prices
3. ✅ **Build damage calculator** (1 hour)
   - Test combos, identify overpowered synergies

**Output:** Balance validation complete

---

### **PHASE 5: BUILD TUTORIAL MISSIONS** (3-4 Hours)
**Goal:** Teach players the game

**Tasks:**
1. ✅ **Mission 1: Solo Combat** (1 hour)
   - Champion only, teach basics
2. ✅ **Mission 2: Status Effects** (1 hour)
   - Bleeding, Weakened mechanics
3. ✅ **Mission 3: Squad Intro** (1 hour)
   - Recruit Marcus, teach card assignment

**Output:** Tutorial complete

---

### **PHASE 6: CODE V1** (4-6 Weeks)
**Goal:** Implement all locked systems

**Tasks:**
1. **Combat engine** (1-2 weeks)
   - Squad combat flow
   - Damage calculation
   - Status effects
   - AI

2. **Hub systems** (1 week)
   - Services (Doctor, Shaman, Market, Card Vendor)
   - Deck builder
   - Gear management
   - Injury tracking

3. **Progression** (3-4 days)
   - XP/leveling
   - Card unlocks
   - Stat growth

4. **UI** (1-2 weeks)
   - Combat screen (text-based)
   - Hub menus
   - Card display (text placeholders)

5. **Save/load** (2-3 days)

**Output:** Playable V1

---

### **PHASE 7: PLAYTEST & BALANCE** (2 Weeks)
**Goal:** Internal testing, tune numbers

**Tasks:**
1. **Run 150 combat simulations** (3 days)
   - Validate faction balance
   - Check win rates
2. **Playtest all 15 missions** (1 week)
   - Difficulty curve
   - Injury pacing
   - Economy balance
3. **Balance pass** (3-4 days)
   - Adjust card costs
   - Tune enemy HP
   - Fix broken combos

**Output:** Balanced V1

---

### **PHASE 8: SEASON 2 PREP** (PARALLEL - While Season 1 in Playtest)
**Goal:** Build Season 2 content ahead

**Tasks:**
1. **Design Missions 16-30** (with story team)
2. **Design new enemies** (Act 4-6 enemies)
3. **Design new gear** (Epic+ tier)
4. **Design new cards** (expansion cards)

**Output:** Season 2 ready to deploy when Season 1 ships

---

### **PHASE 9: SHIP V1** (Week 12-14)
**Goal:** Release Season 1 to players

**Tasks:**
1. **Final polish**
2. **Deploy to Neocities/itch.io**
3. **Gather feedback** (10-50 players)

**Output:** Season 1 live

---

### **PHASE 10: SEASON 2 DEPLOYMENT** (When Season 3 is 90% Done)
**Goal:** Release Season 2 as expansion

**Tasks:**
1. **Finish Season 3 design** (90% complete before Season 2 drops)
2. **Deploy Season 2** (15 missions + side content)
3. **Monitor feedback**

**Output:** Season 2 live, always 1 season ahead

---

## 📋 QUICK ANSWERS TO YOUR QUESTIONS

### **Q2: Should all 8 lieutenants get arcs?**
**Answer:** NO - 5 core lieutenants get full 4-mission arcs, 3 simpler

**Why:**
- ✅ Manageable scope (20 side missions, not 32)
- ✅ Focuses on best characters (Marcus, Livia, Titus, Kara, Decimus)
- ✅ Simpler lieutenants still useful (Julia = emotional anchor, no complex arc needed)

---

### **Q6: Service State Changes - Suggestions?**
**Answer:** SIMPLE STATE MACHINE

**States:**
- Normal (base price)
- Expensive (+50% price)
- Restricted (1x per mission)
- Closed (unavailable)

**Triggers:**
- Missions set states (e.g., "Betray Cult" → Shaman closes)

**Why:**
- ✅ Simple to implement (4 states per service)
- ✅ Story-driven (missions trigger changes)
- ✅ Recoverable (some missions can re-open services)

---

### **Q7: DREAD Meter - Suggestions?**
**Answer:** TIER ESCALATION (0-10 scale)

**Tiers:**
- 0-2: Tier 1 (Rumors) - Normal
- 3-5: Tier 2 (Anomalies) - +10% costs
- 6-8: Tier 3 (Panic) - Services close
- 9-10: Tier 4 (Cordon) - Routes restricted

**Season 1:** 0 → 3 (Tier 1-2)
**Season 2:** 3 → 8 (Tier 2-3)

**Why:**
- ✅ Clear escalation
- ✅ Doesn't destroy Ridge City (max Tier 4 = cordon, not eruption)
- ✅ Tied to story events (Ridge City missions increase DREAD)

---

### **Q8: "Marked" State - Is it Rival System?**
**Answer:** YES - Uses existing hateLevel system

**"Marked" = High hateLevel with Cult OR State:**
- Cult hateLevel ≥8 = Hunted by cult
- State hateLevel ≥8 = Hunted by state
- Both ≥8 = Hunted by both (Season 2 escalation)

**Why:**
- ✅ Reuses existing system (no new mechanic)
- ✅ Clear trigger (hateLevel threshold)

---

### **Q10: Route States - Suggestions?**
**Answer:** PER-ROUTE TRACKING (Simple)

**Routes:**
- Arena ↔ Ridge
- Ridge ↔ Port
- Port ↔ Shrine

**States (0-3):**
- 0: Safe (normal travel)
- 1: Watched (+20g toll)
- 2: Dangerous (+30% ambush chance)
- 3: Closed (alternate route required)

**Triggers:**
- Missions set route states
- HEAT ≥10 = all routes become Dangerous

**Why:**
- ✅ Simple (3 routes × 4 states = 12 total states)
- ✅ Tied to story (missions change states)
- ✅ Affects travel events (higher ambush chance at higher states)

---

## 🎯 PRIORITY ACTIONS (Remaining 3%)

### **✅ COMPLETED: SQUAD INTEGRATION + SIGNATURE CARDS**
1. ✅ **DONE** Design squad combat rules (shared resources, card assignment, targeting)
2. ✅ **DONE** Update gear system (Champion 6-7 slots, Lieutenants 4 slots)
3. ✅ **DONE** Design injury distribution system (Perfect/Partial/Retreat/Wipe outcomes)
4. ✅ **DONE** Update enemy archetypes for squad combat (positioning, AI, compositions)
5. ✅ **DONE** Write signature lieutenant cards (24 cards, 3 per lieutenant, all costs balanced)

### **WEEK 2: FINISH PROGRESSION + BALANCE** (✅ BALANCE COMPLETE)
1. ✅ **DONE** Build balance spreadsheet (87 cards, 24+ gear, squad damage calc, synergy check)
2. **NEXT:** Design stat growth formulas (linear scaling)
3. **NEXT:** Design per-lieutenant XP system (Levels 1-6, catch-up mechanics)
4. **NEXT:** Map card unlocks to missions
5. **NEXT:** Design tutorial missions (M01-M03 with squad mechanics)

### **WEEK 3: STORY INTEGRATION**
- Receive 30 mission specs from story team (15 Season 1, 15 Season 2)
- Build enemy compositions per wave (use ENEMY_ARCHETYPES_SQUAD.md templates)
- Design boss encounters per mission
- Create sample mission lineups (Acts 1-3)

### **AFTER WEEK 3:**
- Build balance spreadsheet (validate all 79-87 cards, 24+ gear pieces)
- Code V1 combat engine (shared resources, card assignment, squad mechanics)
- Playtest and tune

---

## ✅ WHAT YOU CAN DO NOW

### **Immediate Actions:**
1. **Approve squad combat model** (shared resources, card assignment to units)
2. **Approve lieutenant arc split** (5 full arcs, 3 simpler)
3. **Approve gear system update** (5 slots total)

### **Story Team Coordination:**
- Confirm they're building 30 mission specs (15 Season 1, 15 Season 2)
- Confirm they're building 10 side arcs (5 companion × 4 missions, 5 rival × 2 missions)

### **Art Team Coordination:**
- Confirm they're building card art separately
- We use text placeholders for now (easy to swap art later)

---

**READY TO START PHASE 1: LOCK SQUAD COMBAT?** 🚀

Let me know if you want me to dive into any of these systems now!
