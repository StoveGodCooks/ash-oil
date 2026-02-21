# COMBAT SIMULATOR - PARAMETERS LOCKED

> **Status:** ✅ READY TO BUILD  
> **Test Scope:** 3 matchups, 50 runs each (150 total simulations)  
> **Version:** 1.0 - Initial Validation

---

## 🎯 SIMULATION OBJECTIVES

### Primary Goals:
1. Validate combat math works correctly
2. Confirm status effects trigger properly
3. Verify Mana generation rates
4. Test faction balance vs tutorial enemy
5. Identify broken combos or edge cases

### Success Criteria:
- All 3 factions beat Scout with 70%+ win rate
- Average combat: 5-8 turns
- No infinite loops or crashes
- Damage calculations match design docs

---

## 📊 TEST MATCHUPS (3 TOTAL)

### Matchup 1: AEGIS vs Scout
**Purpose:** Test tank faction vs basic enemy
**Expected Outcome:** AEGIS wins 85-90% (high HP + Armor advantage)

### Matchup 2: ECLIPSE vs Scout
**Purpose:** Test assassin faction vs basic enemy  
**Expected Outcome:** ECLIPSE wins 75-80% (speed + burst advantage)

### Matchup 3: SPECTER vs Scout
**Purpose:** Test control faction vs basic enemy
**Expected Outcome:** SPECTER wins 70-75% (Poison scaling advantage)

**Runs per matchup:** 50
**Total simulations:** 150

---

## 🎴 PLAYER STARTING DECKS (LOCKED)

### AEGIS Starter Deck (10 cards)
```
3x Shield Bash
  - Cost: 1 Stamina
  - Effect: Deal 5 damage, Gain 3 Armor

2x Brace
  - Cost: 1 Stamina
  - Effect: Gain 6 Armor

1x Retaliate
  - Cost: 2 Stamina
  - Effect: Gain 4 Armor. Next time you take damage, deal damage = Armor to attacker.

2x Defend
  - Cost: 1 Stamina
  - Effect: Gain 5 Armor

1x Bandage
  - Cost: 1 Stamina
  - Effect: Restore 5 HP

1x Focus
  - Cost: 0 Stamina
  - Effect: Draw 1 card

Total: 10 cards
Avg Cost: 1.0 Stamina
```

### ECLIPSE Starter Deck (10 cards)
```
3x Slash
  - Cost: 1 Stamina
  - Effect: Deal 6 damage, Apply Bleeding 1

2x Quick Strike
  - Cost: 0 Stamina
  - Effect: Deal 4 damage

1x Execution
  - Cost: 2 Stamina
  - Effect: Deal 12 damage if target below 50% HP, else 7 damage

2x Defend
  - Cost: 1 Stamina
  - Effect: Gain 5 Armor

1x Prepare
  - Cost: 0 Stamina
  - Effect: Gain +2 Stamina next turn. Exhaust.

1x Strike
  - Cost: 1 Stamina
  - Effect: Deal 6 damage

Total: 10 cards
Avg Cost: 0.8 Stamina
```

### SPECTER Starter Deck (10 cards)
```
3x Toxin Dart
  - Cost: 1 Stamina
  - Effect: Deal 4 damage, Apply Poison 1

2x Enfeeble
  - Cost: 1 Stamina
  - Effect: Apply Weakened 2

1x Strike
  - Cost: 1 Stamina
  - Effect: Deal 6 damage

2x Defend
  - Cost: 1 Stamina
  - Effect: Gain 5 Armor

1x Bandage
  - Cost: 1 Stamina
  - Effect: Restore 5 HP

1x Focus
  - Cost: 0 Stamina
  - Effect: Draw 1 card

Total: 10 cards
Avg Cost: 0.9 Stamina
```

---

## 👾 ENEMY DECK - SCOUT (8 CARDS)

**Scout Stats:**
- HP: 12
- Armor: 0
- Speed: 3
- Base Damage: 5

**Scout Deck (8 cards):**
```
4x Slash
  - Cost: 1 Stamina
  - Effect: Deal 5 damage

2x Pierce
  - Cost: 1 Stamina
  - Effect: Deal 4 damage, ignores 3 Armor

2x Retreat
  - Cost: 1 Stamina
  - Effect: Gain 2 Armor, move to back row (for simulator: just gain 2 Armor)

Total: 8 cards
Avg Cost: 1.0 Stamina
```

---

## 🧠 AI DECISION RULES (SCOUT)

### Scout AI Priority Tree:
```
EACH TURN (after drawing):
1. Check HP threshold:
   → If HP < 6 (50% HP) AND has "Retreat" in hand:
      Play Retreat (gain 2 Armor)
   
2. Check player Armor:
   → If player has Armor >= 5 AND has "Pierce" in hand:
      Play Pierce (bypass armor)
   
3. Default:
   → Play highest damage card in hand (Slash > Pierce > Retreat)
   → If multiple cards same damage, play lowest cost first
   → If tied on both, random choice
```

