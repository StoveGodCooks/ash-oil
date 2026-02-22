# AI Contributors Guide

**For:** Claude Code, Codex, and any AI working on Ash & Oil
**Purpose:** Establish a universal workflow to prevent conflicts and maintain code quality
**Last Updated:** February 21, 2026

---

## Overview

- **What:** Ash & Oil — Tactical card game built in Godot 4
- **Who:** Multiple AI agents (Claude Code, Codex, future contributors)
- **Where:** Local development (`C:/Users/beebo/Desktop/ash-oil`) → GitHub (backup + CI)
- **Why:** Coordinated workflow prevents conflicts, ensures quality, maintains progress

---

## The One-Way Workflow

```
┌─────────────────────────────────────────────────────────────┐
│ LOCAL (C:/Users/beebo/Desktop/ash-oil)                      │
│ ✓ Edit files here                                           │
│ ✓ Test here                                                 │
│ ✓ Commit here                                               │
│ = SOURCE OF TRUTH                                           │
└──────────────────────────┬──────────────────────────────────┘
                           │
                    git push origin main
                           │
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ GITHUB (Backup + CI Testing)                                │
│ ✓ Stores backup copy                                        │
│ ✓ Runs GitHub Actions CI                                    │
│ ✓ Reports validation results                                │
│ ✗ NEVER pull from here                                      │
│ ✗ NEVER edit directly here                                  │
└─────────────────────────────────────────────────────────────┘
```

**Key Rule:** Edit locally → Test locally → Commit locally → Push to GitHub

---

## Standard Workflow for All AIs

### Phase 1: Plan Your Work

Before editing any files:

```bash
# 1. Check the roadmap
cat ROADMAP.md | grep "Phase"

# 2. Check recent commits
git log --oneline -10

# 3. Check what's in progress
grep -r "in_progress" ROADMAP.md
```

**Goal:** Don't duplicate work. Don't edit files another AI just touched.

### Phase 2: Develop Locally

Work in `C:/Users/beebo/Desktop/ash-oil`:

```bash
# 1. Edit files in your editor/IDE
# Godot scene editor, VSCode, your IDE of choice

# 2. Test before committing
python tests/validate_data.py          # Validate data
# (In Godot) Open scenes/TestRunner.tscn and run tests

# 3. Check what you changed
git status
git diff [file]
```

**Goal:** All changes tested and validated locally before touching git.

### Phase 3: Commit & Push

```bash
# 1. Stage changes
git add [files]

# 2. Commit with clear message
git commit -m "type: description"

# Examples:
# git commit -m "feat: add new combat card type"
# git commit -m "fix: correct M05 mission rewards"
# git commit -m "data: update enemy_templates.json"
# git commit -m "docs: update ROADMAP Phase 5"

# 3. Push to GitHub
git push origin main

# GitHub Actions CI runs automatically
```

**Goal:** Clear, descriptive commits that explain what changed and why.

### Phase 4: Monitor CI Results

After pushing, GitHub Actions automatically runs:

- ✅ **validate-data** — JSON syntax and data integrity
- ✅ **lint-gdscript** — GDScript code quality
- ✅ **validate-tests** — Test suite structure (50+ tests)
- ✅ **validate-crossrefs** — Data cross-references (enemies, cards, meters)

**View results:** `https://github.com/StoveGodCooks/ash-oil/actions`

**If CI passes:** ✅ Work is valid. Next task.
**If CI fails:** ❌ Fix locally. Commit again. Re-push. CI runs again.

---

## Conflict Prevention Rules

### DO ✅

- **Work locally** — C:/Users/beebo/Desktop/ash-oil is the only place to edit
- **Test first** — Run validation before committing
- **Communicate in commits** — Write clear, descriptive commit messages
- **Check git log** — See what other AIs have done recently
- **Wait for CI** — All checks must pass before next task
- **Update ROADMAP** — Mark tasks as complete when done
- **Ask when uncertain** — If unclear about a task, ask the human before starting

### DON'T ❌

