extends "res://tests/runner/TestBase.gd"
## Integration tests — full mission flow from selection through completion

func setup() -> void:
	GameState.reset()
	GameState.current_deck = CardManager.get_starter_deck()

# ── New Game Flow ─────────────────────────────────────────────────────────────
func test_new_game_has_starter_deck() -> void:
	assert_not_empty("New game has a deck", GameState.current_deck)
	assert_gte("New game deck >= 10 cards", GameState.current_deck.size(), 10)

func test_new_game_m01_is_only_available_mission() -> void:
	var avail = MissionManager.get_available_missions()
	assert_in("M01 available", "M01", avail)
	assert_not_in("M02 not available at start", "M02", avail)

func test_new_game_gold_is_zero() -> void:
	assert_eq("Gold starts at 0", GameState.gold, 0)

func test_new_game_all_meters_zero() -> void:
	assert_eq("RENOWN=0", GameState.RENOWN, 0)
	assert_eq("HEAT=0",   GameState.HEAT,   0)

# ── Mission Start ─────────────────────────────────────────────────────────────
func test_start_mission_sets_id() -> void:
	MissionManager.start_mission("M01")
	assert_eq("current_mission_id = M01", GameState.current_mission_id, "M01")

func test_start_mission_fails_when_locked() -> void:
	var result = MissionManager.start_mission("M10")
	assert_false("Cannot start locked mission", result)
	assert_ne("current_mission_id not set to M10", GameState.current_mission_id, "M10")

func test_start_mission_fails_when_completed() -> void:
	GameState.complete_mission("M01")
	var result = MissionManager.start_mission("M01")
	assert_false("Cannot restart completed mission", result)

# ── Victory Flow ──────────────────────────────────────────────────────────────
func test_victory_marks_mission_complete() -> void:
	MissionManager.start_mission("M01")
	MissionManager.complete_mission("M01", "victory")
	assert_in("M01 completed after victory", "M01", GameState.completed_missions)

func test_victory_awards_gold() -> void:
	MissionManager.start_mission("M01")
	var m = MissionManager.get_mission("M01")
	var expected = m.get("victory_rewards", {}).get("gold", 0)
	MissionManager.complete_mission("M01", "victory")
	assert_eq("Victory gold awarded", GameState.gold, expected)

func test_victory_updates_renown() -> void:
	MissionManager.start_mission("M01")
	var m = MissionManager.get_mission("M01")
	var renown_change = m.get("meter_changes", {}).get("RENOWN", 0)
	MissionManager.complete_mission("M01", "victory")
	assert_eq("RENOWN updated after M01", GameState.RENOWN, renown_change)

func test_victory_unlocks_next_mission() -> void:
	MissionManager.start_mission("M01")
	MissionManager.complete_mission("M01", "victory")
	assert_in("M02 unlocked after M01 victory", "M02", GameState.unlocked_missions)

func test_victory_unlocks_side_missions() -> void:
	MissionManager.start_mission("M01")
	MissionManager.complete_mission("M01", "victory")
	assert_in("S01 unlocked after M01", "S01", GameState.unlocked_missions)
	assert_in("S14 unlocked after M01", "S14", GameState.unlocked_missions)

func test_m02_available_after_m01_complete() -> void:
	MissionManager.complete_mission("M01", "victory")
	var avail = MissionManager.get_available_missions()
	assert_in("M02 in available after M01", "M02", avail)

# ── Retreat Flow ──────────────────────────────────────────────────────────────
func test_retreat_marks_mission_complete() -> void:
	MissionManager.start_mission("M01")
	MissionManager.complete_mission("M01", "retreat")
	assert_in("M01 marked complete on retreat", "M01", GameState.completed_missions)

func test_retreat_awards_retreat_gold() -> void:
	MissionManager.start_mission("M01")
	var m = MissionManager.get_mission("M01")
	var retreat_gold = m.get("retreat_rewards", {}).get("gold", 0)
	MissionManager.complete_mission("M01", "retreat")
	assert_eq("Retreat gold correct", GameState.gold, retreat_gold)

func test_retreat_gives_less_gold_than_victory() -> void:
	var m = MissionManager.get_mission("M01")
	var v = m.get("victory_rewards", {}).get("gold", 0)
	var r = m.get("retreat_rewards", {}).get("gold", 0)
	assert_lte("Retreat gold <= victory gold", r, v)

func test_retreat_still_unlocks_next() -> void:
	MissionManager.complete_mission("M01", "retreat")
	assert_in("M02 unlocked even after retreat", "M02", GameState.unlocked_missions)

# ── Sequential Mission Chain ──────────────────────────────────────────────────
func test_chain_m01_to_m03() -> void:
	MissionManager.complete_mission("M01", "victory")
	assert_true("M02 available", GameState.is_mission_available("M02"))

	MissionManager.complete_mission("M02", "victory")
	assert_true("M03 available after M02", GameState.is_mission_available("M03"))

	MissionManager.complete_mission("M03", "victory")
	assert_true("M04 available after M03", GameState.is_mission_available("M04"))

func test_gold_accumulates_across_missions() -> void:
	MissionManager.complete_mission("M01", "victory")
	var gold_after_m01 = GameState.gold

	GameState.unlock_mission("M02")
	MissionManager.complete_mission("M02", "victory")
	assert_gt("Gold increased after M02", GameState.gold, gold_after_m01)

# ── Relationship Changes ──────────────────────────────────────────────────────
func test_mission_updates_lieutenant_loyalty() -> void:
	var m = MissionManager.get_mission("M01")
	var relationships = m.get("relationships", {})
	MissionManager.complete_mission("M01", "victory")
	for lt_name in relationships:
		var expected = relationships[lt_name]
		assert_eq("%s loyalty after M01" % lt_name, GameState.lieutenant_data[lt_name]["loyalty"], expected)

# ── Hooks ─────────────────────────────────────────────────────────────────────
func test_mission_hooks_created() -> void:
	var m = MissionManager.get_mission("M04")
	var hooks = m.get("hooks_created", [])
	if hooks.is_empty():
		skip("M04 has no hooks to test")
		return
	GameState.unlock_mission("M04")
	MissionManager.complete_mission("M04", "victory")
	for hook in hooks:
		assert_in("Hook '%s' created after M04" % hook, hook, GameState.active_hooks)

# ── Ending Path Integration ────────────────────────────────────────────────────
func test_piety_missions_push_toward_cult() -> void:
	GameState.unlock_mission("M05")
	MissionManager.complete_mission("M05", "victory")
	var m = MissionManager.get_mission("M05")
	var piety_change = m.get("meter_changes", {}).get("PIETY", 0)
	assert_gt("M05 increases PIETY", piety_change, 0)
	assert_gt("PIETY > 0 after M05", GameState.PIETY, 0)

func test_favor_missions_push_toward_state() -> void:
	GameState.unlock_mission("M06")
	MissionManager.complete_mission("M06", "victory")
	assert_gt("FAVOR > 0 after M06", GameState.FAVOR, 0)

func test_enemy_data_loaded_for_m01() -> void:
	var enemies = CardManager.get_mission_enemies("M01")
	assert_not_empty("M01 has enemies", enemies)
	for e in enemies:
		assert_has_key("Enemy has hp", e, "hp")
		assert_has_key("Enemy has damage", e, "damage")
		assert_gt("Enemy hp > 0", e.get("hp", 0), 0)
