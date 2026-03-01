extends "res://tests/runner/TestBase.gd"

func before_each() -> void:
	GameState.reset()
	GameState.story_log.clear()

func test_scenes_file_loads_endings() -> void:
	var cult = NarrativeManager.get_ending_scene("Cult")
	assert_not_empty("Cult ending scene present", cult)
	assert_has_key("Cult ending has text", cult, "text")

func test_trigger_scene_logs_entry() -> void:
	NarrativeManager.trigger_scene("test_inline_scene", {
		"title": "Inline Scene",
		"text": "Narrative beats between missions.",
		"type": "story"
	})
	assert_eq("Story log has one entry", GameState.story_log.size(), 1)
	var entry = GameState.story_log[0]
	assert_eq("Scene ID stored", entry.get("id", ""), "test_inline_scene")
	assert_eq("Scene text stored", entry.get("text", ""), "Narrative beats between missions.")

func test_finalize_ending_sets_flag_and_logs() -> void:
	NarrativeManager.finalize_ending("Cult")
	assert_eq("Ending set", GameState.ending_reached, "Cult")
	assert_gt("Story log appended", GameState.story_log.size(), 0)

func test_scene_effects_apply_meter_changes() -> void:
	GameState.reset()
	GameState.story_log.clear()
	NarrativeManager.trigger_scene("effect_scene", {
		"title": "Effect Scene",
		"text": "Meter change test.",
		"effects": {"meter_changes": {"RENOWN": 2}}
	})
	assert_eq("RENOWN increased by scene effects", GameState.renown, 2)
