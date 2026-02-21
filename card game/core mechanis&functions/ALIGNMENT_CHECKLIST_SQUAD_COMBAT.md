# ALIGNMENT CHECKLIST - SQUAD COMBAT INTEGRATION

> **Status:** Ready for implementation guidance
> **Date:** 2026-02-20
> **Purpose:** Track what changes each locked system needs for squad combat compatibility

---

## SYSTEM AUDIT RESULTS

### ✅ Systems That Are COMPATIBLE (No Changes Needed)

1. **Combat System (LOCKED V1)** ✅
   - Damage calculation works per-unit (will apply to each unit independently)
   - Status effects per-unit (perfect for squad)
   - No changes needed

2. **Status Effects (LOCKED V1)** ✅
   - Bleeding, Poison, Armor, Weakened, Enraged all track per-unit
   - Perfect for multi-unit combat
   - No changes needed

3. **Factions (LOCKED V1)** ✅
   - Faction passives apply to units with that faction
   - Passives work independently
   - No changes needed

4. **Faction Abilities (LOCKED V1)** ✅
   - Abilities only Champion uses (confirmed in squad doc)
   - No changes needed

---

## SYSTEMS NEEDING UPDATES

---

## 1️⃣ GEAR SYSTEM - NEEDS MAJOR UPDATE

### Current State:
```
3 Slots per unit:
- Weapon (1 slot)
- Armor (1 slot)
- Accessory (1 slot)

24 total pieces (8 weapons, 8 armors, 8 accessories)
Designed for single unit
```

### What Needs to Change:

#### **Option A: Only Champion Has Gear (Simpler)**
```
Active Slots: 3 (Champion only)
- Champion: Weapon, Armor, Accessory
- Lieutenants: NO gear
- Total equipped: 3 pieces

Pro: Simpler, less inventory
Con: Lieutenants feel less customizable
```

#### **Option B: All Units Have Gear (Complex)**
```
Active Slots: 9-12 (Champion 3 + each LT 3)
- Champion: Weapon, Armor, Accessory
- Lt 1: Weapon, Armor, Accessory
- Lt 2: Weapon, Armor, Accessory
- Lt 3: Weapon, Armor, Accessory
- Total equipped: 12 pieces

Pro: Full customization per unit
Con: Huge inventory, balance nightmare, too many gear drops needed
```

#### **RECOMMENDED: Option C: Hybrid (Champion 3 + LTs Accessories)**
```
Active Slots: 5 (Champion 3 + Lieutenants 1 each)
- Champion: Weapon, Armor, Accessory
- Lt 1: Accessory ONLY
- Lt 2: Accessory ONLY
- Lt 3: Accessory ONLY
- Total equipped: 5 pieces

Pro: ✅ Champions feel special (full loadout)
     ✅ Lieutenants customizable (variety via accessories)
     ✅ Manageable inventory (5 slots)
     ✅ Balanced drop rates
     ✅ Cleaner design

Con: Lieutenants don't get Weapons/Armor
```

### Changes Needed:

#### **For Option C (Recommended):**

**Gear System Doc Updates:**
- [ ] Change slot description: "Weapon (Champion only), Armor (Champion only), Accessory (Champion + all Lieutenants)"
- [ ] Clarify Lieutenant accessory equipping: "Each Lieutenant can wear 1 accessory"
- [ ] Update stat budget: Accessories should scale for 4-unit usage (more healing/utility effects)
- [ ] Clarify that Weapons/Armor are Champion-only equips

**Gear Pieces Redesign:**
- [ ] All 8 weapons: Champion-only ✅ (no change)
- [ ] All 8 armors: Champion-only ✅ (no change)
- [ ] All 8 accessories: NOW accessory effects need re-tuning for multi-unit usage
  - Examples needing rewrite:
    - "Draw 1 card at start of combat" (was single unit, now 4 units = potentially 4 draws?)
    - "Heal 2 HP at start of turn" (apply per-unit or squad-wide?)
    - "Gain +1 Damage" (should this apply to unit wearing it, or all units?)

