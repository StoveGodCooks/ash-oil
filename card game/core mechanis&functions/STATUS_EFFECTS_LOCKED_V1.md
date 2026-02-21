# STATUS EFFECTS - LOCKED FOR PRODUCTION (V1)

> **Status:** ✅ LOCKED - Ready for implementation  
> **Version:** 1.0 Final  
> **Last Updated:** Current Session  
> **Dependencies:** Factions (locked), Combat System (in progress)

---

## 🎯 DESIGN PHILOSOPHY

1. **Clear timing** - All effects trigger at specific, predictable moments
2. **Meaningful stacking** - Rewards building up status effects over time
3. **Hard caps** - Prevents broken infinite scaling
4. **Counterplay** - Each faction has strengths/weaknesses vs specific statuses
5. **DoTs ignore Armor** - Creates strategic diversity, counters pure tank builds

---

## 📊 THE 5 STATUS EFFECTS

### 1. BLEEDING (Damage over Time - Decaying)

**LOCKED NUMBERS:**
- **Damage:** 1 HP per stack
- **Timing:** Start of affected character's turn
- **Decay:** Reduces by 1 after damage
- **Max Stacks:** 12
- **Ignores:** Armor (goes straight to HP)

**Stacking:**
- Intensity stacking (each application adds to total)
- Apply Bleeding 2 + Bleeding 3 = Bleeding 5

**Damage Formula:**
```
Total damage = (stacks × (stacks + 1)) / 2

Examples:
Bleeding 1: 1 damage (1 turn)
Bleeding 3: 3→2→1 = 6 damage (3 turns)
Bleeding 5: 5→4→3→2→1 = 15 damage (5 turns)
Bleeding 12: 12→11→...→1 = 78 damage (12 turns, lethal)
```

**Faction Interactions:**
- **ECLIPSE masters this:** Bloodlust (+2 damage vs bleeding targets)
- **AEGIS resists this:** High HP pool absorbs DoT
- **SPECTER vulnerable to this:** No native healing

---

### 2. ARMOR (Damage Reduction - Persistent)

**LOCKED NUMBERS:**
- **Effect:** Blocks damage before HP
- **Timing:** Always active, depletes when hit
- **Decay:** Damage removes it, does NOT decay naturally
- **Max Stacks:** 30
- **Resets:** End of combat (does not carry between fights)

**Damage Blocking:**
```
Attack: 10 damage
You have 5 Armor

Result: 5 blocked, 5 damage to HP
Armor remaining: 0
```

**Multi-hit Interaction:**
```
You have 15 Armor
Enemy attacks 3 times for 8 damage each

Hit 1: 8 blocked, 0 to HP (7 Armor remaining)
Hit 2: 7 blocked, 1 to HP (0 Armor remaining)  
Hit 3: 0 blocked, 8 to HP (0 Armor remaining)
```

**Critical Rule:** Armor cap prevents infinite stacking
- AEGIS Bulwark ability can grant "50% missing HP as Armor"
- Even at 30 HP, max gain is 30 Armor total (cap enforced)

**Faction Interactions:**
- **AEGIS masters this:** Fortress (heals when gaining Armor)
- **ECLIPSE weak to this:** Burst damage reduced
- **SPECTER bypasses this:** Poison ignores Armor

---

### 3. WEAKENED (Damage Reduction - Duration)

**LOCKED NUMBERS:**
- **Effect:** -25% attack damage (rounded down)
- **Timing:** Applies immediately when inflicted
- **Decay:** Reduces by 1 at end of affected character's turn
- **Max Duration:** 10 turns
- **Affects:** Attack cards only (NOT abilities, NOT DoTs)

**Stacking:**
- Duration stacking (NOT intensity)
- Apply Weakened 2 + Weakened 3 = Weakened 5 total duration
- Always -25% damage, longer duration ≠ stronger reduction

