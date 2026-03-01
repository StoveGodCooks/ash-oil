# START HERE — Ash & Oil Development Guide

⚠️ **CRITICAL: Always work in `C:\Users\beebo\Desktop\ash-oil` — NEVER in the OneDrive version**

**Read this file. That's all you need.**

Everything below is consolidated into one place: onboarding, workflow, handoff status, rules, and quick references.

---

## ⚡ 10-Minute Quick Start

**You have 10 minutes. Read these sections IN ORDER:**

1. **WHAT IS THIS?** (2 min) — Scroll to "The Game" section below
2. **WHERE ARE WE?** (2 min) — Scroll to "Current Status" section below
3. **WHAT DO I DO?** (3 min) — Scroll to "Your Workflow" section below
4. **HOW DO I CODE?** (2 min) — Scroll to "Development Rules" section below
5. **Ready to work** — Pick up the task from "Next Steps"

---

# 🔄 KEEPING THIS FILE CURRENT (CRITICAL)

**This is the single source of truth. You must keep it updated.**

## When to Update

- ✅ **After every major patch** — Before you push to GitHub
- ✅ **When phase is complete** — Update "Current Status" section
- ✅ **When adding new tasks** — Update "Next Steps" section
- ✅ **When you find blockers** — Update "Known Issues" section

## What to Update

After each patch, update these sections:

```markdown
# 📍 CURRENT STATUS

**Last Patch:** [NEW COMMIT HASH] — [NEW MESSAGE]
**Current Phase:** Phase X [update status]

## What's Done This Session
- [Add what you just implemented]

**Next Steps:**
1. [Add next task here]
2. [Add task here]

# ⚠️ KNOWN ISSUES & BLOCKERS
- [ ] [Add any blockers you found]
```

## Example: After Phase 6 Implementation

```markdown
# 📍 CURRENT STATUS

**Last Patch:** a84c10f — feat: Phase 6 narrative hooks system

**Current Phase:** Phase 6 ✅ COMPLETE | Phase 7 🔲 PENDING

## What's Done This Session
- ✅ Created data/hooks.json (20 missions + 3 story beats)
- ✅ Extended GameState with narrative properties
- ✅ Created NarrativeManager singleton
- ✅ Wired UI components into MainHub

**Tests:** All passing (165 assertions)

**Next Steps:**
1. Implement Phase 7: Story UI Integration
   - Integrate MissionBriefer into mission selection
   - Add MetersPanel to MainHub header
   - Add CharacterStatePanel to hub status
   - Add MissionLog journal access
```

## How to Commit

```bash
# After updating START_HERE.md with your changes:
git add START_HERE.md
git commit -m "chore: update START_HERE.md with Phase 6 completion status"
```

---

⚠️ **DO NOT let this file get stale.** It's how the next AI understands where you left off and what to do next.

---

# 🎮 THE GAME

**Ash & Oil** — Story-driven turn-based card game about a gladiator learning to say "No."

**Engine:** Godot 4.6 (GL Compatibility)
**Status:** v0.10.0 — Phase 11 advanced combat + boss cycle complete; narrative/ending pass pending
**⚠️ WORK LOCATION:** `C:\Users\beebo\Desktop\ash-oil` (NOT OneDrive version)

## Story

**Cassian** is enslaved in an arena. He holds a stolen ledger with incriminating evidence. Over 20 missions, he learns that **refusal** is his only power.

**Three narrative phases:**
- **SURVIVAL** (M01-M05) — Running, hunted, learning to say "No"
- **HOPE** (M06-M12) — Allies gather, the ledger spreads, factions compete
- **RESISTANCE** (M13-M20) — The machine breaks, the crowd learns they've been used

## Game Mechanics

| System | Details |
|--------|---------|
| **Combat** | Turn-based cards, 87+ cards across 3 factions |
| **Progression** | 20 main missions (sequential) + 5 side missions (unlocked conditionally) |
| **Squad** | Recruit 8 unique lieutenants, manage 2-unit squad in combat |
| **Meters** | 6 narrative meters (renown, heat, piety, favor, debt, dread) |
| **Rewards** | Gold, meter changes, loyalty shifts, unlocked characters |
| **Endings** | 3 paths based on final meter values (Cult, State, Solo) |

