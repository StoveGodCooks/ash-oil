# Card Game Systems Manuscript (Master Compilation)

**Build date:** 2026-02-15  
**Purpose:** Single, readable manuscript compiled from the project’s system/spec documents.  
**Notes on compilation (non-destructive):**
- No sections were intentionally truncated; all source files were ingested in full.
- Duplicate/overlapping passages across files were de-duplicated **only when they were materially the same** (same meaning, near-identical wording).
- Each section includes `Source:` markers so you can trace content back to originals.

## Table of contents
- [Project Overview](#project-overview)
- [Game Design Document: Tactical Card Expedition Game](#game-design-document-tactical-card-expedition-game)
- [Card UI Spec](#card-ui-spec)
- [CARD UI SPEC v1 — PC Web / Neocities (LOCKED)](#card-ui-spec-v1--pc-web--neocities-locked)
- [Card Library](#card-library)
- [COMPLETE CARD LIBRARY - ALL FACTIONS + NEUTRAL](#complete-card-library---all-factions--neutral)
- [Core Combat System](#core-combat-system)
- [COMBAT SYSTEM - LOCKED FOR PRODUCTION (V1)](#combat-system---locked-for-production-v1)
- [Combat System Rules - Complete Design](#combat-system-rules---complete-design)
- [Status Effects](#status-effects)
- [STATUS EFFECTS - LOCKED FOR PRODUCTION (V1)](#status-effects---locked-for-production-v1)
- [Status Effects System - Complete Design](#status-effects-system---complete-design)
- [Economy & Shop](#economy--shop)
- [ECONOMY & SHOP SYSTEM - COMPLETE DESIGN](#economy--shop-system---complete-design)
- [Resources](#resources)
- [Refined Dual-Resource Combat System (Stamina + Mana)](#refined-dual-resource-combat-system-stamina--mana)
- [Gear System](#gear-system)
- [Gear System - Complete Design (24 Pieces)](#gear-system---complete-design-24-pieces)
- [Factions](#factions)
- [Complete Faction Design - AEGIS | ECLIPSE | SPECTER](#complete-faction-design---aegis--eclipse--specter)
- [FACTION 1: AEGIS (The Fortress)](#faction-1-aegis-the-fortress)
- [FACTION 2: ECLIPSE (The Blade)](#faction-2-eclipse-the-blade)
- [FACTION 3: SPECTER (The Puppeteer)](#faction-3-specter-the-puppeteer)
- [FACTION MATCHUP MATRIX](#faction-matchup-matrix)
- [DESIGN VALIDATION CHECKLIST](#design-validation-checklist)
- [NEXT STEPS](#next-steps)
- [FACTION ABILITIES - COMPLETE DESIGN](#faction-abilities---complete-design)
- [AEGIS ABILITIES (The Fortress)](#aegis-abilities-the-fortress)
- [ECLIPSE ABILITIES (The Blade)](#eclipse-abilities-the-blade)
- [SPECTER ABILITIES (The Puppeteer)](#specter-abilities-the-puppeteer)
- [ABILITY SUMMARY TABLE](#ability-summary-table)
- [FACTION ABILITY MATCHUP ANALYSIS](#faction-ability-matchup-analysis)
- [BALANCE VALIDATION](#balance-validation)
- [IMPLEMENTATION NOTES](#implementation-notes)
- [Enemies & Bosses](#enemies--bosses)
- [ENEMY ARCHETYPES - COMPLETE DESIGN](#enemy-archetypes---complete-design)
- [Boss Trait Library → Locked Implementation Schema (v1)](#boss-trait-library--locked-implementation-schema-v1)
- [12 Boss Traits (Data Objects)](#12-boss-traits-data-objects)
- [Minimal Mapping: Trait → Contract Risk Score / Reward Weighting](#minimal-mapping-trait--contract-risk-score--reward-weighting)
- [Notes for Your Existing Systems (No New Systems Added)](#notes-for-your-existing-systems-no-new-systems-added)
- [Map, Trials, and Weights](#map-trials-and-weights)
- [Contracts](#contracts)
- [Story & Quests](#story--quests)
- [IMPLEMENTATION DIRECTIVE — Dynamic Story + Quest System (RFQE v0.1) — LOCKED](#implementation-directive--dynamic-story--quest-system-rfqe-v01--locked)
- [IMPLEMENTATION DIRECTIVE — Dynamic Story + Quest System (RFQE v0.1) — LOCKED](#implementation-directive--dynamic-story--quest-system-rfqe-v01--locked)
- [Expedition & Injury](#expedition--injury)
- [Expedition Injury System - Two-Track Health Design](#expedition-injury-system---two-track-health-design)
- [Hook Objects & Data Schema](#hook-objects--data-schema)
- [Simulator Parameters](#simulator-parameters)
- [COMBAT SIMULATOR - PARAMETERS LOCKED](#combat-simulator---parameters-locked)
- [Determine turn order (Speed comparison)
    turn_order = determine_turn_order(player, enemy)](#determine-turn-order-speed-comparison----turnorder--determineturnorderplayer-enemy)
- [Combat loop
    turn = 0
    while player.hp > 0 and enemy.hp > 0 and turn < 100:
        turn += 1](#combat-loop----turn--0----while-playerhp--0-and-enemyhp--0-and-turn--100--------turn--1)
- [Phase 2: Main Phase
            if actor.is_player:
                execute_player_turn(player)
            else:
                execute_enemy_ai(enemy)](#phase-2-main-phase------------if-actorisplayer----------------executeplayerturnplayer------------else----------------executeenemyaienemy)
- [Phase 3: End of Turn
            decay_status_effects(actor)
            check_hand_limit(actor)
            reset_stamina(actor)](#phase-3-end-of-turn------------decaystatuseffectsactor------------checkhandlimitactor------------resetstaminaactor)
- [Record results
    return combat_results(player, enemy, turn)
```](#record-results----return-combatresultsplayer-enemy-turn)
- [Play cards (Stamina-based)
    while player.stamina > 0:
        playable_cards = get_playable_cards(player)
        if not playable_cards:
            break](#play-cards-stamina-based----while-playerstamina--0--------playablecards--getplayablecardsplayer--------if-not-playablecards------------break)
- [Priority 2: Defensive (if player low HP)
    if player.hp < 10:
        defense_cards = [c for c in playable_cards if 'Armor' in c.effect]
        if defense_cards:
            return defense_cards[0]](#priority-2-defensive-if-player-low-hp----if-playerhp--10--------defensecards--c-for-c-in-playablecards-if-armor-in-ceffect--------if-defensecards------------return-defensecards0)
- [Priority 3: Apply status effects (if not present)
    if enemy.bleeding < 2 and 'Bleeding' in player.faction:
        bleed_cards = [c for c in playable_cards if 'Bleeding' in c.effect]
        if bleed_cards:
            return bleed_cards[0]](#priority-3-apply-status-effects-if-not-present----if-enemybleeding--2-and-bleeding-in-playerfaction--------bleedcards--c-for-c-in-playablecards-if-bleeding-in-ceffect--------if-bleedcards------------return-bleedcards0)
- [Default: Highest damage/stamina ratio
    return max(playable_cards, key=lambda c: c.damage / max(c.cost, 0.5))
```](#default-highest-damagestamina-ratio----return-maxplayablecards-keylambda-c-cdamage--maxccost-05)
- [Audits & Blind Spots](#audits--blind-spots)
- [SYSTEM BLIND SPOT AUDIT](#system-blind-spot-audit)
- [1️⃣ Combat System Blind Spots](#1-combat-system-blind-spots)
- [2️⃣ Gear System Blind Spots](#2-gear-system-blind-spots)
- [3️⃣ Faction Triangle Stability](#3-faction-triangle-stability)
- [4️⃣ Contract Board & Hook System](#4-contract-board--hook-system)
- [5️⃣ Economy Pressure Curve](#5-economy-pressure-curve)
- [6️⃣ Final Boss Variant System](#6-final-boss-variant-system)
- [7️⃣ Cross-System Integration Opportunities](#7-cross-system-integration-opportunities)
- [🔥 Top 5 Watchpoints (Priority Monitoring)](#top-5-watchpoints-priority-monitoring)
- [Conclusion](#conclusion)
- [Project TODO](#project-todo)
- [Gladiator Card RPG - Project TODO List](#gladiator-card-rpg---project-todo-list)

---
# Project Overview

## Source: card game .txt

# Game Design Document: Tactical Card Expedition Game

## Core Concept

A single-player card-based tactical game combining Legends of Runeterra's combat mechanics with XCOM's strategic depth and Expeditions: Rome's mission structure. Players lead a champion and their lieutenants through multi-encounter expeditions where decisions, resource management, and unit survival create meaningful strategic gameplay.

---

## Game Pillars

### 1. Meaningful Progression

- Multi-encounter missions that feel like real expeditions, not single-fight errands
- "Expeditions of Rome meets XCOM" - substantial operations with weight and consequence
- No constant hub bouncing - commit to full missions with escalating stakes

### 2. Strategic Depth Over Graphics

- Card game format allows deep mechanics without heavy graphics requirements
- Complex systems and tactical decisions are the core appeal
- Gameplay richness compensates for visual limitations

### 3. Attachment to Units

- Named heroes with progression systems
- Injury consequences create emotional investment
- Veteran units become irreplaceable through experience and story

### 4. Challenging But Fair

- Hard but beatable difficulty scaling
- Clear telegraphing and player agency
- NOT Darkest Dungeon brutal - challenging without being punishing
- Players should lose due to decisions, not RNG or unfair mechanics

## Combat System

### Core Mechanics

- **Legends of Runeterra-style card combat**
  - Alternating action system (back-and-forth play)
  - Unit positioning on board matters
  - Units persist between turns and can be buffed/damaged
  - Tactical without requiring complex grid movement

### Unit Composition

- **1 Main Champion** - Player's avatar, cannot permanently die
- **3-4 Lieutenant Slots** - Named heroes with unique abilities
- **Total Roster: 6-8 units** - Allows rotation when units need recovery

### Unit Progression

- Survive missions → gain XP → unlock new cards/abilities
- Each lieutenant has skill tree or card unlock path
- Veterans become genuinely powerful
- Higher level units add more powerful cards to deck pool OR provide passive benefits

## Mission Structure

### Expedition Format

Each mission consists of **4-6 consecutive encounters**:

**Wave 1-2: Scouts/Light Enemies**
- Warm-up encounters
- Establish tactical positioning
- Minimal resource drain

**Wave 3-4: Main Force**
- Primary challenge
- Significant resource drain
- Tests player strategy

**Wave 5-6: Elite/Boss**
- Climactic encounter
- Special mechanics and telegraphed attacks
- Multiple phases possible

### Between-Encounter Decision Points

After each encounter, players choose:

**Push Forward** (no rest)
- Keep momentum, enemies don't reinforce
- Injuries/HP stay as-is
- Faster mission completion
- High risk

**Quick Breather** (short rest)
- Heal 30% HP on all units
- Remove 1 minor status effect per unit
- Enemies may regroup/reinforce
- Costs 1 supply

**Full Rest** (camp)
- Heal 70% HP
- Use healing cards/abilities
- May trigger random event (ambush, find loot, morale boost)
- Enemy gets stronger for final encounter
- Costs 2 supplies

**Strategic Retreat** (abandon mission)
- Keep loot from completed encounters
- All knocked out units risk grave injury (dice roll)
- Mission failure consequences
- "XCOM evac" moment

## Injury System

### Two-Track Health System

**HP (Combat Health)**
- Your combat health during encounters
- Regenerates partially (30-50%) between encounters within same mission
- Drop to 0 HP = knocked out for rest of that encounter
- Can use healing cards/abilities during combat

**Injury Track (Real Damage)**
- Separate from HP - represents lasting harm
- Does NOT automatically heal between encounters

### When Injuries Occur

- HP drops to 0 (knocked out = minimum 1 injury)
- Critical hits from enemies
- Failing to block devastating attacks
- Environmental hazards
- Taking damage while already at low HP

### Injury Severity Levels

**Minor Wounds** (heal naturally over time)
- Examples:
  - Bruised ribs: -1 HP for next mission
  - Strained arm: One random card costs +1 this mission
  - Dazed: Draw -1 card first turn
- Healing: Goes away after sitting out 1-2 missions OR basic medical resources

**Serious Injuries** (require resources + time)
- Examples:
  - Broken leg: Can't use movement cards effectively
  - Deep cut: Lose 1 HP per turn until treated
  - Concussion: 50% chance to discard random card each turn
- Healing: Need medic/supplies/gold to treat, takes multiple missions

**Grave Injuries** (permanent scars)
- Examples:
  - Lost eye: -1 to ranged attack cards permanently
  - Bad knee: -2 max stamina forever
  - Shattered ribs: Starts each mission with -2 HP
  - Nerve damage: One random card type costs +1 permanently
- **NEVER FULLY HEAL** - permanent consequence of reckless play

### Injury Escalation

**Finish mission with 1-2 injuries:**
- Minor wounds, heal normally

**Finish with 3+ injuries OR get injured while already wounded:**
- Risk grave injury
- Game warns: "⚠️ Lt. Marcus is badly wounded. Deploying him again risks permanent injury."

**Player choice:**
- Rest veteran (lose their power for missions) OR risk permanent damage
- Creates meaningful strategic decisions

### Injury Warning System

Game provides explicit warnings:
- "⚠️ Lt. Marcus: 2 injuries, low HP - another knockdown risks GRAVE INJURY"
- "⚠️ Warning: 3 units injured - retreating now may be wise"
- Players make informed risk vs reward decisions

## Difficulty Scaling

### Philosophy

- **Hard but predictable** - Losses from decisions, not RNG
- **Clear telegraphing** - Players can see dangers coming
- **Comeback mechanics** - Getting behind ≠ unwinnable spiral
- **Player agency** - Choose your challenge level

### Target Metrics

- **60-70% mission success rate** - Sweet spot between boring and frustrating
- **Most missions should be "close calls"** not "easy stomps" or "brutal wipes"

### Injury Rate Targets

- 1-2 minor injuries per mission = normal
- 0 injuries = excellent execution, player feels good
- 3+ injuries = warning signs, time to adjust strategy
- Grave injuries = rare, result of ignoring multiple warnings

### Mission Difficulty Tiers

Players choose mission difficulty before deployment:

**EASY ⭐** (Tutorial/Recovery missions)
- 3 encounters, weak enemies
- Good for training new recruits
- Lower rewards
- Example: "Bandit Raid" - disorganized enemies

**MEDIUM ⭐⭐** (Standard progression)
- 4-5 encounters
- Mixed enemy types
- Standard rewards
- Example: "Enemy Patrol" - organized resistance

**HARD ⭐⭐⭐** (Veteran squads)
- 5-6 encounters, elite enemies
- High injury risk
- Great rewards
- Example: "Fortified Position" - prepared enemies

**EXTREME ⭐⭐⭐⭐** (Optional challenges)
- 6+ encounters, brutal difficulty
- Expect injuries
- Legendary loot
- Example: "Enemy Stronghold" - extreme danger

**Key principle:** Players never forced into unfair fights

### Progressive Campaign Difficulty

**Act 1 (Missions 1-10): Learning Phase**
- Injuries are rarer
- Enemies telegraph clearly
- Easier to retreat successfully
- Generous healing resources
- Goal: Learn systems without punishment

**Act 2 (Missions 11-25): Challenge Ramps**
- Enemies hit harder
- More complex encounter design
- Injuries more common but manageable
- Resources tighten slightly
- Goal: Master tactics and resource management

**Act 3 (Missions 26+): Expert Play**
- Assumes system mastery
- Creative enemy combinations
- Injury management critical
- Resource optimization required
- Goal: Execute perfect strategy

**Important:** Even in Act 3, medium difficulty missions available for recovery/training

### Dynamic Difficulty Adjustment (Behind-the-Scenes)

**Track player performance:**
- Win rate on missions
- Average injuries per mission
- Resource accumulation rate
- Retreat frequency

**If player struggling:**
- Slightly reduce enemy damage (5-10%)
- Increase loot/resource drops
- Offer easier mission options
- Give more healing between encounters

**If player crushing:**
- Enemies get slightly smarter AI
- More aggressive enemy compositions
- Better rewards for harder missions

**Critical:** This should be invisible - players shouldn't feel patronized

### Injury Recovery Balance

**Generous recovery options:**
- Natural healing is FREE, just takes time (2-3 missions)
- Medical treatment reasonably priced (not punitive)
- Always have backup units available
- Starting roster: 6-8 units for 4 deployment slots = room for rotation

**Avoiding Darkest Dungeon's mistakes:**
- Injuries are setbacks, not disasters
- Can always field competent team
- Healing resources are available
- Grave injuries rare (only from reckless play)

### Enemy Design for Fair Challenge

**Telegraphed Danger:**
- "⚠️ Enemy Berserker preparing MASSIVE STRIKE (8 damage) - blocks recommended"
- "🎯 Archer targeting Lt. Kira (wounded) - 70% hit chance"
- Show what's coming so players can respond

**Counterplay Always Exists:**
- Every dangerous enemy has weakness
- Block cards reduce damage
- Positioning matters
- CC/debuffs are valuable
- Players never helpless

**Stat-Based Scaling (NOT BS Mechanics):**
- Later enemies have more HP/damage (visible numbers)
- NOT: "This enemy ignores all defenses"
- NOT: "Random chance to permanently wound"

### Hidden Safety Mechanics

**Death Protection** (first time per mission)
- First time unit would die/get grave injury = survives with serious injuries instead
- Players don't know this exists
- Prevents one mistake from destroying veteran

**Clutch Moments**
- When dire, slightly increase chance for good card draws
- Not noticeable, just gives fighting chance

**Resource Floor**
- Can't get stuck unable to progress
- Always at least one free/cheap healing option
- Basic starter units always available

### Player Agency in Difficulty

**Optional Modifiers at Mission Start:**
- "Deploy with -1 unit for +50% rewards"
- "Enemies stronger but drop better loot"
- "Permadeath enabled this mission (hardcore mode)"

Let players push themselves when ready

### Feedback and Learning

**Post-Mission Breakdown:**
- "Lt. Marcus took 45 damage this mission - consider more defensive cards"
- "You used 3 healing cards - enemy type X hits hard, prepare better"
- "Perfect mission! No injuries sustained"

Help players understand and improve

## Example Mission Flow

### Mission Start

- 4 units deploy: Main Champion + 3 Lieutenants, all fresh

### Encounter 1 (Scouts)

- Easy fight
- Lt. Kira takes some damage but no injuries
- **Decision Point:** Push forward or quick rest?

### Encounter 2 (Ambush)

- Harder fight
- Lt. Marcus knocked out → gains "Sprained Ankle" injury
- Lt. Kira hit hard, low HP
- **Decision Point:** Push (Marcus limping, Kira vulnerable) or full rest (enemies fortify)?

### Player Chooses: Quick Rest

- Marcus still has Sprained Ankle (-1 movement)
- Kira back to 60% HP
- Enemies ahead warned of approach

### Encounter 3 (Main Force)

- Tough fight, damage spread around
- Lt. Kira knocked out → gains "Sword Slash" injury (now 2 injuries total)
- Champion takes damage but survives
- **⚠️ NEW WARNING:** "Lt. Kira gravely wounded - another injury becomes permanent"

### Critical Decision Point

Options:
- Push to final boss with Kira at risk?
- Full rest but final boss gets stronger?
- Retreat and take the loss?

### Player Chooses: Push Forward (Risky)

### Encounter 4 (Boss)

- Play carefully, keep Kira in back
- Lt. Marcus takes hits, gets knocked out → 2nd injury
- **WIN** but barely

### Mission End Results

- **Lt. Kira:** 2 injuries, needs medical attention (3 missions OR costs resources)
- **Lt. Marcus:** 2 injuries, same situation
- **If mission lost:** Kira's injuries would have become permanent grave injury

### Post-Mission Hub

**Medical Tent Options:**
- Pay 50 gold → heal Kira in 1 mission instead of 3
- Let her rest naturally (unavailable 3 missions)
- Deploy her anyway next mission (RISK grave injury)

## Tension Sources

The game creates tension through:

1. **Multi-unit injury management** across multiple encounters
2. **Rest vs push decisions** with real consequences
3. **Veteran power vs fragility** - strong but vulnerable
4. **Resource allocation** - healing vs upgrading
5. **Roster rotation** when veterans need recovery
6. **Escalating stakes** within each expedition
7. **Clear warnings** that let players knowingly take risks

## Key Design Principles

### What Makes This Different

**Not Darkest Dungeon:**
- Challenging but not punishing
- Generous recovery systems
- Clear feedback and warnings
- No death spirals

**Not Standard Deck Builder:**
- Multi-encounter expeditions
- Unit persistence and injury management
- Squad-based rather than pure solo hero

**Not Full Tactics Game:**
- Card-based combat keeps complexity manageable
- No complex grid movement
- Focus on card synergies and deck building

### Core Player Experience

Players should feel:
- **Strategic mastery** through good decision-making
- **Attachment to units** through progression and scars
- **Meaningful choices** at every decision point
- **Fair challenge** - hard but beatable
- **Progression** both within missions and across campaign
- **Stories emerging** from veteran units with battle scars

## Future Development Areas

### To Be Designed

1. **Card Mechanics Specifics**
   - Deck building system
   - Card types and categories
   - Combat flow details
   - Resource system (mana/energy/etc)

2. **Hub/Progression Systems**
   - Upgrade trees
   - Recruitment mechanics
   - Campaign map structure
   - Between-mission activities

3. **Enemy Design**
   - Enemy types and abilities
   - Encounter variety
   - Boss mechanics
   - Faction differences

4. **Setting/Theme**
   - Fantasy, sci-fi, historical?
   - Art direction
   - Narrative framing
   - World building

5. **Economy/Resources**
   - Currency types
   - Loot system
   - Crafting/upgrades
   - Resource sinks

## Success Criteria

The game succeeds when:

- Players feel attached to their veteran units
- Missions feel like meaningful expeditions, not chores
- Difficulty is challenging but fair
- Strategic decisions feel impactful
- Comeback from setbacks is possible
- Learning curve is manageable
- Replayability through different builds/strategies

*Document Status: Core systems locked. Ready for detailed mechanical design.*

## Source: CORE SYSTEM MASTER SPEC.txt

🧠 CARD GAME – CORE SYSTEM MASTER SPEC (v1.0 LOCKED)

1️⃣ CORE DESIGN PRINCIPLES

No travel map.

All runs are selected from Hub Board.

Contracts are round-based sequences.

Board is reactive via Hooks.

Rival escalates via Vengeance Clock + Heat.

Relationships are hidden but mechanically active.

Boss Traits define build direction.

Fail-forward model.

Fully modular.

2️⃣ HUB BOARD SYSTEM

Board Structure Per Visit

1 Main Contract (if unlocked)

3 Side Contracts

Rival Contract replaces 1 Side slot when triggered

Minimum 2 contracts must resolve active Hooks.

Side contracts expire on departure.
Main persists.

Contract Preview Data

Each contract displays:

Boss Traits (1–2 keywords)

Round Count

Risk Tags

Reward Tags

Trial Availability

3️⃣ HOOK SYSTEM

Hooks are generated after:

Combat outcomes

Retreat

Defeat

Vow changes

Rival activity

Examples:

injury_major

bond_fracture

trust_drop

vow_created

vow_broken

rival_targets

grief_active

low_supplies

Each hub visit must service ≥2 hooks.

Unresolved hooks escalate (max level 3).

4️⃣ RIVAL ESCALATION MODEL

Rival Core State

hateLevel (1–5)

vengeanceClock (0–6)

rivalHeat (0–100)

targetTeammateId

intrusionLevel (0–3)

Trigger Rule

If vengeanceClock ≥ 6:

Spawn Rival Contract

Reset vengeanceClock to 3

Intrusion Levels

0 – Dormant
1 – Minor Disruption
2 – Active Sabotage
3 – Direct Assault

Rival Intrusion modifies next round.

Rival Contract Types

Intercept

Bait

Rescue

Ignored Rival Contract:

vengeanceClock +2

intrusionLevel++

targetTeammate stress increase

5️⃣ ROUND-BASED CONTRACT SYSTEM

Contract Classes
Short (5 Rounds)

3 Combat
1 Event
1 Boss

Standard (7 Rounds)

4 Combat
1 Event
1 Rest
1 Boss

Power (6 Rounds)

3 Combat
2 Trial Opportunities
1 Boss

Recovery (5–6 Rounds)

2–3 Combat
2 Rest
1 Event
1 Boss/Mini-Boss

Rival (7 Rounds)

4 Combat
1 Event
1 Rival Intrusion
1 Rest
1 Boss

6️⃣ TRIAL SYSTEM

Trials appear before select rounds.

Accept → harder round + enhanced reward
Decline → normal round

Trial Reward Bundles

Upgrade Bundle

Rare Bundle

Economy Bundle

Recovery Bundle

Trial Modifier Library (15)

Reinforced
Frenzy
Thick Hide
Blood Price
Attrition
Overtime
Marked
Sunder
Swarm
Counterstance
Hexed
Cleanse Ward
No Retreat
Shattered Supplies
Executioner

Trials affect only that round.

7️⃣ ROUND REWARD TABLES

Combat

Small gold
Supply chance
20% card reward chance

Elite

Medium gold
Upgrade material
Rare chance

Event

Hook resolution / relationship change

Rest

Heal OR stress relief OR minor injury downgrade

Boss

Major gold
Guaranteed upgrade
Rare card chance
Renown increase

8️⃣ RETREAT SYSTEM

Allowed between rounds unless restricted by Trial.

Reward scaling by progress:

1–2 rounds: 20%
3–4 rounds: 40–50%
5–6 rounds: 60–70%
Pre-boss: 75–80%

Retreat always generates ≥1 hook.

9️⃣ BOSS TRAIT SYSTEM (MECHANICAL)

Boss Traits are not cosmetic.
They alter:

Enemy behavior

Round modifiers

Reward weighting

Shop weighting

Contract risk score

Boss Trait Library (12)

Armor Wall
Bleed Punisher
Poison Bloom
Summoner
Dispel
Tempo Tax
Execute
Counterattack
Shielder
Stun
Swarm
Endurance

Trait Mechanical Impact Examples

Armor Wall

Enemies start with Armor

Shop weighting increases Armor-pierce tools

Bleed Punisher

Boss gains bonus when afflicted with bleed

Shop weights non-bleed builds

Summoner

Adds spawn periodically

AoE cards weighted in shop

Tempo Tax

Card cost manipulation

Shop weights cost-reduction tools

Execute

Boss deals bonus damage to low HP

Defensive upgrades weighted

🔟 SHOP COUNTER WEIGHTING

When contract selected:

Shop stock weighting:

50% normal pool
30% counters for Boss Traits
20% party-condition tools

Ensures build direction matters.

11️⃣ RELATIONSHIP INTEGRATION

Hidden stats influence:

Assist chance

Link effects

Friction penalties

Betrayal checks

Rival targeting

Combat actions affect relationship state.

Hub events modify relationship tags.

No meters shown.

12️⃣ FINAL BOSS VARIANT INTEGRATION

Phase 3 behavior selected by:

If rivalHeat ≥ 70 → RIVAL ENTRY
Else if Loyalty low → BETRAYAL CHECK
Else → UNITY TEST

Boss variants reference relationship + rival systems.

13️⃣ FAIL-FORWARD MODEL

Success → full reward
Retreat → partial reward + hooks
Defeat → heavy hooks + escalation

No default permadeath.
Permanent Scars optional system.

14️⃣ BALANCE SAFEGUARDS

Standard contracts always include 1 Rest.

Recovery contracts contain 0 Elite.

Trials affect only one round.

Rival intrusion modifies next round only.

Hooks capped at escalation level 3.

Boss traits always previewed.

15️⃣ EXPANDABILITY

Supports:

Additional Boss Traits

Additional Trial Modifiers

Multiple Rivals

Faction layers

Act modifiers

Hard Mode (permadeath)

Multi-phase bosses

No system rewrite required.

✅ FINAL LOCK SUMMARY

You now have:

✔ Reactive Hub Board
✔ Hook-driven contract generation
✔ Rival escalation engine
✔ Round-based contracts (no map)
✔ Trial risk/reward system
✔ Reward tables
✔ Boss trait mechanical depth
✔ Shop counter-weighting
✔ Fail-forward structure
✔ Final boss integration
✔ Fully modular expansion path

# Card UI Spec

## Source: CARD UI SPEC v1 — PC Web.txt

# CARD UI SPEC v1 — PC Web / Neocities (LOCKED)

**Status:** LOCKED (v1)
**Platform Target:** PC-first (Neocities web build)
**Card Style Choice:** **Dossier / Terminal Panel** with a subtle physical-card silhouette
**Primary Goal:** readability + cohesion + “watched / logged / system file” vibe

## 0) Master Defaults (Single Source of Truth)

- **Base render size:** **420 × 588 px** (portrait)
- **Inspect / zoom size (optional):** **630 × 882 px**
- **Hover scale:** **1.08 max**
- **Browser zoom support:** must read cleanly at **100%** and **125%**

**Aspect ratio note:** Keep all templates and art crops aligned to this portrait ratio to prevent rework.

## 1) Visual Language (What this should feel like)

- Not a fantasy parchment card.
- Not a clean mobile UI tile.
- It’s a **classified file / terminal dossier** with stamps, IDs, subtle telemetry, and constrained windows.

**Keywords:** clinical, uneasy, monitored, archived, corrupted, procedural.

## 2) Layer Stack (Top → Bottom)

1. **FX Layer**
   - glow, scanline shimmer, rarity pulse, corner bracket pulse (subtle)
2. **Frame Layer**
   - border + corners + silhouette + top/bottom rails
3. **UI Chrome Layer**
   - title plate, type strip, stamps, pips rails, chips
4. **Icon Layer**
   - cost chip icon, faction stamp, keyword chips, rarity pips
5. **Text Layer**
   - name, type, rules, flavor, metadata
6. **Art Layer**
   - illustration inside a “file preview / camera feed” window
7. **Backdrop Layer**
   - matte panel + light noise/vignette texture

**Hard Rule:** The rules box must remain clean/quiet. No busy art behind rules text.

## 3) Zones + Layout (Dossier Template)

### A) Top Bar — Title Plate

- **Left:** Card Name
- **Right:** **Cost Chip** (largest single icon on the card)

### B) Art Window — File Preview

- A framed “preview” window for art.
- Allowed overlays (very subtle):
  - gridlines, timestamp, “REC”, crosshair corners, scanline
- **Never** allow overlays to reduce subject readability.

### C) Type Strip (under art)

- Example: `TACTIC — Ambush` / `ENTITY — Rival` / `GEAR — Field Kit`

### D) Rules Box (bottom third)

- Primary effect text
- Keyword chips just above rules box (optional)
- **Rules text should not exceed 6 lines at base size.**

### E) Footer Microtext

- Set code, card ID, “hash”, build tag, artist credit (tiny)
- Example: `PCR1 • MN-024 • HASH: 8F2A • BUILD: A`

## 4) Typography (Readability Rules)

- **Name:** condensed / terminal-ish sans, **22–26px**
- **Rules:** clean sans, **18–20px**, generous line height
- **Microtext:** **11–12px**
- **Do not** use more than 2 font families in v1.

**Hard Rule:** If rules exceed 6 lines, use:
- “Inspect view” expanded text, OR
- “Extended details” panel outside the card (UI), not on-card.

## 5) Icon System (Consistency Lock)

### Style choice (LOCKED)

- **Thin-line technical icons** with slight roughness (dossier vibe)

### Core icon slots

- **Cost** (top-right chip)
- **Faction/Alignment** (top-left stamp)
- **Rarity** (1–3 pips near title or footer)
- **Keywords** (small chips above rules box)

**Hard Rule:** One icon language only. No mixing glyph styles.

## 6) Rarity Language (Readable in Grayscale)

Rarity must be identifiable by **shape + pips**, not only color.

- **Common:** neutral frame, minimal FX, 0–1 pip
- **Uncommon:** subtle accent stripe, **1 pip**
- **Rare:** stronger accent rail + faint glow, **2 pips**
- **Mythic / Corrupted:** distortion motif + “WARNING” stamp, **3 pips**

**Corrupted motif ideas:** corner fractures, misalignment, “data smear” lines (subtle).

## 7) Color + Texture (PC Web Friendly)

### Palette approach

- Dark neutrals + **one accent** (v1 default = **AMBER**)
- Accent used for: pips, small rails, selection brackets, rare glow

### Texture placement rules

Allowed only in:
- frame edges
- footer microtext area
- ultra-light overlay inside art window

**Banned:** heavy grime behind rules text.

## 8) Interaction States (PC-only)

- **Idle:** very subtle scanline/noise (optional)
- **Hover:** gentle tilt + mild glow + border crisping (no large jump)
- **Selected/Targeted:** strong outline + pulsing corner brackets
- **Disabled:** desaturate + `ACCESS REVOKED` stamp
- **New/Upgraded:** quick `FILE UPDATED` flash (200–300ms)

**Hard Rule:** Hover effects must not shift layout or cause reflow.

## 9) Art Direction Rules (So the set stays coherent)

- Art should feel like it was captured, cataloged, or recovered.
- Prefer: dramatic lighting, high contrast subject separation, minimal background clutter.
- If art is busy, apply a UI “matte mask” so text zones stay quiet.

**Art window overlay intensity:** 5–10% max.

## 10) Asset Formats (Neocities constraints)

- **Illustrations:** WebP (high quality, optimized)
- **Frames / stamps / icons:** PNG (transparent)
- **Textures:** WebP or PNG if alpha required

**Target sizes (guideline):**
- Try to keep most assets **< 300–600KB** each.
- Cards can load many at once; keep total page weight reasonable.

## 11) Folder Structure + Naming (LOCKED)

### Suggested structure

- `/assets/cards/art/` (webp)
- `/assets/cards/frame/` (png)
- `/assets/cards/icons/` (png/svg)
- `/assets/cards/textures/` (webp/png)

### Naming convention

- `art_<cardId>_v01.webp`
- `frame_common_v01.png`
- `frame_rare_v01.png`
- `frame_corrupted_v01.png`
- `icon_cost_v01.png`
- `icon_status_<name>_v01.png`

## 12) Starter Asset Pack (Minimum Viable “Looks Real”)

1. **Frames:** common, rare, corrupted (3 PNGs)
2. **Icons:** 8–12 core technical icons (cost + key statuses)
3. **Textures:** 2–3 subtle panel/noise textures
4. **Placeholders:** 6 art placeholders (WebP) to populate the first build

## 13) Locked Decisions Summary

- **Card template:** Dossier/terminal panel + soft physical silhouette
- **Base size:** 420×588 (inspect 630×882)
- **Icon style:** thin-line technical (single language)
- **Rarity system:** pips + shape (grayscale-safe)
- **Accent default:** AMBER (can change later, but v1 uses one accent)
- **Rules readability:** quiet rules box; max 6 lines at base

## 14) Next Implementation Step (Not part of spec; included as a note)

- Produce a pixel-accurate zone map (exact px heights for title/art/type/rules/footer).
- Build the base HTML/CSS card component that supports the layer stack + hover/selected states.
- Generate first-pass frames + icons consistent with the above.

(END — CARD UI SPEC v1 LOCKED)

# Card Library

## Source: CARD_LIBRARY_COMPLETE.md

# COMPLETE CARD LIBRARY - ALL FACTIONS + NEUTRAL

> **Version:** V1 - Production Ready
> **Total Cards:** 63 (45 Faction + 18 Neutral)
> **Design Philosophy:** Every card teaches a lesson, has clear purpose, scales across Acts

## CARD DATABASE STRUCTURE

### Card Attributes:

- **Name:** Card title
- **Cost:** Stamina required (0-4)
- **Type:** Attack / Skill / Power
- **Rarity:** Starter / Common / Rare / Epic / Ultimate
- **Effect:** Mechanical description
- **Faction:** AEGIS / ECLIPSE / SPECTER / Neutral
- **Unlock:** Level requirement or mission milestone
- **Design Note:** Strategic purpose

## FACTION CARDS (45 TOTAL - 15 PER FACTION)

### ⬜ AEGIS CARDS (15) - The Fortress

#### STARTER CARDS (Level 1 - Always Available)

**1. SHIELD BASH**

- Cost: 1
- Type: Attack
- Effect: Deal 5 damage. Gain 3 Armor.
- Rarity: Starter
- Design: Bread and butter. Efficient damage + defense.

**2. BRACE**

- Cost: 1
- Type: Skill
- Effect: Gain 5 Armor.
- Rarity: Starter
- Design: Pure defense. Simple and reliable.

**3. RETALIATE**

- Cost: 2
- Type: Attack
- Effect: Deal 6 damage. If you have 5+ Armor, deal 10 damage instead.
- Rarity: Starter
- Design: Rewards building armor first. Main damage payoff.

#### EARLY UNLOCKS (Levels 2-5)

**4. IRON WILL**

- Cost: 1
- Type: Skill
- Effect: Gain 4 Armor. Draw 1 card.
- Rarity: Common
- Unlock: Level 2
- Design: Armor + card advantage. Key for keeping hand full.

**5. FORTIFY**

- Cost: 2
- Type: Skill
- Effect: Gain 8 Armor.
- Rarity: Common
- Unlock: Level 3
- Design: Big armor spike for Fortress healing (restores 2 HP).

**6. SHIELDWALL**

- Cost: 2
- Type: Skill
- Effect: Gain 6 Armor. Apply Weakened 2 to enemy.
- Rarity: Common
- Unlock: Level 4
- Design: Defense + offense reduction. Core defensive combo.

#### MID UNLOCKS (Levels 6-10)

**7. COUNTER STRIKE**

- Cost: 1
- Type: Attack
- Effect: Deal damage equal to your current Armor (max 12).
- Rarity: Rare
- Unlock: Level 6
- Design: Converts armor into damage. Big scaling potential.

**8. IMMOVABLE**

- Cost: 3
- Type: Skill
- Effect: Gain 12 Armor. Exhaust.
- Rarity: Rare
- Unlock: Level 7
- Design: Huge armor burst once per fight. Restores 3 HP via Fortress.

**9. STAND GROUND**

- Cost: 2
- Type: Skill
- Effect: Gain 5 Armor. Apply Weakened 3 to enemy.
- Rarity: Rare
- Unlock: Level 8
- Design: Upgraded Shieldwall. Neuters enemy damage.

**10. BULWARK**

- Cost: 1
- Type: Skill
- Effect: Gain Armor equal to 50% of your missing HP (max 10).
- Rarity: Rare
- Unlock: Level 9
- Design: Scales when low. Converts danger into defense.

#### LATE UNLOCKS (Levels 11-15)

**11. AEGIS STANCE**

- Cost: 3
- Type: Power
- Effect: For the next 3 turns, gain 3 Armor at start of your turn.
- Rarity: Epic
- Unlock: Level 11
- Design: Passive armor generation. Incredible value over time.

**12. CRUSHING BLOW**

- Cost: 3
- Type: Attack
- Effect: Deal 15 damage. Lose all Armor.
- Rarity: Epic
- Unlock: Level 12
- Design: Big finisher. Spend your armor bank for burst.

**13. UNBREAKABLE**

- Cost: 2
- Type: Skill
- Effect: Double your current Armor (max 20 total).
- Rarity: Epic
- Unlock: Level 13
- Design: Explosive armor scaling. Enables huge Fortress heals (6 HP).

**14. SECOND WIND**

- Cost: 2
- Type: Skill
- Effect: Restore HP equal to your current Armor. Exhaust.
- Rarity: Epic
- Unlock: Level 14
- Design: Emergency heal. Once per fight bailout.

**15. PHALANX**

- Cost: 4
- Type: Skill
- Effect: Gain 15 Armor. Draw 2 cards. Apply Weakened 4 to enemy.
- Rarity: Ultimate
- Unlock: Level 15
- Design: Do everything. Expensive but game-winning.

### 🔴 ECLIPSE CARDS (15) - The Blade

#### STARTER CARDS (Level 1)

**1. SLASH**

- Cost: 1
- Type: Attack
- Effect: Deal 6 damage. Apply Bleeding 1.
- Rarity: Starter
- Design: Basic damage + Bleeding setup.

**2. QUICK STRIKE**

- Cost: 1
- Type: Attack
- Effect: Deal 5 damage.
- Rarity: Starter
- Design: Fast, cheap damage. Filler.

**3. EXECUTION**

- Cost: 2
- Type: Attack
- Effect: Deal 8 damage. If this kills the enemy, draw 1 card.
- Rarity: Starter
- Design: Finisher with card draw reward.

#### EARLY UNLOCKS (Levels 2-5)

**4. LACERATE**

- Cost: 2
- Type: Attack
- Effect: Deal 7 damage. Apply Bleeding 2.
- Rarity: Common
- Unlock: Level 2
- Design: Heavy Bleeding application.

**5. REND**

- Cost: 1
- Type: Attack
- Effect: Deal 4 damage. If enemy has Bleeding, apply Bleeding 2.
- Rarity: Common
- Unlock: Level 3
- Design: Conditional Bleeding stacker.

**6. FLURRY**

- Cost: 2
- Type: Attack
- Effect: Deal 4 damage 3 times.
- Rarity: Common
- Unlock: Level 4
- Design: Multi-hit for status proc. Bypasses some defenses.

#### MID UNLOCKS (Levels 6-10)

**7. VITAL STRIKE**

- Cost: 3
- Type: Attack
- Effect: Deal 12 damage. Apply Bleeding 3.
- Rarity: Rare
- Unlock: Level 6
- Design: Big burst + heavy bleed. Costs more but worth it.

**8. BLOOD FRENZY**

- Cost: 1
- Type: Skill
- Effect: Apply Enraged 2 to yourself. Draw 1 card.
- Rarity: Rare
- Unlock: Level 7
- Design: Self-buff + card advantage. High risk/reward.

**9. EVISCERATE**

- Cost: 2
- Type: Attack
- Effect: Deal damage equal to 2x enemy's Bleeding stacks (max 12).
- Rarity: Rare
- Unlock: Level 8
- Design: Bleeding payoff card. Rewards bleed stacking.

**10. SHADOW STEP**

- Cost: 1
- Type: Attack
- Effect: Deal 5 damage. Remove all Bleeding from enemy, deal damage equal to stacks removed.
- Rarity: Rare
- Unlock: Level 9
- Design: Converts Bleeding into burst. Flexible.

#### LATE UNLOCKS (Levels 11-15)

**11. PREDATOR**

- Cost: 3
- Type: Power
- Effect: For the next 5 turns, gain +2 damage on all Attacks.
- Rarity: Epic
- Unlock: Level 11
- Design: Sustained damage buff. Long-term value.

**12. BERSERKER RAGE**

- Cost: 2
- Type: Skill
- Effect: Apply Enraged 4 to yourself. Deal 12 damage.
- Rarity: Epic
- Unlock: Level 12
- Design: All-in burst. Glass cannon at its finest.

**13. CARVE**

- Cost: 2
- Type: Attack
- Effect: Deal 8 damage. Apply Bleeding 4. Exhaust.
- Rarity: Epic
- Unlock: Level 13
- Design: Bleed bomb. Once per fight.

**14. MASSACRE**

- Cost: 3
- Type: Attack
- Effect: Deal 10 damage to ALL enemies. Apply Bleeding 2 to ALL.
- Rarity: Epic
- Unlock: Level 14
- Design: AoE burst for squad combat.

**15. ASSASSINATE**

- Cost: 4
- Type: Attack
- Effect: Deal 20 damage. If this kills the enemy, restore 10 HP.
- Rarity: Ultimate
- Unlock: Level 15
- Design: Massive nuke. Rewards clean kills.

### 🟣 SPECTER CARDS (15) - The Puppeteer

#### STARTER CARDS (Level 1)

**1. TOXIN DART**

- Cost: 1
- Type: Attack
- Effect: Deal 4 damage. Apply Poison 1.
- Rarity: Starter
- Design: Core card. Chip damage + poison setup.

**2. ENFEEBLE**

- Cost: 1
- Type: Skill
- Effect: Apply Weakened 2 to enemy.
- Rarity: Starter
- Design: Pure disruption. Reduces incoming damage.

**3. STRIKE**

- Cost: 1
- Type: Attack
- Effect: Deal 6 damage.
- Rarity: Starter
- Design: Basic attack. Filler.

#### EARLY UNLOCKS (Levels 2-5)

**4. CORRUPT**

- Cost: 2
- Type: Skill
- Effect: Apply Poison 2. Draw 1 card.
- Rarity: Common
- Unlock: Level 2
- Design: Poison + card advantage.

**5. SIPHON**

- Cost: 2
- Type: Attack
- Effect: Deal 5 damage. If enemy has Poison, restore 3 HP.
- Rarity: Common
- Unlock: Level 3
- Design: Conditional sustain. Rewards poison uptime.

**6. WEAKEN**

- Cost: 1
- Type: Skill
- Effect: Apply Weakened 3 to enemy.
- Rarity: Common
- Unlock: Level 4
- Design: Big offense reduction. Buys time.

#### MID UNLOCKS (Levels 6-10)

**7. PLAGUE TOUCH**

- Cost: 2
- Type: Skill
- Effect: Apply Poison equal to 50% of enemy's current HP (max 6).
- Rarity: Rare
- Unlock: Level 6
- Design: Scales vs high HP. Anti-AEGIS tool.

**8. WITHER**

- Cost: 2
- Type: Skill
- Effect: Apply Weakened 4. Apply Poison 1.
- Rarity: Rare
- Unlock: Level 7
- Design: Double debuff. Control combo.

**9. VIRULENCE**

- Cost: 1
- Type: Skill
- Effect: Double target's Poison stacks (max 8).
- Rarity: Rare
- Unlock: Level 8
- Design: Poison amplifier. Explosive scaling.

**10. DRAIN LIFE**

- Cost: 2
- Type: Attack
- Effect: Deal 6 damage. Restore HP equal to enemy's Poison stacks.
- Rarity: Rare
- Unlock: Level 9
- Design: Sustain payoff. Scales with poison uptime.

#### LATE UNLOCKS (Levels 11-15)

**11. MIASMA CLOUD**

- Cost: 3
- Type: Power
- Effect: For the next 5 turns, apply Poison 1 to enemy at start of your turn.
- Rarity: Epic
- Unlock: Level 11
- Design: Passive poison generation. Stacks with Miasma passive.

**12. NIGHTMARE**

- Cost: 3
- Type: Skill
- Effect: Apply Weakened 6 to enemy. Enemy discards 2 cards. Exhaust.
- Rarity: Epic
- Unlock: Level 12
- Design: Ultimate disruption. Cripples enemy for one fight.

**13. SEPSIS**

- Cost: 4
- Type: Skill
- Effect: Apply Poison 6. At start of each of your turns, enemy takes damage = Poison stacks.
- Rarity: Epic
- Unlock: Level 13
- Design: Miasma amplifier. Win condition card.

**14. PLAGUE BURST**

- Cost: 3
- Type: Attack
- Effect: Deal damage = enemy's Poison x2. Apply Poison 1 to ALL enemies.
- Rarity: Epic
- Unlock: Level 14
- Design: Poison payoff + AoE spread.

**15. DARK RITE**

- Cost: 4
- Type: Skill
- Effect: Double ALL status effects on enemy (Poison, Bleeding, Weakened). Exhaust.
- Rarity: Ultimate
- Unlock: Level 15
- Design: Ultimate multiplier. Combo finisher.

## NEUTRAL CARDS (18 TOTAL)

### STARTER NEUTRAL POOL (5 cards - Available Level 1)

**1. DEFEND**

- Cost: 1
- Type: Skill
- Effect: Gain 5 Armor.
- Rarity: Starter
- Design: Universal defense. Every deck needs this.

**2. FOCUS**

- Cost: 0
- Type: Skill
- Effect: Draw 1 card.
- Rarity: Starter
- Design: Cycle card, zero cost. Never bad.

**3. BANDAGE**

- Cost: 1
- Type: Skill
- Effect: Restore 5 HP.
- Rarity: Starter
- Design: Basic healing. Accessible to all factions.

**4. PREPARE**

- Cost: 0
- Type: Skill
- Effect: Gain +2 Stamina next turn. Exhaust.
- Rarity: Starter
- Design: Resource ramp. Enables big turns.

**5. STRIKE (Neutral)**
- Cost: 1
- Type: Attack
- Effect: Deal 6 damage.
- Rarity: Starter
- Design: Generic damage. Filler.

### COMMON NEUTRAL CARDS (6 cards - Unlocks Levels 2-6)

**6. CLEANSE**

- Cost: 1
- Type: Skill
- Effect: Remove all Bleeding and Poison from yourself.
- Rarity: Common
- Unlock: Level 2
- Design: Counter to DoT effects. Critical vs SPECTER/ECLIPSE.

**7. FORTITUDE**

- Cost: 2
- Type: Skill
- Effect: Gain 4 Armor. Restore 4 HP.
- Rarity: Common
- Unlock: Level 3
- Design: Hybrid defense + sustain.

**8. RALLY**

- Cost: 1
- Type: Skill
- Effect: Draw 2 cards. Discard 1 card.
- Rarity: Common
- Unlock: Level 4
- Design: Card filtering. Dig for answers.

**9. REPOSITION**

- Cost: 0
- Type: Skill
- Effect: Swap positions with another unit in your squad. Gain 2 Armor.
- Rarity: Common
- Unlock: Level 5
- Design: Positioning tool. Protects weak units.

**10. COORDINATED STRIKE**

- Cost: 2
- Type: Attack
- Effect: Deal 5 damage. Another unit in your squad deals 3 damage.
- Rarity: Common
- Unlock: Level 6
- Design: Squad synergy. Multi-unit combo.

**11. SECOND CHANCE**

- Cost: 1
- Type: Skill
- Effect: Return a card from your discard pile to your hand. Exhaust.
- Rarity: Common
- Unlock: Level 6
- Design: Recursion tool. Get back key cards.

### RARE NEUTRAL CARDS (5 cards - Unlocks Levels 7-12)

**12. DESPERATE GAMBIT**

- Cost: 1
- Type: Attack
- Effect: Deal 10 damage. Take 5 damage. Exhaust.
- Rarity: Rare
- Unlock: Level 7
- Design: High-risk finisher. When you need damage NOW.

**13. MASTER'S INSIGHT**

- Cost: 2
- Type: Skill
- Effect: Draw 3 cards. Exhaust.
- Rarity: Rare
- Unlock: Level 8
- Design: Big card advantage burst. Once per fight.

**14. TACTICAL RETREAT**

- Cost: 1
- Type: Skill
- Effect: Gain 8 Armor. Move to back row. Exhaust.
- Rarity: Rare
- Unlock: Level 9
- Design: Emergency defense + repositioning.

**15. VENGEFUL FURY**

- Cost: 2
- Type: Power
- Effect: Whenever you take damage, apply Enraged 1 to yourself (max 5).
- Rarity: Rare
- Unlock: Level 10
- Design: Comeback mechanic. Scales with punishment.

**16. PROTECT ALLY**

- Cost: 1
- Type: Skill
- Effect: Target ally gains 6 Armor. You take the next attack meant for them.
- Rarity: Rare
- Unlock: Level 12
- Design: Squad protection. Tanks can guard squishy allies.

### EPIC NEUTRAL CARDS (2 cards - Unlocks Levels 13-15)

**17. PHOENIX BLESSING**

- Cost: 3
- Type: Skill
- Effect: If you die this combat, revive with 10 HP. Exhaust.
- Rarity: Epic
- Unlock: Level 13
- Design: Insurance policy. High-risk expeditions.

**18. ARMAGEDDON**

- Cost: 4
- Type: Attack
- Effect: Deal 15 damage to ALL units (enemies AND allies).
- Rarity: Epic
- Unlock: Level 14
- Design: Nuclear option. Board wipe with risk.

## STARTING DECK TEMPLATES (10 CARDS EACH)

### AEGIS Starting Deck (Level 1)

```
3x Shield Bash (Starter)
2x Brace (Starter)
1x Retaliate (Starter)
2x Defend (Neutral Starter)
1x Bandage (Neutral Starter)
1x Focus (Neutral Starter)
---
Total: 10 cards
Avg Cost: 1.2 Stamina
Strategy: Stack armor, sustain via Fortress, finish with Retaliate
```

### ECLIPSE Starting Deck (Level 1)

```
3x Slash (Starter)
2x Quick Strike (Starter)
1x Execution (Starter)
2x Defend (Neutral Starter)
1x Prepare (Neutral Starter)
1x Strike (Neutral Starter)
---
Total: 10 cards
Avg Cost: 1.1 Stamina
Strategy: Apply Bleeding, burst with Execution, use Prepare for big turns
```

### SPECTER Starting Deck (Level 1)

```
3x Toxin Dart (Starter)
2x Enfeeble (Starter)
1x Strike (Starter)
2x Defend (Neutral Starter)
1x Bandage (Neutral Starter)
1x Focus (Neutral Starter)
---
Total: 10 cards
Avg Cost: 1.0 Stamina
Strategy: Stack Poison, stall with Enfeeble, let Miasma do the work
```

## CARD UNLOCK PROGRESSION

### Level 1 (Starting):

- All Starter faction cards (3 per faction)
- All Starter neutral cards (5 total)
- **Total Available:** 14 cards

### Level 2-5 (Early Game):

- Unlock 3 Common faction cards per level (12 total)
- Unlock 2 Common neutral cards per level (8 total)
- **Total Available:** 34 cards

### Level 6-10 (Mid Game):

- Unlock 1 Rare faction card per level (15 total)
- Unlock 1 Rare neutral card per level (5 total)
- **Total Available:** 54 cards

### Level 11-15 (Late Game):

- Unlock 1 Epic faction card per level (12 total)
- Unlock 1 Epic neutral card per level (2 total)
- Unlock 1 Ultimate faction card at Level 15 (3 total)
- **Total Available:** 71 cards

## CARD ACQUISITION METHODS

### 1. Level-Up Unlocks

- Automatic at each level
- Adds card to permanent collection
- Can draft into deck at hub

### 2. Mission Rewards

- 1-2 random cards from current Act pool
- Act 1: Common pool
- Act 2: Common + Rare pool
- Act 3: Rare + Epic pool

### 3. Card Draft (Post-Mission)

```
Choose 1 card from 3 options:
- Option A: Random card from your level pool
- Option B: Random card from your level pool
- Option C: Remove 1 card from deck (always available)
```

### 4. Shop (Hub)

```
Card Shop Inventory (3 cards available):
- 1 Common card: 50 gold
- 1 Rare card: 150 gold
- 1 Epic card: 400 gold (Act 3 only)

Refresh cost: 25 gold
```

### 5. Boss Rewards

```
Guaranteed card reward:
- Act 1 Boss: Choose 1 Rare from 3 options
- Act 2 Boss: Choose 1 Epic from 3 options
- Act 3 Boss: Choose 1 Ultimate from 3 options
```

## CARD RARITY DISTRIBUTION

### By Rarity:

- **Starter:** 23 cards (14 faction + 5 neutral + 4 duplicates)
- **Common:** 18 cards (9 faction + 9 neutral)
- **Rare:** 20 cards (15 faction + 5 neutral)
- **Epic:** 14 cards (12 faction + 2 neutral)
- **Ultimate:** 3 cards (3 faction)

**Total Unique Cards:** 63

### By Faction:

- **AEGIS:** 15 cards
- **ECLIPSE:** 15 cards
- **SPECTER:** 15 cards
- **Neutral:** 18 cards

## CARD UPGRADE SYSTEM

### Upgrade Mechanics:

- **How:** Pay gold at Card Shrine (hub)
- **Cost:**
  - Common: 50 gold
  - Rare: 100 gold
  - Epic: 200 gold
  - Ultimate: 300 gold
- **Effect:** Permanent upgrade (all copies in deck)

### Upgrade Examples:

**SHIELD BASH (Upgraded):**
- Cost: 1 → 0
- Effect: Deal 5 → 6 damage. Gain 3 → 4 Armor.

**SLASH (Upgraded):**
- Cost: 1 → 1
- Effect: Deal 6 → 8 damage. Apply Bleeding 1 → 2.

**TOXIN DART (Upgraded):**
- Cost: 1 → 1
- Effect: Deal 4 → 5 damage. Apply Poison 1 → 2.

**PHALANX (Upgraded):**
- Cost: 4 → 3
- Effect: Gain 15 → 18 Armor. Draw 2 cards. Apply Weakened 4 → 5.

## CARD BALANCE VALIDATION

### Cost Distribution (All 63 Cards):

```
0-Cost: 3 cards (4.8%)
1-Cost: 28 cards (44.4%)
2-Cost: 21 cards (33.3%)
3-Cost: 8 cards (12.7%)
4-Cost: 3 cards (4.8%)

Average Cost: 1.6 Stamina
Median Cost: 2 Stamina
```

### Power Budget Check:

**1-Cost Baseline:**
- Deal 6 damage OR Gain 5 Armor OR Apply status 2 stacks

**2-Cost Cards (~2x value):**
- Deal 8 damage + effect OR Gain 8 Armor + effect

**3-Cost Cards (~3x value):**
- Deal 12 damage + effect OR Gain 12 Armor + effect

**4-Cost Ultimates (~5x value):**
- Deal 20 damage OR Game-changing multi-effect

### Faction Balance:

**AEGIS:**

- Avg Card Cost: 1.8 (highest)
- High-impact defensive cards
- Scales into late game

**ECLIPSE:**

- Avg Card Cost: 1.5 (medium)
- Burst damage focus
- Peaks mid-game

**SPECTER:**

- Avg Card Cost: 1.6 (medium)
- Control/setup cards
- Wins long games

**Neutral:**
- Avg Card Cost: 1.4 (lowest)
- Utility/support
- Fills gaps in all decks

## INTEGRATION WITH ENEMY DESIGN

### Counter-play Cards Per Enemy:

**vs Scout (Tutorial):**
- Any basic attack works
- Teaching: Just play cards

**vs Shieldbearer (Tank):**
- Counter Strike, Crushing Blow (armor-stripping)
- Teaching: Don't let tank protect allies

**vs Bloodletter (Bleeding):**
- Cleanse, Bandage, Defend
- Teaching: Manage DoT effects

**vs Toxicant (Poison):**
- Cleanse, Fortitude
- Teaching: Cleanse is critical

**vs Berserker (Enraged):**
- Enfeeble, Weaken (reduce damage output)
- Teaching: Debuff dangerous enemies

**vs Warlock (Support):**
- Execution, Assassinate (focus fire)
- Teaching: Kill supports first

**vs Assassin (Elite Burst):**
- Defend, Tactical Retreat, Phoenix Blessing
- Teaching: Keep HP high or die

**vs Shade (Elite Control):**
- Cleanse, Master's Insight (card advantage)
- Teaching: Cleanse spam required

**vs Boss (Multi-phase):**
- All tools required
- Teaching: Deck diversity matters

## DECK BUILDING STRATEGY EXAMPLES

### "FORTRESS WALL" (AEGIS - Pure Tank)

```
Core Cards:
- 3x Fortify (big Armor bursts)
- 2x Immovable (once-per-fight spike)
- 2x Counter Strike (Armor → damage conversion)
- 2x Unbreakable (Armor doubling)
- 1x Phalanx (ultimate)

Support Cards:
- 2x Iron Will (card draw)
- 2x Defend (generic Armor)
- 1x Second Wind (emergency heal)
- 1x Cleanse (anti-DoT)

Strategy: Stack Armor to 15-20, heal via Fortress, nuke with Counter Strike
```

### "BLOOD FRENZY" (ECLIPSE - Hyper Aggro)

```
Core Cards:
- 3x Slash (Bleeding setup)
- 2x Lacerate (heavy Bleeding)
- 2x Eviscerate (Bleeding payoff)
- 2x Berserker Rage (self-buff + burst)
- 1x Assassinate (finisher)

Support Cards:
- 3x Quick Strike (cheap damage)
- 2x Blood Frenzy (card draw + Enraged)
- 1x Desperate Gambit (emergency burst)
- 1x Bandage (tiny sustain)

Strategy: Stack Bleeding fast, go Enraged, nuke before enemy recovers
```

### "PLAGUE DOCTOR" (SPECTER - Control Lock)

```
Core Cards:
- 3x Toxin Dart (Poison setup)
- 2x Plague Touch (scaling Poison)
- 2x Virulence (Poison doubling)
- 2x Weaken (damage reduction)
- 1x Sepsis (win condition)

Support Cards:
- 2x Corrupt (Poison + card draw)
- 2x Drain Life (sustain)
- 2x Defend (stall)
- 1x Nightmare (ultimate disruption)

Strategy: Stack Poison to 6+, stall with Weakened, let Miasma + Sepsis win
```

**STATUS: ✅ LOCKED - READY FOR IMPLEMENTATION**

**Next Step:** Define Economy/Shop System (gold costs, unlock progression)
**After That:** Create UI/UX Mockups (screen layouts)
**Then:** Begin HTML/CSS/JS Implementation

**All 63 cards complete!**
**Total:** 45 Faction + 18 Neutral = Production-ready card library
**Starting Decks:** 3 templates (10 cards each, tested and balanced)
**Unlock Progression:** Level 1-15 with clear milestones

# Core Combat System

## Source: COMBAT_SYSTEM_LOCKED_V1.md

# COMBAT SYSTEM - LOCKED FOR PRODUCTION (V1)

> **Status:** ✅ LOCKED - Ready for implementation
> **Version:** 1.0 Final
> **Last Updated:** Current Session
> **Dependencies:** Factions (locked), Status Effects (locked)

## 🎯 DESIGN PHILOSOPHY

**Core Principles:**
1. **Immediate resolution** - No stack, no response window (simpler than MTG)
2. **Predictable timing** - Effects always happen in the same order
3. **Strategic depth** - Resource management + status exploitation
4. **Fair challenge** - Clear telegraphing, no hidden information
5. **Faction identity** - Each faction plays distinctly different

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

#### 1C. Status Effect Updates:

- Duration-based effects are still active (Weakened, Enraged)
- No decay yet (decay happens end of turn)

### Phase 2: MAIN PHASE (Play Cards & Abilities)

#### 2A. Actions Available:

1. **Play cards from hand** (costs Stamina)
2. **Use hero abilities** (costs Mana)
3. **Use combat items** (1 per turn, free action) ✅ LOCKED
4. **Pass turn** (end turn voluntarily)

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

## 🎴 DECK MECHANICS

### Deck Structure (Three Piles During Combat)

1. **Draw Deck:** Cards you'll draw from
2. **Discard Pile:** Cards you've played (goes here after use)
3. **Exhaust Pile:** Cards removed from combat (doesn't shuffle back)

### Draw Rules

**Starting hand:** 5 cards (drawn at combat start) ✅ LOCKED
**Per turn:** Draw 1 card at start of turn
**Additional draws:** Some cards/abilities say "Draw X cards" (resolved immediately)

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

### Hand Limit

**Max hand size:** 8 cards
At end of turn, discard down to 8 if over (you choose which to discard)

**With gear/upgrades:** May increase to 10 cards (endgame upgrade)

### Deck Size During Combat

- Deck size can shrink (cards Exhausted)
- Deck size does NOT grow during combat (no "add card to deck" effects in V1)
- Minimum deck size: 0 (you can exhaust all cards if needed)

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

## 🎯 COMBAT FLOW SUMMARY (QUICK REFERENCE)

### One Complete Turn:

START OF TURN:

═══════════════════════════════════════════
1. DoT damage (Bleeding, Poison) → Death check
2. SPECTER Miasma trigger (if applicable)
3. Gain Stamina (+3 base)
4. Gain Mana (+1 base)
5. Draw 1 card

MAIN PHASE:

═══════════════════════════════════════════
6. Play cards (spend Stamina)
7. Use abilities (spend Mana)
8. Use 1 combat item (free, optional)
9. Gain Mana (+1 per card played, +1 per 5 damage taken)
10. Effects resolve immediately (damage, status, armor, etc.)

END OF TURN:

═══════════════════════════════════════════
11. Weakened/Enraged duration -1
12. Discard down to 8 cards (if over)
13. Lose unused Stamina
14. Armor persists (doesn't decay)
15. Pass turn to opponent
```

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

## 🎮 FULL COMBAT EXAMPLE

**Setup:**
- **Player:** AEGIS (30 HP, 5 Armor, Speed 2)
- **Enemy:** ECLIPSE (20 HP, 0 Armor, Speed 5)
- Turn 1

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

**Combat continues...**

**Document Status:** ✅ LOCKED FOR PRODUCTION
**Ready for:** Implementation, Combat Simulator, Playtesting
**Version:** 1.0 Final - Core rules complete

**Next Design Step:** Lock progression system (card unlocks, stat growth) OR build combat simulator

**Deferred Decisions:** Card upgrade costs (will be decided in progression phase)

## Source: combat_system_complete.md

# Combat System Rules - Complete Design

> **Version:** V1 Locked
> **Dependencies:** Factions (locked), Status Effects (locked), Resources (pinned for later)

## Overview

This document defines the complete combat loop, turn structure, damage calculation, deck mechanics, and all timing rules for the gladiator card game.

## Pre-Combat Setup

### Deck Composition

**Starting Deck (Level 1):**
- 10 cards total
- Composition varies by faction (suggested):
  - 5x Basic Attack (faction-specific Strike variant)
  - 3x Faction Starter Cards (the 3 cards marked "Level 1" in faction design)
  - 2x Defend/Block cards (generic or faction-flavored)

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

## Turn Structure (Detailed)

### Phase 1: START OF TURN

#### 1A. Determine Turn Order (First Turn Only)

#### 1B. Start of Turn Triggers (in this order):

2. **Faction passive triggers:**
   - **SPECTER Miasma:** If acting character is SPECTER AND enemy has Poison, apply +1 Poison to enemy
   - **AEGIS Fortress:** Passive (no start-of-turn trigger)
   - **ECLIPSE Bloodlust:** Passive (no start-of-turn trigger)

#### 1C. Status Effect Updates:

### Phase 2: MAIN PHASE (Play Cards & Abilities)

#### 2A. Actions Available:

1. **Play cards from hand** (costs Stamina)
2. **Use hero abilities** (costs Mana)
3. **Pass turn** (end turn voluntarily)

#### 2B. Card Playing Rules:

#### 2C. Ability Using Rules:

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

### Phase 3: END OF TURN

#### 3A. Duration-based Status Effects Decay:

#### 3B. Hand Limit:

#### 3C. Stamina Reset:

#### 3D. Armor Persistence:

#### 3E. Turn Passes:

## Damage Calculation (Detailed)

### Base Damage Formula:

```
Final Damage = Base Damage × Modifiers - Armor
(Minimum 0 damage)
```

### Step-by-Step Calculation:

#### Step 1: Determine Base Damage

#### Step 2: Apply Offensive Modifiers (Multiplicative)

**ECLIPSE Bloodlust (target has Bleeding or Poison):**
- Add +2 damage (flat bonus, applied after multipliers)

**Rounding:**
- Round DOWN after all multipliers applied

#### Step 3: Apply Armor (Defender)

#### Step 4: Apply Defensive Modifiers (if defender has Enraged)

**Rounding:**
- Round DOWN

#### Step 5: Subtract from HP

- Final damage is subtracted from defender's HP
- If HP reaches 0 or below, defender is Downed

### Damage Calculation Examples:

#### Example 1: Simple Attack

```
Base Damage: 6
Modifiers: None
Armor: 8
Final Damage to HP: 0 (6 - 8 = -2, minimum 0)
Armor remaining: 2 (8 - 6 = 2)
```

#### Example 2: Enraged Attacker

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

## Win/Loss Conditions

### Victory Conditions

### Defeat Conditions

2. **Deck out** (optional rule - not in V1):
   - If you need to draw but deck AND discard are empty
   - Take damage each turn until you die
   - (V1: This shouldn't happen - Exhaust is limited)

### Tie Condition

## Special Combat Rules

### Speed Advantage

### Resource Limits

- **Stamina cap per turn:** 6 (can't exceed, even with boosts)
- **Mana cap total:** 12 (or 15 with endgame upgrade)
- **Hand size cap:** 8 cards (10 with gear)

### Status Effect Caps

### Death Checks

- **Checked immediately** after any damage instance
- If HP ≤ 0, combat ends (no more actions)

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

## Combat Flow Summary (Quick Reference)

### One Complete Turn:

6. Play cards (spend Stamina)
7. Use abilities (spend Mana)
8. Gain Mana (+1 per card played, +1 per 5 damage taken)
9. Effects resolve immediately (damage, status, armor, etc.)

10. Weakened/Enraged duration -1
11. Discard down to 8 cards (if over)
12. Lose unused Stamina
13. Armor persists (doesn't decay)
14. Pass turn to opponent
```

## Combat Example (Full Turn Walkthrough)

### ECLIPSE Turn (goes first, Speed 5 > 2):

### AEGIS Turn:

**End of Turn:**
- No duration effects to decay
- Hand size: 4 cards (under 8)
- Stamina: 0 remaining (lost)
- Armor: 11 (persists)
- Pass to ECLIPSE

## Open Questions for You:

1. **Starting hand size:** 5 cards feels right, or should it be 6?

2. **Item usage limit:** One item per turn, or unlimited items?

3. **Deck out rule:** Should running out of cards cause damage, or just keep shuffling forever? (V1 recommendation: infinite shuffle, no deck-out damage)

4. **Multi-target attacks:** Should some cards hit both you and enemy? (e.g., "Deal 10 damage to enemy, take 3 damage")

5. **Card upgrade costs:** Should upgrades be permanent (pay once, upgraded forever) or per-copy (upgrade each copy separately)?

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

**Document Status:** ✅ READY TO LOCK
**Next Step:** Lock gear system (20-24 pieces with synergies)
**After That:** Build combat simulator to validate balance

# Status Effects

## Source: STATUS_EFFECTS_LOCKED_V1.md

# STATUS EFFECTS - LOCKED FOR PRODUCTION (V1)

> **Status:** ✅ LOCKED - Ready for implementation
> **Version:** 1.0 Final
> **Last Updated:** Current Session
> **Dependencies:** Factions (locked), Combat System (in progress)

## 🎯 DESIGN PHILOSOPHY

1. **Clear timing** - All effects trigger at specific, predictable moments
2. **Meaningful stacking** - Rewards building up status effects over time
3. **Hard caps** - Prevents broken infinite scaling
4. **Counterplay** - Each faction has strengths/weaknesses vs specific statuses
5. **DoTs ignore Armor** - Creates strategic diversity, counters pure tank builds

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

### 2. ARMOR (Damage Reduction - Persistent)

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

### 3. WEAKENED (Damage Reduction - Duration)

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

### 4. ENRAGED (Damage Boost + Risk - Duration)

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

### 5. POISON (Damage over Time - Scaling)

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

## 🛡️ STATUS EFFECT CAPS (HARD LIMITS)

| Status Effect | Max Value | Reason |
|---------------|-----------|--------|
| **Bleeding** | 12 stacks | 78 total damage (lethal to anyone), prevents instant kills |
| **Armor** | 30 stacks | Prevents unkillable AEGIS, 30 = 6+ hits to break |
| **Weakened** | 10 turns | Long enough to matter, always -25% regardless |
| **Enraged** | 8 turns | Risky to maintain, +50% is huge, prevents perma-Enrage |
| **Poison** | 12 stacks | With Miasma, reaches lethal quickly, 12 is exponential |

**Technical Implementation:** Cap at 999 internally (like Slay the Spire), but gameplay balance enforces lower caps shown above.

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

### ECLIPSE (Assassin)

**Masters:**
- Bleeding (applies and exploits with Bloodlust)
- Enraged (risk/reward for massive burst)

**Resists:**
- Poison (kills enemy before it scales)

**Vulnerable:**
- Armor (reduces burst effectiveness)
- Weakened (entire gameplan crippled)

### SPECTER (Control)

**Masters:**
- Poison (exponential Miasma scaling)
- Weakened (enables stalling)

**Resists:**
- Enraged (control + Weakened counters burst)

**Vulnerable:**
- Bleeding (no native healing)
- Burst damage (dies before Poison scales)

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

## 🔒 PRODUCTION LOCK STATUS

**✅ ALL NUMBERS LOCKED FOR V1**

**Locked Decisions:**
- Bleeding: 1 damage/stack, decays by 1
- Armor: Cap 30, blocks before HP
- Weakened: -25% damage, duration stacking
- Enraged: +50% dealt / +25% taken, duration stacking
- Poison: 1 damage/stack, no decay, Miasma +1/turn

**Next Design Step:** Lock combat system rules (turn order, damage calculation, resource system)

**Next Implementation Step:** Code status effects into combat engine

**Document Status:** ✅ LOCKED FOR PRODUCTION
**Ready for:** Implementation, Combat Simulator, Balance Testing
**Version:** 1.0 Final - Do Not Modify

## Source: status_effects_complete.md

# Status Effects System - Complete Design

> **Based on research:** Slay the Spire, Monster Train, Darkest Dungeon
> **Status:** Ready to lock after review

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

## Our 5 Status Effects (Locked)

### Design Principles:

1. **Clear timing** - all effects trigger at specific moments
2. **Meaningful stacking** - can stack intensity OR duration depending on effect
3. **Hard caps** - prevents broken combos
4. **Counterplay** - faction strengths/weaknesses create rock-paper-scissors
5. **Ignores armor** - DoTs go straight to HP (balances vs AEGIS)

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

## Status Effect Caps (Hard Limits)

| Status Effect | Max Stacks/Duration | Why This Cap? |
|---------------|---------------------|---------------|
| **Bleeding** | 12 stacks | Prevents instant kills; 12→11→...→1 = 78 total damage (lethal to anyone) |
| **Armor** | 30 stacks | Prevents unkillable AEGIS; 30 armor = 6+ hits to break through |
| **Weakened** | 10 turns | Long enough to matter, short enough to expire; 25% reduction regardless |
| **Enraged** | 8 turns | Risky to maintain; +50% damage is huge; capped so you can't perma-Enrage |
| **Poison** | 12 stacks | With Miasma, 12 Poison → 13→14→15 per turn = exponential; 12 is lethal |

**All caps = 999 internally for technical reasons** (like Slay the Spire), but balanced gameplay caps are much lower.

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

### ECLIPSE

**Masters:**
- **Bleeding:** Applies and exploits with Bloodlust
- **Enraged:** Risk/reward for massive burst windows

**Resists:**
- **Poison:** Kills enemies before it scales

**Vulnerable to:**
- **Armor:** Reduces burst damage effectiveness
- **Weakened:** Cripples entire damage output

### SPECTER

**Masters:**
- **Poison:** Exponential scaling with Miasma
- **Weakened:** Enables stalling for Poison to scale

**Resists:**
- **Enraged:** Control tools + Weakened counter burst

**Vulnerable to:**
- **Bleeding:** Lacks sustain to heal through it
- **Burst damage:** Dies before Poison scales

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

## Open Questions for You:

1. **Bleeding damage per stack:** Should base Bleeding do 1 damage/stack or scale with level? (Recommendation: flat 1 damage - simple)

2. **Armor cap:** Is 30 too high or too low? (Recommendation: 30 is good - 30 damage absorbed is significant)

3. **Weakened percentage:** 25% feels right, but should it be 30% for more impact?

4. **Enraged numbers:** +50% damage dealt / +25% damage taken - good balance or adjust?

5. **Poison with Miasma:** Is +1 Poison/turn too slow or too fast? (Recommendation: +1 is exponential enough)

6. **Cleanse mechanics:** Should there be in-combat cleanse cards, or only hub/items?

**Document Status:** ✅ READY FOR LOCK
**Next Step:** Lock combat system rules (turn order, damage calc)
**After That:** Design gear system with status synergies

# Economy & Shop

## Source: ECONOMY_SHOP_SYSTEM_COMPLETE.md

# ECONOMY & SHOP SYSTEM - COMPLETE DESIGN

> **Version:** V1 - Production Ready
> **Design Philosophy:** Player is slightly gold-starved, choices matter, no grinding required
> **Balance Target:** ~1500 gold earned across full campaign, ~1800 gold total spending available

## CORE ECONOMIC PRINCIPLES

### 1. Scarcity Creates Choices

- Player cannot afford everything
- Must prioritize: healing vs upgrades vs gear vs cards
- Early game: tight economy (forces careful play)
- Late game: more generous (enables build completion)

### 2. No Grinding Required

- Fixed mission count (~15 main missions)
- Linear progression (can't replay missions for gold farming)
- Economy balanced for single playthrough
- Gold comes from mission rewards, not grinding

### 3. Multiple Spending Paths

Players spend gold on:
- **Healing:** Treat injuries between missions
- **Gear:** Purchase missing gear pieces
- **Cards:** Buy specific cards from shop
- **Upgrades:** Upgrade cards permanently
- **Services:** Cleanse, remove cards, rest units

### 4. RNG Mitigation

- Bad gear drops? Buy from shop
- Bad card unlocks? Purchase from shop
- Shop rerolls available for small fee

## GOLD INCOME (BY SOURCE)

### Mission Completion Rewards

#### Act 1 (Missions 1-5):

```
Mission 1 (Tutorial): 40 gold
Mission 2: 60 gold
Mission 3: 70 gold
Mission 4: 80 gold
Mission 5 (Boss): 100 gold

Act 1 Total: 350 gold
```

#### Act 2 (Missions 6-10):

```
Mission 6: 100 gold
Mission 7: 110 gold
Mission 8: 120 gold
Mission 9: 130 gold
Mission 10 (Boss): 150 gold

Act 2 Total: 610 gold
```

#### Act 3 (Missions 11-15):

```
Mission 11: 140 gold
Mission 12: 150 gold
Mission 13: 160 gold
Mission 14: 170 gold
Mission 15 (Final Boss): 200 gold

Act 3 Total: 820 gold
```

**Total Campaign Income:** 1,780 gold

### Wave Completion Bonuses

Each expedition has 6 waves. Small bonus per wave cleared:

```
Wave 1: +5 gold
Wave 2: +5 gold
Wave 3: +8 gold
Wave 4: +8 gold
Wave 5: +10 gold
Wave 6 (Boss): +15 gold

Per Mission: +51 gold
x15 missions = +765 gold
```

**Total from Wave Bonuses:** 765 gold

### Enemy Kills (Loot Drops)

Based on enemy design:
```
Common enemies: 10-15 gold each
Tactical enemies: 20-30 gold each
Elite enemies: 40-60 gold each
Bosses: 60-100 gold each

Average per mission: ~80 gold from kills
x15 missions = 1,200 gold
```

**Total from Enemy Loot:** 1,200 gold

### TOTAL GOLD INCOME (Full Campaign)

```
Mission Completion: 1,780 gold
Wave Bonuses: 765 gold
Enemy Loot: 1,200 gold

TOTAL EARNED: 3,745 gold
```

**This is your economic ceiling.**

## GOLD EXPENDITURE (SINKS)

### 1. Healing Services (Hub - Doctor)

#### Minor Injury Healing:

```
Triage (Natural Healing - Free):
- Cost: 0 gold
- Effect: Unit sits out 1 mission, injury heals after
- Use Case: When you have spare roster slots

Standard Treatment:
- Cost: 30 gold
- Effect: Instant heal, unit ready immediately
- Use Case: Need unit for next mission

Expected Usage: ~10 minor injuries across campaign
Average Spend: ~200 gold (if paying for instant healing)
```

#### Serious Injury Healing:

```
Field Surgery:
- Cost: 80 gold
- Effect: Reduces Serious → Minor (still needs 1 more treatment)
- Use Case: Emergency downgrade

Full Treatment:
- Cost: 150 gold
- Effect: Instant full heal
- Use Case: Critical unit, urgent need

Expected Usage: ~3-5 serious injuries across campaign
Average Spend: ~300-450 gold
```

#### Grave Injury / Permanent Scars:

```
Advanced Restoration:
- Cost: 300 gold
- Effect: Remove permanent scar (risky procedure)
- Success Rate: 70% (30% chance scar remains)
- Use Case: Endgame only, fix veteran units

Expected Usage: 0-2 across campaign
Average Spend: 0-600 gold (if unlucky)
```

**Total Healing Budget:** 500-1,250 gold (depends on player skill)

### 2. Gear Purchases (Hub - Market)

#### Common Gear:

```
Weapons: 80 gold
Armors: 80 gold
Accessories: 60 gold

Use Case: Fill gaps in early game RNG drops
Expected Purchases: 2-3 pieces
Average Spend: ~200 gold
```

#### Rare Gear:

```
Weapons: 300 gold
Armors: 300 gold
Accessories: 250 gold

Use Case: Enable specific builds mid-game
Expected Purchases: 1-2 pieces
Average Spend: ~300-600 gold
```

#### Epic Gear:

```
Weapons: 1,000 gold
Armors: 1,200 gold
Accessories: 900 gold

Use Case: Build-defining pieces if boss RNG fails
Expected Purchases: 0-1 piece (bosses usually drop these)
Average Spend: 0-1,000 gold
```

**Total Gear Budget:** 500-1,800 gold (varies wildly by RNG)

### 3. Card Purchases (Hub - Card Vendor)

#### Shop Inventory (Refreshes Each Visit):

```
3 cards available:
- 1 Common card: 50 gold
- 1 Rare card: 150 gold
- 1 Epic card: 400 gold (unlocks Act 3)

Refresh Shop:
- Cost: 25 gold
- Effect: Reroll all 3 cards
- Use Case: Looking for specific card
```

**Expected Card Purchases:**
```
Act 1: 1-2 Common cards = 50-100 gold
Act 2: 1-2 Rare cards = 150-300 gold
Act 3: 0-1 Epic card = 0-400 gold (usually unlocked via level-up)

Total: 200-800 gold
```

### 4. Card Upgrades (Hub - Card Shrine)

#### Upgrade Costs (Per Card):

```
Common card upgrade: 50 gold
Rare card upgrade: 100 gold
Epic card upgrade: 200 gold
Ultimate card upgrade: 300 gold
```

#### Upgrade Effects:

```
Typical upgrade paths:

Shield Bash → Shield Bash+
- Cost: 50 gold
- Before: Deal 5 damage, Gain 3 Armor (1 Stamina)
- After: Deal 6 damage, Gain 4 Armor (1 Stamina)

Slash → Slash+
- Cost: 50 gold
- Before: Deal 6 damage, Apply Bleeding 1 (1 Stamina)
- After: Deal 8 damage, Apply Bleeding 2 (1 Stamina)

Phalanx → Phalanx+
- Cost: 200 gold
- Before: Gain 15 Armor, Draw 2, Weakened 4 (4 Stamina)
- After: Gain 18 Armor, Draw 2, Weakened 5 (3 Stamina)
```

**Expected Upgrade Spending:**
```
Early game: Upgrade 2-3 starter cards = 100-150 gold
Mid game: Upgrade 2-3 core cards = 150-300 gold
Late game: Upgrade 1-2 finishers = 200-400 gold

Total: 450-850 gold
```

### 5. Utility Services (Hub)

#### Card Removal Service:

```
Cost: 50 gold per card
Effect: Permanently remove card from deck (deck thinning)
Use Case: Remove starter cards, optimize deck

Expected Usage: 3-5 removals
Total: 150-250 gold
```

#### Cleanse Status Service:

```
Cost: 20 gold
Effect: Remove all status effects from all units
Use Case: Pre-mission prep if entering with DoTs

Expected Usage: 2-4 times
Total: 40-80 gold
```

#### Rest & Recovery (Stress Relief - Story System):

```
Cost: Free (but costs time)
Effect: -3 Stress per unit, minor HP restoration
Penalty: Skip 1 contract opportunity

Use Case: Manage companion stress levels
Expected Usage: Situational (story-driven)
```

### TOTAL EXPENDITURE BUDGET

ESSENTIAL SPENDING:

- Healing (skill-dependent): 500-1,250 gold
- Total: 500-1,250 gold

OPTIONAL SPENDING (Choose Wisely):
- Gear purchases: 500-1,800 gold
- Card purchases: 200-800 gold
- Card upgrades: 450-850 gold
- Card removal: 150-250 gold
- Utility services: 40-80 gold

TOTAL AVAILABLE SINKS: 2,340-5,030 gold
```

**Player earns: 3,745 gold**
**Player can spend: Up to 5,030 gold (if they want everything)**

**DEFICIT: ~1,285 gold** → **Player must make choices!**

## ECONOMIC BALANCE VALIDATION

### Early Game (Missions 1-5):

```
Income: 350 (missions) + 255 (waves) + 400 (kills) = 1,005 gold
Expected Spending: 200-400 gold (minor healing, 1-2 Common gear, 1-2 card upgrades)

Result: Player accumulates 600-800 gold buffer
Strategy: Conservative spending, build foundation
```

### Mid Game (Missions 6-10):

```
Income: 610 (missions) + 255 (waves) + 400 (kills) = 1,265 gold
Expected Spending: 400-800 gold (Rare gear, card upgrades, healing)

Result: Player spends most income, buffer holds ~600 gold
Strategy: Build-enabling purchases, prioritize synergies
```

### Late Game (Missions 11-15):

```
Income: 820 (missions) + 255 (waves) + 400 (kills) = 1,475 gold
Expected Spending: 600-1,200 gold (Epic gear if needed, final upgrades, serious injury healing)

Result: Player finishes campaign with 500-1,000 gold surplus
Strategy: Complete build, prepare for finale
```

## SHOP MECHANICS

### 1. Card Vendor (Hub)

**Inventory Generation:**
```javascript
function generateCardShop(playerLevel, actNumber) {
  const shop = []

// Slot 1: Common card (always available)
  const commonPool = getAllCommonCards(playerLevel)
  shop.push({
    card: randomFrom(commonPool),
    price: 50,
    rarity: 'Common'
  })

// Slot 2: Rare card (Act 2+)
  if (actNumber >= 2) {
    const rarePool = getAllRareCards(playerLevel)
    shop.push({
      card: randomFrom(rarePool),
      price: 150,
      rarity: 'Rare'
    })
  }

// Slot 3: Epic card (Act 3 only)
  if (actNumber >= 3) {
    const epicPool = getAllEpicCards(playerLevel)
    shop.push({
      card: randomFrom(epicPool),
      price: 400,
      rarity: 'Epic'
    })
  }

return shop
}
```

**Refresh Mechanic:**
```
Cost: 25 gold
Effect: Reroll all shop slots (new cards)
Limit: Unlimited refreshes (but costs add up)
Strategy: Fishing for specific card costs 50-100 gold on average
```

### 2. Market (Gear Vendor)

**Inventory Generation:**
```javascript
function generateMarket(actNumber) {
  const market = []

// Always show 2 Common pieces
  market.push(randomCommonWeapon(), randomCommonArmor())

// Act 2+: Add 1 Rare piece
  if (actNumber >= 2) {
    market.push(randomRarePiece())
  }

// Act 3: Add 1 Epic piece
  if (actNumber >= 3) {
    market.push(randomEpicPiece())
  }

return market
}
```

**Pricing:**
```
Common: 60-80 gold (avg 70)
Rare: 250-350 gold (avg 300)
Epic: 900-1,200 gold (avg 1,050)
```

**No Refresh:** Market inventory changes only after completing a mission

### 3. Doctor (Healing Services)

**Always Available:**
```
Triage (Free): Natural healing, 1 mission wait
Standard Treatment (30g): Instant minor injury heal
Field Surgery (80g): Serious → Minor
Full Treatment (150g): Serious → Healed
Advanced Restoration (300g): Remove Permanent Scar (70% success)
```

**Unlock Progression:**
```
Level 1-5: Only Triage + Standard Treatment available
Level 6-10: Field Surgery unlocks
Level 11+: Full Treatment + Advanced Restoration unlock
```

### 4. Card Shrine (Upgrade Services)

**Always Available (Post-Mission 3):**
```
Select card from deck → Pay gold → Card permanently upgraded

Upgrade costs scale by rarity:
- Common: 50 gold
- Rare: 100 gold
- Epic: 200 gold
- Ultimate: 300 gold
```

**Upgrade Benefits:**
```
Typical upgrades:
- +1-2 damage
- +1-2 Armor
- +1 status effect stack
- -1 Stamina cost (for expensive cards)
- Draw +1 card (added effect)

Upgrades apply to ALL copies in deck
Can upgrade same card multiple times (+ → ++ → +++)
```

## UNLOCK PROGRESSION (WHAT UNLOCKS WHEN)

### Level-Based Unlocks:

**Level 1 (Start):**
- Triage healing (free)
- Standard Treatment (30g)
- Market (Common gear only)

**Level 3:**
- Card Shrine unlocks (upgrade cards)
- Card Vendor unlocks (buy cards)

**Level 5:**
- Card Removal service (50g)

**Level 6:**
- Market expands (Rare gear available)
- Field Surgery (80g)

**Level 10:**
- Full Treatment (150g)

**Level 11:**
- Market expands (Epic gear available)
- Advanced Restoration (300g)

### Act-Based Unlocks:

**Act 1 (Missions 1-5):**
- Card Vendor: Common cards only (50g)
- Market: Common gear only (60-80g)

**Act 2 (Missions 6-10):**
- Card Vendor: Common + Rare cards (50g, 150g)
- Market: Common + Rare gear (60-350g)

**Act 3 (Missions 11-15):**
- Card Vendor: Common + Rare + Epic cards (50g, 150g, 400g)
- Market: Common + Rare + Epic gear (60-1,200g)

## GOLD REWARDS BY MISSION (COMPLETE TABLE)

| Mission | Completion | Waves | Kills | Total |
|---------|-----------|-------|-------|-------|
| 1 (Tutorial) | 40 | 30 | 30 | 100 |
| 2 | 60 | 51 | 60 | 171 |
| 3 | 70 | 51 | 70 | 191 |
| 4 | 80 | 51 | 80 | 211 |
| 5 (Boss) | 100 | 51 | 120 | 271 |
| **Act 1 Total** | **350** | **234** | **360** | **944** |
| 6 | 100 | 51 | 90 | 241 |
| 7 | 110 | 51 | 90 | 251 |
| 8 | 120 | 51 | 90 | 261 |
| 9 | 130 | 51 | 90 | 271 |
| 10 (Boss) | 150 | 51 | 150 | 351 |
| **Act 2 Total** | **610** | **255** | **510** | **1,375** |
| 11 | 140 | 51 | 100 | 291 |
| 12 | 150 | 51 | 100 | 301 |
| 13 | 160 | 51 | 100 | 311 |
| 14 | 170 | 51 | 100 | 321 |
| 15 (Final) | 200 | 51 | 130 | 381 |
| **Act 3 Total** | **820** | **255** | **530** | **1,605** |

| **CAMPAIGN TOTAL** | **1,780** | **744** | **1,400** | **3,924** |

**Updated Total Income: 3,924 gold**

## PRICING PHILOSOPHY

### Why These Prices?

**Healing Costs (30-300g):**
- Early injuries cheap (30g) → encourages not letting units sit out
- Serious injuries expensive (150g) → penalty for poor play
- Permanent scars very expensive (300g) → rare, endgame only

**Gear Costs (60-1,200g):**
- Commons cheap (60-80g) → accessible even if RNG fails
- Rares moderate (250-350g) → significant investment
- Epics expensive (900-1,200g) → usually obtained via boss drops, shop is backup

**Card Costs (50-400g):**
- Commons cheap (50g) → deck filler accessible
- Rares moderate (150g) → build-enabling
- Epics expensive (400g) → usually unlocked via level-up, shop is backup

**Upgrade Costs (50-300g):**
- Tied to rarity (50/100/200/300)
- Upgrading full deck = 500-1,000g investment
- Forces prioritization (upgrade 5-6 core cards, not all 20)

## PLAYER SPENDING ARCHETYPES

### "Safe Player" (Conservative):

```
Priorities:
1. Healing (500g) - Never let injuries escalate
2. Card upgrades (300g) - Upgrade 3-4 core cards
3. 1 Rare gear purchase (300g) - Fill critical gap

Total: ~1,100 gold
Surplus: ~2,800 gold (unspent, could've done more)
```

### "Optimized Player" (Balanced):

```
Priorities:
1. Selective healing (300g) - Use free Triage when possible
2. Card upgrades (600g) - Upgrade 6-7 key cards
3. 2 Rare gear purchases (600g) - Complete build
4. Card removal (150g) - Thin deck

Total: ~1,650 gold
Surplus: ~2,300 gold (efficient spending)
```

### "Aggressive Player" (Risk-Taker):

```
Priorities:
1. Minimal healing (200g) - Only emergencies, accepts injuries
2. Heavy upgrades (850g) - Upgrade 8-10 cards
3. Epic gear purchase (1,000g) - Chase build-defining piece
4. Card purchases (300g) - Buy specific cards

Total: ~2,350 gold
Surplus: ~1,600 gold (ambitious build completion)
```

### "Unlucky Player" (RNG Victim):

```
Forced Spending:
1. Heavy healing (1,000g) - Multiple serious injuries
2. Gear purchases (1,500g) - Bad boss RNG, must buy gear
3. Minimal upgrades (200g) - Can't afford more

Total: ~2,700 gold
Surplus: ~1,200 gold (tight budget, limited build options)
```

## ECONOMIC DIFFICULTY MODIFIERS (Optional V2)

### Easy Mode:

- +50% gold rewards
- Healing costs -50%
- More forgiving economy

### Normal Mode:

- Default values (as designed above)

### Hard Mode:

- -25% gold rewards
- Healing costs +50%
- Forces perfect play, no waste

## INTEGRATION WITH OTHER SYSTEMS

### Story/Companion System:

```javascript
// Debt system affects economy
if (campaign.debt.gold > 0) {
  // Gold rewards reduced by debt amount
  missionReward -= min(missionReward * 0.3, campaign.debt.gold)
  campaign.debt.gold -= deduction
}

// Blood Debt creates forced spending
if (campaign.debt.blood > 0) {
  // Must pay "blood price" (HP sacrifice) or gold premium
  doctorCost *= 1.5 // 50% markup if in debt
}
```

### Contract Board System:

```javascript
// Economy contracts offer gold relief
const economyContracts = [
  {
    type: 'Supply Convoy',
    reward: { gold: 200 },
    risk: 'Medium combat'
  },
  {
    type: 'High-Risk Bounty',
    reward: { gold: 350 },
    risk: 'High injury risk'
  },
  {
    type: 'Debt Relief',
    reward: { debtReduction: 100 },
    risk: 'Rival presence'
  }
]
```

## TESTING CHECKLIST

### Economic Balance Validation:

- [ ] Can player afford essential healing? (Yes, 500-1,250g available)
- [ ] Can player complete a build? (Yes, ~1,500g for gear + upgrades)
- [ ] Is player forced to grind? (No, fixed mission count)
- [ ] Does RNG screw over players? (No, shop provides backup)
- [ ] Do choices matter? (Yes, can't afford everything)
- [ ] Can skilled players hoard gold? (Yes, ~2,000g surplus if perfect)
- [ ] Can unskilled players recover? (Yes, but tight budget ~1,200g surplus)

**Next Step:** Create UI/UX Mockups (screen layouts) OR Start Coding
**After That:** Build economy simulator to validate balance
**Then:** Playtest full economic loop

**Complete economy system designed!**
**Total Income:** 3,924 gold across 15 missions
**Total Sinks:** 2,340-5,030 gold (player chooses wisely)
**Balance:** Player must prioritize, no grinding, choices matter

## Source: Shop Counter-Weighting .txt

Shop Counter-Weighting (P0 Lock)
Why we’re doing this

Your blind spot audit flags that mana tempo can compress and that accessories can carry too much systemic weight. Counter-weighting makes the shop behave like a balance valve: it offers what the player needs to stay viable, but never guarantees the “best” build pieces.

This is also consistent with your shop pillar: RNG mitigation without grinding.

Core rule: Shops are biased, not random

Every shop roll is influenced by a ShopBiasProfile that looks at:

A) Player state tags

Faction (AEGIS / ECLIPSE / SPECTER)

Current act (1/2/3)

Current gear slots filled (Weapon/Armor/Accessory)

Current resource posture (too much mana? too much armor? too much poison?)

Current injuries / condition severities (if relevant)

B) Threat state tags

Next mission enemy archetypes (from contract board / map node)

Active rival traits (if rival is hunting you)

Trial modifiers on the route node (from your trial library)

The result: the shop “tries” to present at least one meaningful counter option each time you visit.

“Counter Slots” in every shop inventory (locked)

Each shop inventory is generated as:

Inventory layout (V1)

Gear: 3 items

Cards: 3 items

Services: 2 options (fixed list, act-scaled costs)

1 “Counter Offer” slot (can be gear or card, but must be a counter)

Total visible: 9 entries (or 8 if you prefer fewer; the important part is the “Counter Offer” slot exists).

The Counter Offer slot must satisfy ONE:

A Counter Offer is any item that addresses one of these:

Tempo counter (prevents mana spikes / slows enemy snowball / provides defense early)

Armor counter (armor shred, armor bypass, anti-fortress)

Poison counter (cleanse, resist, shorten debuffs, accelerate kills to beat DOT)

Burst counter (weakening, blinds, dampeners, guard)

Sustain counter (healing/injury mitigation if player is limping)

This forces meaningful choices without making outcomes deterministic.

The anti-accessory dominance rule (this is the key)

Accessories are where your strongest tempo/resource effects typically live.

So we hard-limit them in the shop, not by rewriting all accessories yet:

Accessory availability cap (per shop visit)

Act 1: max 1 accessory can appear in Gear offerings

Act 2: max 1 accessory

Act 3: max 2 accessories

And the Counter Offer slot cannot be an accessory unless the player has no accessory equipped.

This single rule prevents “shop = accessory fishing.”

Weighted selection algorithm (text-friendly, easy to implement later)
Step 1 — build weights by slot

Base weights:

Weapon: 1.0

Armor: 1.0

Accessory: 0.6 (pre-nerfed via weighting)

Adjusters:

If player is missing a slot: that slot weight × 1.8

If player is over-indexed:

Too much mana generation already: Accessory weight × 0.35

Too much armor scaling: Armor weight × 0.7

Too much poison scaling: Status-synergy gear weight × 0.7

If next mission is heavy threat:

Anti-Armor / Anti-Poison / Anti-Burst counters get a guaranteed “candidate list” in Step 3

Step 2 — pick gear slots respecting caps

Roll 3 gear items:

Roll 1: weighted by slot

Roll 2: weighted by slot

Roll 3: weighted by slot
Then apply:

Accessory cap

No duplicates (same item)

Rarity gating (act-based below)

Step 3 — generate Counter Offer

Select 1 item from a Counter Pool computed from threats + player weakness:

If next mission includes “armor wall” enemies → prioritize armor shred/bypass

If poison-heavy enemies → prioritize cleanse/resist/fast kill cards

If rival is active with assassination traits → prioritize defensive tempo

Counter Offer must be purchasable (price within plausible range). If not, downgrade rarity.

Rarity gating (by act) for gear & cards

This keeps “gold-starved choices” intact and stops early “god rolls.”

Gear rarity availability

Act 1: Common 70%, Rare 30%, Epic 0%

Act 2: Common 40%, Rare 50%, Epic 10%

Act 3: Common 20%, Rare 50%, Epic 30%

Counter Offer rarity rules

Counter Offer can be at most Rare in Act 1, unless:

player has 2+ injuries at S2+ severity → then allow Epic at 5% (rare rescue)

“Pity” without freebies: the Bad Luck Buffer

If player visits 2 shops in a row without seeing a relevant counter:

Next shop Counter Offer is guaranteed to target the largest threat gap (not the best item; just a relevant class of item).

This prevents unwinnable RNG spirals.

Shop reroll behavior (important with weighting)

Reroll should not reset the counter guarantee.

Reroll rules:

Reroll cost: stays as your doc specifies (or scale by act)

A reroll regenerates only:

the 3 gear

the 3 cards
But the Counter Offer stays counter-aligned (it can change item, but must remain a counter).

This stops reroll spam from bypassing the design intent.

What this solves immediately (without coding or rewriting gear)

✅ Keeps accessories from being the “always correct purchase”
✅ Reduces mana tempo compression by making “mana engines” harder to fish for early
✅ Makes threat scouting / rivals / trials matter because the shop reacts to them
✅ Preserves your core economy philosophy: scarcity + meaningful choices

What I’d do next (still P0, still text-only)

If you’re aligned with counter-weighting, the next step is to define the Counter Pools as simple tags in text:

COUNTER_ARMOR

COUNTER_POISON

COUNTER_BURST

COUNTER_TEMPO

COUNTER_SUSTAIN

Then we tag existing gear/cards in your library with 1–2 counter tags. That’s a fast pass and gives you huge control later.

# Resources

## Source: refined_resource_system.md

# Refined Dual-Resource Combat System (Stamina + Mana)

> **Based on research:** Slay the Spire, Monster Train, Hearthstone, Marvel Snap
> **Goal:** Dynamic resources with clear balance guardrails

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

## Our System: **Stamina (Cards) + Mana (Abilities)**

### Design Pillars

1. **Stamina is tactical** - moment-to-moment card plays
2. **Mana is strategic** - build toward ability usage
3. **Both scale dynamically** - gear/cards can boost, but capped
4. **Hard caps prevent degenerate combos**
5. **Multiple paths to generation** - passive, active, risk/reward

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

## OPEN QUESTIONS FOR YOU

1. **Starting Mana:** Should fights start at 0 Mana (build up slowly) or 2-3 Mana (Ability 1 available sooner)?

2. **Stamina ramping:** Fixed 3 per turn (simple) or ramp 1→2→3 (early game phases)?

3. **Faction-specific Mana generation:** Should each faction have unique ways to gain Mana faster?

4. **Mana on death:** Should player gain Mana when downed (0 HP), or does that reward losing?

5. **X-cost cards:** Should we add "spend all remaining Stamina/Mana" cards for flexibility?

**Document Status:** ✅ READY FOR REVIEW
**Next Step:** Lock combat fundamentals (turn order, damage calc, status timing)
**After That:** Design 20-24 gear pieces with resource synergies

# Gear System

## Source: gear_system_complete.md

# Gear System - Complete Design (24 Pieces)

> **Version:** V1 Locked
> **Slots:** Weapon, Armor, Accessory (3 total)
> **Pieces:** 8 Weapons, 8 Armors, 8 Accessories

## Gear Philosophy

### Design Pillars:

1. **Faction synergies** - Some gear amplifies specific faction playstyles
2. **Build enablers** - Gear enables different strategies (resource-heavy, status-heavy, burst, etc.)
3. **Meaningful choices** - No strictly best gear, situational power
4. **Rarity = power + specificity** - Common is generalist, Epic is build-around
5. **Stats + effects** - Every piece has base stats AND a unique effect

## Gear Slot Rules

### Equipment Slots:

- **Weapon:** 1 slot (affects offense)
- **Armor:** 1 slot (affects defense/HP)
- **Accessory:** 1 slot (affects utility/resources)

### Equipping Rules:

- Can change gear at hub before missions
- Cannot change mid-combat
- Starting gear: Basic versions of each slot (provided free at game start)

## Rarity Tiers

### Common (Easy to find, affordable)

- Drops frequently from early missions (Levels 1-5)
- Cost: 50-100 gold at Market
- **Power level:** Solid baseline, no fancy synergies
- **Examples:** +2 HP, +1 Armor, small stat boosts

### Rare (Build enablers, mid-game)

- Drops from mid-game missions (Levels 6-12)
- Cost: 200-400 gold at Market
- **Power level:** Stronger stats + unique effect
- **Examples:** Faction synergies, resource generation, status effects

### Epic (Build-defining, late-game)

- Drops from late-game missions (Levels 10-15) and bosses
- Cost: 800-1200 gold at Market
- **Power level:** Powerful effect that enables entire build archetypes
- **Examples:** Double status effects, cap increases, game-changing passives

## WEAPONS (8 Total)

### Stat Baseline:

- Weapons primarily boost **Damage** and may apply **status effects**
- Secondary: May boost Stamina, Speed, or apply debuffs

### COMMON WEAPONS (3)

**1. IRON GLADIUS**

- **Rarity:** Common
- **Stats:** +1 Damage
- **Effect:** None (pure damage boost)
- **Synergy:** Universal
- **Drop:** Mission 1-3

**2. SPIKED CLUB**

- **Rarity:** Common
- **Stats:** +1 Damage
- **Effect:** Your attacks have a 25% chance to apply Bleeding 1
- **Synergy:** ECLIPSE (bleeding synergy)
- **Drop:** Mission 2-4

**3. BALANCED BLADE**

- **Rarity:** Common
- **Stats:** +1 Speed
- **Effect:** Draw 1 additional card at start of combat
- **Synergy:** Universal (card advantage)
- **Drop:** Mission 3-5

### RARE WEAPONS (3)

**4. CRIMSON FANG**

- **Rarity:** Rare
- **Stats:** +2 Damage
- **Effect:** When you apply Bleeding, apply +1 additional stack
- **Synergy:** ECLIPSE (amplifies Bloodlust strategy)
- **Drop:** Mission 6-8
- **Cost:** 300 gold

**5. TOWER BREAKER**

- **Rarity:** Rare
- **Stats:** +2 Damage
- **Effect:** Your attacks deal +3 damage vs enemies with 10+ Armor
- **Synergy:** AEGIS counter (anti-tank)
- **Drop:** Mission 7-9
- **Cost:** 300 gold

**6. VENOMOUS DAGGER**

- **Rarity:** Rare
- **Stats:** +1 Damage, +1 Speed
- **Effect:** Your first attack each turn applies Poison 1
- **Synergy:** SPECTER (free poison application)
- **Drop:** Mission 8-10
- **Cost:** 350 gold

### EPIC WEAPONS (2)

**7. ECLIPSE REAVER**

- **Rarity:** Epic
- **Stats:** +3 Damage
- **Effect:** Your attacks deal +50% damage to enemies below 50% HP
- **Synergy:** ECLIPSE (execute strategy)
- **Drop:** Mission 12-14, Boss reward
- **Cost:** 1000 gold
- **Build:** Finish low-HP enemies explosively

**8. PLAGUE SCYTHE**

- **Rarity:** Epic
- **Stats:** +2 Damage
- **Effect:** Whenever you apply Poison, also apply Weakened 1
- **Synergy:** SPECTER (dual status application)
- **Drop:** Mission 13-15, Boss reward
- **Cost:** 1000 gold
- **Build:** Control + DoT hybrid

## ARMORS (8 Total)

### Stat Baseline:

- Armors primarily boost **HP** and **Armor**
- Secondary: May provide damage reduction, status resistance, healing

### COMMON ARMORS (3)

**9. LEATHER VEST**

- **Rarity:** Common
- **Stats:** +3 HP
- **Effect:** None (pure HP boost)
- **Synergy:** Universal
- **Drop:** Mission 1-3

**10. IRON CHESTPLATE**

- **Rarity:** Common
- **Stats:** +2 Armor
- **Effect:** Start each combat with +2 Armor
- **Synergy:** AEGIS (armor stacking)
- **Drop:** Mission 2-4

**11. AGILE TUNIC**

- **Rarity:** Common
- **Stats:** +2 HP, +1 Speed
- **Effect:** None
- **Synergy:** ECLIPSE (speed + HP)
- **Drop:** Mission 3-5

### RARE ARMORS (3)

**12. FORTIFIED PLATE**

- **Rarity:** Rare
- **Stats:** +5 HP, +3 Armor
- **Effect:** When you gain Armor, gain +1 additional Armor
- **Synergy:** AEGIS (Fortress amplification)
- **Drop:** Mission 6-8
- **Cost:** 350 gold

**13. SHADOW CLOAK**

- **Rarity:** Rare
- **Stats:** +4 HP, +2 Speed
- **Effect:** Reduce Bleeding and Poison damage taken by 1 (minimum 1)
- **Synergy:** ECLIPSE/SPECTER (DoT resistance)
- **Drop:** Mission 7-9
- **Cost:** 300 gold

**14. REGENERATIVE MAIL**

- **Rarity:** Rare
- **Stats:** +6 HP
- **Effect:** At the start of your turn, restore 1 HP if you have no Bleeding or Poison
- **Synergy:** AEGIS (slow sustain)
- **Drop:** Mission 8-10
- **Cost:** 300 gold

### EPIC ARMORS (2)

**15. AEGIS BULWARK**

- **Rarity:** Epic
- **Stats:** +8 HP, +5 Armor
- **Effect:** Increase Armor cap from 30 → 40
- **Synergy:** AEGIS (breaks armor cap)
- **Drop:** Mission 12-14, Boss reward
- **Cost:** 1200 gold
- **Build:** Maximum defense stacking

**16. BLOOD-SOAKED RAIMENT**

- **Rarity:** Epic
- **Stats:** +7 HP
- **Effect:** When you deal damage with an attack, restore HP equal to 20% of damage dealt (rounded down)
- **Synergy:** ECLIPSE (lifesteal)
- **Drop:** Mission 13-15, Boss reward
- **Cost:** 1000 gold
- **Build:** Aggressive sustain

## ACCESSORIES (8 Total)

### Stat Baseline:

- Accessories provide **utility**, **resources**, and **special effects**
- Most flexible slot - enables unique builds

### COMMON ACCESSORIES (3)

**17. IRON RING**

- **Rarity:** Common
- **Stats:** +2 HP
- **Effect:** None (small HP boost)
- **Synergy:** Universal
- **Drop:** Mission 1-3

**18. LUCKY CHARM**

- **Rarity:** Common
- **Stats:** None
- **Effect:** Start each combat with +1 Mana
- **Synergy:** Universal (early ability access)
- **Drop:** Mission 2-4

**19. STAMINA BAND**

- **Rarity:** Common
- **Stats:** None
- **Effect:** Start turn 1 with +1 Stamina (4 total instead of 3)
- **Synergy:** Universal (explosive start)
- **Drop:** Mission 3-5

### RARE ACCESSORIES (3)

**20. ENERGY TALISMAN**

- **Rarity:** Rare
- **Stats:** None
- **Effect:** +1 Stamina per turn (3 → 4 base)
- **Synergy:** Universal (more cards per turn)
- **Drop:** Mission 6-8
- **Cost:** 400 gold
- **Build:** Resource engine

**21. ARCANE CRYSTAL**

- **Rarity:** Rare
- **Stats:** None
- **Effect:** +1 Mana per turn (passive generation 1 → 2)
- **Synergy:** Universal (faster abilities)
- **Drop:** Mission 7-9
- **Cost:** 400 gold
- **Build:** Ability-focused

**22. TACTICIAN'S LENS**

- **Rarity:** Rare
- **Stats:** None
- **Effect:** Draw +1 card per turn (1 → 2)
- **Synergy:** Universal (card advantage)
- **Drop:** Mission 8-10
- **Cost:** 400 gold
- **Build:** Combo/control

### EPIC ACCESSORIES (2)

**23. BLOODSTONE RING**

- **Rarity:** Epic
- **Stats:** None
- **Effect:** Gain Mana per 3 damage taken (instead of per 5). Start each combat with -5 HP.
- **Synergy:** ECLIPSE (risky Mana generation)
- **Drop:** Mission 12-14, Boss reward
- **Cost:** 800 gold
- **Build:** High-risk, high-reward ability spam

**24. MIASMA PENDANT**

- **Rarity:** Epic
- **Stats:** None
- **Effect:** SPECTER Miasma triggers twice per turn (+2 Poison instead of +1)
- **Synergy:** SPECTER ONLY (doubles Miasma)
- **Drop:** Mission 13-15, Boss reward
- **Cost:** 1000 gold
- **Build:** Poison scaling explosion

## Faction Synergy Matrix

### AEGIS Synergies:

**Strong with:**
- Fortified Plate (Armor stacking)
- Aegis Bulwark (Armor cap increase)
- Iron Chestplate (start combat Armor)
- Regenerative Mail (sustain)
- Energy Talisman (play more defensive cards)

**Neutral:**
- Balanced Blade, Lucky Charm, Tactician's Lens (universal utility)

**Weak with:**
- Eclipse Reaver (AEGIS doesn't get enemies low fast)
- Bloodstone Ring (AEGIS doesn't want to take extra damage)

### ECLIPSE Synergies:

**Strong with:**
- Crimson Fang (Bleeding amplification)
- Eclipse Reaver (execute power)
- Blood-Soaked Raiment (lifesteal)
- Spiked Club (chance to bleed)
- Agile Tunic (Speed + HP)
- Bloodstone Ring (risky Mana generation)

**Neutral:**
- Balanced Blade, Lucky Charm, Arcane Crystal (universal)

**Weak with:**
- Tower Breaker (ECLIPSE doesn't fight high-armor targets well)
- Fortified Plate (ECLIPSE doesn't stack Armor)
- Aegis Bulwark (no Armor cap needed)

### SPECTER Synergies:

**Strong with:**
- Venomous Dagger (free Poison per turn)
- Plague Scythe (Poison + Weakened combo)
- Miasma Pendant (doubles Miasma)
- Shadow Cloak (DoT resistance)
- Tactician's Lens (cards for control)
- Arcane Crystal (Mana for abilities)

**Neutral:**
- Balanced Blade, Lucky Charm (universal)

**Weak with:**
- Eclipse Reaver (SPECTER doesn't burst enemies low fast)
- Tower Breaker (SPECTER doesn't need anti-armor)

## Example Builds (Gear + Faction)

### Build 1: "FORTRESS TANK" (AEGIS)

**Gear:**
- **Weapon:** Iron Gladius (+1 Damage)
- **Armor:** Fortified Plate (+5 HP, +3 Armor, extra Armor when gained)
- **Accessory:** Energy Talisman (+1 Stamina/turn)

**Strategy:**
- Stack Armor every turn (Fortified Plate amplifies)
- Fortress passive converts Armor → HP
- Energy Talisman = play more Shield Bash/Fortify per turn
- Grind enemies down slowly

**Counters:** SPECTER Poison (ignores Armor)

### Build 2: "BLEEDING BERSERKER" (ECLIPSE)

**Gear:**
- **Weapon:** Crimson Fang (+2 Damage, +1 Bleeding when applying)
- **Armor:** Blood-Soaked Raiment (+7 HP, lifesteal 20%)
- **Accessory:** Bloodstone Ring (faster Mana, start -5 HP)

**Strategy:**
- Apply Bleeding quickly (Crimson Fang adds +1)
- Bloodlust passive (+2 damage to bleeding enemies)
- Lifesteal sustains through low HP
- Use abilities early (Bloodstone Ring generates Mana from damage taken)
- High risk, high damage

**Counters:** AEGIS Weakened spam (reduces damage)

### Build 3: "PLAGUE MASTER" (SPECTER)

**Gear:**
- **Weapon:** Plague Scythe (+2 Damage, Poison → also apply Weakened 1)
- **Armor:** Shadow Cloak (+4 HP, +2 Speed, reduce DoT damage by 1)
- **Accessory:** Miasma Pendant (Miasma triggers twice: +2 Poison/turn)

**Strategy:**
- Apply Poison quickly
- Miasma Pendant doubles scaling (+2 Poison/turn instead of +1)
- Plague Scythe adds Weakened for defense
- Shadow Cloak provides speed and DoT resistance
- Exponential Poison damage: 4 → 6 → 8 → 10 → 12 per turn

**Counters:** ECLIPSE burst (kills before Poison scales)

### Build 4: "RESOURCE ENGINE" (Universal)

**Gear:**
- **Weapon:** Balanced Blade (+1 Speed, draw 1 at start)
- **Armor:** Regenerative Mail (+6 HP, heal 1 HP/turn if no DoTs)
- **Accessory:** Tactician's Lens (draw +1 card/turn)

**Strategy:**
- Draw 3 cards/turn (1 base + 1 Balanced Blade start + 1 Tactician's Lens)
- Always have options in hand
- Regenerative Mail provides slow sustain
- Flexible, adapts to matchups

**Counters:** Aggressive decks (can't compete with raw power)

## Gear Acquisition

### Drop Rates (Estimated):

**Common gear:**
- Missions 1-5: 80% drop rate
- Cost: 50-100 gold

**Rare gear:**
- Missions 6-10: 60% drop rate
- Missions 11-15: 40% drop rate
- Cost: 200-400 gold

**Epic gear:**
- Missions 10-15: 20% drop rate
- Boss missions: 80% drop rate (guaranteed epic from final bosses)
- Cost: 800-1200 gold

### Progression Path:

- **Early (Levels 1-5):** Commons only, build basics
- **Mid (Levels 6-10):** Unlock Rares, experiment with synergies
- **Late (Levels 11-15):** Unlock Epics, enable build-defining strategies

## Gear Upgrade System (Optional V2 Feature)

### V1: No upgrades (keep it simple)

- Gear is static once acquired
- Progression comes from finding better gear

### V2 (Post-launch):

- **Upgrade tiers:** +1/+2/+3 versions
- **Cost:** Gold + materials from missions
- **Effect:** +1 to all stats, enhanced unique effect
- **Example:** Crimson Fang +1 → Applies +2 Bleeding instead of +1

## Balance Guidelines

### Stat Budget by Rarity:

**Common:** 2-4 stat points, simple effect or no effect
- Example: +2 HP, +1 Damage, +1 Speed

**Rare:** 4-6 stat points, build-enabling effect
- Example: +2 Damage, unique synergy effect

**Epic:** 6-10 stat points, build-defining effect
- Example: +3 Damage, game-changing passive

### Power Comparison:

- **Starting gear (free):** ~2 total stat points
- **Full Common set:** ~6-8 total stat points
- **Full Rare set:** ~12-15 total stat points + synergies
- **Full Epic set:** ~20-25 total stat points + game-changers

## Gear Testing Checklist

### Questions to validate:

- [ ] Are Epics significantly better than Rares? (Yes, but situational)
- [ ] Can you beat the game with Commons? (Yes, harder but doable)
- [ ] Does gear enable build diversity? (Yes, 3+ viable builds per faction)
- [ ] Are any pieces strictly better than others? (No, situational power)
- [ ] Do faction synergies feel strong? (Yes, amplify playstyle)
- [ ] Can you mix-and-match gear across factions? (Yes, some universal pieces)

## Implementation Priority

### Phase 1 (V1 Core):

- [ ] Implement all 24 gear pieces (stats + effects)
- [ ] Implement gear equipping at hub
- [ ] Implement gear drops from missions
- [ ] Add gear to Market shop

### Phase 2 (Balancing):

- [ ] Playtest each build archetype
- [ ] Tune stat values
- [ ] Adjust drop rates
- [ ] Adjust gold costs

### Phase 3 (Polish):

- [ ] Add gear descriptions (flavor text)
- [ ] Add visual indicators (icons/colors by rarity)
- [ ] Add gear comparison UI
- [ ] Add "recommended gear" hints

## Quick Reference Table

| # | Name | Slot | Rarity | Stats | Effect |
|---|------|------|--------|-------|--------|
| 1 | Iron Gladius | Weapon | Common | +1 Dmg | None |
| 2 | Spiked Club | Weapon | Common | +1 Dmg | 25% Bleeding 1 |
| 3 | Balanced Blade | Weapon | Common | +1 Spd | Draw 1 at start |
| 4 | Crimson Fang | Weapon | Rare | +2 Dmg | +1 Bleeding when applying |
| 5 | Tower Breaker | Weapon | Rare | +2 Dmg | +3 dmg vs 10+ Armor |
| 6 | Venomous Dagger | Weapon | Rare | +1 Dmg, +1 Spd | First attack applies Poison 1 |
| 7 | Eclipse Reaver | Weapon | Epic | +3 Dmg | +50% dmg vs <50% HP |
| 8 | Plague Scythe | Weapon | Epic | +2 Dmg | Poison also applies Weakened 1 |
| 9 | Leather Vest | Armor | Common | +3 HP | None |
| 10 | Iron Chestplate | Armor | Common | +2 Armor | Start with +2 Armor |
| 11 | Agile Tunic | Armor | Common | +2 HP, +1 Spd | None |
| 12 | Fortified Plate | Armor | Rare | +5 HP, +3 Armor | +1 Armor when gaining |
| 13 | Shadow Cloak | Armor | Rare | +4 HP, +2 Spd | -1 DoT damage taken |
| 14 | Regenerative Mail | Armor | Rare | +6 HP | Heal 1 HP/turn if no DoTs |
| 15 | Aegis Bulwark | Armor | Epic | +8 HP, +5 Armor | Armor cap 30→40 |
| 16 | Blood-Soaked Raiment | Armor | Epic | +7 HP | 20% lifesteal |
| 17 | Iron Ring | Accessory | Common | +2 HP | None |
| 18 | Lucky Charm | Accessory | Common | None | Start with +1 Mana |
| 19 | Stamina Band | Accessory | Common | None | Turn 1: +1 Stamina |
| 20 | Energy Talisman | Accessory | Rare | None | +1 Stamina/turn |
| 21 | Arcane Crystal | Accessory | Rare | None | +1 Mana/turn |
| 22 | Tactician's Lens | Accessory | Rare | None | Draw +1/turn |
| 23 | Bloodstone Ring | Accessory | Epic | None | Mana per 3 dmg, start -5 HP |
| 24 | Miasma Pendant | Accessory | Epic | None | Miasma +2 Poison (SPECTER only) |

**Document Status:** ✅ READY TO LOCK
**Total Pieces:** 24 (8 Weapons, 8 Armors, 8 Accessories)
**Next Step:** Lock progression system (unlock schedule)
**After That:** Build master balance spreadsheet

# Factions

## Source: faction_design_complete.md

# Complete Faction Design - AEGIS | ECLIPSE | SPECTER

> **Version:** V1 Locked
> **Scope:** Full faction designs including base stats, faction bonuses, status synergies, 15-card kits, and counter-play dynamics

## Design Philosophy

### The Triangle

- **AEGIS** (Tank) → Counters ECLIPSE → Weak to SPECTER
- **ECLIPSE** (Assassin) → Counters SPECTER → Weak to AEGIS
- **SPECTER** (Control) → Counters AEGIS → Weak to ECLIPSE

### Balance Pillars

1. **Stat identity** - Each faction has clear strengths/weaknesses in HP/Armor/Speed/Damage
2. **Status mastery** - Each faction excels with 2 status effects, resists 1, vulnerable to 1
3. **Playstyle clarity** - Tank vs Burst vs Control should feel distinct
4. **Counter-play hooks** - Each faction has exploitable weaknesses

# FACTION 1: AEGIS (The Fortress)

## Identity

The unstoppable wall. AEGIS survives through high HP, armor generation, and converting defensive momentum into sustain. Slow but inexorable.

## Base Stats

- **HP:** 30

- **Armor:** 5
- **Speed:** 2
- **Damage:** 4

## Faction Bonus: "FORTRESS"

**Effect:** Whenever you gain Armor, restore HP equal to 30% of the Armor gained (rounded down).
- Gain 5 Armor → Restore 1 HP
- Gain 10 Armor → Restore 3 HP

**Design intent:** Rewards stacking armor effects. Converts defense into sustain without needing healing cards.

## Status Synergies

- **Masters:** Armor (stacking/refreshing), applying Weakened (reduces incoming damage)
- **Resists:** Bleeding (high HP pool absorbs it), Poison (can outheal it)
- **Vulnerable to:** Enraged (amplifies their low base damage against you)

## Card Philosophy

- High-cost, high-impact defensive plays
- Cards that gain armor AND do something else (attack, weaken, card draw)
- Few attacks, but they're efficient when you have armor up
- Lacks burst damage and speed

## AEGIS - 15 Card Kit

### STARTER CARDS (Always available - Level 1)

- Cost: 1
- Effect: Deal 5 damage. Gain 3 Armor.
- *Bread and butter. Efficient armor gain + damage in one card.*

- Cost: 1
- Effect: Gain 5 Armor.
- *Pure defense. Simple and reliable.*

- Cost: 2
- Effect: Deal 6 damage. If you have 5+ Armor, deal 10 damage instead.
- *Rewards building armor first. Your main damage payoff.*

### EARLY UNLOCKS (Levels 2-5)

- Cost: 1
- Effect: Gain 4 Armor. Draw 1 card.
- *Armor + card advantage. Key for keeping hand full.*

- Cost: 2
- Effect: Gain 8 Armor.
- *Big armor spike for Fortress healing.*

- Cost: 2
- Effect: Gain 6 Armor. Apply Weakened 2 to enemy.
- *Defense + offense reduction. Core defensive combo.*

### MID UNLOCKS (Levels 6-10)

- Cost: 1
- Effect: Deal damage equal to your current Armor (max 12).
- *Converts armor into damage. Big scaling potential.*

- Cost: 3
- Effect: Gain 12 Armor. Exhaust.
- *Huge armor burst once per fight. Massive Fortress heal.*

- Cost: 2
- Effect: Gain 5 Armor. Apply Weakened 3 to enemy.
- *Upgraded Shieldwall. Neuters enemy damage.*

- Cost: 1
- Effect: Gain Armor equal to half your missing HP (max 10).
- *Scales when low. Converts danger into defense.*

### LATE UNLOCKS (Levels 11-15)

- Cost: 3
- Effect: For the next 3 turns, gain 3 Armor at the start of your turn.
- *Passive armor generation. Incredible value over time.*

- Cost: 3
- Effect: Deal 15 damage. Lose all Armor.
- *Big finisher. Spend your armor bank for burst.*

- Cost: 2
- Effect: Double your current Armor (max 20 total).
- *Explosive armor scaling. Enables huge Fortress heals.*

**14. SECOND WIND** (Exhaust)
- Cost: 2
- Effect: Restore HP equal to your current Armor. Exhaust.
- *Emergency heal. Once per fight bailout.*

**15. PHALANX** (Ultimate)
- Cost: 4
- Effect: Gain 15 Armor. Draw 2 cards. Apply Weakened 4 to enemy.
- *Do everything. Expensive but game-winning when played.*

## AEGIS Strengths

- Incredible sustain through Fortress bonus
- Naturally resistant to chip damage (Bleeding, Poison)
- Can neuter enemy offense with Weakened stacks
- Scales well into long fights

## AEGIS Weaknesses

- Low base Speed (always goes second vs SPECTER)
- Low base Damage (struggles to finish quickly)
- Armor-stripping effects counter entire gameplan
- Vulnerable to Enraged (amplifies enemy damage through your armor)
- Expensive cards = vulnerable to hand disruption

# FACTION 2: ECLIPSE (The Blade)

## Identity

Surgical precision and overwhelming burst. ECLIPSE wins through high damage, status manipulation, and punishing wounded enemies. Glass cannon with execution tools.

## Base Stats

- **HP:** 20

- **Armor:** 0
- **Speed:** 5
- **Damage:** 7

## Faction Bonus: "BLOODLUST"

**Effect:** Deal +2 damage to enemies affected by Bleeding or Poison.

**Design intent:** Rewards applying and maintaining DoT effects. Makes status effects both damage AND damage multipliers.

## Status Synergies

- **Masters:** Bleeding (applies + exploits), Enraged (temporary burst windows)
- **Resists:** Poison (can burst enemies down before it matters)
- **Vulnerable to:** Armor (reduces burst damage), Weakened (cripples damage output)

## Card Philosophy

- High damage, low HP
- Many cards apply or exploit Bleeding
- Conditional burst cards (execute low HP enemies, exploit statuses)
- Speed advantage lets them strike first
- Fragile - needs to end fights fast

## ECLIPSE - 15 Card Kit

### STARTER CARDS (Level 1)

- Cost: 1
- Effect: Deal 6 damage. Apply Bleeding 1.
- *Core card. Damage + status setup.*

- Cost: 1
- Effect: Deal 5 damage.
- *Fast, cheap damage. Filler.*

- Cost: 2
- Effect: Deal 8 damage. If enemy is below 50% HP, deal 12 damage instead.
- *Your finisher. Rewards pressure.*

### EARLY UNLOCKS (Levels 2-5)

- Cost: 2
- Effect: Deal 7 damage. Apply Bleeding 2.
- *Heavy bleed application. Sets up Bloodlust.*

- Cost: 1
- Effect: Deal 4 damage. Double enemy's Bleeding stacks.
- *Bleed amplifier. Combos with Slash/Lacerate.*

- Cost: 2
- Effect: Deal 4 damage three times.
- *Multi-hit. Good vs Armor.*

### MID UNLOCKS (Levels 6-10)

**7. BLOOD FRENZY**

- Cost: 2
- Effect: Apply Enraged 2 to yourself. Draw 1 card.
- *Risk/reward. Big damage boost but take more damage.*

**8. HEMORRHAGE**

- Cost: 3
- Effect: Deal 10 damage. Apply Bleeding 3. Exhaust.
- *Massive bleed once per fight.*

**9. PREDATOR**

- Cost: 1
- Effect: If enemy has Bleeding or Poison, deal 9 damage. Otherwise deal 5 damage.
- *Bloodlust payoff card. Efficient with setup.*

**10. VITAL STRIKE**

- Cost: 2
- Effect: Deal 10 damage. If enemy is below 30% HP, kill them instantly.
- *Execute effect. High-roll finisher.*

### LATE UNLOCKS (Levels 11-15)

**11. CRIMSON TIDE**

- Cost: 3
- Effect: Deal 6 damage. For each stack of Bleeding on enemy, deal +2 damage.
- *Scaling damage. Rewards bleed stacking.*

- Cost: 2
- Effect: Apply Enraged 4 to yourself. Deal 12 damage.
- *All-in burst. Glass cannon at its finest.*

**13. SHADOW STEP**

- Cost: 1
- Effect: Deal 5 damage. Remove all Bleeding from enemy and deal damage equal to the stacks removed.
- *Converts Bleeding into immediate burst. Flexible.*

**14. CARVE** (Exhaust)
- Cost: 2
- Effect: Deal 8 damage. Apply Bleeding 4. Exhaust.
- *Long-term bleed bomb. Once per fight.*

**15. ASSASSINATE** (Ultimate)
- Cost: 4
- Effect: Deal 20 damage. If this kills the enemy, restore 10 HP.
- *Massive damage nuke. Rewards clean kills.*

## ECLIPSE Strengths

- Highest burst damage in the game
- Speed advantage (acts first almost always)
- Snowballs hard with Bleeding + Bloodlust
- Excellent at finishing low HP enemies

## ECLIPSE Weaknesses

- Lowest HP pool (20 HP)
- Zero base Armor (every hit hurts)
- Enraged is risky (takes increased damage while boosting offense)
- Struggles vs high Armor stacks (AEGIS hard counter)
- No sustain - must end fights quickly
- Weakened cripples entire gameplan

# FACTION 3: SPECTER (The Puppeteer)

## Identity

Control through disruption and poison. SPECTER wins by sabotaging enemy plans, denying resources, and letting poison do the work. Patient and methodical.

## Base Stats

- **HP:** 25

- **Armor:** 2
- **Speed:** 4
- **Damage:** 5

## Faction Bonus: "MIASMA"

**Effect:** At the start of your turn, if the enemy has Poison, apply +1 Poison stack.

**Design intent:** Exponential poison scaling. Rewards setup and stalling. Turns Poison into a win condition.

## Status Synergies

- **Masters:** Poison (stacking + scaling), Weakened (enables stalling)
- **Resists:** Enraged (can weather burst with control tools)
- **Vulnerable to:** Bleeding (lacks sustain to heal through it)

## Card Philosophy

- Control tools (apply Weakened, discard cards, manipulate resources)
- Poison application and amplification
- Stalling tactics (weak attacks + defense)
- Wins through attrition, not burst
- Requires setup time

## SPECTER - 15 Card Kit

### STARTER CARDS (Level 1)

- Cost: 1
- Effect: Deal 4 damage. Apply Poison 1.
- *Core card. Chip damage + poison setup.*

- Cost: 1
- Effect: Apply Weakened 2 to enemy.
- *Pure disruption. Reduces incoming damage.*

- Cost: 1
- Effect: Deal 6 damage.
- *Basic attack. Filler.*

### EARLY UNLOCKS (Levels 2-5)

- Cost: 2
- Effect: Apply Poison 2. Draw 1 card.
- *Poison + card advantage.*

- Cost: 2
- Effect: Deal 5 damage. If enemy has Poison, restore 3 HP.
- *Conditional sustain. Rewards poison uptime.*

- Cost: 1
- Effect: Apply Weakened 3 to enemy.
- *Big offense reduction. Buys time.*

### MID UNLOCKS (Levels 6-10)

- Cost: 2
- Effect: Apply Poison equal to half enemy's current HP (max 6).
- *Scales vs high HP targets. Anti-AEGIS tool.*

**8. ENERVATE**

- Cost: 2
- Effect: Apply Weakened 4 to enemy. Enemy discards 1 card.
- *Hard disruption. Attacks hand and stats.*

**9. SUFFOCATE**

- Cost: 3
- Effect: Deal damage equal to enemy's Poison stacks. Apply Poison 2. Exhaust.
- *Poison payoff bomb. Once per fight.*

**10. WITHERING CURSE**

- Cost: 1
- Effect: Apply Poison 2. Apply Weakened 2.
- *Dual status. Efficient setup card.*

### LATE UNLOCKS (Levels 11-15)

**11. TOXIC CLOUD**

- Cost: 3
- Effect: Apply Poison 4. Gain 5 Armor.
- *Big poison + defense. Buys time to scale.*

**12. VIRULENCE**

- Cost: 2
- Effect: Double enemy's Poison stacks (max 12 total).
- *Poison amplifier. Explosive scaling.*

**13. DRAIN LIFE**

- Cost: 2
- Effect: Deal 6 damage. Restore HP equal to enemy's Poison stacks.
- *Sustain payoff. Scales with poison uptime.*

**14. NIGHTMARE** (Exhaust)
- Cost: 3
- Effect: Apply Weakened 6 to enemy. Enemy discards 2 cards. Exhaust.
- *Ultimate disruption. Cripples enemy for one fight.*

**15. SEPSIS** (Ultimate)
- Cost: 4
- Effect: Apply Poison 6. At the start of each of your turns, enemy takes damage equal to their Poison stacks.
- *Miasma amplifier. Win condition card.*

## SPECTER Strengths

- Exponential poison scaling (Miasma bonus)
- Strong disruption tools (Weakened + discard effects)
- Balanced stats (not fragile, not slow)
- Counters burst-heavy strategies (ECLIPSE)
- Wins wars of attrition

## SPECTER Weaknesses

- Slow setup (needs 3-4 turns to get poison going)
- Low burst damage (can't finish quickly)
- Vulnerable to sustained pressure (AEGIS outlasts)
- Bleeding punishes stall tactics (no native healing)
- Weak to fast aggro (dies before poison matters)

# FACTION MATCHUP MATRIX

## AEGIS vs ECLIPSE

**AEGIS favored (65/35)**
- AEGIS armor counters ECLIPSE burst
- AEGIS Weakened stacks neuter ECLIPSE damage
- ECLIPSE lacks tools to strip armor efficiently
- ECLIPSE's low HP means they die before breaking through
- **ECLIPSE win condition:** Apply max Bleeding early, burst before armor scales

## ECLIPSE vs SPECTER

**ECLIPSE favored (60/40)**
- ECLIPSE speed + burst kills SPECTER before poison scales
- ECLIPSE Enraged ignores Weakened stacks (risk/reward)
- SPECTER lacks healing to survive burst
- **SPECTER win condition:** Survive opening burst, max Weakened + Poison, outlast

## SPECTER vs AEGIS

**SPECTER favored (65/35)**
- Poison ignores Armor (goes straight to HP)
- Plague Touch scales vs AEGIS high HP
- Weakened stacks reduce AEGIS pressure
- AEGIS lacks burst to end before poison scales
- **AEGIS win condition:** Rush with Crushing Blow/Counter Strike, finish before poison critical mass

# DESIGN VALIDATION CHECKLIST

## Each faction has:

✅ Clear identity (Tank / Assassin / Control)
✅ Distinct stat profile (high HP vs high damage vs balanced)
✅ Unique faction bonus (Fortress / Bloodlust / Miasma)
✅ 2 status masteries, 1 resist, 1 vulnerability
✅ 15 cards spanning starter → ultimate
✅ Clear win condition and playstyle
✅ Exploitable weaknesses for counterplay
✅ 60/40 to 65/35 favorable/unfavorable matchups

## Balance confirms:

✅ No faction autowins any matchup
✅ Each faction has comeback mechanics (Bulwark / Vital Strike / Virulence)
✅ Each faction has skill expression (combo sequencing, risk/reward)
✅ Status effects matter (not just stats)
✅ Gear can shift matchups (TBD in gear design)

# NEXT STEPS

1. **Lock status effect numbers** (Bleeding tick damage, Poison duration, Armor decay, etc.)
2. **Lock combat rules** (turn order, resource system, damage calc)
3. **Design gear system** (20-24 pieces with faction synergies)
4. **Build balance spreadsheet** (consolidate all numbers)
5. **Playtest simulation** (math out key matchups)

**Document Status:** ✅ LOCKED - Ready for implementation
**Last Updated:** V1 Initial
**Next Review:** After status effects + combat rules locked

## Source: FACTION_ABILITIES_COMPLETE.md

# FACTION ABILITIES - COMPLETE DESIGN

> **Status:** LOCKED - Ready for Implementation
> **Resource System:** Mana-based (0 start, +1/turn, +1 per card played max +2/turn)
> **Ability Costs:** 3 Mana (Ability 1), 7 Mana (Ability 2), 10+ Mana (Ability 3 - Future)

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

# AEGIS ABILITIES (The Fortress)

## PASSIVE: FORTRESS

**Effect:** Armor persists between waves in expeditions.
**Design Note:** Already locked. No combat effect, but critical for expedition progression.

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

## ABILITY 3: UNBREAKABLE FORTRESS (Future - Level 15+ Unlock)

**Cost:** 10 Mana
**Effect:** Double your current Armor (max 30). Gain Armor equal to your current HP. Immune to Weakened for 2 turns.
**Cooldown:** Once per combat

### Design Note:

- Late-game unlock
- Enables "invincible turn" fantasy
- Combines with Counter Strike for explosive damage
- Once-per-combat prevents spam

# ECLIPSE ABILITIES (The Blade)

## PASSIVE: BLOODLUST

**Effect:** Deal +2 damage to enemies with Bleeding or Poison.
**Design Note:** Already locked. Core to ECLIPSE identity.

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

## ABILITY 3: BLOOD FRENZY (Future - Level 15+ Unlock)

**Cost:** 10 Mana
**Effect:** Apply Enraged 3 to yourself. All Attack cards cost 0 Stamina this turn. Draw 2 cards.
**Cooldown:** Once per combat

### Design Note:

- All-in turn (spam attacks for free)
- Enraged 3 = +50% damage dealt, +25% damage taken (huge risk)
- Draw 2 ensures you have attacks to spam
- Glass cannon fantasy at peak

# SPECTER ABILITIES (The Puppeteer)

## PASSIVE: MIASMA

**Effect:** At start of your turn, if enemy has Poison, apply +1 Poison.
**Design Note:** Already locked. Exponential poison scaling.

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

## ABILITY 3: SOUL HARVEST (Future - Level 15+ Unlock)

**Cost:** 10 Mana
**Effect:** Apply Poison 10 to all enemies. For the next 3 turns, whenever an enemy takes Poison damage, restore 2 HP.
**Cooldown:** Once per combat

### Design Note:

- Massive poison bomb (10 stacks immediately)
- Lifesteal from poison (addresses SPECTER sustain weakness)
- Poison 10 + Miasma = 10, 11, 12 stacks (33+ damage over 3 turns + healing)

# ABILITY SUMMARY TABLE

| Faction | Ability 1 (3 Mana) | Ability 2 (7 Mana) | Ability 3 (10 Mana - Future) |
|---------|-------------------|-------------------|------------------------------|
| **AEGIS** | Bulwark: Gain Armor = 50% missing HP (max 10) | Iron Bastion: 12 Armor, Weakened 3 (all), Draw 1 | Unbreakable Fortress: Double Armor, gain Armor = HP, immune Weakened |
| **ECLIPSE** | Crimson Surge: +6 damage next attack, Bleeding 2, +1 Speed | Reaper's Mark: 12 damage, heal 8 + refund 2 Mana if kill, else Bleeding 4 | Blood Frenzy: Enraged 3, all attacks cost 0, Draw 2 |
| **SPECTER** | Withering Curse: Weakened 3, discard 1, Poison 1 | Plague Mastery: Double Poison (all), damage = Poison, Weakened 2 (all) | Soul Harvest: Poison 10 (all), heal when poison ticks |

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

**STATUS: LOCKED âœ…**
**Next Step:** Design enemy archetypes with AI behavior
**After That:** Define starting deck compositions
**Then:** Build combat simulator to validate math

**All 9 abilities are now locked and ready for implementation!**

# Enemies & Bosses

## Source: ENEMY_ARCHETYPES_COMPLETE.md

# ENEMY ARCHETYPES - COMPLETE DESIGN

> **Version:** V1 - Production Ready
> **Total Enemy Types:** 12 (8 regular + 3 elite + 1 boss template)
> **Design Philosophy:** Each enemy teaches a lesson, has clear counter-play, scales across Acts

## DESIGN PRINCIPLES

### 1. Enemy Purpose Pyramid

```
WAVE 1-2: Tutorial Enemies (teach mechanics)
WAVE 3-4: Tactical Enemies (test strategy)
WAVE 5-6: Elite/Boss Enemies (demand mastery)
```

### 2. AI Behavior Framework

Every enemy follows **Intent → Action → Outcome** pattern:
- **Intent:** Telegraphed next turn (shown to player)
- **Action:** Executes on enemy turn
- **Outcome:** Creates decision point for player

### 3. Faction Distribution

Each faction has **2 common + 1 elite** enemy types:
- **AEGIS:** Tank + Support + Elite Tank
- **ECLIPSE:** Assassin + Berserker + Elite Assassin
- **SPECTER:** Controller + Poisoner + Elite Controller
- **NEUTRAL:** Scouts + Mercenaries (any faction can field)

### 4. Scaling Rules

```
Act 1 (Missions 1-10):  Base stats
Act 2 (Missions 11-25): +20% HP, +1 damage
Act 3 (Missions 26+):   +40% HP, +2 damage, +1 to status effects
```

## TIER 1: COMMON ENEMIES (Waves 1-4)

### 🗡️ SCOUT (Neutral - Tutorial Enemy)

**Role:** Warm-up fodder, teaches basic combat
**Faction:** Any (hired mercenaries)

**Base Stats (Act 1):**

- HP: 12

- Armor: 0
- Speed: 3
- Damage: 5

**AI Behavior Pattern:**
```
Priority 1: If HP < 50% → Use "Retreat" (move to back, gain 2 Armor)
Priority 2: If player has Armor > 5 → Use "Pierce" (ignores 3 Armor)
Priority 3: Default → Use "Slash" (basic attack)
```

**Ability Deck:**
- **Slash** (70% chance): Deal 5 damage
- **Pierce** (20% chance): Deal 4 damage, ignores 3 Armor
- **Retreat** (10% chance): Gain 2 Armor, move to back row

**Loot:**
- Gold: 10-15
- Common card chance: 5%

**Design Notes:**
- Dies in 2-3 hits
- Teaches: Basic damage, armor mechanics, positioning
- Counter: Literally any strategy works

### 🛡️ SHIELDBEARER (AEGIS - Defensive Wall)

**Role:** Tank, protects dangerous allies
**Faction:** AEGIS

**Base Stats:**

- Armor: 8
- Speed: 2
- Damage: 4

**AI Behavior Pattern:**
```
Priority 1: If ally at <30% HP → Use "Protect" (redirect next attack to self)
Priority 2: If self Armor < 3 → Use "Fortify" (gain 5 Armor)
Priority 3: Default → Use "Shield Bash" (attack + gain Armor)
```

**Ability Deck:**
- **Shield Bash** (50%): Deal 4 damage, gain 3 Armor
- **Fortify** (30%): Gain 5 Armor
- **Protect** (20%): Redirect next attack to self, gain 2 Armor

**Loot:**
- Gold: 20-30
- Common armor gear chance: 8%

**Design Notes:**
- High armor, low damage
- Becomes priority target when protecting allies
- Teaches: Target prioritization, armor stripping
- Counter: Ignore until dangerous allies dead, or use armor-piercing attacks

### 🩸 BLOODLETTER (ECLIPSE - Bleed Specialist)

**Role:** Applies Bleeding, punishes low-armor targets
**Faction:** ECLIPSE

- HP: 18

- Armor: 0
- Speed: 5
- Damage: 6

**AI Behavior Pattern:**
```
Priority 1: If player has Bleeding 0 → Use "Open Wound" (apply Bleeding 3)
Priority 2: If player has Bleeding 3+ → Use "Twist the Knife" (deal damage = Bleeding stacks x2)
Priority 3: Default → Use "Slash" (basic attack)
```

**Ability Deck:**
- **Open Wound** (40%): Deal 5 damage, apply Bleeding 3
- **Twist the Knife** (30%): Deal damage = target's Bleeding x2 (max 12)
- **Slash** (30%): Deal 6 damage

**Loot:**
- Gold: 20-30
- Common weapon chance: 8%

**Design Notes:**
- Fragile (18 HP, 0 Armor) but dangerous if ignored
- Teaches: Status effect pressure, importance of healing
- Counter: Focus fire early, use armor to mitigate Bleeding, cleanse effects

### ☠️ TOXICANT (SPECTER - Poison Applicator)

**Role:** Poison stacker, enables SPECTER win condition
**Faction:** SPECTER

**AI Behavior Pattern:**
```
Priority 1: If player has Poison 0 → Use "Envenom" (apply Poison 2)
Priority 2: If player has Poison 3+ → Use "Plague Strike" (damage + spread Poison to squad)
Priority 3: Default → Use "Toxin Dart" (attack + Poison 1)
```

**Ability Deck:**
- **Envenom** (40%): Apply Poison 3
- **Plague Strike** (30%): Deal 5 damage, spread 1 Poison to entire player squad
- **Toxin Dart** (30%): Deal 4 damage, apply Poison 1

**Loot:**
- Gold: 20-30
- Common accessory chance: 8%

**Design Notes:**
- Medium bulk, stacks Poison quickly
- Teaches: Cleanse importance, squad-wide effects
- Counter: Focus fire to kill before Poison stacks, use AEGIS healing, cleanse consumables

### 🔥 BERSERKER (ECLIPSE - Risk/Reward)

**Role:** High damage, self-buffs with Enraged
**Faction:** ECLIPSE

- HP: 22

- Armor: 0
- Speed: 4
- Damage: 7

**AI Behavior Pattern:**
```
Priority 1: If HP > 50% AND not Enraged → Use "Rage" (apply Enraged 3 to self)
Priority 2: If Enraged → Use "Reckless Strike" (massive damage, lose HP)
Priority 3: Default → Use "Cleave" (AoE attack)
```

**Ability Deck:**
- **Rage** (30%): Apply Enraged 3 to self (deal +50% damage, take +25% damage)
- **Reckless Strike** (40%): Deal 12 damage, take 4 damage
- **Cleave** (30%): Deal 5 damage to entire player squad

**Loot:**
- Gold: 25-35
- Rare weapon chance: 5%

**Design Notes:**
- Glass cannon that buffs itself
- Becomes extremely dangerous when Enraged
- Teaches: Interrupt priority, exploiting vulnerabilities (Enraged takes +damage)
- Counter: Burst down while Enraged (exploit vulnerability), apply Weakened

### 🧙 WARLOCK (SPECTER - Debuff Support)

**Role:** Applies Weakened, supports allies
**Faction:** SPECTER

- Armor: 3
- Speed: 4
- Damage: 4

**AI Behavior Pattern:**
```
Priority 1: If player not Weakened → Use "Curse" (apply Weakened 3)
Priority 2: If ally HP < 40% → Use "Dark Mend" (heal ally 8 HP)
Priority 3: Default → Use "Shadow Bolt" (basic attack)
```

**Ability Deck:**
- **Curse** (40%): Apply Weakened 3 to player
- **Dark Mend** (30%): Heal ally 8 HP
- **Shadow Bolt** (30%): Deal 4 damage, apply Poison 1

**Loot:**
- Gold: 25-35
- Rare accessory chance: 5%

**Design Notes:**
- Fragile support that enables allies
- Priority kill target (healing + debuffs)
- Teaches: Target prioritization, interrupt importance
- Counter: Focus fire immediately, use cleanse for Weakened

### 🪓 BRUISER (Neutral - Damage Dealer)

**Role:** Mid-tier threat, solid stats
**Faction:** Any

- HP: 24

- Armor: 3
- Speed: 3
- Damage: 7

**AI Behavior Pattern:**
```
Priority 1: If player has Armor > 6 → Use "Armor Break" (deal damage, remove Armor)
Priority 2: If player HP < 30% → Use "Execute" (bonus damage vs low HP)
Priority 3: Default → Use "Heavy Blow" (high damage attack)
```

**Ability Deck:**
- **Heavy Blow** (50%): Deal 7 damage
- **Armor Break** (30%): Deal 5 damage, remove 4 Armor
- **Execute** (20%): Deal 10 damage if target below 30% HP, else 6 damage

**Loot:**
- Gold: 25-35
- Common weapon chance: 10%

**Design Notes:**
- Balanced stats, no gimmicks
- Teaches: Managing HP thresholds, armor dependency
- Counter: Keep HP high, maintain armor

### 🏹 SNIPER (Neutral - Backline Threat)

**Role:** Bypasses front line, targets weakest unit
**Faction:** Any

- HP: 16

- Armor: 0
- Speed: 5
- Damage: 8

**AI Behavior Pattern:**
```
Priority 1: Always target lowest HP player unit
Priority 2: If that unit has Armor > 5 → Use "Pierce Shot" (ignores Armor)
Priority 3: Default → Use "Snipe" (high damage, can't be blocked by positioning)
```

**Ability Deck:**
- **Snipe** (60%): Deal 8 damage to lowest HP target (ignores positioning)
- **Pierce Shot** (30%): Deal 6 damage, ignores all Armor
- **Retreat** (10%): Gain 3 Armor, move to back

**Loot:**
- Gold: 30-40
- Rare accessory chance: 5%

**Design Notes:**
- Fragile but dangerous
- Forces player to protect weakest units
- Teaches: HP management across squad, positioning limitations
- Counter: Rush down immediately, use armor on weak units

## TIER 2: ELITE ENEMIES (Waves 4-6)

### 👑 CHAMPION (AEGIS Elite - Mini-Boss Tank)

**Role:** High HP tank with self-sustain
**Faction:** AEGIS

- HP: 40

- Armor: 10
- Speed: 2
- Damage: 6

**AI Behavior Pattern:**
```
Priority 1: If HP < 50% → Use "Second Wind" (restore 15 HP, gain 5 Armor)
Priority 2: If Armor < 5 → Use "Fortress Stance" (gain 8 Armor, apply Weakened 2)
Priority 3: Default → Use "Crushing Blow" (attack that removes Armor from self for bonus damage)
```

**Ability Deck:**
- **Crushing Blow** (40%): Deal 10 damage, lose all Armor
- **Fortress Stance** (30%): Gain 8 Armor, apply Weakened 2 to attacker
- **Second Wind** (30%): Restore 15 HP, gain 5 Armor (once per combat)

**Loot:**
- Gold: 50-70
- Rare gear chance: 20%
- Epic gear chance: 5%

**Design Notes:**
- Endurance test, not burst threat
- Dangerous in squad compositions (protects allies)
- Teaches: Sustained pressure, armor stripping combos
- Counter: Ignore until dangerous allies dead, use armor-piercing repeatedly

### ⚔️ ASSASSIN (ECLIPSE Elite - Execution Specialist)

**Role:** Ultra-high burst, execution rewards
**Faction:** ECLIPSE

- HP: 28

- Armor: 0
- Speed: 6
- Damage: 10

**AI Behavior Pattern:**
```
Priority 1: If any player unit below 40% HP → Use "Execute" (massive damage, restore HP on kill)
Priority 2: If player has Bleeding 3+ → Use "Bloodlust Strike" (damage x Bleeding stacks)
Priority 3: Default → Use "Vital Strike" (apply Bleeding 3, high damage)
```

**Ability Deck:**
- **Execute** (30%): Deal 15 damage. If this kills, restore 12 HP.
- **Bloodlust Strike** (35%): Deal damage = 3 + (target's Bleeding x3)
- **Vital Strike** (35%): Deal 8 damage, apply Bleeding 3

**Loot:**
- Gold: 50-70
- Rare weapon chance: 25%
- Epic weapon chance: 5%

**Design Notes:**
- EXTREMELY dangerous if player is wounded
- Snowballs with kills (Execute heal)
- Teaches: HP threshold management, focus fire discipline
- Counter: Keep all units above 40% HP, focus fire immediately, use armor

### 🌑 SHADE (SPECTER Elite - Master Controller)

**Role:** Full control suite, debuffs + Poison scaling
**Faction:** SPECTER

- HP: 32

- Armor: 4
- Speed: 5
- Damage: 6

**AI Behavior Pattern:**
```
Priority 1: If player Poison < 3 → Use "Virulent Touch" (apply Poison 4)
Priority 2: If player Poison >= 3 → Use "Plague Burst" (deal damage = Poison x2, spread to squad)
Priority 3: If not applied Weakened → Use "Enfeeble" (apply Weakened 4, discard 1 card)
Priority 4: Default → Use "Shadow Strike" (attack + Poison 1)
```

**Ability Deck:**
- **Virulent Touch** (30%): Apply Poison 4
- **Plague Burst** (25%): Deal damage = target's Poison x2, spread 1 Poison to entire squad
- **Enfeeble** (25%): Apply Weakened 4, target discards 1 card
- **Shadow Strike** (20%): Deal 6 damage, apply Poison 1

**Loot:**
- Gold: 50-70
- Rare accessory chance: 25%
- Epic accessory chance: 5%

**Design Notes:**
- Control lock if ignored
- Poison scaling becomes lethal
- Teaches: Cleanse priority, resource denial
- Counter: Burst down early, cleanse constantly, use AEGIS

## TIER 3: BOSS TEMPLATE

### 👹 BOSS ENCOUNTER (Generic Template)

**Role:** Multi-phase endurance test
**Faction:** Varies by mission

**Phase 1 (100%-60% HP):**
```
Base Stats:
- HP: 60-80 (scales by Act)
- Armor: 5-10
- Speed: 4
- Damage: 8

AI Pattern:
- Telegraphed high-damage attacks (⚠️ HEAVY STRIKE incoming)
- Applies 1-2 status effects per turn
- Summons 1 common enemy every 3 turns
```

**Phase 2 (60%-30% HP):**
```
Mechanic Shift:
- Gains Enraged 3 permanently (+50% damage)
- Speed increases to 5
- Uses AoE attacks more frequently
- Summons elite enemies instead of common
```

**Phase 3 (30%-0% HP):**
```
Desperation:
- Uses ultimate ability (unique per boss)
- Applies multiple status effects
- Gains 10 Armor at start of phase
- Attacks twice per turn
```

**Boss-Specific Ultimates (Examples):**

**AEGIS Boss - "THE BULWARK":**
- **Phase 3 Ultimate:** Gain 20 Armor, heal 20 HP, apply Weakened 5 to entire squad

**ECLIPSE Boss - "THE REAPER":**
- **Phase 3 Ultimate:** Deal 20 damage to lowest HP unit, apply Bleeding 5 to entire squad

**SPECTER Boss - "THE HOLLOW KING":**
- **Phase 3 Ultimate:** Apply Poison 6 to entire squad, double all Poison stacks at start of each turn

**Loot:**
- Gold: 80-120
- Rare gear chance: 50%
- Epic gear chance: 20%
- Legendary gear chance: 5%

**Design Notes:**
- Each phase teaches a different skill
- Telegraphed attacks give counterplay windows
- Summons prevent pure stall strategies
- Phase transitions are clear (visual + audio cues)

## AI BEHAVIOR PRIORITY SYSTEM

### Decision Tree (Every Enemy Turn):

```
1. Check survival threshold (HP < 30%?)
   → YES: Use defensive/escape ability
   → NO: Continue

2. Check high-value targets (player unit below 30% HP?)
   → YES: Use execution/burst ability
   → NO: Continue

3. Check setup conditions (player has 0 Bleeding/Poison?)
   → YES: Use setup ability (apply status)
   → NO: Continue

4. Check payoff conditions (player has 3+ Bleeding/Poison?)
   → YES: Use payoff ability (damage scaling)
   → NO: Continue

5. DEFAULT: Use basic attack
```

### Difficulty Modifiers (Act Scaling):

**Act 1:**
- Enemies prioritize basic attacks (70% of the time)
- Rare use of advanced abilities
- Predictable patterns

**Act 2:**
- Enemies use advanced abilities more (50% of the time)
- Start comboing abilities (Warlock Curse → Berserker Rage)
- Adapt to player strategy (if player stacks Armor, use Pierce more)

**Act 3:**
- Enemies optimize ability usage (30% basic attacks)
- Full combo execution (Warlock Curse → Assassin Execute)
- Counter player faction (AEGIS players face more Poison/Bleeding)

## SQUAD COMPOSITION TEMPLATES

### Wave 1-2: Tutorial Squads

```
Composition: 2-3 Scouts
Purpose: Teach basic combat, low threat
```

### Wave 3-4: Tactical Squads

```
AEGIS Composition: 1 Shieldbearer + 2 Bruisers
- Shieldbearer protects Bruisers
- Player must decide: kill tank first or ignore?

ECLIPSE Composition: 1 Bloodletter + 1 Berserker + 1 Sniper
- Berserker goes Enraged, Bloodletter applies Bleeding, Sniper finishes
- Player must: cleanse Bleeding, burst Berserker while vulnerable

SPECTER Composition: 1 Toxicant + 1 Warlock + 1 Shade (Elite)
- Warlock Weakens, Toxicant/Shade stack Poison
- Player must: burst Warlock first, cleanse constantly
```

### Wave 5-6: Elite Squads

```
Mixed Faction: 1 Champion + 1 Assassin + 1 Warlock
- Champion tanks, Warlock debuffs, Assassin executes
- Player must: perfect target priority, HP management, cleanse timing

Boss Wave: 1 Boss + 2 rotating summons
- Boss summons common enemies every 3 turns
- Player must: balance boss damage with add control
```

## LOOT TABLE (Consolidated)

### Common Enemies (Scout, Shieldbearer, Bloodletter, Toxicant):

```
Gold: 10-30
Common gear: 5-10%
Rare gear: 0-2%
```

### Tactical Enemies (Berserker, Warlock, Bruiser, Sniper):

```
Gold: 25-40
Common gear: 10-15%
Rare gear: 5-8%
Epic gear: 0-1%
```

### Elite Enemies (Champion, Assassin, Shade):

```
Gold: 50-70
Rare gear: 20-25%
Epic gear: 5-8%
Legendary gear: 1-2%
```

### Boss Enemies:

```
Gold: 80-120
Rare gear: 50%
Epic gear: 20%
Legendary gear: 5%
```

## INTEGRATION WITH EXISTING SYSTEMS

### Injury System Integration:

```
Enemies can inflict injuries via:
- CRITICAL HITS (telegraphed ⚠️ attacks)

- KNOCKING PLAYER TO 0 HP

- ENVIRONMENTAL HAZARDS (boss mechanics)

Critical Hit Triggers:
- Assassin Execute on kill
- Boss Phase 3 ultimate
- Berserker Reckless Strike (if player below 20% HP)
```

### Companion/Story System Integration:

```
Enemy kills can trigger events:
- Kill Assassin that targeted your teammate → Bond +1
- Fail to protect ally from Sniper → Bond -1, stress +1
- Retreat from Elite → stress +1, trust -1 (if vow_no_retreat active)
```

### Contract Board Integration:

```
Enemy factions on missions create hooks:
- Face heavy AEGIS composition → "armor_dependence" hook
- Face ECLIPSE Assassins → "injury_risk" hook
- Face SPECTER Poison spam → "cleanse_required" hook

These hooks influence next contract board generation
```

## TESTING PRIORITIES

1. **Solo Enemy Validation**
   - Each enemy beatable with basic starter deck
   - AI makes intelligent decisions
   - Loot rewards feel fair

2. **Squad Composition Balance**
   - 3-enemy squads pose challenge but not wall
   - Synergies feel intentional, not random
   - Player has multiple valid strategies

3. **Boss Encounter Tuning**
   - Each phase distinct and teachable
   - Summoning doesn't overwhelm
   - Ultimates are dramatic but survivable

4. **Act Scaling Verification**
   - Act 2 enemies feel stronger, not unfair
   - Act 3 enemies demand mastery, not perfection
   - Loot scaling matches difficulty increase

**Next Step:** Design Card Library (40-60 cards)
**After That:** Create Starting Deck Templates
**Then:** Build combat simulator to validate balance

**All 12 enemy archetypes complete!**
**Total lines:** 8 Common + 3 Elite + 1 Boss Template = Production-ready enemy roster

## Source: Boss Trait Library → Locked Implementation Schema.txt

# Boss Trait Library → Locked Implementation Schema (v1)

Aligned to:
- CORE SYSTEM MASTER SPEC: boss traits are mechanical; impact enemy behavior, risk score, reward weighting, shop weighting :contentReference[oaicite:0]{index=0}
- Dynamic Story + Quest System: hooks + receiptsLog are first-class outputs :contentReference[oaicite:1]{index=1}
- Dynamic Contract Board + Hook System: hooks escalate and must be serviced by contracts :contentReference[oaicite:2]{index=2}
- Trial Modifier Library overlap rules (avoid stacking same effect) :contentReference[oaicite:3]{index=3}

## Global Conventions

### Schema (per trait)

- id
- name
- combatRule
- telegraph
- counterTags[]  → feeds Shop Counter Weighting (30% counter pool)
- riskTags[]     → displayed on contract preview
- riskScore      → 0–10 (used in contract risk score + reward weighting)
- onResultHooks  → { onWin[], onRetreat[], onDefeat[] } (hooks are data-driven tags)
- receiptLines   → { onPreview[], onWin[], onRetreat[], onDefeat[] } (1–2 lines each)

### CounterTags (standardized)

Use these tags to drive shop weighting pools:
- ArmorBreak, ArmorPierce, MultiHit, Sustain, Cleanse, AntiHeal
- AoE, AddControl, Tempo, CostControl, DebuffPlan, DebuffSpam
- Burst, ExecuteSafety, Scaling, Positioning, DispelCounter

### Trial Overlap Rule (LOCK CANDIDATE)

If a contract boss has a trait that overlaps a trial modifier, that modifier is removed from the trial offer set for that contract.
Examples:
- Armor Wall ↔ Reinforced
- Tempo Tax ↔ Hexed
- Summoner/Swarm ↔ Swarm
- Dispel ↔ Cleanse Ward
- Execute ↔ Executioner
(Prevents “double punishment” and keeps trials spicy.) :contentReference[oaicite:4]{index=4}

# 12 Boss Traits (Data Objects)

## 01) ARMOR_WALL

id: ARMOR_WALL
name: Armor Wall
combatRule: >
  Boss starts with +12 Armor. At the start of boss turn, if Armor < 6, gain +6 Armor.
  Armor cap for boss = 40.
telegraph: >
  "Plating Seals" — Armor refresh is displayed as a predictable start-of-turn pulse when threshold is met.
counterTags: [ArmorBreak, ArmorPierce, MultiHit, DebuffPlan]
riskTags: [HighDefense, AttritionFight]
riskScore: 7
onResultHooks:
  onWin: []
  onRetreat: [low_supplies]        # retreat implies you lacked answers
  onDefeat: [injury_major, low_supplies]
receiptLines:
  onPreview:
    - "BOSS TRAIT: ARMOR WALL — target plated. countermeasures recommended."
  onWin:
    - "ARMOR WALL BREACHED — plating failure logged."
  onRetreat:
    - "RETREAT LOGGED — armor countermeasures insufficient."
  onDefeat:
    - "FAILURE LOGGED — plating overcame output. supplies deficit flagged."

## 02) BLEED_PUNISHER

id: BLEED_PUNISHER
name: Bleed Punisher
combatRule: >
  If boss has Bleeding at start of its turn, it consumes all Bleeding stacks:
  deal direct HP damage = stacks × 2 (ignores Armor), then gain "Coagulate" (immune to Bleeding) for 1 turn.
telegraph: >
  "Backlash Pending" icon appears whenever boss currently has Bleeding; triggers at boss turn start.
counterTags: [Burst, DebuffPlan, Sustain, DispelCounter]
riskTags: [DebuffRisk, PunishMisplay]
riskScore: 6
onResultHooks:
  onWin: []
  onRetreat: [trust_drop]          # someone blames the plan
  onDefeat: [injury_major, bond_fracture]
receiptLines:
  onPreview:
    - "BOSS TRAIT: BLEED PUNISHER — bleed will be converted into harm."
  onWin:
    - "BLEED LOOP BROKEN — backlash denied."
  onRetreat:
    - "WITHDRAWAL LOGGED — bleed strategy flagged as hazardous."
  onDefeat:
    - "CASCADE FAILURE — backlash executed. cohesion impacted."

## 03) POISON_BLOOM

id: POISON_BLOOM
name: Poison Bloom
combatRule: >
  If boss has Poison at start of its turn, it converts it into Bloom (max 10):
  heal = Bloom and gain Armor = Bloom, then reduce Poison by 2.
  (Poison is still usable, but becomes a sustain engine if unchecked.)
telegraph: >
  "Blooming" meter shows current Bloom value before it triggers on boss turn start.
counterTags: [AntiHeal, Burst, DebuffSpam, CostControl]
riskTags: [HealingBoss, AntiDot]
riskScore: 7
onResultHooks:
  onWin: []
  onRetreat: [low_supplies]
  onDefeat: [injury_major, low_supplies]
receiptLines:
  onPreview:
    - "BOSS TRAIT: POISON BLOOM — toxins metabolized into armor + recovery."
  onWin:
    - "BLOOM SUPPRESSED — recovery loop interrupted."
  onRetreat:
    - "RETREAT LOGGED — bloom saturation exceeded capability."
  onDefeat:
    - "LOSS LOGGED — bloom sustained target beyond tolerance."

## 04) SUMMONER

id: SUMMONER
name: Summoner
combatRule: >
  Every 2 boss turns, summon 1 add. Adds persist.
  While any add is alive, boss gains +1 Damage per add (stacking).
telegraph: >
  "Summon Cycle" counter (2→1→SUMMON) shown on boss intent track.
counterTags: [AoE, AddControl, Tempo, Positioning]
riskTags: [AddPressure, ScalingThreat]
riskScore: 8
onResultHooks:
  onWin: []
  onRetreat: [stress_spike]        # (use your stress hook naming convention)
  onDefeat: [injury_major, stress_spike]
receiptLines:
  onPreview:
    - "BOSS TRAIT: SUMMONER — add pressure expected. clear protocols advised."
  onWin:
    - "SUMMON LOOP CONTAINED — external threats neutralized."
  onRetreat:
    - "WITHDRAWAL LOGGED — add pressure exceeded containment."
  onDefeat:
    - "COLLAPSE LOGGED — adds overran formation."

## 05) DISPEL

id: DISPEL
name: Dispel
combatRule: >
  Once per boss turn, the first debuff applied to boss is cleansed immediately
  (priority: Weakened > Poison > Bleeding). At 50% HP, boss triggers one-time Full Dispel (remove all debuffs).
telegraph: >
  "Ward Up" indicator shows whether the per-turn cleanse is available; 50% HP shows "Purge Incoming" warning.
counterTags: [RawDamage, DebuffSpam, Scaling, CostControl]
riskTags: [DebuffResist, TimingFight]
riskScore: 6
onResultHooks:
  onWin: []
  onRetreat: [trust_drop]
  onDefeat: [injury_major, trust_drop]
receiptLines:
  onPreview:
    - "BOSS TRAIT: DISPEL — debuffs will be erased. stack timing required."
  onWin:
    - "DISPEL WINDOW BAITED — purge exhausted."
  onRetreat:
    - "RETREAT LOGGED — dispel denied leverage."
  onDefeat:
    - "FAILURE LOGGED — purge neutralized control plan."

## 06) TEMPO_TAX

id: TEMPO_TAX
name: Tempo Tax
combatRule: >
  At start of player turn, apply Tax:
  the first card played costs +1 Stamina (min 1).
  Every 3rd boss turn, Tax escalates for 1 round: first two cards cost +1.
telegraph: >
  "Tax Active" shown on player turn. One turn before escalation: "Audit Pending" warning.
counterTags: [CostControl, Tempo, HighValueCards, StaminaEngine]
riskTags: [ResourceDenial, SlowStart]
riskScore: 8
onResultHooks:
  onWin: []
  onRetreat: [vow_broken]          # if you use vows; otherwise use trust_drop
  onDefeat: [injury_major, debt_pressure]
receiptLines:
  onPreview:
    - "BOSS TRAIT: TEMPO TAX — output will be throttled."
  onWin:
    - "TAX EVADED — tempo restored."
  onRetreat:
    - "RETREAT LOGGED — throttling achieved. audit recorded."
  onDefeat:
    - "FAILURE LOGGED — resource denial succeeded."

## 07) EXECUTE

id: EXECUTE
name: Execute
combatRule: >
  Boss deals +50% damage to targets below 30% HP.
  When any player unit enters execute range, boss gains +1 Speed for that turn.
telegraph: >
  "Finisher" icon appears over any unit in execute range; boss intent highlights lethal potential.
counterTags: [ExecuteSafety, Sustain, ArmorBreak, Tempo]
riskTags: [LethalThreshold, PunishLowHP]
riskScore: 7
onResultHooks:
  onWin: []
  onRetreat: [injury_minor]
  onDefeat: [injury_major]
receiptLines:
  onPreview:
    - "BOSS TRAIT: EXECUTE — low HP will be collected."
  onWin:
    - "EXECUTION DENIED — threshold control maintained."
  onRetreat:
    - "WITHDRAWAL LOGGED — termination window approached."
  onDefeat:
    - "TERMINATION LOGGED — execute condition met."

## 08) COUNTERATTACK

id: COUNTERATTACK
name: Counterattack
combatRule: >
  Once per round, the first time boss takes Attack damage, it deals counter damage back to attacker (direct HP):
  Counter = 5 + TraitRank. Multi-hit triggers counter only once.
telegraph: >
  "Counter Ready" marker resets each round; clears after counter triggers.
counterTags: [SkillOpeners, ArmorPlan, Sustain, DebuffPlan]
riskTags: [PunishAggro, SequencingTest]
riskScore: 6
onResultHooks:
  onWin: []
  onRetreat: [bond_fracture]       # mis-sequencing hurts trust in tactics
  onDefeat: [injury_major, bond_fracture]
receiptLines:
  onPreview:
    - "BOSS TRAIT: COUNTERATTACK — first strike each round will be answered."
  onWin:
    - "COUNTER LOOP DISARMED — sequencing verified."
  onRetreat:
    - "RETREAT LOGGED — counter pressure fractured formation."
  onDefeat:
    - "FAILURE LOGGED — counter pattern harvested mistakes."

## 09) SHIELDER

id: SHIELDER
name: Shielder
combatRule: >
  Boss begins with Barrier 10 (separate from Armor; must be broken first).
  First time Barrier breaks, boss gains Enraged 1 for 2 turns.
  Barrier refreshes once to 6 after a 1-turn cooldown.
telegraph: >
  Barrier value shown as an outer ring; "Barrier Re-forming" state is displayed during cooldown.
counterTags: [MultiHit, ArmorPierce, Burst, WeakenedPlan]
riskTags: [AntiBurst, TwoLayerDefense]
riskScore: 7
onResultHooks:
  onWin: []
  onRetreat: [low_supplies]
  onDefeat: [injury_major, low_supplies]
receiptLines:
  onPreview:
    - "BOSS TRAIT: SHIELDER — layered defenses detected."
  onWin:
    - "BARRIER SHATTERED — defense stack compromised."
  onRetreat:
    - "RETREAT LOGGED — barrier cycling outlasted burst."
  onDefeat:
    - "FAILURE LOGGED — layered defense held."

## 10) STUN

id: STUN
name: Stun
combatRule: >
  Every 3rd boss turn, it uses Stunning Blow:
  apply Stunned 1 (recommended implementation: player loses 2 Stamina next turn instead of a full skip).
  Cooldown prevents consecutive stuns.
telegraph: >
  Turn cadence: "Stun Charging" appears one turn before the stun beat.
counterTags: [Cleanse, StaminaEngine, HandSize, Tempo]
riskTags: [ControlLoss, TurnDisruption]
riskScore: 7
onResultHooks:
  onWin: []
  onRetreat: [stress_spike]
  onDefeat: [injury_major, stress_spike]
receiptLines:
  onPreview:
    - "BOSS TRAIT: STUN — command latency expected."
  onWin:
    - "STUN CYCLE BROKEN — control retained."
  onRetreat:
    - "RETREAT LOGGED — disruption exceeded tolerance."
  onDefeat:
    - "FAILURE LOGGED — control loss confirmed."

## 11) SWARM

id: SWARM
name: Swarm
combatRule: >
  Each boss turn: boss gains +1 Damage.
  Also spawns a 1-HP token. Tokens explode on death for 2 damage to a random player unit.
  If 3+ tokens exist, boss uses a weak AoE ping.
telegraph: >
  Token count is shown. At 3 tokens: "Swarm Critical" warning appears.
counterTags: [AoE, AddControl, Tempo, Sustain]
riskTags: [Escalation, BoardFlood]
riskScore: 8
onResultHooks:
  onWin: []
  onRetreat: [low_supplies]
  onDefeat: [injury_major, low_supplies]
receiptLines:
  onPreview:
    - "BOSS TRAIT: SWARM — attrition via saturation."
  onWin:
    - "SWARM CONTAINED — flood prevented."
  onRetreat:
    - "RETREAT LOGGED — saturation exceeded clearance rate."
  onDefeat:
    - "FAILURE LOGGED — swarm escalated beyond control."

## 12) ENDURANCE

id: ENDURANCE
name: Endurance
combatRule: >
  Boss has breakpoints at 75/50/25% HP.
  At each breakpoint: gain +8 Armor, cleanse Weakened, and gain Resolve (takes 1 less damage per hit) until next player turn.
telegraph: >
  Breakpoint markers shown on boss HP bar; "Breakpoint Imminent" flashes when within 5% HP.
counterTags: [Scaling, ArmorBreak, MultiHit, Tempo]
riskTags: [LongFight, BreakpointSpikes]
riskScore: 9
onResultHooks:
  onWin: []
  onRetreat: [debt_pressure]       # long fights burn supplies; tie into economy hooks
  onDefeat: [injury_major, debt_pressure]
receiptLines:
  onPreview:
    - "BOSS TRAIT: ENDURANCE — target will not collapse cleanly."
  onWin:
    - "ENDURANCE BROKEN — breakpoints exhausted."
  onRetreat:
    - "RETREAT LOGGED — endurance outlasted reserves."
  onDefeat:
    - "FAILURE LOGGED — breakpoint spikes overwhelmed output."

# Minimal Mapping: Trait → Contract Risk Score / Reward Weighting

Suggested contractRiskScore addition:
- Add the riskScore of each boss trait (1–2 traits), then clamp + normalize with act scaling.
Example:
- 1 trait: +6 risk
- 2 traits: +12 risk (high)
This is consistent with: traits alter contract risk score + reward weighting :contentReference[oaicite:5]{index=5}

# Notes for Your Existing Systems (No New Systems Added)

- Hooks listed use your existing hook approach (injury_major, trust_drop, bond_fracture, low_supplies, vow_broken, etc.)
- Receipts are short, “logged” lines that fit receiptsLog in the story system :contentReference[oaicite:7]{index=7}
- Shop counter-weighting uses counterTags; you already locked the 50/30/20 weighting model :contentReference[oaicite:8]{index=8}

# Map, Trials, and Weights

## Source: Map Node Weight Tables + Trial Modifier Library.txt

📊 Map Node Weight Tables + Trial Modifier Library (v0.1 LOCKED)
0) Conventions
Node Types

C = Combat (Normal)

E = Elite

EV = Event

R = Rest

CA = Cache (loot/supplies)

S = Shop/Service

B = Boss

RI = Rival Intrusion (special modifier node; only in Rival contracts)

General rules (global)

Boss always appears as the final node.

Standard / Power / Rival contracts must contain ≥1 Event.

Standard / Rival contracts must contain ≥1 Rest OR ≥1 Shop.

Recovery contracts contain 0 Elites.

Safe lane biases toward R/EV/S; Risk lane biases toward E/CA.

1) Step-by-step Node Weight Tables (2-lane map)

Each step: generate Left and Right node types using lane bias tables below.
(You can treat each lane as a weighted roll per step.)

Lane biases
Safe lane weights (per step roll)

C 35%

EV 25%

R 20%

S 10%

CA 10%

E 0% (unless contract explicitly allows elites in safe lane)

Risk lane weights (per step roll)

C 30%

CA 25%

E 20%

EV 15%

R 5%

S 5%

Clamp rule: if a contract class limits elites, set E=0% and re-normalize.

2) Contract Class Templates (node counts + step weights)
2.1 SHORT Contract (5 nodes total)

Fixed structure: Step 5 = B
Goal: fast side jobs, early pacing.

Required: C ≥ 2

Recommended step plan (1–4):

Step 1: C (100% both lanes)

Step 2: Safe roll (Safe lane table), Risk roll (Risk lane table) but clamp E to 10% max

Step 3: C 70% / EV 30%

Step 4: R 40% / S 20% / EV 25% / CA 15%

Guarantee rules:

Ensure at least one of EV/R/S appears in steps 2–4 (if not, force Step 4 = EV).

2.2 STANDARD Contract (7 nodes total)

Fixed structure: Step 7 = B
Required: EV ≥ 1, R ≥ 1, C ≥ 3, E ≤ 1

Step weights

Step 1: C (100%)

Step 2:

Safe lane: EV 35 / CA 25 / C 25 / R 15

Risk lane: CA 35 / C 30 / EV 20 / E 10 / R 5

Step 3: C 75 / EV 25

Step 4 (recovery step): R 50 / S 25 / EV 15 / CA 10

Step 5: C 70 / EV 15 / CA 15

Step 6 (pressure step):

Safe lane: EV 30 / C 35 / R 20 / S 15

Risk lane: E 25 / CA 25 / C 30 / EV 20

Clamp: if an Elite already spawned earlier, set E=0 here.

If no EV by end of Step 3 → force Step 4 = EV (instead of R).

If no R by end of Step 4 → force Step 4 = R.

2.3 POWER Contract (7 nodes total)

Fixed structure: Step 7 = B
Required: E ≥ 2, EV ≥ 1, C ≥ 2

Step 2: E 60 / CA 20 / EV 20

Step 4:

Safe lane: S 30 / R 30 / EV 20 / CA 20

Risk lane: CA 35 / E 35 / EV 15 / C 15

Step 5: E 60 / C 20 / EV 20

Step 6: S 35 / R 35 / EV 20 / CA 10

If fewer than 2 Elites by Step 5 → force Step 5 = E.

If no EV by Step 4 → force Step 4 = EV (safe lane).

2.4 RECOVERY Contract (5–7 nodes)

Elites: E = 0 always
Purpose: resolve injury/stress hooks, stabilize builds.

Recovery-Short (5 nodes)

Step 2: EV 50 / R 30 / S 20

Step 3: C 60 / CA 25 / EV 15

Step 4: R 55 / S 25 / EV 20

Step 5: B (mini-boss profile; lower lethality)

Recovery-Standard (7 nodes)

Step 2: EV 45 / R 30 / S 25

Step 4: R 50 / S 30 / EV 20

Step 5: C 55 / EV 25 / CA 20

Step 6: R 45 / S 35 / EV 20

Step 7: B

Must include ≥2 of (R, S, EV) in steps 2–6.

2.5 RIVAL Contract (7–8 nodes)

Includes: 1 guaranteed RI node (special)
Required: EV ≥ 1, RI = 1, C ≥ 3, R or S ≥ 1

Rival-Standard (7 nodes)

Step 2: EV 60 / C 25 / CA 15 (rival-themed)

Step 3: C 70 / CA 15 / EV 15

Step 4: RI (100%) ✅ guaranteed

Step 5: C 60 / E 20 / EV 20

Step 7: B (rival-modified boss OR rival as add)

Rival-Extended (8 nodes) (late game / high heat)

Step 1: C

Step 2: EV (rival)

Step 3: C

Step 4: RI

Step 5: C

Step 6: E 50 / CA 25 / EV 25

Step 7: R 45 / S 35 / EV 20

Step 8: B

If E appears in Step 6, Step 7 must be R or S.

3) Cache Trap Chance (risk legibility)

Caches can be “clean” or “trapped.” Trap chance is driven by contract class:

Recovery: 5%

Short: 10%

Standard: 15%

Power: 25%

Rival: 30% (or +10% if Rival Heat high)

Trap outcomes should generate hooks (injury/stress/conflict), not just damage.

4) Shop Stock Weighting (build planning)

When a contract is selected, it has Boss Traits. Shops should bias toward counters:

50% normal stock pool

30% counters for shown Boss Traits

20% “party condition” items (injury/stress/supplies)

This ensures boss preview actually matters.

⚔️ Trial Modifier Library (v0.1)

Trials are optional modifiers offered on Elite nodes (mainly in Power contracts; sometimes in Standard/Rival).

Trial rules

Player can Accept or Decline.

Accepting increases difficulty but improves rewards.

Trials should be legible and build-relevant.

Trial rewards (pick 1 bundle per accepted trial)

Upgrade Bundle: 1 guaranteed card upgrade option + extra reroll

Rare Bundle: chance at rare mod / link unlock token

Economy Bundle: +gold +supplies +shop discount token

Recovery Bundle: heal + reduce injury severity chance (small)

Trial modifiers (15 starter)

Reinforced — Enemies start with extra Armor.

Frenzy — Enemies gain +1 tempo for first 2 turns (speed/initiative equivalent).

Thick Hide — First instance of damage each round is reduced.

Blood Price — Healing is 50% less effective during this node.

Attrition — You draw 1 fewer card for the first 3 turns.

Overtime — After turn X, enemies gain stacking damage/tempo each turn.

Marked — A random teammate starts “Marked” (takes extra threat) until cleansed.

Sunder — Your block/armor generation is reduced (or decays).

Swarm — Adds spawn at fixed intervals.

Counterstance — Enemies counter the first attack each round.

Hexed — First skill card played each round is “taxed” (cost +1 / reduced effect).

Cleanse Ward — Enemies cleanse a debuff the first time they receive one.

No Retreat — Retreat disabled for this node (only for Elite nodes; never for entire run).

Shattered Supplies — Consumables are disabled for this node.

Executioner — Enemies deal extra damage to low-HP targets.

Trial selection weighting (by contract class)

Recovery: 0% (no trials)

Short: 0–10% (rare)

Standard: 20% (on elite only)

Power: 80% (on elite)

Rival: 40% (on elite)

RI (Rival Intrusion) Modifier Library (v0.1)

When RI triggers, it modifies the next node (Step 5 usually). Choose 1 intrusion based on Rival state + current hooks.

Targeted Weakness — targeted teammate starts next combat with a debuff.

Stolen Supplies — lose a small amount of supplies; generate low_supplies hook.

False Orders — first turn: 1 random card is locked/unplayable.

Split Focus — enemies spawn an extra add that pressures your backline.

Rigged Field — hazard present (damage or debuff zone).

Bounty Tag — rival marks a teammate; if they drop, penalty escalates (hook).

Panic Spike — stress increases for one teammate (hook generator).

# Contracts

## Source: Dynamic Contract Board System_P0_UPDATED.txt

📜 Card Game – Dynamic Contract Board System (v0.1 LOCKED)
Purpose

The Contract Board must:

React to player decisions

Reflect party condition and relationship state

Escalate unresolved problems

Deliver meaningful gameplay hooks

Stay modular and expandable

No ambient fluff. No static listings.
The board is generated fresh each hub visit.

1️⃣ Board Structure

Each hub visit generates:

1 Main Contract Slot (if unlocked by story spine)

3 Side Contract Slots

1 Rival Contract Slot (conditional)

If Rival Contract is active:

It replaces one Side slot

Total visible contracts remain 4

Side contracts expire on departure.
Main contracts persist until completed.

2️⃣ Board Signals (Input Data)

Each hub visit collects signals from game state:

2.1 Progress

Act number

Mission tier

Difficulty scaling factor

2.2 Party Condition

Active injuries (minor/major)

Stress states (Calm / Tense / Frayed / etc.)

Active roster

2.3 Relationship State (Hidden)

Recent bond fracture tags

Trust drop tags

Vow created/broken tags

Grief tags

2.4 Economy

Gold total

Debt burden (if system enabled)

Supply level

2.5 Rival State

Hate Level (1–5)

Vengeance Clock (0–6)

Targeted teammate

Rival Heat score

2.6 Player Pattern Flags (optional but supported)

Frequent retreat

Always prioritizes loot

Avoids certain enemy types

Always protects same teammate

These inputs feed contract generation.

3️⃣ Hook System (Core of Reactivity)

After every expedition, the game generates Hooks.

Hooks represent unresolved consequences that must influence the next board.

Example Hook Types

injury_major: teammateId

injury_minor: teammateId

bond_fracture: A,B

trust_drop: teammateId

vow_created: vowType

vow_broken: vowType

rival_targets: teammateId

loot_dispute

grief_active: teammateId

Hook Rule (Mandatory)

Each hub visit must:

Offer at least 2 contracts that directly resolve active hooks

Escalate hooks that go unresolved multiple visits

Escalation Examples:

Ignored injury → worsens tier

Ignored bond fracture → pairing penalties

Ignored rival target → stronger rival intrusion

Ignored vow break → trust penalty compounds

This guarantees meaning.

4️⃣ Contract Slot Filling Algorithm
Step 1: Gather Signals + Hooks

Collect:

Current hooks[]

Rival clock status

Party state

Step 2: Determine Slots
mainSlot = available if story gate open
sideSlots = 3
if rivalClock == 6:
    rivalSlot = active
    sideSlots = 2

Step 3: Fill Slots by Priority

Priority buckets:

Hook-Resolvers (minimum 2 required)

Build-Enablers (upgrades, economy, synergy)

Risk/Reward Spice (wildcard high variance)

Step 4: Personalization Pass

For each generated contract:

Generate hook-aware flavor line

Attach involved teammates (if relevant)

Scale reward and risk by difficulty tier

Step 5: Expiration & Escalation

Side contracts expire on departure

Unresolved hooks increment escalation counters

Escalation modifies future board weightings

5️⃣ Contract Template Categories

We implement 12 reusable templates grouped into categories.

5.1 Recovery Contracts

Purpose: resolve injury/stress hooks

Safe Route Extraction

Field Medic Escort

Defensive Hold

Rewards:

Injury reduction

Stress relief

Minor gold

Risk:

Low–Medium combat

5.2 Power Contracts

Purpose: enable builds

Elite Hunt

Rare Relic Retrieval

Champion Trial

Card upgrade

Gear mod

Link card unlock chance

High combat pressure

5.3 Relationship Contracts

Purpose: resolve bond/trust hooks

Forced Pairing Assignment

Personal Errand

Mediation Run

Bond repair

Trust boost

Unique synergy unlock

Mid difficulty

Narrative consequence if failed

5.4 Economy Contracts

Purpose: gold/supply/debt management

Supply Convoy

High-Risk Bounty

Salvage Sweep

Gold

Supplies

Debt reduction

Injury risk modifier

Timed pressure

5.5 Rival Contracts (Triggered Only)

Trigger Condition:

Variants:

Intercept (fight rival’s unit)

Bait (reward trap)

Rescue (rival targeted teammate)

Rival contract replaces 1 side slot.

If ignored:

Rival Heat increases

Next intrusion stronger

6️⃣ Hook Generation, Escalation, & Resolution (P0 LOCK)

Hooks are the board’s “memory.” They are generated after expeditions and must visibly pressure the next hub board until resolved.

6.1 Hook Object Schema (minimum)

Hook:
- hookId (uuid)
- type (enum)
- subjectIds (array; teammateId(s), vowType, pairId, rivalId, etc.)
- createdAt (act, missionIndex, hubVisitIndex)
- escalationLevel (0–3)
- ignoredCount (int)
- state (active | resolved | suppressed)
- ttl (optional; default none)
- meta (freeform: severity, cause, debtBand, supplyBand, etc.)

Contract (resolution fields):
- resolveHooks[]: list of matchers (type + subjectIds)
- resolveMode: full | partial | convert | suppress
- failOutcome: escalate | mutate | createNewHook
- onComplete: effects (heal, gold, debt, bond/trust deltas, etc.)

6.2 Hook Generation Triggers (post-expedition pass)

Run once after each expedition completes (before next board generation).

A) Injury Hooks
- injury_minor: teammateId
  Create if:
  1) Teammate gained a Tier 1 Minor injury during this expedition (first occurrence), OR
  2) Teammate ends expedition with exactly 1 active Minor and no active injury hook exists for them.
  Meta: severity="minor", countMinor=N, source="knockout|crit|hazard|…"

- injury_major: teammateId
  Create if:
  1) Teammate gained Tier 2 Serious OR Tier 3 Grave injury, OR
  2) Teammate ends expedition with 2+ active Minor injuries (minor stack danger).
  Meta: severity="serious|grave|minor_stack", countMinor=N, hasSerious, hasGrave

Rule of thumb:
- 0–1 Minor => injury_minor
- 2+ Minor OR any Serious/Grave => injury_major

B) Economy / Survival Hooks
- low_supplies
  Create if supplies below “Low” threshold (or “Critical”).
  Meta: supplyBand="low|critical"

- debt_pressure (if enabled)
  Create if debt band crosses threshold OR interest tick occurs.
  Meta: debtBand="warning|heavy|crushing"

C) Relationship Hooks (Hidden meters; visible through behavior + receipts)
- bond_fracture: A,B
  Create when fracture tag recorded (argument, blame, deny relief while stressed, etc.)

- trust_drop: teammateId
  Create when trust drop tag recorded OR vow broken against that teammate.

- vow_created: vowType
  Create when vow flag set.

- vow_broken: vowType
  Create when vow flag broken.

- grief_active: teammateId
  Create when death/near-death event produces grief tag.

D) Rival Hooks
- rival_targets: teammateId
  Create when rival target changes OR an intrusion attempt is recorded.

6.3 What Counts As “Ignored”

A hook is “ignored” if a hub visit occurs and:
- no chosen contract resolves it (full/partial/convert/suppress), AND
- no hub service resolves it (doctor, mediation, debt payment, resupply, etc.).

Then:
- ignoredCount += 1
- escalationLevel = min(3, escalationLevel + 1)

6.4 Escalation Ladder (global effects)

L0 (fresh):
- Resolver contracts appear normally.

L1 (pressure):
- Resolver contracts gain +1 Risk Tag (Timed / Injury Risk / Elite Presence / Rival Presence — context-fit).
- Resolver rewards may get a small boost (never exceed economy bounds).

L2 (consequences begin):
- Apply a soft penalty immediately on hub arrival (type-specific; see 6.5).
- Resolver contracts become harder (enemy tier bump or trial modifier more likely).

L3 (cap / breaking point):
- Board MUST generate at least 1 “Hard Resolver” contract for the hook.
- If still ignored this visit: trigger a forced event on departure or at next expedition start (type-specific).

Hard cap: escalationLevel 3.

6.5 Type-Specific Escalation Effects

A) injury_minor
- L1: recovery contracts add Injury Risk or Timed Extraction tag.
- L2: expedition-start readiness penalty (choose one globally):
  Option A: injured teammate gets -1 Stamina on Turn 1
  Option B: injured teammate starts each combat at -2 HP
- L3: forced dilemma at hub:
  - Sit them out next expedition (no contract required), OR
  - Take the guaranteed Hard Resolver (consumes a slot).

Resolution:
- Full: injury removed or reduced below Minor threshold.
- Partial: escalationLevel -1; injury remains.
- Convert: injury_minor can convert into stabilized state with ttl (optional).
- Suppress: hides hook for 1 visit (rare; not recommended for injuries).

B) injury_major
- L1: increase risk tags on resolver contracts; add “worsening” narrative pressure.
- L2: major readiness penalty during expedition (choose one globally):
  Option A: start each combat with Weakened 1
  Option B: max HP -10% (expedition only)
- L3: forced event:
  - Guaranteed “Medical Crisis” Hard Resolver appears.
  - If ignored: apply a consequence on departure (e.g., +1 Minor injury, or scar check flag).

Resolution:
- Full: Serious->Minor, Grave->Serious, or remove minor stack.
- Convert: injury_major -> injury_minor (stabilized but not healed).
- Partial: reduce escalation by 1 (still major).
- Suppress: not allowed.

C) bond_fracture / trust_drop / vow_broken / grief_active
- L1: resolver contracts gain Mid difficulty + consequence-on-fail tag.
- L2: apply pair/teammate friction penalty at expedition start (pick one globally):
  Option A: involved teammate starts with -1 card draw on Turn 1
  Option B: first Support played on them is weakened/halved
- L3: forced event:
  - “Blowup” or “Mediation” contract guaranteed; if ignored, apply a larger trust/bond hit + receipt.

Resolution:
- Full: mediation/personal errand resolves the hook.
- Convert: vow_broken -> trust_drop (if vow is no longer relevant).
- Partial: escalation -1.
- Suppress: allowed for grief (ttl 1 visit) if story requires quiet.

D) low_supplies / debt_pressure
- L1: increase shop chances for relevant offers (resupply / debt relief).
- L2: apply expedition penalty:
  Option A: -1 consumable charge at expedition start
  Option B: rest effectiveness reduced (heals/stress relief -1)
- L3: forced event:
  - “Shortage” trial modifier auto-attaches to next expedition if ignored.

Resolution:
- Full: resupply / pay down debt below threshold.
- Convert: debt_pressure -> blood_debt (if player takes a debt bargain).
- Partial: escalation -1.
- Suppress: not allowed.

E) rival_targets
- L1: increase Rival Presence tag chance in contracts.
- L2: intrusion chance can trigger mid-expedition modifier.
- L3: if ignored, auto-advance Vengeance Clock by +1 OR force rival slot next board.

Resolution:
- Full: intercept/rescue success.
- Convert: rival_targets -> rival_heat_spike (if bait failed).
- Suppress: allowed (ttl 1 visit) if player took a “lay low” contract.

6.6 Board Guarantees (mandatory)

Per hub visit:
- Minimum 2 hook-resolving contracts must be offered.
- At escalationLevel 3, at least 1 of those must be a Hard Resolver targeted at the level-3 hook.
- Max 1 rival contract per board still applies.

7️⃣ What Player Sees

Each contract shows:

Title

Hook Line (dynamic, state-aware)

Reward Tags (Upgrade / Heal / Gold / Link / Supply)

Risk Tags (Elite / Timed / Injury Risk / Rival Presence)

Involved Teammates (portrait icons)

NO numbers exposed for trust/bond.

8️⃣ Design Constraints

Minimum 2 hook-resolving contracts per board

Max 1 rival contract per board

Max total contracts visible: 4

System must be modular

Templates must be data-driven

9️⃣ Expandability

Future versions can add:

Additional hook types

New contract templates

Seasonal/Act-specific contract pools

Special faction-exclusive contracts

Additional ending integration hooks

The board system must allow insertion of new categories without rewriting generation logic.

## Source: Dynamic Contract Board System.txt

6️⃣ Hook Escalation Rules

Each hook tracks escalationLevel.

escalationLevel++

Escalation impacts:

Contract difficulty

Penalties

Forced events

Hard cap recommended: escalationLevel 3

# Story & Quests

## Source: Dynamic Story + Quest System_P0_UPDATED.txt

# IMPLEMENTATION DIRECTIVE — Dynamic Story + Quest System (RFQE v0.1) — LOCKED

## Goal

Implement a dynamic story + quest system where the player grows attached to their team. Quests and dialogue must create meaningful consequences (relationships, vows, debt, rivalry), not just progression. The system must support:
- A fixed main quest spine (Acts I–III)
- A procedural/reactionary contract layer
- 4 distinct endings (expandable)
- Final boss behavior that changes based on hidden party state

IMPORTANT: Relationship meters (Trust/Bond) are **HIDDEN** from the player. The player learns state from:
- party barks + dialogue event outcomes
- terminal “receipts” logs
- behavior changes (assists, hesitations, refusal, grief, etc.)

No patented “Nemesis System” replication. We use our own Rival Heat + Vengeance Clock + targeted intrusions.

## 1) DATA MODEL (STATE)

### 1.1 Global Campaign State

Maintain these values (persisted in save):
- renown: 0–100
- infamy: 0–100
- favor: { AEGIS: -50..+50, ECLIPSE: -50..+50, SPECTER: -50..+50 }
- debt: { gold: 0..∞, blood: 0..∞ }  // blood debt is “owed cost” flags
- receiptsLog: array of short strings (timestamped)

### 1.2 Party State (per teammate)

Each teammate has:
- id, name
- traits: [traitA, traitB]  // from a small pool (see below)
- need: one of [Respect, Safety, Profit, Control, Redemption, Glory]
- stress: 0–10
- trustToPlayer: 0–20   (HIDDEN)
- injuryTags: []        // existing injury system tags integrate here
- historyTags: []       // small strings, see below
- active: bool (in current party / alive)

### 1.3 Pairwise Relationship State

For each active pair (A,B):
- bond: 0–20 (HIDDEN)
- pairTags: [] (optional, can store in historyTags instead)

### 1.4 Rival State

- rivalId (or multiple later)
- hateLevel: 1–5
- vengeanceClock: 0–6
- targetTeammateId (can be null; choose dynamically)
- rivalHeat: 0–100 (computed or stored)
- rivalFlags: [] (e.g., humiliated, spared, escaped)

## 2) TAGS + TRAITS (MINIMUM SET)

### 2.1 Traits (starter pool: 8)

Protective, Reckless, Greedy, Stoic, Vengeful, MercyProne, Suspicious, Proud

### 2.2 Needs (starter pool: 6)

Respect, Safety, Profit, Control, Redemption, Glory

### 2.3 History Tags (keep active tags small; prefer these)

saved_me, left_me, took_hit_for_me, stole_credit,
split_loot, denied_relief,
kept_promise, broke_vow,
witnessed_mercy, witnessed_cruelty,
blood_debt, medical_debt,
rival_targeted_me, grief

RULE: avoid tag explosion; prefer reusing this set.

## 3) RELATIONSHIP RULES (HIDDEN METERS, VISIBLE EFFECTS)

### 3.1 Bond Changes (A<->B)

Bond increases:
- A protects/heals/shields B (+1)
- A shares resources with B (+1)
- Event choice supports B (+1 to +2)
Bond decreases:
- A abandons B / preventable injury occurs to B (−2)
- A denies relief to B while stressed/injured (−1)
- Event choice blames B (−2)

### 3.2 Trust Changes (Teammate -> Player)

Trust increases:
- Player keeps a vow (+2)
- Player fulfills teammate Need (+1 to +3)
- Player chooses safety over profit at meaningful times (+1)
Trust decreases:
- Player breaks vow (−3)
- Player sacrifices teammate for debt/reward (−3 to −5)
- Player repeatedly ignores injuries/stress (−1 per occurrence)

### 3.3 Stress

Stress increases:
- injuries, near-death, debt pressure, losses (+1..+3)
Stress decreases:
- rest choices, success, “support events” (−1..−3)

### 3.4 Silence Rules (UI/Dialogue)

Stress controls chatter frequency:
- 0–3: normal barks
- 4–6: shorter guarded barks
- 7–10: minimal barks; terminal logs carry tone (silence weapon)

## 4) VOWS SYSTEM (PROMISES THAT MATTER)

A Vow is a boolean flag created by certain dialogue choices.
Examples:
- vow_no_sacrifice
- vow_share_loot
- vow_no_retreat

Mechanics:
- Keeping a vow: add kept_promise tag; +Trust; add a positive receipt
- Breaking a vow: add broke_vow tag; −Trust; +Stress; add a “receipt” that is referenced later

Vows must be readable by Ending Resolver + Final Boss variants.

## 5) EVENT DECK SYSTEM (DYNAMIC DIALOGUE ENGINE)

### 5.1 Event Types (v0.1 minimum)

- BondEvent (two teammates; bond threshold or recent tag)
- LoyaltyTest (one teammate; need/trust/stress driven)
- CampArgument (stress driven; creates tags)
- InjuryFallout (injury tag triggers narrative scar + choice)
- RivalIntrusion (rival heat triggers sabotage; targets relationships)

### 5.2 Event Format

Each event is a data object:
- id, type
- conditions (thresholds/tags/state)
- promptText (terminal voice; short)
- choices: 2–3
  - each choice applies: meter deltas + tags + vow set/break + receipts lines

### 5.3 Event Frequency Control

Per expedition:
- Guarantee at least 1 event
- Cap at 2 events
Choose events based on highest-weight conditions to prevent randomness feeling aimless.

## 6) QUEST SYSTEM (MAIN SPINE + PROCEDURAL LAYER)

### 6.1 Main Quest Spine (Fixed)

- 3 Acts, ~15 core missions total
- These are authored milestones (bosses, reveals, setpieces)
- Progress unlocks by completing required core missions
- Main missions can read party state to swap dialogue, modifiers, intrusions

### 6.2 Procedural Contracts (Reactive)

Between main missions:
- Generate 2–4 contracts
- Player must complete at least 1 to advance
- Others expire/disappear
Contracts are generated from:
- renown/infamy/favor/debt
- party injuries/stress/trust distribution/bond tensions (hidden but computed)
- rival state

Procedural contracts must produce at least 2 of:
- stress shift
- bond/trust opportunity
- debt relief or debt trap
- rival escalation
- scar risk / injury pressure

### 6.3 Hooks Bridge (Consequences That Persist)

Procedural contracts are driven by the Contract Board Hook system.

Hook rules (must match Contract Board spec):
- Hooks are generated after every expedition in a post-expedition pass.
- Hooks represent unresolved consequences (injury, trust fractures, supply/debt pressure, rival targeting).
- Each hub visit must offer at least 2 contracts that can directly resolve active hooks.
- Unresolved hooks escalate (0–3). Escalation increases risk, applies penalties, and can force resolver contracts/events.

Story integration:
- Dialogue/Event Deck choices are allowed to CREATE hooks directly (not just meter deltas).
- Any event outcome that sets tags like broke_vow, denied_relief, split_loot, rival_targeted_me, or creates/advances debt MUST create or update the corresponding hook:
  - broke_vow => vow_broken:vowType (+ optional trust_drop:teammateId)
  - denied_relief / preventable injury => bond_fracture:A,B or trust_drop:teammateId
  - debt bargain => debt_pressure (or convert to blood_debt meta)
  - rival sabotage => rival_targets:teammateId (or rival_heat_spike meta)

Hook generation mapping (minimum triggers; details live in Contract Board doc):
- injury_minor / injury_major: created from injury tiers and minor-stacks after expedition.
- low_supplies: created when supplies cross “low/critical.”
- debt_pressure: created when debt crosses band thresholds or interest ticks.
- bond_fracture / trust_drop / vow_created / vow_broken / grief_active: created from event tags and meter threshold events.
- rival_targets: created when rival target changes or intrusion attempt happens.

IMPORTANT:

- Trust/Bond remain hidden; hooks are the player-facing consequence layer via contracts, risk tags, and terminal receipts.
- Endings + Final Boss variants can read hook history (createdAt, ignoredCount, escalationLevel peaks) as “evidence” even after a hook resolves.

## 7) ENDINGS (4, EXPANDABLE)

Compute end-state variables at finale:

### 7.1 Metrics (normalized 0–100 except FA)

- LI (Loyalty Index): average trustToPlayer across active party scaled to 0–100
- CI (Cohesion Index): average of top 3 pairwise bonds scaled to 0–100
- DB (Debt Burden): 0–100 derived from debt.gold + debt.blood + blood_debt/medical_debt tags
- RH (Rival Heat): 0–100 from hateLevel, vengeanceClock, rivalFlags, recent intrusions
- FA (Faction Alignment): which faction has highest favor and its magnitude

### 7.2 Resolution Priority (IMPORTANT)

Resolve ending in this order:
1) Blood Ledger if DB >= 70
2) Mutiny if LI <= 35 AND DB < 70
3) Liberation if LI >= 65 AND CI >= 55 AND DB < 50
4) Crown otherwise

Endings:
- Liberation: break the circuit / revolt / escape with proof
- Crown: win but become an owned “champion asset”
- Blood Ledger: system collects (forced permanent scar / collateral / vow-break)
- Mutiny: team deserts/refuses/turns mid-finale

EXPANDABLE: new endings can be inserted between steps 2–4 later.

## 8) FINAL BOSS VARIANT MATRIX (C)

One boss identity, 3 phases, each phase picks 1 variant module based on metrics:

### Phase 1 (Social Pressure) — driven by LI/CI

- Variant: CORRUPTION if CI high (temptations, tradeoffs)
- Variant: DISCORD if CI low (assists fail, buffs don’t share, argument triggers)

### Phase 2 (Resource Pressure) — driven by DB/FA

- Variant: LIEN if DB high (collect at HP thresholds: lock healing / force scar choice / seize reward)
- Variant: ESCALATION if DB normal (adds/hazards)
- Optional overlay: FA “help-with-a-cost” injection (buff now, consequence later)

### Phase 3 (Betrayal/Rival Pressure) — driven by RH/LI

- Variant: RIVAL_ENTRY if RH high (rival add replaces a boss mechanic; targets most emotionally relevant teammate)
- Variant: BETRAYAL_CHECK if LI low (lowest-trust teammate hesitates/refuses/temporarily flips for 1 wave)
- Variant: UNITY_TEST if LI high (team can trigger coordinated action if they remain aligned)

Boss behavior changes must be visible through gameplay + dialogue, not a UI meter.

## 9) PRESENTATION (HIDDEN METERS)

Do NOT show Trust/Bond numbers.
Instead show:
- short barks that reference tags (“After the bunker… you still trust me?”)
- terminal receipts logs (“RECEIPT: You promised no one would bleed for debt. Timestamp: …”)
- behavioral tells (assist chance, hesitation, refusal, grief reaction)

## 10) DELIVERABLES TO IMPLEMENT (v0.1)

1) Data structures + save/load integration
2) Event deck runner:
   - condition evaluation
   - weighted selection
   - apply outcomes
   - receipts logging
3) Procedural contract generator:
   - uses state inputs
   - outputs 2–4 contracts
4) Ending Resolver using the priority rules
5) Final boss phase variant selection + hooks
6) Minimal content pack:
   - 12 events (4 bond, 3 loyalty, 3 argument, 2 injury fallout)
   - 12 procedural contract templates
   - 15 mission spine stubs (names + triggers; dialogue can be placeholder)

All systems must be modular and not overwrite unrelated game logic.

## Source: Dynamic Story + Quest System.txt

# IMPLEMENTATION DIRECTIVE — Dynamic Story + Quest System (RFQE v0.1) — LOCKED

## Goal

## 1) DATA MODEL (STATE)

### 1.1 Global Campaign State

### 1.2 Party State (per teammate)

### 1.3 Pairwise Relationship State

### 1.4 Rival State

## 2) TAGS + TRAITS (MINIMUM SET)

### 2.1 Traits (starter pool: 8)

### 2.2 Needs (starter pool: 6)

### 2.3 History Tags (keep active tags small; prefer these)

## 3) RELATIONSHIP RULES (HIDDEN METERS, VISIBLE EFFECTS)

### 3.1 Bond Changes (A<->B)

### 3.2 Trust Changes (Teammate -> Player)

### 3.3 Stress

### 3.4 Silence Rules (UI/Dialogue)

## 4) VOWS SYSTEM (PROMISES THAT MATTER)

## 5) EVENT DECK SYSTEM (DYNAMIC DIALOGUE ENGINE)

### 5.1 Event Types (v0.1 minimum)

### 5.2 Event Format

### 5.3 Event Frequency Control

## 6) QUEST SYSTEM (MAIN SPINE + PROCEDURAL LAYER)

### 6.1 Main Quest Spine (Fixed)

### 6.2 Procedural Contracts (Reactive)

## 7) ENDINGS (4, EXPANDABLE)

### 7.1 Metrics (normalized 0–100 except FA)

### 7.2 Resolution Priority (IMPORTANT)

## 8) FINAL BOSS VARIANT MATRIX (C)

### Phase 1 (Social Pressure) — driven by LI/CI

### Phase 2 (Resource Pressure) — driven by DB/FA

### Phase 3 (Betrayal/Rival Pressure) — driven by RH/LI

## 9) PRESENTATION (HIDDEN METERS)

## 10) DELIVERABLES TO IMPLEMENT (v0.1)

# Expedition & Injury

## Source: expedition_injury_system.md

# Expedition Injury System - Two-Track Health Design

> **Version:** V2 - Expedition-Based
> **Replaces:** Hub-based single duel injury system
> **Core Principle:** HP heals between waves, Injuries persist and compound

## The Core Problem (Solved)

**Original Issue:**
- Expeditions have 3-6 waves with rest opportunities between waves
- If HP fully heals between waves, where's the tension?
- If injuries heal between waves, what's the consequence of getting knocked out?

**Solution:**
- **Two separate tracks:** HP (short-term combat resource) vs Injuries (long-term consequences)
- HP can be restored between waves (30% or 70%)
- Injuries persist entire expedition and create compounding difficulty

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

[Lt. Kira - ECLIPSE]

Supplies: 3
```

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

**DECISION POINT 1:**

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

**DECISION POINT 2:**

WAVE 2 COMPLETE

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Rewards: 20 gold (Total: 35 gold)

[Champion] 19/30 HP (63%) - Healthy
[Lt. Marcus] 0/25 HP ❌ - Sprained Ankle (Minor)
[Lt. Kira] 3/25 HP (12%) ⚠️ - Bruised Ribs (Minor)

Supplies: 2

NEXT WAVE: Supply Tent BOSS (1 elite enemy, high difficulty)

⚠️ WARNING: 2 units injured, low HP across squad
Consider: Full Rest or Retreat

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

**DECISION POINT 3:**

WAVE 3 COMPLETE (BOSS DEFEATED)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Rewards: 30 gold + Rare gear (Total: 70 gold, 1 Rare)

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

Lt. Kira now has 2 MINOR INJURIES:
- Bruised Ribs (start waves -2 HP)
- Strained Arm (random card +1 cost)

ONE MORE KNOCKDOWN RISKS SERIOUS INJURY

**Wave barely cleared:** +25 gold (total: 95 gold)

**DECISION POINT 4:**

WAVE 4 COMPLETE (BARELY)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Rewards: 25 gold (Total: 95 gold, 1 Rare gear)

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

[ Push Forward ] - Near-certain disaster
[ Retreat ] - Keep 95 gold + Rare gear (realistic choice)
```

**Player chooses: RETREAT (smart decision)**

---

### Post-Mission Results

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

## Rest System with Injuries

### Between-Wave Rest Mechanics

#### **PUSH FORWARD** (Free)

- **No healing** to HP
- Injuries persist and apply their effects
- Enemies don't fortify or reinforce
- Next wave starts immediately
- **Use when:** Healthy, want speed, conserve supplies

#### **QUICK REST** (1 Supply)

- **Restore 30% max HP** to all units
- Injuries still reduce effective HP (applied after healing)
  - Example: 70% of 25 HP = 17.5 → 17 HP, minus 2 from "Bruised Ribs" = 15 HP starting next wave
- Remove 1 random temporary status effect from previous wave (Poison, Bleeding cleared between waves anyway)
- Enemies ahead get **+10% HP/damage** (fortification)
- Takes ~10 minutes in-game time
- **Use when:** Moderate damage, supplies available, manageable injuries

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

#### **STRATEGIC RETREAT** (Free, abort mission)

- **Abort expedition entirely**
- Keep all gold and loot from completed waves
- All units restore to 40% HP minimum (recovery floor)
- **All units with Serious injuries roll for escalation:**
  - 50% chance Serious → Grave (permanent)
  - If you retreat with Serious injuries, it's a coin flip
- Mission marked as failed (cannot retry for better rewards)
- **Use when:** Too injured to continue, preserve veteran units, cut losses

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

## Warning System (Player Agency)

### Warning Levels

#### **Level 1: First Minor Injury**

INJURY SUSTAINED

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Lt. Marcus has been injured!

Injury: Sprained Ankle (Minor)
Effect: Movement cards cost +1 Stamina
Duration: Rest of expedition

This injury will persist until expedition ends.
Seek medical attention at hub after mission.
```

#### **Level 2: Second Minor Injury (Escalation Risk)**

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

#### **Level 3: Serious Injury (Critical Risk)**

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

#### **Level 4: Before Potential Grave Injury**

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

### Injury Distribution (Target %)

Across all missions in a campaign:
- **60%** - Missions completed with 0-1 Minor injuries
- **30%** - Missions completed with 2-3 Minor injuries
- **8%** - Missions completed with 1+ Serious injury
- **2%** - Missions resulting in Grave injury (player error)

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

## Open Questions for Playtesting

1. **Minor injury effects:** Are the debuffs impactful enough without being crippling?

2. **Serious injury escalation:** Is 66% chance (from 2 Minor → Serious) the right probability? Or should it be 50% or 100%?

3. **Grave injury threshold:** Should it require 4 knockdowns or only 3? (Currently: 1 Minor → 2 Minor → Serious → Grave = 4 total)

4. **Rest healing %:** Is 30% (Quick) and 70% (Full) balanced? Should it be 25%/60% or 40%/80%?

5. **Injury pool size:** How many unique injuries per tier? Currently targeting 10-12 Minor, 8-10 Serious, 6-8 Grave.

6. **Blood Price cost:** Is 10% max HP permanent loss the right trade-off for instant Serious injury healing?

7. **Retreat injury risk:** Should retreating with Serious injuries have 50% Grave risk, or is that too punishing?

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

**Document Status:** ✅ COMPLETE - Ready for implementation
**Next Steps:**
1. Lock squad combat system (simultaneous turns, positioning)
2. Revise 45 faction cards for multi-target combat
3. Build combat simulator with injury tracking
4. Design 5 mission templates with injury rate targets
5. Implement core injury system and test

*This system preserves expedition tension while allowing functional combat healing, creates meaningful risk/reward decisions, and respects player agency through explicit warnings.*

# Hook Objects & Data Schema

## Source: Hook Object Schema (minimal + future-proof).txt

Hook Object Schema (minimal + future-proof)

Hook

hookId (uuid)

type (enum)

subjectIds (array: teammateId(s), vowType, etc.)

createdAt (act, missionIndex, hubVisitIndex)

escalationLevel (0–3)

ignoredCount (int)

state (active | resolved | suppressed)

ttl (optional; default none)

meta (freeform: severity, cause, rivalId, etc.)

Contract

resolveHooks[] (list of hook type+subject matchers)

resolveMode (full | partial | convert)

failOutcome (escalate | mutate | createNewHook)

onComplete effects (heal, bond, gold, etc.)

1) Hook Generation Triggers (after every expedition)

Hooks are generated in a single pass, post-expedition, using the signals you already list. (Progress, Party Condition, Relationship State, Economy, Rival State). Your board doc already mandates “After every expedition, generate Hooks.” ✅

Injury Hooks (the ones you asked about explicitly)

We map directly onto your injury tiers:

Create when any of these are true:

Teammate gains Tier 1 Minor Wound during expedition (first time this expedition).

Teammate ends expedition with 1 active Minor and no existing injury hook for them.

Meta suggested:

meta.severity = "minor"

meta.countMinor = N (current minor count)

meta.source = "knockout" | "crit" | "hazard" | ...

Teammate gains Tier 2 Serious OR Tier 3 Grave injury.

Teammate ends expedition with 2+ Minor injuries (even if they didn’t roll into Serious yet).

Rationale: your injury system explicitly warns that 2 minors is “danger zone.”

meta.severity = "serious" | "grave" | "minor_stack"

meta.countMinor = N

meta.hasSerious = true/false

meta.hasGrave = true/false

Rule of thumb:

0–1 minor = injury_minor

2+ minor OR serious/grave = injury_major

Other core hook triggers (tight set; everything else can be added later)
low_supplies

Create when:

Supplies below threshold (you already track supply level).
Meta: meta.supplyBand = "low" | "critical"

debt_pressure (if debt enabled)

Debt burden > threshold or interest tick triggered.
Meta: meta.debtBand

A specific pair triggers fracture tag (argument, sacrifice ignored, betrayal flag, etc.)

A trust drop tag is recorded (hidden meter) OR vow broken against that teammate.

vow_created / vow_broken

Vow created/broken tag occurs.

Rival state sets/changes a targeted teammate OR “attempted intrusion” event occurs.

2) Hook Escalation Rules (Level 0 → 1 → 2 → 3)

Your board doc already says: ignored hooks increment escalation counters, cap at 3. Here’s the exact behavior.

What counts as “ignored”

A hook is “ignored” if a hub visit occurs and:

No chosen contract resolves it (full/partial/convert), AND

No hub service resolves it (doctor/shaman, mediation, pay debt, etc.)

Then:

ignoredCount += 1

escalationLevel = min(3, escalationLevel + 1)

Global escalation effects (applies to all hook types)

At each escalation level, apply these general knobs to any contract that targets the hook:

L0 (fresh): normal

Resolver contracts appear with normal risk/reward.

L1: pressure

Resolver contracts gain +1 Risk Tag (Timed / Injury Risk / Elite Presence — pick one that fits).

Resolver rewards get a small boost (player feels the pull).

L2: consequences begin

If hook still active at hub arrival: apply a soft penalty immediately (type-specific below).

Resolver contracts become harder (enemy tier bump / trial modifier more likely).

L3 (cap): forced or breaking point

Board must generate at least 1 “Hard Resolver” contract that is the best/cleanest fix, but costly.

If the player still doesn’t resolve it this visit, trigger a forced event on departure or in next expedition start (type-specific below).

3) Type-Specific Escalation Effects (what actually happens)
A) Injury Hooks
injury_minor escalation

L0: show 1–2 Recovery contracts as normal.

L1: recovery contracts add Injury Risk tag (or “Timed Extraction”).

L2: apply a minor readiness penalty at expedition start:

the injured teammate starts with -1 Stamina on Turn 1 or -2 HP at Wave start (pick one globally).

L3: trigger a mandatory dilemma:

Either: “sit them out this mission” prompt (free)

Or: accept a harder recovery contract as your side slot (board guarantees it).

Resolution for injury_minor:

Completing a recovery contract that includes Heal/Reduce Injury resolves it.

Using hub Doctor to heal resolves it immediately.

If injury naturally heals (sit-out mechanic) resolves at completion.

injury_major escalation

L0: recovery contracts appear, plus “safe route” variants.

L1: increase the chance of Serious worsening events (no new injury tier needed; just tension).

L2: apply a major readiness penalty until resolved:

“start each combat with Weakened 1” or “max HP -10% during expedition only”

L3: forced event:

“Medical Crisis” contract is guaranteed on board (counts as one of the minimum 2 resolver contracts), and if skipped:

the teammate gains an additional Minor (if serious) OR a permanent scar check (if already grave-risk tagged)

Resolution for injury_major:

A contract can resolve via:

Full: reduces injury tier (Serious → Minor) or removes stacked minors

Convert: turns injury_major into injury_minor (e.g., stabilized but not healed)

Hub advanced doctor/shaman options can:

Resolve full or convert depending on service used.

This matches your injury system’s escalation warnings and makes “ignoring injuries” mechanically felt without instantly bricking a run.

B) Relationship Hooks (bond_fracture, trust_drop, vow_broken, grief_active)

L1: resolver contracts gain “Mid difficulty” + “Narrative consequence if failed” tag (you already list this).

L2: apply a pair penalty:

the involved pair starts expeditions with -1 hand size on Turn 1 (or “first support card played is weakened”).

“Blowup” at expedition start: choose one:

lock out “support cards” for that pair for 1 wave

or accept a mediation contract that consumes a side slot

Resolution:

“Mediation Run / Forced Pairing / Personal Errand” contracts resolve.

Failure typically escalates (not resolves).

C) Economy Hooks (low_supplies, debt_pressure)

L1: shop offers include more “Supply” entries (counter-weighting synergy).

L2: apply a consumption penalty:

start expedition with -1 consumable charge / reduced rest effectiveness

“Shortage” adds a Trial modifier to next expedition if still ignored.

Completing supply convoy / salvage resolves.

Paying debt / restocking resolves.

D) Rival Hooks (rival_targets)

This interacts with your existing Rival Clock and Rival Contract trigger (vengeanceClock==6).

L1: increase “Rival Presence” risk tag chance in board generation.

L2: “intrusion chance” can trigger a mid-expedition encounter modifier.

L3: if not addressed, advance Vengeance Clock by +1 automatically (or force a rival slot next board if near cap).

Rescue/intercept/bait contracts resolve or suppress depending on outcome:

Win intercept: resolves

Ignore bait: escalates + heat

Rescue success: resolves + reduces heat

4) Resolution Conditions (how a contract resolves a hook)

Each contract declares exactly what it can do:

Resolution modes

Full resolve: hook removed (state=resolved)

Partial resolve: reduces escalation (escalationLevel -= 1, ignoredCount reset), hook remains

Convert: hook changes type (injury_major → injury_minor, trust_drop → bond_fracture, etc.)

Suppress: hook hidden for N visits but returns (good for rivals)

Completion/Failure mapping (standard)

If contract completed: apply resolveMode

If contract failed:

For “recovery/relationship” contracts: default failOutcome=escalate

For economy/rival: failOutcome=mutate (creates follow-up hook like debt_pressure or rival_heat_spike)

Required rule (keep your board guarantee consistent)

At each hub visit:

Board must offer ≥2 contracts whose resolveHooks[] match active hooks (your doc already mandates this).

If hooks are few, those slots become build-enablers.

Quick Example (shows the whole loop)

Player finishes expedition with:

Teammate Kira has 2 minors → create injury_major: kira (minor_stack)

Supplies low → low_supplies

Rival targets Marcus → rival_targets: marcus

Next hub board must include at least 2 resolvers, e.g.:

Field Medic Escort (resolves injury_major:kira convert→minor)

Supply Convoy (resolves low_supplies)
Plus:

A build enabler

A wildcard / maybe rival slot if clock capped

If player ignores medic contract:

injury_major:kira escalates L0→L1
Repeat ignores:

At L2, Kira starts fights penalized

At L3, a “Medical Crisis” hard resolver is guaranteed and skipping causes a forced consequence

# Simulator Parameters

## Source: SIMULATOR_PARAMETERS_LOCKED.md

# COMBAT SIMULATOR - PARAMETERS LOCKED

> **Status:** ✅ READY TO BUILD
> **Test Scope:** 3 matchups, 50 runs each (150 total simulations)
> **Version:** 1.0 - Initial Validation

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

Total: 10 cards
Avg Cost: 0.9 Stamina
```

## 👾 ENEMY DECK - SCOUT (8 CARDS)

**Scout Stats:**

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

**Document Status:** ✅ LOCKED - Ready for implementation
**Estimated Build Time:** 3-4 hours (combat engine + metrics + output formatting)
**First Results:** Can validate balance assumptions immediately

# Audits & Blind Spots

## Source: COMPLETE SYSTEM AUDIT.txt

Final Polish Pass - Comprehensive System Review
Let me do a thorough analysis of our entire combat system with all refinements, then identify any gaps or final improvements before we lock it.

📋 COMPLETE SYSTEM AUDIT

✅ Combat Math (Foundation)

Damage formula refined (Flat → % → Armor → Min 1)
 Status effects defined (5 types, caps, timing)
 Faction passives integrated (Fortress, Bloodlust, Miasma)
 DoT mechanics clarified (ignores Armor, affected by Enraged)
 Multi-hit interactions validated

Status: SOLID ✓

✅ Card Design (55 Total)

AEGIS: 15 cards (tank/armor focus)
 ECLIPSE: 15 cards (burst/bleed focus)
 SPECTER: 15 cards (control/poison focus)
 Neutral: 10 cards (utility/support)
 All cards redesigned for squad combat (3v3)
 Positioning requirements specified
 Cost distribution balanced (avg 1.8 Stamina)

✅ Squad Combat (3v3)

Simultaneous turn system
 Front/back line positioning
 Card assignment to units
 Shared deck (7 cards drawn/turn)
 Individual HP tracking per unit
 Injury tracking per unit

✅ Expedition Structure (6 Waves)

Multi-wave missions
 Rest system between waves
 HP persistence across waves
 Status effects reset between waves
 Injury accumulation system
 Retreat mechanic

✅ Injury System (Two-Track Health)

HP vs Injury Track separation
 Three tiers (Minor/Serious/Grave)
 Escalation path (1 Minor → 2 Minor → Serious → Grave)
 Warning system (⚠️ at each tier)
 Hub healing options (Natural/Doctor/Shaman)
 Per-unit tracking

✅ New Refinements Added
Transparency & Fairness:

Boss preview before mission (Refinement 1)
 Enemy intent system (Refinement 2)
 Combat log with step-by-step math (Refinement 10)
 Turn undo system (Refinement 9)

Deck Building:

Free card removal service (Refinement 3)
 Draft starting deck system (Refinement 5)
 Deck library save system (Refinement 12)

Tactical Depth:

Enhanced positional tactics (Refinement 6)
 Synergy cards for faction combos (Refinement 7)
 Conditional skill-testing cards (Refinement 8)

Quality of Life:

Comeback mechanics (underdog bonus) (Refinement 4)
 Quick simulation mode (Refinement 11)

Innovation:

Dynamic difficulty adjustment (Refinement 13)
 Veteran unique signature cards (Refinement 14)
 Injury medals system (Refinement 15)

Status: ALL ADDED ✓

🔍 GAP ANALYSIS - What's Missing?
GAP 1: Enemy Design Incomplete ⚠️
Current State:

We have player cards designed
Enemy composition vague ("3 ECLIPSE scouts")
No enemy AI behavior defined
No unique enemy abilities

What We Need:
ENEMY ARCHETYPES (Design 8-10 types)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SCOUT (Wave 1-2):

- HP: 12-15

- AI: Uses basic attacks (Slash, Quick Strike)
- Threat: Low, warm-up enemy
- Drops: 10-15 gold

BRUISER (Wave 2-4):

- HP: 20-25

- AI: Prioritizes front line, applies Bleeding
- Threat: Medium damage dealer
- Drops: 15-25 gold

TANK (Wave 3-5):
- HP: 28-35, Armor 5-8
- AI: Uses Fortify, blocks for allies
- Threat: High HP, protects dangerous allies
- Drops: 20-30 gold

SNIPER (Wave 3-5):

- HP: 15-18

- AI: Targets back line, applies Poison
- Threat: Bypasses front line protection
- Drops: 20-30 gold

CONTROLLER (Wave 4-6):

- HP: 22-28

- AI: Applies Weakened, supports allies
- Threat: Debuffs your squad
- Drops: 25-35 gold

ELITE (Wave 5-6):

- HP: 35-45

- AI: Two actions per turn, unique abilities
- Threat: High, mini-boss
- Drops: 30-50 gold + Rare gear chance

BOSS (Wave 6):

- HP: 50-80

- AI: Multi-phase, telegraphed ultimates
- Threat: Extreme, campaign milestone
- Drops: 50-100 gold + Rare/Epic gear
Action Item: Design 10 enemy types with AI behaviors

GAP 2: Mission Design Incomplete ⚠️
Current State:

We know missions have 6 waves
No actual missions designed
No difficulty progression curve

What We Need:
MISSION ROSTER (Design 10-15 missions)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Mission 1: TUTORIAL - "First Blood"
- Waves: 3 (short intro)
- Enemies: ECLIPSE Scouts only
- Boss: None (ends at Wave 3)
- Difficulty: ★☆☆☆
- Rewards: 50 gold, 1 Common gear, unlock AEGIS cards
- Purpose: Teach basic combat

Mission 2: "Bandit Camp Raid"
- Waves: 4
- Enemies: Mix of ECLIPSE + SPECTER
- Boss: Elite ECLIPSE "Bandit Leader" (Wave 4)
- Difficulty: ★★☆☆
- Rewards: 80 gold, 1 Common + 1 Rare gear
- Purpose: Introduce status effects

Mission 5: "Fortified Outpost"
- Waves: 5
- Enemies: Heavy AEGIS presence (Tanks + Bruisers)
- Boss: AEGIS "Commander" (Wave 5)
- Difficulty: ★★★☆
- Rewards: 120 gold, 1 Rare + 1 Epic (10%)
- Purpose: Test anti-armor strategies

Mission 10: FINAL - "Enemy Stronghold"
- Waves: 6
- Enemies: All factions mixed, Elite spam
- Boss: Multi-phase ECLIPSE/SPECTER hybrid boss
- Difficulty: ★★★★
- Rewards: 200 gold, 1 Epic guaranteed, Campaign complete
- Purpose: Ultimate test
Action Item: Design 10 missions with enemy wave compositions

GAP 3: Ability Costs Not Locked ⚠️
Current State:

Mana system designed (0 start, +1/turn, +1/card)
Ability costs vague ("3-4 Mana" for Ability 1)
No actual abilities finalized

What We Need:
FACTION ABILITIES (Lock all 9)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

AEGIS ABILITIES:

1. Bulwark (3 Mana)
   - Gain Armor = 50% missing HP (max 10)
   - Fast defensive response

2. Aegis Wall (7 Mana)
   - Gain 15 Armor, Apply Weakened 5 to all enemies, Draw 1
   - Ultimate defensive lockdown

ECLIPSE ABILITIES:

1. Blood Rush (3 Mana)
   - Next attack deals +8 damage, Apply Bleeding 2
   - Burst damage enabler

2. Execute (7 Mana)
   - Deal 15 damage, If kill, restore 10 HP
   - High-risk finisher

SPECTER ABILITIES:

1. Enfeeble (3 Mana)
   - Apply Weakened 4, Enemy discards 1 card
   - Hard disruption

2. Virulent Plague (8 Mana)
   - Double all Poison on all enemies, Deal damage = total Poison
   - Poison payoff ultimate
Action Item: Lock all 9 abilities with exact costs

GAP 4: Starting Deck Composition Undefined ⚠️
Current State:

Draft system designed (Refinement 5)
No actual starting deck defined

What We Need:
STARTING DECK TEMPLATES (Per Faction)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

AEGIS CHAMPION (Level 1) - Guaranteed 7 cards:
- 2x Shield Bash
- 2x Brace
- 1x Retaliate
- 1x Iron Will
- 1x Fortify

+ DRAFT 3 from: Shieldwall, Stand Ground, Guardian Stance

ECLIPSE LIEUTENANT (Level 1) - Guaranteed 5 cards:
- 2x Slash
- 1x Quick Strike
- 1x Execution
- 1x Lacerate

+ DRAFT 2 from: Rend, Flurry, Blood Frenzy

SPECTER LIEUTENANT (Level 1) - Guaranteed 5 cards:
- 2x Toxin Dart
- 1x Enfeeble
- 1x Strike
- 1x Corrupt

+ DRAFT 2 from: Siphon, Weaken, Withering Curse

NEUTRAL POOL (Add 2-3):
- Bandage, Reposition, Defend Ally, Prepare, Focus Fire

TOTAL STARTING DECK: 19-22 cards
Action Item: Define exact starting cards per faction

GAP 5: Gear Acquisition Schedule Vague ⚠️
Current State:

24 gear pieces designed
Drop rates estimated ("Common 80% Missions 1-5")
No exact schedule

What We Need:

GEAR DROP SCHEDULE

Mission 1: Iron Gladius (guaranteed first weapon)
Mission 2: Leather Vest (guaranteed first armor)
Mission 3: Iron Ring (guaranteed first accessory)

Mission 4-6: Common pool (random drops)
Mission 7: First Rare guaranteed (choose 1 of 3 shown)
Mission 10: Epic weapon or armor (choose 1 of 2)

Boss Kills: Always drop gear 1 tier higher than mission level
- Mission 5 boss → Rare guaranteed
- Mission 10 boss → Epic guaranteed

Market: All gear available for purchase (except Epics until Mission 8+)
Action Item: Create exact gear unlock/drop schedule

GAP 6: Economy Not Balanced ⚠️
Current State:

Gold rewards estimated (10-100 range)
Costs defined but not validated
No earning/spending balance tested

ECONOMY VALIDATION

INCOME (Per Mission):
- Mission 1-3: 50-80 gold
- Mission 4-7: 80-120 gold
- Mission 8-10: 120-200 gold
- Total Campaign: ~1200 gold earned

SINKS:

- Healing (Minor): 20-30 gold × 10 uses = 200-300
- Healing (Serious): 50-80 gold × 3 uses = 150-240
- Gear purchases: 500-800 (fill gaps in bad RNG)
- Card removal: 50-100 total
- Deck upgrades: 200-300

TOTAL SPENDING: ~1200-1800 gold

BALANCE: Player should be slightly gold-starved (choices matter)
Action Item: Run economy simulation, validate balance

GAP 7: Tutorial Sequence Missing ⚠️
Current State:

Complex systems designed
No onboarding for new players

TUTORIAL MISSION FLOW

Wave 1: Basic Combat
→ Teach: Playing cards, Stamina, HP, Armor
→ Enemy: 1 weak Scout (10 HP)
→ Goal: Play 3 cards, defeat enemy

Wave 2: Status Effects
→ Teach: Bleeding, Weakened
→ Enemy: 1 Scout that applies Bleeding
→ Goal: Apply Weakened, survive Bleeding damage

Wave 3: Positioning
→ Teach: Front/back line, targeting
→ Enemy: 1 front Scout + 1 back Sniper
→ Goal: Reposition unit, attack back line

RESULT: Player understands core loop
THEN: Unlock full game
Action Item: Design tutorial mission with step-by-step guidance

GAP 8: UI/UX Flow Undefined ⚠️
Current State:

Text-based game
No UI mockups or flow diagrams

SCREEN FLOW DIAGRAM

[Main Menu]
   ↓
[Campaign Map] → See all 10 missions, progress
   ↓
[Mission Preview] → Boss info, rewards, difficulty
   ↓
[Squad Selection] → Draft starting deck
   ↓
[Wave 1 Combat] → Card assignment, combat resolution
   ↓
[Decision Point] → Push/Rest/Retreat
   ↓
[Wave 2-6...] → Repeat
   ↓
[Mission Complete] → Rewards, injuries, level up
   ↓
[Hub] → Healing, shopping, deck building, next mission
   ↓
[Repeat]

Combat Screen Layout:
┌─────────────────────────────────────┐
│ ENEMIES:  [Front] [Front] [Back]    │
│           HP/Status shown            │
├─────────────────────────────────────┤
│ YOUR SQUAD: [Front] [Front] [Back]  │
│             HP/Status shown          │
├─────────────────────────────────────┤
│ HAND: [Card1] [Card2] ... [Card7]   │
│ Stamina: 9/9  Mana: 4                │
├─────────────────────────────────────┤
│ [Assign to Unit] [Play] [Undo]      │
│ [End Turn] [Combat Log]              │
└─────────────────────────────────────┘
Action Item: Create UI flow document for implementation

GAP 9: Synergy Card Details Missing ⚠️
Current State:

Synergy card concept defined (Refinement 7)
No actual cards designed

What We Need:
SYNERGY CARDS (Design 10 Total)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

AEGIS + ECLIPSE:

1. Bleeding Edge (2 Stamina)
   - Deal 6 damage. Gain Armor = Bleeding on target (max 8).

2. Fortified Assault (3 Stamina)
   - Deal 10 damage. If you have 10+ Armor, deal 15 instead.

AEGIS + SPECTER:

3. Toxic Fortress (2 Stamina)
   - Gain 6 Armor. Apply Poison 2 to all enemies.

4. Resilient Miasma (3 Stamina)
   - Gain 5 Armor. If any enemy has Poison, gain +5 Armor.

ECLIPSE + SPECTER:

5. Predator Tactics (1 Stamina)
   - Deal 8 damage. If target has Bleeding AND Poison, deal 14.

6. Exsanguinate (3 Stamina)
   - Convert all Poison on target to Bleeding (1:1).

ALL THREE FACTIONS:

7. Triumvirate Strike (4 Stamina) [Ultimate]
   - Deal 12 damage. Gain 8 Armor. Apply Bleeding 2 and Poison 2.
   - Requires all 3 factions in squad.

Unlock: After Mission 5 (mid-game reward)
Drop Rate: Rare (treat as Rare card rarity)
Action Item: Design 10 synergy cards with exact effects

GAP 10: Veteran Signature Cards Undesigned ⚠️
Current State:

Concept defined (Refinement 14)
No actual cards created

What We Need:
VETERAN SIGNATURE CARDS (9 Total - 3 per faction)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

AEGIS SIGNATURES:

Level 10: "Unbreakable Will" (4 Stamina, Exhaust)
- Gain Armor = 100% missing HP (no cap). All allies gain 5 Armor.

Level 12: "Fortress Incarnate" (Passive ability)
- Fortress healing increased from 30% → 50% of Armor gained.

Level 15: "Last Stand" (0 Stamina, Exhaust)
- If below 30% HP, gain 20 Armor, draw 3 cards, +3 Stamina this turn.

ECLIPSE SIGNATURES:

Level 10: "Bladestorm" (4 Stamina, Exhaust)
- Deal 8 damage three times. For each kill, restore 5 HP.

Level 12: "Blood God" (Passive ability)
- Bloodlust bonus increased from +2 → +4 damage.

Level 15: "Execution Mastery" (Passive ability)
- All attacks deal +50% damage to enemies below 30% HP.

SPECTER SIGNATURES:

Level 10: "Miasma Burst" (4 Stamina, Exhaust)
- Apply Poison = total Poison on all enemies (max 12). Draw 2.

Level 12: "Plague Master" (Passive ability)
- Miasma triggers twice (+2 Poison instead of +1).

Level 15: "Death Touch" (2 Stamina, Exhaust)
- Double all status effects on target (Poison, Bleeding, Weakened).

Unlock: Automatically upon reaching level
Uniqueness: Only this specific unit can use their signature
Action Item: Design 9 veteran signature cards

GAP 11: Injury Medal Details Missing ⚠️
Current State:

Concept defined (Refinement 15)
No actual medals designed

What We Need:
INJURY MEDALS (Design 15 Total - 5 per tier)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

MINOR INJURY MEDALS (Earn after 5 missions with injury):

"Bruised Ribs" → "Survivor's Grit"
- Penalty: Start waves -2 HP
- Bonus: +1 Stamina if HP < 50%

"Strained Arm" → "Adapted Fighter"
- Penalty: Random card +1 cost
- Bonus: When that card played, draw 1 card

"Dazed" → "Focused Mind"
- Penalty: Draw -1 first turn
- Bonus: Cards cost -1 Stamina first turn

SERIOUS INJURY MEDALS:

"Deep Cut" → "Scar of Defiance"
- Penalty: Lose 1 HP/turn
- Bonus: Deal +2 damage while < 30% HP

"Broken Leg" → "Immovable"
- Penalty: Back line only
- Bonus: Gain 2 Armor at start of each turn

GRAVE INJURY MEDALS:

"Lost Eye" → "One-Eyed Veteran"
- Penalty: -1 damage all attacks
- Bonus: Enemies target you 50% less

"Bad Knee" → "Grizzled Survivor"
- Penalty: -2 max HP
- Bonus: Start missions with +1 Mana

Unlock: Automatically after 5 missions with same injury
Visual: Unit gains unique icon/badge
Action Item: Design 15 injury medals (5 per tier)

🔧 FINAL IMPROVEMENTS NEEDED

Improvement 1: Resource Generation Needs Tuning
Current:

+3 Stamina/turn (fixed)
+1 Mana/turn + 1/card played + 1/5 damage taken
May be too fast or too slow

Test Needed:

Can you play 2-3 cards/turn consistently? (Goal: yes)
Can you afford abilities by Turn 3-4? (Goal: yes for Ability 1, Turn 5-6 for Ability 2)
Do late turns feel flooded with resources? (Goal: no, should stay tight)

Action: Run simulation, tune generation rates

Improvement 2: Multi-Target Balance Unclear
Current:

AoE cards exist (Phalanx, Toxic Cloud)
No clear power budget vs single-target

Question:

Should "Deal 5 damage to all" (15 total) cost same as "Deal 15 to one"?
Or should AoE be less efficient per-target?

Proposal:

AoE = 60-70% efficiency of single-target
"Deal 10 to one" (2 Stamina) vs "Deal 4 to all" (2 Stamina, 12 total if 3 enemies)
Balances AoE power without making it useless

Action: Define AoE cost multiplier rule

Improvement 3: Turn Timing Cap Needed
Current:

No turn limit
Games could go 20+ turns (stalemate)

Proposal:
TURN LIMIT: 15 turns
After Turn 15:
- All units take 5% max HP damage per turn (both sides)
- "The battle drags on, exhaustion sets in"
- Forces aggression, prevents infinite stall

OR

FATIGUE SYSTEM:

- Turn 10+: All cards cost +1 Stamina
- Turn 15+: All units lose 1 HP/turn
- Forces eventual resolution
Action: Decide turn limit/fatigue system

Improvement 4: Retreat Consequences Undefined
Current:

Retreat = keep rewards, injured units risk Grave injury (50%)
May be too punishing or too generous

Questions:

Should retreat cost gold?
Should retreat fail the mission permanently?
Should retreat have a "retreat counter" (3 retreats = campaign loss)?

RETREAT MECHANICS:

- Keep gold/gear earned so far (as designed)
- All knocked out units: 50% Grave injury risk (as designed)
- Mission marked FAILED (cannot retry for better rewards)
- NEW: Retreat count tracked (3 retreats in 10 missions = Warning: "Morale low")
- If 5 retreats: Campaign difficulty increases permanently (+10% enemy stats)
Action: Define exact retreat mechanics and consequences

Improvement 5: Faction Balance Verification
Current:

Rock-paper-scissors designed (AEGIS > ECLIPSE > SPECTER > AEGIS)
Target: 60/40 to 65/35 matchups
Not validated with actual numbers

Simulate 100 fights: AEGIS vs ECLIPSE
Simulate 100 fights: ECLIPSE vs SPECTER
Simulate 100 fights: SPECTER vs AEGIS
Validate win rates match targets

Action: Run faction matchup simulations, tune HP/damage if needed

Improvement 6: Card Upgrade System Missing
Current:

Cards can be "upgraded" (mentioned in design)
No upgrade mechanic defined

Proposal:
CARD UPGRADE SYSTEM (Hub Service)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

FORGE (Unlock Mission 3)
Upgrade cards for permanent improvements.

Examples:
- Shield Bash → Shield Bash+
  - Before: 5 damage, 3 Armor (1 Stamina)
  - After: 7 damage, 4 Armor (1 Stamina)

- Slash → Slash+
  - Before: 6 damage, Bleeding 1 (1 Stamina)
  - After: 8 damage, Bleeding 2 (1 Stamina)

Cost: 50-100 gold per upgrade
Limit: Can upgrade same card multiple times (Slash → Slash+ → Slash++)
Max upgrade: +2 tiers

Visual: Card shows "+" or "++" suffix
Action: Define upgrade costs and effect increases for all 55 cards

Improvement 7: Mission Failure Consequences Vague
Current:

Retreat = mission failed
What happens if all units die mid-mission?

MISSION FAILURE OUTCOMES:

RETREAT (Player choice):
- Keep rewards earned
- Injured units risk Grave injury
- Mission marked failed

TOTAL PARTY WIPE (All 3 units knocked out):
- Keep 50% of rewards earned
- ALL units gain 1 Serious injury (severe consequence)
- Forced return to hub
- Mission available to retry (but no rewards for waves already cleared)

Campaign continues (no permadeath).
But wipe = very costly (3 Serious injuries to heal).
Action: Define exact wipe consequences

Improvement 8: Boss Loot Table Missing
Current:

Bosses drop "better loot"
No exact table

BOSS LOOT TABLES:

Early Boss (Mission 2, 4):
- Gold: 50-80
- Gear: 1 Common guaranteed + 1 Rare (30% chance)
- Card: Unlock 1 new card for your faction

Mid Boss (Mission 5, 7):
- Gold: 80-120
- Gear: 1 Rare guaranteed + 1 Epic (20% chance)
- Card: Unlock 1 new card OR upgrade token

Late Boss (Mission 8, 9):
- Gold: 120-180
- Gear: 1 Rare + 1 Epic (50% chance)
- Card: Unlock 1 Epic card OR 2 upgrade tokens

Final Boss (Mission 10):
- Gold: 200
- Gear: 1 Epic guaranteed + 1 Epic (second roll, 50%)
- Card: Unlock all remaining cards for your faction
- Special: Campaign victory screen, stats summary
Action: Create exact loot tables for all boss encounters

📊 COMPLETE CHECKLIST - What Needs to Be Locked
TIER 1: CRITICAL (Must Lock Before Simulator)

Lock all 9 faction abilities (exact costs, effects)
 Define 8-10 enemy archetypes (HP, AI, abilities)
 Lock starting deck composition (exact cards per faction)
 Define AoE damage efficiency rule (60-70% of single-target?)
 Lock resource generation rates (confirm 3 Stamina, Mana formula)

TIER 2: HIGH PRIORITY (Before First Playtest)

Design 10 missions (wave compositions, bosses, rewards)
 Create gear drop schedule (which gear, which mission)
 Design 10 synergy cards (faction combos)
 Design 9 veteran signature cards (level 10/12/15)
 Design 15 injury medals (5 per tier)
 Define card upgrade costs and effects (55 cards × 2 upgrade tiers)

TIER 3: MEDIUM PRIORITY (Before V1 Release)

Design tutorial mission (3-wave intro)
 Create UI/UX flow document
 Balance economy (gold income vs sinks)
 Define retreat exact mechanics (consequences, limits)
 Define mission failure mechanics (wipe consequences)
 Create boss loot tables (8-10 bosses)
 Add turn limit or fatigue system

TIER 4: POLISH (Before V2)

Validate faction balance (100 simulations per matchup)
 Tune multi-target balance (test AoE cards)
 Test resource generation (does it feel good?)
 Implement dynamic difficulty (invisible adjustment)

🎯 RECOMMENDED NEXT STEPS

Step 1: Lock The Critical 5 (Today)
Let's finalize these RIGHT NOW:

Lock all 9 abilities - I'll design exact costs/effects
Define 8 enemy archetypes - I'll create stat blocks
Lock starting decks - I'll specify exact 19-22 cards per faction combo
Define AoE efficiency - Let's decide 60% or 70%?
Confirm resources - Keep 3 Stamina/turn, 0 start Mana, +1/turn+card?

Step 2: Design Mission Suite (Tomorrow)

Create 10 missions with exact enemy wave breakdowns
Define boss loot tables
Balance economy across 10 missions

Step 3: Add New Cards (Day 3)

Design 10 synergy cards
Design 9 veteran signatures
Design 15 injury medals

Step 4: Build Simulator (Day 4-5)

Implement combat simulator with all locked systems
Run 100+ simulations
Validate balance

Step 5: Polish Pass (Day 6-7)

Tutorial mission
UI/UX documentation
Final tweaks based on simulation data

❓ DECISION POINTS FOR YOU

Before we lock everything, I need your input on:
Q1: AoE Damage Efficiency?

Option A: 60% efficiency (Deal 4 to all = 12 total vs 10 to one)
Option B: 70% efficiency (Deal 5 to all = 15 total vs 10 to one)
Option C: Same efficiency (Deal 10 to all = 30 total vs 10 to one) [Very strong]

Q2: Turn Limit?

Option A: No limit (games can go 20+ turns)
Option B: 15 turn limit with fatigue damage
Option C: 20 turn limit with fatigue

Q3: Retreat Limit?

Option A: Unlimited retreats (but consequences per retreat)
Option B: 3 retreats per campaign (hard limit)
Option C: 5 retreats, but each increases difficulty

Q4: Starting Mana?

Option A: 0 Mana (abilities Turn 3-4)
Option B: 2 Mana (abilities Turn 2-3)
Option C: 3 Mana (abilities Turn 1-2) [Too fast?]

Tell me your choices and I'll lock the system!

## Source: SYSTEM BLIND SPOT AUDIT .txt

# SYSTEM BLIND SPOT AUDIT

## Card Game – Structural Review (v1)

This document outlines potential blind spots discovered during a full-system audit.
These are not criticisms — they are pressure-test points meant to strengthen the design before scaling.

# 1️⃣ Combat System Blind Spots

## 1.1 Mana Tempo Compression

### Risk:

Mana generation currently scales from:
- +1 passive per turn
- +1 per card played (up to +2)
- +1 per 5 damage taken
- Accessories and gear modifiers
- Faction interactions (e.g., Enraged builds)

In optimized builds, Ability 2 (7 Mana) may become accessible too early (Turn 2 in edge cases).

### Why It Matters:

This compresses combat pacing and may trivialize mid-fight tension.

### Recommendation:

- Implement a **hard cap on Mana gained per turn** (e.g., max 4 from sources, excluding passive).
- Monitor Ability 2 timing across all factions in Act 1 and Act 2.

## 1.2 AEGIS Long-Fight Dominance

### Risk:

Armor:
- Does not decay
- Converts to HP (Fortress)
- Can double
- Has cap increases via gear
- Can scale very high in drawn-out fights

AEGIS may become mathematically dominant in long encounters, especially vs non-poison factions.

### Why It Matters:

If long fights favor AEGIS too strongly, faction triangle balance erodes.

### Recommendation:

- Introduce more **Armor Shred mechanics** in Act 2+ enemies.
- Add boss traits that temporarily reduce Armor caps.
- Ensure ECLIPSE and SPECTER have reliable scaling counters.

## 1.3 Poison Exponential Scaling

### Risk:

SPECTER’s Poison:
- Scales passively via Miasma
- Doubles via Plague Mastery
- Deals immediate and over-time damage

In multi-enemy fights, poison can spike extremely high if allowed to stack uncontested.

### Why It Matters:

Late-game builds may default to poison dominance.

### Recommendation:

- Ensure late-game enemies include partial cleanse or poison mitigation.
- Monitor poison cap reach frequency.
- Track whether poison becomes the safest universal strategy.

# 2️⃣ Gear System Blind Spots

## 2.1 Accessory Slot Overload

### Risk:

Accessory slot currently influences:
- Mana generation
- Card draw
- Stamina
- Status scaling
- Tempo acceleration

It carries more systemic weight than weapon or armor slots.

### Why It Matters:

Optimal builds may revolve around accessory selection more than core identity.

### Recommendation:

- Introduce select Weapons or Armor pieces that affect resource flow.
- Slightly redistribute systemic influence away from accessories.

# 3️⃣ Faction Triangle Stability

### Current Triangle:

- SPECTER > AEGIS

### Blind Spot:

High-skill players may lean toward SPECTER due to:
- Poison bypassing armor
- Control reducing burst threats
- Exponential scaling

### Recommendation:

- Playtest late-game meta for faction drift.
- Ensure cleanse and disruption mechanics remain relevant at high tiers.

# 4️⃣ Contract Board & Hook System

## 4.1 Escalation Legibility

### Risk:

Hooks escalate internally if ignored.

If escalation is not visibly reflected in:
- Contract tone
- Dialogue tension
- Risk tags
- Rival behavior

Players may perceive punishment as arbitrary.

### Recommendation:

- Escalation must be emotionally legible, not numerically visible.
- Contracts should visibly feel more desperate or volatile over time.

# 5️⃣ Economy Pressure Curve

### Observation:

Economy is healthy overall.
Projected deficit encourages meaningful decisions.

### Blind Spot:

Early-game gold totals may feel slightly comfortable unless sinks apply pressure.

### Recommendation:

- Slightly increase early healing or upgrade pressure.
- Ensure Act 1 choices carry opportunity cost.

# 6️⃣ Final Boss Variant System

### Strength:

Final boss phases dynamically react to:
- Loyalty Index
- Cohesion Index
- Debt Burden
- Rival Heat
- Faction Alignment

### Blind Spot:

If consequences are not foreshadowed throughout the campaign, players may feel blindsided by endings like:
- Mutiny
- Blood Ledger

### Recommendation:

- Seed terminal “receipts”
- Add subtle narrative warnings
- Foreshadow consequences long before finale

# 7️⃣ Cross-System Integration Opportunities

| System | Current Links | Potential Deepening |
|--------|---------------|--------------------|
| Combat | Gear, Factions | Relationship tension affecting mid-fight behavior |
| Rival | Contracts | Combat modifiers tied to personal grudges |
| Hooks | Board | Economy penalties or cost modifiers |
| Boss Traits | Shop | Stronger counter-item weighting |

Greater cross-system interaction will elevate the design from layered to fully interwoven.

# 🔥 Top 5 Watchpoints (Priority Monitoring)

1. Mana generation enabling early Ability 2 usage
2. AEGIS armor scaling dominance
3. Poison exponential late-game control
4. Accessory slot systemic overload
5. Final boss feeling unfair without narrative foreshadowing

# Conclusion

The foundation is strong, modular, and unusually deep.

The current blind spots are not structural failures — they are scaling risks.
Addressing them early will prevent late-stage rebalance pain.

This system is capable of supporting high mastery and long-term depth.
Now the focus shifts to stress-testing and cross-system refinement.

# Project TODO

## Source: project_todo_list.md

# Gladiator Card RPG - Project TODO List

> **Last Updated:** Current Session
> **Project Status:** Design Phase - Factions Complete

## ✅ COMPLETED

### Design Documents Locked

- [x] **Campaign loop & hub structure** (healing, conditions, shops, rivals)
- [x] **Conditions system** (Physical/Sickness/Mental with S1/S2/S3 severity)
- [x] **Doctor & Shaman services** (treatment, Blood Price, purification)
- [x] **Rivals system** (intel gathering, vengeance clock, preemptive strikes)
- [x] **Three factions fully designed** (AEGIS, ECLIPSE, SPECTER)
  - Complete stat profiles
  - Faction bonuses (Fortress, Bloodlust, Miasma)
  - 15-card kits per faction
  - Rock-paper-scissors matchup dynamics

## 📌 PINNED FOR LATER EVALUATION

### Resource System (Stamina + Mana)

**Document:** `refined_resource_system.md`

**Status:** Designed but not locked - needs decisions on:
- [ ] Fixed 3 Stamina vs Ramping 1→2→3 Stamina
- [ ] Starting Mana: 0 vs 2-3
- [ ] Faction-specific Mana generation (should each faction have unique triggers?)
- [ ] X-cost cards (spend all remaining resources)
- [ ] Exact Mana costs for abilities

**Why pinned:** Need to lock combat fundamentals and status effects first to properly tune resource numbers.

**Review after:** Combat system rules + Status effect mechanics are locked

## 🔴 TIER 1 - CRITICAL (Must Lock Before Building)

### Currently In Progress

**None** - Need to decide next priority

### Remaining Critical Items

#### 1. Status Effects - Exact Mechanics

**Priority:** HIGH
**Estimated Time:** 1-2 hours
**Blockers:** None

Define precise numbers for:
- [ ] **Bleeding:** Damage per stack per turn, duration, max stacks, decay rules
- [ ] **Armor:** Damage reduction %, decay per turn, max stacks
- [ ] **Weakened:** Damage reduction %, duration, max stacks
- [ ] **Enraged:** Damage boost %, damage taken increase %, duration
- [ ] **Poison:** Damage per stack per turn, duration, max stacks, interaction with Miasma
- [ ] Stacking rules (do status effects stack linearly or cap?)
- [ ] Application timing (start of turn, end of turn, immediate?)
- [ ] Removal rules (decay, cleanse, exhaust)

#### 2. Combat System Rules

**Priority:** HIGH
**Estimated Time:** 2-3 hours
**Blockers:** Should lock status effects first

Define:
- [ ] Turn order system (Speed stat resolution, tiebreakers)
- [ ] Damage calculation formula (base damage + modifiers + armor interaction)
- [ ] Status effect trigger timing (when do DoTs tick? When do buffs apply?)
- [ ] Win/loss conditions (HP = 0, deck out, surrender)
- [ ] Deck size (starting deck, max deck, card limit per unique card)
- [ ] Shuffle rules (when does discard pile shuffle back?)
- [ ] Exhaust pile (permanent removal from fight)
- [ ] Combat item usage rules (when can consumables be used?)

#### 3. Gear System - Complete Design

**Priority:** HIGH
**Estimated Time:** 2-3 hours
**Blockers:** None (can start now)

Create 20-24 gear pieces:
- [ ] 6-8 Weapons (stat bonuses + unique effects)
- [ ] 6-8 Armors (HP/Armor bonuses + unique effects)
- [ ] 6-8 Accessories (utility + resource bonuses)
- [ ] Define faction synergies per gear piece
- [ ] Define rarity tiers (Common/Rare/Epic)
- [ ] Define stat ranges (how much HP/Armor/Damage per piece?)

#### 4. Progression System - Lock Unlock Schedule

**Priority:** MEDIUM-HIGH
**Estimated Time:** 2-3 hours
**Blockers:** Needs gear system locked

Define:
- [ ] Levels 1-15 unlock schedule (which cards at which levels)
- [ ] Gear drop schedule (which gear drops from which missions)
- [ ] Stat growth per level (HP/Armor/Speed/Damage scaling)
- [ ] Shop unlock schedule (when do Doctor/Shaman upgrade tiers unlock?)
- [ ] Campaign upgrade unlock schedule (when are resource upgrades available?)

## 🟡 TIER 2 - IMPORTANT (Before Coding)

#### 5. Mission/Quest Design

**Priority:** MEDIUM
**Estimated Time:** 3-4 hours

- [ ] 15 quest/mission names and themes
- [ ] Opponent factions per mission
- [ ] Difficulty curve (enemy HP/damage scaling)
- [ ] Loot rewards per mission (gold + gear drops)
- [ ] Card unlock placement (which missions unlock which cards)
- [ ] Boss encounters (special mechanics, higher rewards)

#### 6. Balance Spreadsheet

**Priority:** MEDIUM
**Estimated Time:** 2-3 hours
**Blockers:** Needs all mechanics locked first

Create master spreadsheet with:
- [ ] All 45 faction cards (costs, effects, unlock levels)
- [ ] All 20-24 gear pieces (stats, effects, drop locations)
- [ ] All 5 status effects (exact numbers)
- [ ] Damage calculation simulator
- [ ] Synergy matrix (combo identification)
- [ ] DPS calculations per faction/build

#### 7. Economy Design

**Priority:** MEDIUM
**Estimated Time:** 1-2 hours

- [ ] Gold rewards per mission (early/mid/late game)
- [ ] Gear cost bands (Common/Rare/Epic pricing)
- [ ] Doctor service costs (Triage Heal, Treatment, Blood Price)
- [ ] Shaman service costs
- [ ] Market consumable costs
- [ ] Shop upgrade costs (Tier 1→2→3)
- [ ] Campaign upgrade costs (resource upgrades, etc.)

## 🟢 TIER 3 - NICE TO HAVE (Can Add Later)

#### 8. Story/Narrative

**Priority:** LOW
**Estimated Time:** 3-5 hours

- [ ] Why you're fighting (main story arc)
- [ ] Backstory for each faction
- [ ] NPC personalities (Doctor, Shaman, Merchants, Rivals)
- [ ] Mission flavor text
- [ ] Victory/defeat dialogue

#### 9. UI/UX Design

**Priority:** LOW (V1 is text-based)
**Estimated Time:** 2-3 hours

- [ ] Card layout mockups
- [ ] Deck builder interface
- [ ] Combat screen layout
- [ ] Hub navigation structure
- [ ] Progression screen
- [ ] Status effect visual indicators

#### 10. Tutorial/Onboarding

**Priority:** LOW
**Estimated Time:** 2-3 hours

- [ ] Tutorial mission sequence
- [ ] Mechanic explanations (status effects, resources, gear)
- [ ] Practice fights (safe environment to learn)
- [ ] Tooltips and help text

## 🔵 TIER 4 - V2+ (After V1 Ships)

#### Future Enhancements

- [ ] Card art (ChatGPT Plus / Stable Diffusion)
- [ ] Animations
- [ ] Sound effects
- [ ] Expanded campaign story
- [ ] New factions (Season 2 content)
- [ ] PvP mode (if applicable)
- [ ] Daily challenges / roguelike mode

## 📋 REALISTIC TIMELINE (Draft)

### Week 1 (Current): Lock Core Systems

- [x] Factions complete ✅
- [ ] Status effects (2 hours)
- [ ] Combat rules (2 hours)
- [ ] Gear system (3 hours)
- **Total:** ~7 hours remaining this week

### Week 2: Balance & Progression

- [ ] Progression system (3 hours)
- [ ] Mission design (4 hours)
- [ ] Balance spreadsheet (3 hours)
- **Total:** ~10 hours

### Week 3: Economy & Simulator

- [ ] Economy design (2 hours)
- [ ] Test combat simulator in spreadsheet (3 hours)
- [ ] Playtest simulations (3 hours)
- **Total:** ~8 hours

### Week 4-5: Coding V1 (with Claude's help)

- [ ] Combat engine
- [ ] Hub system
- [ ] Progression tracking
- [ ] Basic UI
- **Total:** ~15-20 hours

### Week 6: Playtesting & Balance

- [ ] Internal playtests
- [ ] Balance adjustments
- [ ] Bug fixes
- **Total:** ~10 hours

### Week 7: Ship V1

- [ ] Final polish
- [ ] Release text-based V1

### Week 8-10: Feedback & V2 Planning

- [ ] Collect player feedback
- [ ] Identify pain points
- [ ] Plan V2 features

### Week 11+: V2 with Art

- [ ] Generate card art
- [ ] UI polish
- [ ] New content

## 🎯 IMMEDIATE NEXT STEPS (This Session)

**Choose one:**

### Option A: Lock Status Effects

→ Define exact numbers for Bleeding/Armor/Weakened/Enraged/Poison
→ Sets foundation for combat balance
→ **Estimated time:** 1-2 hours

### Option B: Design Gear System

→ Create 20-24 weapons/armors/accessories
→ Define faction synergies
→ **Estimated time:** 2-3 hours

### Option C: Lock Combat Rules

→ Turn order, damage calc, timing, win conditions
→ Needs status effects for full context
→ **Estimated time:** 2-3 hours

## 📝 NOTES & CONSIDERATIONS

### Design Philosophy Reminders

- **Text-based V1** - no art needed initially
- **Single-player campaign** - not roguelike (persistent progression)
- **Anti-death-spiral mechanics** - condition caps, recovery floor, Blood Price
- **Player agency** - rivals are solvable problems, not unavoidable harassment
- **Balanced factions** - 60/40 to 65/35 matchups (no autowins)

### Key Design Constraints

- 3 factions only (V1)
- 5 status effects
- 15 cards per faction
- 3 gear slots (Weapon/Armor/Accessory)
- 3 condition categories with severity system
- 15 mission campaign

**What would you like to work on next?**

---

# Appendix: Source Inventory

The following files were compiled into this manuscript:

- Boss Trait Library → Locked Implementation Schema.txt — 385 lines
- CARD UI SPEC v1 — PC Web.txt — 197 lines
- CARD_LIBRARY_COMPLETE.md — 911 lines
- COMBAT_SYSTEM_LOCKED_V1.md — 688 lines
- COMPLETE SYSTEM AUDIT.txt — 811 lines
- CORE SYSTEM MASTER SPEC.txt — 407 lines
- Dynamic Contract Board System.txt — 379 lines
- Dynamic Contract Board System_P0_UPDATED.txt — 540 lines
- Dynamic Story + Quest System.txt — 255 lines
- Dynamic Story + Quest System_P0_UPDATED.txt — 288 lines
- ECONOMY_SHOP_SYSTEM_COMPLETE.md — 743 lines
- ENEMY_ARCHETYPES_COMPLETE.md — 662 lines
- FACTION_ABILITIES_COMPLETE.md — 384 lines
- Hook Object Schema (minimal + future-proof).txt — 342 lines
- Map Node Weight Tables + Trial Modifier Library.txt — 345 lines
- SIMULATOR_PARAMETERS_LOCKED.md — 531 lines
- STATUS_EFFECTS_LOCKED_V1.md — 458 lines
- SYSTEM BLIND SPOT AUDIT .txt — 205 lines
- Shop Counter-Weighting .txt — 204 lines
- card game .txt — 485 lines
- combat_system_complete.md — 595 lines
- expedition_injury_system.md — 1027 lines
- faction_design_complete.md — 482 lines
- gear_system_complete.md — 558 lines
- project_todo_list.md — 282 lines
- refined_resource_system.md — 434 lines
- status_effects_complete.md — 441 lines
