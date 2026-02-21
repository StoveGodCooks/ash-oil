# IMMEDIATE TASKS (No Story Dependency)
> **Date:** 2026-02-15
> **Purpose:** What we can build RIGHT NOW while story team works
> **Timeline:** 1-2 weeks of parallel work

---

## 🚀 CRITICAL PATH (Build These First)

### **TASK 1: Squad Combat Rules** 🚨 BLOCKING EVERYTHING
**Status:** NOT DESIGNED
**Time:** 4-6 hours design
**Blocks:** Combat coding, balance spreadsheet, tutorial

**What to Design:**
1. **Turn Structure for 3 Units**
   - How does shared deck work with 3 units?
   - Card assignment rules ("Shield Bash → Marcus")
   - Individual HP tracking during combat

2. **Resource Management**
   - CONFIRMED: Shared Stamina pool (3/turn)
   - CONFIRMED: Shared Mana pool (0 start, +1/turn, +1/card, +1/5dmg)
   - Hand: Shared (7 cards drawn/turn)

3. **Targeting System**
   - How to choose which enemy to attack?
   - AoE cards ("all enemies") - how does UI show this?
   - Single-target cards - click to choose target?

4. **Unit Death/KO Rules**
   - What happens when lieutenant hits 0 HP?
   - Does combat continue with 2 units?
   - Can you revive KO'd units mid-combat? (NO - stays down)

**Deliverable:** `SQUAD_COMBAT_RULES_V1.md`

**Why Critical:** Blocks all coding work. Can't build combat engine without this.

---

### **TASK 2: Signature Lieutenant Cards** ⚡ EXTENDS CARD LIBRARY
**Status:** NOT DESIGNED
**Time:** 2-3 hours
**Dependency:** NONE (we have 8 lieutenants already designed)

**What to Design:**
Design 2-3 signature cards per lieutenant (16-24 cards total)

**Format:**
```
VETERAN'S RESOLVE (Marcus Signature)
Cost: 1 Stamina
Type: Skill
Effect: Gain 4 Armor. If played by Marcus, draw 1 card.
Rarity: Common
Unlock: Recruit Marcus

LEGION TACTICS (Marcus Signature)
Cost: 2 Stamina
Type: Attack
Effect: Deal 6 damage. If played by Marcus, apply Weakened 2.
Rarity: Rare
Unlock: Marcus Level 3

---

BLESSED STRIKE (Livia Signature)
Cost: 1 Stamina
Type: Attack
Effect: Deal 4 damage, apply Poison 1. If played by Livia, apply +1 additional Poison.
Rarity: Common
Unlock: Recruit Livia

RITUAL CURSE (Livia Signature)
Cost: 2 Stamina
Type: Skill
Effect: Apply Poison 3. If played by Livia, enemy discards 1 card.
Rarity: Rare
Unlock: Livia Level 3
```

**Design Template:**
Each lieutenant gets:
- 1 Common signature (unlocked when recruited)
- 1 Rare signature (unlocked at Level 3)
- 1 Epic signature (unlocked at Level 6) - OPTIONAL

**Total Cards:** 8 lieutenants × 2-3 = 16-24 new cards

**Deliverable:** `LIEUTENANT_SIGNATURE_CARDS.md`

**Why Now:** Extends card pool to 79-87 cards, creates lieutenant identity, no story dependency.

---

### **TASK 3: Stat Growth Formulas** ⚡ FINISHES PROGRESSION
**Status:** 30% COMPLETE
**Time:** 1 hour
**Dependency:** NONE

**What to Design:**
Linear stat scaling for Champion + Lieutenants

**Champion Scaling:**
```
AEGIS (Tank):
- Level 1: 30 HP, 5 Armor, 2 Speed
- Per Level: +2 HP
- Level 15: 58 HP, 5 Armor, 2 Speed

ECLIPSE (Burst):
- Level 1: 20 HP, 0 Armor, 5 Speed
- Per Level: +1.5 HP
- Level 15: 41 HP, 0 Armor, 5 Speed

SPECTER (Control):
- Level 1: 25 HP, 2 Armor, 4 Speed
- Per Level: +1.75 HP
- Level 15: 49 HP, 2 Armor, 4 Speed
```

