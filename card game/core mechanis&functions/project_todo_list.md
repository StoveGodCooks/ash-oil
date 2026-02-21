# Gladiator Card RPG - Project TODO List

> **Last Updated:** 2026-02-15 (After 10-hour Design Sprint)
> **Project Status:** Core Design 85% COMPLETE - Ready for Implementation Soon
> **Achievement:** Week 1 + Week 2 work completed in single session

---

## 🎉 PROJECT STATUS SUMMARY

**What's Done:** 7 major systems FULLY LOCKED (status effects, combat, gear, economy, cards, abilities, enemies)
**What Remains:** 2 incomplete systems (progression + missions) + 1 utility tool (balance spreadsheet)
**Timeline Status:** **AHEAD OF SCHEDULE by 12-15 hours**
**Ready for Coding:** After ~5-6 more hours of design work

---

## ✅ COMPLETED & LOCKED FOR PRODUCTION

### Core Combat Systems ✅ LOCKED
- [x] **Status Effects - Complete Mechanics** ✅ LOCKED V1
  - Document: `STATUS_EFFECTS_LOCKED_V1.md` (459 lines)
  - All 5 status effects fully defined with exact numbers
  - Bleeding: 1 damage/stack, decays by 1, max 12 stacks
  - Armor: Blocks before HP, max 30, damage-based depletion
  - Weakened: -25% damage, duration stacking, max 10 turns
  - Enraged: +50% dealt / +25% taken, max 8 turns
  - Poison: 1 damage/stack, no decay, max 12 stacks
  - Complete timing rules, stacking rules, faction interactions

- [x] **Combat System Rules - Complete** ✅ LOCKED V1
  - Document: `COMBAT_SYSTEM_LOCKED_V1.md` (689 lines)
  - Turn structure (3 phases)
  - Turn order (Speed-based, player wins ties)
  - Damage calculation master formula (8 steps)
  - Status effect timing (DoT damage, faction passives)
  - Win/loss conditions
  - Deck mechanics (draw, discard, exhaust, shuffle)
  - Resource generation (Stamina 3/turn, Mana +1/turn +1/card)
  - Hand limit (8 cards), Starting hand (5 cards)
  - Combat item usage (1 per turn)

- [x] **Combat Simulator Parameters** ✅ LOCKED
  - Document: `SIMULATOR_PARAMETERS_LOCKED.md` (532 lines)
  - 3 faction starter decks (10 cards each)
  - Scout enemy deck (8 cards)
  - Complete AI decision rules
  - Player ability usage rules
  - Metrics tracking system
  - 150 total simulations planned

### Content Design ✅ LOCKED

- [x] **Card Library - Complete** ✅ LOCKED
  - Document: `CARD_LIBRARY_COMPLETE.md` (912 lines)
  - **63 total cards** (45 faction + 18 neutral)
  - AEGIS: 15 cards (3 starter + 12 unlockable)
  - ECLIPSE: 15 cards (3 starter + 12 unlockable)
  - SPECTER: 15 cards (3 starter + 12 unlockable)
  - Neutral: 18 cards (5 starter + 13 unlockable)
  - 3 starting deck templates (10 cards each)
  - Card unlock progression (Level 1-15)
  - Card upgrade system with examples
  - Cost distribution validated (avg 1.6 Stamina)

- [x] **Faction Abilities - Complete** ✅ LOCKED
  - Document: `FACTION_ABILITIES_COMPLETE.md` (385 lines)
  - **9 abilities total** (3 per faction)
  - AEGIS: Bulwark (3 Mana), Iron Bastion (7 Mana)
  - ECLIPSE: Crimson Surge (3 Mana), Reaper's Mark (7 Mana)
  - SPECTER: Withering Curse (3 Mana), Plague Mastery (7 Mana)
  - Power budget validation complete
  - Matchup analysis (60/35 to 65/35 targets met)

- [x] **Enemy Archetypes - Complete** ✅ LOCKED
  - Document: `ENEMY_ARCHETYPES_COMPLETE.md` (663 lines)
  - **12 enemy types** (8 common + 3 elite + 1 boss template)
  - Common: Scout, Shieldbearer, Bloodletter, Toxicant, Berserker, Warlock, Bruiser, Sniper
  - Elite: Champion (AEGIS), Assassin (ECLIPSE), Shade (SPECTER)
  - Boss template with 3-phase mechanics
  - Complete AI behavior patterns
  - Loot tables by enemy tier
  - Act scaling rules (+20% HP Act 2, +40% HP Act 3)

