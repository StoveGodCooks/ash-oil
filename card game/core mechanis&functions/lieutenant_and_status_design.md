# Lieutenant System + Status Effect Distinction

**Created:** 2026-02-15  
**Status:** LOCKED FOR V1 IMPLEMENTATION  
**Purpose:** Complete mechanical design for lieutenant progression and status effect clarity

---

## PART A: LIEUTENANT SYSTEM

### Core Philosophy

Lieutenants are **named heroes with unique identities** that create emotional attachment through:
- Distinct mechanical playstyles
- Unique passive abilities
- Exclusive signature cards
- Progression through survival
- Injury consequences that matter

**Design Constraint:** No permanent death (avoids death spirals while maintaining injury tension)

---

## Lieutenant Roster (8 Total)

### Roster Management
- **Total lieutenants available:** 8
- **Active deployment slots:** 4 (1 champion + 3 lieutenants)
- **Bench slots:** 4 (rotate when injured/fatigued)
- **Recruitment:** All 8 available from start (no unlocking needed)
- **Specialization:** Each tied to a faction or neutral archetype

---

## AEGIS Specialists (The Fortress)

### Lt. Kira "The Bulwark"
**Stats:**
- HP: 32 (+2 over base AEGIS)
- Armor: 5 (base AEGIS)
- Speed: 2 (base AEGIS)

**Passive: "Fortress Heart"**
- Whenever you gain Armor, heal 1 HP (in addition to AEGIS faction passive 30% heal)
- **Total healing on Armor gain:** 1 HP (Fortress Heart) + 30% of Armor gained (AEGIS passive)
- Example: Gain 10 Armor → Heal 1 HP + 3 HP = 4 HP total

**Signature Cards (3 unique):**

**1. Kira's Aegis** (1 Stamina, Common)
- Gain 5 Armor
- Draw 1 card
- *"Her shield is an extension of her will"*

**2. Unbreakable** (2 Stamina, Rare)
- Gain Armor equal to current Armor (double your Armor)
- Max 12 Armor gained
- *"What doesn't kill me makes me stronger"*

**3. Last Stand** (3 Stamina, Epic, Exhaust)
- If HP ≤ 10: Gain 15 Armor, heal 5 HP, apply Weakened 3 to enemy
- If HP > 10: Gain 8 Armor
- *"When her back's against the wall, she becomes unbreakable"*

**Playstyle:** Ultra-defensive stacking engine, converts Armor into sustain

---

### Lt. Darius "The Sentinel"
**Stats:**
- HP: 30 (base AEGIS)
- Armor: 8 (+3 over base AEGIS)
- Speed: 1 (-1 from base AEGIS, slower but tankier)

**Passive: "Retaliation"**
- At start of your turn, if you have 10+ Armor, deal 3 damage to enemy (ignores Armor)
- *Passive Armor offense - rewards stacking high Armor*

**Signature Cards (3 unique):**

**1. Sentinel's Strike** (1 Stamina, Common)
- Deal 4 damage
- If you have 8+ Armor, apply Bleeding 2
- *"His shield strikes as hard as his sword"*

**2. Fortified Counterstrike** (2 Stamina, Rare)
- Gain 6 Armor
- Next time enemy attacks you this turn, deal 5 damage back (ignores Armor)
- *"Every blow returned twofold"*

**3. Immovable Object** (3 Stamina, Epic, Exhaust)
- Gain 12 Armor
- For 2 turns, damage you take is capped at 5 per hit
- *"He does not yield"*

**Playstyle:** Armor-based offense, punishes enemies for attacking

---

## ECLIPSE Specialists (The Blade)

### Lt. Marcus "The Reaper"
**Stats:**
- HP: 18 (-2 from base ECLIPSE, glass cannon)
- Armor: 0 (base ECLIPSE)
- Speed: 6 (+1 over base ECLIPSE)

**Passive: "First Blood"**
- Your first attack each combat applies Bleeding 2 (free)
- At start of turn, if enemy has 6+ Bleeding, gain +1 Stamina this turn only

**Signature Cards (3 unique):**

**1. Reaper's Edge** (1 Stamina, Common)
- Deal 6 damage
- If enemy has Bleeding, deal +3 damage
- *"He smells blood in the water"*

