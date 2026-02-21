# ENEMY ARCHETYPES - SQUAD COMBAT UPDATE

> **Status:** ✅ LOCKED FOR SQUAD COMBAT
> **Version:** V2 - Squad-Optimized
> **Date:** 2026-02-20
> **Purpose:** Update 12 existing enemy archetypes with squad composition templates and squad-aware AI

---

## OVERVIEW

This document extends ENEMY_ARCHETYPES_COMPLETE.md with:
1. **Squad Composition Templates** — How enemies team up (3-4 unit squads)
2. **Squad-Aware AI Moves** — Enemies protect/support allies
3. **Enemy Positioning Rules** — Front-row (tank) vs back-row (ranged/support)
4. **Sample Wave Lineups** — Example enemy squads per mission difficulty

---

## SQUAD COMPOSITION FRAMEWORK

### Enemy Positioning (Mirrors Player Squad)

```
FRONT ROW (Melee/Tank):        BACK ROW (Ranged/Support):
├─ Shieldbearer                ├─ Archer
├─ Bruiser                      ├─ Warlock
├─ Champion (Elite)             ├─ Toxicant
└─ Berserker                    ├─ Sniper
                                ├─ Shade (Elite)
                                └─ Boss
```

### Enemy Squad Sizes (Match Player 3-4 Units)

```
Wave 1-2 (Tutorial):     1-2 enemies (teach positioning)
Wave 3-4 (Mid-Mission):  2-3 enemies (test strategy)
Wave 5 (Challenging):    2-3 enemies (demand mastery)
Wave 6 (Boss):           1 boss + 0-2 adds
```

---

## WAVE COMPOSITION TEMPLATES

### WAVE 1-2: TUTORIAL SQUADS (1-2 Enemies)

#### Template A: Solo Weak Enemy
```
COMPOSITION: 1 Scout
POSITION: Front or Back (irrelevant)
HP: 12
PURPOSE: Teach "damage reduces enemy HP" mechanic

PLAYER SQUAD (Example):
Champion (30 HP) + Marcus (25 HP) + Livia (22 HP)

ENEMY TACTICS:
- Scout uses basic "Slash" (70% chance)
- Dies in 1-2 hits
- Teaches: Targeting, basic damage

DIFFICULTY: ★☆☆ (Trivial)
EXPECTED OUTCOME: Perfect Victory
```

#### Template B: Weak Pair
```
COMPOSITION: 2 Scouts (each 12 HP)
POSITION: Front + Back (Scout 1 front, Scout 2 back)
SYNERGY: None (just weak numbers)
PURPOSE: Teach positioning blocking

ENEMY TACTICS:
- Back Scout tries to "Retreat" to avoid damage
- Front Scout uses "Slash" defensively
- Both die easily (2-3 hits each)

DIFFICULTY: ★☆☆ (Easy)
EXPECTED OUTCOME: Perfect Victory
```

---

### WAVE 3-4: TACTICAL SQUADS (2-3 Enemies)

#### Template C: Tank + Damage (AEGIS Classic)
```
COMPOSITION: 1 Shieldbearer + 1 Bruiser
POSITIONS:
  - Shieldbearer (front row, tanks)
  - Bruiser (back row, deals damage)
SYNERGY: Shieldbearer protects Bruiser while it damages

STATS:
- Shieldbearer: 25 HP, 8 Armor (tanks hits)
- Bruiser: 24 HP, 3 Armor (outputs damage)

ENEMY TACTICS:
- Shieldbearer: "Protect" → redirect next attack to self (if Bruiser low)
- Shieldbearer: "Fortify" → gain Armor (if self Armor < 3)
- Bruiser: "Armor Break" → strip player Armor (if player has >6)
- Bruiser: "Heavy Blow" → basic attack

AI DECISION TREE:
Priority 1: If Bruiser at <30% HP → Shieldbearer uses "Protect"
Priority 2: Shieldbearer keeps Armor high (self-preservation)
Priority 3: Bruiser pressures player (focus damage on weaker player unit)

COUNTER-PLAY:
✓ Ignore Shieldbearer, focus fire Bruiser
✓ Use armor-stripping cards to make Bruiser vulnerable
✓ Weaken Shieldbearer first, then burst Bruiser

DIFFICULTY: ★★☆ (Medium)
EXPECTED OUTCOME: Partial Victory or Perfect Victory
INJURY RISK: 20% chance (if Bruiser kills a player unit)
```