### Scout Ability Usage:
- **No abilities** (basic enemy)
- Scout only plays cards from deck

---

## 🔮 PLAYER ABILITY USAGE RULES (LOCKED)

### AEGIS Abilities:

**Bulwark (3 Mana):**
```
Use when ALL of:
- Current Mana >= 3
- Missing HP >= 12 (40%+ missing from 30 max)
- Would gain 6+ Armor (50% of 12+ missing HP)

Logic: Only use when good value (6+ Armor gain)
```

**Iron Bastion (7 Mana):**
```
Use when ALL of:
- Current Mana >= 7
- HP < 20 (under pressure) OR enemy HP > 8 (enemy still healthy)

Logic: Save for critical moments or when enemy dangerous
```

---

### ECLIPSE Abilities:

**Blood Rush (3 Mana):**
```
Use when ALL of:
- Current Mana >= 3
- Enemy has Bleeding >= 1 (Bloodlust synergy active)
- Can play attack card same turn (have 1+ Stamina remaining)

Logic: Combo with attacks for maximum burst
```

**Reaper's Mark (7 Mana):**
```
Use when ALL of:
- Current Mana >= 7
- Enemy HP < 8 (below 67% HP for Scout)
- Have attack cards in hand (can follow up)

Logic: Setup execution window
```

---

### SPECTER Abilities:

**Enfeeble (3 Mana):**
```
Use when ALL of:
- Current Mana >= 3
- Enemy does NOT have Weakened status
- Turn 2 or later (want to apply early but not turn 1)

Logic: Apply debuff early, don't stack duration
```

**Plague Mastery (7 Mana):**
```
Use when ALL of:
- Current Mana >= 7
- Enemy has Poison >= 4 (good damage payoff)
- Enemy HP > 6 (enemy won't die before payoff)

Logic: Maximize poison damage burst
```

---

## 📈 METRICS TO TRACK

### Per-Combat Metrics:
```
Combat ID: Unique identifier
Faction: AEGIS/ECLIPSE/SPECTER
Enemy: Scout
Winner: Player/Enemy
Turn Count: How many turns
Player HP Remaining: Final HP
Enemy HP Remaining: Final HP (should be 0 if player wins)

Max Status Effects Reached:
- Max Bleeding (player)
- Max Poison (enemy)
- Max Armor (player)
- Max Weakened (enemy)

Resource Usage:
- Total Mana Generated
- Total Mana Spent
- Abilities Used (count by name)
- Cards Played (count by name)

Damage Stats:
- Total Damage Dealt (player)
- Total Damage Taken (player)
- DoT Damage Dealt (Bleeding/Poison)
- Armor Damage Blocked
```

### Aggregate Metrics (per matchup, 50 runs):
```
Win Rate: X/50 wins (percentage)
Avg Turn Count: Mean turns to victory/defeat
Avg HP Remaining: Mean HP when winning
Turn Count Distribution: Fastest win, Slowest win, Median

Status Effect Analysis:
- Avg Max Bleeding reached
- Avg Max Poison reached
- Avg Max Armor reached

Resource Analysis:
- Avg Mana generated per combat
- Avg Mana spent per combat
- Ability usage rate (% of combats where used)

Card Performance:
- Most played card
- Highest damage card
- Most efficient card (damage per Stamina)
```

---

## 🎲 RNG HANDLING

### Deck Shuffling:
```
- Use Python random.shuffle() with seed
- Seed = run number (1-50)
- Each run gets unique but reproducible shuffle
- Example: Run 1 always has same draw order
```

### Card Draw:
```
- Draw from top of deck
- When deck empty, shuffle discard → new deck
- Starting hand: Draw 5 cards at combat start
- Per turn: Draw 1 card at start of turn
```

### Tiebreakers:
```
- If multiple valid actions have same priority:
  → Choose randomly
- If simultaneous death (both reach 0 HP):
  → Player wins (per combat rules)
```

---

## 🔧 IMPLEMENTATION NOTES

### Combat Loop Structure:
```python
def simulate_combat(player_faction, enemy_type, seed):
    # Setup
    player = create_player(player_faction)
    enemy = create_enemy(enemy_type)
    random.seed(seed)
    
    # Determine turn order (Speed comparison)
    turn_order = determine_turn_order(player, enemy)
    
    # Combat loop
    turn = 0
    while player.hp > 0 and enemy.hp > 0 and turn < 100:
        turn += 1
        
        for actor in turn_order:
            # Phase 1: Start of Turn
            apply_dots(actor)
            check_death(player, enemy)
            if combat_over(): break
            
            trigger_faction_passives(actor)
            generate_resources(actor)
            draw_card(actor)
            
            # Phase 2: Main Phase
            if actor.is_player:
                execute_player_turn(player)
            else:
                execute_enemy_ai(enemy)
            
            # Phase 3: End of Turn
            decay_status_effects(actor)
            check_hand_limit(actor)
            reset_stamina(actor)
    
    # Record results
    return combat_results(player, enemy, turn)
```

