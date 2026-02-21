# FACTION ABILITIES - COMPLETE DESIGN
> **Status:** LOCKED - Ready for Implementation
> **Resource System:** Mana-based (0 start, +1/turn, +1 per card played max +2/turn)
> **Ability Costs:** 3 Mana (Ability 1), 7 Mana (Ability 2), 10+ Mana (Ability 3 - Future)

---

## DESIGN PHILOSOPHY

### Ability 1 (3 Mana):
- **Cost:** Affordable by Turn 1-2
- **Power Level:** Tactical tool, not game-ending
- **Usage:** 2-3 times per fight
- **Design Intent:** Enables faction identity, rewards skill

### Ability 2 (7 Mana):
- **Cost:** Available Turn 3-4 (with active play)
- **Power Level:** Game-changing moment
- **Usage:** 1-2 times per fight
- **Design Intent:** Swing turns, ultimate expression of faction

### Power Budget Formula:
- **3 Mana Ability ≈ 2x the value of a 1-cost card**
- **7 Mana Ability ≈ 4-5x the value of a 1-cost card**

---

# AEGIS ABILITIES (The Fortress)

## PASSIVE: FORTRESS
**Effect:** Armor persists between waves in expeditions.
**Design Note:** Already locked. No combat effect, but critical for expedition progression.

---

## ABILITY 1: BULWARK
**Cost:** 3 Mana
**Effect:** Gain Armor equal to 50% of your missing HP (max 10 Armor).
**Cooldown:** None (can spam if you have Mana)

### Examples:
- Current HP: 20/30 → Missing 10 HP → Gain 5 Armor
- Current HP: 10/30 → Missing 20 HP → Gain 10 Armor (capped)
- Current HP: 28/30 → Missing 2 HP → Gain 1 Armor

### Design Rationale:
✅ **Defensive Response** - Converts danger into safety
✅ **Scales with Risk** - More valuable when low HP
✅ **Not OP** - Capped at 10, doesn't heal HP
✅ **Synergy** - Feeds Counter Strike (damage = Armor), Fortress (wave persistence)
✅ **Faction Identity** - Rewards patient, defensive play

### Power Budget Check:
- Compare to **Fortify** (card): 2 Stamina → 8 Armor
- Bulwark: 3 Mana → 5-10 Armor (situational)
- **Verdict:** Fair. Conditional power, peak efficiency requires being wounded.

---

## ABILITY 2: IRON BASTION
**Cost:** 7 Mana
**Effect:** Gain 12 Armor. Apply Weakened 3 to all enemies. Draw 1 card.
**Cooldown:** None

### Breakdown:
- **12 Armor:** Huge defensive spike (equivalent to 6 Stamina worth of cards)
- **Weakened 3 to ALL enemies:** Reduces incoming damage by 25% for 3 turns (squad combat value)
- **Draw 1:** Keeps hand full, enables next turn

### Design Rationale:
✅ **Ultimate Defense** - Massive survivability swing
✅ **Multi-Target Value** - Shines in 3v3 squad combat (Weakens 3 enemies at once)
✅ **Not Just Stalling** - Draw 1 keeps pressure
✅ **Expensive** - Can't spam, feels like an earned moment
✅ **Faction Identity** - Peak AEGIS fantasy (immovable wall)

### Power Budget Check:
- **Shieldwall** (card): 2 Stamina → 6 Armor + Weakened 2 (single target)
- **Stand Ground** (card): 2 Stamina → 5 Armor + Weakened 3 (single target)
- Iron Bastion: 7 Mana → 12 Armor + Weakened 3 (ALL) + Draw 1
- **Verdict:** Strong but fair. Costs 7 Mana (Turn 3-4), doesn't end fights alone.

### Why Not "Aegis Wall" (Original Name)?
- Renamed to **Iron Bastion** (more evocative, less generic)
- Keeps same mechanical identity

---

## ABILITY 3: UNBREAKABLE FORTRESS (Future - Level 15+ Unlock)
**Cost:** 10 Mana
**Effect:** Double your current Armor (max 30). Gain Armor equal to your current HP. Immune to Weakened for 2 turns.
**Cooldown:** Once per combat

### Design Note:
- Late-game unlock
- Enables "invincible turn" fantasy
- Combines with Counter Strike for explosive damage
- Once-per-combat prevents spam

---

# ECLIPSE ABILITIES (The Blade)

