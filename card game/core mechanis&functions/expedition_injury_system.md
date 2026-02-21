# Expedition Injury System - Two-Track Health Design

> **Version:** V2 - Expedition-Based  
> **Replaces:** Hub-based single duel injury system  
> **Core Principle:** HP heals between waves, Injuries persist and compound

---

## The Core Problem (Solved)

**Original Issue:**
- Expeditions have 3-6 waves with rest opportunities between waves
- If HP fully heals between waves, where's the tension?
- If injuries heal between waves, what's the consequence of getting knocked out?

**Solution:**
- **Two separate tracks:** HP (short-term combat resource) vs Injuries (long-term consequences)
- HP can be restored between waves (30% or 70%)
- Injuries persist entire expedition and create compounding difficulty

---

## Two-Track Health System

### Track 1: HP (Combat Health)

**What it is:**
- Your health bar during combat encounters
- Starts at max (faction-specific: AEGIS 30, ECLIPSE 20, SPECTER 25)
- Goes down when taking damage in combat
- Regenerates partially between waves (via resting)

**When it hits 0:**
- Unit is **knocked out** for remainder of that wave
- Cannot act for rest of encounter
- May gain an **Injury** (see Track 2)
- Can be revived between waves (HP restored via rest)

**Healing sources:**
- Quick Rest: +30% max HP
- Full Rest: +70% max HP
- Consumables: Variable (potions, bandages)

---

### Track 2: Injury Track (Real Damage)

**What it is:**
- Separate from HP—represents lasting harm and battle scars
- Does NOT heal between waves (persists entire expedition)
- Only heals at hub after expedition ends (Doctor/Shaman services)
- Creates mechanical penalties that compound over waves

**When you gain injuries:**
- HP drops to 0 (unit knocked out in combat)
- Critical hits from enemies (rare, telegraphed "⚠️ CRITICAL STRIKE incoming")
- Failing to block devastating attacks
- Taking damage while already at very low HP (<30%)
- Environmental hazards (special mission mechanics)

**Key rule:** Injuries create **expedition-scoped debuffs** that make subsequent waves harder.

---

## Injury Severity Tiers

### Tier 1: Minor Wounds

**Duration:** Rest of expedition + until healed at hub

**Mechanical Effects (active during expedition):**
- **"Bruised Ribs"** — Start each wave with -2 HP
- **"Strained Arm"** — One random card costs +1 Stamina
- **"Dazed"** — Draw -1 card at start of first turn each wave
- **"Twisted Ankle"** — Movement/positioning cards cost +1 Stamina
- **"Shallow Cut"** — Take 1 additional damage from first attack each wave
- **"Winded"** — Start each wave with -1 Stamina first turn
- **"Shaken"** — First status effect applied to you each wave has +1 duration
- **"Fatigued"** — Armor gained reduced by 1 (minimum 0)

**Healing options (at hub after expedition):**

**Option A: Natural Healing (Free)**
- Sit out 1 mission
- Unit unavailable for next mission
- After that mission ends, injury fully heals

**Option B: Doctor Treatment (20-30 gold)**
- Pay at hub
- Instant heal
- Unit ready for next mission immediately

---

### Tier 2: Serious Injuries

**Duration:** Rest of expedition + 3 missions (or until treated)

**Mechanical Effects (more severe):**
- **"Broken Leg"** — All movement cards cost +1 Stamina, positioned in back line only
- **"Deep Cut"** — Lose 1 HP at start of each turn (during combat)
- **"Concussion"** — 50% chance to discard random card at start of each turn
- **"Fractured Ribs"** — Max HP reduced by 20% (25→20 HP)
- **"Torn Muscle"** — All Attack cards deal -2 damage
- **"Internal Bleeding"** — Start each wave with Bleeding 2 (auto-applied)
- **"Dislocated Shoulder"** — Cannot play cards costing 3+ Stamina
- **"Severe Trauma"** — Start each combat with Weakened 2

**How acquired:**
- Get knocked out while already having 2+ Minor injuries
- 66% chance of Serious (33% chance of 3rd Minor instead)

**Warning appears:**
⚠️⚠️ **"Lt. Marcus: 2 Minor injuries—one more knockdown risks SERIOUS INJURY"**

**Healing options (at hub):**

**Option A: Natural Healing (Free, Slow)**
- Sit out 3 missions
- After 3rd mission ends, injury fully heals

**Option B: Doctor Advanced Treatment (50-80 gold)**
- Pay at hub
- Sit out 1 mission (mandatory rest even with payment)
- After that mission, injury heals
- **Total: 1 mission rest + gold cost**

