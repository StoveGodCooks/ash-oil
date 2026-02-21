# Combat System Rules - Complete Design

> **Version:** V1 Locked  
> **Dependencies:** Factions (locked), Status Effects (locked), Resources (pinned for later)

---

## Overview

This document defines the complete combat loop, turn structure, damage calculation, deck mechanics, and all timing rules for the gladiator card game.

---

## Pre-Combat Setup

### Deck Composition
**Starting Deck (Level 1):**
- 10 cards total
- Composition varies by faction (suggested):
  - 5x Basic Attack (faction-specific Strike variant)
  - 3x Faction Starter Cards (the 3 cards marked "Level 1" in faction design)
  - 2x Defend/Block cards (generic or faction-flavored)

**Max Deck Size:** 40 cards (hard cap)

**Card Limits:**
- No limit on copies of Common cards
- Max 3 copies of Rare cards
- Max 2 copies of Epic cards
- Max 1 copy of Ultimate cards

### Starting Conditions
**Player:**
- Full HP (faction-specific: AEGIS 30, ECLIPSE 20, SPECTER 25)
- Base Armor (faction-specific: AEGIS 5, ECLIPSE 0, SPECTER 2)
- 0 Mana
- 0 status effects
- Deck shuffled
- Draw starting hand: 5 cards

**Enemy:**
- Varies by mission (HP, Armor, deck composition)
- May have pre-applied status effects (mission-specific)

---

## Turn Structure (Detailed)

### Phase 1: START OF TURN

#### 1A. Determine Turn Order (First Turn Only)
**Speed stat determines who goes first:**
- Higher Speed = acts first
- Tie: Player wins ties (always acts first if Speed is equal)

**Speed values:**
- AEGIS: 2 (slowest)
- SPECTER: 4 (medium)
- ECLIPSE: 5 (fastest)