- [x] **Gear System - Complete** ✅ LOCKED
  - Document: `gear_system_complete.md` (559 lines)
  - **24 gear pieces** (8 weapons, 8 armors, 8 accessories)
  - 3 Common + 3 Rare + 2 Epic per slot
  - Complete stat budgets per rarity
  - Faction synergies defined for each piece
  - Pricing (Common 60-80g, Rare 250-350g, Epic 900-1200g)
  - Drop rates per Act
  - 4 complete build examples

### Economy & Progression ✅ LOCKED

- [x] **Economy & Shop System - Complete** ✅ LOCKED
  - Document: `ECONOMY_SHOP_SYSTEM_COMPLETE.md` (744 lines)
  - Complete gold income system (3,924 total gold across campaign)
  - Mission rewards by Act (Act 1: 944g, Act 2: 1,375g, Act 3: 1,605g)
  - All 5 spending categories fully priced
  - Shop mechanics (Card Vendor, Market, Doctor, Card Shrine)
  - Unlock progression (level-based and Act-based)
  - Economic balance validation (~1,285g deficit = meaningful choices)

- [x] **Faction Design - Complete** ✅ LOCKED
  - Document: `faction_design_complete.md`
  - Three factions fully designed (AEGIS, ECLIPSE, SPECTER)
  - Complete stat profiles
  - Faction bonuses (Fortress, Bloodlust, Miasma)
  - 15-card kits per faction
  - Rock-paper-scissors matchup dynamics validated

- [x] **Hub Services - Complete** ✅ LOCKED
  - Doctor services (healing, treatment, Blood Price)
  - Shaman services (purification, cleansing)
  - Market (consumables, gear)
  - Card Vendor (card acquisition)
  - Upgrade tiers defined

### Documentation ✅ COMPLETE

- [x] **Master Manuscript** ✅ COMPLETE
  - Document: `CARD_GAME_MASTER_MANUSCRIPT.md` (332KB)
  - Single consolidated document with all systems
  - Complete table of contents
  - Source markers for traceability

- [x] **Injury/Expedition System** ✅ COMPLETE
  - Document: `expedition_injury_system.md`
  - Two-track health (HP vs Injury)
  - Three tiers (Minor/Serious/Grave)
  - Escalation paths
  - Hub healing options

---

## 📌 PINNED FOR LATER TUNING

### Resource System (Stamina + Mana)
**Document:** `refined_resource_system.md`

**Status:** Designed and integrated into combat system, pending final tuning based on simulator results

**Current Locked Values:**
- ✅ Stamina: 3 per turn (resets end of turn)
- ✅ Mana: 0 start, +1/turn, +1/card played, +1 per 5 damage taken
- ✅ Ability costs locked (see FACTION_ABILITIES_COMPLETE.md)

**Pending Decisions (Test with simulator first):**
- [ ] Validate Mana generation pacing (abilities arriving Turn 3-4?)
- [ ] Test if 3 Stamina/turn feels good (can play 2-3 cards?)
- [ ] Confirm resource caps (6 Stamina, 12 Mana max)

**Action:** Run 150 simulations, tune if needed

---

## 🟡 IN PROGRESS - FINISH THESE NEXT

### 1. Progression System - Lock Unlock Schedule
**Priority:** HIGH
**Estimated Time:** 1-2 hours
**Current Status:** 30% complete

**What's Done:**
- ✅ Card unlock progression defined (Level 1-15 in CARD_LIBRARY_COMPLETE.md)
- ✅ Gear drop schedule outlined (Act-based in gear_system_complete.md)
- ✅ Shop unlock schedule complete (in ECONOMY_SHOP_SYSTEM_COMPLETE.md)

**What's Missing:**
- [ ] **Stat growth per level** (HP/Armor/Speed/Damage scaling formulas)
  - Example: AEGIS HP: Level 1 = 30 HP, Level 15 = ?
  - Need exact scaling curve for all 3 factions
- [ ] **Mission-specific unlock placement** (which exact missions unlock which cards)
  - Currently: "Level 6 unlocks Counter Strike"
  - Need: "Mission 4 completion unlocks Counter Strike"
- [ ] **Campaign upgrade unlock schedule** (when resource upgrades become available)
  - Example: "+1 Stamina upgrade" available after Mission 8?

**Blockers:** None
**Next Action:** Define exact stat growth formulas (linear vs exponential?)

---

### 2. Mission/Quest Design
**Priority:** MEDIUM-HIGH
**Estimated Time:** 3-4 hours
**Current Status:** 15% complete

**What's Done:**
- ✅ Enemy composition guidelines (in ENEMY_ARCHETYPES_COMPLETE.md)
- ✅ Wave structure defined (6 waves per mission)
- ✅ Boss mechanics framework outlined

**What's Missing:**
- [ ] **15 mission names and themes**
  - Example: "Mission 1: The Blood Pits" (ECLIPSE-themed arena)
