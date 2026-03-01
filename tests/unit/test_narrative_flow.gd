extends "res://tests/runner/TestBase.gd"
## Narrative Flow & Scene System Tests

func test_mission_hook_application() -> void:
	GameState.reset()
	# Simulate M01 completion
	var hook = NarrativeManager.get_mission_hook("M01")
	assert_not_empty(hook, "M01 hook should exist")
	
	NarrativeManager._on_mission_complete("M01")
	
	assert_eq(GameState.story_phase, "SURVIVAL", "Phase should be SURVIVAL after M01")
	assert_true("Marcellus" in GameState.threat_level, "Marcellus should be hunting Cassian")
	assert_true(GameState.lieutenant_data["Rhesus"]["recruited"], "Rhesus should be recruited via M01 hook")
	assert_eq(GameState.refusals_made, 1, "Refusals should increment")

func test_story_beat_trigger() -> void:
	GameState.reset()
	# Simulate M06 completion which triggers 'copied_ledger' story beat
	# In NarrativeManager.gd, _check_phase_transition(mission_id) handles this
	NarrativeManager._on_mission_complete("M06")
	
	assert_true("copied_ledger" in GameState.completed_story_beats, "Story beat 'copied_ledger' should trigger after M06")
	
	# Verify story log entry
	var found_log := false
	for entry in GameState.story_log:
		if entry.get("id") == "copied_ledger":
			found_log = true
			assert_eq(entry.get("type"), "story_beat", "Log type should be story_beat")
			break
	assert_true(found_log, "Story log should contain 'copied_ledger' entry")

func test_scene_effects_application() -> void:
	GameState.reset()
	var effects := {
		"meter_changes": {"RENOWN": 5, "HEAT": -2},
		"set_flags": ["test_flag"],
		"relationship_changes": {"Rhesus": 10},
		"faction_changes": {"Cult": 15}
	}
	
	NarrativeManager._apply_scene_effects(effects)
	
	assert_eq(GameState.renown, 5, "Renown should increase by 5")
	assert_eq(GameState.heat, 0, "Heat should be clamped at 0") # Started at 0, -2 -> 0
	assert_true(GameState.check_relationship_flag("global", "test_flag"), "Global flag should be set")
	assert_eq(GameState.npc_relationships["Rhesus"]["score"], 10, "Rhesus score should increase")
	assert_eq(GameState.get_faction_alignment("Cult"), 15, "Cult alignment should increase")

func test_ending_flow() -> void:
	GameState.reset()
	# Setup meters for Cult ending
	GameState.piety = 8
	
	var ending = MissionManager.check_ending_path()
	assert_eq(ending, "Cult", "Should trigger Cult ending with PIETY 8")
	
	NarrativeManager.finalize_ending(ending)
	assert_eq(GameState.ending_reached, "Cult", "Ending reached should be set in GameState")
	
	# Verify log contains ending
	var found_ending := false
	for entry in GameState.story_log:
		if entry.get("id") == "Cult":
			found_ending = true
			assert_eq(entry.get("type"), "ending", "Log type should be ending")
			break
	assert_true(found_ending, "Story log should contain 'Cult' ending")