**2. Rapid Strikes** (2 Stamina, Rare)
- Deal 4 damage three times (12 total)
- Each hit that kills an enemy applies Bleeding 3 to next wave
- *"A flurry of lethal precision"*

**3. Death Mark** (3 Stamina, Epic)
- Apply Bleeding 6 to enemy
- Until end of combat, your attacks ignore Armor when hitting Bleeding targets
- *"Once marked, they're already dead"*

**Playstyle:** Hyper-aggressive bleed stacker, rewards early pressure

---

### Lt. Selene "The Shadow"
**Stats:**
- HP: 20 (base ECLIPSE)
- Armor: 0 (base ECLIPSE)
- Speed: 5 (base ECLIPSE)

**Passive: "Assassinate"**
- If enemy has ≤30% HP, your attacks deal +4 damage
- Draw 1 card when enemy reaches ≤30% HP (once per combat)

**Signature Cards (3 unique):**

**1. Shadow Strike** (1 Stamina, Common)
- Deal 7 damage
- If this kills the enemy, gain 2 Mana
- *"Swift and silent"*

**2. Exploit Weakness** (2 Stamina, Rare)
- Deal 5 damage
- If enemy has Weakened or Bleeding, deal double damage (10 total)
- *"She finds the gaps in every defense"*

**3. Execute** (3 Stamina, Epic)
- Deal 8 damage
- If enemy has ≤50% HP, deal 15 damage instead
- If this kills the enemy, fully restore your HP
- *"No mercy for the wounded"*

**Playstyle:** Finisher specialist, explosive burst when enemy is low

---

## SPECTER Specialists (The Puppeteer)

### Lt. Elena "The Witch"
**Stats:**
- HP: 25 (base SPECTER)
- Armor: 2 (base SPECTER)
- Speed: 4 (base SPECTER)

**Passive: "Contagion"**
- When you apply Poison, apply +1 additional Poison stack
- At 8+ Poison on enemy, they have permanent Weakened 1

**Signature Cards (3 unique):**

**1. Toxic Touch** (1 Stamina, Common)
- Deal 3 damage
- Apply Poison 3
- *"Her touch corrupts"*

**2. Epidemic** (2 Stamina, Rare)
- Apply Poison equal to enemy's current Poison stacks (double it)
- Draw 1 card
- *"The plague spreads exponentially"*

**3. Final Breath** (3 Stamina, Epic, Exhaust)
- Convert all Poison on enemy into immediate damage (deal damage equal to Poison stacks)
- Then apply Poison 4
- *"The killing blow, delivered slowly"*

**Playstyle:** Poison scaling engine, converts DoT into burst

---

### Lt. Corvus "The Manipulator"
**Stats:**
- HP: 27 (+2 over base SPECTER)
- Armor: 1 (-1 from base SPECTER)
- Speed: 3 (-1 from base SPECTER, more methodical)

**Passive: "Mind Games"**
- Whenever you apply Weakened, enemy discards 1 card
- When enemy deck is empty, they take 2 damage at start of turn (deck pressure)

**Signature Cards (3 unique):**

**1. Disrupt** (1 Stamina, Common)
- Apply Weakened 2
- Enemy discards 1 card (in addition to passive)
- *"Control is everything"*

**2. Psychological Warfare** (2 Stamina, Rare)
- Apply Weakened 3
- Look at enemy's hand, choose 1 card to discard
- *"He knows your next move before you do"*

**3. Total Domination** (3 Stamina, Epic, Exhaust)
- Apply Weakened 5
- Enemy discards entire hand
- For 2 turns, enemy draws -1 card per turn
- *"Resistance is futile"*

**Playstyle:** Control/disruption specialist, starves enemy resources

---

## NEUTRAL Specialists (Balanced)

### Lt. Thane "The Veteran"
**Stats:**
- HP: 25 (balanced)
- Armor: 3 (moderate)
- Speed: 3 (moderate)

**Passive: "Battle Hardened"**
- Start combat with +2 Mana (starts at 2 instead of 0)
- At start of turn, if you used an Ability last turn, gain +1 Stamina this turn

**Signature Cards (3 unique):**

**1. Veteran's Instinct** (0 Stamina, Common)
- Draw 2 cards
- Gain 1 Mana
- *"Experience guides his hand"*

