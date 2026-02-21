# ENEMY ARCHETYPES - COMPLETE DESIGN
> **Version:** V1 - Production Ready
> **Total Enemy Types:** 12 (8 regular + 3 elite + 1 boss template)
> **Design Philosophy:** Each enemy teaches a lesson, has clear counter-play, scales across Acts

---

## DESIGN PRINCIPLES

### 1. Enemy Purpose Pyramid
```
WAVE 1-2: Tutorial Enemies (teach mechanics)
WAVE 3-4: Tactical Enemies (test strategy)
WAVE 5-6: Elite/Boss Enemies (demand mastery)
```

### 2. AI Behavior Framework
Every enemy follows **Intent → Action → Outcome** pattern:
- **Intent:** Telegraphed next turn (shown to player)
- **Action:** Executes on enemy turn
- **Outcome:** Creates decision point for player

### 3. Faction Distribution
Each faction has **2 common + 1 elite** enemy types:
- **AEGIS:** Tank + Support + Elite Tank
- **ECLIPSE:** Assassin + Berserker + Elite Assassin
- **SPECTER:** Controller + Poisoner + Elite Controller
- **NEUTRAL:** Scouts + Mercenaries (any faction can field)

### 4. Scaling Rules
```
Act 1 (Missions 1-10):  Base stats
Act 2 (Missions 11-25): +20% HP, +1 damage
Act 3 (Missions 26+):   +40% HP, +2 damage, +1 to status effects
```

---

## TIER 1: COMMON ENEMIES (Waves 1-4)

### 🗡️ SCOUT (Neutral - Tutorial Enemy)
**Role:** Warm-up fodder, teaches basic combat
**Faction:** Any (hired mercenaries)

**Base Stats (Act 1):**
- HP: 12
- Armor: 0
- Speed: 3
- Damage: 5

**AI Behavior Pattern:**
```
Priority 1: If HP < 50% → Use "Retreat" (move to back, gain 2 Armor)
Priority 2: If player has Armor > 5 → Use "Pierce" (ignores 3 Armor)
Priority 3: Default → Use "Slash" (basic attack)
```

**Ability Deck:**
- **Slash** (70% chance): Deal 5 damage
- **Pierce** (20% chance): Deal 4 damage, ignores 3 Armor
- **Retreat** (10% chance): Gain 2 Armor, move to back row

**Loot:**
- Gold: 10-15
- Common card chance: 5%

**Design Notes:**
- Dies in 2-3 hits
- Teaches: Basic damage, armor mechanics, positioning
- Counter: Literally any strategy works

---

### 🛡️ SHIELDBEARER (AEGIS - Defensive Wall)
**Role:** Tank, protects dangerous allies
**Faction:** AEGIS

**Base Stats:**
- HP: 25
- Armor: 8
- Speed: 2
- Damage: 4

**AI Behavior Pattern:**
```
Priority 1: If ally at <30% HP → Use "Protect" (redirect next attack to self)
Priority 2: If self Armor < 3 → Use "Fortify" (gain 5 Armor)
Priority 3: Default → Use "Shield Bash" (attack + gain Armor)
```

**Ability Deck:**
- **Shield Bash** (50%): Deal 4 damage, gain 3 Armor
- **Fortify** (30%): Gain 5 Armor
- **Protect** (20%): Redirect next attack to self, gain 2 Armor

**Loot:**
- Gold: 20-30
- Common armor gear chance: 8%

**Design Notes:**
- High armor, low damage
- Becomes priority target when protecting allies
- Teaches: Target prioritization, armor stripping
- Counter: Ignore until dangerous allies dead, or use armor-piercing attacks

---

### 🩸 BLOODLETTER (ECLIPSE - Bleed Specialist)
**Role:** Applies Bleeding, punishes low-armor targets
**Faction:** ECLIPSE

**Base Stats:**
- HP: 18
- Armor: 0
- Speed: 5
- Damage: 6

**AI Behavior Pattern:**
```
Priority 1: If player has Bleeding 0 → Use "Open Wound" (apply Bleeding 3)
Priority 2: If player has Bleeding 3+ → Use "Twist the Knife" (deal damage = Bleeding stacks x2)
Priority 3: Default → Use "Slash" (basic attack)
```

