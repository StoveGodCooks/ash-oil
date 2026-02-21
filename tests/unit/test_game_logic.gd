extends Node
## In-game unit tests for Ash & Oil core logic.
## Run via DevMenu "Run Tests" button or headlessly.
## No external test framework needed.

var passed: int = 0
var failed: int = 0
var results: Array = []

# ── Assert helpers ─────────────────────────────────────────────────────────
func assert_eq(label: String, got, expected) -> void:
	if got == expected:
		passed += 1
		results.append("[PASS] %s" % label)
	else:
		failed += 1
		results.append("[FAIL] %s — expected %s, got %s" % [label, str(expected), str(got)])

func assert_true(label: String, value: bool) -> void:
	if value:
		passed += 1
		results.append("[PASS] %s" % label)
	else:
		failed += 1
		results.append("[FAIL] %s — expected true, got false" % label)

func assert_false(label: String, value: bool) -> void:
	if not value:
		passed += 1
		results.append("[PASS] %s" % label)
	else:
		failed += 1
		results.append("[FAIL] %s — expected false, got true" % label)

func assert_gt(label: String, value, min_val) -> void:
	if value > min_val:
		passed += 1
		results.append("[PASS] %s" % label)
	else:
		failed += 1
		results.append("[FAIL] %s — %s not > %s" % [label, str(value), str(min_val)])

# ── Test Suites ────────────────────────────────────────────────────────────

func test_gamestate_meters() -> void:
	results.append("\n-- GameState: Meter Clamping --")
	GameState.reset()

	# RENOWN clamps at 20
	GameState.change_meter("RENOWN", 25)
	assert_eq("RENOWN max clamp (25 -> 20)", GameState.RENOWN, 20)

	# RENOWN clamps at 0
	GameState.change_meter("RENOWN", -999)
	assert_eq("RENOWN min clamp (0)", GameState.RENOWN, 0)

	# HEAT clamps at 15
	GameState.change_meter("HEAT", 100)
	assert_eq("HEAT max clamp (100 -> 15)", GameState.HEAT, 15)

	# PIETY clamps at 10
	GameState.change_meter("PIETY", 50)
	assert_eq("PIETY max clamp (50 -> 10)", GameState.PIETY, 10)

	# FAVOR clamps at 10
	GameState.change_meter("FAVOR", 50)
	assert_eq("FAVOR max clamp (50 -> 10)", GameState.FAVOR, 10)

	# DREAD clamps at 10
	GameState.change_meter("DREAD", 99)
	assert_eq("DREAD max clamp (99 -> 10)", GameState.DREAD, 10)

	# DEBT can go high (unlimited)
	GameState.change_meter("DEBT", 1000)
	assert_gt("DEBT unlimited (>0)", GameState.DEBT, 0)

	# DEBT clamps at 0 (no negative debt)
	GameState.change_meter("DEBT", -99999)
	assert_eq("DEBT min clamp (0)", GameState.DEBT, 0)


func test_gamestate_gold() -> void:
	results.append("\n-- GameState: Gold --")
	GameState.reset()

	GameState.add_gold(100)
	assert_eq("Add 100 gold", GameState.gold, 100)

	var spent = GameState.spend_gold(30)
	assert_true("Spend 30 gold succeeds", spent)
	assert_eq("Gold after spending 30", GameState.gold, 70)

	var over = GameState.spend_gold(200)
	assert_false("Spend 200 when only 70 fails", over)
	assert_eq("Gold unchanged after failed spend", GameState.gold, 70)


func test_gamestate_deck() -> void:
	results.append("\n-- GameState: Deck --")
	GameState.reset()

	# Add cards up to 30
	var added = 0
	for i in range(35):
		if GameState.add_card("card_001"):
			added += 1
	assert_eq("Deck capped at 30", GameState.current_deck.size(), 30)
	assert_eq("Returned false after cap", added, 30)

	# Discovered cards tracking
	assert_true("card_001 in discovered", "card_001" in GameState.discovered_cards)


func test_gamestate_missions() -> void:
	results.append("\n-- GameState: Mission Progression --")
	GameState.reset()

	assert_true("M01 unlocked at start", "M01" in GameState.unlocked_missions)
	assert_false("M01 not completed at start", "M01" in GameState.completed_missions)
	assert_true("M01 available at start", GameState.is_mission_available("M01"))

	GameState.complete_mission("M01")
	assert_true("M01 in completed after complete", "M01" in GameState.completed_missions)
	assert_false("M01 not available after complete", GameState.is_mission_available("M01"))

	GameState.unlock_mission("M02")
	assert_true("M02 unlocked manually", "M02" in GameState.unlocked_missions)
	assert_true("M02 available", GameState.is_mission_available("M02"))


