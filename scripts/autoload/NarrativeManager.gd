extends Node
## Narrative Event Manager (Autoload Singleton)
## Coordinates story beats, hooks, and narrative UI updates
## Triggered by MissionManager when missions complete

var hooks_data: Dictionary = {}
var cassian_reflection_scene: PackedScene = null  # Will load CassianReflectionPanel.tscn
var story_beat_panel_scene: PackedScene = null    # Will load StoryBeatPanel.tscn

func _ready() -> void:
	# Load hooks.json
	_load_hooks()

	# Connect to mission manager signals
	if MissionManager.mission_completed.is_connected(_on_mission_complete):
		return  # Already connected
	MissionManager.mission_completed.connect(_on_mission_complete)

func _load_hooks() -> void:
	var file_path = "res://data/hooks.json"
	if ResourceLoader.exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file != null:
			var json = JSON.new()
			var error = json.parse(file.get_as_text())
			if error == OK:
				hooks_data = json.data
				print("✓ Hooks loaded: %d missions" % hooks_data.get("mission_hooks", {}).size())
			else:
				push_error("Failed to parse hooks.json: ", json.get_error_message())
	else:
		push_error("hooks.json not found at ", file_path)

func _on_mission_complete(mission_id: String) -> void:
	var mission_hooks = hooks_data.get("mission_hooks", {})
	var hook = mission_hooks.get(mission_id, {})

	if hook.is_empty():
		print("⚠ No hook found for mission: ", mission_id)
		return

	# Apply narrative changes from this mission
	_apply_mission_hook(mission_id, hook)

	# Check for phase transitions and story beats
	_check_phase_transition(mission_id)

	# Show Cassian's monologue (internal reflection)
	var monologue = hook.get("monologue", "")
	if not monologue.is_empty():
		show_cassian_reflection(mission_id, monologue)

	# Trigger any major story beats
	var story_id = hook.get("story_id", "")
	var story_beats = hooks_data.get("story_beats", {})
	if story_id in story_beats and story_id not in GameState.completed_story_beats:
		show_story_beat_panel(story_id)

	# Update all narrative UI components
	_update_all_ui()

func _apply_mission_hook(_mission_id: String, hook: Dictionary) -> void:
	# Increment refusals counter
	GameState.refusals_made += 1

	# Update phase
	var phase = hook.get("phase", GameState.story_phase)
	GameState.story_phase = phase

	# Update threat level (who's hunting Cassian now)
	var who_hunts = hook.get("who_hunts", [])
	if who_hunts is Array:
		GameState.threat_level = Array[String](who_hunts)
	elif typeof(who_hunts) == TYPE_STRING and not who_hunts.is_empty():
		GameState.threat_level = Array[String]([who_hunts])
	else:
		GameState.threat_level = Array[String]([])

	# Apply meter impacts
	var meter_impact = hook.get("meter_impact", {})
	for meter_name in meter_impact.keys():
		var amount = meter_impact[meter_name]
		GameState.change_meter(meter_name, amount)

	# Unlock related lieutenants
	var who_helps = hook.get("who_helps", [])
	for lieutenant in who_helps:
		if lieutenant in GameState.lieutenant_data and not GameState.lieutenant_data[lieutenant]["recruited"]:
			GameState.recruit_lieutenant(lieutenant)
			# Apply slight loyalty boost for being introduced
			GameState.change_loyalty(lieutenant, 1)

func _check_phase_transition(mission_id: String) -> void:
	var mission_num = int(mission_id.split("M")[1]) if "M" in mission_id else 0

	# Phase transitions
	if mission_num == 6:
		_trigger_story_beat("copied_ledger")
	elif mission_num == 13:
		_trigger_story_beat("public_exposure")

	# Update narrative momentum based on phase
	_update_narrative_momentum()

func _trigger_story_beat(beat_id: String) -> void:
	if beat_id in GameState.completed_story_beats:
		return  # Already triggered

	GameState.completed_story_beats.append(beat_id)
	var story_beats = hooks_data.get("story_beats", {})
	var beat = story_beats.get(beat_id, {})

	if not beat.is_empty():
		show_story_beat_panel(beat_id)

func _update_narrative_momentum() -> void:
	match GameState.story_phase:
		"SURVIVAL":
			GameState.narrative_momentum = "On the Run"
		"HOPE":
			GameState.narrative_momentum = "Building Opposition"
		"RESISTANCE":
			GameState.narrative_momentum = "Last Stand"

func show_cassian_reflection(_mission_id: String, text: String) -> void:
	# Simple modal with Cassian's monologue (1-2 lines)
	# For now, just print to console; later show UI panel
	print("\n🗣 CASSIAN: %s\n" % text)

	# TODO: Queue actual UI panel when CassianReflectionPanel scene exists
	# var panel = cassian_reflection_scene.instantiate()
	# panel.set_text(text, mission_id)
	# get_tree().root.add_child(panel)

func show_story_beat_panel(beat_id: String) -> void:
	var story_beats = hooks_data.get("story_beats", {})
	var beat = story_beats.get(beat_id, {})

	if beat.is_empty():
		return

	var text = beat.get("text", "")
	print("\n✦ STORY BEAT: %s\n%s\n" % [beat_id, text])

	# TODO: Queue actual UI panel when StoryBeatPanel scene exists
	# var panel = story_beat_panel_scene.instantiate()
	# panel.set_beat(beat_id, beat)
	# get_tree().root.add_child(panel)

func _update_all_ui() -> void:
	# Signal all UI components to refresh
	# These will be called from:
	# - CharacterStatePanel._update()
	# - MetersPanel._update()
	# - MissionLog.add_entry()

	print("→ Narrative UI updated: Phase=%s, Threats=%s, Refusals=%d" % [
		GameState.story_phase,
		",".join(GameState.threat_level),
		GameState.refusals_made
	])

# Helper: get character arc info
func get_character_arc(lieutenant_name: String) -> Dictionary:
	var arcs = hooks_data.get("character_arcs", {})
	return arcs.get(lieutenant_name, {})

# Helper: get mission hook
func get_mission_hook(mission_id: String) -> Dictionary:
	var mission_hooks = hooks_data.get("mission_hooks", {})
	return mission_hooks.get(mission_id, {})

# Helper: get story beat
func get_story_beat(beat_id: String) -> Dictionary:
	var story_beats = hooks_data.get("story_beats", {})
	return story_beats.get(beat_id, {})
