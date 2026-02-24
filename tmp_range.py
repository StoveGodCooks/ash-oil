import pathlib, sys

start = int(sys.argv[1]) if len(sys.argv) > 1 else 0
end = int(sys.argv[2]) if len(sys.argv) > 2 else start + 80

lines = pathlib.Path('scripts/ui/CombatUI.gd').read_text(encoding='utf-8').splitlines()
for i in range(start, min(end, len(lines))):
    sys.stdout.buffer.write(f"{i+1:04d}: {lines[i]}\n".encode('utf-8', 'replace'))