**Lieutenant Scaling:**
```
Marcus (AEGIS-like Tank):
- Level 1: 25 HP, 3 Armor, 2 Speed
- Per Level: +2 HP, +0.2 Armor (rounded)
- Level 6: 35 HP, 4 Armor, 2 Speed

Livia (SPECTER-like Control):
- Level 1: 20 HP, 2 Armor, 4 Speed
- Per Level: +1.5 HP
- Level 6: 27 HP, 2 Armor, 4 Speed

Kara (ECLIPSE-like Burst):
- Level 1: 22 HP, 1 Armor, 5 Speed
- Per Level: +1.5 HP
- Level 6: 29 HP, 1 Armor, 5 Speed

[Repeat for all 8 lieutenants]
```

**Deliverable:** `STAT_GROWTH_FORMULAS.md`

**Why Now:** Completes progression system, no story needed.

---

### **TASK 4: Gear System Update (5 Slots)** ⚡ EXTENDS GEAR
**Status:** NEEDS REVISION
**Time:** 1 hour
**Dependency:** NONE

**Current Design:** 3 slots (Weapon, Armor, Accessory) for single unit

**New Design:** 5 slots total for squad
```
CHAMPION LOADOUT:
├─ Weapon Slot (offensive gear)
├─ Armor Slot (defensive gear)
└─ Accessory Slot (utility gear)

LIEUTENANT 1 LOADOUT:
└─ Accessory Slot (utility gear)

LIEUTENANT 2 LOADOUT:
└─ Accessory Slot (utility gear)

TOTAL: 5 gear pieces equipped at once
```

**Why This:**
- ✅ Champion feels special (full loadout)
- ✅ Lieutenants customizable (1 accessory creates variety)
- ✅ Manageable (5 slots, not 9)
- ✅ Easier to balance

**Deliverable:** Update `gear_system_complete.md` with 5-slot model

**Why Now:** No story dependency, just extends existing gear system.

---

### **TASK 5: Injury Distribution Rules** ⚡ EXTENDS INJURY SYSTEM
**Status:** NEEDS CLARIFICATION
**Time:** 30 minutes
**Dependency:** NONE

**What to Define:**
When mission fails/retreats, who takes injuries?

**Proposed Rules:**
```
RETREAT (Player Choice):
- Keep rewards earned
- All DOWNED units: 50% Grave injury risk
- All STANDING units: 25% Minor injury risk
- Forced return to hub

TOTAL WIPE (All 3 Units KO'd):
- Keep 50% rewards
- All units: 1 Serious injury GUARANTEED
- Forced return to hub
- Morale penalty: -1 starting hand next mission

PARTIAL LOSS (1-2 Units KO'd):
- Keep full rewards
- KO'd units: 50% Serious injury risk
- Standing units: No injury (protected fallen allies)
- Can continue mission OR retreat

PERFECT VICTORY (No Units KO'd):
- Full rewards
- No injury risk
- Morale bonus: +1 Mana start next mission
```

**Deliverable:** Update `expedition_injury_system.md` with distribution rules

**Why Now:** No story dependency, just mechanics.

---

### **TASK 6: Balance Spreadsheet** 📊 VALIDATION TOOL
**Status:** NOT STARTED
**Time:** 2-3 hours
**Dependency:** Squad combat rules (need to know how 3 units interact)

**What to Build:**
Google Sheets or Excel with:

**Tab 1: Card Database**
```
Columns:
- Card Name
- Cost (Stamina)
- Damage
- Status Effects (Bleeding/Armor/Weakened/Enraged/Poison)
- Rarity
- Faction
- Unlock Level
- Notes

All 63 cards + 16-24 signature cards = 79-87 rows
```

**Tab 2: Gear Database**
```
Columns:
- Gear Name
- Slot (Weapon/Armor/Accessory)
- Stats (+HP, +Armor, +damage, etc.)
- Unique Effect
- Rarity
- Price
- Faction Synergy

All 24 gear pieces
```