### Player Turn Logic:
```python
def execute_player_turn(player):
    # Check ability usage (Mana-based)
    if should_use_ability(player):
        use_ability(player)
    
    # Play cards (Stamina-based)
    while player.stamina > 0:
        playable_cards = get_playable_cards(player)
        if not playable_cards:
            break
        
        card = choose_best_card(playable_cards, player, enemy)
        play_card(player, card)
```

### Card Selection Logic:
```python
def choose_best_card(playable_cards, player, enemy):
    # Priority 1: Kill shot (if enemy low HP)
    if enemy.hp <= 7:
        damage_cards = [c for c in playable_cards if c.type == 'attack']
        if damage_cards:
            return max(damage_cards, key=lambda c: c.damage)
    
    # Priority 2: Defensive (if player low HP)
    if player.hp < 10:
        defense_cards = [c for c in playable_cards if 'Armor' in c.effect]
        if defense_cards:
            return defense_cards[0]
    
    # Priority 3: Apply status effects (if not present)
    if enemy.bleeding < 2 and 'Bleeding' in player.faction:
        bleed_cards = [c for c in playable_cards if 'Bleeding' in c.effect]
        if bleed_cards:
            return bleed_cards[0]
    
    # Default: Highest damage/stamina ratio
    return max(playable_cards, key=lambda c: c.damage / max(c.cost, 0.5))
```

---

## ✅ VALIDATION CHECKS

### Pre-Simulation Checks:
- [ ] All 3 player decks have exactly 10 cards
- [ ] Scout deck has exactly 8 cards
- [ ] All cards have valid costs (0-4 Stamina)
- [ ] All status effect caps enforced (Bleeding 12, Poison 12, Armor 30)
- [ ] Starting stats match design docs (AEGIS 30 HP, ECLIPSE 20 HP, SPECTER 25 HP)

### Post-Combat Checks:
- [ ] Winner HP > 0, Loser HP = 0
- [ ] Turn count >= 1
- [ ] Total Mana generated matches formula (+1/turn, +1/card played)
- [ ] Status effects never exceeded caps
- [ ] Damage calculations match manual verification

### Expected Results:
- [ ] AEGIS beats Scout 85-90% (42-45 wins out of 50)
- [ ] ECLIPSE beats Scout 75-80% (37-40 wins out of 50)
- [ ] SPECTER beats Scout 70-75% (35-37 wins out of 50)
- [ ] Average combat duration: 5-8 turns
- [ ] No crashes or infinite loops

---

## 📋 OUTPUT FORMAT

### Per-Run Output:
```
Run #1: AEGIS vs Scout
Winner: AEGIS
Turns: 6
Player HP: 23/30
Max Bleeding: 2
Max Armor: 14
Mana Generated: 7
Abilities Used: Bulwark (Turn 4)
Cards Played: Shield Bash x3, Brace x2, Defend x1, Focus x1
```

### Aggregate Report:
```
═══════════════════════════════════════════
AEGIS vs SCOUT (50 runs)
═══════════════════════════════════════════
Win Rate: 43/50 (86%)
Avg Turn Count: 6.2 turns
Avg HP Remaining: 21.4/30

Turn Distribution:
  Fastest Win: 4 turns
  Slowest Win: 9 turns
  Median: 6 turns

Status Effects:
  Avg Max Bleeding: 1.8
  Avg Max Armor: 16.3

Resource Usage:
  Avg Mana Generated: 7.8
  Avg Mana Spent: 5.2
  Bulwark Usage: 68% of combats
  Iron Bastion Usage: 12% of combats

Top Cards Played:
  1. Shield Bash (avg 3.2 per combat)
  2. Brace (avg 2.1 per combat)
  3. Defend (avg 1.8 per combat)
```

---

## 🔒 LOCKED STATUS

**✅ ALL PARAMETERS LOCKED FOR SIMULATOR V1**

**Ready to implement:**
- Player decks (3 factions, 10 cards each)
- Enemy deck (Scout, 8 cards)
- AI decision rules (Scout behavior)
- Ability usage rules (6 abilities across 3 factions)
- Metrics tracking (per-combat + aggregate)
- Expected outcomes (win rates, turn counts)

**Simulation Scope:**
- 3 matchups (AEGIS vs Scout, ECLIPSE vs Scout, SPECTER vs Scout)
- 50 runs per matchup
- 150 total simulations

**Next Step:** Build Python simulator with locked parameters

---

**Document Status:** ✅ LOCKED - Ready for implementation  
**Estimated Build Time:** 3-4 hours (combat engine + metrics + output formatting)  
**First Results:** Can validate balance assumptions immediately