## PASSIVE: BLOODLUST
**Effect:** Deal +2 damage to enemies with Bleeding or Poison.
**Design Note:** Already locked. Core to ECLIPSE identity.

---

## ABILITY 1: CRIMSON SURGE
**Cost:** 3 Mana
**Effect:** Your next Attack card this turn deals +6 damage and applies Bleeding 2. Gain +1 Speed until end of turn.
**Cooldown:** None

### Examples:
- Play **Slash** (6 damage, Bleeding 1) → Becomes 12 damage, Bleeding 3
- Play **Execution** (8 damage at full HP) → Becomes 14 damage, Bleeding 2
- Play **Quick Strike** (5 damage) → Becomes 11 damage, Bleeding 2

### Design Rationale:
✅ **Burst Enabler** - Makes next attack devastating
✅ **Speed Bonus** - Thematic (ECLIPSE is fastest faction), enables first-strike kills
✅ **Bleed Synergy** - Sets up Bloodlust passive (+2 damage on bleeding targets)
✅ **Requires Card** - Not damage itself, amplifies your cards
✅ **Flexible** - Works with any Attack card

### Power Budget Check:
- **Lacerate** (card): 2 Stamina → 7 damage + Bleeding 2
- Crimson Surge: 3 Mana → +6 damage to next attack + Bleeding 2 + Speed 1
- If you play **Quick Strike** (1 Stamina, 5 damage) after Crimson Surge:
  - Total cost: 1 Stamina + 3 Mana
  - Total value: 11 damage + Bleeding 2 + Speed 1
- **Verdict:** Strong combo, but requires 2 actions (ability + card). Fair.