**Tab 3: Damage Calculator**
```
Inputs:
- Base Damage
- Attacker Modifiers (Enraged? Weakened? Bloodlust?)
- Defender Armor
- Defender Modifiers (Enraged?)

Output:
- Final Damage to HP
- Step-by-step breakdown
```

**Tab 4: Combo Finder**
```
Test combinations:
- Card + Gear + Faction passive
- Identify overpowered combos (DPS > 30/turn)
- Identify "strictly worse" cards (never worth playing)
```

**Deliverable:** `BALANCE_SPREADSHEET.xlsx` or Google Sheets link

**Why Now:** Can build after squad combat rules locked (need to know how 3 units share resources).

---

### **TASK 7: Export Card Library as Text** 📄 PLACEHOLDER SYSTEM
**Status:** READY
**Time:** 30 minutes
**Dependency:** NONE

**What to Do:**
Export all 63 cards (+ 16-24 signature cards) in text format

**Format:**
```
======================
AEGIS CARDS (15)
======================

SHIELD BASH
Cost: 1 Stamina
Type: Attack
Effect: Deal 5 damage. Gain 3 Armor.
Rarity: Starter
Faction: AEGIS
Unlock: Level 1

BRACE
Cost: 1 Stamina
Type: Skill
Effect: Gain 5 Armor.
Rarity: Starter
Faction: AEGIS
Unlock: Level 1

[... all 63 cards ...]

======================
LIEUTENANT SIGNATURES
======================

VETERAN'S RESOLVE (Marcus)
Cost: 1 Stamina
Type: Skill
Effect: Gain 4 Armor. If played by Marcus, draw 1 card.
Rarity: Common
Unlock: Recruit Marcus

[... all signature cards ...]
```

**Deliverable:** `CARD_LIBRARY_TEXT_EXPORT.txt`

**Why Now:**
- ✅ Chat GPT building card art separately
- ✅ Text placeholders for coding/balancing
- ✅ Easy to swap in art later
- ✅ No story dependency

---

### **TASK 8: Tutorial Mission Specs (Mechanics Only)** 📚 ONBOARDING
**Status:** NOT DESIGNED
**Time:** 2-3 hours
**Dependency:** Squad combat rules (need to know how to teach it)

**What to Design:**
First 3 missions (tutorial sequence)

**Mission 1: "First Blood" (Solo Combat)**
```
Objective: Learn basic combat
Player Squad: Champion only (no lieutenants yet)
Enemy Squad: 1 Scout (10 HP, 0 Armor)

Waves: 1 (tutorial is short)
Tutorial Steps:
1. "Play a card from your hand" (force Shield Bash play)
2. "Your turn ends when you pass or run out of Stamina"
3. "Enemy attacks. You take damage."
4. "DoTs tick at start of turn. Watch your HP."
5. "Defeat the Scout to win."

Rewards:
- 50 gold
- Unlock: 3 Level 2 cards (Iron Will, Fortify, Shieldwall)
- Unlock: Ability to recruit lieutenants

No Story: Just mechanics tutorial
```

**Mission 2: "The Companion" (Squad Combat)**
```
Objective: Learn lieutenant system
Player Squad: Champion + Marcus (just recruited)
Enemy Squad: 2 Scouts (12 HP each)

Waves: 1
Tutorial Steps:
1. "You now have a lieutenant. Marcus fights alongside you."
2. "Play Shield Bash. Choose which unit executes it." (click Marcus or Champion)
3. "Marcus has a trait: Disciplined (+1 starting hand). You draw 6 cards now."
4. "Lieutenants share your Stamina and Mana pools."
5. "Defeat both Scouts."

Rewards:
- 60 gold
- Unlock: Marcus signature cards (Veteran's Resolve, Legion Tactics)
- Unlock: Ability to recruit 2nd lieutenant

No Story: Just squad mechanics tutorial
```

