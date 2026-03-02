extends Node
## Rival System Manager (Autoload Singleton)
## Tracks rival identification, investigation clues, interference events, and challenges
## Rivals are discovered through investigation confidence accumulation from mission clues

# ============ SIGNALS ============
signal rival_identified(rival_id: String)
signal investigation_clue_registered(rival_id: String, clue_id: String, confidence: float)
signal rival_challenged(rival_id: String, success: bool)
signal interference_event_triggered(rival_id: String, event_id: String)

# ============ CONSTANTS ============
const RIVALS_DATA_PATH := "res://data/rivals.json"
const INVESTIGATION_MIN := 0.0
const INVESTIGATION_MAX := 1.0

# ============ DATA ============
var rival_data: Dictionary = {}
var act_definitions: Dictionary = {}

## Tracks which clues have been registered per rival
## Format: {"rival_id": ["clue_id_1", "clue_id_2", ...]}
var registered_clues: Dictionary = {}

## Tracks investigation confidence per rival (calculated, not stored)
## Format: {"rival_id": 0.85}
var rival_confidence: Dictionary = {}

## Tracks whether each rival has been identified (discovered at threshold)
## Format: {"rival_id": true/false}
var identified_rivals: Dictionary = {}

## Tracks challenges and outcomes
## Format: {"rival_id": {"challenged": true, "success": false, "penalty_applied": true}}
var challenge_history: Dictionary = {}

## Active interference events from rivals
## Format: [{"rival_id": "...", "event_id": "...", "active": true, "triggers_on": "after_mission_5"}]
var active_interference: Array = []

# ============ LIFECYCLE ============

func _ready() -> void:
	_load_rival_data()
	_initialize_tracking()

# ============ DATA LOADING ============

func _load_rival_data() -> void:
	var file := FileAccess.open(RIVALS_DATA_PATH, FileAccess.READ)
	if file == null:
		push_error("Failed to load rivals data from %s" % RIVALS_DATA_PATH)
		return

	var json := JSON.new()
	var error := json.parse(file.get_as_text())
	if error != OK:
		push_error("Failed to parse rivals JSON: %s" % json.get_error_message())
		return

	var data := json.data
	rival_data = data.get("rivals", {})
	act_definitions = data.get("act_definitions", {})

	# Initialize rival tracking dicts
	for rival_id in rival_data.keys():
		registered_clues[rival_id] = []
		rival_confidence[rival_id] = 0.0
		identified_rivals[rival_id] = false
		challenge_history[rival_id] = {"challenged": false, "success": false, "penalty_applied": false}

# ============ INITIALIZATION ============

func _initialize_tracking() -> void:
	## Called after data load; can be extended for save/load restoration
	pass

# ============ PUBLIC API ============

## Register a clue when a mission completes
## Called by MissionManager after mission rewards are applied
func register_clue(rival_id: String, clue_id: String) -> void:
	if not rival_data.has(rival_id):
		push_error("Unknown rival: %s" % rival_id)
		return

	if clue_id in registered_clues[rival_id]:
		## Clue already registered, skip
		return

	registered_clues[rival_id].append(clue_id)
	_recalculate_confidence(rival_id)

	var new_confidence := rival_confidence[rival_id]
	var rival_info = rival_data[rival_id]
	var threshold = rival_info.get("discovery_threshold", 1.0)

	investigation_clue_registered.emit(rival_id, clue_id, new_confidence)

	## Auto-identify if threshold reached
	if new_confidence >= threshold and not identified_rivals[rival_id]:
		_identify_rival(rival_id, true)

## Get current investigation confidence for a rival (0.0 - 1.0)
func get_rival_confidence(rival_id: String) -> float:
	if not rival_data.has(rival_id):
		return 0.0
	return rival_confidence.get(rival_id, 0.0)

## Get all rivals relevant to current act
func get_rivals_for_act(act_number: int) -> Array:
	var act_key := "act_%d" % act_number
	if not act_definitions.has(act_key):
		return []

	var rival_ids: Array = act_definitions[act_key].get("rival_ids", [])
	return rival_ids

## Get full rival profile with gathered clues
func get_rival_profile(rival_id: String) -> Dictionary:
	if not rival_data.has(rival_id):
		return {}

	var rival = rival_data[rival_id].duplicate(true)
	var confidence = get_rival_confidence(rival_id)
	var registered = registered_clues.get(rival_id, [])

	## Filter clues to only show registered ones
	var discovered_clues = []
	for clue in rival.get("clues", []):
		if clue["clue_id"] in registered:
			discovered_clues.append(clue)

	rival["discovered_clues"] = discovered_clues
	rival["confidence"] = confidence
	rival["identified"] = identified_rivals.get(rival_id, false)
	rival["clue_count"] = len(discovered_clues)
	rival["total_clues"] = len(rival.get("clues", []))

	return rival