func test_gamestate_lieutenants() -> void:
	results.append("\n-- GameState: Lieutenant Loyalty --")
	GameState.reset()

	GameState.change_loyalty("Marcus", 5)
	assert_eq("Marcus loyalty +5", GameState.lieutenant_data["Marcus"]["loyalty"], 5)

	# Clamp at max 10
	GameState.change_loyalty("Marcus", 10)
	assert_eq("Marcus loyalty clamped at 10", GameState.lieutenant_data["Marcus"]["loyalty"], 10)

	# Clamp at min -5
	GameState.change_loyalty("Marcus", -20)
	assert_eq("Marcus loyalty clamped at -5", GameState.lieutenant_data["Marcus"]["loyalty"], -5)

	# Recruit
	GameState.recruit_lieutenant("Marcus")
	assert_true("Marcus recruited", GameState.lieutenant_data["Marcus"]["recruited"])
	assert_true("Marcus in active squad", "Marcus" in GameState.active_lieutenants)


func test_card_manager() -> void:
	results.append("\n-- CardManager: Data Loading --")

	assert_gt("87 cards loaded", CardManager.cards_data.size(), 80)
	assert_eq("Exactly 8 lieutenants loaded", CardManager.lieutenants_data.size(), 8)
	assert_gt("Enemy templates loaded", CardManager.enemy_templates.size(), 0)

	var card = CardManager.get_card("card_001")
	assert_false("card_001 exists", card.is_empty())
	assert_eq("card_001 has correct type", card.get("type"), "attack")

	var missing = CardManager.get_card("card_999")
	assert_true("card_999 returns empty dict", missing.is_empty())

	var starter = CardManager.get_starter_deck()
	assert_gt("Starter deck has cards", starter.size(), 10)
	assert_true("Starter deck within 30", starter.size() <= 30)

	var lt = CardManager.get_lieutenant("Marcus")
	assert_false("Marcus lieutenant data exists", lt.is_empty())


func test_mission_manager() -> void:
	results.append("\n-- MissionManager: Mission Data --")

	var m01 = MissionManager.get_mission("M01")
	assert_false("M01 found in missions data", m01.is_empty())
	assert_eq("M01 name correct", m01.get("name"), "The Token")
	assert_gt("M01 has enemies", m01.get("enemies", []).size(), 0)

	var missing = MissionManager.get_mission("M99")
	assert_true("M99 returns empty dict", missing.is_empty())

	# Ending paths
	GameState.reset()
	GameState.change_meter("PIETY", 7)
	assert_eq("PIETY>=7 gives Cult ending", MissionManager.check_ending_path(), "Cult")

	GameState.reset()
	GameState.change_meter("FAVOR", 6)
	assert_eq("FAVOR>=6 gives State ending", MissionManager.check_ending_path(), "State")

	GameState.reset()
	assert_eq("No high meters gives Solo ending", MissionManager.check_ending_path(), "Solo")


func test_enemy_loading() -> void:
	results.append("\n-- CardManager: Enemy Loading --")
	GameState.reset()

	var enemies = CardManager.get_mission_enemies("M01")
	assert_gt("M01 has enemies loaded", enemies.size(), 0)
	assert_eq("M01 first enemy is Quintus", enemies[0].get("name"), "Quintus")

	var e = enemies[0]
	assert_true("Enemy has hp", e.has("hp"))
	assert_true("Enemy has armor", e.has("armor"))
	assert_true("Enemy has damage", e.has("damage"))
	assert_eq("M01 enemy hp/max_hp match", e.get("hp"), e.get("max_hp"))

	# Verify enemies are duplicated (not shared references)
	enemies[0]["hp"] = 0
	var enemies2 = CardManager.get_mission_enemies("M01")
	assert_eq("Enemies are independent copies", enemies2[0].get("hp"), enemies2[0].get("max_hp"))


# ── Runner ─────────────────────────────────────────────────────────────────
func run_all() -> String:
	passed = 0
	failed = 0
	results = []

	results.append("=" .repeat(50))
	results.append("  ASH & OIL - IN-GAME UNIT TESTS")
	results.append("=" .repeat(50))

	test_gamestate_meters()
	test_gamestate_gold()
	test_gamestate_deck()
	test_gamestate_missions()
	test_gamestate_lieutenants()
	test_card_manager()
	test_mission_manager()
	test_enemy_loading()

	results.append("\n" + "=" .repeat(50))
	results.append("  RESULTS: %d passed | %d failed" % [passed, failed])
	results.append("=" .repeat(50))

	# Print to output console
	for r in results:
		print(r)

	# Restore clean state
	GameState.reset()

	return "\n".join(results)