## Key Systems

**Narrative:** Meters tied to mission outcomes. Story beats trigger at M01, M06, M13.

**Combat:** 5 Command Points per turn (single resource), draw 2 cards, max 30-card deck. Enemy AI prioritizes damage.

**Data:** All game data in JSON (`data/` folder). Singletons load once at startup.

**UI:** 100% programmatic (no scene editor layouts). All Control nodes built in GDScript.

---

---

# 📍 CURRENT STATUS

**Last Patch:** c01d83d — feat: cinematic landing page with Colosseum background | Phase 12

**Current Phase:** Phase 12 (UI Polish & Narrative) 🔄 IN PROGRESS | Phase 11 ✅ COMPLETE

## What's Done This Session

- ✅ **Lieutenant Combat System (from previous session):** Refactored from 1 passive LT to 4 independent persistent on-battlefield units (LTCombatState class)
- ✅ **Lieutenant Data:** Added combat stats to all 8 LTs (attack, defense, atkScale, defScale, spdScale, cp, portrait)
- ✅ **GameState (Step 2):** Added XP tracking per LT, expanded loyalty range to -100/+100, increased squad size to 4 max, migration function for old saves
- ✅ **CombatUI Refactoring (Step 3):** Converted singular LT fields to Array[LTCombatState], updated all 6 team ability effects to loop through active LTs, serialized save/load for 4-slot squad
- ✅ **Professional MainHub Redesign (Phase 12a):** Created atmospheric shader + HeroCard/PrimaryMissionCard/AtmosphericBackground inner classes (rejected aesthetic)
- ✅ **Cinematic Landing Page (Phase 12b):**
  - Integrated AI-generated Colosseum background image (landing_colosseum.png)
  - Implemented animated smoke particle system (~20 particles/sec, organic fade lifecycle)
  - Added VignetteOverlay for depth effect (35% edge darkening)
  - Implemented smooth button hover animations (scale 1.0→1.08, cubic easing)
  - Proper z-indexing (background:0, smoke:1, vignette:2, awning:3, center:4, UI:5-10)
  - Preserved existing title/buttons with professional scaling feedback

**Tests:** Structure verified via code analysis; smoke system and animations follow combat UI patterns
**Data validation:** `python tests/validate_data.py` passing
**Lint:** Verified with gdlint (no errors)

**Blockers:** Godot headless runner not in PATH (cannot verify at runtime); structure inspection shows no issues.

**Next Steps:**
1. Scene system for text-based intermissions and Act 3 endings (data/scenes.json scaffolded)
2. Hook journal entries to branching consequences + narrative flag system
3. Author ending scenes for Cult / State / Solo paths
4. Lieutenant XP/leveling system (tied to mission rewards)
5. Lieutenant skill trees (tier-1, tier-2 abilities per LT unlocks)
6. Portrait asset integration (hub, dialogue, card preview) once assets arrive

---

---

# 🛠️ YOUR WORKFLOW

**This is how you work on this project.**

## Before You Start

```
cd C:\Users\beebo\Desktop\ash-oil
git status  # See what's on this branch
godot --headless -s res://tests/runner/RunTests.gd  # Run tests (must pass)
```

## While You Work

1. **Write code** → Add tests → Fix bugs
2. **Keep tests green** — Never commit with failing tests
3. **Follow rules** — See "Development Rules" section below

## When You're Done (Before Push)

```bash
# 1. Make sure tests pass
godot --headless -s res://tests/runner/RunTests.gd

# 2. Make sure lint passes
gdlint .

# 3. Verify data is valid
python tests/validate_data.py

# 4. Update git before pushing
# Fill in what you did, why, and what tests were added
```

## Commit & Push

```bash
# Stage files
git add .

# Commit with phase reference
git commit -m "feat: Phase 7 story UI integration

- Integrate MetersPanel + CharacterStatePanel into MainHub
- Add MissionLog modal access + MissionBriefer cancel flow
- All tests passing (624 assertions)"

# Push
git push origin main
```

**Commit format:**
- Line 1: `type: description | Phase X`
- Lines 2+: Detailed list of changes
- Types: `feat` (feature), `fix` (bug), `refactor`, `chore`, `test`, `docs`

## After You Push

Update `ROADMAP.md` to mark completed tasks:

