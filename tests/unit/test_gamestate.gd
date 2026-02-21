extends "res://tests/runner/TestBase.gd"
## GameState comprehensive unit tests — 40+ assertions

# ── Meter Initialization ────────────────────────────────────────────────────
func test_meters_start_at_zero() -> void:
	assert_eq("RENOWN starts at 0",  GameState.RENOWN, 0)
	assert_eq("HEAT starts at 0",    GameState.HEAT,   0)
	assert_eq("PIETY starts at 0",   GameState.PIETY,  0)
	assert_eq("FAVOR starts at 0",   GameState.FAVOR,  0)
	assert_eq("DEBT starts at 0",    GameState.DEBT,   0)
	assert_eq("DREAD starts at 0",   GameState.DREAD,  0)

# ── Meter Clamping ─────────────────────────────────────────────────────────
func test_renown_clamps_at_max() -> void:
	GameState.change_meter("RENOWN", 999)
	assert_eq("RENOWN clamps at 20", GameState.RENOWN, 20)

func test_renown_clamps_at_min() -> void:
	GameState.change_meter("RENOWN", -999)
	assert_eq("RENOWN clamps at 0", GameState.RENOWN, 0)

func test_heat_clamps_at_max() -> void:
	GameState.change_meter("HEAT", 999)
	assert_eq("HEAT clamps at 15", GameState.HEAT, 15)

func test_heat_clamps_at_min() -> void:
	GameState.change_meter("HEAT", 10)
	GameState.change_meter("HEAT", -999)
	assert_eq("HEAT clamps at 0", GameState.HEAT, 0)

func test_piety_clamps_at_max() -> void:
	GameState.change_meter("PIETY", 999)
	assert_eq("PIETY clamps at 10", GameState.PIETY, 10)

func test_favor_clamps_at_max() -> void:
	GameState.change_meter("FAVOR", 999)
	assert_eq("FAVOR clamps at 10", GameState.FAVOR, 10)

func test_dread_clamps_at_max() -> void:
	GameState.change_meter("DREAD", 999)
	assert_eq("DREAD clamps at 10", GameState.DREAD, 10)

func test_debt_is_unlimited() -> void:
	GameState.change_meter("DEBT", 500)
	assert_eq("DEBT accepts 500", GameState.DEBT, 500)
	GameState.change_meter("DEBT", 500)
	assert_eq("DEBT accepts 1000", GameState.DEBT, 1000)

func test_debt_clamps_at_zero() -> void:
	GameState.change_meter("DEBT", -999)
	assert_eq("DEBT cannot go negative", GameState.DEBT, 0)

func test_meter_partial_increment() -> void:
	GameState.change_meter("RENOWN", 5)
	GameState.change_meter("RENOWN", 3)
	assert_eq("RENOWN accumulates: 5+3=8", GameState.RENOWN, 8)

func test_meter_decrement() -> void:
	GameState.change_meter("HEAT", 10)
	GameState.change_meter("HEAT", -4)
	assert_eq("HEAT decrements: 10-4=6", GameState.HEAT, 6)

func test_get_meter_returns_correct_value() -> void:
	GameState.change_meter("RENOWN", 7)
	assert_eq("get_meter RENOWN returns 7", GameState.get_meter("RENOWN"), 7)
	GameState.change_meter("PIETY", 3)
	assert_eq("get_meter PIETY returns 3", GameState.get_meter("PIETY"), 3)

func test_get_meter_unknown_returns_zero() -> void:
	assert_eq("get_meter unknown returns 0", GameState.get_meter("UNKNOWN"), 0)

# ── Gold ────────────────────────────────────────────────────────────────────
func test_gold_starts_at_zero() -> void:
	assert_eq("Gold starts at 0", GameState.gold, 0)

func test_add_gold() -> void:
	GameState.add_gold(150)
	assert_eq("add_gold 150", GameState.gold, 150)

func test_add_gold_accumulates() -> void:
	GameState.add_gold(100)
	GameState.add_gold(50)
	assert_eq("Gold accumulates: 100+50=150", GameState.gold, 150)

func test_spend_gold_success() -> void:
	GameState.add_gold(100)
	var result = GameState.spend_gold(60)
	assert_true("spend_gold 60 succeeds", result)
	assert_eq("Gold reduced to 40", GameState.gold, 40)

