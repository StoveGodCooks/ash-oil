extends "res://tests/runner/TestBase.gd"
## Integration tests — full save/load cycle with real game state

const SLOT = 6

func setup() -> void:
	GameState.reset()
	if SaveManager.save_exists(SLOT):
		SaveManager.delete_save(SLOT)

func teardown() -> void:
	if SaveManager.save_exists(SLOT):
		SaveManager.delete_save(SLOT)
	GameState.reset()

# ── Full State Roundtrip ──────────────────────────────────────────────────────
func test_full_state_roundtrip() -> void:
	## Set up a rich game state, save it, reset, load it, verify everything
	GameState.change_meter("RENOWN", 10)
	GameState.change_meter("HEAT",    5)
	GameState.change_meter("PIETY",   3)
	GameState.change_meter("FAVOR",   4)
	GameState.change_meter("DREAD",   2)
	GameState.change_meter("DEBT",  150)
	GameState.add_gold(350)
	GameState.current_deck = CardManager.get_starter_deck()
	GameState.complete_mission("M01")
	GameState.unlock_mission("M02")
	GameState.unlock_mission("S01")
	GameState.change_loyalty("Marcus", 6)
	GameState.recruit_lieutenant("Marcus")
	GameState.story_flags["lanista_met"] = true

	SaveManager.save_game(SLOT)
	GameState.reset()

	# Verify reset actually cleared things
	assert_eq("Sanity: RENOWN=0 after reset", GameState.RENOWN, 0)

	var load_result = SaveManager.load_game(SLOT)
	assert_true("Load succeeded", load_result)

	assert_eq("RENOWN restored", GameState.RENOWN, 10)
	assert_eq("HEAT restored",   GameState.HEAT,    5)
	assert_eq("PIETY restored",  GameState.PIETY,   3)
	assert_eq("FAVOR restored",  GameState.FAVOR,   4)
	assert_eq("DREAD restored",  GameState.DREAD,   2)
	assert_eq("DEBT restored",   GameState.DEBT,  150)
	assert_eq("Gold restored",   GameState.gold,  350)
	assert_in("M01 in completed", "M01", GameState.completed_missions)
	assert_in("M02 in unlocked",  "M02", GameState.unlocked_missions)
	assert_in("S01 in unlocked",  "S01", GameState.unlocked_missions)
	assert_eq("Marcus loyalty restored", GameState.lieutenant_data["Marcus"]["loyalty"], 6)
	assert_true("Marcus recruited restored", GameState.lieutenant_data["Marcus"]["recruited"])
	assert_true("story_flag lanista_met", GameState.story_flags.get("lanista_met", false))
	assert_not_empty("Deck restored", GameState.current_deck)

# ── Mid-Mission Save ──────────────────────────────────────────────────────────
func test_save_mid_mission_progress() -> void:
	## Simulate completing a few missions, save, reload, verify progress
	MissionManager.complete_mission("M01", "victory")
	MissionManager.complete_mission("M02", "victory")
	var gold_before = GameState.gold
	var renown_before = GameState.RENOWN

	SaveManager.save_game(SLOT)
	GameState.reset()
	SaveManager.load_game(SLOT)

	assert_eq("Gold preserved mid-campaign", GameState.gold, gold_before)
	assert_eq("RENOWN preserved mid-campaign", GameState.RENOWN, renown_before)
	assert_in("M01 completed preserved", "M01", GameState.completed_missions)
	assert_in("M02 completed preserved", "M02", GameState.completed_missions)
	assert_in("M03 unlocked preserved",  "M03", GameState.unlocked_missions)

# ── Deck Persistence ──────────────────────────────────────────────────────────
func test_custom_deck_survives_save_load() -> void:
	var custom_deck = ["card_001","card_002","card_003","card_027","card_028"]
	GameState.current_deck = custom_deck.duplicate()
	SaveManager.save_game(SLOT)
	GameState.reset()
	SaveManager.load_game(SLOT)

	assert_size("Custom deck size preserved", GameState.current_deck, custom_deck.size())
	for cid in custom_deck:
		assert_in("%s in restored deck" % cid, cid, GameState.current_deck)

func test_discovered_cards_survive_save_load() -> void:
	GameState.current_deck = CardManager.get_starter_deck()
	GameState.discovered_cards = ["card_001","card_002","card_010","card_020"]
	SaveManager.save_game(SLOT)
	GameState.reset()
	SaveManager.load_game(SLOT)
	assert_in("card_010 in discovered after load", "card_010", GameState.discovered_cards)

# ── Auto-Save Integration ─────────────────────────────────────────────────────
func test_auto_save_after_mission_complete() -> void:
	if SaveManager.save_exists(0):
		SaveManager.delete_save(0)
	GameState.current_deck = CardManager.get_starter_deck()
	MissionManager.complete_mission("M01", "victory")
	# complete_mission calls auto_save internally
	assert_true("Auto-save created after mission complete", SaveManager.save_exists(0))

func test_auto_save_has_correct_state() -> void:
	if SaveManager.save_exists(0):
		SaveManager.delete_save(0)
	GameState.current_deck = CardManager.get_starter_deck()
	GameState.add_gold(100)
	MissionManager.complete_mission("M01", "victory")
	var gold_before_load = GameState.gold

	GameState.reset()
	SaveManager.load_game(0)
	assert_eq("Auto-save gold correct", GameState.gold, gold_before_load)

# ── Continue Game Flow ────────────────────────────────────────────────────────
func test_continue_from_saved_game_is_correct_state() -> void:
	## Simulate: play → save → quit → continue
	GameState.change_meter("RENOWN", 5)
	GameState.add_gold(200)
	GameState.complete_mission("M01", "victory")
	SaveManager.save_game(0)

	# Simulate "quit"
	GameState.reset()
	assert_eq("State reset (simulating quit)", GameState.RENOWN, 0)

	# Simulate "continue"
	var loaded = SaveManager.load_game(0)
	assert_true("Continue: load succeeded", loaded)
	assert_eq("Continue: RENOWN correct", GameState.RENOWN, 5)
	assert_eq("Continue: gold correct",   GameState.gold, 200)
	assert_in("Continue: M01 completed",  "M01", GameState.completed_missions)
	assert_true("Continue: M02 available", GameState.is_mission_available("M02"))