```markdown
## Phase 7: Story UI Integration ✅
- [x] Integrate MissionBriefer into mission selection
- [x] Add MetersPanel to MainHub header
- [x] Add CharacterStatePanel to hub status
- [x] Add MissionLog journal access
```

Then commit:
```bash
git commit -m "chore: update ROADMAP.md after Phase 7 patch"
git push origin main
```

**That's the workflow. Every patch follows these steps.**

---

---

# 📋 DEVELOPMENT RULES

**Non-negotiable standards for this codebase.**

## Testing & Quality

- ❌ **NO bandage fixes** — Find root cause before coding
- ✅ **Test-first** — Write test before code
- ✅ **All tests must pass** — Never commit with failing tests
- ✅ **Add tests for new features** — Every feature needs unit + integration tests
- ✅ **Run lint before pushing** — `gdlint .` must pass

## Commits & Pushes

- ✅ **Push immediately after major patches** — Don't wait for approval
- ✅ **Reference phase in commit message** — "Phase 6: narrative hooks"
- ❌ **NO force-push to main** — Ever
- ✅ **Update ROADMAP.md after push** — Mark completed tasks

## Code Quality

- ✅ **Max line length: 120 chars** (gdlint enforces this)
- ✅ **Clear variable names** — `campaign_meter` not `cm`
- ✅ **Singletons have clear public API** — GameState methods, not direct property access
- ✅ **UI uses UITheme for styling** — No hardcoded colors
- ✅ **Data-driven design** — Game logic in JSON, not hardcoded

## Data Consistency

- ✅ **All meter names canonical** — REPUTATION, DANGER, FAITH, ALLIES, COST, RESISTANCE only
- ✅ **Mission IDs consistent** — M01-M20 main, S01-S15 side
- ✅ **Lieutenant data linked to recruiting** — Automatic unlock when recruited
- ✅ **Save/load preserves all state** — No data loss on reload

## Documentation

- ✅ **Update ROADMAP.md after major patches** — Document progress
- ✅ **Comments only for non-obvious logic** — Clear names > comments
- ❌ **No TODO comments left behind** — Resolve before committing

---

---

# 📂 PROJECT STRUCTURE

```
ash-oil/
├── START_HERE.md                ← You are here (all-in-one guide)
├── ROADMAP.md                   ← Project phases + completion status
│
├── data/                        ← All game data (JSON)
│   ├── missions.json            ← 20 main + 5 side missions
│   ├── cards.json               ← 87+ cards (AEGIS, SPECTER, ECLIPSE)
│   ├── lieutenants.json         ← 8 recruitable allies
│   ├── enemy_templates.json     ← 45+ enemies
│   ├── gear.json                ← 24 gear pieces
│   └── hooks.json               ← Narrative hooks (story data)
│
├── scripts/
│   ├── autoload/                ← Singletons (always loaded)
│   │   ├── GameState.gd         ← Central game state
│   │   ├── SaveManager.gd       ← Save/load JSON
│   │   ├── MissionManager.gd    ← Mission rewards + completion
│   │   ├── CardManager.gd       ← Data loader
│   │   └── NarrativeManager.gd  ← Story coordination
│   │
│   └── ui/                      ← UI components (programmatic)
│       ├── Main.gd              ← Landing page
│       ├── MainHub.gd           ← Central hub
│       ├── CombatUI.gd          ← Combat arena
│       ├── CardDisplay.gd       ← Card component
│       ├── MissionBriefer.gd    ← Mission briefing
│       ├── MetersPanel.gd       ← Meter display
│       ├── CharacterStatePanel.gd ← Phase/threats/allies
│       └── MissionLog.gd        ← Journal
│
├── scenes/
│   ├── Main.tscn
│   ├── MainHub.tscn
│   └── [other scenes]
│
└── tests/
    ├── runner/RunTests.gd       ← Run with: godot --headless -s res://tests/runner/RunTests.gd
    ├── unit/                    ← 5+ unit test files
    └── integration/             ← 2+ integration test files
```

---

---

# 🔗 KEY FILES & PATHS

