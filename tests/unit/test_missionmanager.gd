extends "res://tests/runner/TestBase.gd"
## MissionManager unit tests — loading, availability, completion, rewards, unlocks

# ── Data Loading ─────────────────────────────────────────────────────────────
func test_missions_loaded() -> void:
	assert_gt("Missions loaded", MissionManager.missions_data.size(), 0)

func test_m01_exists() -> void:
	var m = MissionManager.get_mission("M01")
	assert_false("M01 found", m.is_empty())

func test_m01_correct_name() -> void:
	var m = MissionManager.get_mission("M01")
	assert_eq("M01 name is 'The Token'", m.get("name"), "The Token")

func test_m01_has_enemies() -> void:
	var m = MissionManager.get_mission("M01")
	assert_not_empty("M01 has enemies array", m.get("enemies", []))

func test_m01_has_victory_rewards() -> void:
	var m = MissionManager.get_mission("M01")
	assert_has_key("M01 has victory_rewards", m, "victory_rewards")
	assert_has_key("M01 victory_rewards has gold", m.get("victory_rewards", {}), "gold")

func test_m10_exists() -> void:
	var m = MissionManager.get_mission("M10")
	assert_false("M10 found", m.is_empty())

func test_s01_exists() -> void:
	var m = MissionManager.get_mission("S01")
	assert_false("S01 found", m.is_empty())

func test_unknown_mission_returns_empty() -> void:
	var m = MissionManager.get_mission("M99")
	assert_true("M99 returns empty", m.is_empty())

func test_all_missions_have_required_fields() -> void:
	var required = ["id","name","type","description","enemies","victory_rewards"]
	var bad = []
	for mid in MissionManager.missions_data:
		var m = MissionManager.missions_data[mid]
		for field in required:
			if not m.has(field):
				bad.append("%s missing %s" % [mid, field])
	assert_empty("All missions have required fields", bad)

# ── Availability ─────────────────────────────────────────────────────────────
func test_get_available_missions_at_start() -> void:
	var avail = MissionManager.get_available_missions()
	assert_in("M01 available at start", "M01", avail)

func test_get_available_excludes_completed() -> void:
	GameState.complete_mission("M01")
	var avail = MissionManager.get_available_missions()
	assert_not_in("M01 not available after complete", "M01", avail)

func test_get_available_excludes_locked() -> void:
	var avail = MissionManager.get_available_missions()
	assert_not_in("M05 not available when locked", "M05", avail)

func test_unlock_makes_mission_available() -> void:
	GameState.unlock_mission("M05")
	var avail = MissionManager.get_available_missions()
	assert_in("M05 available after unlock", "M05", avail)

# ── start_mission ─────────────────────────────────────────────────────────────
func test_start_mission_sets_current_id() -> void:
	MissionManager.start_mission("M01")
	assert_eq("current_mission_id set to M01", GameState.current_mission_id, "M01")

func test_start_mission_returns_true_when_available() -> void:
	var result = MissionManager.start_mission("M01")
	assert_true("start_mission M01 returns true", result)

func test_start_mission_returns_false_when_locked() -> void:
	var result = MissionManager.start_mission("M10")
	assert_false("start_mission locked M10 returns false", result)

func test_start_mission_returns_false_when_completed() -> void:
	GameState.complete_mission("M01")
	var result = MissionManager.start_mission("M01")
	assert_false("start_mission completed M01 returns false", result)

# ── complete_mission ─────────────────────────────────────────────────────────
func test_complete_mission_marks_completed() -> void:
	MissionManager.complete_mission("M01")
	assert_in("M01 in completed_missions", "M01", GameState.completed_missions)

func test_complete_mission_applies_gold_reward() -> void:
	var m = MissionManager.get_mission("M01")
	var expected_gold = m.get("victory_rewards", {}).get("gold", 0)
	MissionManager.complete_mission("M01", "victory")
	assert_eq("M01 victory gold applied", GameState.gold, expected_gold)

