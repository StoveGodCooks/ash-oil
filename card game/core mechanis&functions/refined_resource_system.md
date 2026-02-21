# Refined Dual-Resource Combat System (Stamina + Mana)

> **Based on research:** Slay the Spire, Monster Train, Hearthstone, Marvel Snap  
> **Goal:** Dynamic resources with clear balance guardrails

---

## Key Takeaways from Similar Games

### Slay the Spire (Energy System)
✅ **Base 3 energy per turn** - industry standard sweet spot  
✅ **Energy doesn't carry over** - prevents hoarding, forces decisions  
✅ **Boss relics add +1 energy with harsh trade-offs** - Coffee Dripper (no rest), Cursed Key (curses from chests), Ectoplasm (no gold)  
✅ **Hard cap at 10 energy** - prevents infinite scaling  
✅ **Temporary energy cards** (Innervate, Bloodletting) - burst turns without permanent scaling  
✅ **X-cost cards** - spend all remaining energy for scaling effects  

### Monster Train (Multiple Resources)
✅ **Multiple resource pools** work when clearly differentiated  
✅ **Pyre = HP pool** (persistent), **Mana = per-turn** (refresh)  
✅ **Capacity system** - limits how many units per floor (spatial resource)  
✅ **Resource generation mechanics** - Dragon's Hoard builds over time for big payoffs  
✅ **Risk/reward** - taking damage to Pyre can grant bonuses  

### Hearthstone (Mana Crystals + Hero Powers)
✅ **Ramping mana** - 1→2→3 mana per turn up to 10  
✅ **Hero powers cost 2 mana, once per turn** - always available baseline action  
✅ **Mana doesn't carry over** - use it or lose it  
✅ **Hard cap at 10 mana** - prevents infinite scaling  
✅ **Temporary mana** (The Coin, Innervate) - burst plays  
✅ **Overload mechanic** - pay now, lock next turn's mana (risk/reward)  

### Marvel Snap (Linear Energy Progression)
✅ **Turn 1 = 1 energy, Turn 2 = 2 energy, etc.** - extremely simple  
✅ **No carry-over** - forces spending  
✅ **6 turn games** - short and decisive  
✅ **Locations modify energy** (+1 energy this turn, etc.)  
✅ **Simplicity = accessibility** - new players understand instantly  

---

## Our System: **Stamina (Cards) + Mana (Abilities)**

### Design Pillars
1. **Stamina is tactical** - moment-to-moment card plays
2. **Mana is strategic** - build toward ability usage
3. **Both scale dynamically** - gear/cards can boost, but capped
4. **Hard caps prevent degenerate combos**
5. **Multiple paths to generation** - passive, active, risk/reward

---

## STAMINA SYSTEM (for playing cards)

### Base Rules
- **Starting Stamina per turn:** 3
- **Hard cap:** 6 Stamina per turn (cannot exceed this)
- **Carry-over:** NO - unused Stamina is lost at end of turn
- **Ramping:** Optional - could start at 2, scale to 3 at turn 3+

### Stamina Generation Options

#### OPTION A: Fixed 3 per turn (Recommended for V1)
- **Simple**, **predictable**, **easy to balance**
- Turn 1: 3 Stamina
- Turn 2: 3 Stamina
- Every turn: 3 Stamina
- **Pro:** Consistent tempo, cards costs (1-4) fit perfectly
- **Con:** No early-game ramp fantasy

#### OPTION B: Ramping (Marvel Snap / Hearthstone style)
- Turn 1: 1 Stamina
- Turn 2: 2 Stamina
- Turn 3: 3 Stamina
- Turn 4+: 3 Stamina (cap)
- **Pro:** Creates early/mid/late game phases
- **Con:** First 2 turns feel slow, balancing early cards is harder

**Recommendation:** **Option A** for V1 (fixed 3). Can test Option B later if early game feels too explosive.

---

### Ways to Boost Stamina (capped at 6 total)

#### GEAR (Accessories)
**Energy Talisman** (Common Accessory)
- +1 Stamina per turn (3→4)
- *Trade-off:* Uses accessory slot