#### Template D: Bleed Stack (ECLIPSE Offensive)
```
COMPOSITION: 1 Bloodletter + 1 Berserker + 1 Sniper
POSITIONS:
  - Bloodletter (front, applies Bleeding)
  - Berserker (front/middle, high damage)
  - Sniper (back, targets weakest)
SYNERGY: Bloodletter stacks Bleeding → Berserker exploits → Sniper finishes

STATS:
- Bloodletter: 18 HP, 0 Armor (fragile, deadly)
- Berserker: 22 HP, 0 Armor (glass cannon)
- Sniper: 16 HP, 0 Armor (fragile but high damage)

ENEMY TACTICS:
- Bloodletter: "Open Wound" → apply Bleeding 3 (setup)
- Bloodletter: "Twist the Knife" → damage = Bleeding × 2 (payoff)
- Berserker: "Rage" → apply Enraged 3 (goes first turn usually)
- Berserker: "Reckless Strike" → 12 damage (with Enraged, massive threat)
- Sniper: "Snipe" → 8 damage to lowest HP (execution)

AI DECISION TREE:
Priority 1: Bloodletter applies Bleeding if not present
Priority 2: Berserker uses "Rage" to buff (if not Enraged)
Priority 3: Berserker deals "Reckless Strike" (exploit Enraged buff)
Priority 4: Sniper targets lowest HP player (execute weakest)
Priority 5: Bloodletter uses "Twist the Knife" if Bleeding stacked

COUNTER-PLAY:
✓ Burst Bloodletter first (prevent Bleeding setup)
✓ Keep Berserker at distance (prevent "Reckless Strike")
✓ Use cleanse to remove Bleeding
✓ Keep all player units above 40% HP (avoid Sniper execution)

DIFFICULTY: ★★★ (Hard)
EXPECTED OUTCOME: Partial Victory (1-2 units injured)
INJURY RISK: 40% chance (high burst damage)
```

#### Template E: Poison Stack (SPECTER Control)
```
COMPOSITION: 1 Toxicant + 1 Warlock + 1 Shade (Elite)
POSITIONS:
  - Toxicant (front, stacks Poison)
  - Warlock (back, heals allies + debuffs)
  - Shade (back, scales Poison damage)
SYNERGY: Toxicant/Shade stack Poison → Warlock keeps them alive → Shade deals Poison damage

STATS:
- Toxicant: 20 HP, 2 Armor
- Warlock: 18 HP, 3 Armor
- Shade (Elite): 32 HP, 4 Armor

ENEMY TACTICS:
- Toxicant: "Envenom" → apply Poison 3 (setup)
- Toxicant: "Plague Strike" → spread Poison to entire squad (area)
- Warlock: "Curse" → apply Weakened 3 (debuff player)
- Warlock: "Dark Mend" → heal ally 8 HP (support)
- Shade: "Virulent Touch" → apply Poison 4 (high stack)
- Shade: "Plague Burst" → damage = Poison × 2 (payoff)

AI DECISION TREE:
Priority 1: Warlock heals if any ally <40% HP
Priority 2: Toxicant applies Poison if not present
Priority 3: Shade applies high Poison stack ("Virulent Touch")
Priority 4: Shade deals "Plague Burst" if Poison >= 3
Priority 5: Warlock debuffs ("Curse") if no current Weakened

COUNTER-PLAY:
✓ Burst Warlock first (stops healing)
✓ Use cleanse constantly (Poison + Weakened removal)
✓ Play AEGIS faction (healing defense)
✓ Kill Toxicant second (stops Poison application)

DIFFICULTY: ★★★ (Hard)
EXPECTED OUTCOME: Partial Victory (1-2 units injured)
INJURY RISK: 30% chance (control-based, less burst)
```

---

