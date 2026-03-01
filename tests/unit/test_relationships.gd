extends "res://tests/runner/TestBase.gd"
## Relationship and faction gating + dialogue coverage

func test_m14_locked_until_varro_trust() -> void:
	GameState.unlock_mission("M14")
	var reasons = MissionManager.get_mission_lock_reasons("M14")
	assert_in("M14 shows Varro trust gate", "Requires Varro trust (15+)", reasons)

	GameState.modify_relationship_score("Varro", 20, "unit_test")
	GameState.set_relationship_flag("Varro", "revealed", true)

	assert_true("M14 unlocks after Varro trust met", MissionManager.is_mission_available("M14"))


func test_m15_requires_iona_and_cult_alignment() -> void:
	GameState.unlock_mission("M15")
	var reasons = MissionManager.get_mission_lock_reasons("M15")
	assert_in("M15 locked by Iona trust", "Requires Iona trust (15+)", reasons)
	assert_in("M15 locked by Cult alignment", "Requires Cult alignment 18", reasons)

	GameState.modify_relationship_score("Iona", 20, "unit_test")
	GameState.set_relationship_flag("Iona", "met", true)
	GameState.modify_faction_alignment("Cult", 25, "unit_test")

	assert_true("M15 unlocks after Cult + Iona requirements", MissionManager.is_mission_available("M15"))


func test_m17_blocked_by_cult_alignment_threshold() -> void:
	GameState.unlock_mission("M17")
	GameState.modify_relationship_score("Moth", 12, "unit_test")
	GameState.set_relationship_flag("Moth", "met", true)
	GameState.faction_status["Syndicate"]["alignment"] = 20
	GameState.faction_status["Cult"]["alignment"] = 0
	assert_true("M17 available when Syndicate path chosen", MissionManager.is_mission_available("M17"))

	GameState.faction_status["Cult"]["alignment"] = 35
	var reasons = MissionManager.get_mission_lock_reasons("M17")
	assert_in("M17 blocked when Cult alignment too high", "Blocked by Cult alignment 30+", reasons)


func test_moth_dialogue_respects_flag_and_context() -> void:
	GameState.set_relationship_flag("Moth", "injured", true)
	var injured = GameState.get_npc_dialogue("Moth")
	assert_eq("Moth injured flag returned", injured, "Do not look at me like that. I knew the risk.")

	GameState.set_relationship_flag("Moth", "rescued", true)
	var locked = GameState.get_npc_dialogue("Moth", "mission_locked")
	assert_eq("Moth mission-locked rescued line", locked, "You carried me once. I'll return the favor - once.")


func test_sabina_dialogue_available() -> void:
	var line = GameState.get_npc_dialogue("Sabina")
	assert_not_empty("Sabina dialogue loaded", line)