**Ability Deck:**
- **Open Wound** (40%): Deal 5 damage, apply Bleeding 3
- **Twist the Knife** (30%): Deal damage = target's Bleeding x2 (max 12)
- **Slash** (30%): Deal 6 damage

**Loot:**
- Gold: 20-30
- Common weapon chance: 8%

**Design Notes:**
- Fragile (18 HP, 0 Armor) but dangerous if ignored
- Teaches: Status effect pressure, importance of healing
- Counter: Focus fire early, use armor to mitigate Bleeding, cleanse effects

---

### ☠️ TOXICANT (SPECTER - Poison Applicator)
**Role:** Poison stacker, enables SPECTER win condition
**Faction:** SPECTER

**Base Stats:**
- HP: 20
- Armor: 2
- Speed: 4
- Damage: 5

**AI Behavior Pattern:**
```
Priority 1: If player has Poison 0 → Use "Envenom" (apply Poison 2)
Priority 2: If player has Poison 3+ → Use "Plague Strike" (damage + spread Poison to squad)
Priority 3: Default → Use "Toxin Dart" (attack + Poison 1)
```

**Ability Deck:**
- **Envenom** (40%): Apply Poison 3
- **Plague Strike** (30%): Deal 5 damage, spread 1 Poison to entire player squad
- **Toxin Dart** (30%): Deal 4 damage, apply Poison 1

**Loot:**
- Gold: 20-30
- Common accessory chance: 8%

**Design Notes:**
- Medium bulk, stacks Poison quickly
- Teaches: Cleanse importance, squad-wide effects
- Counter: Focus fire to kill before Poison stacks, use AEGIS healing, cleanse consumables

---

### 🔥 BERSERKER (ECLIPSE - Risk/Reward)
**Role:** High damage, self-buffs with Enraged
**Faction:** ECLIPSE

**Base Stats:**
- HP: 22
- Armor: 0
- Speed: 4
- Damage: 7

**AI Behavior Pattern:**
```
Priority 1: If HP > 50% AND not Enraged → Use "Rage" (apply Enraged 3 to self)
Priority 2: If Enraged → Use "Reckless Strike" (massive damage, lose HP)
Priority 3: Default → Use "Cleave" (AoE attack)
```

**Ability Deck:**
- **Rage** (30%): Apply Enraged 3 to self (deal +50% damage, take +25% damage)
- **Reckless Strike** (40%): Deal 12 damage, take 4 damage
- **Cleave** (30%): Deal 5 damage to entire player squad

**Loot:**
- Gold: 25-35
- Rare weapon chance: 5%

**Design Notes:**
- Glass cannon that buffs itself
- Becomes extremely dangerous when Enraged
- Teaches: Interrupt priority, exploiting vulnerabilities (Enraged takes +damage)
- Counter: Burst down while Enraged (exploit vulnerability), apply Weakened

---

### 🧙 WARLOCK (SPECTER - Debuff Support)
**Role:** Applies Weakened, supports allies
**Faction:** SPECTER

**Base Stats:**
- HP: 18
- Armor: 3
- Speed: 4
- Damage: 4

**AI Behavior Pattern:**
```
Priority 1: If player not Weakened → Use "Curse" (apply Weakened 3)
Priority 2: If ally HP < 40% → Use "Dark Mend" (heal ally 8 HP)
Priority 3: Default → Use "Shadow Bolt" (basic attack)
```

**Ability Deck:**
- **Curse** (40%): Apply Weakened 3 to player
- **Dark Mend** (30%): Heal ally 8 HP
- **Shadow Bolt** (30%): Deal 4 damage, apply Poison 1

**Loot:**
- Gold: 25-35
- Rare accessory chance: 5%

**Design Notes:**
- Fragile support that enables allies
- Priority kill target (healing + debuffs)
- Teaches: Target prioritization, interrupt importance
- Counter: Focus fire immediately, use cleanse for Weakened

---

### 🪓 BRUISER (Neutral - Damage Dealer)
**Role:** Mid-tier threat, solid stats
**Faction:** Any

**Base Stats:**
- HP: 24
- Armor: 3
- Speed: 3
- Damage: 7

**AI Behavior Pattern:**
```
Priority 1: If player has Armor > 6 → Use "Armor Break" (deal damage, remove Armor)
Priority 2: If player HP < 30% → Use "Execute" (bonus damage vs low HP)
Priority 3: Default → Use "Heavy Blow" (high damage attack)
```