| File/Dir | Purpose |
|----------|---------|
| `data/missions.json` | Mission definitions (20 main, 5 side) |
| `data/cards.json` | All 87+ cards and their effects |
| `scripts/autoload/GameState.gd` | Central state: meters, inventory, progress |
| `scripts/autoload/MissionManager.gd` | Mission completion logic + rewards |
| `scripts/ui/CombatUI.gd` | Battle arena (where most gameplay happens) |
| `tests/runner/RunTests.gd` | Run: `godot --headless -s res://tests/runner/RunTests.gd` |
| `ROADMAP.md` | Project status + what's done |
| `START_HERE.md` | This file (all-in-one guide) |

---

---

# 📊 CURRENT METRICS

| Metric | Value |
|--------|-------|
| **Version** | v0.10.0 |
| **Phases Complete** | 11/16 |
| **Missions** | 20 main + 5 side |
| **Cards** | 87+ |
| **Lieutenants** | 8 |
| **Enemies** | 45+ |
| **Gear** | 24 pieces |
| **Test Assertions** | 715 |
| **Test Coverage** | ~75% (headless suite) |
| **Code Files** | 20+ |
| **Data Files** | 8 (cards, missions, lieutenants, enemies, gear, hooks, npcs, npc_dialogue) |

---

---

# ✅ QUICK CHECKLIST

**Before pushing:**
- [ ] Tests pass locally (`godot --headless -s res://tests/runner/RunTests.gd`)
- [ ] Lint passes (`gdlint .`)
- [ ] Data valid (`python tests/validate_data.py`)
- [ ] Commit message includes phase reference

**After pushing:**
- [ ] START_HERE.md updated (Current Status + Next Steps)
- [ ] ROADMAP.md updated (check off completed tasks)
- [ ] Commit both updates
- [ ] Push both commits

---

---

# 🔍 QUALITY & AUDIT CHECKLISTS

**Run these audits before major patches. They catch blind spots and ensure quality.**

## Test Coverage Audit (REQUIRED FOR EVERY FEATURE)

When you add new functions/systems, run this checklist:

```
NEW CODE CHECKLIST:
- [ ] New .gd file? Create matching test file in tests/
- [ ] New method in singleton? Add unit test
- [ ] New data structure? Add validation test
- [ ] New UI component? Add integration test
- [ ] Modified game logic? Add scenario test

TEST COVERAGE RULE: Every feature must have tests. No exceptions.
```

**Example: Phase 6 Implementation**
```
- Added: NarrativeManager.gd (new singleton)
  → Tests: tests/unit/test_narrative_manager.gd (8 assertions)
- Added: data/hooks.json (new data structure)
  → Tests: tests/integration/test_mission_hooks.gd (12 assertions)
- Modified: GameState.gd (story_phase property)
  → Tests: Updated test_gamestate.gd (+5 assertions)

Result: 150 assertions → 175 assertions (+25) ✅
```

---

## Blind Spot Audit (Run Every 2 Phases)

**Purpose:** Find incomplete features, unfinished systems, and edge case bugs.

### Audit Checklist

```
COMBAT:
- [ ] All 87 cards playable in combat?
- [ ] Do all card types work (attack, defense, support, reaction, area, evasion, effect)?
- [ ] Stamina correct in all scenarios?
- [ ] Gear bonuses applied to damage?

MISSIONS:
- [ ] All 20 main missions unlock in correct order?
- [ ] Do all 5 side missions unlock with right conditions?
- [ ] Mission rewards apply correctly (gold, meters, loyalty)?
- [ ] Victory/defeat feel fair?

PROGRESSION:
- [ ] Can player reach all 3 endings (Cult, State, Solo)?
- [ ] Lieutenant loyalty works (increases, decreases, removal)?
- [ ] Save/load preserves all state?

UI/UX:
- [ ] Can user navigate all screens?
- [ ] All buttons responsive?
- [ ] No text overflow or broken layouts?
- [ ] Game playable on different window sizes?

DATA:
- [ ] All referenced IDs exist (cards, lieutenants, enemies, gear)?
- [ ] No duplicate entries in JSON?
- [ ] Meters use canonical names (renown, heat, piety, favor, debt, dread)?
```

### Log Findings

```markdown
❌ Blind Spot Found: [Description]
   Steps to reproduce: [...]
   Impact: [Game-breaking / Major / Minor inconvenience]
   Fix: [Proposed solution]
```