**New Accessory Design Guidance:**
- Unit-specific effects: Apply to the lieutenant wearing it (e.g., "Wearer gains +2 Damage")
- Squad-wide effects: Benefit entire team (e.g., "All units start combat with +1 Armor")
- Hybrid: Some per-unit, some squad-wide (balance with rarity)

**Inventory System:**
- [ ] Cap: 5 pieces equipped (Champion 3, Lieutenants 1 each)
- [ ] Swap: Can change gear at hub before missions
- [ ] When swapping units: New unit inherits their accessory slot (already equipped)

---

## 2️⃣ CARD LIBRARY - NEEDS SIGNATURE CARDS

### Current State:
```
63 total cards:
- 45 faction cards (15 per faction: 3 starter, 12 unlockable)
- 18 neutral cards

No signature cards per lieutenant
Cards don't reference unit assignment
```

### What Needs to Change:

#### **Add Signature Lieutenant Cards:**

Each of 8 Season 1 lieutenants gets 2-3 signature cards (16-24 new cards total):

```
Season 1 Lieutenants (8):
1. Marcus the Veteran (ECLIPSE-aligned)
2. Livia the Cultist (SPECTER-aligned)
3. Titus the Noble (Neutral/AEGIS-aligned)
4. Kara the Beast Hunter (ECLIPSE-aligned)
5. Decimus the Assassin (SPECTER-aligned)
6. Julia the Childhood Friend (Neutral-aligned)
7. Corvus the Smuggler (Neutral/SPECTER-aligned)
8. Thane the Gladiator (Neutral-aligned)

Each Lieutenant: 2-3 signature cards
Total: 16-24 new cards
```

#### **Signature Card Design Template:**

```
VETERAN'S RESOLVE (Marcus Signature)
Cost: 1 Stamina
Type: Skill
Effect: Gain 4 Armor. If played by Marcus, draw 1 card.
Rarity: Common
Unlock: When Marcus is recruited
Faction: Bonus effect (ECLIPSE-themed)

Design Philosophy:
- Works for ANY unit (not locked to Marcus)
- Bonus effect if Marcus uses it ("If played by Marcus...")
- Encourages squad synergy without requiring it
```

#### **Signature Card Rules:**

- **Unlock trigger:** When lieutenant is recruited (or after mission completion)
- **Deck building:** Added to shared deck pool as optional cards
- **Flexibility:** Can be used by ANY unit, but bonus applies if "correct" unit uses it
- **Progression:** Typically 1 Common (recruitment), 1 Rare (Level 3), 1 Epic (Level 6)
- **No forced usage:** Players can include or exclude signature cards (deck building choice)

### Changes Needed:

**Card Library Doc Updates:**
- [ ] Add section: "LIEUTENANT SIGNATURE CARDS (16-24 total)"
- [ ] Design 16-24 signature cards (2-3 per Season 1 lieutenant)
- [ ] Document unlock progression (recruitment vs level-based)
- [ ] Add examples of "unit-specific bonus" mechanic
- [ ] Update total card count: 63 → 79-87 cards

**Signature Card Design Work:**
- [ ] Marcus the Veteran: 2-3 cards (ECLIPSE-themed, veteran tactics)
- [ ] Livia the Cultist: 2-3 cards (SPECTER-themed, cult rituals)
- [ ] Titus the Noble: 2-3 cards (AEGIS/Neutral, political power)
- [ ] Kara the Beast Hunter: 2-3 cards (ECLIPSE, beast hunting)
- [ ] Decimus the Assassin: 2-3 cards (SPECTER, assassination)
- [ ] Julia the Childhood Friend: 2-3 cards (Neutral, emotional support)
- [ ] Corvus the Smuggler: 2-3 cards (Neutral, smuggling/black market)
- [ ] Thane the Gladiator: 2-3 cards (Neutral, arena tactics)

**Update Card Unlock Progression:**
- [ ] Level 1-15 progression now includes signature card unlocks
- [ ] Recruitment triggers unlock timing
- [ ] Example: "Recruit Marcus → Unlock Veteran's Resolve (Common), Legion Tactics (Rare at Level 3), Death Mark (Epic at Level 6)"