**Ability Deck:**
- **Heavy Blow** (50%): Deal 7 damage
- **Armor Break** (30%): Deal 5 damage, remove 4 Armor
- **Execute** (20%): Deal 10 damage if target below 30% HP, else 6 damage

**Loot:**
- Gold: 25-35
- Common weapon chance: 10%

**Design Notes:**
- Balanced stats, no gimmicks
- Teaches: Managing HP thresholds, armor dependency
- Counter: Keep HP high, maintain armor

---

### 🏹 SNIPER (Neutral - Backline Threat)
**Role:** Bypasses front line, targets weakest unit
**Faction:** Any

**Base Stats:**
- HP: 16
- Armor: 0
- Speed: 5
- Damage: 8

**AI Behavior Pattern:**
```
Priority 1: Always target lowest HP player unit
Priority 2: If that unit has Armor > 5 → Use "Pierce Shot" (ignores Armor)
Priority 3: Default → Use "Snipe" (high damage, can't be blocked by positioning)
```

**Ability Deck:**
- **Snipe** (60%): Deal 8 damage to lowest HP target (ignores positioning)
- **Pierce Shot** (30%): Deal 6 damage, ignores all Armor
- **Retreat** (10%): Gain 3 Armor, move to back

**Loot:**
- Gold: 30-40
- Rare accessory chance: 5%

**Design Notes:**
- Fragile but dangerous
- Forces player to protect weakest units
- Teaches: HP management across squad, positioning limitations
- Counter: Rush down immediately, use armor on weak units

---

## TIER 2: ELITE ENEMIES (Waves 4-6)

### 👑 CHAMPION (AEGIS Elite - Mini-Boss Tank)
**Role:** High HP tank with self-sustain
**Faction:** AEGIS

**Base Stats:**
- HP: 40
- Armor: 10
- Speed: 2
- Damage: 6

**AI Behavior Pattern:**
```
Priority 1: If HP < 50% → Use "Second Wind" (restore 15 HP, gain 5 Armor)
Priority 2: If Armor < 5 → Use "Fortress Stance" (gain 8 Armor, apply Weakened 2)
Priority 3: Default → Use "Crushing Blow" (attack that removes Armor from self for bonus damage)
```

**Ability Deck:**
- **Crushing Blow** (40%): Deal 10 damage, lose all Armor
- **Fortress Stance** (30%): Gain 8 Armor, apply Weakened 2 to attacker
- **Second Wind** (30%): Restore 15 HP, gain 5 Armor (once per combat)

**Loot:**
- Gold: 50-70
- Rare gear chance: 20%
- Epic gear chance: 5%

**Design Notes:**
- Endurance test, not burst threat
- Dangerous in squad compositions (protects allies)
- Teaches: Sustained pressure, armor stripping combos
- Counter: Ignore until dangerous allies dead, use armor-piercing repeatedly

---

### ⚔️ ASSASSIN (ECLIPSE Elite - Execution Specialist)
**Role:** Ultra-high burst, execution rewards
**Faction:** ECLIPSE

**Base Stats:**
- HP: 28
- Armor: 0
- Speed: 6
- Damage: 10

**AI Behavior Pattern:**
```
Priority 1: If any player unit below 40% HP → Use "Execute" (massive damage, restore HP on kill)
Priority 2: If player has Bleeding 3+ → Use "Bloodlust Strike" (damage x Bleeding stacks)
Priority 3: Default → Use "Vital Strike" (apply Bleeding 3, high damage)
```