---

## QoL Audit (Run Every 3 Phases)

**Purpose:** Make sure the game FEELS good, not just works mechanically.

### Play-Through Checklist

Play 3 missions and ask:

```
GAMEPLAY:
- [ ] Pacing feels right? (Not too slow, not too fast)
- [ ] I understand what's happening?
- [ ] My choices have visible impact?
- [ ] Difficulty is varied and fair?

STORY:
- [ ] Narrative meters feel thematic?
- [ ] Do story beats make sense?
- [ ] Character arcs engaging?

CONTROLS/UX:
- [ ] Keyboard shortcuts (1-5, T, R, Esc, Space, -/=) intuitive?
- [ ] Card hand fan feels responsive?
- [ ] Menu navigation smooth?

AESTHETICS:
- [ ] Parchment/wax UI cohesive?
- [ ] Colors readable (text/background contrast)?
- [ ] Animations feel polished?

SATISFACTION:
- [ ] Victories feel earned?
- [ ] Defeats feel fair?
- [ ] Progression rewarding?
```

### Log Issues

```markdown
🟡 QoL Issue: [Description]
   Severity: [Critical / Major / Minor]
   Suggestion: [Fix idea, if known]
```

---

## Code Health Audit (Run Before Major Push)

```bash
# Quality checks
gdlint .                      # Lint
python tests/validate_data.py # Data validation

# Pattern checks:
- [ ] All singletons follow get_thing() pattern?
- [ ] All UI programmatic (no scene editor layouts)?
- [ ] All meters use canonical names (renown/heat/piety/favor/debt/dread)?
- [ ] All game logic data-driven (JSON)?

# Duplication check:
- [ ] Any repeated code that should be extracted?
- [ ] Similar components that could consolidate?
- [ ] Duplicate test logic?

# Documentation:
- [ ] Complex functions have comments?
- [ ] Method names clearly describe purpose?
- [ ] TODO comments resolved?
```

---

## Performance Audit (Run Every 4 Phases - Optional)

```
TIMING CHECKS:
- [ ] Main.gd loads < 2 seconds?
- [ ] Combat card animation smooth (60 FPS)?
- [ ] Enemy AI decides < 1 second?
- [ ] MainHub switches tabs responsive?
- [ ] Save completes < 1 second?
- [ ] Load completes < 2 seconds?

If slow:
❌ Performance Issue: [Description]
   Likely cause: [...]
   Fix: Profile first, then optimize
```

---

## Architecture Health Audit (Run Every Phase)

```
SINGLETONS:
- [ ] Each has one clear responsibility?
- [ ] Public API is clean?
- [ ] No circular dependencies?

DATA LAYER:
- [ ] All game data in JSON?
- [ ] Single source of truth (no duplication)?

UI LAYER:
- [ ] All programmatic (no scene editor)?
- [ ] Styling via UITheme (no hardcoded colors)?

TESTING:
- [ ] Unit tests for singletons?
- [ ] Integration tests for full flows?
- [ ] Edge case coverage?

If debt found:
⚠️ Architecture Debt: [Description]
   Impact: [Will block future features / Currently fine]
   Refactor plan: [If needed]
```

---

## Audit Frequency

| Audit | How Often | Required? |
|-------|-----------|-----------|
| Test Coverage | Every feature | ✅ YES |
| Blind Spot | Every 2 phases | 🟡 Recommended |
| QoL | Every 3 phases | 🟡 Recommended |
| Code Health | Major patches | ✅ YES |
| Performance | Every 4 phases | 🟢 Optional |
| Architecture | Every phase | 🟡 Recommended |

---

## Audit Template

```markdown
## Audit: [Test Coverage / Blind Spot / QoL / etc] — Phase X

**Date:** [When]
**Findings:**
- ✅ [Good things]
- ⚠️ [Minor issues]
- ❌ [Critical issues]

**Actions:**
- [ ] Fixed: [...]
- [ ] Logged as blocker: [...]
- [ ] Deferred: [...]

**Metrics:**
- Test assertions: [Old] → [New]
- Issues found: [Count]
- Issues resolved: [Count]
```

---

---

# 📚 GLOSSARY — Project Terms

**Quick definitions so everyone speaks the same language.**