**Berserker's Band** (Rare Accessory)
- +1 Stamina per turn
- Start each combat with -5 HP
- *Trade-off:* Risk/reward

**Adrenaline Charm** (Epic Accessory)  
- +2 Stamina per turn (3→5)
- Take 2 damage at the start of each turn
- *Trade-off:* Heavy risk/reward

#### CARDS (Temporary Boosts)
**Second Wind** (1 Stamina, Exhaust)
- Gain +2 Stamina this turn only
- *Net: +1 Stamina for this turn*

**Adrenaline Rush** (2 Stamina)
- Gain +3 Stamina. Take 3 damage.
- *Net: +1 Stamina, costs HP*

**Battle Trance** (0 Stamina, Exhaust)
- Gain +1 Stamina this turn. Apply Weakened 1 to yourself next turn.
- *Delayed cost*

#### CAMPAIGN UPGRADES (Permanent Unlocks)
**Efficient Fighter I** (Level 5 unlock, 200 gold)
- Start turn 1 with +1 Stamina (one-time bonus)

**Efficient Fighter II** (Level 10 unlock, 500 gold)
- Increase base Stamina from 3→4
- *Expensive, late-game only*

**Efficient Fighter III** (Level 15 unlock, 1000 gold)
- Increase base Stamina from 4→5
- *Very expensive, endgame only*

---

## MANA SYSTEM (for hero abilities)

### Base Rules
- **Mana generation:** Multiple sources (passive + actions)
- **Max Mana cap:** 12 (hard cap)
- **Carry-over:** YES - Mana persists between turns (builds up over fight)
- **Starting Mana:** 0 (or 2-3 to enable Ability 1 sooner - TBD)

### Mana Generation Formula (Base)

**Passive Generation:**
- +1 Mana at the start of each turn

**Active Generation:**
- +1 Mana per card played
- +1 Mana per 5 damage taken

**Example Fight:**
- Turn 1: Start with 0, gain 1 (passive), play 2 cards → End with 3 Mana
- Turn 2: Start with 3, gain 1 (passive), play 3 cards → End with 7 Mana (can use Ability 2 which costs 7-8)
- Turn 3: Start with 7, gain 1 (passive), take 10 damage (+2), play 2 cards → End with 12 Mana (capped)

---

### Ability Costs (Baseline)

**Passive Ability:** Free, always active
- AEGIS: Fortress (Armor → HP conversion)
- ECLIPSE: Bloodlust (+2 damage to bleeding enemies)
- SPECTER: Miasma (+1 Poison at start of turn)

**Ability 1:** 3-4 Mana (accessible turn 2-3)
- AEGIS: Bulwark (4 Mana) - Gain Armor = 50% missing HP
- ECLIPSE: Blood Rush (3 Mana) - Next attack +8 damage
- SPECTER: Enfeeble (3 Mana) - Apply Weakened 4, enemy discards 1 card

**Ability 2:** 7-9 Mana (accessible turn 3-5)
- AEGIS: Aegis Wall (8 Mana) - Gain 15 Armor, Weakened 5, Draw 1
- ECLIPSE: Execute (7 Mana) - Deal 15 damage, restore 10 HP if kill
- SPECTER: Virulent Plague (8 Mana) - Double Poison, deal damage = Poison stacks

---

### Ways to Boost Mana Generation

#### GEAR (Accessories)
**Arcane Crystal** (Common Accessory)
- +1 Mana per turn (passive generation 1→2)
- *Trade-off:* Uses accessory slot

**Bloodstone Ring** (Rare Accessory)
- Gain Mana per 3 damage taken (instead of per 5)
- *Trade-off:* Rewards risky play

**Mana Battery** (Epic Accessory)
- Start each combat with 4 Mana
- *Trade-off:* Front-loads power, doesn't affect generation rate

#### CARDS (Mana Acceleration)
**Focus** (1 Stamina)
- Gain 2 Mana. Draw 1 card.
- *Converts Stamina → Mana + card*

**Sacrifice** (0 Stamina, Exhaust)
- Lose 5 HP. Gain 3 Mana.
- *High risk, burst Mana*