**Turn order remains fixed** for entire combat (doesn't recalculate each turn)

#### 1B. Start of Turn Triggers (in this order):
1. **Damage over Time effects trigger:**
   - **Bleeding:** Take damage = Bleeding stacks, then reduce Bleeding by 1
   - **Poison:** Take damage = Poison stacks (Poison does NOT reduce)
   - Damage goes directly to HP (ignores Armor)
   - **Death check:** If HP reaches 0, combat ends immediately (before any other actions)

2. **Faction passive triggers:**
   - **SPECTER Miasma:** If acting character is SPECTER AND enemy has Poison, apply +1 Poison to enemy
   - **AEGIS Fortress:** Passive (no start-of-turn trigger)
   - **ECLIPSE Bloodlust:** Passive (no start-of-turn trigger)

3. **Resource generation:**
   - **Gain Stamina:** +3 (base, can be modified by gear/upgrades)
   - **Gain Mana:** +1 (passive generation, can be modified)

4. **Card draw:**
   - Draw 1 card (base, can be modified by gear)
   - If deck is empty, shuffle discard pile into new deck, then draw

#### 1C. Status Effect Updates:
- Duration-based effects are still active (Weakened, Enraged)
- No decay yet (decay happens end of turn)

---

### Phase 2: MAIN PHASE (Play Cards & Abilities)

#### 2A. Actions Available:
1. **Play cards from hand** (costs Stamina)
2. **Use hero abilities** (costs Mana)
3. **Pass turn** (end turn voluntarily)

#### 2B. Card Playing Rules:
**Cost:**
- Each card has a Stamina cost (0-4)
- Must have enough Stamina to play
- Stamina is spent immediately when card is played

**Playing a card:**
1. Choose card from hand
2. Spend Stamina
3. **Immediately resolve card effect** (no stack, no response window)
4. Card goes to discard pile (unless it says "Exhaust")

**Card types:**
- **Attack cards:** Deal damage (affected by Weakened, Enraged, blocked by Armor)
- **Skill cards:** Apply status effects, gain Armor, draw cards, etc.
- **Exhaust cards:** After use, removed from combat entirely (goes to Exhaust pile, not discard)

#### 2C. Ability Using Rules:
**Cost:**
- Each ability has a Mana cost (3-9)
- Must have enough Mana to use
- Mana is spent immediately when ability is used
- Mana persists between turns (doesn't reset like Stamina)

**Using an ability:**
1. Choose ability (if you have enough Mana)
2. Spend Mana
3. **Immediately resolve ability effect**
4. Abilities don't go to discard (they're permanent character abilities)

#### 2D. Action Resolution Order:
- All effects resolve **immediately** when played/used
- No "stack" or "response window" (not like Magic: the Gathering)
- Example sequence:
  1. Play Shield Bash (1 Stamina): Deal 5 damage, Gain 3 Armor
     - Enemy takes 5 damage (after Armor reduction)
     - You gain 3 Armor
     - AEGIS Fortress triggers: Restore 1 HP (30% of 3 Armor)
  2. Play Fortify (2 Stamina): Gain 8 Armor
     - You gain 8 Armor (total now 11)
     - AEGIS Fortress triggers: Restore 2 HP (30% of 8 Armor)
  3. Use Bulwark ability (4 Mana): Gain Armor = 50% missing HP
     - Calculate: If missing 10 HP, gain 5 Armor
     - AEGIS Fortress triggers: Restore 1 HP (30% of 5 Armor)

#### 2E. Mana Generation During Turn:
- **+1 Mana per card played** (triggers immediately after card resolves)
- **+1 Mana per 5 damage taken** (triggers immediately after taking damage)
- Mana generation can enable ability usage mid-turn

**Example:**
- Start turn with 2 Mana
- Play 2 cards (+2 Mana) → now at 4 Mana
- Can now use ability that costs 4 Mana

---

### Phase 3: END OF TURN

#### 3A. Duration-based Status Effects Decay:
- **Weakened:** Reduce duration by 1 (e.g., Weakened 3 → Weakened 2)
- **Enraged:** Reduce duration by 1 (e.g., Enraged 2 → Enraged 1)
- When duration reaches 0, status effect is removed

#### 3B. Hand Limit:
- **Max hand size:** 8 cards
- If you have more than 8 cards, **discard down to 8** (you choose which to discard)

#### 3C. Stamina Reset:
- **All unused Stamina is lost**
- Does not carry over to next turn

#### 3D. Armor Persistence:
- **Armor does NOT decay**
- Armor carries over to opponent's turn (persistent defense)

#### 3E. Turn Passes:
- Opponent's turn begins
- Return to Phase 1 (Start of Turn) for opponent

---

## Damage Calculation (Detailed)

### Base Damage Formula:

```
Final Damage = Base Damage × Modifiers - Armor
(Minimum 0 damage)
```

### Step-by-Step Calculation:

#### Step 1: Determine Base Damage
- From card effect (e.g., "Deal 6 damage")
- Or from ability (e.g., "Deal 15 damage")

#### Step 2: Apply Offensive Modifiers (Multiplicative)
**Enraged (attacker has Enraged):**
- Base Damage × 1.5

**Weakened (attacker has Weakened):**
- Base Damage × 0.75

**Both (Enraged + Weakened on attacker):**
- Base Damage × 1.5 × 0.75 = Base Damage × 1.125

**ECLIPSE Bloodlust (target has Bleeding or Poison):**
- Add +2 damage (flat bonus, applied after multipliers)

**Rounding:**
- Round DOWN after all multipliers applied

#### Step 3: Apply Armor (Defender)
- Subtract defender's current Armor from damage
- Each point of Armor blocks 1 point of damage (1:1 ratio)
- Armor is depleted by damage blocked
- Excess damage (after Armor is depleted) goes to HP

#### Step 4: Apply Defensive Modifiers (if defender has Enraged)
**Enraged (defender has Enraged):**
- Damage × 1.25
- Applied AFTER Armor reduction

**Rounding:**
- Round DOWN

#### Step 5: Subtract from HP
- Final damage is subtracted from defender's HP
- If HP reaches 0 or below, defender is Downed

---

### Damage Calculation Examples:

#### Example 1: Simple Attack
**Attacker:** ECLIPSE plays Slash (6 damage), no modifiers  
**Defender:** AEGIS with 8 Armor

```
Base Damage: 6
Modifiers: None
Armor: 8
Final Damage to HP: 0 (6 - 8 = -2, minimum 0)
Armor remaining: 2 (8 - 6 = 2)
```

#### Example 2: Enraged Attacker
**Attacker:** ECLIPSE plays Slash (6 damage), has Enraged  
**Defender:** AEGIS with 8 Armor

```
Base Damage: 6
Enraged multiplier: 6 × 1.5 = 9 damage
Armor: 8
Final Damage to HP: 1 (9 - 8 = 1)
Armor remaining: 0 (8 - 9 = -1, minimum 0)
```

#### Example 3: Weakened Attacker
**Attacker:** AEGIS plays Shield Bash (5 damage), has Weakened  
**Defender:** ECLIPSE with 0 Armor

```
Base Damage: 5
Weakened multiplier: 5 × 0.75 = 3.75 → 3 damage (round down)
Armor: 0
Final Damage to HP: 3
```

#### Example 4: Bloodlust Bonus
**Attacker:** ECLIPSE plays Predator (9 damage if target has Bleeding)  
**Defender:** SPECTER with 2 Armor, has Bleeding 3

```
Base Damage: 9 (condition met: target has Bleeding)
Bloodlust bonus: +2 (passive, target has Bleeding)
Total: 11 damage
Armor: 2
Final Damage to HP: 9 (11 - 2 = 9)
Armor remaining: 0
```

#### Example 5: Complex (Enraged Attacker + Weakened + Bloodlust + Enraged Defender)
**Attacker:** ECLIPSE plays Execution (12 damage), has Enraged  
**Defender:** AEGIS with 10 Armor, has Weakened (doesn't affect defender), has Enraged

```
Base Damage: 12
Enraged (attacker): 12 × 1.5 = 18 damage
Weakened: Not on attacker, no effect
Bloodlust: Target has no Bleeding/Poison, no bonus
Armor: 10
Damage after Armor: 18 - 10 = 8
Enraged (defender): 8 × 1.25 = 10 damage (defender takes MORE damage)
Final Damage to HP: 10
Armor remaining: 0
```

---

## Special Damage Rules

### Damage over Time (Bleeding, Poison)
- **Ignores Armor entirely** (goes straight to HP)
- **Not affected by Weakened** (attacker's Weakened doesn't reduce DoT damage)
- **IS affected by defender's Enraged** (defender takes +25% more)

**Example:**
- Defender has Bleeding 5, Poison 3, 10 Armor, and is Enraged
- Start of turn:
  - Bleeding: 5 damage (ignores 10 Armor)
  - Poison: 3 damage (ignores 10 Armor)
  - Total: 8 damage base
  - Enraged: 8 × 1.25 = 10 damage to HP
  - Armor: Still 10 (wasn't touched)

### Multi-Hit Attacks
- Some cards hit multiple times (e.g., ECLIPSE Flurry: "Deal 4 damage three times")
- **Each hit calculated separately** (important vs Armor)

**Example:**
- Flurry: 4 damage × 3 hits
- Defender has 8 Armor
- Hit 1: 4 damage - 8 Armor = 0 to HP, 4 Armor remaining
- Hit 2: 4 damage - 4 Armor = 0 to HP, 0 Armor remaining
- Hit 3: 4 damage - 0 Armor = 4 to HP
- **Total: 4 damage to HP, Armor depleted**

### Overkill Damage
- Damage beyond 0 HP is ignored (no "negative HP")
- Combat ends immediately when HP reaches 0

---

## Deck Mechanics

### Deck Structure
**Three piles during combat:**
1. **Draw Deck:** Cards you'll draw from
2. **Discard Pile:** Cards you've played (goes here after use)
3. **Exhaust Pile:** Cards removed from combat (doesn't shuffle back)

### Draw Rules
- **Starting hand:** 5 cards (drawn at combat start)
- **Per turn:** Draw 1 card at start of turn
- **Additional draws:** Some cards/abilities say "Draw X cards" (resolved immediately)

### Shuffle Rules
- **When deck is empty and you need to draw:**
  1. Shuffle entire discard pile
  2. Discard pile becomes new draw deck
  3. Then draw card(s)
- **Exhaust pile never shuffles back** (cards removed for entire combat)

### Hand Limit
- **Max hand size:** 8 cards
- At end of turn, discard down to 8 if over
- You choose which cards to discard

### Deck Size During Combat
- Deck size can shrink (cards Exhausted)
- Deck size does NOT grow during combat (no "add card to deck" effects in V1)
- Minimum deck size: 0 (you can exhaust all cards if needed)

---

## Win/Loss Conditions

### Victory Conditions
1. **Enemy HP reaches 0** → You win
2. **Enemy surrenders** (not implemented in V1, but possible later)

### Defeat Conditions
1. **Your HP reaches 0** → You are Downed
   - Combat ends immediately
   - Apply "Break" condition (Physical S1) post-combat
   - Return to hub with 40% HP (recovery floor)

2. **Deck out** (optional rule - not in V1):
   - If you need to draw but deck AND discard are empty
   - Take damage each turn until you die
   - (V1: This shouldn't happen - Exhaust is limited)

### Tie Condition
- **Simultaneous death** (both reach 0 HP same turn):
  - Player wins ties (you survive, enemy dies)
  - Rare edge case (DoT effects mostly)

---

## Special Combat Rules

### Speed Advantage
- **First turn only:** Speed determines turn order
- **Subsequent turns:** Order alternates (doesn't recalculate)
- **Ties:** Player always wins Speed ties

### Resource Limits
- **Stamina cap per turn:** 6 (can't exceed, even with boosts)
- **Mana cap total:** 12 (or 15 with endgame upgrade)
- **Hand size cap:** 8 cards (10 with gear)

### Status Effect Caps
- **Bleeding:** Max 12 stacks
- **Poison:** Max 12 stacks
- **Armor:** Max 30 stacks
- **Weakened:** Max 10 turns
- **Enraged:** Max 8 turns

### Death Checks
- **Checked immediately** after any damage instance
- If HP ≤ 0, combat ends (no more actions)

---

## Combat Items (Consumables)

### When Can Items Be Used?
- **During your Main Phase** (Phase 2)
- **Does not cost Stamina or Mana** (free action)
- **One item per turn** (limit to prevent spam)
- Items resolve immediately

### Item Types (examples, TBD in gear design):
- **Healing Potion:** Restore HP
- **Bandage:** Remove Bleeding
- **Antivenom:** Remove Poison
- **Energy Tonic:** Gain Stamina this turn
- **Mana Vial:** Gain Mana

### Item Limits:
- Inventory slots (TBD - maybe 3-5 slots)
- Items are consumed on use (single-use per combat)
- Restock at hub (purchase from Market)

---

## Advanced Mechanics (V1 Scope)

### Card Upgrades
- Some cards can be upgraded (hub service)
- **Upgraded effect:** Usually +damage, +status stacks, or -cost
- **Visual:** Card shows "+" symbol (e.g., "Shield Bash+" = 5→7 damage)
- Upgraded cards still count as same card for deck limits

### Temporary Buffs (Cards)
- Some cards grant temporary Stamina/Mana for one turn
- Example: "Second Wind" (1 Stamina) - Gain +2 Stamina this turn
- Temporary resources CAN exceed caps for that turn only
- Example: Base 3 Stamina + Second Wind = 5 Stamina this turn

### X-Cost Cards (V2 Feature - Not in V1)
- Cards that say "Spend all remaining Stamina/Mana"
- Effect scales with amount spent
- Example: "X-Cost: Deal damage equal to X"
- **Not in V1, but design space is reserved**

---

## Combat Flow Summary (Quick Reference)

### One Complete Turn:

```
START OF TURN:
1. DoT damage (Bleeding, Poison) → Death check
2. SPECTER Miasma trigger (if applicable)
3. Gain Stamina (+3 base)
4. Gain Mana (+1 base)
5. Draw 1 card

MAIN PHASE:
6. Play cards (spend Stamina)
7. Use abilities (spend Mana)
8. Gain Mana (+1 per card played, +1 per 5 damage taken)
9. Effects resolve immediately (damage, status, armor, etc.)

END OF TURN:
10. Weakened/Enraged duration -1
11. Discard down to 8 cards (if over)
12. Lose unused Stamina
13. Armor persists (doesn't decay)
14. Pass turn to opponent
```

---

## Combat Example (Full Turn Walkthrough)

**Setup:**
- **Player:** AEGIS (30 HP, 5 Armor, Speed 2)
- **Enemy:** ECLIPSE (20 HP, 0 Armor, Speed 5)
- Turn 1

---

### ECLIPSE Turn (goes first, Speed 5 > 2):

**Start of Turn:**
- No DoT effects
- Gain 3 Stamina (now 3 total)
- Gain 1 Mana (now 1 total)
- Draw 1 card (hand: 6 cards)

**Main Phase:**
1. **Play Slash (1 Stamina):** Deal 6 damage, Apply Bleeding 1
   - AEGIS: 6 damage - 5 Armor = 1 damage to HP (29 HP remaining, 0 Armor)
   - AEGIS: Bleeding 1 applied
   - ECLIPSE: Gain +1 Mana (now 2 Mana)

2. **Play Lacerate (2 Stamina):** Deal 7 damage, Apply Bleeding 2
   - AEGIS: 7 damage - 0 Armor = 7 damage to HP (22 HP remaining)
   - AEGIS: Bleeding 2 applied (now Bleeding 3 total)
   - ECLIPSE: Gain +1 Mana (now 3 Mana)

**End of Turn:**
- No duration effects to decay
- Hand size: 4 cards (under 8, no discard)
- Stamina: 0 remaining (lost)
- Pass to AEGIS

---

### AEGIS Turn:

**Start of Turn:**
- **Bleeding 3 triggers:** Take 3 damage (ignores armor) → 19 HP
- Bleeding reduces by 1 → **Bleeding 2** now
- Gain 3 Stamina (now 3 total)
- Gain 1 Mana (now 1 total)
- Draw 1 card (hand: 6 cards)

**Main Phase:**
1. **Play Shield Bash (1 Stamina):** Deal 5 damage, Gain 3 Armor
   - ECLIPSE: 5 damage - 0 Armor = 5 damage to HP (15 HP remaining)
   - AEGIS: Gain 3 Armor
   - AEGIS Fortress: Restore 1 HP (30% of 3 = 0.9 → 1 HP) (20 HP now)
   - AEGIS: Gain +1 Mana (now 2 Mana)

2. **Play Fortify (2 Stamina):** Gain 8 Armor
   - AEGIS: Gain 8 Armor (now 11 Armor total)
   - AEGIS Fortress: Restore 2 HP (30% of 8 = 2.4 → 2 HP) (22 HP now)
   - AEGIS: Gain +1 Mana (now 3 Mana)

**End of Turn:**
- No duration effects to decay
- Hand size: 4 cards (under 8)
- Stamina: 0 remaining (lost)
- Armor: 11 (persists)
- Pass to ECLIPSE

---

Combat continues...

---

## Open Questions for You:
 
 pinned for later addressing-
**Card upgrade costs:** Should upgrades be permanent (pay once, upgraded forever) or per-copy (upgrade each copy separately)?

---

## Implementation Checklist

### Phase 1 (Core Combat):
- [ ] Implement turn order (Speed-based, player wins ties)
- [ ] Implement damage calculation (modifiers, armor, rounding)
- [ ] Implement status effect timing (start of turn, end of turn)
- [ ] Implement deck mechanics (draw, discard, shuffle, exhaust)
- [ ] Implement resource generation (Stamina, Mana)
- [ ] Implement win/loss conditions

### Phase 2 (Polish):
- [ ] Add combat log (show damage calc step-by-step)
- [ ] Add visual indicators (HP bars, status icons)
- [ ] Add combat items (consumables)
- [ ] Add card upgrades
- [ ] Test all edge cases

### Phase 3 (Balancing):
- [ ] Playtest all faction matchups
- [ ] Verify damage formulas with spreadsheet
- [ ] Tune starting deck composition
- [ ] Adjust caps if needed