func test_spend_gold_exact_amount() -> void:
	GameState.add_gold(100)
	var result = GameState.spend_gold(100)
	assert_true("spend_gold exact amount succeeds", result)
	assert_eq("Gold reduced to 0", GameState.gold, 0)

func test_spend_gold_insufficient_fails() -> void:
	GameState.add_gold(50)
	var result = GameState.spend_gold(100)
	assert_false("spend_gold over balance fails", result)
	assert_eq("Gold unchanged after failed spend", GameState.gold, 50)

func test_spend_gold_zero() -> void:
	GameState.add_gold(100)
	var result = GameState.spend_gold(0)
	assert_true("spend_gold 0 succeeds", result)
	assert_eq("Gold unchanged after spending 0", GameState.gold, 100)

# ── Deck / Cards ────────────────────────────────────────────────────────────
func test_deck_starts_empty() -> void:
	assert_empty("Deck starts empty", GameState.current_deck)

func test_add_card_to_deck() -> void:
	GameState.add_card("card_001")
	assert_size("Deck has 1 card", GameState.current_deck, 1)
	assert_in("card_001 in deck", "card_001", GameState.current_deck)

func test_add_card_tracks_discovered() -> void:
	GameState.add_card("card_001")
	assert_in("card_001 in discovered", "card_001", GameState.discovered_cards)

func test_add_card_no_duplicate_in_discovered() -> void:
	GameState.add_card("card_001")
	GameState.add_card("card_001")
	var count = 0
	for c in GameState.discovered_cards:
		if c == "card_001": count += 1
	assert_eq("card_001 only once in discovered", count, 1)

func test_deck_capped_at_thirty() -> void:
	for i in range(35):
		GameState.add_card("card_001")
	assert_eq("Deck capped at 30", GameState.current_deck.size(), 30)

func test_add_card_returns_false_when_full() -> void:
	for i in range(30):
		GameState.add_card("card_001")
	var result = GameState.add_card("card_002")
	assert_false("add_card returns false when deck full", result)

func test_add_card_returns_true_when_space() -> void:
	var result = GameState.add_card("card_001")
	assert_true("add_card returns true when space", result)

# ── Mission Progression ─────────────────────────────────────────────────────
func test_m01_unlocked_at_start() -> void:
	assert_in("M01 unlocked at start", "M01", GameState.unlocked_missions)

func test_no_completed_missions_at_start() -> void:
	assert_empty("No missions completed at start", GameState.completed_missions)

func test_m01_available_at_start() -> void:
	assert_true("M01 available at start", GameState.is_mission_available("M01"))

func test_complete_mission_marks_done() -> void:
	GameState.complete_mission("M01")
	assert_in("M01 in completed", "M01", GameState.completed_missions)

func test_completed_mission_not_available() -> void:
	GameState.complete_mission("M01")
	assert_false("M01 not available after complete", GameState.is_mission_available("M01"))

func test_unlock_mission() -> void:
	GameState.unlock_mission("M05")
	assert_in("M05 in unlocked", "M05", GameState.unlocked_missions)

func test_locked_mission_not_available() -> void:
	assert_false("M05 not available before unlock", GameState.is_mission_available("M05"))

func test_unlock_then_available() -> void:
	GameState.unlock_mission("M05")
	assert_true("M05 available after unlock", GameState.is_mission_available("M05"))

func test_complete_unlocked_not_in_unlocked_twice() -> void:
	GameState.unlock_mission("M02")
	GameState.unlock_mission("M02")
	var count = 0
	for m in GameState.unlocked_missions:
		if m == "M02": count += 1
	assert_eq("M02 only once in unlocked", count, 1)

# ── Lieutenants ─────────────────────────────────────────────────────────────
func test_all_eight_lieutenants_exist() -> void:
	var names = ["Marcus","Livia","Titus","Kara","Decimus","Julia","Corvus","Thane"]
	for lt_name in names:
		assert_in("%s in lieutenant_data" % lt_name, lt_name, GameState.lieutenant_data)

func test_lieutenant_starts_unrecruited() -> void:
	assert_false("Marcus not recruited at start", GameState.lieutenant_data["Marcus"]["recruited"])

func test_recruit_lieutenant() -> void:
	GameState.recruit_lieutenant("Marcus")
	assert_true("Marcus recruited", GameState.lieutenant_data["Marcus"]["recruited"])

func test_recruited_lieutenant_in_active_squad() -> void:
	GameState.recruit_lieutenant("Marcus")
	assert_in("Marcus in active squad", "Marcus", GameState.active_lieutenants)