- **Never edit on GitHub** — GitHub is backup only, not a work space
- **Never pull unless instructed** — Local is source of truth; don't fetch from remote
- **Never work on same file simultaneously** — Coordinate with other AIs first
- **Never ignore CI failures** — If CI fails, fix it before moving on
- **Never commit without testing** — Validation must pass locally first
- **Never create random branches** — All work is on `main`
- **Never force-push** — Use safe git workflows only

---

## File Structure

```
C:/Users/beebo/Desktop/ash-oil/

├── scripts/
│   ├── autoload/           # Singletons: GameState, SaveManager, etc.
│   └── ui/                 # UI screens: MainHub, CombatUI, Shop, etc.
│
├── data/
│   ├── cards.json          # 87+ card definitions
│   ├── missions.json       # M01-M20 main, S01-S14 side missions
│   ├── lieutenants.json    # 8 character definitions
│   └── enemy_templates.json # 26+ enemy types
│
├── scenes/                 # .tscn scene files (Main, Hub, Combat, etc.)
├── tests/                  # Test suites (unit, integration, runner)
├── .github/workflows/      # CI configuration (ci.yml)
│
├── WORKFLOW.md             # Human-focused development guide
├── ROADMAP.md              # Project phases and progress
└── PROJECT_AUDIT.md        # Architecture and component overview
```

---

## Git Quick Reference

### Essential Commands

```bash
# See current status
git status

# View file changes
git diff [filename]

# Stage files
git add [filename]           # Stage specific file
git add .                    # Stage all changes

# Commit
git commit -m "type: message"

# Push to GitHub
git push origin main

# Check history
git log --oneline -10        # Last 10 commits
git log --oneline [file]     # History of specific file

# Check what other AIs did
git log --since="1 hour ago" # Recent commits
```

### Commit Message Types

```
feat:    New feature
fix:     Bug fix
data:    Data changes (JSON files)
docs:    Documentation
refactor: Code restructuring
test:    Test changes
ci:      CI/workflow changes
```

---

## Error Handling

### If CI Fails

```
1. Read error message on GitHub Actions
2. Fix the issue locally
3. Commit again: git commit -m "fix: address CI failure"
4. Push again: git push origin main
5. CI automatically re-runs
```

### If Merge Conflict Occurs

```
1. Contact human coordinator (don't resolve automatically)
2. Wait for guidance before proceeding
3. Never force-push to resolve conflicts
```

### If Uncertain About a Task

```
1. Check ROADMAP.md for phase details
2. Check PROJECT_AUDIT.md for architecture
3. Check git log to see similar work
4. Ask the human before starting
```

---

## Coordination Checklist

Before starting any work:

- [ ] Read ROADMAP.md (what's in progress?)
- [ ] Check git log (what did others just do?)
- [ ] Identify target file(s) (what will I edit?)
- [ ] Test strategy (how will I validate?)
- [ ] Commit message planned (what will I say?)

Before pushing:

- [ ] Local tests pass?
- [ ] Data validation passes?
- [ ] GDScript lint passes?
- [ ] Commit message clear?
- [ ] Only editing intended files?

---

## Current Project Status

**Phase:** 4 (Mission Integration & UI Polish) ✅ COMPLETE
**Next:** Phase 5 (Balance Tuning & Content Refinement)

**Key Files:**
- `ROADMAP.md` — Full 12-phase roadmap
- `WORKFLOW.md` — Human development guide
- `PROJECT_AUDIT.md` — Complete architecture
- `.claude/MEMORY.md` — Project knowledge base

---

## Questions?

**About the workflow?** → Read `WORKFLOW.md`
**About project architecture?** → Read `PROJECT_AUDIT.md`
**About what's next?** → Read `ROADMAP.md`
**About project context?** → Read `.claude/projects/.../MEMORY.md`
**About a specific commit?** → Run `git log -p [commit-hash]`

---

## Summary: The Golden Rule

```
LOCAL is the source of truth.
GitHub is backup + testing only.
Push to validate. Never pull to develop.
All AIs follow the same workflow.
Clear communication prevents conflicts.
```

**When in doubt, ask the human. Better safe than sorry.**