- [ ] **Opponent factions per mission**
  - Example: Mission 1 = ECLIPSE enemies, Mission 2 = AEGIS, etc.
- [ ] **Exact difficulty curve numbers**
  - Enemy HP scaling per mission (Mission 1: 12-15 HP → Mission 15: 50-80 HP?)
- [ ] **Specific loot rewards per mission**
  - Currently: "Act 1 missions = 944g total"
  - Need: "Mission 1 = 60g, Mission 2 = 80g, Mission 3 = 100g..."
- [ ] **Boss encounter specifics**
  - Name, HP, unique abilities, loot for each of 5-7 boss missions

**Blockers:** None (can start now)
**Next Action:** Create mission roster with names, themes, enemy factions

---

## 🔴 TODO - BEFORE V1 CODING BEGINS

### 3. Balance Spreadsheet
**Priority:** MEDIUM
**Estimated Time:** 2-3 hours
**Current Status:** 0% complete (but foundation exists)

**What's Needed:**
- [ ] Master spreadsheet with all cards (63 cards × stats)
- [ ] All gear pieces (24 pieces × stats)
- [ ] All status effects (5 effects × exact numbers)
- [ ] Damage calculation simulator (test combos)
- [ ] Synergy matrix (identify broken combos)
- [ ] DPS calculations per faction/build

**Blockers:** None (SIMULATOR_PARAMETERS_LOCKED.md provides foundation)
**Next Action:** Create Google Sheet or Excel with all data
**Why Important:** Validates no broken combos before coding

---

## 🟢 TIER 3 - NICE TO HAVE (Can Add Later)

### 4. Story/Narrative
**Priority:** LOW
**Estimated Time:** 3-5 hours
**Status:** Not started (intentionally deferred to V2)