### WAVE 5: ELITE SQUADS (2-3 Enemies)

#### Template F: Mixed Faction Elite
```
COMPOSITION: 1 Champion (AEGIS Elite) + 1 Assassin (ECLIPSE Elite) + 1 Warlock
POSITIONS:
  - Champion (front, tanks)
  - Assassin (front/back, high burst)
  - Warlock (back, support)
SYNERGY: Champion tanks → Assassin executes weakened targets → Warlock keeps Assassin alive

STATS:
- Champion (Elite): 40 HP, 10 Armor (durable)
- Assassin (Elite): 28 HP, 0 Armor (glass cannon)
- Warlock: 18 HP, 3 Armor (support)

ENEMY TACTICS:
- Champion: "Second Wind" → restore 15 HP (if <50%, self-heal)
- Champion: "Fortress Stance" → gain 8 Armor, apply Weakened 2
- Assassin: "Execute" → 15 damage (kill target, restore 12 HP)
- Assassin: "Vital Strike" → 8 damage, apply Bleeding 3
- Warlock: "Dark Mend" → heal Assassin 8 HP (priority)

AI DECISION TREE:
Priority 1: Warlock heals if Assassin <40% HP (keep deleter alive)
Priority 2: Assassin targets lowest HP player (execution)
Priority 3: Champion tanks (gain Armor, protect squad)
Priority 4: Assassin uses "Vital Strike" if setup needed

COUNTER-PLAY:
✓ Burst Warlock (stop healing support)
✓ Keep all units above 40% HP (avoid Assassin Execute)
✓ Use armor-piercing on Champion
✓ Focus fire Assassin while Warlock is dead

DIFFICULTY: ★★★★ (Very Hard)
EXPECTED OUTCOME: Partial Victory (1-2 units seriously injured)
INJURY RISK: 50% chance (elite composition)
```

---

### WAVE 6: BOSS ENCOUNTERS (1 Boss + 0-2 Adds)

#### Template G: Boss Solo
```
COMPOSITION: 1 Boss (no adds)
POSITION: Any (center, fills entire arena)
PURPOSE: Pure endurance test

BOSS STATS (Examples):
- AEGIS Boss "The Bulwark": 60 HP, 10 Armor, slow but durable
- ECLIPSE Boss "The Reaper": 60 HP, 5 Armor, fast and dangerous
- SPECTER Boss "The Hollow King": 60 HP, 5 Armor, control-focused

BOSS TACTICS (Phase 1-3):
- Phase 1 (100-60% HP): Basic attacks, 1 summon every 3 turns
- Phase 2 (60-30% HP): Enraged 3 (permanent), uses AoE more
- Phase 3 (30-0% HP): Ultimate ability (faction-specific), attacks twice per turn

COUNTER-PLAY:
✓ Phase 1: Build resources, learn patterns
✓ Phase 2: Focus DPS, avoid Enraged damage
✓ Phase 3: Setup for kill, use ultimate defensive card

DIFFICULTY: ★★★★★ (Extreme)
EXPECTED OUTCOME: Partial Victory (1-3 units seriously injured)
INJURY RISK: 60% chance (boss damage output)
```

#### Template H: Boss + Adds
```
COMPOSITION: 1 Boss + 2 common/tactical enemies
POSITION: Boss (center/back), Adds (front/flanking)
PURPOSE: Managing adds while dealing with boss

EXAMPLE: "The Bulwark" (AEGIS Boss) + 2 Shieldbearer adds
- Boss focuses on primary threat (usually Champion)
- Adds (Shieldbearer) protect each other and Boss
- Forces player to multitask: damage boss vs clear adds

ADD TACTICS:
- Adds prioritize protecting Boss or high-HP allies
- Adds use simplified AI (not full elite patterns)
- Adds typically die in 2-3 hits

COUNTER-PLAY:
✓ Clear adds first (simplifies fight)
✓ Ignore adds, rush boss (risky but possible)
✓ Use AoE to hit boss + adds simultaneously

DIFFICULTY: ★★★★☆ (Very Hard)
EXPECTED OUTCOME: Partial Victory (1-2 units injured)
INJURY RISK: 40% chance (add management reduces pressure)
```

