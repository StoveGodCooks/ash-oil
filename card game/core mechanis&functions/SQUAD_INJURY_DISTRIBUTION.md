# SQUAD INJURY DISTRIBUTION - SQUAD COMBAT UPDATE

> **Status:** ✅ LOCKED FOR SQUAD COMBAT
> **Version:** V1 - Squad-Optimized
> **Date:** 2026-02-20
> **Purpose:** Define how injuries distribute across 3-4 unit squads based on mission outcomes

---

## CORE PRINCIPLE

The existing two-track injury system (HP vs Injuries) applies **per-unit** in squad combat. When a mission ends with different outcomes, injury risk is distributed based on **which units were knocked out vs standing**.

---

## INJURY OUTCOMES BY MISSION RESULT

### OUTCOME A: PERFECT VICTORY ✅
**Condition:** No units knocked out, Champion at >25% HP

**Injury Risk:**
- Champion: 0% injury
- All Lieutenants: 0% injury

**Reward Bonus:**
- Morale +1 (next mission starts with +1 Mana pool)
- Gold: +10% bonus

**Status:**
```
PERFECT VICTORY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Champion: 28/30 HP ✓ Healthy
Marcus:   20/25 HP ✓ Healthy
Livia:    19/22 HP ✓ Healthy
Titus:    18/20 HP ✓ Healthy

Result: No injuries, excellent tactical execution
Morale: +1 (enjoy 1 bonus Mana start of next mission)
Gold: +10% mission bonus
```

---

### OUTCOME B: PARTIAL VICTORY ⚠️
**Condition:** 1-2 units knocked out, at least 1-2 units standing, Champion alive

**Injury Risk Distribution:**

**Knocked Out Units:** 50% chance of Serious injury each
- If already has Minor injuries: Roll 66% Serious / 33% 3rd Minor
- If healthy: Roll 50% Serious / 50% escape with 1 Minor

**Standing Units:** 0% injury (they protected the squad)

**Reward:**
- Gold: Full earned rewards
- Cards: All drops kept
- XP: Full XP to active squad

**Status:**
```
PARTIAL VICTORY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Champion: 15/30 HP ✓ Standing
Marcus:   0/25 HP ❌ KNOCKED OUT
Livia:    8/22 HP ✓ Standing (protected self)
Titus:    0/20 HP ❌ KNOCKED OUT

Injury Rolls:
Marcus (knocked out, healthy):
  Roll: 73 → Serious Injury! ("Deep Cut")
  Effect: Lose 1 HP each turn, lasts 3 missions

Titus (knocked out, healthy):
  Roll: 42 → Escapes with Minor ("Bruised Ribs")
  Effect: -2 HP start of waves, rest of expedition

Champion & Livia: 0% injury (they stood)

Rewards: 150 gold, 1 Rare gear, full XP
Morale: 0 (no change, pyrrhic victory)
```

---

### OUTCOME C: STRATEGIC RETREAT 🚨
**Condition:** Player initiates retreat between waves (mid-mission abort)

**Injury Risk Distribution:**

**Downed Units (from failed wave):** 50% chance of Grave injury
- If has 0 Minor: 50% Serious / 50% escape with 1 Minor
- If has 1+ Minor: 50% chance Serious → Grave (coin flip on previous serious)

**Standing Units:** 25% chance of Minor injury (from intense final wave)
- Risk simulates "barely escaped alive" scenario

