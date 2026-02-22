# Ash & Oil — Development Workflow

**Source of Truth:** Local folder `C:/Users/beebo/Desktop/ash-oil`
**Backup & Testing:** GitHub repository (CI/validation only)

---

## Daily Development Cycle

### 1. **Code Locally**
- Edit files in `C:/Users/beebo/Desktop/ash-oil`
- Test in Godot editor (Main scene, TestRunner scene, DevMenu)
- Changes are YOUR source of truth

### 2. **Validate Locally**
```bash
# Run data validation
python tests/validate_data.py

# Run unit tests (in Godot editor or DevMenu)
# Open res://scenes/TestRunner.tscn and run
```

### 3. **Commit & Push**
```bash
cd C:/Users/beebo/Desktop/ash-oil

# Review changes
git status

# Stage changes
git add [files]

# Commit with clear message
git commit -m "type: description (Phase/feature)"

# Push to GitHub (backup + CI testing)
git push origin main
```

### 4. **GitHub Actions CI Runs**
Automatic on push. Check results at: `https://github.com/StoveGodCooks/ash-oil/actions`

**CI validates:**
- ✓ JSON syntax & data integrity (Python)
- ✓ GDScript linting (gdtoolkit)
- ✓ Test suite structure (50+ tests, all extend TestBase)
- ✓ Data cross-references (enemies, cards, lieutenants, meters)

**If CI fails:**
- Fix locally
- Commit & push again
- CI re-runs automatically

---

## When to Pull From GitHub

**Only intentionally pull when:**
1. Codex pushes changes you want to merge
2. You want to review GitHub Actions results
3. You're explicitly syncing with remote

**DO NOT:**
- Use GitHub as primary source (always work local first)
- Auto-sync or auto-pull branches
- Push to branches other than `main`

**Command to manually sync (if needed):**
```bash
# Check remote changes without pulling
git fetch origin

# See what's different
git log main..origin/main

# Merge if desired
git merge origin/main
```

---

## Branch Strategy

- **main** = single source of truth (always deployable)
- No other branches on remote
- Feature work happens directly on `main`
- All commits tested via CI before being considered "done"

---

## Commit Message Format

```
type: short description

Optional longer explanation.

Examples:
- fix: correct mission M05 meter changes
- feat: add NPC relationship system (Phase 6)
- docs: update ROADMAP for Phase 5
- test: add combat logic edge cases
- refactor: simplify MainHub UI layout
```

---

## CI/CD Pipeline

**On every push to main:**
1. Validate JSON syntax (Python)
2. Lint all GDScript files
3. Verify test suite structure
4. Check data cross-references
5. Report results

**All must pass before considering PR/merge ready.**

---

## Workflow Rules

✅ **DO:**
- Edit files locally first
- Test in Godot before committing
- Push after each logical change
- Check CI results after pushing
- Fix failures and re-push

❌ **DON'T:**
- Rely on GitHub as primary source
- Make changes directly on GitHub web editor
- Pull auto-sync from GitHub
- Commit to GitHub without local test
- Push before CI validates

---

## If Something Goes Wrong

**Local changes conflict with GitHub:**
```bash
git fetch origin
git diff main origin/main
# Review differences, then merge if safe
git merge origin/main
```

**Need to revert a commit:**
```bash
# See history
git log --oneline -10

# Revert last commit (safe, creates new commit)
git revert HEAD

# Or reset to previous commit (destructive)
git reset --hard HEAD~1
git push origin main --force  # Only if absolutely necessary
```

---

## Summary

```
You Edit → You Test → You Commit → You Push → GitHub Validates → Check Results
    ↓
   LOCAL = PRIMARY SOURCE
   GITHUB = BACKUP + TESTING
```

Local folder is always the source of truth. GitHub is where we validate and back up.