**2. Tactical Advantage** (2 Stamina, Rare)
- Draw 3 cards
- Reduce cost of next card played this turn by 2 (min 0)
- *"He sees opportunities others miss"*

**3. Commander's Presence** (3 Stamina, Epic)
- Draw 2 cards
- Gain 3 Mana
- Heal 4 HP
- Gain 4 Armor
- *"A leader inspires by example"*

**Playstyle:** Resource engine, enables ability-heavy builds

---

### Lt. Aria "The Duelist"
**Stats:**
- HP: 22 (low-moderate)
- Armor: 0 (glass cannon)
- Speed: 5 (fast)

**Passive: "Momentum"**
- Playing cards generates Momentum tokens (1 token per card)
- Spend 3 Momentum: Gain +1 Stamina this turn only (can use multiple times)
- Momentum resets at end of turn

**Signature Cards (3 unique):**

**1. Quick Slash** (0 Stamina, Common)
- Deal 3 damage
- *"Speed over power"*

**2. Chain Attack** (1 Stamina, Rare)
- Deal 5 damage
- If you've played 2+ cards this turn, deal +4 damage (9 total)
- *"Relentless combinations"*

**3. Perfect Form** (2 Stamina, Epic)
- Deal 8 damage
- For each card played this turn before this card, deal +2 damage
- Gain Momentum equal to damage dealt / 4 (rounded down)
- *"Flawless technique"*

**Playstyle:** Combo specialist, rewards playing many cards per turn

---

## Lieutenant Progression System

### Experience & Leveling
- Lieutenants gain XP by **surviving missions** (not by kills)
- XP rewards:
  - Mission completed: 100 XP
  - Mission completed without taking damage: +50 XP bonus
  - Boss killed: +25 XP bonus

**Level Thresholds:**
```
Level 1: 0 XP (starting)
Level 2: 100 XP
Level 3: 250 XP
Level 4: 450 XP
Level 5: 700 XP
Level 6: 1000 XP (max for Season 1)
```

**Level Benefits:**
- Level 2: +2 HP
- Level 3: Unlock 1st signature card
- Level 4: +1 Speed OR +2 Armor (choose one, permanent)
- Level 5: Unlock 2nd signature card
- Level 6: Unlock 3rd signature card + passive upgrade (see below)

### Level 6 Passive Upgrades

**Kira:** Fortress Heart now heals 2 HP (instead of 1)  
**Darius:** Retaliation damage increases to 5 (instead of 3)  
**Marcus:** First Blood applies Bleeding 3 (instead of 2)  
**Selene:** Assassinate bonus damage increases to +6 (instead of +4)  
**Elena:** Contagion applies +2 Poison (instead of +1)  
**Corvus:** Mind Games causes enemy to discard 2 cards (instead of 1)  
**Thane:** Battle Hardened gives +3 starting Mana (instead of +2)  
**Aria:** Momentum costs 2 tokens instead of 3 (easier to activate)

---

## Injury System Integration

### How Injuries Affect Lieutenants

**Minor Injuries:**
- Lieutenant unavailable for 1 mission
- No mechanical penalties
- Can still earn "participation XP" (50% if benched during a mission)

**Serious Injuries:**
- Lieutenant unavailable for 2 missions
- When they return: -2 HP for 1 mission (recovers after)
- Doctor/Shaman can reduce recovery to 1 mission

**Grave Injuries (Permanent):**
- Lieutenant gains permanent mechanical scar (see examples below)
- Still playable but weakened
- **Cannot be removed** (permanent consequence)

### Grave Injury Examples (by Lieutenant)

**Kira - "Shattered Shield"**
- Fortress Heart healing reduced by 50% (heals 0.5 HP rounded down, or 1 HP at Level 6)

**Darius - "Cracked Armor"**
- Retaliation damage threshold increased to 15 Armor (instead of 10)

**Marcus - "Blunted Blade"**
- First Blood applies Bleeding 1 (instead of 2/3)

**Selene - "Hesitation"**
- Assassinate threshold increased to ≤20% HP (instead of ≤30%)

**Elena - "Weakened Curse"**
- Contagion applies +0 Poison (passive disabled)