**Reward:**
- Gold: Keep 60% of earned rewards (no bonus)
- Cards: Drops from completed waves kept
- XP: 50% XP to active units (partial credit)
- Benched units: 0% XP (they didn't participate)

**Status:**
```
STRATEGIC RETREAT (Wave 3 / 6)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Champion: 12/30 HP ✓ Standing
Marcus:   0/25 HP ❌ KNOCKED OUT
Livia:    7/22 HP ✓ Standing
Titus:    5/20 HP ✓ Standing

Injury Rolls (on retreat):
Marcus (downed, no injuries yet):
  Roll: 68 → Serious Injury! ("Fractured Ribs")
  Effect: -20% max HP (25→20), lasts 3 missions

Livia (standing, escape check):
  Roll: 19 → Minor Injury! ("Winded")
  Effect: -1 Stamina first turn each wave, expedition-scoped

Champion & Titus (standing, no roll for retreat fear):
  0% injury risk

Rewards:
  - Gold: 120 earned → Keep 72 gold (60%)
  - Cards: 1 Rare gear from Wave 2
  - XP: 50% to Champion/Marcus/Livia
  - Benched unit: 0% XP

Morale: 0 (strategic decision, no penalty)
```

---

### OUTCOME D: TOTAL WIPE 🚨🚨
**Condition:** All units knocked out in same wave

**Injury Risk:**

**All Units:** 1 Serious injury GUARANTEED
- Cannot be avoided or rolled
- Applies even to units that were protecting

**Morale Penalty:** -2 Morale
- Next mission starts with -2 Mana pool
- Affects morale-based story events (stress +1, bond relationships strained)

**Reward:**
- Gold: 50% of earned before wipe
- Cards: Half the drops (random selection)
- XP: 25% XP to all units (barely survived)

**Status:**
```
TOTAL WIPE (Wave 4 / 6)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Champion: 0/30 HP ❌ KNOCKED OUT
Marcus:   0/25 HP ❌ KNOCKED OUT
Livia:    0/22 HP ❌ KNOCKED OUT
Titus:    0/20 HP ❌ KNOCKED OUT

ALL UNITS DOWN = TOTAL WIPE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Injury Assignment (AUTOMATIC):
Champion: Serious Injury ("Concussion")
  Effect: 50% chance discard random card per turn, 3 missions

Marcus: Serious Injury ("Torn Muscle")
  Effect: All attacks deal -2 damage, 3 missions

Livia: Serious Injury ("Deep Cut")
  Effect: Lose 1 HP each turn, 3 missions

Titus: Serious Injury ("Broken Leg")
  Effect: Back-line only, movement cards +1 cost, 3 missions

Morale: -2 (massive squad failure)
  Next mission: Start with Mana pool -2 (not +1, but -2 from base)

Rewards:
  - Gold: 240 earned → Keep 120 gold (50%)
  - Cards: 2 Rare gear (half of 4)
  - XP: 25% to all units

RECOVERY PATH:
Option 1: Natural healing (3 missions benched = very slow)
Option 2: Doctor Advanced (180-240 gold total = expensive)
Option 3: Shaman Blood Price (3 units × 10% = units much weaker)
Option 4: Push forward injured (extremely risky)
```

---

## INJURY ESCALATION IN SQUAD CONTEXT

### Per-Unit Escalation (Existing System, Adapted)

**Single Unit Knockdown Track:**
```
Knockdown 1: 1 Minor injury
Knockdown 2: 1 More Minor (now 2 total)
Knockdown 3: 66% Serious / 33% 3rd Minor
Knockdown 4+: Serious → Grave (automatic)
```

**Squad Context:** Each unit tracks independently
- Champion can have Serious while Marcus has Minor
- Livia can have 2 Minors while Titus has none
- Example: Marcus knocked out twice in Expedition Y (now has 2 Minor injuries)
- But Livia only knocked out once (has 1 Minor injury)
- They escalate independently, not together

### Cumulative Risk Example

```
MISSION: Bandit Camp (6 waves)

WAVE 1: All units take damage
  - Champion at 50% HP
  - Marcus at 60% HP
  - Livia at 40% HP
  - Titus at 80% HP
  (No knockdowns yet)

WAVE 2: Enemies focus fire
  - Champion: 0/30 HP ❌ Knockdown 1 → 1 Minor ("Bruised Ribs")
  - Marcus: Healthy
  - Livia: Healthy
  - Titus: Healthy

WAVE 3: Enemy burst combo
  - Champion: Recovering (2 Minor now) ⚠️⚠️
  - Marcus: 0/25 HP ❌ Knockdown 1 → 1 Minor ("Strained Arm")
  - Livia: Healthy
  - Titus: Healthy

WAVE 4: Targeted assault
  - Champion: 0/30 HP ❌ Knockdown 3 → Roll 44 → Escapes (3rd Minor instead)
  - Marcus: Healthy (didn't get hit again)
  - Livia: Healthy
  - Titus: 0/20 HP ❌ Knockdown 1 → 1 Minor ("Winded")

WAVE 5: High-damage phase
  - Champion: Still has 3 Minors (hasn't been hit again)
  - Marcus: Still has 1 Minor
  - Livia: Healthy
  - Titus: Has 1 Minor

WAVE 6: Final boss
  - Champion: 0/30 HP ❌ Knockdown 4 → Serious Injury! ("Fractured Ribs")
  - Marcus: Survives
  - Livia: Survives
  - Titus: 0/20 HP ❌ Knockdown 2 → 1 More Minor (now 2 total)

END MISSION RESULT: Partial Victory
  - Champion: 1 Serious Injury (needs 50-80 gold treatment or 1 mission rest)
  - Marcus: 1 Minor Injury
  - Livia: Healthy
  - Titus: 2 Minor Injuries ⚠️⚠️ (one more knockdown = Serious risk)
```

---

## MORALE SYSTEM

### Morale Tracking

**Starting Morale:** 0
**Range:** -3 to +3

**Morale Effects:**

```
Morale +3: All units start missions with +2 Mana pool
Morale +2: All units start missions with +1 Mana pool
Morale +1: Champion starts with +1 Mana
Morale 0:  No effect
Morale -1: Champion starts with -1 Mana
Morale -2: All units start missions with -1 Mana pool
Morale -3: All units start missions with -2 Mana pool + stress events trigger
```

### Morale Changes

**Morale +1 (Perfect Victory):**
- Triggers after any mission with zero knockouts
- "Squad executed flawlessly"
- Visible squad morale boost (dialogue/scene)

**Morale -1 (Total Wipe):**
- Triggered automatically on total wipe
- "The squad was completely overwhelmed"
- Triggers story consequence (stress on protagonists, bond tension)

**Morale -2 (Story Events):**
- Can be triggered by critical story moments
- Example: Losing a key ally, failing an important contract
- Requires explicit story trigger

**Morale +2 (Rare Victories):**
- Perfect run through hard mission (6 waves, 0 injuries) = +2 morale
- OR consecutive Perfect victories (3 in a row)

### Morale and Story Integration

```
High Morale (+2/+3):
- Squad is confident, takes risks
- Story scenes show unity
- Bond events more likely
- "We can handle anything" attitude

Low Morale (-2/-3):
- Squad is afraid, hesitant
- Story scenes show tension
- Conflict events possible
- Arguments between characters
- Stress penalties on personality stats
```

---

## SQUAD-SPECIFIC INJURY MECHANICS

### Benched Units During Mission

**Benched Lieutenant (not in active squad):**
- Does NOT participate in combat
- Does NOT take injuries from battle outcomes
- Earns 50% XP if mission completed
- Earns 0% XP if mission failed/retreat

**Example:**
```
MISSION: Ranger's Hideout
Active Squad: Champion + Marcus + Livia
Benched: Titus, Kara, Decimus

Outcome: Total wipe (all active units knocked out)

Injury Assignment:
- Champion: Serious injury (from wipe)
- Marcus: Serious injury (from wipe)
- Livia: Serious injury (from wipe)
- Titus: SAFE (benched, didn't fight)
- Kara: SAFE (benched, didn't fight)
- Decimus: SAFE (benched, didn't fight)

Available for next mission: Titus, Kara, Decimus
Healing path: Swap in benched units while Champion/Marcus/Livia recover
```

---

## HUB HEALING (Adapted for Squad)

### Natural Healing (Free)

**Minor Injury:**
- Sit out 1 mission
- Unit unavailable for that mission only
- After that mission: fully healed

**Serious Injury:**
- Sit out 3 missions
- Unit unavailable for Missions X, X+1, X+2
- After 3rd mission: fully healed

**Strategy in Squad:**
```
Mission 5: Champion gets Serious injury
Healing option: Sit out Missions 6, 7, 8
Active squad: Backup Champion (if exists) or just 3 Lieutenants
After Mission 8: Champion rejoins, fully healed
```

### Doctor Treatment (Gold Cost)

**Minor Injury:** 20-30 gold
- Instant or 1 mission
- Unit ready immediately next mission

**Serious Injury:** 50-80 gold
- Mandatory 1 mission rest (even with gold)
- After that mission: fully healed
- Example: Pay 60 gold → Sit out Mission 6 → Ready Mission 7

### Shaman Blood Price (Permanent)

**Cost:** 10% max HP permanently
- AEGIS Champion: 30 → 27 HP forever
- ECLIPSE Marcus: 25 → 22 HP forever
- SPECTER Livia: 22 → 20 HP forever

**Benefit:** Instant healing (no mission rest required)

**Squad Strategy:**
```
Have injured unit in multiple serious injuries?
Example: Marcus has 2 Serious injuries from different missions
Option 1: Pay Doctor 160 gold (80 × 2)
Option 2: Pay Shaman 2× blood price (-2 HP each = -4 HP total)
Option 3: Sit benched 6 missions (3 per injury)
Option 4: Mix (pay Shaman once, natural healing once)
```

---

## INJURY DISTRIBUTION AT MISSION END

### Decision Matrix

```
WHO WAS KNOCKED OUT?        INJURED PARTIES?               MORALE?
═════════════════════════════════════════════════════════════════════
Nobody                   → Nobody injured, full rewards   +1 Morale
                         → Perfect Victory

1-2 Units              → KO'd units 50% Serious risk    0 Morale
                         → Standing safe                 (no change)
                         → Partial Victory

Everyone               → All get 1 Serious guaranteed   -1 Morale
                         → 50% gold, half drops
                         → Total Wipe

Player-initiated       → Standing 25% Minor risk        0 Morale
Retreat                → Downed 50% Serious risk
                         → 60% gold, affected XP
```

---

## BALANCE TARGETS

### Mission-by-Mission Injury Goals

**Easy Missions (★☆☆):**
- 80% chance: 0 injuries, Perfect Victory
- 20% chance: 1 Minor injury, Partial Victory
- <1% chance: Serious injury (player error)

**Medium Missions (★★☆):**
- 40% chance: 0 injuries, Perfect Victory
- 50% chance: 1-2 Minor injuries, Partial Victory
- 10% chance: 1 Serious injury, Partial Victory

**Hard Missions (★★★):**
- 20% chance: 0 injuries, Perfect Victory
- 50% chance: 1-3 Minor injuries, Partial Victory
- 25% chance: 1-2 Serious injuries, Partial Victory
- 5% chance: Total Wipe, Serious injuries

---

## IMPLEMENTATION CHECKLIST

### Core Mechanics:
- [ ] Per-unit knockdown counter (tracks escalation independently)
- [ ] Outcome detection system (Perfect/Partial/Retreat/Wipe)
- [ ] Injury distribution logic (roll % based on outcome)
- [ ] Morale system (track -3 to +3, apply Mana penalties/bonuses)

### Injury Rolls:
- [ ] Perfect Victory: 0% all units
- [ ] Partial Victory: 50% Serious for KO'd, 0% for standing
- [ ] Retreat: 50% Serious for downed, 25% Minor for standing
- [ ] Total Wipe: 100% Serious (guaranteed)

### Morale Changes:
- [ ] Perfect Victory: +1 Morale
- [ ] Total Wipe: -1 Morale
- [ ] Apply Mana pool adjustments based on morale level
- [ ] Trigger story events on Morale extremes (-2/-3)

### UI Elements:
- [ ] Show per-unit knockdown count during mission
- [ ] Display morale after mission end
- [ ] List which units will be injured
- [ ] Show healing options for injured units at hub

---

## SUMMARY

**Perfect Victory (0 KOs):** Zero injuries, +1 Morale, full rewards, confidence boost

**Partial Victory (1-2 KOs):** KO'd units risk Serious (50%), standing safe, normal morale

**Strategic Retreat:** Both sides take injury risk (downed 50% Serious, standing 25% Minor), 60% gold, normal morale

**Total Wipe (All KOs):** All Serious guaranteed, -1 Morale, 50% gold, catastrophic

---

**Status:** ✅ READY FOR IMPLEMENTATION
**Next:** Design Enemy Squad Archetypes and update roadmap