**Damage Calculation:**
```
Base attack: 10 damage
Weakened: 10 × 0.75 = 7.5 → 7 damage (rounded down)

Base attack: 13 damage  
Weakened: 13 × 0.75 = 9.75 → 9 damage (rounded down)
```

**What It Affects:**
- ✅ Attack cards from hand
- ✅ Enemy attacks
- ❌ Hero abilities (bypass Weakened)
- ❌ Bleeding/Poison damage
- ❌ Armor gain

**Faction Interactions:**
- **AEGIS masters this:** Spam to neuter enemy offense
- **SPECTER masters this:** Enables stalling for Poison scaling
- **ECLIPSE vulnerable to this:** Entire strategy crippled

---

### 4. ENRAGED (Damage Boost + Risk - Duration)

**LOCKED NUMBERS:**
- **Effect:** +50% damage dealt, +25% damage taken
- **Timing:** Applies immediately when inflicted
- **Decay:** Reduces by 1 at end of affected character's turn
- **Max Duration:** 8 turns
- **Affects:** ALL damage (attacks, abilities, even DoTs taken!)

**Stacking:**
- Duration stacking (NOT intensity)
- Apply Enraged 2 + Enraged 3 = Enraged 5 total duration
- Always +50% dealt / +25% taken

**Damage Calculation:**
```
YOUR ATTACKS:
Base: 10 damage
Enraged: 10 × 1.5 = 15 damage

DAMAGE YOU TAKE:
Enemy attacks: 10 damage
Enraged: 10 × 1.25 = 12.5 → 12 damage (rounded down)
```

**Enraged + Weakened Interaction:**
```
Your attack: 10 damage
Enraged: × 1.5 = 15
Weakened: × 0.75 = 11.25 → 11 damage

Net result: +10% damage (Enraged overcomes Weakened partially)
```

**Risk/Reward:**
- Glass cannon amplifier for ECLIPSE burst windows
- Taking +25% more damage = you die MUCH faster
- Counters Weakened (multiplicative, not additive)
- High skill expression (timing Enraged is critical)

**Faction Interactions:**
- **ECLIPSE masters this:** Synergy with Bloodlust (multiplicative bonuses)
- **AEGIS counters this:** Can punish Enraged targets
- **SPECTER neutral:** Uses Weakened to mitigate Enraged enemies

---

### 5. POISON (Damage over Time - Scaling)

**LOCKED NUMBERS:**
- **Damage:** 1 HP per stack
- **Timing:** Start of affected character's turn
- **Decay:** Does NOT decay (persists entire fight)
- **Max Stacks:** 12
- **Ignores:** Armor (goes straight to HP)
- **SPECTER Miasma Bonus:** +1 Poison at start of SPECTER's turn if enemy has any Poison

**Stacking:**
- Intensity stacking (like Bleeding)
- Apply Poison 2 + Poison 3 = Poison 5

**Damage Formula (No Miasma):**
```
Poison 3: 3 damage every turn until fight ends
4-turn fight: 3+3+3+3 = 12 total damage
```

**Damage Formula (With SPECTER Miasma):**
```
Turn 1: Apply Poison 4
Turn 2 Start: Miasma (+1) → Poison 5, take 5 damage
Turn 3 Start: Miasma (+1) → Poison 6, take 6 damage  
Turn 4 Start: Miasma (+1) → Poison 7, take 7 damage
Turn 5 Start: Miasma (+1) → Poison 8, take 8 damage

Total: 5+6+7+8 = 26 damage (exponential!)

Formula: initial_stacks × turns + (turns × (turns-1)) / 2
```

**Exponential Scaling Example:**
```
SPECTER applies Poison 6 on Turn 1
6-turn fight:

Turn 1: Apply Poison 6
Turn 2: +1 → 7 damage
Turn 3: +1 → 8 damage
Turn 4: +1 → 9 damage
Turn 5: +1 → 10 damage
Turn 6: +1 → 11 damage

Total: 45 damage (LETHAL to any faction)
```

