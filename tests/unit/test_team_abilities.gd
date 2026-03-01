extends "res://tests/runner/TestBase.gd"
## Team ability system tests — verifying combo effects between champion and lieutenant.

const COMBAT_UI_SCRIPT = preload("res://scripts/ui/CombatUI.gd")

func _setup_combat() -> Control:
	var combat = COMBAT_UI_SCRIPT.new()
	add_child(combat)
	# Force initialization of key variables
	combat.champion_hp = 20
	combat.champion_max_hp = 30
	combat.champion_armor = 0
	combat.lt_hp = 15
	combat.lt_max_hp = 25
	combat.lt_armor = 0
	combat.lt_name = "Marcus"
	combat.command_points = 5
	combat.enemies = [{"name": "Dummy", "hp": 10, "max_hp": 10, "armor": 0, "damage": 2}]
	return combat

func test_evasion_team_applies_armor_to_both() -> void:
	var combat = _setup_combat()
	var card_data = {
		"id": "test_evasion",
		"type": "evasion",
		"effect": "evasion_team",
		"cost": 1
	}
	combat.champion_armor = 0
	combat.lt_armor = 0

	combat._execute_card_logic(card_data, 0)

	assert_eq("Champion gained 3 armor from evasion", combat.champion_armor, 3)
	assert_eq("Lieutenant gained 2 armor from evasion_team", combat.lt_armor, 2)

	combat.queue_free()

func test_team_protect_applies_armor_to_both() -> void:
	var combat = _setup_combat()
	var card_data = {
		"id": "test_protect",
		"type": "defense",
		"armor": 5,
		"effect": "team_protect",
		"cost": 1
	}
	combat.champion_armor = 0
	combat.lt_armor = 0

	combat._execute_card_logic(card_data, 0)

	assert_eq("Champion gained 5 armor", combat.champion_armor, 5)
	assert_eq("Lieutenant gained 4 armor from team_protect", combat.lt_armor, 4)

	combat.queue_free()

func test_morale_boost_team_heals_both() -> void:
	var combat = _setup_combat()
	combat.hand = ["test_morale"]
	var card_btn = Control.new()

	# Override CardManager.get_card for this test if needed,
	# but we can just use _apply_support_effect directly for speed.

	combat.champion_hp = 10
	combat.lt_hp = 10

	combat._apply_support_effect("morale_boost_team")

	assert_eq("Champion healed 3 HP", combat.champion_hp, 13)
	assert_eq("Lieutenant healed 3 HP", combat.lt_hp, 13)

	combat.queue_free()

func test_regen_team_heals_both() -> void:
	var combat = _setup_combat()
	combat.champion_hp = 10
	combat.lt_hp = 10

	combat._apply_support_effect("regen_team")

	assert_eq("Champion healed 5 HP", combat.champion_hp, 15)
	assert_eq("Lieutenant healed 5 HP", combat.lt_hp, 15)

	combat.queue_free()

func test_bless_team_applies_armor_to_both() -> void:
	var combat = _setup_combat()
	combat.champion_armor = 0
	combat.lt_armor = 0

	combat._apply_global_effect("bless_team")

	assert_eq("Champion gained 3 armor", combat.champion_armor, 3)
	assert_eq("Lieutenant gained 3 armor", combat.lt_armor, 3)

	combat.queue_free()

func test_team_buff_all_applies_armor_and_hp() -> void:
	var combat = _setup_combat()
	combat.champion_hp = 10
	combat.lt_hp = 10
	combat.champion_armor = 0
	combat.lt_armor = 0

	combat._apply_support_effect("team_buff_all")

	assert_eq("Champion +2 HP", combat.champion_hp, 12)
	assert_eq("Lieutenant +2 HP", combat.lt_hp, 12)
	assert_eq("Champion +2 Armor", combat.champion_armor, 2)
	assert_eq("Lieutenant +2 Armor", combat.lt_armor, 2)

	combat.queue_free()