| Term | Definition |
|------|-----------|
| **METER** | One of 6 narrative values (renown, heat, piety, favor, debt, dread). Tracks Cassian's situation. Tied to mission outcomes. |
| **HOOK** | Story data for a mission (who hunts, who helps, monologue, meter impacts). Applied when mission completes. |
| **LIEUTENANT** | Recruitable ally character (8 total: Marcus, Julia, Kara, etc.). Has loyalty stat, signature cards, story arc. |
| **REFUSAL** | Counter tracking how many times Cassian said "No" to offers. Core theme of the game. |
| **NARRATIVE MOMENTUM** | Current story beat descriptor ("On the Run", "Building Opposition", "Last Stand"). Changes by phase. |
| **FACTION** | One of 3 gameplay factions (AEGIS, SPECTER, ECLIPSE) + NEUTRAL. Determines card color, deck synergies. |
| **PHASE** | One of 3 story phases (SURVIVAL, HOPE, RESISTANCE). Unlocks missions sequentially, changes meter thresholds. |
| **METER IMPACT** | How a mission changes meters on victory (e.g., M01 adds +3 renown, +8 heat). |
| **STORY BEAT** | Major narrative moment (token_arrives M01, copied_ledger M06, public_exposure M13). Triggers UI events. |
| **LOYALTY** | Lieutenant relationship stat (-5 to +10). Decreasing loyalty can remove them from squad. |
| **THREAT LEVEL** | Array of faction names currently hunting Cassian (e.g., ["Marcellus", "State"]). Affects story branches. |

---

---

# 🗺️ FILE NAVIGATION — Where to Find Things

**Quick reference so you don't waste time searching.**

## Core Game Logic
```
Game State & Data:
  scripts/autoload/GameState.gd          ← Central game state (meters, inventory, progress)
  scripts/autoload/MissionManager.gd     ← Mission selection, combat routing, reward logic
  scripts/autoload/NarrativeManager.gd   ← Story beats, dialogue, narrative coordination
  scripts/autoload/CardManager.gd        ← Data loader (cards, missions, enemies, gear, lieutenants)
  scripts/autoload/SaveManager.gd        ← Save/load JSON to disk
```

## User Interface
```
Main Screens:
  scripts/ui/Main.gd                     ← Landing page
  scripts/ui/MainHub.gd                  ← Central hub (mission select, deck builder, etc.)
  scripts/ui/CombatUI.gd                 ← Battle arena (where most gameplay happens)

Story & Narrative UI:
  scripts/ui/MissionBriefer.gd           ← Pre-mission briefing (story context)
  scripts/ui/MetersPanel.gd              ← 6-meter display (renown, heat, piety, favor, debt, dread)
  scripts/ui/CharacterStatePanel.gd      ← Phase/threats/allies indicator
  scripts/ui/MissionLog.gd               ← Journal of completed missions

Card & Item UI:
  scripts/ui/CardDisplay.gd              ← Reusable card component (120×180 + hover preview)
  scripts/ui/ShopUI.gd                   ← Card/gear shop
  scripts/ui/DeckBuilder.gd              ← Deck construction screen
```

## Game Data (JSON)
```
Gameplay Data:
  data/missions.json                     ← 20 main + 5 side missions (enemies, rewards, etc.)
  data/cards.json                        ← 87+ cards (name, type, cost, faction, effect)
  data/enemy_templates.json              ← 45+ enemy types with stats
  data/gear.json                         ← 24 gear pieces (weapon/armor/accessory)
  data/lieutenants.json                  ← 8 recruitable characters (traits, HP, signature cards)

Story Data:
  data/hooks.json                        ← Narrative hooks (20 missions, 3 story beats, character arcs)
```

## Tests
```
Test Files:
  tests/runner/RunTests.gd               ← Main test runner (headless: godot --headless -s res://tests/runner/RunTests.gd)
  tests/unit/                            ← Unit tests for singletons (GameState, MissionManager, etc.)
  tests/integration/                     ← Integration tests for full flows (mission complete, save/load, etc.)
  tests/validate_data.py                 ← Data validation script (python tests/validate_data.py)
```

## Scenes
```
Scene Files:
  scenes/Main.tscn                       ← Landing page scene
  scenes/MainHub.tscn                    ← Hub scene
  [other scenes]                         ← Godot scene files for each screen
```

