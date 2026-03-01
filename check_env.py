import os
import sys

print(f"OS: {os.name}")
print(f"Platform: {sys.platform}")
print(f"PATH: {os.environ.get('PATH')}")
print(f"Shell: {os.environ.get('SHELL')}")
print(f"ComSpec: {os.environ.get('COMSPEC')}")
