# Status Effects System - Complete Design

> **Based on research:** Slay the Spire, Monster Train, Darkest Dungeon  
> **Status:** Ready to lock after review

---

## Key Research Insights

### Slay the Spire Lessons:
✅ **Vulnerable:** 50% more damage from attacks, stacks add duration not intensity, rounded down  
✅ **Weak:** 25% less attack damage, stacks add duration not intensity, rounded down  
✅ **Poison:** At start of turn, lose HP = poison stacks, then reduce by 1, ignores block  
✅ **Duration stacking** - applying 2 Weak = lasts 2 turns (not 2x as powerful)  
✅ **Cap at 999** for all status effects (practical limit)

### Monster Train Lessons:
✅ **Armor:** Extra health on top of units, remains until hit off or battle ends, can be healed/regenerated  
✅ **Frostbite:** Damages enemy by 1 for every point, decreases by 1 at end of turn  
✅ **Status effects persist** until removed (no auto-decay except for specific mechanics)  
✅ **999 cap** for balance reasons

### Darkest Dungeon Lessons:
✅ **Bleed/Blight mechanics:** At start of turn, take damage = strength, lasts 3 turns (5 on crit), ignores protection, stacks individually  
✅ **Individual stack tracking** - each application tracked separately, expires independently  
✅ **Bleed = lower damage but paired with strong attacks**  
✅ **Blight = higher damage but weak attack damage**  
✅ **Different enemies resist different DoTs** (skeletons immune to bleed, scales resist bleed)

---

## Our 5 Status Effects (Locked)

### Design Principles:
1. **Clear timing** - all effects trigger at specific moments
2. **Meaningful stacking** - can stack intensity OR duration depending on effect
3. **Hard caps** - prevents broken combos
4. **Counterplay** - faction strengths/weaknesses create rock-paper-scissors
5. **Ignores armor** - DoTs go straight to HP (balances vs AEGIS)

---

## 1. BLEEDING (Damage over Time)

### Core Mechanic
**Timing:** At the START of the affected character's turn  
**Effect:** Take damage equal to Bleeding stacks, then reduce Bleeding by 1  
**Ignores:** Armor (damage goes directly to HP)

### Stacking Rules
**Intensity stacking:** Each application adds to total stacks  
- Apply Bleeding 2 + Bleeding 3 = Bleeding 5 total
- Decays by 1 per turn until 0

**Max stacks:** 12 (hard cap)

### Damage Values (Examples)
- **Bleeding 1:** 1 damage/turn for 1 turn = 1 total damage
- **Bleeding 3:** 3→2→1 = 6 total damage over 3 turns
- **Bleeding 5:** 5→4→3→2→1 = 15 total damage over 5 turns
- **Total damage formula:** (stacks × (stacks + 1)) / 2

### Why it works this way:
- Rewards building up stacks (exponential payoff)
- ECLIPSE Bloodlust (+2 damage to bleeding enemies) creates synergy
- Natural decay prevents infinite scaling
- Goes through armor (counters AEGIS)

---

## 2. ARMOR (Damage Reduction)

### Core Mechanic
**Timing:** When taking damage  
**Effect:** Each point of Armor blocks 1 damage (1:1 reduction)  
**Persistence:** Armor does NOT decay naturally - stays until depleted by damage

### Stacking Rules
**Intensity stacking:** Each application adds to total Armor  
- Gain 5 Armor + Gain 8 Armor = 13 Armor total
- Depletes as damage is taken

**Max stacks:** 30 (hard cap - prevents unkillable builds)

### How it works:
- Enemy attacks for 10 damage
- You have 8 Armor
- You take 2 damage (10 - 8 = 2)
- Armor reduced to 0
- Remaining 2 damage goes to HP