## Attempt to identify/challenge a rival
## Returns: {"success": bool, "message": String}
func identify_rival(rival_id: String, correct: bool) -> Dictionary:
	if not rival_data.has(rival_id):
		return {"success": false, "message": "Unknown rival"}

	var already_identified = identified_rivals.get(rival_id, false)
	if already_identified:
		return {"success": false, "message": "Rival already identified"}

	if not correct:
		## Wrong identification - becomes permanent enemy
		var result = _apply_challenge_failure(rival_id)
		challenge_history[rival_id]["challenged"] = true
		challenge_history[rival_id]["success"] = false
		challenge_history[rival_id]["penalty_applied"] = true
		rival_challenged.emit(rival_id, false)
		return result

	## Correct identification - triggers combat
	_identify_rival(rival_id, true)
	challenge_history[rival_id]["challenged"] = true
	challenge_history[rival_id]["success"] = true
	rival_challenged.emit(rival_id, true)

	return {"success": true, "message": "Rival identified correctly! Challenge them in combat."}

## Get challenge combat details for identified rival
func get_challenge_combat_data(rival_id: String) -> Dictionary:
	if not rival_data.has(rival_id):
		return {}

	var rival = rival_data[rival_id]
	var reward = rival.get("challenge_reward", {})

	return {
		"rival_id": rival_id,
		"enemy_template": reward.get("enemy_template", ""),
		"gold": reward.get("gold", 0),
		"gear": reward.get("gear", ""),
		"meter_changes": reward.get("meter_changes", {}),
		"is_combat": reward.get("combat", true)
	}

## Generate interference event between missions
func generate_interference_event(rival_id: String) -> Dictionary:
	if not rival_data.has(rival_id):
		return {}

	var rival = rival_data[rival_id]
	var events: Array = rival.get("interference_events", [])

	if events.is_empty():
		return {}

	## Randomly select an event
	var event = events[randi() % events.size()]
	interference_event_triggered.emit(rival_id, event.get("event_id", ""))

	return {
		"rival_id": rival_id,
		"event_id": event.get("event_id", ""),
		"description": event.get("description", ""),
		"trigger": event.get("trigger", "")
	}

## Get all identified rivals
func get_identified_rivals() -> Array:
	var identified = []
	for rival_id in identified_rivals.keys():
		if identified_rivals[rival_id]:
			identified.append(rival_id)
	return identified

## Check if rival has been challenged
func is_rival_challenged(rival_id: String) -> bool:
	return challenge_history.get(rival_id, {}).get("challenged", false)

## Check if rival challenge was successful
func was_challenge_successful(rival_id: String) -> bool:
	return challenge_history.get(rival_id, {}).get("success", false)

# ============ PRIVATE METHODS ============

## Recalculate confidence based on registered clues
func _recalculate_confidence(rival_id: String) -> void:
	if not rival_data.has(rival_id):
		return

	var rival = rival_data[rival_id]
	var clues: Array = rival.get("clues", [])
	var registered = registered_clues.get(rival_id, [])

	if clues.is_empty():
		rival_confidence[rival_id] = 0.0
		return

	## Calculate confidence as average of all clues in order
	var total_confidence = 0.0
	var found_count = 0

	for clue in clues:
		if clue["clue_id"] in registered:
			total_confidence += clue.get("confidence", 0.0)
			found_count += 1

	if found_count == 0:
		rival_confidence[rival_id] = 0.0
	else:
		rival_confidence[rival_id] = total_confidence / found_count
		rival_confidence[rival_id] = clamp(rival_confidence[rival_id], INVESTIGATION_MIN, INVESTIGATION_MAX)

## Internal rival identification
func _identify_rival(rival_id: String, automatic: bool = false) -> void:
	identified_rivals[rival_id] = true
	rival_identified.emit(rival_id)

## Apply penalties for wrong identification
func _apply_challenge_failure(rival_id: String) -> Dictionary:
	if not rival_data.has(rival_id):
		return {}

	var rival = rival_data[rival_id]
	var failure_data = rival.get("challenge_failure", {})
	var becomes_permanent_enemy = failure_data.get("permanent_enemy", true)
	var meter_changes = failure_data.get("meter_changes", {})

	return {
		"success": false,
		"message": "Wrong identification! %s is now your enemy." % rival.get("name", "Unknown"),
		"becomes_enemy": becomes_permanent_enemy,
		"meter_changes": meter_changes
	}

# ============ SAVE/LOAD ============

func save_state() -> Dictionary:
	return {
		"registered_clues": registered_clues.duplicate(true),
		"identified_rivals": identified_rivals.duplicate(true),
		"challenge_history": challenge_history.duplicate(true),
	}

func load_state(state: Dictionary) -> void:
	registered_clues = state.get("registered_clues", {}).duplicate(true)
	identified_rivals = state.get("identified_rivals", {}).duplicate(true)
	challenge_history = state.get("challenge_history", {}).duplicate(true)

	## Recalculate all confidences
	for rival_id in rival_data.keys():
		_recalculate_confidence(rival_id)