---

## SQUAD-AWARE AI DECISION SYSTEM

### New Squad Decision Priorities

Enemies now consider **team health**, not just themselves.

```
DECISION TREE (Every Enemy Turn):
═════════════════════════════════════════════════════════════════

1. CHECK ALLY HEALTH (NEW FOR SQUADS):
   IF any allied unit at <30% HP:
     → Use healing/protection ability
   ELSE: Continue to next check

2. CHECK SURVIVAL THRESHOLD:
   IF self HP < 30%:
     → Use defensive/escape ability
   ELSE: Continue

3. CHECK HIGH-VALUE TARGETS:
   IF any player unit below 40% HP:
     → Use execution/burst ability
   ELSE: Continue

4. CHECK SETUP CONDITIONS:
   IF player has 0 Bleeding/Poison/Weakened:
     → Use setup ability (apply status)
   ELSE: Continue

5. CHECK PAYOFF CONDITIONS:
   IF player has 3+ Bleeding/Poison:
     → Use payoff ability (damage scaling)
   ELSE: Continue

6. DEFAULT: Use basic attack
```

### Example: Shieldbearer Squad-Aware AI

**Original (1v1) AI:**
```
Priority 1: If ally at <30% HP → Use "Protect"
Priority 2: If self Armor < 3 → Use "Fortify"
Priority 3: Default → Use "Shield Bash"
```

**Updated (Squad) AI:**
```
Priority 1: If ANY allied Bloodletter at <30% HP → "Protect" + position to cover
Priority 2: If ANY allied Warlock knocked down → "Fortify" to protect them
Priority 3: If multiple allies low HP → "Fortify" (self-preserve team)
Priority 4: Default → "Shield Bash"
```

### Example: Warlock Squad-Aware AI

**Original (1v1) AI:**
```
Priority 1: If player not Weakened → Use "Curse"
Priority 2: If ally HP < 40% → Use "Dark Mend"
Priority 3: Default → Use "Shadow Bolt"
```

**Updated (Squad) AI:**
```
Priority 1: If ANY allied Assassin at <40% HP → "Dark Mend" (keep damage dealer alive)
Priority 2: If ANY allied Berserker at <50% HP → "Dark Mend" (protect carry)
Priority 3: If player not Weakened → "Curse" (debuff)
Priority 4: Default → "Shadow Bolt"
```

### Example: Assassin Squad-Aware AI

**Original (1v1) AI:**
```
Priority 1: If any player unit <40% HP → "Execute"
Priority 2: If player Bleeding 3+ → "Bloodlust Strike"
Priority 3: Default → "Vital Strike"
```

**Updated (Squad) AI:**
```
Priority 1: If any allied unit <30% HP → RETREAT to back row (protect self)
Priority 2: If player unit <40% HP AND Warlock alive → "Execute" (supported)
Priority 3: If player Bleeding 3+ → "Bloodlust Strike" (payoff)
Priority 4: Default → "Vital Strike"
```

---

## SAMPLE MISSION LINEUPS

### ACT 1, MISSION 1: "Tutorial Bandit Camp"

**Wave 1:** 1 Scout (12 HP)
- Teaches: Basic damage
- Expected: Perfect Victory

**Wave 2:** 2 Scouts (12 HP each)
- Teaches: Positioning
- Expected: Perfect Victory

**Wave 3:** 1 Shieldbearer + 1 Bruiser
- Teaches: Tank protection, armor management
- Expected: Perfect Victory (or 1 Minor injury)

**Wave 4:** 1 Bloodletter + 1 Sniper
- Teaches: Status effects, Bleeding, low-HP targeting
- Expected: Perfect Victory (or 1-2 Minor injuries)

**Wave 5:** 1 Bruiser + 1 Warlock
- Teaches: Support enemies, healing management
- Expected: Partial Victory (1 Minor injury)

**Wave 6 (Boss):** 1 Boss (Weak) Solo
- Teaches: Boss mechanics, phases
- Expected: Partial Victory (1 Serious injury)

