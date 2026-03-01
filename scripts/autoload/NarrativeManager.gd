extends Node
## Narrative Event Manager (Autoload Singleton)
## Coordinates story beats, hooks, and narrative UI updates
## Triggered by MissionManager when missions complete

signal scene_triggered(scene_id: String, payload: Dictionary)
var hooks_data: Dictionary = {}
var scenes_data: Dictionary = {}
var cassian_reflection_scene: PackedScene = null  # Will load CassianReflectionPanel.tscn
var story_beat_panel_scene: PackedScene = null    # Will load StoryBeatPanel.tscn

func _ready() -> void:
	# Load hooks.json
	_load_hooks()
	# Load scenes.json
	_load_scenes()

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

func _load_scenes() -> void:
	var file_path = "res://data/scenes.json"
	if not ResourceLoader.exists(file_path):
		return
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		return
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	if error == OK:
		scenes_data = json.data
		print("✓ Scenes loaded: %d endings, %d beats" % [
			scenes_data.get("endings", {}).size(),
			scenes_data.get("story_beats", {}).size()
		])
	else:
		push_error("Failed to parse scenes.json: %s" % json.get_error_message())

func _on_mission_complete(mission_id: String) -> void:
	var mission_hooks: Dictionary = hooks_data.get("mission_hooks", {}) as Dictionary
	var hook: Dictionary = mission_hooks.get(mission_id, {}) as Dictionary

	if hook.is_empty():
		print("⚠ No hook found for mission: ", mission_id)
		return

	# Apply narrative changes from this mission
	_apply_mission_hook(mission_id, hook)

	# Check for phase transitions and story beats
	_check_phase_transition(mission_id)

	# Trigger mission scene/journal entry
	var scene_text: String = str(hook.get("scene", ""))
	if not scene_text.is_empty():
		trigger_scene(mission_id, {
			"title": hook.get("title", mission_id),
			"text": scene_text,
			"type": "mission",
			"phase": hook.get("phase", GameState.story_phase),
			"story_id": hook.get("story_id", "")
		})

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
	var normalized_threats: Array[String] = []
	if who_hunts is Array:
		for entry in who_hunts:
			if typeof(entry) == TYPE_STRING:
				normalized_threats.append(entry)
	elif typeof(who_hunts) == TYPE_STRING and not who_hunts.is_empty():
		normalized_threats.append(who_hunts)
	GameState.threat_level = normalized_threats

	# Apply meter impacts (narrative meters -> game meters)
	# Note: gameplay meters are applied by MissionManager via missions.json meter_changes.
	# Narrative meter_impact is currently display-only for briefing/log UI.

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
		trigger_scene(beat_id, beat)

func _update_narrative_momentum() -> void:
	match GameState.story_phase:
		"SURVIVAL":
			GameState.narrative_momentum = "On the Run"
		"HOPE":
			GameState.narrative_momentum = "Building Opposition"
		"RESISTANCE":
			GameState.narrative_momentum = "Last Stand"

func show_cassian_reflection(mission_id: String, text: String) -> void:
	# Simple modal with Cassian's monologue (1-2 lines)
	print("\n🗣 CASSIAN: %s\n" % text)
	
	# Reuse SceneModal for reflection, but with a specific "reflection" type
	var payload := {
		"title": "Reflection",
		"text": text,
		"type": "reflection",
		"portrait": "res://assets/characters/cassian.png",
		"tags": ["monologue"]
	}
	trigger_scene("reflection_" + mission_id, payload)

func show_story_beat_panel(beat_id: String) -> void:
	var story_beats = hooks_data.get("story_beats", {})
	var beat = story_beats.get(beat_id, {})

	if beat.is_empty():
		return

	print("\n✦ STORY BEAT: %s\n%s\n" % [beat_id, beat.get("text", "")])
	
	# Trigger it as a scene with choices if it exists in scenes_data
	var scene_payload = get_scene(beat_id)
	if not scene_payload.is_empty():
		trigger_scene(beat_id, scene_payload)
	else:
		# Fallback if not in scenes_data but in hooks_data
		trigger_scene(beat_id, {
			"title": beat.get("title", beat_id),
			"text": beat.get("text", ""),
			"type": "story_beat",
			"phase": beat.get("phase", GameState.story_phase)
		})

