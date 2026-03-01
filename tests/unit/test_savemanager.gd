extends "res://tests/runner/TestBase.gd"
## SaveManager unit tests — save/load/delete/auto-save

const TEST_SLOT = 9  # Use slot 9 to avoid interfering with real saves

func setup() -> void:
	GameState.reset()
	# Clean up test slot before each test
	if SaveManager.save_exists(TEST_SLOT):
		SaveManager.delete_save(TEST_SLOT)

func teardown() -> void:
	# Clean up test slot after each test
	if SaveManager.save_exists(TEST_SLOT):
		SaveManager.delete_save(TEST_SLOT)
	GameState.reset()

# ── Save Existence ────────────────────────────────────────────────────────────
func test_save_exists_returns_false_for_empty_slot() -> void:
	assert_false("Save slot %d empty at start" % TEST_SLOT, SaveManager.save_exists(TEST_SLOT))

func test_save_exists_returns_true_after_save() -> void:
	SaveManager.save_game(TEST_SLOT)
	assert_true("Save exists after save_game", SaveManager.save_exists(TEST_SLOT))

# ── Save / Load ───────────────────────────────────────────────────────────────
func test_save_and_load_gold() -> void:
	GameState.add_gold(777)
	SaveManager.save_game(TEST_SLOT)
	GameState.reset()
	assert_eq("Gold is 0 after reset", GameState.gold, 0)
	SaveManager.load_game(TEST_SLOT)
	assert_eq("Gold restored to 777 after load", GameState.gold, 777)

func test_save_and_load_renown() -> void:
	GameState.change_meter("RENOWN", 12)
	SaveManager.save_game(TEST_SLOT)
	GameState.reset()
	SaveManager.load_game(TEST_SLOT)
	assert_eq("RENOWN restored to 12", GameState.renown, 12)

func test_save_and_load_all_meters() -> void:
	GameState.change_meter("RENOWN", 8)
	GameState.change_meter("HEAT",   7)
	GameState.change_meter("PIETY",  5)
	GameState.change_meter("FAVOR",  4)
	GameState.change_meter("DREAD",  3)
	GameState.change_meter("DEBT",  200)
	SaveManager.save_game(TEST_SLOT)
	GameState.reset()
	SaveManager.load_game(TEST_SLOT)
	assert_eq("RENOWN roundtrip", GameState.renown, 8)
	assert_eq("HEAT roundtrip",   GameState.heat,   7)
	assert_eq("PIETY roundtrip",  GameState.piety,  5)
	assert_eq("FAVOR roundtrip",  GameState.favor,  4)
	assert_eq("DREAD roundtrip",  GameState.dread,  3)
	assert_eq("DEBT roundtrip",   GameState.debt,  200)

func test_save_and_load_deck() -> void:
	GameState.current_deck = ["card_001", "card_002", "card_027"]
	SaveManager.save_game(TEST_SLOT)
	GameState.reset()
	SaveManager.load_game(TEST_SLOT)
	assert_size("Deck restored with 3 cards", GameState.current_deck, 3)
	assert_in("card_001 in restored deck", "card_001", GameState.current_deck)

func test_save_and_load_completed_missions() -> void:
	GameState.complete_mission("M01")
	SaveManager.save_game(TEST_SLOT)
	GameState.reset()
	SaveManager.load_game(TEST_SLOT)
	assert_in("M01 in restored completed_missions", "M01", GameState.completed_missions)

func test_save_and_load_unlocked_missions() -> void:
	GameState.unlock_mission("M05")
	GameState.unlock_mission("S01")
	SaveManager.save_game(TEST_SLOT)
	GameState.reset()
	SaveManager.load_game(TEST_SLOT)
	assert_in("M05 in restored unlocked_missions", "M05", GameState.unlocked_missions)
	assert_in("S01 in restored unlocked_missions", "S01", GameState.unlocked_missions)

func test_save_and_load_lieutenant_loyalty() -> void:
	GameState.change_loyalty("Marcus", 7)
	GameState.recruit_lieutenant("Livia")
	SaveManager.save_game(TEST_SLOT)
	GameState.reset()
	SaveManager.load_game(TEST_SLOT)
	assert_eq("Marcus loyalty restored", GameState.lieutenant_data["Marcus"]["loyalty"], 7)
	assert_true("Livia recruited status restored", GameState.lieutenant_data["Livia"]["recruited"])

func test_save_and_load_story_flags() -> void:
	GameState.story_flags["lanista_met"] = true
	GameState.story_flags["quest_count"] = 3
	SaveManager.save_game(TEST_SLOT)
	GameState.reset()
	SaveManager.load_game(TEST_SLOT)
	assert_true("story_flag lanista_met restored", GameState.story_flags.get("lanista_met", false))
	assert_eq("story_flag quest_count restored", GameState.story_flags.get("quest_count", 0), 3)

func test_load_returns_true_on_success() -> void:
	SaveManager.save_game(TEST_SLOT)
	var result = SaveManager.load_game(TEST_SLOT)
	assert_true("load_game returns true on success", result)

func test_load_returns_false_when_no_save() -> void:
	var result = SaveManager.load_game(TEST_SLOT)
	assert_false("load_game returns false when no save", result)

# ── Delete ────────────────────────────────────────────────────────────────────
func test_delete_save_removes_file() -> void:
	SaveManager.save_game(TEST_SLOT)
	assert_true("Save exists before delete", SaveManager.save_exists(TEST_SLOT))
	SaveManager.delete_save(TEST_SLOT)
	assert_false("Save gone after delete", SaveManager.save_exists(TEST_SLOT))

func test_delete_nonexistent_does_not_crash() -> void:
	SaveManager.delete_save(TEST_SLOT)  # Should not throw
	assert_true("Delete nonexistent save does not crash", true)

# ── Auto Save ─────────────────────────────────────────────────────────────────
func test_auto_save_creates_slot_zero() -> void:
	# Clean slot 0 first
	if SaveManager.save_exists(0):
		SaveManager.delete_save(0)
	GameState.add_gold(42)
	SaveManager.auto_save()
	assert_true("auto_save creates slot 0", SaveManager.save_exists(0))

func test_auto_save_stores_current_state() -> void:
	if SaveManager.save_exists(0):
		SaveManager.delete_save(0)
	GameState.add_gold(99)
	SaveManager.auto_save()
	GameState.reset()
	SaveManager.load_game(0)
	assert_eq("auto_save stores gold correctly", GameState.gold, 99)

# ── Multiple Slots Independent ────────────────────────────────────────────────
func test_multiple_slots_are_independent() -> void:
	var slot_a = 7
	var slot_b = 8
	# Clean
	if SaveManager.save_exists(slot_a): SaveManager.delete_save(slot_a)
	if SaveManager.save_exists(slot_b): SaveManager.delete_save(slot_b)

	GameState.add_gold(100)
	SaveManager.save_game(slot_a)

	GameState.reset()
	GameState.add_gold(200)
	SaveManager.save_game(slot_b)

	SaveManager.load_game(slot_a)
	assert_eq("Slot A has 100 gold", GameState.gold, 100)

	SaveManager.load_game(slot_b)
	assert_eq("Slot B has 200 gold", GameState.gold, 200)

	# Cleanup
	SaveManager.delete_save(slot_a)
	SaveManager.delete_save(slot_b)