**Total Mission Injury Target:** 1-2 Minor + 1 Serious (manageable for intro)

---

### ACT 1, MISSION 5: "Bandit Stronghold"

**Wave 1:** 1 Scout + 1 Scout
- Teaches: 2v2 combat
- Expected: Perfect Victory

**Wave 2:** 1 Shieldbearer + 1 Bruiser
- Teaches: Tank vs Damage roles
- Expected: Perfect Victory

**Wave 3 (Boss):** 1 Boss + 1 Bruiser add
- Teaches: Boss + adds management
- Expected: Partial Victory (1 Serious injury)

**Total Mission Injury Target:** 0-1 Serious

---

### ACT 2, MISSION 15: "Elite Encampment"

**Wave 1:** 2 Scouts + 1 Bruiser
- Expected: Perfect Victory

**Wave 2:** 1 Shieldbearer + 1 Bloodletter
- Teaches: Tank protecting bleeders
- Expected: Partial Victory (1 Minor)

**Wave 3:** 1 Toxicant + 1 Warlock + 1 Shade (Elite)
- High control composition
- Expected: Partial Victory (1-2 Serious)

**Wave 4:** 1 Bruiser + 1 Assassin (Elite)
- High burst composition
- Expected: Partial Victory (1 Serious)

**Wave 5:** Mixed trio (Champion + Assassin + Warlock)
- Very hard elite squad
- Expected: Partial Victory (2 Serious injuries)

**Wave 6 (Boss):** 1 Boss Solo (Medium difficulty)
- Expected: Partial Victory (1-2 Serious)

**Total Mission Injury Target:** 4-6 Serious injuries (requires doctor visits or natural healing)

---

## ENEMY DIFFICULTY SCALING

### Act 1 Scaling
```
Base stats per enemy type
Missions 1-10: All enemies at base HP/Armor/Damage
```

### Act 2 Scaling
```
+20% HP per enemy
+1 damage per attack
+1 to status effect stacks
Example: Scout (12 → 14 HP), Bloodletter (18 → 22 HP)
```

### Act 3 Scaling
```
+40% HP per enemy
+2 damage per attack
+2 to status effect stacks
Example: Shieldbearer (25 → 35 HP), Assassin (28 → 39 HP)
```

---

## IMPLEMENTATION CHECKLIST

### Squad AI Updates:
- [ ] Add "check ally health first" priority to all enemy abilities
- [ ] Implement protection mechanics (Shieldbearer targets to cover)
- [ ] Implement healing priority (keep damage dealers alive)
- [ ] Update Assassin to retreat if unsupported
- [ ] Update Boss phases to summon adds strategically

### Composition System:
- [ ] Define 8-10 squad composition templates (by enemy faction)
- [ ] Map templates to wave difficulty (1, 2-3, 5-6)
- [ ] Create mission-specific enemy lineups (per Act)
- [ ] Implement random variation (prevent repetition)

### Positioning System:
- [ ] Implement front/back-row positioning
- [ ] Allow player to target back-row (no blocking for enemies)
- [ ] Enemies use positioning to protect allies
- [ ] Display positioning clearly in UI

### Testing:
- [ ] Validate each squad composition feels balanced
- [ ] Ensure squad-aware AI makes better decisions
- [ ] Test wave difficulty curve (1 easy, 6 hard)
- [ ] Verify injury rates match targets per mission

---

## INTEGRATION NOTES

### With Injury System:
- Elite squads (Champions, Assassins, Shades) should cause 2+ Serious injuries
- Boss encounters should have 40-60% injury rate
- Squad compositions force resource management (healing, cleansing)

### With Card System:
- Player must adapt deck to enemy composition
- Status cleanse cards become valuable vs SPECTER squads
- Armor-stripping cards valuable vs AEGIS squads

### With Progression:
- Early missions have weak squads (teach mechanics)
- Mid-missions have mixed squads (test strategy)
- Late missions have elite squads (demand mastery)

---

**Status:** ✅ READY FOR IMPLEMENTATION
**Next:** Update COMPLETE_PROJECT_ROADMAP.md to show all progress

