extends "res://tests/runner/TestBase.gd"
## Gear system tests — combat stat application and drop distribution.

const COMBAT_UI_SCRIPT = preload("res://scripts/ui/CombatUI.gd")

func _make_combat_with_gear(equipped: Dictionary) -> Control:
	GameState.equipped_gear = equipped
	var combat = COMBAT_UI_SCRIPT.new()
	combat._init_state()
	return combat

func test_base_stats_no_gear() -> void:
	var combat = _make_combat_with_gear({"weapon": "", "armor": "", "accessory": ""})
	assert_eq("Base HP max is 30", combat.champion_max_hp, 30)
	assert_eq("Base HP current is 30", combat.champion_hp, 30)
	assert_eq("Base armor is 0", combat.champion_armor, 0)
	assert_eq("Base damage bonus is 0", combat.gear_flat_damage_bonus, 0)

func test_single_gear_applies_hp() -> void:
	var combat = _make_combat_with_gear({"weapon": "", "armor": "gear_009", "accessory": ""})
	assert_eq("Leather Vest adds +3 max HP", combat.champion_max_hp, 33)
	assert_eq("Leather Vest boosts current HP", combat.champion_hp, 33)

func test_multiple_gear_stack_bonuses() -> void:
	var combat = _make_combat_with_gear({"weapon": "gear_001", "armor": "gear_009", "accessory": "gear_017"})
	assert_eq("HP bonuses stack", combat.champion_max_hp, 35)
	assert_eq("Damage bonus applied", combat.gear_flat_damage_bonus, 1)

func test_unequip_removes_bonus_next_combat() -> void:
	_make_combat_with_gear({"weapon": "", "armor": "gear_009", "accessory": ""})
	var combat = _make_combat_with_gear({"weapon": "", "armor": "", "accessory": ""})
	assert_eq("HP reset without gear", combat.champion_max_hp, 30)

func test_reequip_restores_bonus() -> void:
	_make_combat_with_gear({"weapon": "", "armor": "", "accessory": ""})
	var combat = _make_combat_with_gear({"weapon": "", "armor": "gear_009", "accessory": ""})
	assert_eq("HP restored after re-equip", combat.champion_max_hp, 33)

func test_damage_bonus_integration() -> void:
	var combat = _make_combat_with_gear({"weapon": "gear_004", "armor": "", "accessory": ""})
	var base_damage = 2
	assert_eq("Damage bonus adds +2", combat._get_total_attack_damage(base_damage), 4)

func test_armor_bonus_integration() -> void:
	var combat = _make_combat_with_gear({"weapon": "", "armor": "gear_010", "accessory": ""})
	assert_eq("Armor bonus applies at start", combat.champion_armor, 4)

func test_hp_bonus_integration() -> void:
	var combat = _make_combat_with_gear({"weapon": "", "armor": "gear_014", "accessory": ""})
	assert_eq("HP bonus applies at start", combat.champion_max_hp, 36)

func test_no_negative_stats_from_gear() -> void:
	var combat = _make_combat_with_gear({"weapon": "", "armor": "", "accessory": "gear_023"})
	assert_gt("Max HP never below 1", combat.champion_max_hp, 0)
	assert_gt("Current HP never below 1", combat.champion_hp, 0)

func test_combat_does_not_modify_persistent_gear() -> void:
	var equipped = {"weapon": "gear_001", "armor": "", "accessory": ""}
	GameState.equipped_gear = equipped.duplicate()
	var _combat = _make_combat_with_gear(equipped)
	assert_eq("Equipped gear unchanged after combat init", GameState.equipped_gear["weapon"], "gear_001")

func test_rarity_distribution_over_5000_drops() -> void:
	MissionManager.set_gear_rng_seed(12345)
	var counts = {"common": 0, "rare": 0, "epic": 0}
	var total = 5000
	for i in range(total):
		var rarity = MissionManager.roll_gear_rarity()
		counts[rarity] += 1
	var common_pct = (float(counts["common"]) / float(total)) * 100.0
	var rare_pct = (float(counts["rare"]) / float(total)) * 100.0
	var epic_pct = (float(counts["epic"]) / float(total)) * 100.0
	assert_between("Common ~90% (±2%)", common_pct, 88.0, 92.0)
	assert_between("Rare ~9% (±2%)", rare_pct, 7.0, 11.0)
	assert_between("Epic ~1% (±2%)", epic_pct, 0.0, 3.0)

func test_drop_chance_increases_with_act() -> void:
	var act1 = MissionManager.get_drop_chance_for_act(1)
	var act2 = MissionManager.get_drop_chance_for_act(2)
	var act3 = MissionManager.get_drop_chance_for_act(3)
	assert_gt("Act 2 drop chance > Act 1", act2, act1)
	assert_gt("Act 3 drop chance > Act 2", act3, act2)

func test_fallback_gold_when_all_gear_owned() -> void:
	GameState.owned_gear = []
	for gear_id in CardManager.gear_data.keys():
		GameState.owned_gear.append(gear_id)
	MissionManager.set_gear_rng_seed(42)
	MissionManager.missions_data["TEST_DROP"] = {"act": 4, "victory_rewards": {"gold": 0}}
	var reward = MissionManager.generate_mission_reward("TEST_DROP", "victory", 1.0)
	MissionManager.missions_data.erase("TEST_DROP")
	assert_eq("No gear awarded when pool empty", reward.get("gear_id", ""), "")
	assert_gt("Fallback gold granted", int(reward.get("gold", 0)), 0)