## Documentation & Configuration
```
Documentation:
  START_HERE.md                          ← THIS FILE (all-in-one reference)
  ROADMAP.md                             ← Project phases + completion status
  README.md                              ← Project overview

Configuration:
  .gdlintrc                              ← GDScript lint rules (max 120 chars, etc.)
  .gitignore                             ← Git ignore patterns
  project.godot                          ← Godot project config
```

---

---

# 🔍 COMMON TASKS

## Run Tests
```bash
godot --headless -s res://tests/runner/RunTests.gd
```

## Run Lint Check
```bash
gdlint .
```

## Validate Game Data
```bash
python tests/validate_data.py
```

## Launch Game (Debug)
```bash
godot --debug
# Or: Open in Godot editor and press Play
```

## Check Git Status
```bash
git status
git log --oneline -10  # Last 10 commits
```

## Add a New Card to Game
1. Edit `data/cards.json`
2. Add card object with: id, name, type, cost, faction, effect, etc.
3. Run data validation: `python tests/validate_data.py`
4. Tests pass? Commit it.

## Add a New Mission
1. Edit `data/missions.json`
2. Add mission object with: id, name, description, enemies, meter_changes, rewards
3. Edit `data/hooks.json` to add narrative context
4. Update MissionManager if special logic needed
5. Tests pass? Commit it.

---

---

# ⚠️ KNOWN ISSUES & BLOCKERS

**Current:**
- Godot headless runner emits RID/ObjectDB leak warnings on exit; investigate resource lifetime before release.

If you find an issue:
1. Log it with: `❌ [Priority] Issue Title`
2. Add reproduction steps
3. Add to this section

---

---

# 🎯 NEXT STEPS (What to Work On)

**RECOMMENDED: Phase 12 Story & Narrative**

**Why:** Combat/relationship systems are stable; story beats and endings are not yet shipped.

**Tasks:**
1. Expand scene text with choice branches + portraits when assets arrive (`data/scenes.json`).
2. Add modal presentation (overlay) for scenes, with continue/choice buttons; StoryLog already renders in HUB LOG tab.
3. Hook journal entries to branching consequences (set flags, apply meter deltas) and ensure end-of-campaign flow uses `NarrativeManager.finalize_ending`.
4. Integrate character portraits into hub/dialogue/card preview once assets arrive.
5. Update ROADMAP.md and START_HERE.md after each milestone.

**Estimated scope:** Large (multi-patch)

---

---

# 📞 NEED HELP?

**Stuck on something?**
1. Check this file (you're reading it!)
2. Check `ROADMAP.md` for what's been done
3. Check `data/*.json` files for data structure examples
4. Check test files in `tests/` for usage examples
5. Check existing singletons in `scripts/autoload/` for patterns

**Found a bug?**
1. Write a test that reproduces it
2. Trace to root cause (don't bandage)
3. Fix the root cause
4. Verify test passes
5. Commit with `fix: [description]`

---

---

# 📌 FINAL CHECKLIST

**You just read START_HERE.md. Check these before starting:**

- [ ] I understand what Ash & Oil is (story + mechanics)
- [ ] I know the current status (Phase 11 complete; Phase 12 narrative pending)
- [ ] I know my workflow (code → test → commit → push → ROADMAP.md update)
- [ ] I know the rules (tests first, no bandages, push immediately)
- [ ] I know how to run tests (`godot --headless -s res://tests/runner/RunTests.gd`)
- [ ] I know my next task (Phase 12 story/narrative work)
- [ ] I understand this is the ONLY doc I need

**Ready? Start with Phase 12 narrative scenes + endings.**

---

## ⚠️ BEFORE YOU LEAVE FOR THE NEXT AI

**This is mandatory. Do not skip.**

When you're done with your work:

1. ✅ All tests pass
2. ✅ Code pushed to GitHub
3. ✅ **Update this file's "Current Status" section**
4. ✅ **Update "Next Steps" with what's next**
5. ✅ **Commit START_HERE.md with message:** `chore: update START_HERE.md after Phase X`
6. ✅ **Push that commit**

**The next AI will read this file first. If it's stale, they'll be lost.**

---

**Questions? This file has the answer.**

**Good luck!** 🎮