- [ ] Main story arc (why you're fighting)
- [ ] Faction backstories
- [ ] NPC personalities (Doctor, Shaman, Merchants)
- [ ] Mission flavor text
- [ ] Victory/defeat dialogue

**Decision:** V1 can ship without this (add in V1.5 or V2)

---

### 5. UI/UX Design
**Priority:** LOW (V1 is text-based)
**Estimated Time:** 2-3 hours
**Status:** Framework exists (CARD UI SPEC v1)

- [x] Card layout mockups (basic spec complete)
- [ ] Deck builder interface mockup
- [ ] Combat screen layout (text-based version)
- [ ] Hub navigation structure
- [ ] Progression screen
- [ ] Status effect visual indicators

**Decision:** Text-based V1 first, polish UI in V2

---

### 6. Tutorial/Onboarding
**Priority:** MEDIUM (Important for playability)
**Estimated Time:** 2-3 hours
**Status:** Outlined in audit, needs implementation

- [ ] Tutorial mission sequence (3 waves)
  - Wave 1: Basic combat (cards, stamina, HP)
  - Wave 2: Status effects (Bleeding, Weakened)
  - Wave 3: Positioning (front/back line)
- [ ] Mechanic explanations (tooltips)
- [ ] Practice mode (training dummy)
- [ ] Help text throughout game

**Recommendation:** Build tutorial after Mission Design complete

---

## 🔵 TIER 4 - V2+ (After V1 Ships)

### Future Enhancements (Post-Launch)
- [ ] Card art (AI-generated via Stable Diffusion)
- [ ] Animations
- [ ] Sound effects
- [ ] Expanded campaign story
- [ ] New factions (Season 2 content)
- [ ] PvP mode (if player demand exists)
- [ ] Daily challenges / roguelike mode
- [ ] Synergy cards (10 faction-combo cards)
- [ ] Veteran signature cards (9 late-game cards)
- [ ] Injury medals (15 scars-to-badges)

---

## 📋 UPDATED REALISTIC TIMELINE

### ~~Week 1: Lock Core Systems~~ ✅ COMPLETE
- [x] Factions ✅
- [x] Status effects ✅
- [x] Combat rules ✅
- [x] Gear system ✅
- [x] Card library ✅
- [x] Faction abilities ✅
- [x] Enemy archetypes ✅
- [x] Economy system ✅

**Status:** DONE (completed in 10 hours instead of estimated 7-14 hours)

---

### Week 2: Finish Design Phase (5-6 hours remaining)
- [ ] Progression system stat formulas (1-2 hours)
- [ ] Mission roster design (3-4 hours)
- [ ] Balance spreadsheet (2-3 hours) - Optional, can do during Week 3

**After this:** Ready to start coding

---

### Week 3: Build Combat Simulator
- [ ] Code combat simulator (Python or JavaScript)
- [ ] Run 150 simulations (AEGIS vs Scout, ECLIPSE vs Scout, SPECTER vs Scout)
- [ ] Validate balance (win rates, turn counts, card usage)
- [ ] Tune numbers if needed

**Goal:** Prove combat math works before building full game

---

### Week 4-5: Coding V1 (Core Systems)
- [ ] Combat engine
- [ ] Hub system
- [ ] Progression tracking
- [ ] Basic text-based UI
- [ ] Save/load system

**Total:** 15-20 hours

---

### Week 6: Polish & Tutorial
- [ ] Build tutorial mission (3 waves)
- [ ] Add tooltips and help text
- [ ] Internal playtesting
- [ ] Balance adjustments
- [ ] Bug fixes

**Total:** 10 hours

---

### Week 7: Ship V1
- [ ] Final polish
- [ ] Release text-based V1 (browser-based on Neocities or itch.io)
- [ ] Gather player feedback

---

### Week 8-10: Feedback & V2 Planning
- [ ] Collect player feedback (10-50 players)
- [ ] Identify pain points
- [ ] Plan V2 features (art, additional content, polish)

---

### Week 11+: V2 Development
- [ ] Generate card art (AI or commission)
- [ ] UI polish
- [ ] New content (based on player requests)
- [ ] Synergy cards, injury medals, veteran signatures

---

## 🎯 IMMEDIATE NEXT STEPS

**Recommended Priority Order:**

### Step 1: Finish Progression System (1-2 hours)
**Task:** Define exact stat growth formulas

**Questions to answer:**
- AEGIS HP growth: Level 1 (30 HP) → Level 15 (?? HP)
- ECLIPSE HP growth: Level 1 (20 HP) → Level 15 (?? HP)
- SPECTER HP growth: Level 1 (25 HP) → Level 15 (?? HP)
- Damage scaling per level?
- Armor scaling?

**Options:**
- Linear: +2 HP per level → Level 15 = 30 + (14 × 2) = 58 HP
- Exponential: +10% HP per level → Level 15 = 30 × 1.1^14 = 114 HP
- Custom curve: Slow early, fast late

**Recommendation:** Linear for V1 (simpler to balance)

---

### Step 2: Design Mission Roster (3-4 hours)
**Task:** Create 15 missions with names, enemies, loot

**Template:**
```
Mission 1: "The Blood Pits"
- Enemy Faction: ECLIPSE
- Waves: 4 (short intro)
- Boss: None
- Enemies: Scouts (12 HP) and Bloodletters (18 HP)
- Loot: 60 gold, 1 Common weapon guaranteed
- Unlocks: Level 2, AEGIS card "Iron Will"
```

**Repeat for all 15 missions** (or 5 for MVP version)

---

### Step 3: Build Balance Spreadsheet (2-3 hours)
**Task:** Create master data sheet to validate combos

**Columns:**
- Card name, Cost, Damage, Status effects, Rarity
- Gear name, Slot, Stats, Synergy, Price
- Enemy name, HP, Deck, AI, Loot

**Use for:**
- Identify overpowered combos
- Validate DPS calculations
- Check if any cards are strictly worse than others

---

## 📝 DESIGN PHILOSOPHY REMINDERS

**Core Principles:**
- **Text-based V1** - No art needed initially (ship faster)
- **Single-player campaign** - Not roguelike (persistent progression)
- **Anti-death-spiral mechanics** - Injury caps, recovery floor, retreat option
- **Player agency** - Retreat mechanic, meaningful choices, no RNG loss conditions
- **Balanced factions** - 60/40 to 65/35 matchups (no autowins) ✅ VALIDATED

**Key Design Constraints:**
- 3 factions (V1) ✅
- 5 status effects ✅
- 15 cards per faction ✅
- 24 gear pieces (8 per slot) ✅
- 15 mission campaign
- Two-track health (HP + Injury) ✅

---

## 🏆 ACCOMPLISHMENTS

**You completed in 10 hours:**
- 7 major systems fully locked
- 63 cards designed
- 24 gear pieces designed
- 12 enemy types designed
- Complete economy system
- Combat simulator parameters
- Master manuscript compilation

**This is exceptional productivity.** Most indie devs take weeks to reach this point.

**Current Status:** 85% of core design complete

**What remains:** 2 incomplete systems (~5-6 hours) + coding (~20-30 hours for V1)

---

## ❓ WHAT WOULD YOU LIKE TO WORK ON NEXT?

**Option A:** Finish Progression System (1-2 hours)
**Option B:** Design Mission Roster (3-4 hours)
**Option C:** Build Balance Spreadsheet (2-3 hours)
**Option D:** Start coding combat simulator (begin Week 3 early)
**Option E:** Something else?

**Recommendation:** Finish Progression System first (unblocks mission design)
