extends Node
## Card and Lieutenant data manager (Autoload Singleton)

var cards_data: Dictionary = {}
var lieutenants_data: Dictionary = {}
var enemy_templates: Dictionary = {}
var gear_data: Dictionary = {}

func _ready() -> void:
	_load_cards()
	_load_lieutenants()
	_load_enemy_templates()
	_load_gear()
	var status_msg = "CardManager ready: %d cards, %d lieutenants, %d enemies, %d gear" % [
		cards_data.size(), lieutenants_data.size(), enemy_templates.size(), gear_data.size()
	]
	print(status_msg)

func _load_cards() -> void:
	var path = "res://data/cards.json"
	if not FileAccess.file_exists(path):
		push_error("cards.json not found")
		return
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.new()
	if json.parse(file.get_as_text()) == OK:
		cards_data = json.data

func _load_lieutenants() -> void:
	var path = "res://data/lieutenants.json"
	if not FileAccess.file_exists(path):
		push_error("lieutenants.json not found")
		return
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.new()
	if json.parse(file.get_as_text()) == OK:
		lieutenants_data = json.data

func _load_enemy_templates() -> void:
	var path = "res://data/enemy_templates.json"
	if not FileAccess.file_exists(path):
		push_error("enemy_templates.json not found")
		return
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.new()
	if json.parse(file.get_as_text()) == OK:
		enemy_templates = json.data

func _load_gear() -> void:
	var path = "res://data/gear.json"
	if not FileAccess.file_exists(path):
		push_error("gear.json not found")
		return
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.new()
	if json.parse(file.get_as_text()) == OK:
		gear_data = json.data

func get_enemy(id: String) -> Dictionary:
	return enemy_templates.get(id, {})

func get_mission_enemies(mission_id: String) -> Array:
	var mission = MissionManager.get_mission(mission_id)
	var enemy_ids: Array = mission.get("enemies", ["warrior_a", "warrior_b"])
	var act: int = int(mission.get("act", 1))
	var mission_num: int = 1
	if mission_id.begins_with("M") and mission_id.length() >= 3:
		mission_num = maxi(1, mission_id.substr(1).to_int())
	elif mission_id.begins_with("S"):
		mission_num = 6
	var per_act_idx: int = mission_num
	match act:
		2:
			per_act_idx = maxi(1, mission_num - 7)
		3:
			per_act_idx = maxi(1, mission_num - 14)
	var hp_scale: float = 1.0 + float(act - 1) * 0.22 + float(per_act_idx - 1) * 0.04
	var dmg_scale: float = 1.0 + float(act - 1) * 0.16 + float(per_act_idx - 1) * 0.03
	var armor_bonus: int = maxi(0, act - 1) + int(floor(float(per_act_idx - 1) / 3.0))
	var result = []
	for eid in enemy_ids:
		var tmpl = get_enemy(eid)
		if not tmpl.is_empty():
			var tuned_enemy: Dictionary = tmpl.duplicate()
			var base_hp: int = int(tuned_enemy.get("hp", 1))
			var base_armor: int = int(tuned_enemy.get("armor", 0))
			var base_damage: int = int(tuned_enemy.get("damage", 1))
			tuned_enemy["hp"] = maxi(1, int(round(float(base_hp) * hp_scale)))
			tuned_enemy["max_hp"] = int(tuned_enemy["hp"])
			tuned_enemy["armor"] = maxi(0, base_armor + armor_bonus)
			tuned_enemy["damage"] = maxi(1, int(round(float(base_damage) * dmg_scale)))
			result.append(tuned_enemy)
	return result

func get_card(id: String) -> Dictionary:
	return cards_data.get(id, {})

func get_lieutenant(lt_name: String) -> Dictionary:
	return lieutenants_data.get(lt_name, {})

func get_gear(gear_id: String) -> Dictionary:
	return gear_data.get(gear_id, {})

func get_starter_deck() -> Array:
	## 15-card starter deck tuned for Phase 9 pacing and teaching core mechanics.
	return [
		"card_027", "card_027",                          # 2x Quick Jab (free poke)
		"card_001", "card_001", "card_001", "card_001",  # 4x Veteran's Strike (core attack)
		"card_077", "card_077",                          # 2x Focused Strike (stronger finisher)
		"card_028", "card_028",                          # 2x Steady Stance (free defense)
		"card_002", "card_002",                          # 2x Shield Bash (armor + utility)
		"card_029",                                      # 1x Mending Potion (small heal)
		"card_033", "card_033",                          # 2x First Aid (reliable sustain)
		"card_026", "card_030",                          # 1x Parry, 1x Iron Skin (reactive + scaling defense)
	]

func save_card(card_id: String, card_data: Dictionary) -> bool:
	## Save a single card back to cards.json
	cards_data[card_id] = card_data
	return _write_cards_to_file()

func reload_cards() -> void:
	## Reload cards.json from disk
	_load_cards()
	print("✓ Cards reloaded: %d cards" % cards_data.size())

func _write_cards_to_file() -> bool:
	## Write cards_data back to cards.json
	var path = "res://data/cards.json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open cards.json for writing")
		return false

	# Convert to JSON and write (indented for readability)
	var json_string = JSON.stringify(cards_data, "\t")
	file.store_string(json_string)
	print("✓ Saved card: cards.json updated")
	return true


