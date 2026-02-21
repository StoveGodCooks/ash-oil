# SQUAD COMBAT RULES - LOCKED FOR PRODUCTION (V1)

> **Status:** ✅ LOCKED - Ready for implementation
> **Version:** 1.0 Final
> **Date:** 2026-02-20
> **Dependencies:** Combat System (locked), Status Effects (locked), Lieutenants (story names)

---

## 🎯 DESIGN PHILOSOPHY

**Core Principles:**
1. **One shared squad turn** - All 3 units act together in one turn phase
2. **Shared resources** - One Stamina pool, one Mana pool, one hand
3. **Individual tracking** - Each unit has separate HP, passives, can be KO'd
4. **Player agency** - You assign cards to specific units, pick targets
5. **Tactical depth** - Who executes what card matters (passives, traits)

---

## 📋 PRE-COMBAT SQUAD SETUP

### Champion + 3-4 Lieutenants (4-5 Units Total)

```
Your Squad:
├─ Champion (You): Primary unit, 1 faction
├─ Lieutenant 1: Supporting unit
├─ Lieutenant 2: Supporting unit
├─ Lieutenant 3: Supporting unit
└─ Lieutenant 4: Supporting unit (optional, Season 2+)

Bench (2-3 Extra Lieutenants):
├─ Bench Unit 1: Ready to swap in
├─ Bench Unit 2: Ready to swap in
└─ Bench Unit 3: Ready to swap in (optional)
```

### Deck Composition (CRUCIAL)

**Deck = Champion's Faction ONLY**
- Champion picks the faction (AEGIS, ECLIPSE, SPECTER, or ORACLE in Season 2)
- All cards drawn are from Champion's faction pool + Neutral pool
- Lieutenants contribute: **Passives, Stats, Signature Cards only**

**Why This Works:**
- ✅ Keeps deck coherent (not 3 random factions mixed)
- ✅ Faction identity clear (AEGIS squad plays like AEGIS)
- ✅ Lieutenants add flavor without deck chaos
- ✅ Easy to implement and balance

**Example:**
```
Champion: AEGIS (30 HP, 5 Armor, Speed 2)
├─ Deck: All AEGIS cards + Neutral cards
├─ Passives: AEGIS Fortress passive
└─ Abilities: AEGIS Bulwark (3 Mana), Iron Bastion (7 Mana)

Lieutenant 1: Marcus the Veteran (ECLIPSE-aligned)
├─ HP: 25, Armor: 0, Speed: 6 (individual tracking)
├─ Passive: "Disciplined" (+1 starting hand size)
├─ Signature Cards: "Veteran's Resolve", "Legion Tactics" (in deck pool)
└─ Note: Does NOT change deck faction, just adds his cards to pool

Lieutenant 2: Livia the Cultist (SPECTER-aligned)
├─ HP: 20, Armor: 2, Speed: 4
├─ Passive: "Blessed" (+2 Mana start)
├─ Signature Cards: "Blessed Strike", "Ritual Curse" (in deck pool)
└─ Note: Does NOT change deck faction
```

---

## ⏱️ TURN STRUCTURE FOR SQUADS

### ONE SQUAD TURN (All 3 Units Act Together)

#### Phase 1: START OF TURN

**1A. Determine Turn Order (First Turn Only)**
- Higher Speed = squad acts first
- Tie: Player wins (acts first)
- **Squad Speed = Champion's Speed + Lieutenant Bonuses**
  - Example: Champion Speed 2 + Marcus (+2 from trait) = Squad Speed 4
