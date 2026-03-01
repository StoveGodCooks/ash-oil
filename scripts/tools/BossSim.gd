extends SceneTree
## Quick headless simulator for The Collector boss cycle (Act 2).

# Boss scripted actions (from data/enemy_templates.json)
var actions := [
	{"name": "Mark & Shred",      "armor_shred": 3, "damage": 4, "hits": 1, "intent": "Shreds 3 armor, then strikes"},
	{"name": "Collector's Reach", "damage": 4, "hits": 2, "intent": "2x sweeping strikes"},
	{"name": "Tithe Leech",       "damage": 5, "hits": 1, "lifesteal": 4, "intent": "Drains 4 HP on hit"},
	{"name": "Debt Bomb",         "damage": 3, "hits": 1, "true_damage": true, "intent": "Ignores armor"},
]

func _initialize() -> void:
	var scenarios = [
		{"label": "Baseline HP 30 / Armor 0", "hp": 30, "armor": 0, "reflect": 0.0},
		{"label": "Start Armor 5",            "hp": 30, "armor": 5, "reflect": 0.0},
		{"label": "Thorns 50% (2 turns)",     "hp": 30, "armor": 0, "reflect": 0.5},
	]
	print("=== Collector Boss Cycle Simulation ===")
	for s in scenarios:
		_run_scenario(s)
	quit()

func _run_scenario(s: Dictionary) -> void:
	var hp: int = s["hp"]
	var armor: int = s["armor"]
	var reflect: float = s["reflect"]
	var boss_hp: int = 35
	print("\nScenario: %s" % s["label"])
	for i in range(actions.size()):
		var act: Dictionary = actions[i]
		var hits: int = int(act.get("hits", 1))
		var dmg: int = int(act.get("damage", 0))
		var shred: int = int(act.get("armor_shred", 0))
		var lifesteal: int = int(act.get("lifesteal", 0))
		var is_true: bool = bool(act.get("true_damage", false))

		if shred > 0:
			var before = armor
			armor = max(0, armor - shred)
			print(" Turn %d - %s: shred %d armor (%d -> %d)" % [i + 1, act["name"], shred, before, armor])

		var total_actual := 0
		for h in range(hits):
			var absorbed := 0
			if not is_true:
				absorbed = min(armor, dmg)
				armor = max(0, armor - absorbed)
			var actual := dmg - absorbed
			hp = max(0, hp - actual)
			total_actual += actual
			print("   Hit %d/%d: %d dmg (absorbed %d) -> HP %d, Armor %d" % [h + 1, hits, actual, absorbed, hp, armor])
			if reflect > 0.0 and i < 2:  # apply reflect on first 2 turns (Thorns duration)
				var reflected := maxi(1, int(ceil(float(actual) * reflect)))
				boss_hp = max(0, boss_hp - reflected)
				print("     Reflect: %d back -> Boss HP %d" % [reflected, boss_hp])

		if lifesteal > 0 and total_actual > 0:
			var before_hp = boss_hp
			boss_hp = min(35, boss_hp + lifesteal)
			print("   Lifesteal: +%d (Boss %d -> %d)" % [lifesteal, before_hp, boss_hp])

	print(" Result: Player %d HP / %d Armor after cycle; Boss HP %d" % [hp, armor, boss_hp])