### Why "Crimson Surge" instead of "Blood Rush"?
- More evocative name
- Adds Speed component (wasn't in original design)

---

## ABILITY 2: REAPER'S MARK
**Cost:** 7 Mana
**Effect:** Deal 12 damage to target enemy. If this kills the enemy, restore 8 HP and gain +2 Mana. If enemy survives, apply Bleeding 4.
**Cooldown:** None

### Breakdown:
- **12 Damage:** High single-target burst
- **Execute Payoff:** Heal 8 HP + Refund 2 Mana (net cost 5 Mana)
- **Miss Payoff:** Apply Bleeding 4 (sets up future Bloodlust damage)

### Design Rationale:
✅ **High Skill Ceiling** - Rewards correct timing (killing blow)
✅ **Risk/Reward** - ECLIPSE is fragile (20 HP), heal is critical
✅ **Never Feels Bad** - Bleeding 4 consolation prize is strong
✅ **Mana Refund** - Enables double ability turns (use twice if you execute)
✅ **Faction Identity** - Surgical execution, glass cannon sustain

### Power Budget Check:
- **Execution** (card): 2 Stamina → 8 damage (12 if enemy <50% HP)
- **Assassinate** (ultimate card): 4 Stamina → 20 damage, heal 10 HP if kill
- Reaper's Mark: 7 Mana → 12 damage, heal 8 HP + refund 2 Mana if kill, OR Bleeding 4
- **Verdict:** Powerful but conditional. Requires setup or good timing. Fair.

### Why "Reaper's Mark" instead of "Execute"?
- "Execute" is already a card name
- More thematic (marking targets for death)

---

## ABILITY 3: BLOOD FRENZY (Future - Level 15+ Unlock)
**Cost:** 10 Mana
**Effect:** Apply Enraged 3 to yourself. All Attack cards cost 0 Stamina this turn. Draw 2 cards.
**Cooldown:** Once per combat

### Design Note:
- All-in turn (spam attacks for free)
- Enraged 3 = +50% damage dealt, +25% damage taken (huge risk)
- Draw 2 ensures you have attacks to spam
- Glass cannon fantasy at peak

---

# SPECTER ABILITIES (The Puppeteer)

## PASSIVE: MIASMA
**Effect:** At start of your turn, if enemy has Poison, apply +1 Poison.
**Design Note:** Already locked. Exponential poison scaling.

---

## ABILITY 1: WITHERING CURSE
**Cost:** 3 Mana
**Effect:** Apply Weakened 3 to target enemy. Enemy discards 1 card. Apply Poison 1.
**Cooldown:** None

### Breakdown:
- **Weakened 3:** -25% damage for 3 turns
- **Discard 1 Card:** Resource denial (reduces enemy options)
- **Poison 1:** Feeds Miasma (will become 2, 3, 4+ over turns)

### Design Rationale:
✅ **Pure Disruption** - All three effects control enemy
✅ **No Damage** - SPECTER doesn't burst, controls
✅ **Multi-Layered** - Affects damage, hand, AND HP over time
✅ **Scales** - Poison 1 becomes exponential threat via Miasma
✅ **Faction Identity** - Sabotage and patience

### Power Budget Check:
- **Enfeeble** (card): 1 Stamina → Weakened 2
- **Weaken** (card): 1 Stamina → Weakened 3
- **Toxin Dart** (card): 1 Stamina → 4 damage + Poison 1
- Withering Curse: 3 Mana → Weakened 3 + Discard 1 + Poison 1
- **Verdict:** Strong control bundle. No immediate damage = balanced.

### Why "Withering Curse" instead of "Enfeeble"?
- "Enfeeble" is already a card name
- More evocative (curse that withers enemies over time)

---

## ABILITY 2: PLAGUE MASTERY
**Cost:** 7 Mana
**Effect:** Double all Poison on all enemies. Deal damage to each enemy equal to their Poison stacks. Apply Weakened 2 to all enemies.
**Cooldown:** None

### Breakdown:
- **Double Poison (ALL enemies):** Poison 3 → 6, Poison 5 → 10 (exponential)
- **Deal Poison Damage:** Immediate payoff (Poison 6 → take 6 damage NOW)
- **Weakened 2 (ALL):** Defensive component (buys time for poison to tick)

### Examples:
**Scenario 1:**
- Enemy has Poison 4
- Use Plague Mastery
- Enemy now has Poison 8, takes 8 damage immediately, has Weakened 2

**Scenario 2 (Squad Combat):**
- Enemy 1 has Poison 3, Enemy 2 has Poison 5, Enemy 3 has Poison 2
- Use Plague Mastery
- Enemy 1: Poison 6, take 6 damage, Weakened 2
- Enemy 2: Poison 10, take 10 damage, Weakened 2
- Enemy 3: Poison 4, take 4 damage, Weakened 2
- **Total damage: 20 across 3 enemies**

### Design Rationale:
✅ **Poison Payoff** - Rewards setup (3-4 turns of poison stacking)
✅ **Explosive Scaling** - Can deal 20-30+ damage if maxed poison
✅ **Multi-Target** - Shines in 3v3 squad combat
✅ **Not Instant Win** - Requires setup, enemies can still recover
✅ **Faction Identity** - Peak SPECTER fantasy (plague detonation)

### Power Budget Check:
- **Sepsis** (ultimate card): 4 Stamina → Poison 6 + amplify damage over time
- **Virulence** (card): 2 Stamina → Deal damage = Poison stacks
- Plague Mastery: 7 Mana → Double ALL Poison + Immediate damage + Weakened 2 (ALL)
- **Verdict:** Extremely powerful IF setup. Fair because requires 3-4 turns of poison stacking first.

### Why "Plague Mastery" instead of "Virulent Plague"?
- More concise
- "Mastery" implies skill/buildup required

---

## ABILITY 3: SOUL HARVEST (Future - Level 15+ Unlock)
**Cost:** 10 Mana
**Effect:** Apply Poison 10 to all enemies. For the next 3 turns, whenever an enemy takes Poison damage, restore 2 HP.
**Cooldown:** Once per combat

### Design Note:
- Massive poison bomb (10 stacks immediately)
- Lifesteal from poison (addresses SPECTER sustain weakness)
- Poison 10 + Miasma = 10, 11, 12 stacks (33+ damage over 3 turns + healing)

---

# ABILITY SUMMARY TABLE

| Faction | Ability 1 (3 Mana) | Ability 2 (7 Mana) | Ability 3 (10 Mana - Future) |
|---------|-------------------|-------------------|------------------------------|
| **AEGIS** | Bulwark: Gain Armor = 50% missing HP (max 10) | Iron Bastion: 12 Armor, Weakened 3 (all), Draw 1 | Unbreakable Fortress: Double Armor, gain Armor = HP, immune Weakened |
| **ECLIPSE** | Crimson Surge: +6 damage next attack, Bleeding 2, +1 Speed | Reaper's Mark: 12 damage, heal 8 + refund 2 Mana if kill, else Bleeding 4 | Blood Frenzy: Enraged 3, all attacks cost 0, Draw 2 |
| **SPECTER** | Withering Curse: Weakened 3, discard 1, Poison 1 | Plague Mastery: Double Poison (all), damage = Poison, Weakened 2 (all) | Soul Harvest: Poison 10 (all), heal when poison ticks |

---

# FACTION ABILITY MATCHUP ANALYSIS

## AEGIS vs ECLIPSE:
**AEGIS Advantage:**
- Bulwark counters ECLIPSE burst (more HP lost = more Armor gained)
- Iron Bastion Weakened 3 cripples ECLIPSE damage output
- ECLIPSE lacks tools to strip Armor efficiently

**ECLIPSE Counterplay:**
- Crimson Surge Speed bonus can first-strike
- Reaper's Mark Bleeding 4 bypasses Armor (goes to HP)
- Must stack Bleeding and burst before Armor scales

**Verdict:** AEGIS favored (65/35)

---

## ECLIPSE vs SPECTER:
**ECLIPSE Advantage:**
- Crimson Surge + Speed = kill SPECTER before Poison scales
- Reaper's Mark 12 damage finishes low HP targets
- ECLIPSE Speed 5 > SPECTER Speed 4 (always acts first)

**SPECTER Counterplay:**
- Withering Curse Weakened 3 reduces ECLIPSE burst
- Plague Mastery can end fights if ECLIPSE doesn't finish fast
- Poison ignores ECLIPSE's 0 Armor

**Verdict:** ECLIPSE favored (60/40)

---

## SPECTER vs AEGIS:
**SPECTER Advantage:**
- Poison ignores Armor entirely (bypasses AEGIS core defense)
- Plague Mastery can deal 20-30+ damage to high HP AEGIS
- Withering Curse + Miasma ensures Poison ramps exponentially

**AEGIS Counterplay:**
- Iron Bastion Weakened 3 buys time (reduces SPECTER chip damage)
- Bulwark can outheal Poison ticks (if used repeatedly)
- High HP pool (30 vs 25) gives more turns to respond

**Verdict:** SPECTER favored (65/35)

---

# BALANCE VALIDATION

## Does each ability feel earned?
✅ **3 Mana:** Available Turn 1-2, feels accessible but not spammable
✅ **7 Mana:** Available Turn 3-4, feels like earned ultimate moment
✅ **10 Mana:** Available Turn 5-6+, rare capstone ability

## Does each ability express faction identity?
✅ **AEGIS:** Defensive, scales with danger, enables tank fantasy
✅ **ECLIPSE:** Burst damage, execution rewards, high risk/reward
✅ **SPECTER:** Control, disruption, poison payoff

## Power creep check:
✅ **Ability 1 ≠ Always Better Than Cards** - Cards are more Stamina-efficient for pure damage/defense
✅ **Ability 2 ≠ Auto-Win** - 7 Mana abilities swing fights but don't end them alone
✅ **Abilities ≠ Mandatory** - You can win without using abilities (if you draft well)

## Skill expression:
✅ **AEGIS:** Timing Bulwark when low HP, saving Iron Bastion for critical turns
✅ **ECLIPSE:** Executing with Reaper's Mark (refund mechanic rewards precision)
✅ **SPECTER:** Stacking Poison optimally before Plague Mastery detonation

---

# IMPLEMENTATION NOTES

## UI Requirements:
- Ability buttons show current Mana cost (3, 7, 10)
- Ability buttons gray out if not enough Mana
- Mana bar shows current/max (e.g., "6/12 Mana")
- Ability tooltips explain exact effects

## Testing Priorities:
1. **Mana Generation Rate** - Validate Turn 1-2 for Ability 1, Turn 3-4 for Ability 2
2. **Ability 2 Power** - Ensure 7 Mana abilities swing but don't auto-win
3. **Faction Matchups** - Confirm 60/40 to 65/35 win rates hold with abilities

## Future Expansion:
- **Ability 3** (10 Mana) unlocks at Level 15+
- **Ability Variants** - Alternate versions of abilities (choose 1 before mission)
- **Ability Upgrades** - Enhanced versions (e.g., Bulwark max Armor 10 → 15)

---

**STATUS: LOCKED âœ…**
**Next Step:** Design enemy archetypes with AI behavior
**After That:** Define starting deck compositions
**Then:** Build combat simulator to validate math

---

**All 9 abilities are now locked and ready for implementation!**