**Counterplay:**
- Kill SPECTER before Poison scales (ECLIPSE speed advantage)
- Pressure SPECTER so they can't apply high initial stacks
- Cleanse effects (Doctor/Shaman/items)

**Faction Interactions:**
- **SPECTER masters this:** Miasma exponential scaling
- **ECLIPSE resists this:** Kills enemy before it scales
- **AEGIS vulnerable to this:** Long fights let Poison reach lethal

---

## ⏱️ TURN TIMING (CRITICAL)

### Start of Turn (in exact order):
1. **DoT Damage Triggers:**
   - Bleeding: Take damage = stacks, then reduce by 1
   - Poison: Take damage = stacks (no reduction)
   - **Death check:** If HP ≤ 0, combat ends immediately

2. **Faction Passives:**
   - SPECTER Miasma: If enemy has Poison, +1 Poison to enemy
   - AEGIS Fortress: Passive (always active)
   - ECLIPSE Bloodlust: Passive (always active)

3. **Resource Generation:**
   - Gain 3 Stamina (base, modifiable by gear)
   - Gain 1 Mana (base, modifiable by gear)

4. **Card Draw:**
   - Draw 1 card (base, modifiable by gear)
   - If deck empty, shuffle discard into new deck, then draw

### Play Phase:
- Play cards (cost Stamina)
- Use abilities (cost Mana)
- Apply status effects (immediate resolution)
- Deal damage (affected by Weakened, Enraged, Armor)

### End of Turn:
1. **Duration Status Decay:**
   - Weakened: -1 duration
   - Enraged: -1 duration
   - When duration reaches 0, status removed

2. **Hand Limit:**
   - If >8 cards, discard down to 8 (player chooses)

3. **Stamina Reset:**
   - Unused Stamina lost (does not carry over)

