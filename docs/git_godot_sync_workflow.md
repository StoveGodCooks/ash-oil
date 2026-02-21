# GitHub + Godot update workflow

Yes — your understanding is correct.

## Recommended flow

1. You ask me to make changes in this repository.
2. I commit the changes and open a pull request.
3. You review and merge that pull request on GitHub.
4. On your local machine, open GitHub Desktop and click **Fetch origin** then **Pull origin** on the branch you use in Godot (usually `main`).
5. Godot reads the updated files from disk; then you test in the editor/game.

## Notes

- Pull requests are created in GitHub/Git tools, **not** inside Godot.
- If Godot does not instantly reflect changes, use **Reload Changed Files** or restart the editor.
- Make sure your local Godot project folder is the same Git repository you pulled.
