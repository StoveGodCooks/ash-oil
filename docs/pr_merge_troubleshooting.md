# PR merge troubleshooting (GitHub)

If GitHub says you cannot merge, check the PR status badge first.

## What your screenshot means

Your pull request shows a red **Closed** state. A closed PR cannot be merged.

## How to recover

1. Open your branch in GitHub.
2. Create a **new pull request** from the same branch into `main`.
3. If GitHub reports conflicts, click **Resolve conflicts** and keep these code choices:
   - In `scripts/ui/CombatUI.gd`, keep the Godot 4 typed enum form:
     - `TextServer.AutowrapMode.AUTOWRAP_WORD`
   - Keep victory rewards centralized via `MissionManager.complete_mission("M01")`.
4. Mark conflicts resolved and complete the merge.

## If GitHub still blocks merge

- Ensure required checks are green.
- Ensure branch is up to date with `main`.
- Verify no conflict markers remain in files (`<<<<<<<`, `=======`, `>>>>>>>`).

## GitHub Desktop flow

1. Fetch origin.
2. Checkout your working branch.
3. Merge `main` into your branch.
4. Resolve conflicts locally, commit.
5. Push branch, refresh PR, merge.