**Important Timing Notes:**
- DoTs can kill you BEFORE you act (no "last card save")
- Armor persists between turns (doesn't decay)
- Poison NEVER decays without cleanse
- Weakened/Enraged applied immediately (no delay)

---

## 🛡️ STATUS EFFECT CAPS (HARD LIMITS)

| Status Effect | Max Value | Reason |
|---------------|-----------|--------|
| **Bleeding** | 12 stacks | 78 total damage (lethal to anyone), prevents instant kills |
| **Armor** | 30 stacks | Prevents unkillable AEGIS, 30 = 6+ hits to break |
| **Weakened** | 10 turns | Long enough to matter, always -25% regardless |
| **Enraged** | 8 turns | Risky to maintain, +50% is huge, prevents perma-Enrage |
| **Poison** | 12 stacks | With Miasma, reaches lethal quickly, 12 is exponential |

**Technical Implementation:** Cap at 999 internally (like Slay the Spire), but gameplay balance enforces lower caps shown above.

---

## 🧩 FACTION STATUS MASTERY

### AEGIS (Tank)
**Masters:**
- Armor (massive stacks + Fortress healing)
- Weakened (spam to reduce enemy damage)

**Resists:**
- Bleeding (high HP pool absorbs it)
- Poison (early stacks, Fortress heals through it)

**Vulnerable:**
- Enraged enemies (amplifies damage even through Armor)
- High Poison stacks (eventually overwhelms Fortress)

---

### ECLIPSE (Assassin)
**Masters:**
- Bleeding (applies and exploits with Bloodlust)
- Enraged (risk/reward for massive burst)

**Resists:**
- Poison (kills enemy before it scales)

**Vulnerable:**
- Armor (reduces burst effectiveness)
- Weakened (entire gameplan crippled)

---

### SPECTER (Control)
**Masters:**
- Poison (exponential Miasma scaling)
- Weakened (enables stalling)

**Resists:**
- Enraged (control + Weakened counters burst)

**Vulnerable:**
- Bleeding (no native healing)
- Burst damage (dies before Poison scales)

---

## 🧪 CLEANSE MECHANICS (V1)

**How to Remove Status Effects:**

### Hub Services:
- **Doctor (Physical):** Removes Bleeding
- **Shaman (Mystical):** Removes Poison
- **Both:** Can reduce Weakened/Enraged duration

### Combat Items:
- **Bandage (consumable):** Remove Bleeding immediately
- **Antivenom (consumable):** Remove Poison immediately
- **Tonic (consumable):** Remove Weakened or Enraged

### V1 Rule: NO in-combat cleanse cards
- Keeps combat focused on status application/exploitation
- Forces strategic item usage decisions
- Hub cleansing creates meaningful campaign choices

### V2 Expansion (Optional):
- Add faction-specific cleanse cards (1-2 per faction)
- Example: AEGIS "Purge" - 2 Stamina, remove all negative statuses
- Only add if playtesting shows status effects too oppressive

---

## 🧮 STATUS INTERACTION EXAMPLES

### Weakened + Enraged (Same Target):
```
Base attack: 10 damage
Enraged: × 1.5 = 15
Weakened: × 0.75 = 11.25 → 11 damage

Result: +10% net damage (Enraged partially overcomes Weakened)
```

### Bleeding + Poison (Same Target):
```
Target has Bleeding 5 and Poison 3

Start of turn:
- Take 5 damage from Bleeding (Bleeding → 4)
- Take 3 damage from Poison (Poison stays 3)
- Total: 8 damage this turn
```

### Armor + DoTs:
```
You have 15 Armor
You have Bleeding 4 and Poison 2

Start of turn:
- Bleeding 4 damage → goes to HP (bypasses Armor)
- Poison 2 damage → goes to HP (bypasses Armor)
- Armor still 15 (DoTs don't deplete Armor)
```

### Multiple Status Applications (Same Turn):
```
You play 3 cards:
- Slash: Bleeding 2
- Lacerate: Bleeding 3  
- Open Wound: Bleeding 4

Result: Bleeding 9 total (immediate stacking)
```

---

## ✅ IMPLEMENTATION CHECKLIST

### Phase 1: Core Mechanics
- [ ] Implement 5 status effects with exact numbers
- [ ] Implement timing (start of turn, end of turn)
- [ ] Implement stacking rules (intensity vs duration)
- [ ] Implement hard caps
- [ ] Test damage calculations with spreadsheet

### Phase 2: Interactions
- [ ] Test Weakened + Enraged multiplicative
- [ ] Test DoTs bypassing Armor
- [ ] Test Miasma exponential scaling
- [ ] Test all faction passives with statuses
- [ ] Validate formulas match design intent

### Phase 3: Balance Validation
- [ ] Playtest AEGIS vs ECLIPSE (Armor vs Bleeding)
- [ ] Playtest ECLIPSE vs SPECTER (Burst vs Poison)
- [ ] Playtest SPECTER vs AEGIS (Poison vs Armor)
- [ ] Tune ONLY if broken strategies emerge
- [ ] Document any changes with rationale

---

## 🔒 PRODUCTION LOCK STATUS

**✅ ALL NUMBERS LOCKED FOR V1**

**Locked Decisions:**
- Bleeding: 1 damage/stack, decays by 1
- Armor: Cap 30, blocks before HP
- Weakened: -25% damage, duration stacking
- Enraged: +50% dealt / +25% taken, duration stacking
- Poison: 1 damage/stack, no decay, Miasma +1/turn

**NO FURTHER CHANGES without playtesting data proving balance issues**

**Next Design Step:** Lock combat system rules (turn order, damage calculation, resource system)

**Next Implementation Step:** Code status effects into combat engine

---

**Document Status:** ✅ LOCKED FOR PRODUCTION  
**Ready for:** Implementation, Combat Simulator, Balance Testing  
**Version:** 1.0 Final - Do Not Modify
