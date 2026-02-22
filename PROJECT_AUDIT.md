# Project Audit
 
## Project Config 
- Name: Ash and Oil 
- Main scene: res://scenes/Main.tscn 
- Renderer: GL Compatibility (desktop and mobile) 
- Physics: Jolt Physics 
 
## Autoloads (Singletons) 
- GameState: res://scripts/autoload/GameState.gd 
- SaveManager: res://scripts/autoload/SaveManager.gd 
- MissionManager: res://scripts/autoload/MissionManager.gd 
- CardManager: res://scripts/autoload/CardManager.gd 
 
## Top-Level Items 
- .editorconfig 
- .gdlintrc 
- .gitattributes 
- .github/ 
- .gitignore 
- .godot/ 
- assets/ 
- data/ 
- gdlintrc 
- icon.svg 
- icon.svg.import 
- project.godot 
- scenes/ 
- scripts/ 
- tests/ 
 
## Scenes (.tscn) 
- scenes/CombatScreen.tscn (script: res://scripts/ui/CombatUI.gd) 
- scenes/DeckBuilder.tscn (script: res://scripts/ui/DeckBuilder.gd) 
- scenes/DevMenu.tscn (script: res://scripts/ui/DevMenu.gd) 
- scenes/Main.tscn (script: res://scripts/ui/Main.gd) 
- scenes/MainHub.tscn (script: res://scripts/ui/MainHub.gd) 
- scenes/ShopUI.tscn (script: res://scripts/ui/ShopUI.gd) 
- scenes/TestRunner.tscn (script: res://tests/runner/TestRunner.gd) 
 
## Scripts (.gd) 
- scripts/autoload/CardManager.gd 
- scripts/autoload/GameState.gd 
- scripts/autoload/MissionManager.gd 
- scripts/autoload/SaveManager.gd 
- scripts/ui/CombatUI.gd 
- scripts/ui/DeckBuilder.gd 
- scripts/ui/DevMenu.gd 
- scripts/ui/Main.gd 
- scripts/ui/MainHub.gd 
- scripts/ui/ShopUI.gd 
 
## Likely Entry Scenes 
- Primary: scenes/Main.tscn (configured as run/main_scene) 
- Test/Dev: scenes/TestRunner.tscn, scenes/DevMenu.tscn