**Meditate** (2 Stamina, Exhaust)
- Gain 4 Mana. Exhaust.
- *One-time burst*

#### FACTION-SPECIFIC MANA GENERATION
**AEGIS Bonus:**
- Gain +1 Mana when you gain 8+ Armor in one turn
- *Rewards defensive plays*

**ECLIPSE Bonus:**
- Gain +1 Mana when you deal 12+ damage in one turn
- *Rewards burst damage*

**SPECTER Bonus:**
- Gain +1 Mana when you apply 3+ status stacks in one turn
- *Rewards status application*

#### CAMPAIGN UPGRADES
**Mana Efficiency I** (Level 7 unlock, 300 gold)
- Abilities cost -1 Mana (min 1)
- *Makes Ability 1 cost 2-3 instead of 3-4*

**Mana Font** (Level 12 unlock, 600 gold)
- Start each combat with 3 Mana
- *Front-loads power*

**Mana Overflow** (Level 15 unlock, 1000 gold)
- Increase Mana cap from 12→15
- *Very expensive, endgame only*

---

## CARD DRAW SYSTEM

### Base Rules
- **Starting hand:** 5 cards
- **Draw per turn:** 1 card
- **Max hand size:** 8 cards
- **Discard:** At end of turn, discard down to 8 if over
- **Deck shuffle:** When deck empty, shuffle discard pile into new deck

### Ways to Boost Draw

#### GEAR
**Tactician's Lens** (Rare Accessory)
- Draw +1 card per turn (1→2 per turn)

**Scholar's Pendant** (Common Accessory)
- +2 max hand size (8→10)

#### CARDS
**Prepare** (1 Stamina)
- Draw 2 cards

**Deep Focus** (2 Stamina, Exhaust)
- Draw 3 cards. Exhaust.

**Scout** (0 Stamina)
- Draw 1 card. It costs -1 Stamina this turn.

---

## BALANCE MECHANISMS (Anti-Cheese)

### 1. HARD CAPS
- **Max Stamina:** 6 per turn (even with all boosts)
- **Max Mana:** 12 total (15 with endgame upgrade)
- **Max Hand Size:** 8 cards (10 with gear)

