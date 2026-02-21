# COMBAT SYSTEM - LOCKED FOR PRODUCTION (V1)

> **Status:** ✅ LOCKED - Ready for implementation  
> **Version:** 1.0 Final  
> **Last Updated:** Current Session  
> **Dependencies:** Factions (locked), Status Effects (locked)

---

## 🎯 DESIGN PHILOSOPHY

**Core Principles:**
1. **Immediate resolution** - No stack, no response window (simpler than MTG)
2. **Predictable timing** - Effects always happen in the same order
3. **Strategic depth** - Resource management + status exploitation
4. **Fair challenge** - Clear telegraphing, no hidden information
5. **Faction identity** - Each faction plays distinctly different

---

## 📋 PRE-COMBAT SETUP

### Deck Composition
**Starting Deck (Level 1):**
- 10 cards total
- Composition varies by faction:
  - 5x Basic Attack (faction-specific Strike variant)
  - 3x Faction Starter Cards (Level 1 cards from faction design)
  - 2x Defend/Block cards (generic or faction-flavored)

**Max Deck Size:** 40 cards (hard cap)

**Card Rarity Limits:**
- **Common:** Unlimited copies
- **Rare:** Max 3 copies per unique card
- **Epic:** Max 2 copies per unique card
- **Ultimate:** Max 1 copy per unique card

---

### Starting Conditions

**Player:**
- Full HP (faction-specific: AEGIS 30, ECLIPSE 20, SPECTER 25)
- Base Armor (faction-specific: AEGIS 5, ECLIPSE 0, SPECTER 2)
- 0 Mana
- 0 status effects
- Deck shuffled
- **Draw starting hand: 5 cards** ✅ LOCKED

**Enemy:**
- Varies by mission (HP, Armor, deck composition)
- May have pre-applied status effects (mission-specific)

---

## ⏱️ TURN STRUCTURE (COMPLETE)

### Phase 1: START OF TURN

#### 1A. Determine Turn Order (First Turn Only)
**Speed stat determines who goes first:**
- Higher Speed = acts first
- **Tie:** Player wins ties (always acts first if Speed is equal)

**Speed Values:**
- AEGIS: 2 (slowest)
- SPECTER: 4 (medium)
- ECLIPSE: 5 (fastest)