---

## 3️⃣ PROGRESSION SYSTEM - NEEDS LIEUTENANT LEVELING

### Current State:
```
Card unlocks: Per level (1-15)
Gear drops: Per Act
Shop unlocks: Per level + Act
No individual unit leveling (single protagonist)
```

### What Needs to Change:

#### **ADD: Individual Lieutenant XP Tracking**

```
CHAMPION PROGRESSION:
- Levels 1-15 (locked)
- HP/Armor/Speed scale per level
- Gain Mana/Stamina upgrades per level

EACH LIEUTENANT PROGRESSION (Season 1: 8 total):
- Levels 1-6 (per-mission cap at 6 for Season 1)
- Independent XP tracking per lieutenant
- HP/Armor/Speed scale per lieutenant
- Traits unlock at specific levels
- Signature cards unlock per level
```

#### **XP Gain System:**

```
PER MISSION:
- Base XP: 100 XP per mission (all units in active squad)
- Bonus XP: Tied to performance
  - Perfect victory (no KO'd units): +50 XP
  - Boss victory: +25 XP
  - Benched unit: 50% XP earned (training on sideline)

LIEUTENANT CATCH-UP (After Swap):
- Mission 1 after swap: 100% XP (baseline)
- Mission 2 after swap: 150% XP (ramping)
- Mission 3+ after swap: 200% XP (max catch-up, caps after 2-3 missions back to 100%)
- Purpose: Prevent benched units from falling too far behind
```

#### **Level-Up Benefits (Per Lieutenant):**

```
Level 2: +2 HP
Level 3: Unlock 1st signature card
Level 4: +1 Speed OR +2 Armor (player chooses, permanent)
Level 5: Unlock 2nd signature card
Level 6: Unlock 3rd signature card + trait upgrade (passive gets stronger)

Example - Marcus Trait Upgrade at Level 6:
- Level 1: "Disciplined" — +1 starting hand size
- Level 6: "Hardened Veteran" — +1 starting hand size, +2 Armor start of combat
```

#### **Per-Lieutenant Stat Scaling:**

```
CHAMPION (AEGIS):
- Level 1: 30 HP, 5 Armor, 2 Speed
- Per level: +2 HP
- Level 15: 58 HP, 5 Armor, 2 Speed

MARCUS THE VETERAN (ECLIPSE-aligned):
- Level 1: 25 HP, 0 Armor, 6 Speed
- Per level: +1.5 HP
- Level 6: 33 HP, 0 Armor, 6 Speed

LIVIA THE CULTIST (SPECTER-aligned):
- Level 1: 20 HP, 2 Armor, 4 Speed
- Per level: +1.75 HP
- Level 6: 29 HP, 2 Armor, 4 Speed

[Repeat for all 8 Season 1 lieutenants]
```

### Changes Needed:

**Progression System Doc Updates (NEW):**
- [ ] Create LIEUTENANT_PROGRESSION_SYSTEM.md
- [ ] Document XP gain per mission (base + bonuses)
- [ ] Document catch-up XP bonus (after swap)
- [ ] Document level-up benefits (traits, HP scaling, card unlocks)
- [ ] Create stat scaling table for all 8 Season 1 lieutenants
- [ ] Clarify benched unit XP (50% earning rate)

**Specific Design Work:**
- [ ] Define XP thresholds per level (0 → 100 → 250 → 450 → 700 → 1000)
- [ ] Design stat growth curves (linear vs exponential) for each lieutenant
- [ ] Map signature card unlocks to lieutenant levels
- [ ] Design trait upgrades at Level 6 for each lieutenant
- [ ] Document cap-out mechanic (catch-up XP goes back to 100% after 3 missions)

---

## 4️⃣ INJURY SYSTEM - NEEDS SQUAD DISTRIBUTION RULES

### Current State:
```
Two-track health (HP vs Injury)
Three tiers (Minor, Serious, Grave)
Injuries per expedition
BUT: No rules for distributing injuries across squad
```

### What Needs to Change:

#### **ADD: Squad-Based Injury Distribution**

When a mission ends in RETREAT or WIPE, determine which units get injured:

```
SCENARIO A: RETREAT (Player chooses to quit mid-mission)
Status: ACCEPTED LOSS
Rewards: Keep earned gold/cards
Injury Risk:
  - Downed units: 50% chance of Grave injury
  - Standing units: 25% chance of Minor injury
  - Example: If Marcus is down and Livia/Titus standing
    → Marcus: 50% Grave injury risk
    → Livia/Titus: 25% Minor injury risk each

SCENARIO B: WIPE (All units KO'd)
Status: TOTAL LOSS
Rewards: Keep 50% earned gold
Injury Risk:
  - All units: 1 Serious injury GUARANTEED
  - Additional: -1 morale (affects next mission)
  - Example: All 4 units take at least 1 Serious injury
    → Takes 2 missions to heal (Doctor/Shaman services)

SCENARIO C: PARTIAL LOSS (1-2 units KO'd)
Status: PYRRHIC VICTORY
Rewards: Keep full earned gold/cards
Injury Risk:
  - KO'd units: 50% chance of Serious injury
  - Standing units: No injury (they protected the squad)
  - Example: Marcus/Livia down, Champion/Titus standing
    → Marcus/Livia: 50% Serious injury risk each
    → Champion/Titus: Safe (no injury)

SCENARIO D: PERFECT VICTORY (No units KO'd)
Status: SUCCESS
Rewards: Keep full gold/cards
Bonus: +1 morale (next mission starts +1 Mana)
Injury Risk: Zero
```

#### **Injury Severity Per Unit:**

When a unit gets injured, they're affected separately:

```
INJURY TRACKING:
- Each unit has independent injury track
- Multiple injuries compound (2 Minor → Serious)
- Can use tent camp to prep for injuries before next fight

HEALING MECHANICS:
- Doctor: 250g for 1 injury treatment (next mission)
- Shaman: 100g for 1 partial healing (less effective)
- Rest: 1-2 missions to naturally recover

MORALE SYSTEM:
- Perfect victory: +1 morale (next mission +1 Mana)
- Total wipe: -1 morale (next mission -1 starting hand)
```

### Changes Needed:

**Injury System Doc Updates:**
- [ ] Create SQUAD_INJURY_DISTRIBUTION.md
- [ ] Document retreat outcome (downed vs standing units)
- [ ] Document total wipe outcome (guaranteed injuries)
- [ ] Document partial loss outcome (KO'd units at risk)
- [ ] Document perfect victory outcome (no injury, bonus morale)
- [ ] Add morale system mechanics
- [ ] Clarify per-unit injury tracking

**Specific Rules Needed:**
- [ ] Define injury roll mechanics (50% chance = roll d100?)
- [ ] Define morale effects on next mission
- [ ] Define escalation path (Minor → Serious → Grave)
- [ ] Define injury medals system (mention for V2, pin for now)

---

## 5️⃣ ENEMY ARCHETYPES - NEEDS SQUAD COMPOSITION VARIANTS

### Current State:
```
12 enemy types (8 common, 3 elite, 1 boss)
Each designed for 1v1 combat
Behavior patterns for single units
Squad composition templates mentioned but NOT designed
```

### What Needs to Change:

#### **ADD: Enemy Squad Composition Rules**

Design enemy squads to match player squad (3-4 units):

```
ENEMY SQUAD SIZING:

Wave 1-2 (Tutorial):
- 1-2 weak enemies (teach blocking, targeting)
- Example: 1 Scout, or 1 Scout + 1 Shieldbearer

Wave 3-4 (Mid-Mission):
- 2-3 medium enemies (test strategy)
- Example: 1 Shieldbearer + 1 Bloodletter, or 3 Scouts

Wave 5 (Challenging):
- 2-3 strong enemies (demand mastery)
- Example: 1 Bruiser + 1 Warlock, or 2 Elites

Wave 6 (Boss):
- 1 boss enemy OR boss + 1-2 adds
- Example: Raid Boss (3-phase), or Boss + 2 weak adds
```

#### **Enemy Squad Positioning:**

```
Front Row (Tanky): Shieldbearer, Bruiser, Raid Boss parts
Back Row (Ranged/Support): Archer, Warlock, Poison Specialist
Mixed: Scouts, Assassins (mobile)

POSITIONING LOGIC:
- Tanky enemies protect fragile allies (like player squad)
- Player can target back-row enemies freely (no blocking for enemies)
- Enemies use positioning to protect allies (AI chess moves)
```

#### **Updated Enemy AI for Squads:**

```
Current AI is per-unit, needs squad-aware variants:

SHIELDBEARER AI UPDATE:
- "Protect" move: Redirect next attack meant for ally to self
- NEW: Prioritize protecting high-damage allies (Bloodletters, Warlocks)

WARLOCK AI UPDATE:
- NEW "Vulnerable Ally" detection: If back-row ally low HP, apply Weakened debuff to player
- Defensive positioning: Stay back-row, rely on tanky allies to protect

SCOUT AI (No change, stays flexible)

ELITE ENEMIES:
- Raid Boss uses more complex chess moves (10-15 possible moves)
- Adds (weaker enemies alongside boss) have simplified AI
```

### Changes Needed:

**Enemy Archetypes Doc Updates:**
- [ ] Add section: "SQUAD COMPOSITION RULES"
- [ ] Define wave-by-wave enemy sizing (1-2, 2-3, 2-3, 1-2 boss)
- [ ] Create positioning guidelines (front/back/mixed)
- [ ] Update each enemy type with squad-aware notes

**New Enemy Squad Templates (Examples):**
- [ ] 1 Shieldbearer + 1 Bloodletter (tank + damage)
- [ ] 2 Scouts + 1 Archer (weak + ranged support)
- [ ] 1 Bruiser + 1 Warlock (tough + control)
- [ ] 1 Raid Boss + 2 Adds (boss + minions)
- [ ] 3 Elite enemies (3 strong units, no boss)

**AI Updates:**
- [ ] Shieldbearer: Add "Protect priority" (choose which ally to protect)
- [ ] Warlock: Add "Support weak ally" move (debuff enemies attacking vulnerable allies)
- [ ] Assassin: Add "Focus lowest HP" move (target weakest player unit)
- [ ] Elite enemies: Add 10-15 chess moves (more tactical)

**Testing Recommendations:**
- [ ] Design sample wave compositions for Acts 1-3
- [ ] Validate difficulty curve (Wave 1 easy, Wave 6 hard)
- [ ] Ensure squad composition feels tactical (not random)

---

## SUMMARY: PRIORITY ORDER

### HIGHEST PRIORITY (Blocks Coding):
1. ✅ **Gear System** — Decide Option C (hybrid model) → Finalize 5-slot rules
2. ✅ **Card Library** — Design 16-24 signature cards
3. ✅ **Enemy Archetypes** — Design squad composition variants

### MEDIUM PRIORITY (Affects Balance):
4. ✅ **Progression System** — Lock XP gain, stat scaling, lieutenant leveling
5. ✅ **Injury System** — Lock squad injury distribution

### IMPLEMENTATION NOTES:

**For Gear System:**
- Go with Option C (Champion 3 + LT Accessory)
- Rewrite 8 accessories to work with 4-unit squads
- Update gear doc with new 5-slot model

**For Card Library:**
- Design signature cards as flexible (work for anyone, bonus if correct unit)
- Total cards: 63 → 79-87 after signature additions

**For Progression:**
- Create new doc: LIEUTENANT_PROGRESSION_SYSTEM.md
- Include XP tables, scaling curves, level-up benefits

**For Enemy Archetypes:**
- Add squad composition section (templates for each wave)
- Update AI for squad-aware decisions
- Create sample mission enemy lineups

**For Injury System:**
- Create new doc: SQUAD_INJURY_DISTRIBUTION.md
- Lock retreat/wipe/partial loss outcomes
- Add morale system (bonus/penalty for next mission)

---

**Next Steps:**
1. Pick 1-2 of these to finalize now (I recommend Gear + Card Library)
2. Create detailed design docs for each
3. Update locked system docs with new information

Ready to dive into any of these?