**Option C: Shaman Blood Price (Risky)**
- Pay 10% max HP **permanently** (25 HP → 22 HP forever)
- Instant heal, no mission rest required
- Unit ready immediately but weaker forever
- **Trade-off:** Permanent HP reduction

---

### Tier 3: Grave Injuries (PERMANENT)

**Duration:** Forever (NEVER heals)

**Mechanical Effects (permanent character scars):**
- **"Lost Eye"** — -1 damage to all Attack cards permanently
- **"Bad Knee"** — -2 max HP forever (25 HP → 23 HP)
- **"Shattered Ribs"** — Start each mission with -3 HP (every mission, forever)
- **"Nerve Damage"** — One random card type costs +1 Stamina permanently
- **"Mangled Hand"** — Cannot play cards costing 4 Stamina
- **"Chronic Pain"** — 25% chance each turn to lose 1 Stamina
- **"Crippled Arm"** — All buff/support cards 50% effective (rounded down)
- **"Scarred Lungs"** — Draw -1 card permanently (hand size 7 instead of 8)

**How acquired:**
- Get knocked out while having a Serious injury
- **Automatic** Grave Injury (no roll, guaranteed)
- Requires ignoring multiple warnings

**Warning appears:**
🚨 **"CRITICAL: Lt. Kira has SERIOUS INJURY—next knockdown = GRAVE INJURY (PERMANENT)"**

**Before potentially fatal knockdown:**
```
🚨 GRAVE INJURY WARNING 🚨
Lt. Marcus will suffer PERMANENT INJURY if knocked out.
This NEVER heals and weakens the unit forever.

Are you sure you want to continue this expedition?
[ Yes, I understand the risk ]
[ No, retreat now and cut losses ]
```

**Healing:**
- **None.** These are permanent scars from reckless play.
- Unit remains usable but permanently weaker
- Can compensate with gear/strategy
- Creates "scarred veteran" narrative

---

## Injury Escalation During Expeditions

### Progression Path:

```
Healthy
   ↓ (knocked out once)
1 Minor Injury
   ↓ (knocked out again)
2 Minor Injuries ⚠️ WARNING
   ↓ (knocked out third time - 66% chance)
Serious Injury ⚠️⚠️ DANGER
   ↓ (knocked out fourth time - 100% chance)
Grave Injury 🚨 PERMANENT
```

### Detailed Rules:

**First knockdown (0 HP reached):**
- Gain 1 Minor Wound (random from pool)
- Unit stays down for remainder of that wave
- Can be revived between waves (HP restored via rest)
- Injury effect applies to all subsequent waves

**Second knockdown (while having 1 Minor):**
- Gain 1 more Minor Wound (now has 2 Minor total)
- ⚠️ **Warning appears:** "Lt. Marcus: 2 injuries—one more knockdown risks SERIOUS INJURY"
- Player is explicitly informed of escalation risk

**Third knockdown (while having 2+ Minor):**
- **Roll:** 66% chance Serious Injury, 33% chance 3rd Minor
- If Serious: Replace all Minors with 1 Serious (consolidate)
- ⚠️⚠️ **Danger warning:** "Lt. Marcus: SERIOUS INJURY—further damage risks GRAVE INJURY (PERMANENT)"
- Game strongly recommends retreat

**Fourth knockdown (while having Serious):**
- **Automatic** Grave Injury (no roll, guaranteed)
- Serious Injury becomes Grave Injury
- 🚨 **Critical alert** before wave starts if unit is at risk
- Explicit confirmation required to continue expedition

---

## Example Expedition with Injury System

### Mission 5: "Bandit Stronghold" (6 waves)

**Starting Roster:**
```
[Champion - AEGIS]
HP: 30/30 (100%)
Injuries: None
Status: ✓ Healthy

[Lt. Marcus - ECLIPSE]
HP: 25/25 (100%)
Injuries: None
Status: ✓ Healthy

[Lt. Kira - ECLIPSE]
HP: 25/25 (100%)
Injuries: None
Status: ✓ Healthy

Supplies: 3
```

---

#### **WAVE 1: Outer Sentries**

**Enemies:** 3 weak ECLIPSE (12 HP each)

**Combat result:**
- Champion: 22/30 HP (took some hits)
- Lt. Marcus: 18/25 HP (moderate damage)
- Lt. Kira: 0/25 HP ❌ **KNOCKED OUT** (first knockdown)