**Ability Deck:**
- **Execute** (30%): Deal 15 damage. If this kills, restore 12 HP.
- **Bloodlust Strike** (35%): Deal damage = 3 + (target's Bleeding x3)
- **Vital Strike** (35%): Deal 8 damage, apply Bleeding 3

**Loot:**
- Gold: 50-70
- Rare weapon chance: 25%
- Epic weapon chance: 5%

**Design Notes:**
- EXTREMELY dangerous if player is wounded
- Snowballs with kills (Execute heal)
- Teaches: HP threshold management, focus fire discipline
- Counter: Keep all units above 40% HP, focus fire immediately, use armor

---

### 🌑 SHADE (SPECTER Elite - Master Controller)
**Role:** Full control suite, debuffs + Poison scaling
**Faction:** SPECTER

**Base Stats:**
- HP: 32
- Armor: 4
- Speed: 5
- Damage: 6

**AI Behavior Pattern:**
```
Priority 1: If player Poison < 3 → Use "Virulent Touch" (apply Poison 4)
Priority 2: If player Poison >= 3 → Use "Plague Burst" (deal damage = Poison x2, spread to squad)
Priority 3: If not applied Weakened → Use "Enfeeble" (apply Weakened 4, discard 1 card)
Priority 4: Default → Use "Shadow Strike" (attack + Poison 1)
```

**Ability Deck:**
- **Virulent Touch** (30%): Apply Poison 4
- **Plague Burst** (25%): Deal damage = target's Poison x2, spread 1 Poison to entire squad
- **Enfeeble** (25%): Apply Weakened 4, target discards 1 card
- **Shadow Strike** (20%): Deal 6 damage, apply Poison 1

**Loot:**
- Gold: 50-70
- Rare accessory chance: 25%
- Epic accessory chance: 5%

**Design Notes:**
- Control lock if ignored
- Poison scaling becomes lethal
- Teaches: Cleanse priority, resource denial
- Counter: Burst down early, cleanse constantly, use AEGIS

---

## TIER 3: BOSS TEMPLATE

### 👹 BOSS ENCOUNTER (Generic Template)
**Role:** Multi-phase endurance test
**Faction:** Varies by mission

**Phase 1 (100%-60% HP):**
```
Base Stats:
- HP: 60-80 (scales by Act)
- Armor: 5-10
- Speed: 4
- Damage: 8

AI Pattern:
- Telegraphed high-damage attacks (⚠️ HEAVY STRIKE incoming)
- Applies 1-2 status effects per turn
- Summons 1 common enemy every 3 turns
```

**Phase 2 (60%-30% HP):**
```
Mechanic Shift:
- Gains Enraged 3 permanently (+50% damage)
- Speed increases to 5
- Uses AoE attacks more frequently
- Summons elite enemies instead of common
```

**Phase 3 (30%-0% HP):**
```
Desperation:
- Uses ultimate ability (unique per boss)
- Applies multiple status effects
- Gains 10 Armor at start of phase
- Attacks twice per turn
```

**Boss-Specific Ultimates (Examples):**

**AEGIS Boss - "THE BULWARK":**
- **Phase 3 Ultimate:** Gain 20 Armor, heal 20 HP, apply Weakened 5 to entire squad

**ECLIPSE Boss - "THE REAPER":**
- **Phase 3 Ultimate:** Deal 20 damage to lowest HP unit, apply Bleeding 5 to entire squad

**SPECTER Boss - "THE HOLLOW KING":**
- **Phase 3 Ultimate:** Apply Poison 6 to entire squad, double all Poison stacks at start of each turn

**Loot:**
- Gold: 80-120
- Rare gear chance: 50%
- Epic gear chance: 20%
- Legendary gear chance: 5%

**Design Notes:**
- Each phase teaches a different skill
- Telegraphed attacks give counterplay windows
- Summons prevent pure stall strategies
- Phase transitions are clear (visual + audio cues)

---

## AI BEHAVIOR PRIORITY SYSTEM

### Decision Tree (Every Enemy Turn):
```
1. Check survival threshold (HP < 30%?)
   → YES: Use defensive/escape ability
   → NO: Continue

2. Check high-value targets (player unit below 30% HP?)
   → YES: Use execution/burst ability
   → NO: Continue

3. Check setup conditions (player has 0 Bleeding/Poison?)
   → YES: Use setup ability (apply status)
   → NO: Continue

4. Check payoff conditions (player has 3+ Bleeding/Poison?)
   → YES: Use payoff ability (damage scaling)
   → NO: Continue

5. DEFAULT: Use basic attack
```

### Difficulty Modifiers (Act Scaling):

**Act 1:**
- Enemies prioritize basic attacks (70% of the time)
- Rare use of advanced abilities
- Predictable patterns

**Act 2:**
- Enemies use advanced abilities more (50% of the time)
- Start comboing abilities (Warlock Curse → Berserker Rage)
- Adapt to player strategy (if player stacks Armor, use Pierce more)

**Act 3:**
- Enemies optimize ability usage (30% basic attacks)
- Full combo execution (Warlock Curse → Assassin Execute)
- Counter player faction (AEGIS players face more Poison/Bleeding)

---

## SQUAD COMPOSITION TEMPLATES

### Wave 1-2: Tutorial Squads
```
Composition: 2-3 Scouts
Purpose: Teach basic combat, low threat
```

### Wave 3-4: Tactical Squads
```
AEGIS Composition: 1 Shieldbearer + 2 Bruisers
- Shieldbearer protects Bruisers
- Player must decide: kill tank first or ignore?

ECLIPSE Composition: 1 Bloodletter + 1 Berserker + 1 Sniper
- Berserker goes Enraged, Bloodletter applies Bleeding, Sniper finishes
- Player must: cleanse Bleeding, burst Berserker while vulnerable

SPECTER Composition: 1 Toxicant + 1 Warlock + 1 Shade (Elite)
- Warlock Weakens, Toxicant/Shade stack Poison
- Player must: burst Warlock first, cleanse constantly
```

### Wave 5-6: Elite Squads
```
Mixed Faction: 1 Champion + 1 Assassin + 1 Warlock
- Champion tanks, Warlock debuffs, Assassin executes
- Player must: perfect target priority, HP management, cleanse timing

Boss Wave: 1 Boss + 2 rotating summons
- Boss summons common enemies every 3 turns
- Player must: balance boss damage with add control
```

---

## LOOT TABLE (Consolidated)

### Common Enemies (Scout, Shieldbearer, Bloodletter, Toxicant):
```
Gold: 10-30
Common gear: 5-10%
Rare gear: 0-2%
```

### Tactical Enemies (Berserker, Warlock, Bruiser, Sniper):
```
Gold: 25-40
Common gear: 10-15%
Rare gear: 5-8%
Epic gear: 0-1%
```

### Elite Enemies (Champion, Assassin, Shade):
```
Gold: 50-70
Rare gear: 20-25%
Epic gear: 5-8%
Legendary gear: 1-2%
```

### Boss Enemies:
```
Gold: 80-120
Rare gear: 50%
Epic gear: 20%
Legendary gear: 5%
```

---

## INTEGRATION WITH EXISTING SYSTEMS

### Injury System Integration:
```
Enemies can inflict injuries via:
- CRITICAL HITS (telegraphed ⚠️ attacks)
- KNOCKING PLAYER TO 0 HP
- ENVIRONMENTAL HAZARDS (boss mechanics)

Critical Hit Triggers:
- Assassin Execute on kill
- Boss Phase 3 ultimate
- Berserker Reckless Strike (if player below 20% HP)
```

### Companion/Story System Integration:
```
Enemy kills can trigger events:
- Kill Assassin that targeted your teammate → Bond +1
- Fail to protect ally from Sniper → Bond -1, stress +1
- Retreat from Elite → stress +1, trust -1 (if vow_no_retreat active)
```

### Contract Board Integration:
```
Enemy factions on missions create hooks:
- Face heavy AEGIS composition → "armor_dependence" hook
- Face ECLIPSE Assassins → "injury_risk" hook
- Face SPECTER Poison spam → "cleanse_required" hook

These hooks influence next contract board generation
```

---

## TESTING PRIORITIES

1. **Solo Enemy Validation**
   - Each enemy beatable with basic starter deck
   - AI makes intelligent decisions
   - Loot rewards feel fair

2. **Squad Composition Balance**
   - 3-enemy squads pose challenge but not wall
   - Synergies feel intentional, not random
   - Player has multiple valid strategies

3. **Boss Encounter Tuning**
   - Each phase distinct and teachable
   - Summoning doesn't overwhelm
   - Ultimates are dramatic but survivable

4. **Act Scaling Verification**
   - Act 2 enemies feel stronger, not unfair
   - Act 3 enemies demand mastery, not perfection
   - Loot scaling matches difficulty increase

---

**STATUS: ✅ LOCKED - READY FOR IMPLEMENTATION**

**Next Step:** Design Card Library (40-60 cards)
**After That:** Create Starting Deck Templates
**Then:** Build combat simulator to validate balance

---

**All 12 enemy archetypes complete!**
**Total lines:** 8 Common + 3 Elite + 1 Boss Template = Production-ready enemy roster
