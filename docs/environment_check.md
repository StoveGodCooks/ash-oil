# Environment Check: Go / Godot and GitHub Files

## Tool availability

- `go` is installed and available:
  - `go version go1.24.3 linux/amd64`
- This project is configured for Godot 4.x (`config/features=PackedStringArray("4.6", "GL Compatibility")` in `project.godot`).
- Godot 4 is installed and available:
  - `godot4 --version` → `4.6.1.stable.official.14d19694e`
  - `godot --version` → `4.6.1.stable.official.14d19694e`
- `godot3` is also still installed, but should not be used for this project.

## GitHub metadata/files in this repository

- There is a `.git/` directory (this is a Git repository).
- There is currently **no** `.github/` directory in this repository.

## Commands used

```bash
go version
sed -n '1,120p' project.godot
python - <<'PY'
import json,urllib.request,re
url='https://api.github.com/repos/godotengine/godot/releases'
rels=json.load(urllib.request.urlopen(url))
for r in rels:
    tag=r['tag_name']
    if re.match(r'^4\.',tag):
        for a in r['assets']:
            n=a['name']
            if 'linux.x86_64' in n and n.endswith('.zip') and 'mono' not in n and 'editor' not in n:
                print(tag,n,a['browser_download_url'])
                raise SystemExit
PY
mkdir -p /opt/godot4
curl -L -o /opt/godot4/godot4.zip https://github.com/godotengine/godot/releases/download/4.6.1-stable/Godot_v4.6.1-stable_linux.x86_64.zip
unzip -o /opt/godot4/godot4.zip -d /opt/godot4
chmod +x /opt/godot4/Godot_v4.6.1-stable_linux.x86_64
ln -sf /opt/godot4/Godot_v4.6.1-stable_linux.x86_64 /usr/local/bin/godot4
ln -sf /opt/godot4/Godot_v4.6.1-stable_linux.x86_64 /usr/local/bin/godot
godot4 --version
godot --version
find . -maxdepth 2 -type d -name '.github' -o -name '.git'
git ls-files
```

## Notes

Using Godot 3 for this repository would be a major-version mismatch and can break project loading/features. Godot 4.x is now set as the default `godot` command in this environment.