**Injury roll:**
```
Lt. Kira knocked out!
Rolling for injury... 

INJURY GAINED: "Bruised Ribs" (Minor)
Effect: Start each wave with -2 HP for rest of expedition
```

**Wave cleared:** +15 gold

---

**DECISION POINT 1:**

```
WAVE 1 COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Rewards: 15 gold

UNIT STATUS:
[Champion] 22/30 HP - Healthy
[Lt. Marcus] 18/25 HP - Healthy  
[Lt. Kira] 0/25 HP ❌ - Bruised Ribs (Minor)

Supplies: 3

NEXT WAVE: Main Camp (3 enemies, moderate difficulty)

CHOOSE ACTION:
[ Push Forward ] - No healing, save supplies
[ Quick Rest - 1 Supply ] - Restore 30% HP
[ Full Rest - 2 Supplies ] - Restore 70% HP, random event
[ Retreat ] - Abort, keep 15 gold
```

**Player chooses: QUICK REST (1 supply)**

**Healing calculation:**
- Champion: 22 → 27 HP (30% of 30 = +9 HP, capped at max)
- Lt. Marcus: 18 → 23 HP (30% of 25 = +7.5 → +7 HP)
- Lt. Kira: 0 → 5 HP (30% of 25 = 7.5 → 7 HP, **minus 2 from Bruised Ribs** = 5 HP)

**Supplies: 2 remaining**

---

#### **WAVE 2: Main Camp**

**Enemies:** 2 AEGIS tanks + 1 ECLIPSE assassin (20 HP each)  
**Terrain:** "Defensive Position" - Enemies start with +3 Armor

**Starting HP (after Quick Rest):**
```
[Champion] 27/30 HP - Healthy
[Lt. Marcus] 23/25 HP - Healthy
[Lt. Kira] 5/25 HP - Bruised Ribs (already weakened!)
```

**Combat result:**
- Champion: 19/30 HP (tanking front line)
- Lt. Marcus: 0/25 HP ❌ **KNOCKED OUT** (first knockdown for Marcus)
- Lt. Kira: 3/25 HP (barely survived)

**Injury rolls:**
```
Lt. Marcus knocked out!
Rolling for injury...

INJURY GAINED: "Sprained Ankle" (Minor)
Effect: Movement cards cost +1 Stamina for rest of expedition
```

**Wave cleared:** +20 gold (total: 35 gold)

---

**DECISION POINT 2:**

```
WAVE 2 COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Rewards: 20 gold (Total: 35 gold)

UNIT STATUS:
[Champion] 19/30 HP (63%) - Healthy
[Lt. Marcus] 0/25 HP ❌ - Sprained Ankle (Minor)
[Lt. Kira] 3/25 HP (12%) ⚠️ - Bruised Ribs (Minor)

Supplies: 2

NEXT WAVE: Supply Tent BOSS (1 elite enemy, high difficulty)

⚠️ WARNING: 2 units injured, low HP across squad
Consider: Full Rest or Retreat

CHOOSE ACTION:
[ Push Forward ] - No healing, high risk
[ Quick Rest - 1 Supply ] - Restore 30% HP
[ Full Rest - 2 Supplies ] - Restore 70% HP, use all supplies
[ Retreat ] - Abort, keep 35 gold + 1 Common gear
```

**Player chooses: FULL REST (2 supplies)**

**Healing calculation:**
- Champion: 19 → 28 HP (70% of 30 = +21 HP, but only 11 needed)
- Lt. Marcus: 0 → 17 HP (70% of 25 = 17.5 → 17 HP)
- Lt. Kira: 3 → 15 HP (70% of 25 = 17.5 → 17 HP, **minus 2 from Bruised Ribs** = 15 HP)

**Random event (Full Rest):**
```
RANDOM EVENT: Ambush!
2 weak ECLIPSE scouts attack during rest!

Mini-encounter (cannot retreat):
- Champion tanks, takes 8 damage → 20/30 HP
- Squad defeats scouts
- No additional injuries (minor fight)

Ambush cleared: +5 gold bonus
```

**Supplies: 0 remaining (cannot rest again!)**

---

#### **WAVE 3: Supply Tent Boss**

**Enemy:** 1 elite SPECTER "Supply Master" (35 HP)  
**Special Mechanic:** Heals 10 HP every 3 turns unless you destroy Supply Crates (deal 15 damage to crates)

**Starting HP (after Full Rest & Ambush):**
```
[Champion] 20/30 HP (67%) - Healthy
[Lt. Marcus] 17/25 HP (68%) - Sprained Ankle (Minor)
[Lt. Kira] 15/25 HP (60%) - Bruised Ribs (Minor)
```

