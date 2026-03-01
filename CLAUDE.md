# Ash & Oil — Claude Instructions

## Project Identity

**Ash & Oil** is a story-driven turn-based card game in Godot 4.6 (GL Compatibility).
Cassian, an enslaved gladiator, holds a stolen ledger and learns refusal is his only power.
20 main missions, 3 narrative phases (SURVIVAL → HOPE → RESISTANCE), 3 endings (Cult / State / Solo).

**Work location:** `C:\Users\beebo\Desktop\ash-oil` — NOT the OneDrive version.

---

## Current Status

**Version:** v0.10.0 | **Last patch:** `470a746` (Feb 27, 2026)
**Phase 11:** ✅ COMPLETE | **Phase 12:** ⏳ PENDING

**Next work:** Phase 12 — Story & Narrative
- Scene system for text-based intermissions and Act 3 endings (`data/scenes.json` scaffolded)
- Wire mission hooks → branching consequences + journal
- Author ending scenes: Cult / State / Solo
- `NarrativeManager.finalize_ending` for end-of-campaign flow
- Modal presentation (overlay) for scenes with continue/choice buttons
- Portrait integration once assets land

**Known blocker:** Godot headless runner emits RID/ObjectDB leak warnings on exit — investigate before release.

---

## Mandatory Workflow

```bash
# Before starting
git status
godot --headless --path C:\Users\beebo\Desktop\ash-oil -s res://tests/runner/RunTests.gd

# Before every commit
godot --headless --path C:\Users\beebo\Desktop\ash-oil -s res://tests/runner/RunTests.gd  # must pass
gdlint .                      # must pass
python tests/validate_data.py # must pass

# After pushing
# Update START_HERE.md (Current Status + Next Steps) and ROADMAP.md (check off tasks)
# Commit both with: chore: update START_HERE.md after Phase X
```

**Commit format:** `type: description | Phase X` (types: feat, fix, refactor, chore, test, docs)

---

## Non-Negotiable Rules

- **Test-first.** Write the test before the code. Every feature needs unit + integration tests.
- **Never commit failing tests.** Never.
- **No bandage fixes.** Find and fix root cause.
- **No force-push to main.** Ever.
- **Push immediately** after major patches — don't wait for approval.
- **Update START_HERE.md and ROADMAP.md** after every push.

---

## Code Standards

- Max line length: **160 chars** (enforced by gdlint; `max-public-methods` disabled)
- All UI is **programmatic** — no scene editor layouts
- All styling via **UITheme** — no hardcoded colors
- All game logic is **data-driven** — JSON, not hardcoded
- Singletons expose a **clean public API** — `get_thing()` pattern, not direct property access
- Canonical meter names: `renown`, `heat`, `piety`, `favor`, `debt`, `dread`
- Mission IDs: `M01`–`M20` main, `S01`–`S15` side

---

## Architecture

**Singletons (autoload):**
| File | Responsibility |
|------|---------------|
| `scripts/autoload/GameState.gd` | Central state: meters, inventory, progress, narrative flags |
| `scripts/autoload/MissionManager.gd` | Mission lifecycle, rewards, completion |
| `scripts/autoload/CardManager.gd` | Data loader: cards, missions, enemies, gear, lieutenants |
| `scripts/autoload/SaveManager.gd` | JSON save/load to disk |
| `scripts/autoload/NarrativeManager.gd` | Story beats, dialogue, ending logic |

**Key UI scripts:** `scripts/ui/` — Main, MainHub, CombatUI, CardDisplay, DeckBuilder, ShopUI, MetersPanel, MissionBriefer, MissionLog, StoryLog, SceneModal

**Data files (`data/`):** `missions.json`, `cards.json`, `lieutenants.json`, `enemy_templates.json`, `gear.json`, `hooks.json`, `scenes.json`

**Tests:** `tests/runner/RunTests.gd` auto-discovers all `test_*.gd`. All must extend `TestBase`. Current: ~719 assertions.

---

## Game Data Quick Reference

| System | Details |
|--------|---------|
| Combat | Turn-based cards, 5 Command Points/turn, draw 2, max 30-card deck |
| Cards | 87+ across 3 factions: AEGIS, SPECTER, ECLIPSE + NEUTRAL |
| Meters | 6 narrative meters (renown, heat, piety, favor, debt, dread) |
| Lieutenants | 8 recruitable allies, loyalty –100 to +100, 2-unit squad |
| Enemies | 45+ templates |
| Gear | 24 pieces, 3 slots (weapon/armor/accessory), 3 rarities |
| Endings | 3 paths based on final meter values |

---

## Keyboard Shortcuts (CombatUI)

`1-5` play cards | `T` end turn | `R` retreat | `Esc` clear targeting | `Space` skip animation | `-`/`=` animation speed

---

## Running Things

```bash
# Tests
godot --headless --path C:\Users\beebo\Desktop\ash-oil -s res://tests/runner/RunTests.gd

# Lint
gdlint .

# Data validation
python tests/validate_data.py

# Launch game (debug)
godot --debug
```

---

## Before You Leave

1. All tests pass
2. Code pushed
3. START_HERE.md updated (Current Status + Next Steps)
4. ROADMAP.md updated (tasks checked off)
5. Both committed and pushed

**The full reference is in `START_HERE.md`. This file gives you the essentials to start immediately.**