**Mission 3: "Blood and Steel" (Status Effects)**
```
Objective: Learn status effects
Player Squad: Champion + Marcus + [2nd Lieutenant]
Enemy Squad: 1 Bloodletter (18 HP, applies Bleeding)

Waves: 1
Tutorial Steps:
1. "Enemies can apply status effects. This one applies Bleeding."
2. "Bleeding: Take 1 damage per stack at start of turn, then -1 stack."
3. "Use Brace to gain Armor. Armor blocks damage before HP."
4. "Status effects are powerful. Use them wisely."
5. "Defeat the Bloodletter."

Rewards:
- 80 gold
- 1 Common gear (Iron Gladius)
- Unlock: Full game (can play Missions 4-15)

No Story: Just status effect tutorial
```

**Deliverable:** `TUTORIAL_MISSIONS_SPEC.md`

**Why Now:**
- ⚠️ Depends on squad combat rules (need to know how to teach card assignment)
- ✅ No story needed (just mechanics)
- ✅ Can design once squad rules locked

---

## 🔧 SUPPORTING TASKS (Lower Priority, No Story)

### **TASK 9: Economy Extension to 30 Missions** 📊
**Status:** NEEDS EXTENSION
**Time:** 1 hour
**Dependency:** NONE

**What to Do:**
Extend economy table from 15 missions to 30

**Season 1 (Missions 1-15):**
- Total Gold: 3,924g (already designed)
- Deficit: ~1,285g (player must choose)

**Season 2 (Missions 16-30):**
- Total Gold: +3,924g (same as Season 1)
- New Sinks:
  - Epic gear upgrades (~1,500g)
  - Rare card purchases (~600g)
  - Max-level healing (~400g)
  - Campaign upgrades (~500g)
- Deficit: ~1,000g

**Total Campaign (30 missions):**
- Income: 7,848g
- Spending: ~10,133g
- Total Deficit: ~2,285g (forces choices across campaign)

**Deliverable:** Update `ECONOMY_SHOP_SYSTEM_COMPLETE.md` with Season 2 table

**Why Now:** No story dependency, just extends existing economy.

---

### **TASK 10: Lieutenant Loyalty System** 🎭
**Status:** MENTIONED, NOT DESIGNED
**Time:** 1-2 hours
**Dependency:** NONE

**What to Design:**
Loyalty meter per lieutenant (0-10 scale)

**Loyalty Effects:**
```
MARCUS (Veteran):
- Increases: Spare enemies (+1), Win honorably (+1)
- Decreases: Execute enemies (-1), Retreat from winnable fight (-1)
- High (8-10): Bonus trait (+1 Armor start of combat)
- Medium (4-7): Normal trait (Disciplined: +1 starting hand)
- Low (1-3): Trait disabled, may desert (triggers "Desertion" event)
- Zero: Deserts permanently (lose lieutenant)

LIVIA (Cultist):
- Increases: Join cult (+3), Heed omens (+1), Attend rites (+1)
- Decreases: Betray cult (-5), Ignore omens (-1)
- High: Bonus trait (+1 Mana start)
- Low: Leaves if you betray cult

[Design for all 8 lieutenants]
```

**Loyalty Triggers:**
- Story choices (join cult, betray faction, etc.) - **WAIT FOR STORY**
- Combat choices (spare vs execute) - **CAN DESIGN NOW**
- Mission outcomes (win vs retreat) - **CAN DESIGN NOW**

**Deliverable:** `LIEUTENANT_LOYALTY_SYSTEM.md`

**Why Now:**
- ⚠️ Some triggers need story (faction choices)
- ✅ Combat triggers can be designed now (spare, execute, retreat)

---

### **TASK 11: Combat Simulator Update** 🤖
**Status:** NEEDS SQUAD SUPPORT
**Time:** 3-4 hours coding
**Dependency:** Squad combat rules

**What to Update:**
Current simulator is 1v1 (Champion vs Scout)

**New Requirements:**
- 3-unit squad (Champion + 2 Lieutenants)
- Shared Stamina/Mana pools
- Individual HP tracking
- Card assignment to units
- Lieutenants provide passive traits

**What to Simulate:**
- 150 combats: 50 per faction vs Scout
- Metrics: Win rate, avg turns, HP remaining, card usage

**Deliverable:** Updated `combat_simulator.py` or `.js`