**Combat result:**
- Champion: 12/30 HP (took boss poison damage)
- Lt. Marcus: 0/25 HP ❌ **KNOCKED OUT AGAIN** (second knockdown)
- Lt. Kira: 8/25 HP (poisoned, low HP)

**Injury roll:**
```
Lt. Marcus knocked out!
Already has 1 Minor injury (Sprained Ankle)
Rolling for 2nd injury...

INJURY GAINED: "Dazed" (Minor)
Effect: Draw -1 card at start of first turn each wave

⚠️⚠️ WARNING ⚠️⚠️
Lt. Marcus now has 2 MINOR INJURIES:
- Sprained Ankle (movement cards +1 cost)
- Dazed (draw -1 card first turn)

ONE MORE KNOCKDOWN RISKS SERIOUS INJURY (lasting 3 missions)
Recommend: Position Marcus defensively or retreat
```

**Wave cleared:** +30 gold + Rare gear (total: 70 gold)

---

**DECISION POINT 3:**

```
WAVE 3 COMPLETE (BOSS DEFEATED)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Rewards: 30 gold + Rare gear (Total: 70 gold, 1 Rare)

UNIT STATUS:
[Champion] 12/30 HP (40%) ⚠️ - Healthy
[Lt. Marcus] 0/25 HP ❌ - 2 Minors (Sprained Ankle, Dazed) ⚠️⚠️
[Lt. Kira] 8/25 HP (32%) ⚠️ - Bruised Ribs (Minor)

⚠️⚠️ DANGER ZONE ⚠️⚠️
- No supplies remaining (cannot rest)
- Champion at 40% HP
- Marcus at critical injury risk (2 Minors)
- Kira low HP

NEXT WAVE: Inner Barracks (3 strong enemies)

STRONGLY RECOMMEND: Retreat now
Continuing risks SERIOUS INJURIES (3-mission healing time)

CHOOSE ACTION:
[ Push Forward ] - Extremely high risk, no healing possible
[ Retreat ] - Keep 70 gold + Rare gear (60% mission rewards)
```

**Player chooses: PUSH FORWARD (very risky decision)**

---

#### **WAVE 4: Inner Barracks**

**Enemies:** 1 AEGIS tank + 1 ECLIPSE assassin + 1 SPECTER controller (25 HP each)  
**Terrain:** "Cramped Quarters" - Front line units take +2 damage from all attacks

**Starting HP (no rest available):**
```
[Champion] 12/30 HP (40%) ⚠️ - Healthy
[Lt. Marcus] 0/25 HP ❌ - Cannot participate (knocked out)
[Lt. Kira] 8/25 HP (32%) ⚠️ - Bruised Ribs (Minor)
```