- Turn order FIXED for entire combat (doesn't recalculate)

---

**1B. Start of Turn Triggers (Per Unit)**

Apply to EACH unit individually:

```
For Champion:
1. DoT damage (Bleeding, Poison) → HP deduction
2. Death check → If HP ≤ 0, SQUAD LOSS (combat ends)

For each Lieutenant:
1. DoT damage (Bleeding, Poison) → HP deduction
2. Death check → If HP ≤ 0, that unit is KO'd (sits out)
   (Combat continues with remaining 2 units)

For all 3 units:
3. Faction passives trigger (Fortress, Bloodlust, Miasma)
   - Each unit applies their faction passive independently
   - Example: If Marcus is ECLIPSE with Bloodlust, he triggers it

4. Lieutenants' traits trigger
   - Example: Marcus "Disciplined" trait triggers (+1 starting hand)

5. SHARED RESOURCE GENERATION:
   - Gain 3 Stamina (squad pool, shared)
   - Gain 1 Mana (squad pool, shared)
   - Draw 1 card (shared hand)
```

---

#### Phase 2: MAIN PHASE (Play Cards & Abilities)

**2A. Card Assignment Rule**

When you play a card:
```
1. Choose card from hand
2. Choose which unit executes it (Champion, Marcus, or Livia)
3. Spend Stamina from shared pool
4. That unit's stats + passives apply

Example: Play "Shield Bash" (1 Stamina)
├─ Assign to Marcus (ECLIPSE) → 5 damage (using his Speed-based scaling) + 3 Armor
├─ That unit gets ECLIPSE Bloodlust bonus (+2 damage if target has Bleeding)
├─ Card resolves immediately (no stack, no response window)
└─ Discard pile (unless Exhaust)
```

**Why This Works:**
- ✅ Tactical choice ("Who should use this card?")
- ✅ Faction passives matter ("Marcus benefits from Bloodlust")
- ✅ Lieutenants feel unique (different stats affect output)

---

**2B. Card Types & Execution**

**Attack Cards:**
- Deal damage (affected by executing unit's faction passive)
- Example: Marcus uses "Slash" → ECLIPSE Bloodlust triggers

**Skill Cards:**
- Apply status effects, gain Armor, draw cards, etc.
- Execute unit's stats don't matter (pure effect)
- Example: Livia uses "Blessed Strike" → Applies Poison 2 (same regardless of who uses it)

**Power Cards:**
- Ongoing effects for entire squad (not unit-specific)
- Example: "Aegis Stance" → Squad gains 3 Armor per turn for 3 turns

---

**2C. Targeting System (Player Chooses)**

When a card or ability targets enemy(ies):

```
SINGLE-TARGET CARDS:
- You click the enemy (front-line, back-line, or specific enemy)
- Full control, no auto-target

MULTI-TARGET CARDS:
- "All enemies" → Hits all 3 enemy units simultaneously
- "Another unit in your squad" → You pick which ally (Marcus or Livia)
- "Target ally" → You pick which ally receives the buff

Example:
Card: "Coordinated Strike" (5 damage, another unit deals 3 damage)
├─ You hit enemy A for 5 damage
├─ You assign "another unit" to Marcus
└─ Marcus deals 3 damage to same target (or different, you choose)
```

---

**2D. Unit-Specific Card Bonuses**

Some cards have unit bonuses:

```
VETERAN'S RESOLVE (Marcus Signature)
Cost: 1 Stamina
Effect: Gain 4 Armor. If played by Marcus, draw 1 card.

How It Works:
- Any unit can use this card
- Gain 4 Armor (same for all)
- BONUS: If Marcus uses it, draw 1 extra card
- Reward for "correct" unit usage, but not required
```

---

**2E. Shared Resources During Turn**

```
Stamina Pool (Shared):
- Start: 3 Stamina
- Spend on cards: 1-4 Stamina per card
- Unused: Lost at end of turn
- Cap: 6 Stamina (can't exceed)

Mana Pool (Shared):
- Start: 1 Mana (or +2 if Livia trait)
- Generate: +1 per turn, +1 per card played, +1 per 5 damage taken
- Use on abilities: Champion abilities only
- Persist: Carries to next turn
- Cap: 12 Mana (or 15 with upgrades)

Hand (Shared):
- Draw 1 per turn at start
- Max size: 8 cards
- Discard down to 8 at end of turn
- All units draw from same hand, play from same hand
```

---

#### Phase 3: END OF TURN

```
For each unit:
1. Duration-based effects decay (Weakened, Enraged) → -1 duration

For squad:
2. Hand limit check (discard to 8 if over)
3. Stamina reset (lose unused)
4. Armor persists (doesn't decay)
5. Mana persists (carries to next turn)
6. Pass to enemy turn
```

---

## ⚡ UNIT KO MECHANICS

### When a Lieutenant hits 0 HP:

```
That lieutenant is KO'd:
- Removed from active play
- Sits out current and future turns
- Their passives/traits stop applying
- Their signature cards still available (other units can use them)
- Combat continues with 2 units (3 → 2)

Resources don't change:
- Shared Stamina/Mana pools unaffected
- Hand unaffected
- Speed recalculation: None (squad speed was set on Turn 1)

When that unit returns (via bench swap):
- Can rejoin combat
- Reset to full HP (or healing from tent)
```

### When Champion hits 0 HP:

```
COMBAT ENDS IMMEDIATELY
- Squad loss (fail the mission)
- Return to hub with 40% HP (recovery floor)
- Lieutenants take injuries based on outcome
```

---

## 🔄 BENCH SYSTEM (Mid-Campaign Unit Swaps)

### Bench Capacity

```
Active Slots: 4-5 units (Champion + 3-4 Lieutenants)
Bench Slots: 2-3 units (backup lieutenants)

Total Lieutenant Pool: 12 (8 in Season 1, 4 in Season 2)
Available for deployment: 3-4 active at a time, 2-3 on bench

Season 1: 3 active (Champion + 2 LTs) + 2-3 bench
Season 2: 4 active (Champion + 3 LTs) + 2-3 bench (after recruiting 4th LT)
```

### Swapping (At Camp Only)

**Can only swap between fights, not during combat.**

```
SWAP COST (Progressive):
1st swap per campaign: 50g
2nd swap per campaign: 150g
3rd swap per campaign: 300g
4th+ swap per campaign: 500g (caps)

SWAP MECHANICS:
- Benched unit comes in with FULL HP (or injured if they took injuries)
- Their deck is RESET (only signature cards unlocked for level, rest default)
- Takes 2 missions to fully "come online":
  * Mission 1 (after swap): Catch-up XP 100% (baseline)
  * Mission 2 (after swap): Catch-up XP 150% (ramping)
  * Mission 3+: Back to normal XP growth

2-FIGHT LOCKOUT:
- Swap someone OUT on Fight N
- They sit out Fight N and Fight N+1
- Can swap them back in on Fight N+2 (earliest)

Prevents: Swapping every fight for "fresh" units
```

**Example (6-fight mission):**
```
Fight 1: Marcus takes heavy damage
Fight 2: Swap Marcus out, bring Titus in (50g)
Fight 3: Marcus still benched (2-fight lockout)
Fight 4: Marcus available to swap back in
Fight 5-6: Can keep Titus or swap back to Marcus
```

---

## ⛺ TENT RESOURCE (Between-Fight Camp)

### Tent Availability (Per Mission)

```
Act 1 missions: 1 tent
Act 2 missions: 1-2 tents (varies)
Act 3+ missions: 2 tents (standard)

Boss missions: 2-3 tents (harder fights, more healing)

Tent Usage:
- Cannot use mid-fight
- Only available between waves/fights
- Limited per mission (can't camp every fight)
- Must choose strategically WHEN to use
```

### What You Can Do at Camp (Inside Tent)

```
ONE CAMP SESSION (uses 1 tent):
- Heal injuries (all units or specific ones)
- Treat status effects (remove Bleeding/Poison if stuck)
- Swap units (costs gold)
- Rebuild decks (free, adjust card lineup)
- Use combat items (healing potions, antivenom)

CANNOT DO (requires going back to hub):
- Buy new gear
- Level up
- Full healing recovery
- Revive dead units
```

---

## 🎯 POSITIONING SYSTEM

### Squad Formation

```
BACK ROW (Protected but Vulnerable):
└─ Champion (Main character)

FRONT ROW (Shields the back, 3-4 units):
├─ Lieutenant 1 (Left flank)
├─ Lieutenant 2 (Center)
├─ Lieutenant 3 (Right flank)
└─ Lieutenant 4 (Optional, deep center - Season 2+)
```

**Why This Matters:**
- Front row units take hits first (positioned to block)
- Back row Champion is protected but exposed if front falls
- 3-4 units in front = flexible squad composition
- Creates tactical decisions: "Which lieutenants do I deploy? Who guards the Champion?"

---

### Blocking Mechanic (Player Choice)

When an enemy attacks the Champion (back row):

```
Player Option A: NO BLOCK
- Damage goes to Champion directly (8 damage to Champion)

Player Option B: BLOCK
- Choose a front-row lieutenant to intercept
- That unit takes the damage instead (8 damage to Marcus, not Champion)
- MUST have full HP available (can't block with KO'd unit)
```

**When Blocking Available:**
- Only when enemies target the back row (Champion)
- Only during enemy turn (not during player actions)
- Front-row unit can only block once per enemy attack
- After block, front-row unit is now "blocking" (visual indicator)

**Why It Matters:**
- Creates meaningful defense choices
- Lieutenants feel protective (they literally shield the Champion)
- Risk/reward: Weak lieutenant up front = more blocking options but they die faster

**Example (3-unit front row):**
```
Enemy Bruiser attacks Champion for 8 damage

Enemy Turn Notification:
"Bruiser attacks Champion (8 damage)"

Player gets prompt:
[A] Let damage through (Champion takes 8)
[B] Marcus blocks (Marcus takes 8)
[C] Livia blocks (Livia takes 8)
[D] Titus blocks (Titus takes 8)

Player chooses [B] → Marcus takes 8 damage instead
(Livia and Titus stay healthy, continue protecting)
```

**Strategic Implications:**
- More front units = more blocking options
- But also more units to keep healthy
- Losing front units = Champion becomes more exposed
- Front unit arrangement matters (left/center/right positioning influences who blocks naturally)

---

## 🎯 ENEMY SQUADS

### Enemy Composition (1-3 enemies per wave)

Enemies also fight in squads:
```
Early fights: 1-2 enemies
Mid fights: 2-3 enemies
Boss fights: 1 boss (3-phase)

Enemy Positioning:
- Front: Tanky enemies (Shieldbearer, Bruiser)
- Back: Ranged/support enemies (Archer, Warlock)
- Can be targeted freely (no blocking mechanic for player)
```

---

## 🤖 ENEMY AI (Dynamic Chess Moves System)

**NOT hardcoded priority system. Instead: Conditional decision pool based on field state.**

### AI Decision Framework

Each enemy evaluates the current situation and picks from available "moves":

```
BEFORE EACH ENEMY ACTION:
1. Read field state:
   - Player HP status (full, medium, low, critical)
   - Lineup (front row status, back row vulnerable?)
   - Status effects (do any trigger special responses?)
   - Enemy HP status (are we losing?)

2. Evaluate available moves:
   - Aggressive moves (damage, apply status)
   - Defensive moves (heal, gain Armor, apply debuff)
   - Special moves (faction-specific, tactical)

3. Choose move based on condition:
   - "If player Champion < 30% HP, execute kill blow"
   - "If front row is damaged, heal our front"
   - "If player has 0 Armor, burst damage"
   - "If we're outnumbered, apply Weakened"

4. Execute move
```

### Example AI Moves (By Type)

**OFFENSIVE MOVES:**
- "Kill Blow" — If target ≤20% HP, deal high damage (finish them)
- "Burst Attack" — If enemy has no Armor, deal max damage
- "Status Stack" — If target has 3+ Bleeding, apply more Bleeding
- "Focus Fire" — If one player unit is low HP, target them (finish weak first)

**DEFENSIVE MOVES:**
- "Heal Ally" — If allied unit < 50% HP, heal them
- "Gain Armor" — If we're low HP, stack defense
- "Apply Weakened" — If player is attacking hard, debuff them
- "Cleanse" — If we have Poison/Weakened, remove it

**POSITIONING MOVES:**
- "Guard Champion" — If Champion is low HP, position to block future damage
- "Protect Back Row" — If back-row enemy is low, move to guard
- "Expose Champion" — If front row all down, attack Champion (now unguarded)

**FACTION-SPECIFIC MOVES:**
- ECLIPSE: "Apply Bleeding first, burst later" (bleed setup → damage payoff)
- SPECTER: "Stack Poison early, finish with control" (poison ramp → weak control)
- AEGIS: "Build Armor, heal via Fortress" (defense → sustain)

### Decision Rules (Pseudocode)

```
IF (player_champion_hp < 20% AND enemy_can_finish):
  → Execute kill blow (high priority)

ELSE IF (self_hp < 30% AND heal_available):
  → Heal self (survival)

ELSE IF (player_frontline_all_down):
  → Attack unguarded Champion (exposed target)

ELSE IF (player_has_high_armor AND damage_blocked):
  → Apply Weakened debuff (bypass armor)

ELSE IF (self_has_status_effect AND cleanse_available):
  → Cleanse self (remove threat)

ELSE:
  → Default attack (damage highest HP target)
```

### Why This Works

✅ **More interesting than hardcoded priority** — Enemies adapt to field state
✅ **Not random** — Players can predict moves if they understand the chess moves
✅ **Scalable** — Easy to add new moves per enemy type
✅ **Tactical** — Players learn to anticipate enemy decisions
✅ **Balanced** — Can tune move selection without rewriting AI

### Implementation Notes

- Each enemy type has a "move pool" (8-12 possible moves)
- Moves have conditions (IF field_state, THEN execute_move)
- Conditions are evaluated every turn (dynamic response)
- Moves include attack card selection + target priority
- Complex enemies (elites, bosses) have more moves available

---

## 🎓 AI Example: Bruiser vs Squad

**Setup:**
```
Player: Champion (15 HP, back row) + Marcus (22 HP, front left) + Livia (18 HP, front center) + Titus (20 HP, front right)
Enemy: Bruiser (28 HP), with moves:
  A) "Kill Blow" — If target < 25% HP
  B) "Armor Up" — If self < 35% HP
  C) "Burst Attack" — If target has no Armor
  D) "Focus Front" — If front row all healthy, wear them down
  E) "Default Attack" — Damage highest HP
```

**Turn Flow:**
```
Turn 1: Champion 15 HP, Marcus 22 HP, Livia 18 HP, Titus 20 HP
→ Bruiser evaluates: Front row all healthy (3 units), back row vulnerable but protected
→ Focus Front: Deal 8 damage to Marcus (22 → 14 HP, highest front unit HP)

Turn 2: Champion 15 HP, Marcus 14 HP, Livia 18 HP, Titus 20 HP
→ Bruiser evaluates: Marcus getting low (63% HP), Livia healthy, Titus healthy
→ Kill Blow condition: 14 < 25%? YES
→ Execute Kill Blow: Deal 16 damage to Marcus
→ Marcus KO'd (combat continues with Champion + Livia + Titus)

Turn 3: Champion 15 HP, Livia 18 HP, Titus 20 HP (Marcus out)
→ Bruiser evaluates: Still 2 front units protecting back row, but Marcus is gone
→ Burst Attack: Deal 12 damage to Livia (18 → 6 HP, more damaged target)

Turn 4: Champion 15 HP, Livia 6 HP, Titus 20 HP
→ Bruiser evaluates: Livia is critical (30% HP), should finish
→ Kill Blow condition: 6 < 25%? YES
→ Execute Kill Blow: Deal 16 damage to Livia
→ Livia KO'd (Champion now has only Titus protecting)
→ After this, Champion is more exposed (only 1 front unit)
```

---

---

## 💀 WIN/LOSS CONDITIONS

```
Victory:
- All enemy units reach 0 HP

Defeat:
- Champion reaches 0 HP (immediate loss)
- Retreat: Keep partial rewards, take injury risk

Tie (both reach 0 HP same turn):
- Player wins tie (Champion survives, enemy dies)
```

---

## 📊 RESOURCE CAPS & LIMITS (SHARED SQUAD)

```
Stamina: 3/turn (shared), cap 6, resets end of turn
Mana: +1/turn + bonuses (shared), cap 12, persists
Hand: 8 card max (shared)
Armor: No cap (persists per unit)
Status effects: Per unit, individual tracking
```

---

## 🔒 PRODUCTION LOCK STATUS

**✅ ALL SQUAD RULES LOCKED FOR V1**

### Locked Decisions:
- One shared squad turn (not unit-by-unit)
- Shared resource pools (Stamina, Mana, hand)
- **Squad Size: Champion (back) + 3-4 Lieutenants (front row)**
- Champion faction determines deck
- Lieutenants add passives + signature cards only
- Player assigns cards to units
- Player picks targets (full control)
- KO'd unit sits out (not revived)
- **Positioning: Back (Champion), Front (3-4 Lieutenants in formation)**
- **Blocking: Front units can intercept back-row damage (player chooses which)**
- **Enemy AI: Dynamic chess moves (conditional decisions, not hardcoded priority)**
- Bench system with progressive gold cost (50g → 150g → 300g → 500g)
- 2-fight lockout on swaps (can't swap back in for 2 fights minimum)
- Tent-based camp (1-2 per mission, limited between-fight healing)
- Front row can be damaged/knocked out (exposes Champion)

### Deferred to Progression Phase:
- Exact XP catch-up bonus values
- Specific tent counts per mission (1-2 or 2-3)
- Lieutenant-specific combat scaling

---

## 🎮 FULL SQUAD COMBAT EXAMPLE

**Setup:**
- **Player Squad:**
  - Champion (AEGIS, 30 HP, 5 Armor, Speed 2, back row)
  - Marcus the Veteran (25 HP, Disciplined trait, front left)
  - Livia the Cultist (20 HP, Blessed trait +2 Mana start, front center)
  - Titus the Noble (22 HP, Connected trait, front right)
- **Enemy Squad:** Scout (15 HP, front) + Bruiser (20 HP, 0 Armor, front)
- **Squad Speed:** 2 (Champion base) → Your squad acts first

---

### YOUR SQUAD TURN 1:

**Start of Turn:**
- No DoT effects (first turn)
- Gain 3 Stamina (shared pool)
- Gain 1 Mana + 2 Mana (Livia trait) = 3 Mana total (shared)
- Draw 1 card + 1 bonus (Livia) = 2 cards drawn (hand now has 7)

**Main Phase:**
1. **Play Shield Bash (1 Stamina)** → Assign to Champion
   - Deal 5 damage to Scout, gain 3 Armor
   - Scout takes 5 damage (Scout 10 HP remaining)
   - Champion gains 3 Armor (now 8 total)
   - AEGIS Fortress triggers: Restore 1 HP (heal 1) (31 HP)
   - Gain +1 Mana (now 4 Mana)

2. **Play Slash (1 Stamina)** → Assign to Marcus
   - Deal 6 damage, apply Bleeding 1
   - Target Bruiser: Takes 6 damage (Bruiser 14 HP remaining)
   - Bruiser: Bleeding 1 applied
   - Gain +1 Mana (now 5 Mana)

3. **Play Enfeeble (1 Stamina)** → Assign to Livia
   - Apply Weakened 2 to Bruiser
   - Bruiser: Weakened 2 applied (will reduce damage output next turn)
   - Gain +1 Mana (now 6 Mana)

4. **Play Titus's Command (2 Stamina)** → Assign to Titus
   - "Target ally gains 4 Armor"
   - Marcus gains 4 Armor (front-row protection)
   - Gain +1 Mana (now 7 Mana)

**End of Turn:**
- Stamina: 0 remaining (lost)
- Mana: 7 (persists to next turn)
- Hand: 3 cards (under 8 limit)
- Squad Status: All 4 units healthy, Marcus gaining Armor, Bruiser weakened
- Pass to enemy turn

---

### ENEMY SQUAD TURN 1:

Scout (Speed 2 + modifiers):
- No DoT effects
- Gain 3 Stamina, 1 Mana
- Draw 1 card
- **Play Attack (1 Stamina):** Deal 6 damage to Champion
  - Champion: 6 damage - 3 Armor = 3 damage to HP (27 HP remaining, 0 Armor)

Bruiser (Speed 1, slower):
- No DoT effects
- Gain 3 Stamina, 1 Mana
- Draw 1 card
- **Play Attack (1 Stamina):** Deal 8 damage to Champion
  - Champion: 8 damage - 0 Armor = 8 damage to HP (19 HP remaining)
  - Weakened 2 reduces output: 8 × 0.75 = 6 (rounded down)
  - Actually: 6 damage to Champion (19 HP remaining)

**End of Turn:**
- Bleeding 1 on Bruiser (will tick next turn)
- Weakened 2 on Bruiser (will decay next turn)
- Pass to player

---

**Combat continues...**

---

## 🔗 INTEGRATION WITH EXISTING SYSTEMS

### How Squad Combat Interacts With:

**Combat System (LOCKED):**
- ✅ Damage calculation: Per unit, using their faction passives
- ✅ Status effects: Tracked per unit (Bleeding on unit A, Poison on unit B)
- ✅ Resource generation: Shared Stamina/Mana (no change)
- ✅ Turn order: Based on squad Speed (sum of champion + bonuses)

**Injury System (LOCKED):**
- ✅ Individual HP tracking: Each unit tracked separately
- ✅ KO mechanics: When unit hits 0 HP, they sit out (can re-enter via bench)
- ✅ Injury distribution: After mission, determine which units get injured

**Gear System (NEEDS UPDATE):**
- ⚠️ Currently designed for 1 unit (3 slots)
- 🔄 NEW: 5-slot system (Champion 3, Lieutenants 1 each)

**Card System (NEEDS UPDATE):**
- ⚠️ Cards designed for single unit
- 🔄 NEW: Signature cards per lieutenant, unit-specific bonuses

**Progression (NEEDS UPDATE):**
- ⚠️ Currently 1 unit leveling
- 🔄 NEW: Each lieutenant levels independently, catch-up XP on swap

---

## 📝 IMPLEMENTATION CHECKLIST

### Phase 1 (Core Squad Combat):
- [ ] Implement shared squad turn (not unit-by-unit)
- [ ] Implement card assignment (choose unit to execute)
- [ ] Implement individual HP tracking per unit
- [ ] Implement KO mechanics (unit sits out)
- [ ] Implement shared resource pools (Stamina, Mana)
- [ ] Implement target selection (player chooses)

### Phase 2 (Bench System):
- [ ] Implement bench swapping (gold cost escalation)
- [ ] Implement 2-fight lockout (can't swap back in immediately)
- [ ] Implement catch-up XP (100% → 150% → 200%)
- [ ] Implement deck reset on swap

### Phase 3 (Tent System):
- [ ] Implement tent resource per mission (1-2)
- [ ] Implement between-fight camp (swap, heal, rebuild)
- [ ] Implement tent depletion (use 1, decrement counter)

### Phase 4 (Integration):
- [ ] Update gear system to 5-slot model
- [ ] Update card library with signature cards
- [ ] Update progression for individual lieutenant leveling
- [ ] Update injury system for squad distribution

---

**Document Status:** ✅ LOCKED FOR PRODUCTION
**Ready for:** Implementation, Integration with Gear/Cards/Progression
**Version:** 1.0 Final - Squad rules complete

**Next Step:** Align Gear System (5 slots), Card System (signature cards), Progression (lieutenant leveling)

---

**End of Document**