**Corvus - "Fractured Mind"**
- Mind Games discard effect reduced to 50% chance

**Thane - "War Fatigue"**
- Battle Hardened gives +1 starting Mana (instead of +2/3)

**Aria - "Lost Rhythm"**
- Momentum costs 4 tokens (instead of 3/2)

**Design Note:** Grave injuries are severe but not run-ending. Players can still complete campaign with scarred lieutenants, but will feel the impact.

---

## Recruitment & Deck Building

### Starting Roster
- All 8 lieutenants available from Mission 1
- Player chooses 4 to deploy (1 champion + 3 lieutenants)
- Can swap lieutenants between missions (unless injured)

### Deck Composition
Each lieutenant brings:
1. **Faction card pool** (shared with all lieutenants of that faction)
   - AEGIS specialists can use all AEGIS cards
   - ECLIPSE specialists can use all ECLIPSE cards
   - SPECTER specialists can use all SPECTER cards
   - Neutral specialists can use Neutral cards only (no faction access)

2. **Signature cards** (unique to that lieutenant)
   - Unlocked at Level 3, 5, and 6
   - Only that lieutenant can use these cards
   - Added to their personal deck pool

**Example Deck Build:**
```
Kira (AEGIS specialist, Level 6):
- Can use: All 15 AEGIS faction cards
- Can use: 3 Kira signature cards (Kira's Aegis, Unbreakable, Last Stand)
- Total card pool: 18 cards
- Deck limit: 40 cards
- Starting deck: 10 cards (chosen from pool)
```

### Multi-Faction Teams
Players can deploy mixed teams:
- 1 AEGIS + 1 ECLIPSE + 1 SPECTER + 1 Neutral
- Or 2 AEGIS + 2 ECLIPSE
- Or any combination

This creates diverse playstyle options and synergy exploration.

---

## UI/UX Considerations

### Lieutenant Select Screen
```
[Portrait] Lt. Kira "The Bulwark"
Level: 5 | XP: 820/1000
HP: 32 | Armor: 5 | Speed: 2
Passive: Fortress Heart

Status: READY
Injuries: None

[SELECT] [VIEW CARDS] [VIEW STATS]
```

### Injury Warning System
```
⚠️ WARNING: Lt. Marcus has SERIOUS INJURY
- Unavailable for 2 missions
- Consider using Doctor (250g) or Shaman (100g)
- Next knockdown = GRAVE INJURY (permanent)

[USE DOCTOR] [USE SHAMAN] [LET HEAL NATURALLY]
```

### Grave Injury Notification
```
🚨 CRITICAL: Lt. Elena suffered GRAVE INJURY
- Permanent scar: "Weakened Curse"
- Contagion passive disabled permanently
- Still playable, but significantly weakened

This cannot be reversed.

[ACKNOWLEDGE]
```

---

## Balance Validation Checklist

### Before Implementation, Test:
- [ ] All 8 lieutenants can complete tutorial mission (70-90% win rate)
- [ ] Signature cards are balanced (not must-picks, but competitive)
- [ ] Level 6 passives are impactful but not overpowered
- [ ] Grave injuries are punishing but not run-ending
- [ ] Neutral lieutenants are competitive with faction specialists
- [ ] Mixed-faction teams are viable (not weaker than mono-faction)

### Simulator Tests:
```
Run 50 simulations per lieutenant vs Scout enemy:
- Track win rate (expect 75-85%)
- Track average turn count (expect 5-8 turns)
- Track signature card usage (should be played 60%+ of games)
- Identify underperforming lieutenants and buff accordingly
```

---

## PART B: STATUS EFFECT DISTINCTION

### Problem Statement
**Bleeding** and **Poison** were too similar in master-spec.json:
- Both deal 1 damage per stack
- Both max at 12 stacks
- Both ignore Armor
- Only difference: decay timing

**This is confusing for players and reduces strategic depth.**

---

## REVISED STATUS EFFECTS (LOCKED)

### 🩸 Bleeding (Front-Loaded DoT)

**Mechanical Identity:** Burst damage that decays quickly

**Stats:**
- **Damage:** 2 per stack (doubled from original)
- **Max Stacks:** 6 (halved from original)
- **Decay:** Reduce by 1 after dealing damage
- **Ignores Armor:** Yes
- **Timing:** Start of turn (before main phase)