**Combat result:**
- Fighting 2v3 (Marcus can't act)
- Champion: 4/30 HP (barely alive, tanked everything)
- Lt. Marcus: Still 0/25 HP (unconscious)
- Lt. Kira: 0/25 HP ❌ **KNOCKED OUT** (second knockdown)

**Injury rolls:**

```
Lt. Kira knocked out!
Already has 1 Minor injury (Bruised Ribs)
Rolling for 2nd injury...

INJURY GAINED: "Strained Arm" (Minor)
Effect: One random card costs +1 Stamina each wave

⚠️⚠️ WARNING ⚠️⚠️
Lt. Kira now has 2 MINOR INJURIES:
- Bruised Ribs (start waves -2 HP)
- Strained Arm (random card +1 cost)

ONE MORE KNOCKDOWN RISKS SERIOUS INJURY
```

**Wave barely cleared:** +25 gold (total: 95 gold)

---

**DECISION POINT 4:**

```
WAVE 4 COMPLETE (BARELY)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Rewards: 25 gold (Total: 95 gold, 1 Rare gear)

UNIT STATUS:
[Champion] 4/30 HP (13%) 🚨 CRITICAL
[Lt. Marcus] 0/25 HP ❌ - 2 Minors ⚠️⚠️
[Lt. Kira] 0/25 HP ❌ - 2 Minors ⚠️⚠️

🚨🚨 CRITICAL SITUATION 🚨🚨
- Champion at 4 HP (one hit from death)
- Both Lieutenants unconscious with 2 injuries each
- No supplies (cannot rest)
- 2 waves remaining (Wave 5 + Final Boss)

CONTINUING WILL LIKELY RESULT IN:
- Champion death (mission failure)
- Serious injuries on both Lieutenants (3-mission healing)
- Possible GRAVE INJURIES if knocked out again

NEXT WAVE: Elite Guards (high difficulty)

🚨 RETREAT STRONGLY RECOMMENDED 🚨

CHOOSE ACTION:
[ Push Forward ] - Near-certain disaster
[ Retreat ] - Keep 95 gold + Rare gear (realistic choice)
```

**Player chooses: RETREAT (smart decision)**

---

### Post-Mission Results

```
MISSION FAILED - STRATEGIC RETREAT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Waves Completed: 4 / 6
Result: Retreat with rewards

REWARDS KEPT:
- Gold: 95 (waves 1-4)
- Gear: 1 Rare weapon
- XP: Partial (40% per unit)

INJURY REPORT:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Champion - AEGIS]
HP: 4/30 (will restore to 40% minimum at hub)
Injuries: None
Status: ✓ Ready for next mission

[Lt. Marcus - ECLIPSE]
HP: 0/25 (will restore to 40% minimum)
Injuries: 
  - Sprained Ankle (Minor)
  - Dazed (Minor)
Status: ⚠️ Needs healing

[Lt. Kira - ECLIPSE]
HP: 0/25 (will restore to 40% minimum)
Injuries:
  - Bruised Ribs (Minor)
  - Strained Arm (Minor)
Status: ⚠️ Needs healing

NEXT STEPS AT HUB:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Option 1: Pay Doctor (80 gold total)
  - Lt. Marcus: 40 gold → Instant heal
  - Lt. Kira: 40 gold → Instant heal
  - All units ready for Mission 6

Option 2: Natural Healing (Free)
  - Let both Lieutenants rest 1 mission
  - Deploy Champion + 2 backup Lieutenants for Mission 6
  - Marcus & Kira ready by Mission 7

Option 3: Deploy Injured (RISKY)
  - Take Marcus & Kira injured into Mission 6
  - If knocked out, risk Serious injuries (3-mission healing)
  - NOT RECOMMENDED
```

---

## Rest System with Injuries

### Between-Wave Rest Mechanics

#### **PUSH FORWARD** (Free)
- **No healing** to HP
- Injuries persist and apply their effects
- Enemies don't fortify or reinforce
- Next wave starts immediately
- **Use when:** Healthy, want speed, conserve supplies

---

#### **QUICK REST** (1 Supply)
- **Restore 30% max HP** to all units
- Injuries still reduce effective HP (applied after healing)
  - Example: 70% of 25 HP = 17.5 → 17 HP, minus 2 from "Bruised Ribs" = 15 HP starting next wave
- Remove 1 random temporary status effect from previous wave (Poison, Bleeding cleared between waves anyway)
- Enemies ahead get **+10% HP/damage** (fortification)
- Takes ~10 minutes in-game time
- **Use when:** Moderate damage, supplies available, manageable injuries

---

#### **FULL REST** (2 Supplies)
- **Restore 70% max HP** to all units
- Injuries still apply (can't heal them mid-expedition)
- Can use consumable items:
  - Healing Potion: +10 HP immediate
  - Bandage: Remove 1 Bleeding stack (usually cleared anyway between waves)
  - Antivenom: Remove all Poison (usually cleared anyway)
- **Random event triggers** (50% chance):
  - **Good (30%):** Find loot (+1 supply, +10 gold, or consumable)
  - **Bad (40%):** Ambush (small fight: 2 weak enemies, cannot retreat, might take damage/injuries)
  - **Neutral (30%):** Morale boost (+1 Stamina first turn next wave) OR nothing
- Enemies ahead get **+20% HP/damage** (heavy fortification)
- Takes ~30 minutes in-game time
- **Use when:** Badly hurt, have supplies, willing to risk event

---

#### **STRATEGIC RETREAT** (Free, abort mission)
- **Abort expedition entirely**
- Keep all gold and loot from completed waves
- All units restore to 40% HP minimum (recovery floor)
- **All units with Serious injuries roll for escalation:**
  - 50% chance Serious → Grave (permanent)
  - If you retreat with Serious injuries, it's a coin flip
- Mission marked as failed (cannot retry for better rewards)
- **Use when:** Too injured to continue, preserve veteran units, cut losses

---

## Hub Healing (After Expedition)

### Minor Injuries (Tier 1)

#### **Option A: Natural Healing (Free)**
- **Cost:** None (free)
- **Time:** Sit out 1 mission
- Unit unavailable for next mission (in medbay)
- After that mission completes, injury fully heals
- **Example:** Get injured Mission 5 → Sit out Mission 6 → Ready Mission 7

#### **Option B: Doctor Basic Treatment (20-30 gold)**
- **Cost:** 20 gold (common injury) to 30 gold (complex injury)
- **Time:** Instant
- Unit ready for next mission immediately
- **Trade-off:** Gold cost vs time cost

---

### Serious Injuries (Tier 2)

#### **Option A: Natural Healing (Free, Slow)**
- **Cost:** None (free)
- **Time:** Sit out 3 missions
- Unit unavailable for Missions X, X+1, X+2
- After 3rd mission completes, injury fully heals
- **Example:** Injured Mission 5 → Sit out 6, 7, 8 → Ready Mission 9

#### **Option B: Doctor Advanced Treatment (50-80 gold)**
- **Cost:** 50-80 gold depending on injury severity
- **Time:** Sit out 1 mission (mandatory rest even with payment)
- After that 1 mission, injury fully heals
- **Trade-off:** Expensive but cuts 3 missions → 1 mission
- **Example:** Injured Mission 5 → Pay 60 gold → Sit out Mission 6 → Ready Mission 7

#### **Option C: Shaman Blood Price (Risky, No Time Cost)**
- **Cost:** 10% max HP **permanently**
  - AEGIS: 30 → 27 HP forever
  - ECLIPSE: 20 → 18 HP forever
  - SPECTER: 25 → 22 HP forever
- **Time:** Instant, no mission rest required
- Unit ready immediately but permanently weaker
- **Trade-off:** Time vs permanent HP reduction
- **Use when:** Desperate for veteran's skills immediately, willing to accept permanent weakness

---

### Grave Injuries (Tier 3)

**NEVER HEAL.**

- Unit permanently scarred and weaker
- Can still deploy and use
- Compensate with gear, strategy, card choices
- Creates "scarred veteran" narrative (mechanical & thematic)
- **Examples:**
  - "Lost Eye" (-1 damage all attacks) → Equip high-damage weapon to compensate
  - "Bad Knee" (-2 max HP) → Equip +HP armor, play defensive
  - "Nerve Damage" (one card type +1 cost) → Rebuild deck around unaffected cards

---

## Warning System (Player Agency)

### Warning Levels

#### **Level 1: First Minor Injury**
```
INJURY SUSTAINED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Lt. Marcus has been injured!

Injury: Sprained Ankle (Minor)
Effect: Movement cards cost +1 Stamina
Duration: Rest of expedition

This injury will persist until expedition ends.
Seek medical attention at hub after mission.
```

---

#### **Level 2: Second Minor Injury (Escalation Risk)**
```
⚠️ WARNING: INJURY ESCALATION RISK ⚠️
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Lt. Marcus now has 2 MINOR INJURIES:
  - Sprained Ankle (movement +1 cost)
  - Dazed (draw -1 card first turn)

⚠️ NEXT KNOCKDOWN RISKS SERIOUS INJURY ⚠️

Serious injuries last 3 missions and require
expensive treatment (50-80 gold) or long rest.

RECOMMENDATIONS:
✓ Position Marcus in back line (safer)
✓ Use defensive cards to protect him
✓ Consider retreating if situation worsens
✓ Use supplies to rest and restore HP
```

---

#### **Level 3: Serious Injury (Critical Risk)**
```
⚠️⚠️ DANGER: SERIOUS INJURY SUSTAINED ⚠️⚠️
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Lt. Kira has sustained a SERIOUS INJURY!

Injury: Deep Cut (Serious)
Effect: Lose 1 HP at start of each turn
Duration: Rest of expedition + 3 missions

🚨 NEXT KNOCKDOWN = GRAVE INJURY (PERMANENT) 🚨

GRAVE INJURIES NEVER HEAL and permanently weaken units.

STRONGLY RECOMMEND:
🚨 Retreat immediately and cut losses
OR
🚨 Play extremely defensively
🚨 Keep Lt. Kira in back line only
🚨 Avoid all risky plays with this unit
```

---

#### **Level 4: Before Potential Grave Injury**
```
🚨🚨 GRAVE INJURY WARNING 🚨🚨
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Lt. Marcus has SERIOUS INJURY: Deep Cut

If Lt. Marcus is knocked out this wave, he will
suffer a GRAVE INJURY (PERMANENT, NEVER HEALS).

Examples of Grave Injuries:
• Lost Eye: -1 damage to all attacks FOREVER
• Bad Knee: -2 max HP FOREVER  
• Nerve Damage: One card type +1 cost FOREVER

These scars are PERMANENT and NEVER heal.

You are about to enter WAVE 5.
Lt. Marcus is currently at 8/25 HP.

Are you CERTAIN you want to continue?

[ No, retreat now ] ← RECOMMENDED
[ Yes, I understand the permanent risk ]

If you choose "Yes," Lt. Marcus will be positioned
in the back line automatically for his safety.
```

---

## Balance Targets

### Injury Rate Goals (Per Mission)

**Easy Mission (★☆☆):**
- **Target:** 0-1 Minor injuries total
- Smooth run, minimal danger
- Players learn mechanics safely
- Example: Tutorial missions, early campaign

**Medium Mission (★★☆):**
- **Target:** 1-2 Minor injuries total
- Expected outcome for balanced play
- Occasional knockdowns, manageable consequences
- Example: Mid-campaign standard missions

**Hard Mission (★★★):**
- **Target:** 2-3 Minor injuries, possible 1 Serious
- High risk, high reward
- Requires good tactics and resource management
- Example: Late-campaign, elite missions

**Grave Injuries (All Difficulties):**
- **Target:** <5% of missions should result in Grave injuries
- Only occurs when players:
  1. Ignore 2-Minor warning
  2. Continue with Serious injury
  3. Get knocked out again
- Requires 3-4 knockdowns on same unit + ignoring warnings
- Should feel like player error, not bad luck

---

### Per-Unit Knockdown Targets (6-Wave Expedition)

**Healthy Run:**
- 0-1 total knockdowns across entire squad
- No injuries or only 1 Minor
- Excellent tactical play

**Standard Run:**
- 2-3 total knockdowns across squad
- 1-2 Minor injuries
- Normal outcome

**Rough Run:**
- 4-5 total knockdowns
- 2-3 Minor injuries, maybe 1 Serious
- Still winnable but costly

**Disaster Run:**
- 6+ knockdowns
- Multiple Serious injuries or 1 Grave
- Should have retreated earlier

---

### Injury Distribution (Target %)

Across all missions in a campaign:
- **60%** - Missions completed with 0-1 Minor injuries
- **30%** - Missions completed with 2-3 Minor injuries
- **8%** - Missions completed with 1+ Serious injury
- **2%** - Missions resulting in Grave injury (player error)

---

## Injury Effect Categories

### Combat Handicaps

**HP Reduction:**
- "Bruised Ribs" — Start waves -2 HP
- "Shallow Cut" — Take +1 damage from first attack each wave
- "Deep Cut" (Serious) — Lose 1 HP/turn during combat
- "Bad Knee" (Grave) — -2 max HP permanently

**Resource Handicaps:**
- "Strained Arm" — Random card costs +1 Stamina
- "Winded" — Start waves -1 Stamina first turn
- "Dazed" — Draw -1 card first turn each wave
- "Nerve Damage" (Grave) — One card type costs +1 forever

**Combat Effectiveness:**
- "Twisted Ankle" — Movement cards cost +1
- "Fatigued" — Armor gained reduced by 1
- "Torn Muscle" (Serious) — All attacks deal -2 damage
- "Lost Eye" (Grave) — -1 damage all attacks permanently

**Strategic Limitations:**
- "Broken Leg" (Serious) — Back line positioning only
- "Dislocated Shoulder" (Serious) — Cannot play 3+ cost cards
- "Mangled Hand" (Grave) — Cannot play 4 cost cards
- "Concussion" (Serious) — 50% chance discard random card/turn

---

## Implementation Checklist

### Core Systems:
- [ ] Create "Injury Track" separate from HP for each unit
- [ ] Implement HP healing (30% quick rest, 70% full rest)
- [ ] Implement injury persistence across waves (no healing mid-expedition)
- [ ] Track knockdown count per unit per expedition
- [ ] Implement injury escalation rules (1 Minor → 2 Minor → Serious → Grave)

### Injury Effects:
- [ ] Define 10-12 Minor injury effects (expedition-scoped)
- [ ] Define 8-10 Serious injury effects (3-mission duration)
- [ ] Define 6-8 Grave injury effects (permanent)
- [ ] Implement mechanical effects (HP reduction, card cost increases, etc.)
- [ ] Apply injury effects at appropriate times (start of wave, start of turn, etc.)

### Warning System:
- [ ] Display injury gained notification after knockdowns
- [ ] Show ⚠️ warning at 2 Minor injuries ("next knockdown risks Serious")
- [ ] Show ⚠️⚠️ danger alert at Serious injury ("next knockdown = GRAVE")
- [ ] Show 🚨 confirmation dialog before wave if Grave risk exists
- [ ] Display injury status on unit cards at all times

### Rest System:
- [ ] Implement Push Forward (no healing)
- [ ] Implement Quick Rest (30% HP, 1 supply)
- [ ] Implement Full Rest (70% HP, 2 supplies, random event)
- [ ] Implement Retreat (abort mission, keep rewards, injury risk)
- [ ] Apply injury effects after healing (Bruised Ribs reduces post-heal HP)

### Hub Healing:
- [ ] Implement Natural Healing (free, 1 mission for Minor, 3 for Serious)
- [ ] Implement Doctor Treatment (gold cost, instant or 1 mission)
- [ ] Implement Shaman Blood Price (permanent HP loss, instant)
- [ ] Track unit availability (injured units sit out missions during healing)
- [ ] Display injury status at hub (red icons, warnings)

### UI Elements:
- [ ] Unit status screen showing HP + Injuries
- [ ] Injury tooltips explaining effects
- [ ] Warning banners at decision points
- [ ] Injury history log (track scars per unit)
- [ ] Visual indicators (⚠️ warning icons, 🚨 danger icons)

### Balance Testing:
- [ ] Playtest Easy missions (target: 0-1 Minor)
- [ ] Playtest Medium missions (target: 1-2 Minor)
- [ ] Playtest Hard missions (target: 2-3 Minor, maybe 1 Serious)
- [ ] Verify Grave injuries only occur with 4+ knockdowns + ignored warnings
- [ ] Tune injury rates based on player feedback
- [ ] Adjust warning thresholds if needed

---

## Design Validation Questions

### Does the system achieve its goals?

✅ **Does HP healing between waves keep combat functional?**
- Yes, 30-70% restoration prevents death spirals

✅ **Do injuries create rising tension across waves?**
- Yes, compounding debuffs make later waves harder

✅ **Do warnings give players agency?**
- Yes, explicit alerts at 2 Minor, Serious, and before Grave

✅ **Are Grave injuries rare and avoidable?**
- Yes, requires 4 knockdowns + ignoring 3 warnings

✅ **Is retreat always a viable option?**
- Yes, keeps rewards earned so far, prevents disasters

✅ **Does hub healing have meaningful costs?**
- Yes, gold vs time vs permanent HP (Blood Price)

---

## Open Questions for Playtesting

1. **Minor injury effects:** Are the debuffs impactful enough without being crippling?

2. **Serious injury escalation:** Is 66% chance (from 2 Minor → Serious) the right probability? Or should it be 50% or 100%?

3. **Grave injury threshold:** Should it require 4 knockdowns or only 3? (Currently: 1 Minor → 2 Minor → Serious → Grave = 4 total)

4. **Rest healing %:** Is 30% (Quick) and 70% (Full) balanced? Should it be 25%/60% or 40%/80%?

5. **Injury pool size:** How many unique injuries per tier? Currently targeting 10-12 Minor, 8-10 Serious, 6-8 Grave.

6. **Blood Price cost:** Is 10% max HP permanent loss the right trade-off for instant Serious injury healing?

7. **Retreat injury risk:** Should retreating with Serious injuries have 50% Grave risk, or is that too punishing?

---

## Summary: Key Takeaways

### The Two-Track System:

**HP = Short-term combat resource**
- Depletes during combat
- Restores between waves (30-70% via resting)
- Reaching 0 = knockdown (not death)

**Injuries = Long-term consequences**
- Gained when knocked out
- Persist entire expedition (don't heal between waves)
- Create compounding mechanical debuffs
- Only heal at hub (gold/time cost)

### The Escalation Path:

```
Healthy → 1 Minor → 2 Minor ⚠️ → Serious ⚠️⚠️ → Grave 🚨
```

### The Safety Net:

- Explicit warnings at each escalation tier
- Retreat always available (cut losses vs push)
- Grave injuries require ignoring 3+ warnings
- Deaths are preventable with good decisions

---

**Document Status:** ✅ COMPLETE - Ready for implementation  
**Next Steps:**  
1. Lock squad combat system (simultaneous turns, positioning)
2. Revise 45 faction cards for multi-target combat
3. Build combat simulator with injury tracking
4. Design 5 mission templates with injury rate targets
5. Implement core injury system and test

---

*This system preserves expedition tension while allowing functional combat healing, creates meaningful risk/reward decisions, and respects player agency through explicit warnings.*