**Why Later:**
- ⚠️ Depends on squad combat rules
- ⚠️ Coding task (Phase 6 work)

---

## 📋 PRIORITY ORDER (What to Do First)

### **WEEK 1: LOCK SQUAD MECHANICS**

**Day 1-2: Squad Combat Rules** (4-6 hours)
1. Design turn structure for 3 units
2. Define card assignment rules
3. Define targeting system
4. Document unit KO rules

**Day 3: Signature Lieutenant Cards** (2-3 hours)
1. Design 2-3 cards per lieutenant × 8
2. Total: 16-24 new cards
3. Add to card library

**Day 4: Stat Growth Formulas** (1 hour)
1. Champion scaling (3 factions)
2. Lieutenant scaling (8 lieutenants)
3. Linear growth formulas

**Day 5: Gear System Update** (1 hour)
1. 5-slot model (Champion 3, Lieutenants 1 each)
2. Update existing gear to work with new slots

**Day 6-7: Balance Spreadsheet** (2-3 hours)
1. Enter all 79-87 cards
2. Enter all 24 gear pieces
3. Build damage calculator
4. Test combos

### **WEEK 2: TUTORIAL & VALIDATION**

**Day 1-2: Tutorial Mission Specs** (2-3 hours)
1. Mission 1: Solo combat
2. Mission 2: Squad combat
3. Mission 3: Status effects

**Day 3: Export Card Library** (30 minutes)
1. Text file with all 79-87 cards
2. Ready for balancing/coding

**Day 4: Injury Distribution Rules** (30 minutes)
1. Retreat outcomes
2. Total wipe outcomes
3. Partial loss outcomes

**Day 5: Economy Extension** (1 hour)
1. Season 2 gold rewards
2. Season 2 sinks
3. Balance validation

**Day 6-7: Loyalty System** (1-2 hours)
1. Design loyalty meters
2. Combat-based triggers (can do now)
3. Story-based triggers (pin for later)

---

## ✅ WHAT YOU GET AFTER 2 WEEKS

### **Fully Designed Systems:**
1. ✅ Squad combat rules (LOCKED)
2. ✅ 79-87 total cards (63 base + 16-24 signatures)
3. ✅ Stat growth formulas (LOCKED)
4. ✅ 5-slot gear system (LOCKED)
5. ✅ Balance spreadsheet (validation ready)
6. ✅ Tutorial missions (M01-M03 specs)
7. ✅ Injury distribution rules (LOCKED)
8. ✅ Economy for 30 missions (LOCKED)
9. ✅ Loyalty system framework (combat triggers)

### **Ready for Coding:**
- Combat engine can be built (squad rules locked)
- Balance is validated (spreadsheet complete)
- Tutorial is designed (M01-M03 ready)
- Placeholder cards ready (text export done)

### **Waiting on Story Team:**
- Missions 4-30 (enemy compositions need story context)
- Companion arcs (need story beats)
- Service/route state changes (need story triggers)
- Loyalty story triggers (need faction choices)

---

## 🎯 IMMEDIATE ACTION ITEMS

**Can Start TODAY:**
1. **Design squad combat rules** (4-6 hours) - CRITICAL PATH
2. **Design signature lieutenant cards** (2-3 hours)
3. **Define stat growth formulas** (1 hour)

**Can Start This Week:**
4. Update gear to 5-slot system (1 hour)
5. Build balance spreadsheet (2-3 hours)
6. Design tutorial missions (2-3 hours)

**Can Start Next Week:**
7. Export card library as text (30 minutes)
8. Define injury distribution (30 minutes)
9. Extend economy to 30 missions (1 hour)
10. Design loyalty system (1-2 hours)

---

## 🚀 LET'S START NOW

**Want me to design:**
1. **Squad Combat Rules** (full system)?
2. **Signature Lieutenant Cards** (16-24 cards)?
3. **Stat Growth Formulas** (Champion + 8 Lieutenants)?

**Or all three in sequence?**

We can knock out **Squad Combat Rules** in the next few hours, then move to the rest. That unlocks everything else.

**Ready to go?** 🎯