**Faction Association:** ECLIPSE (The Blade)

**Strategic Purpose:**
- High immediate damage
- Short duration (burns out fast)
- Rewards aggressive early pressure
- Punishes enemies who can't heal/armor quickly

**Example:**
```
Turn 1: Apply Bleeding 4 (will deal 8 damage next turn)
Turn 2: Take 8 damage, Bleeding reduces to 3 (will deal 6 damage next turn)
Turn 3: Take 6 damage, Bleeding reduces to 2 (will deal 4 damage next turn)
Turn 4: Take 4 damage, Bleeding reduces to 1 (will deal 2 damage next turn)
Turn 5: Take 2 damage, Bleeding expires

Total damage over 4 turns: 20 damage
```

**Counterplay:**
- Stack Armor quickly to survive burst
- Heal aggressively
- Kill ECLIPSE before they stack Bleeding

---

### 🧪 Poison (Scaling DoT)

**Mechanical Identity:** Slow ramp that never stops

**Stats:**
- **Damage:** 1 per stack (unchanged)
- **Max Stacks:** 12 (unchanged)
- **Decay:** Never (permanent until combat ends)
- **Ignores Armor:** Yes
- **Timing:** Start of turn (before main phase)

**Faction Association:** SPECTER (The Puppeteer)

**Strategic Purpose:**
- Low immediate damage
- Infinite duration (scales over time)
- Rewards patient, controlling playstyle
- Punishes enemies in long fights

**Example:**
```
Turn 1: Apply Poison 2 (will deal 2 damage per turn forever)
Turn 2: Take 2 damage, Poison stays 2 (apply +2 more → now 4)
Turn 3: Take 4 damage, Poison stays 4 (apply +2 more → now 6)
Turn 4: Take 6 damage, Poison stays 6 (apply +2 more → now 8)
Turn 5: Take 8 damage, Poison stays 8

Total damage over 4 turns: 20 damage (same as Bleeding)
BUT Poison continues dealing 8/turn forever
```

**Counterplay:**
- Kill SPECTER quickly before Poison ramps
- Use burst damage to end fight early
- Pressure them to force defensive plays instead of stacking Poison

---

### Secondary Effects (Thematic Integration)

To further differentiate, add secondary effects:

#### Bleeding Secondary Effect: **"Injury Risk"**
```
If you are knocked out (HP reaches 0) with 4+ Bleeding stacks:
- Injury severity automatically escalates by 1 tier
- Minor → Serious
- Serious → Grave

Flavor: "Bleeding out worsens wounds"
```

**Impact:** Makes Bleeding scarier in campaign mode (ties to injury system)

---

#### Poison Secondary Effect: **"Sickness"**
```
At 6+ Poison stacks:
- Target has permanent Weakened 1 (while Poison ≥ 6)
- Stacks with regular Weakened debuff

At 10+ Poison stacks:
- Target has permanent Weakened 2 (while Poison ≥ 10)

Flavor: "Poison weakens the body"
```

**Impact:** Makes Poison a control tool (debuff + DoT hybrid)

---

## Updated Faction Synergies

### ECLIPSE + Bleeding
**Bloodlust Passive:** Deal +2 damage to enemies with Bleeding or Poison

**Synergy Cards:**
- **Hemorrhage** (2 Stamina, Rare): Deal 7 damage. If target has Bleeding, apply Bleeding 3.
- **Crimson Strike** (1 Stamina, Common): Deal 5 damage. Gain +2 damage for each Bleeding stack on target (max +6).
- **Blood Rush Ability** (3 Mana): Next attack deals +8 damage and applies Bleeding 2.

**Strategy:** Stack Bleeding fast → burst before it decays → repeat

---

### SPECTER + Poison
**Miasma Passive:** At start of your turn, if enemy has Poison, apply +1 Poison

**Synergy Cards:**
- **Toxic Buildup** (1 Stamina, Common): Apply Poison 2. If target already has Poison, apply +1 extra.
- **Virulent Dose** (2 Stamina, Rare): Apply Poison equal to target's current Poison (double it).
- **Plague Mastery Ability** (7 Mana): Double all Poison on enemy. Deal damage equal to Poison stacks.