func trigger_scene(scene_id: String, payload: Dictionary = {}) -> void:
	var base_scene: Dictionary = scenes_data.get("story_beats", {}).get(scene_id, {}) as Dictionary
	if base_scene.is_empty():
		base_scene = scenes_data.get("endings", {}).get(scene_id, {}) as Dictionary

	var merged: Dictionary = base_scene.duplicate()
	for key in payload.keys():
		merged[key] = payload[key]

	if merged.is_empty():
		return

	# Apply immediate scene effects (e.g. static changes not tied to a choice)
	_apply_scene_effects(merged.get("effects", {}))

	var entry := {
		"id": scene_id,
		"title": merged.get("title", scene_id),
		"text": merged.get("text", payload.get("text", "")),
		"type": merged.get("type", payload.get("type", "scene")),
		"phase": merged.get("phase", GameState.story_phase),
		"tags": merged.get("tags", []),
		"story_id": merged.get("story_id", ""),
		"portrait": merged.get("portrait", payload.get("portrait", "")),
		"choices": merged.get("choices", []),
		"timestamp": Time.get_ticks_msec()
	}

	GameState.story_log.append(entry)
	scene_triggered.emit(scene_id, entry)

func get_scene(scene_id: String) -> Dictionary:
	var scene = scenes_data.get("story_beats", {}).get(scene_id, {})
	if not scene.is_empty():
		return scene
	return scenes_data.get("endings", {}).get(scene_id, {})

func get_ending_scene(ending_id: String) -> Dictionary:
	return scenes_data.get("endings", {}).get(ending_id, {})

func finalize_ending(ending_id: String) -> void:
	var ending_scene := get_ending_scene(ending_id)
	if ending_scene.is_empty():
		return
	GameState.ending_reached = ending_id
	trigger_scene(ending_id, ending_scene)

func _apply_scene_effects(effects: Dictionary) -> void:
	var meters: Dictionary = effects.get("meter_changes", {})
	for meter_name in meters.keys():
		GameState.change_meter(str(meter_name), int(meters[meter_name]))

	for flag_name in effects.get("set_flags", []):
		GameState.set_relationship_flag("global", str(flag_name), true)
	for flag_name in effects.get("clear_flags", []):
		GameState.set_relationship_flag("global", str(flag_name), false)

	var rels: Dictionary = effects.get("relationship_changes", {})
	for npc_id in rels.keys():
		GameState.modify_relationship_score(str(npc_id), int(rels[npc_id]), "scene")

	var factions: Dictionary = effects.get("faction_changes", {})
	for faction_id in factions.keys():
		GameState.modify_faction_alignment(str(faction_id), int(factions[faction_id]), "scene")

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

func apply_dialogue_choice(npc_id: String, choice_payload: Dictionary) -> void:
	# Generic dialogue consequence entrypoint for UI scripts.
	# Example payload:
	# {
	#   "score_delta": 10,
	#   "set_flags": ["helped"],
	#   "clear_flags": ["betrayed"],
	#   "faction_changes": {"Cult": 15, "State": -8},
	#   "context": "dialogue_help_choice"
	# }
	var score_delta := int(choice_payload.get("score_delta", 0))
	var context := str(choice_payload.get("context", "dialogue"))
	if score_delta != 0:
		GameState.modify_relationship_score(npc_id, score_delta, context)

	for flag_name in choice_payload.get("set_flags", []):
		GameState.set_relationship_flag(npc_id, str(flag_name), true)
	for flag_name in choice_payload.get("clear_flags", []):
		GameState.set_relationship_flag(npc_id, str(flag_name), false)

	var faction_changes: Dictionary = choice_payload.get("faction_changes", {})
	for faction_id in faction_changes.keys():
		GameState.modify_faction_alignment(str(faction_id), int(faction_changes[faction_id]), context)

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