### 2. OPPORTUNITY COSTS
- **Gear slots are limited:** Only 1 accessory slot (can't stack 3 resource accessories)
- **Gold spent on resources ≠ gold spent on damage/defense**
- **Card slots:** Running resource cards means fewer combat cards

### 3. DIMINISHING RETURNS
| Stamina Boost | Increase | Value |
|---------------|----------|-------|
| 3 → 4         | 33%      | Huge  |
| 4 → 5         | 25%      | Good  |
| 5 → 6         | 20%      | Okay  |

Each additional point matters less.

### 4. RISK/REWARD CARDS
- Cards that boost resources often cost HP or have drawbacks
- **Adrenaline Rush:** Stamina + damage to yourself
- **Sacrifice:** Mana + HP loss
- Risky builds vulnerable to burst damage

### 5. LATE-GAME GATING
- Big resource upgrades require:
  - **Level 10+** (campaign progression)
  - **High gold costs** (500-1000 gold)
  - Can't rush max resources early

### 6. DECK DILUTION
- Too many resource cards = fewer combat cards
- "Focus" spam deck = no damage = lose
- Natural balance between enablers and payoffs

---

## ANTI-INFINITE SAFEGUARDS

### Can you go infinite?
**NO** - Hard caps prevent infinite loops:
- Stamina capped at 6
- Mana capped at 12 (or 15 late-game)
- Can't play infinite cards even with max resources

### Can you end fights turn 1?
**NO** - Generation too slow:
- Turn 1: 3 Stamina, ~2 Mana (not enough for big combos)
- Abilities cost 3-8 Mana (need 2-3 turns to build)

### Can you ignore resources entirely?
**YES** - Base rates are playable:
- 3 Stamina per turn is solid baseline
- Mana generates naturally from playing cards
- Investing in resources is optional optimization, not mandatory

---

## EXAMPLE BUILDS (and their counters)

### Build 1: "STAMINA ENGINE" (AEGIS)
**Gear:** Energy Talisman (+1 Stamina)  
**Upgrade:** Efficient Fighter II (base 4 Stamina)  
**Result:** 5 Stamina per turn

**Strengths:**
- Plays more cards per turn
- Can combo armor stacking efficiently

**Weaknesses:**
- Used accessory slot (lower stats from gear)
- Expensive upgrade (500 gold)
- Still capped at 6 max
- **Counter:** ECLIPSE bursts them down before they scale

---

### Build 2: "MANA RUSH" (ECLIPSE)
**Gear:** Arcane Crystal (+1 Mana/turn), Bloodstone Ring (Mana from damage)  
**Cards:** 3x Sacrifice (HP → Mana)  
**Upgrade:** Mana Font (start with 3 Mana)  
**Result:** Can Execute (7 Mana) by turn 2-3

**Strengths:**
- Very fast ability access
- Burst damage with abilities + Bloodlust

**Weaknesses:**
- Very low HP from Sacrifices
- Fragile, dies to sustained pressure
- **Counter:** AEGIS stacks Weakened, survives burst, grinds them down

---

### Build 3: "CARD ENGINE" (SPECTER)
**Gear:** Tactician's Lens (+1 draw/turn)  
**Cards:** 2x Prepare (draw 2)  
**Upgrade:** Scholar's Pendant (+2 hand size)  
**Result:** Draws 2 cards/turn, 10 card hand size

**Strengths:**
- Always has answers
- Cycles deck fast
- Consistent status application

**Weaknesses:**
- Used resources on card draw, not damage/defense
- Needs time to set up
- **Counter:** ECLIPSE kills before engine spins up

---

## TUNING KNOBS (For Playtesting)

If fights are too fast:
- ⬇️ Base Stamina 3→2
- ⬆️ Mana costs for abilities
- ⬇️ Mana generation rates

If fights are too slow:
- ⬆️ Base Stamina 3→4 (or use ramping)
- ⬇️ Mana costs for abilities
- ⬆️ Mana generation rates

If resource builds too strong:
- ⬆️ Gold costs for upgrades
- ⬇️ Hard caps (6→5 Stamina, 12→10 Mana)
- ⬆️ Risk/reward costs (more HP loss)

If resource builds too weak:
- ⬇️ Gold costs for upgrades
- ⬆️ Effectiveness of resource cards
- Add more faction-specific generation

---

## IMPLEMENTATION CHECKLIST

### Phase 1 (V1 Core)
- [ ] Lock base rates (3 Stamina, Mana formula)
- [ ] Lock hard caps (6 Stamina, 12 Mana, 8 hand size)
- [ ] Lock ability costs (3-4 for Ability 1, 7-9 for Ability 2)
- [ ] Create 3-5 resource gear pieces per slot
- [ ] Add 2-3 resource cards per faction

### Phase 2 (Balancing)
- [ ] Playtest base rates in all 3 matchups
- [ ] Test max resource builds vs balanced builds
- [ ] Tune costs based on average fight length
- [ ] Adjust caps if degenerate combos found

### Phase 3 (Polish)
- [ ] Add faction-specific Mana generation
- [ ] Add campaign upgrade tree
- [ ] Fine-tune numbers based on data
- [ ] Add X-cost cards (spend all Stamina/Mana)

---

## OPEN QUESTIONS FOR YOU

1. **Starting Mana:** Should fights start at 0 Mana (build up slowly) or 2-3 Mana (Ability 1 available sooner)?

2. **Stamina ramping:** Fixed 3 per turn (simple) or ramp 1→2→3 (early game phases)?

3. **Faction-specific Mana generation:** Should each faction have unique ways to gain Mana faster?

4. **Mana on death:** Should player gain Mana when downed (0 HP), or does that reward losing?

5. **X-cost cards:** Should we add "spend all remaining Stamina/Mana" cards for flexibility?

---

**Document Status:** ✅ READY FOR REVIEW  
**Next Step:** Lock combat fundamentals (turn order, damage calc, status timing)  
**After That:** Design 20-24 gear pieces with resource synergies