**Strategy:** Ramp Poison slowly → control with Weakened → finish with burst conversion

---

## Comparison Table

| Attribute | Bleeding | Poison |
|-----------|----------|--------|
| **Damage/Stack** | 2 | 1 |
| **Max Stacks** | 6 | 12 |
| **Decay** | -1 after damage | Never |
| **Duration** | 3-6 turns | Infinite |
| **Total Damage** | 20-24 (burst) | 1-78 (ramp) |
| **Faction** | ECLIPSE | SPECTER |
| **Playstyle** | Aggressive | Patient |
| **Secondary** | Injury risk | Weakened |
| **Counterplay** | Armor/Heal fast | Kill fast |

---

## Balance Validation

### Expected Performance

**Bleeding:**
- Should deal 40-50% of enemy HP in first 4 turns
- Should expire by turn 6-8
- ECLIPSE should win via burst + Bleeding pressure

**Poison:**
- Should deal 20-30% of enemy HP by turn 6
- Should deal 50-60% by turn 10
- SPECTER should win via control + Poison scaling

**Head-to-Head (ECLIPSE vs SPECTER):**
- ECLIPSE favored 60/40 (bursts before Poison ramps)
- If SPECTER survives to turn 8+, Poison wins
- Weakened effect helps SPECTER survive burst

---

## Implementation Checklist

### Code Changes Required:
- [ ] Update Bleeding to 2 damage/stack, max 6 stacks
- [ ] Add Bleeding injury escalation trigger (4+ stacks on knockout)
- [ ] Add Poison Weakened effect (6+ stacks = Weakened 1, 10+ = Weakened 2)
- [ ] Update ECLIPSE cards to reference new Bleeding values
- [ ] Update SPECTER cards to reference Poison scaling
- [ ] Update simulator to reflect new damage profiles

### Data Updates:
- [ ] master-spec.json (status effects section)
- [ ] Card library (all Bleeding/Poison cards)
- [ ] Enemy decks (adjust for new balance)
- [ ] Tutorial tooltips (explain difference clearly)

### Testing:
- [ ] Run 100 simulations: AEGIS vs Scout (control test)
- [ ] Run 100 simulations: ECLIPSE vs Scout (Bleeding pressure test)
- [ ] Run 100 simulations: SPECTER vs Scout (Poison ramp test)
- [ ] Run 100 simulations: ECLIPSE vs SPECTER (faction balance test)
- [ ] Validate win rates within 70-90% range
- [ ] Validate turn counts within 5-8 turn range

---

## Player Communication

### Tutorial Tooltips

**Bleeding:**
```
🩸 BLEEDING
- Deals 2 damage per stack at start of turn
- Maximum 6 stacks
- Reduces by 1 after dealing damage
- Ignores Armor

⚠️ WARNING: Being knocked out with 4+ Bleeding 
worsens injury severity!

"Fast damage that burns out quickly"
```

**Poison:**
```
🧪 POISON
- Deals 1 damage per stack at start of turn
- Maximum 12 stacks
- Never decays (lasts entire combat)
- Ignores Armor
- At 6+ stacks: Applies Weakened 1
- At 10+ stacks: Applies Weakened 2

"Slow ramp that never stops"
```

---

## Final Notes

### Why This Design Works

1. **Clear Differentiation:**
   - Bleeding = burst (2 damage, short duration)
   - Poison = ramp (1 damage, infinite duration)

2. **Faction Identity:**
   - ECLIPSE = aggressive finisher
   - SPECTER = patient controller

3. **Strategic Depth:**
   - Different optimal timings
   - Different counterplay strategies
   - Different win conditions

4. **Thematic Clarity:**
   - Bleeding → injury risk (fits campaign)
   - Poison → weakness (fits control)

5. **Math Validation:**
   - Similar total damage over 5-8 turns
   - Different damage curves
   - Both viable, neither dominant

---

**LOCKED FOR IMPLEMENTATION**

These designs are final and ready for coding. No further iteration needed unless simulator reveals critical imbalance.

**Next Steps:**
1. Update master-spec.json
2. Update card library with new values
3. Run validation tests in simulator
4. Adjust only if win rates fall outside 70-90% range

---

**End of Document**
