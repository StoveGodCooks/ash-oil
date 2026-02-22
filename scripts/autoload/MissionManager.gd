extends Node
## Mission manager (Autoload Singleton)

var missions_data: Dictionary = {}
var gear_rng: RandomNumberGenerator = RandomNumberGenerator.new()
var last_reward: Dictionary = {}

# ============ SIGNALS ============
signal mission_completed(mission_id: String)

func _ready() -> void:
	randomize()
	gear_rng.randomize()
	_load_missions()

func _load_missions() -> void:
	var path = "res://data/missions.json"
	if not FileAccess.file_exists(path):
		print("missions.json not found - will be created later")
		return
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.new()
	if json.parse(file.get_as_text()) == OK:
		missions_data = json.data
		print("Loaded %d missions" % missions_data.size())

func get_mission(id: String) -> Dictionary:
	return missions_data.get(id, {})

func get_available_missions() -> Array:
	var available = []
	for id in GameState.unlocked_missions:
		if id not in GameState.completed_missions:
			available.append(id)
	return available

func start_mission(id: String) -> bool:
	if GameState.is_mission_available(id):
		GameState.current_mission_id = id
		return true
	return false

func complete_mission(id: String, outcome: String = "victory") -> void:
	var mission = get_mission(id)
	if mission.is_empty():
		push_error("Mission not found: " + id)
		return

	GameState.complete_mission(id)

	# Apply meter changes
	var multiplier = 1.0
	if outcome == "retreat": multiplier = 0.5
	elif outcome == "defeat": multiplier = 0.25

	var meters = mission.get("meter_changes", {})
	for meter in meters:
		GameState.change_meter(meter, int(meters[meter] * multiplier))

	# Apply relationship changes
	var relationships = mission.get("relationships", {})
	for lt in relationships:
		GameState.change_loyalty(lt, relationships[lt])

	# Apply hooks
	for hook in mission.get("hooks_created", []):
		if hook not in GameState.active_hooks:
			GameState.active_hooks.append(hook)

	# Distribute rewards
	last_reward = generate_mission_reward(id, outcome, multiplier)

	# Unlock next missions
	_unlock_next(id)
	SaveManager.auto_save()

	# Emit signal for narrative manager and other subscribers
	mission_completed.emit(id)

func _unlock_next(id: String) -> void:
	if id.begins_with("M"):
		var num = int(id.substr(1))
		GameState.unlock_mission("M%02d" % (num + 1))
	# Side mission unlocks
	var side_unlocks = {
		"M01": ["S01", "S14"],
		"M04": ["S02"],
		"M05": ["S06", "S13"],
		"M06": ["S03"],
		"M08": ["S07", "S08"],
		"M09": ["S04"],
		"M11": ["S09"],
		"M12": ["S05", "S11", "S12"],
		"M14": ["S10"],
		"M15": ["S15"],
	}
	for mission in side_unlocks.get(id, []):
		GameState.unlock_mission(mission)

func _roll_gear_drop() -> String:
	var target_rarity := roll_gear_rarity()

	var candidates: Array = []
	var unowned_any_rarity: Array = []
	for gear_id in CardManager.gear_data.keys():
		if GameState.has_gear(gear_id):
			continue
		unowned_any_rarity.append(gear_id)
		var gear: Dictionary = CardManager.get_gear(gear_id)
		if str(gear.get("rarity", "")).to_lower() == target_rarity:
			candidates.append(gear_id)

	if candidates.is_empty():
		# Keep fallback-gold behavior for true "owned everything" state only.
		if unowned_any_rarity.is_empty():
			return ""
		candidates = unowned_any_rarity
	var pick_idx: int = gear_rng.randi_range(0, candidates.size() - 1)
	return str(candidates[pick_idx])

func roll_gear_rarity() -> String:
	var roll: float = gear_rng.randf()
	if roll < 0.01:
		return "epic"
	if roll < 0.10:
		return "rare"
	return "common"

func generate_mission_reward(mission_id: String, outcome: String, multiplier: float) -> Dictionary:
	var mission = get_mission(mission_id)
	if mission.is_empty():
		return {"gold": 0, "gear_id": "", "gear_name": "", "gear_rarity": "", "dropped": false}
	var reward := {"gold": 0, "gear_id": "", "gear_name": "", "gear_rarity": "", "dropped": false}
	var rewards = mission.get("victory_rewards", {})
	if outcome == "retreat":
		rewards = mission.get("retreat_rewards", rewards)
	reward["gold"] = int(rewards.get("gold", 0) * multiplier)
	GameState.add_gold(reward["gold"])

	if outcome != "victory":
		return reward

	var drop_chance := _get_drop_chance(mission)
	if gear_rng.randf() > drop_chance:
		return reward

	var dropped_gear_id: String = _roll_gear_drop()
	if dropped_gear_id == "":
		var fallback_gold := _gear_fallback_gold(mission)
		if fallback_gold > 0:
			GameState.add_gold(fallback_gold)
			reward["gold"] += fallback_gold
		return reward

	GameState.add_gear(dropped_gear_id)
	var gear_data: Dictionary = CardManager.get_gear(dropped_gear_id)
	reward["gear_id"] = dropped_gear_id
	reward["gear_name"] = gear_data.get("name", dropped_gear_id)
	reward["gear_rarity"] = gear_data.get("rarity", "unknown")
	reward["dropped"] = true
	print("Gear drop: %s (%s)" % [reward["gear_name"], reward["gear_rarity"]])
	return reward

func _get_drop_chance(mission: Dictionary) -> float:
	var act = int(mission.get("act", 1))
	return get_drop_chance_for_act(act)

func get_drop_chance_for_act(act: int) -> float:
	match act:
		1:
			return 0.60
		2:
			return 0.75
		3:
			return 0.90
		_:
			return 1.0

func _gear_fallback_gold(_mission: Dictionary) -> int:
	return 100

func set_gear_rng_seed(rng_seed: int) -> void:
	gear_rng.seed = rng_seed

func get_last_reward_text() -> String:
	if last_reward.is_empty():
		return ""
	var gold = int(last_reward.get("gold", 0))
	var gear_name = str(last_reward.get("gear_name", ""))
	if gear_name != "":
		return "Reward: +%d gold | Gear: %s" % [gold, gear_name]
	return "Reward: +%d gold" % gold

func check_ending_path() -> String:
	if GameState.PIETY >= 7: return "Cult"
	elif GameState.FAVOR >= 6: return "State"
	else: return "Solo"