func test_active_squad_max_two() -> void:
	GameState.recruit_lieutenant("Marcus")
	GameState.recruit_lieutenant("Livia")
	GameState.recruit_lieutenant("Titus")
	assert_lte("Active squad max 2", GameState.active_lieutenants.size(), 2)

func test_loyalty_change_positive() -> void:
	GameState.change_loyalty("Marcus", 5)
	assert_eq("Marcus loyalty +5", GameState.lieutenant_data["Marcus"]["loyalty"], 5)

func test_loyalty_change_negative() -> void:
	GameState.change_loyalty("Marcus", 3)
	GameState.change_loyalty("Marcus", -2)
	assert_eq("Marcus loyalty 3-2=1", GameState.lieutenant_data["Marcus"]["loyalty"], 1)

func test_loyalty_clamps_at_max_ten() -> void:
	GameState.change_loyalty("Marcus", 999)
	assert_eq("Marcus loyalty clamped at 10", GameState.lieutenant_data["Marcus"]["loyalty"], 10)

func test_loyalty_clamps_at_min_neg_five() -> void:
	GameState.change_loyalty("Marcus", -999)
	assert_eq("Marcus loyalty clamped at -5", GameState.lieutenant_data["Marcus"]["loyalty"], -5)

# ── Reset ────────────────────────────────────────────────────────────────────
func test_reset_clears_all_meters() -> void:
	GameState.change_meter("RENOWN", 15)
	GameState.change_meter("HEAT", 10)
	GameState.change_meter("PIETY", 8)
	GameState.reset()
	assert_eq("RENOWN reset to 0", GameState.RENOWN, 0)
	assert_eq("HEAT reset to 0",   GameState.HEAT,   0)
	assert_eq("PIETY reset to 0",  GameState.PIETY,  0)

func test_reset_clears_gold() -> void:
	GameState.add_gold(500)
	GameState.reset()
	assert_eq("Gold reset to 0", GameState.gold, 0)

func test_reset_clears_deck() -> void:
	GameState.add_card("card_001")
	GameState.add_card("card_002")
	GameState.reset()
	assert_empty("Deck cleared on reset", GameState.current_deck)

func test_reset_restores_m01_unlock() -> void:
	GameState.unlock_mission("M05")
	GameState.reset()
	assert_in("M01 re-unlocked after reset", "M01", GameState.unlocked_missions)
	assert_not_in("M05 gone after reset", "M05", GameState.unlocked_missions)

func test_reset_clears_completed_missions() -> void:
	GameState.complete_mission("M01")
	GameState.reset()
	assert_empty("Completed missions cleared on reset", GameState.completed_missions)

# ── Serialization ────────────────────────────────────────────────────────────
func test_to_dict_has_all_keys() -> void:
	var d = GameState.to_dict()
	for key in ["RENOWN","HEAT","PIETY","FAVOR","DEBT","DREAD","gold",
				"current_deck","completed_missions","unlocked_missions",
				"lieutenant_data","active_lieutenants","faction_status"]:
		assert_has_key("to_dict has '%s'" % key, d, key)

func test_from_dict_restores_state() -> void:
	GameState.change_meter("RENOWN", 7)
	GameState.add_gold(250)
	GameState.complete_mission("M01")
	var saved = GameState.to_dict()
	GameState.reset()
	GameState.from_dict(saved)
	assert_eq("RENOWN restored from dict", GameState.RENOWN, 7)
	assert_eq("Gold restored from dict",   GameState.gold, 250)
	assert_in("M01 restored in completed", "M01", GameState.completed_missions)

func test_from_dict_roundtrip_all_meters() -> void:
	GameState.change_meter("HEAT", 9)
	GameState.change_meter("PIETY", 5)
	GameState.change_meter("FAVOR", 4)
	GameState.change_meter("DREAD", 3)
	GameState.change_meter("DEBT", 100)
	var saved = GameState.to_dict()
	GameState.reset()
	GameState.from_dict(saved)
	assert_eq("HEAT roundtrip",  GameState.HEAT,  9)
	assert_eq("PIETY roundtrip", GameState.PIETY, 5)
	assert_eq("FAVOR roundtrip", GameState.FAVOR, 4)
	assert_eq("DREAD roundtrip", GameState.DREAD, 3)
	assert_eq("DEBT roundtrip",  GameState.DEBT,  100)