### Special Rules:
- **Armor persists between turns** (unlike Stamina)
- **Armor resets to 0 at end of combat** (doesn't carry between fights)
- **AEGIS Fortress bonus:** Gaining armor also heals HP (30% of armor gained)
- **Blocking priority:** Armor always absorbs damage before HP

### Why it works this way:
- Rewards building armor stacks (like Monster Train)
- AEGIS can stack huge amounts but capped at 30
- Creates decision: spend armor for damage (Crushing Blow) or keep it?
- ECLIPSE multi-hit attacks (Flurry) can chip through
- SPECTER Poison ignores armor entirely

---

## 3. WEAKENED (Damage Reduction Debuff)

### Core Mechanic
**Timing:** Applies immediately when inflicted  
**Effect:** Reduce damage dealt from Attacks by 25% (rounded down)  
**Duration stacking:** Each application adds duration, not intensity

### Stacking Rules
**Duration stacking (like Slay the Spire):**
- Apply Weakened 2 = Weakened for 2 turns
- Apply Weakened 3 while already Weakened 2 = Weakened 5 total
- Always 25% reduction regardless of stacks
- Decreases by 1 at end of affected character's turn

**Max duration:** 10 turns (practical cap)

### Damage Calculation:
- Base attack: 10 damage
- Weakened: 10 × 0.75 = 7.5 → **rounds down to 7 damage**
- Base attack: 7 damage  
- Weakened: 7 × 0.75 = 5.25 → **rounds down to 5 damage**

### What it affects:
✅ Attack cards (Shield Bash, Slash, Strike, etc.)  
❌ Poison/Bleeding (DoTs not affected)  
❌ Abilities (hero abilities bypass Weakened)  
✅ Enemy attacks

### Why it works this way:
- AEGIS and SPECTER use this to survive burst damage
- Hard counters ECLIPSE (whose entire gameplan is burst damage)
- Duration stacking = easier to track (one number, not 25% + 25% confusion)
- Rounding down means weak attacks become very weak (consistent with Slay the Spire)

---

## 4. ENRAGED (Damage Boost + Risk)

### Core Mechanic
**Timing:** Applies immediately when inflicted  
**Effect:** Deal +50% damage from Attacks, but take +25% damage from all sources  
**Duration stacking:** Each application adds duration, not intensity

### Stacking Rules
**Duration stacking:**
- Apply Enraged 2 = Enraged for 2 turns
- Apply Enraged 3 while already Enraged 2 = Enraged 5 total
- Always +50% damage dealt, +25% damage taken
- Decreases by 1 at end of affected character's turn

**Max duration:** 8 turns (practical cap)

### Damage Calculation:
**Your attacks:**
- Base attack: 10 damage
- Enraged: 10 × 1.5 = **15 damage**

**Damage you take:**
- Enemy attacks for 10 damage
- Enraged: 10 × 1.25 = 12.5 → **rounds down to 12 damage**
- You have 5 Armor: blocks 5, take 7 damage to HP

### What it affects:
✅ Attack cards (damage dealt)  
✅ Abilities (hero abilities also boosted!)  
✅ ALL damage taken (attacks, Poison, Bleeding, everything)  
✅ Armor still blocks damage first (13 × 1.25 = 16.25 → 16 damage before armor)

### Risk/Reward:
- **Glass cannon amplifier** - ECLIPSE loves this for burst
- **Dangerous** - taking +25% more damage in Enraged = you die faster
- **Counters Weakened** - +50% damage partially offsets -25% from Weakened
  - Example: 10 damage with both = 10 × 1.5 × 0.75 = 11.25 → **11 damage** (net positive!)
- **High skill expression** - timing Enraged windows is crucial

### Why it works this way:
- Creates dramatic turns (ECLIPSE Blood Frenzy + Berserker Rage)
- Punishes greedy play (AEGIS can kill Enraged ECLIPSE)
- Amplifies both offense AND defense pressure
- Multiplicative with Bloodlust (stacking damage bonuses)

---

## 5. POISON (Damage over Time - Scaling)

### Core Mechanic
**Timing:** At the START of the affected character's turn  
**Effect:** Take damage equal to Poison stacks, then Poison does NOT decay naturally  
**Ignores:** Armor (damage goes directly to HP)  
**SPECTER Miasma bonus:** At start of SPECTER's turn, if enemy has Poison, apply +1 Poison

### Stacking Rules
**Intensity stacking (like Bleeding):**
- Apply Poison 2 + Poison 3 = Poison 5 total
- Does NOT decay naturally (persists all fight)
- Only removed by cleanse effects or fight end

**Max stacks:** 12 (hard cap)

### Damage Values (Examples)
- **Poison 3 (no Miasma):** 3 damage every turn for entire fight
- **Poison 3 (with Miasma):** Turn 1: 3 dmg, Turn 2: 4 dmg (+1 from Miasma), Turn 3: 5 dmg, Turn 4: 6 dmg...
- **Poison 6 (with Miasma, 5-turn fight):** 6→7→8→9→10 = 40 total damage
- **With Miasma, damage = initial_stacks × turns + (turns × (turns-1))/2**

### Interaction with Miasma:
**Turn sequence (SPECTER vs Enemy):**
1. SPECTER turn starts → Miasma triggers → Enemy gains +1 Poison (if any exists)
2. SPECTER plays cards (may apply more Poison)
3. SPECTER turn ends
4. Enemy turn starts → Takes Poison damage
5. Enemy plays cards
6. Enemy turn ends
7. Repeat

**Example (SPECTER applies Poison 4 turn 1):**
- Turn 1: Apply Poison 4
- Turn 2 start: Miasma triggers (Poison 4→5), enemy takes 5 damage
- Turn 3 start: Miasma triggers (Poison 5→6), enemy takes 6 damage
- Turn 4 start: Miasma triggers (Poison 6→7), enemy takes 7 damage
- **Exponential scaling = SPECTER's win condition**

### Why it's different from Bleeding:
- **Bleeding decays** (short-term burst DoT for ECLIPSE)
- **Poison persists** (long-term scaling DoT for SPECTER)
- **Miasma amplifies** Poison exponentially (unique to SPECTER)
- **Ignores Armor** (like Bleeding, counters AEGIS)
- **Trade-off:** Requires setup time (weak early, strong late)

### Counterplay:
- Kill SPECTER before Poison scales (ECLIPSE burst)
- Cleanse effects (items, Shaman, specific cards)
- Pressure SPECTER so they can't set up (AEGIS Weakened spam)

---

## Status Effect Timing (Critical)

### Turn Structure:
1. **Start of turn triggers:**
   - **Bleeding damage** (if you have Bleeding)
   - **Poison damage** (if you have Poison)
   - **SPECTER Miasma** (if SPECTER's turn and enemy has Poison, +1 Poison to enemy)
   - Gain Stamina (3 base)
   - Gain Mana (+1 base)
   - Draw 1 card

2. **Play phase:**
   - Play cards (costs Stamina)
   - Use abilities (costs Mana)
   - Apply status effects (Weakened, Enraged, Armor, Bleeding, Poison)
   - Deal damage (affected by Weakened, Enraged, blocked by Armor)

3. **End of turn:**
   - **Duration-based statuses decay by 1** (Weakened, Enraged)
   - Discard hand down to 8 cards (if over)
   - Unused Stamina lost

### Important Timing Notes:
- **DoTs trigger BEFORE you can act** (can kill you before playing healing card)
- **Armor doesn't decay** (persistent between turns)
- **Bleeding decays after damage** (reduces by 1)
- **Poison doesn't decay** (persists forever unless cleansed)
- **Weakened/Enraged active ALL turn** (applied immediately)

---

## Status Effect Caps (Hard Limits)

| Status Effect | Max Stacks/Duration | Why This Cap? |
|---------------|---------------------|---------------|
| **Bleeding** | 12 stacks | Prevents instant kills; 12→11→...→1 = 78 total damage (lethal to anyone) |
| **Armor** | 30 stacks | Prevents unkillable AEGIS; 30 armor = 6+ hits to break through |
| **Weakened** | 10 turns | Long enough to matter, short enough to expire; 25% reduction regardless |
| **Enraged** | 8 turns | Risky to maintain; +50% damage is huge; capped so you can't perma-Enrage |
| **Poison** | 12 stacks | With Miasma, 12 Poison → 13→14→15 per turn = exponential; 12 is lethal |

**All caps = 999 internally for technical reasons** (like Slay the Spire), but balanced gameplay caps are much lower.

---

## Faction Status Mastery (Summary)

### AEGIS
**Masters:**
- **Armor:** Generates massive stacks + Fortress healing
- **Weakened:** Spam to neuter enemy offense

**Resists:**
- **Bleeding:** High HP pool absorbs it
- **Poison:** Fortress healing can outheal early Poison

**Vulnerable to:**
- **Enraged:** Amplifies enemy damage even through armor
- **High Poison stacks:** Eventually overwhelms Fortress healing

---

### ECLIPSE
**Masters:**
- **Bleeding:** Applies and exploits with Bloodlust
- **Enraged:** Risk/reward for massive burst windows

**Resists:**
- **Poison:** Kills enemies before it scales

**Vulnerable to:**
- **Armor:** Reduces burst damage effectiveness
- **Weakened:** Cripples entire damage output

---

### SPECTER
**Masters:**
- **Poison:** Exponential scaling with Miasma
- **Weakened:** Enables stalling for Poison to scale

**Resists:**
- **Enraged:** Control tools + Weakened counter burst

**Vulnerable to:**
- **Bleeding:** Lacks sustain to heal through it
- **Burst damage:** Dies before Poison scales

---

## Cleanse/Removal Mechanics

### How to remove status effects:

**Bleeding & Poison:**
- Doctor services (hub)
- Shaman services (hub)
- Combat items (Bandage, Antivenom)
- Specific cards (TBD - could add "Cleanse Bleeding" to some cards)

**Weakened & Enraged:**
- Wait for duration to expire (most common)
- Specific cleanse effects (rare)
- Items (rare)

**Armor:**
- Takes damage (depleted by attacks)
- Resets at end of combat
- Some enemy effects might "strip armor" (TBD)

---

## Status Effect Interactions

### Weakened + Enraged:
- **Both apply:** +50% and -25% are multiplicative
- Example: 10 damage × 1.5 (Enraged) × 0.75 (Weakened) = 11.25 → **11 damage**
- Net result: +10% damage (Enraged partially overcomes Weakened)

### Bleeding + Poison:
- **Both stack independently**
- Both trigger at start of turn (order doesn't matter since both go to HP)
- Example: Bleeding 5 + Poison 3 = 8 damage at start of turn

### Armor + DoTs:
- **DoTs ignore Armor entirely**
- Bleeding/Poison damage goes straight to HP
- This is critical for SPECTER to counter AEGIS

### Multiple status applications:
- **Same status, same turn:** Stacks immediately
  - Play "Slash" (Bleeding 1) + "Lacerate" (Bleeding 2) = Bleeding 3
- **Duration-based:** Add durations
  - Apply Weakened 2, then Weakened 3 = Weakened 5 total

---

## Balance Testing Checklist

### Questions to validate:
- [ ] Can Bleeding kill in one turn? (Max 12 = no, need 2-3 turns)
- [ ] Can Armor prevent all damage forever? (Max 30, decays with hits = no)
- [ ] Can Weakened completely negate damage? (25% reduction = no, still does 75%)
- [ ] Is Enraged too risky? (Taking +25% damage = yes if misplayed, rewarding if timed)
- [ ] Can Poison scale infinitely? (Max 12 + fight length cap = no)

### Tuning knobs:
- Bleeding max stacks (currently 12)
- Armor max stacks (currently 30)
- Weakened percentage (currently 25%)
- Enraged damage boost/taken (currently +50%/-25%)
- Poison max stacks (currently 12)
- Miasma bonus (currently +1/turn)

---

## Implementation Priority

### Phase 1 (V1 Core):
- [ ] Implement all 5 status effects with base mechanics
- [ ] Implement timing (start of turn, end of turn)
- [ ] Implement stacking rules (intensity vs duration)
- [ ] Implement hard caps
- [ ] Test in simulated combats

### Phase 2 (Balancing):
- [ ] Playtest all faction matchups
- [ ] Tune damage values (Bleeding/Poison numbers)
- [ ] Tune percentages (Weakened/Enraged)
- [ ] Adjust caps if needed
- [ ] Test edge cases (max stacks, multiple statuses)

### Phase 3 (Polish):
- [ ] Add cleanse mechanics
- [ ] Add status removal cards
- [ ] Add visual indicators (text-based V1)
- [ ] Add status effect tutorials

---

## Open Questions for You:

1. **Bleeding damage per stack:** Should base Bleeding do 1 damage/stack or scale with level? (Recommendation: flat 1 damage - simple)

2. **Armor cap:** Is 30 too high or too low? (Recommendation: 30 is good - 30 damage absorbed is significant)

3. **Weakened percentage:** 25% feels right, but should it be 30% for more impact?

4. **Enraged numbers:** +50% damage dealt / +25% damage taken - good balance or adjust?

5. **Poison with Miasma:** Is +1 Poison/turn too slow or too fast? (Recommendation: +1 is exponential enough)

6. **Cleanse mechanics:** Should there be in-combat cleanse cards, or only hub/items?

---

**Document Status:** ✅ READY FOR LOCK  
**Next Step:** Lock combat system rules (turn order, damage calc)  
**After That:** Design gear system with status synergies