**Turn order remains fixed** for entire combat (doesn't recalculate each turn)

---

#### 1B. Start of Turn Triggers (in exact order):

**1. Damage over Time effects trigger:**
- **Bleeding:** Take damage = Bleeding stacks, then reduce Bleeding by 1
- **Poison:** Take damage = Poison stacks (Poison does NOT reduce)
- Damage goes directly to HP (ignores Armor)
- **Death check:** If HP reaches 0, combat ends immediately (before any other actions)

**2. Faction passive triggers:**
- **SPECTER Miasma:** If acting character is SPECTER AND enemy has Poison, apply +1 Poison to enemy
- **AEGIS Fortress:** Passive (always active, no start-of-turn trigger)
- **ECLIPSE Bloodlust:** Passive (always active, no start-of-turn trigger)

**3. Resource generation:**
- **Gain Stamina:** +3 (base, can be modified by gear/upgrades)
- **Gain Mana:** +1 (passive generation, can be modified)

**4. Card draw:**
- Draw 1 card (base, can be modified by gear)
- If deck is empty, shuffle discard pile into new deck, then draw

---

#### 1C. Status Effect Updates:
- Duration-based effects are still active (Weakened, Enraged)
- No decay yet (decay happens end of turn)

---

### Phase 2: MAIN PHASE (Play Cards & Abilities)

#### 2A. Actions Available:
1. **Play cards from hand** (costs Stamina)
2. **Use hero abilities** (costs Mana)
3. **Use combat items** (1 per turn, free action) ✅ LOCKED
4. **Pass turn** (end turn voluntarily)

---

#### 2B. Card Playing Rules

**Cost:**
- Each card has a Stamina cost (0-4)
- Must have enough Stamina to play
- Stamina is spent immediately when card is played

**Playing a card:**
1. Choose card from hand
2. Spend Stamina
3. **Immediately resolve card effect** (no stack, no response window)
4. Card goes to discard pile (unless it says "Exhaust")

**Card Types:**
- **Attack cards:** Deal damage (affected by Weakened, Enraged, blocked by Armor)
- **Skill cards:** Apply status effects, gain Armor, draw cards, etc.
- **Exhaust cards:** After use, removed from combat entirely (goes to Exhaust pile, not discard)

**Multi-Target Cards:** ✅ LOCKED
- YES, some cards can hit multiple targets or have self-harm effects
- Example: "Deal 10 damage to enemy, take 3 damage"
- Example: "Deal 5 damage to all enemies"
- Adds strategic risk/reward decisions

---

#### 2C. Ability Using Rules

**Cost:**
- Each ability has a Mana cost (3-9)
- Must have enough Mana to use
- Mana is spent immediately when ability is used
- **Mana persists between turns** (doesn't reset like Stamina)

**Using an ability:**
1. Choose ability (if you have enough Mana)
2. Spend Mana
3. **Immediately resolve ability effect**
4. Abilities don't go to discard (they're permanent character abilities)

---

#### 2D. Combat Item Usage ✅ LOCKED

**When Can Items Be Used:**
- During your Main Phase (Phase 2)
- Does not cost Stamina or Mana (free action)
- **ONE ITEM PER TURN** (limit to prevent spam)
- Items resolve immediately

**Item Types (examples):**
- **Healing Potion:** Restore HP
- **Bandage:** Remove Bleeding
- **Antivenom:** Remove Poison
- **Energy Tonic:** Gain +2 Stamina this turn
- **Mana Vial:** Gain +2 Mana

**Item Limits:**
- Inventory slots: 3-5 slots (TBD in progression design)
- Items are consumed on use (single-use per combat)
- Restock at hub (purchase from Market)

**V2 Expansion:** May add "2 items per turn" upgrade as campaign unlock

---

#### 2E. Action Resolution Order

**All effects resolve immediately when played/used** (no stack)

**Example sequence:**
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

---

#### 2F. Mana Generation During Turn

**Mana sources (all stack):**
- **+1 Mana per card played** (triggers immediately after card resolves)
- **+1 Mana per 5 damage taken** (triggers immediately after taking damage)
- **Gear/upgrades:** May modify base generation

**Mana generation enables mid-turn ability usage:**

Example:
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

## 🎲 DAMAGE CALCULATION (COMPLETE)

### Master Formula:

```
Step 1: Base Damage (from card/ability)
Step 2: Apply Offensive Modifiers (Enraged, Weakened)
Step 3: Apply Bloodlust Bonus (ECLIPSE only)
Step 4: Round DOWN
Step 5: Subtract Armor (defender)
Step 6: Apply Defensive Modifiers (Enraged defender)
Step 7: Round DOWN
Step 8: Subtract from HP (minimum 0)
```

---

### Step-by-Step Breakdown:

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

#### Step 3: Apply ECLIPSE Bloodlust (if applicable)
**Bloodlust (target has Bleeding OR Poison):**
- Add +2 damage (flat bonus, applied after multipliers)

#### Step 4: Round DOWN
- After all multipliers and bonuses, round down to nearest integer

#### Step 5: Apply Armor (Defender)
- Subtract defender's current Armor from damage
- Each point of Armor blocks 1 point of damage (1:1 ratio)
- Armor is depleted by damage blocked
- Excess damage (after Armor is depleted) goes to HP

**Armor Depletion:**
```
Attack: 10 damage
Defender has 7 Armor

Result: 7 blocked, 3 to HP
Armor remaining: 0
```

#### Step 6: Apply Defensive Modifiers (if defender has Enraged)
**Enraged (defender has Enraged):**
- Damage × 1.25
- Applied AFTER Armor reduction

#### Step 7: Round DOWN
- Final damage rounded down to nearest integer

#### Step 8: Subtract from HP
- Final damage is subtracted from defender's HP
- If HP reaches 0 or below, defender is Downed
- **Overkill damage is ignored** (no "negative HP")

---

### Damage Calculation Examples:

#### Example 1: Simple Attack
**Attacker:** ECLIPSE plays Slash (6 damage), no modifiers  
**Defender:** AEGIS with 8 Armor

```
Base Damage: 6
Modifiers: None
Bloodlust: No (target has no Bleeding/Poison)
After modifiers: 6
Armor: 8
Damage to HP: 0 (6 - 8 = -2, minimum 0)
Armor remaining: 2 (8 - 6 = 2)
```

#### Example 2: Enraged Attacker
**Attacker:** ECLIPSE plays Slash (6 damage), has Enraged  
**Defender:** AEGIS with 8 Armor

```
Base Damage: 6
Enraged: 6 × 1.5 = 9
Bloodlust: No
After modifiers: 9
Armor: 8
Damage to HP: 1 (9 - 8 = 1)
Armor remaining: 0
```

#### Example 3: Bloodlust Bonus
**Attacker:** ECLIPSE plays Predator (9 damage)  
**Defender:** SPECTER with 2 Armor, has Bleeding 3

```
Base Damage: 9
Modifiers: None
Bloodlust: +2 (target has Bleeding)
After modifiers: 11
Armor: 2
Damage to HP: 9 (11 - 2 = 9)
Armor remaining: 0
```

#### Example 4: Complex (Enraged Attacker + Bloodlust + Enraged Defender)
**Attacker:** ECLIPSE plays Slash (6 damage), has Enraged  
**Defender:** SPECTER with 0 Armor, has Bleeding 2 AND Enraged

```
Base Damage: 6
Enraged (attacker): 6 × 1.5 = 9
Bloodlust: +2 (target has Bleeding)
After modifiers: 11
Armor: 0
Damage after armor: 11
Enraged (defender): 11 × 1.25 = 13.75 → 13
Final Damage to HP: 13
```

#### Example 5: Multi-Hit vs Armor
**Attacker:** AEGIS plays Flurry (3 hits of 4 damage each)  
**Defender:** ECLIPSE with 7 Armor

```
Hit 1: 4 damage - 7 Armor = 0 to HP (3 Armor remaining)
Hit 2: 4 damage - 3 Armor = 1 to HP (0 Armor remaining)
Hit 3: 4 damage - 0 Armor = 4 to HP
Total: 5 damage to HP, Armor depleted
```

---

## 🎴 DECK MECHANICS

### Deck Structure (Three Piles During Combat)

1. **Draw Deck:** Cards you'll draw from
2. **Discard Pile:** Cards you've played (goes here after use)
3. **Exhaust Pile:** Cards removed from combat (doesn't shuffle back)

---

### Draw Rules

**Starting hand:** 5 cards (drawn at combat start) ✅ LOCKED  
**Per turn:** Draw 1 card at start of turn  
**Additional draws:** Some cards/abilities say "Draw X cards" (resolved immediately)

---

### Shuffle Rules

**When deck is empty and you need to draw:**
1. Shuffle entire discard pile
2. Discard pile becomes new draw deck
3. Then draw card(s)

**Exhaust pile never shuffles back** (cards removed for entire combat)

**Deck-out rule:** ✅ LOCKED - **INFINITE SHUFFLE, NO DAMAGE**
- If you need to draw but deck AND discard are empty (all cards Exhausted), you simply draw nothing
- No damage penalty for empty deck
- Combat continues (some cards generate resources without drawing)

---

### Hand Limit

**Max hand size:** 8 cards  
At end of turn, discard down to 8 if over (you choose which to discard)

**With gear/upgrades:** May increase to 10 cards (endgame upgrade)

---

### Deck Size During Combat

- Deck size can shrink (cards Exhausted)
- Deck size does NOT grow during combat (no "add card to deck" effects in V1)
- Minimum deck size: 0 (you can exhaust all cards if needed)

---

## 🏆 WIN/LOSS CONDITIONS

### Victory Conditions
1. **Enemy HP reaches 0** → You win
2. **Enemy surrenders** (not implemented in V1, but possible later)

### Defeat Conditions
1. **Your HP reaches 0** → You are Downed
   - Combat ends immediately
   - Apply "Break" condition (Physical S1) post-combat
   - Return to hub with 40% HP (recovery floor)

### Tie Condition
**Simultaneous death (both reach 0 HP same turn):**
- **Player wins ties** (you survive, enemy dies)
- Rare edge case (DoT effects mostly)

---

## 📊 RESOURCE LIMITS & CAPS

### Stamina
- **Base per turn:** 3 Stamina
- **Cap per turn:** 6 (can't exceed, even with temporary boosts)
- **Carries over:** NO (lost at end of turn)

### Mana
- **Base per turn:** +1 Mana
- **Per card played:** +1 Mana
- **Per 5 damage taken:** +1 Mana
- **Total cap:** 12 (or 15 with endgame upgrade)
- **Carries over:** YES (persists between turns)

### Hand Size
- **Base max:** 8 cards
- **With upgrades:** 10 cards (gear/campaign unlock)

### Status Effect Caps (see Status Effects doc)
- Bleeding: Max 12 stacks
- Poison: Max 12 stacks
- Armor: Max 30 stacks
- Weakened: Max 10 turns
- Enraged: Max 8 turns

---

## ⚡ SPECIAL COMBAT RULES

### Speed Advantage
- **First turn only:** Speed determines turn order
- **Subsequent turns:** Order alternates (doesn't recalculate)
- **Ties:** Player always wins Speed ties

### Death Checks
- **Checked immediately** after any damage instance
- If HP ≤ 0, combat ends (no more actions)
- DoTs can kill you BEFORE you can act on your turn

### Simultaneous Effects
- When multiple effects trigger simultaneously (rare), resolve in this order:
  1. DoT damage (Bleeding, then Poison)
  2. Faction passives (Miasma, Fortress, Bloodlust)
  3. Resource generation
  4. Card draw

---

## 🎯 COMBAT FLOW SUMMARY (QUICK REFERENCE)

### One Complete Turn:

```
═══════════════════════════════════════════
START OF TURN:
═══════════════════════════════════════════
1. DoT damage (Bleeding, Poison) → Death check
2. SPECTER Miasma trigger (if applicable)
3. Gain Stamina (+3 base)
4. Gain Mana (+1 base)
5. Draw 1 card

═══════════════════════════════════════════
MAIN PHASE:
═══════════════════════════════════════════
6. Play cards (spend Stamina)
7. Use abilities (spend Mana)
8. Use 1 combat item (free, optional)
9. Gain Mana (+1 per card played, +1 per 5 damage taken)
10. Effects resolve immediately (damage, status, armor, etc.)

═══════════════════════════════════════════
END OF TURN:
═══════════════════════════════════════════
11. Weakened/Enraged duration -1
12. Discard down to 8 cards (if over)
13. Lose unused Stamina
14. Armor persists (doesn't decay)
15. Pass turn to opponent
```

---

## 💡 ADVANCED MECHANICS

### Card Upgrades ⚠️ TO BE DECIDED LATER
- Cards can be upgraded at hub (service cost TBD)
- Upgraded effect: Usually +damage, +status stacks, or -cost
- Visual indicator: "+" symbol (e.g., "Shield Bash+")
- **Upgrade cost system:** TO BE DECIDED
  - Option A: Permanent (pay once, all copies upgraded forever)
  - Option B: Per-copy (upgrade each copy separately)
  - **Decision deferred to progression design phase**

### Temporary Resource Boosts
- Some cards grant temporary Stamina/Mana for current turn only
- Example: "Second Wind" (1 Stamina) - Gain +2 Stamina this turn
- Temporary resources CAN exceed caps for that turn only
- Example: Base 3 Stamina + Second Wind = 5 Stamina this turn (exceeds 6 cap temporarily)

### X-Cost Cards (V2 Feature - Not in V1)
- Cards that say "Spend all remaining Stamina/Mana"
- Effect scales with amount spent
- Example: "X-Cost: Deal damage equal to X"
- **Not in V1, but design space is reserved**

---

## 📝 IMPLEMENTATION CHECKLIST

### Phase 1 (Core Combat):
- [ ] Implement turn order (Speed-based, player wins ties)
- [ ] Implement damage calculation (modifiers, armor, rounding)
- [ ] Implement status effect timing (start of turn, end of turn)
- [ ] Implement deck mechanics (draw, discard, shuffle, exhaust)
- [ ] Implement resource generation (Stamina, Mana)
- [ ] Implement win/loss conditions
- [ ] Implement death checks (immediate after damage)
- [ ] Implement item usage (1 per turn, free action)

### Phase 2 (Polish):
- [ ] Add combat log (show damage calc step-by-step)
- [ ] Add visual indicators (HP bars, status icons)
- [ ] Add combat items (consumables)
- [ ] Add multi-target card support
- [ ] Test all edge cases

### Phase 3 (Balancing):
- [ ] Playtest all faction matchups
- [ ] Verify damage formulas with spreadsheet
- [ ] Tune starting deck composition
- [ ] Adjust caps if needed
- [ ] Validate Mana generation rates

---

## 🔒 PRODUCTION LOCK STATUS

**✅ ALL CORE RULES LOCKED FOR V1**

### Locked Decisions:
- Starting hand: 5 cards
- Item limit: 1 per turn
- Multi-target attacks: YES (enabled)
- Deck-out: Infinite shuffle, no damage
- Turn structure: 3 phases as defined
- Damage calculation: Complete formula locked
- Resource generation: 3 Stamina/turn, 1 Mana/turn + bonuses

### Deferred to Progression Phase:
- Card upgrade cost system (permanent vs per-copy)
- Exact item inventory size (3-5 slots)
- Endgame resource cap increases (exact values)

**NO FURTHER CHANGES without playtesting data proving balance issues**

---

## 🎮 FULL COMBAT EXAMPLE

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
- Armor: 11 (persists to next turn)
- Pass to ECLIPSE

---

**Combat continues...**

---

**Document Status:** ✅ LOCKED FOR PRODUCTION  
**Ready for:** Implementation, Combat Simulator, Playtesting  
**Version:** 1.0 Final - Core rules complete

**Next Design Step:** Lock progression system (card unlocks, stat growth) OR build combat simulator

**Deferred Decisions:** Card upgrade costs (will be decided in progression phase)
