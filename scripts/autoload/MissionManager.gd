extends Node
## Mission manager (Autoload Singleton)

var missions_data: Dictionary = {}

func _ready() -> void:
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
	var rewards = mission.get("victory_rewards", {})
	if outcome == "retreat": rewards = mission.get("retreat_rewards", rewards)
	GameState.add_gold(int(rewards.get("gold", 0) * multiplier))

	# Unlock next missions
	_unlock_next(id)
	SaveManager.auto_save()

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

func check_ending_path() -> String:
	if GameState.PIETY >= 7: return "Cult"
	elif GameState.FAVOR >= 6: return "State"
	else: return "Solo"