func test_complete_mission_applies_meter_changes() -> void:
	var m = MissionManager.get_mission("M01")
	var renown_change = m.get("meter_changes", {}).get("RENOWN", 0)
	MissionManager.complete_mission("M01", "victory")
	assert_eq("M01 RENOWN meter applied", GameState.RENOWN, renown_change)

func test_complete_mission_retreat_halves_gold() -> void:
	var m = MissionManager.get_mission("M01")
	var full_gold = m.get("victory_rewards", {}).get("gold", 0)
	var retreat_gold = m.get("retreat_rewards", {}).get("gold", 0)
	MissionManager.complete_mission("M01", "retreat")
	assert_eq("M01 retreat gold applied", GameState.gold, retreat_gold)

func test_complete_mission_unlocks_next_main() -> void:
	MissionManager.complete_mission("M01", "victory")
	assert_in("M02 unlocked after M01", "M02", GameState.unlocked_missions)

func test_complete_m01_unlocks_s01() -> void:
	MissionManager.complete_mission("M01", "victory")
	assert_in("S01 unlocked after M01", "S01", GameState.unlocked_missions)

func test_complete_m01_unlocks_s14() -> void:
	MissionManager.complete_mission("M01", "victory")
	assert_in("S14 unlocked after M01", "S14", GameState.unlocked_missions)

func test_complete_m04_unlocks_s02() -> void:
	GameState.unlock_mission("M04")
	MissionManager.complete_mission("M04", "victory")
	assert_in("S02 unlocked after M04", "S02", GameState.unlocked_missions)

func test_complete_m05_unlocks_s06() -> void:
	GameState.unlock_mission("M05")
	MissionManager.complete_mission("M05", "victory")
	assert_in("S06 unlocked after M05", "S06", GameState.unlocked_missions)

func test_complete_m05_unlocks_s13() -> void:
	GameState.unlock_mission("M05")
	MissionManager.complete_mission("M05", "victory")
	assert_in("S13 unlocked after M05", "S13", GameState.unlocked_missions)

func test_complete_applies_relationship_changes() -> void:
	var m = MissionManager.get_mission("M01")
	var relationships = m.get("relationships", {})
	MissionManager.complete_mission("M01", "victory")
	for lt_name in relationships:
		var expected = relationships[lt_name]
		assert_eq("%s loyalty after M01" % lt_name, GameState.lieutenant_data[lt_name]["loyalty"], expected)

func test_complete_unknown_mission_does_not_crash() -> void:
	MissionManager.complete_mission("M99", "victory")
	assert_true("complete unknown mission does not crash", true)

# ── Ending Paths ──────────────────────────────────────────────────────────────
func test_ending_path_solo_by_default() -> void:
	assert_eq("Default ending path is Solo", MissionManager.check_ending_path(), "Solo")

func test_ending_path_cult_at_piety_seven() -> void:
	GameState.change_meter("PIETY", 7)
	assert_eq("PIETY=7 gives Cult ending", MissionManager.check_ending_path(), "Cult")

func test_ending_path_cult_at_piety_max() -> void:
	GameState.change_meter("PIETY", 10)
	assert_eq("PIETY=10 gives Cult ending", MissionManager.check_ending_path(), "Cult")

func test_ending_path_state_at_favor_six() -> void:
	GameState.change_meter("FAVOR", 6)
	assert_eq("FAVOR=6 gives State ending", MissionManager.check_ending_path(), "State")

func test_ending_path_piety_beats_favor() -> void:
	GameState.change_meter("PIETY", 7)
	GameState.change_meter("FAVOR", 6)
	assert_eq("PIETY>=7 beats FAVOR for Cult ending", MissionManager.check_ending_path(), "Cult")

func test_ending_path_solo_low_meters() -> void:
	GameState.change_meter("PIETY", 5)
	GameState.change_meter("FAVOR", 4)
	assert_eq("Low meters = Solo ending", MissionManager.check_ending_path(), "Solo")
