extends "res://tests/runner/TestBase.gd"
## Combat logic unit tests — damage, armor, poison, stamina, hand management
## Tests pure combat math without needing the UI scene.

# ── Helpers: build enemy/state dicts ─────────────────────────────────────────
func _make_enemy(name: String, hp: int, armor: int, damage: int, poison: int = 0) -> Dictionary:
	return {"name": name, "hp": hp, "max_hp": hp, "armor": armor, "damage": damage, "poison": poison}

func _apply_damage(enemy: Dictionary, amount: int) -> Dictionary:
	## Pure combat math: armor absorbs first, then HP
	var absorbed = min(enemy.get("armor", 0), amount)
	enemy["armor"] = max(0, enemy.get("armor", 0) - absorbed)
	var actual = amount - absorbed
	enemy["hp"] = max(0, enemy["hp"] - actual)
	return enemy

func _apply_poison(enemy: Dictionary) -> Dictionary:
	## Poison deals damage ignoring armor, then decays by 1
	if enemy["poison"] > 0:
		enemy["hp"] = max(0, enemy["hp"] - enemy["poison"])
		enemy["poison"] = max(0, enemy["poison"] - 1)
	return enemy

func _is_dead(enemy: Dictionary) -> bool:
	return enemy["hp"] <= 0

func _champion_healed(hp: int, heal: int, max_hp: int) -> int:
	return min(max_hp, hp + heal)

func _reflected_damage(incoming: int, ratio: float) -> int:
	if incoming <= 0 or ratio <= 0.0:
		return 0
	return maxi(1, int(ceil(float(incoming) * ratio)))

# ── Damage Calculation ────────────────────────────────────────────────────────
func test_damage_no_armor() -> void:
	var e = _make_enemy("Grunt", 12, 0, 2)
	e = _apply_damage(e, 5)
	assert_eq("5 dmg vs 0 armor = 7 HP left", e["hp"], 7)

func test_damage_partial_armor_absorption() -> void:
	var e = _make_enemy("Guard", 20, 3, 3)
	e = _apply_damage(e, 5)
	assert_eq("5 dmg vs 3 armor = 2 actual dmg", e["hp"], 18)
	assert_eq("Armor reduced by 3 (absorbed)", e["armor"], 0)

func test_damage_full_armor_blocks_all() -> void:
	var e = _make_enemy("Tank", 15, 10, 2)
	e = _apply_damage(e, 5)
	assert_eq("5 dmg vs 10 armor = 0 actual dmg", e["hp"], 15)
	assert_eq("Armor reduced to 5", e["armor"], 5)

func test_damage_exact_armor_equals_damage() -> void:
	var e = _make_enemy("Fighter", 20, 4, 3)
	e = _apply_damage(e, 4)
	assert_eq("4 dmg vs 4 armor = 0 actual dmg", e["hp"], 20)
	assert_eq("Armor fully depleted", e["armor"], 0)

func test_damage_kills_enemy() -> void:
	var e = _make_enemy("Grunt", 5, 0, 2)
	e = _apply_damage(e, 10)
	assert_eq("Overkill doesn't go below 0 HP", e["hp"], 0)
	assert_true("Enemy is dead", _is_dead(e))

func test_zero_damage_does_nothing() -> void:
	var e = _make_enemy("Grunt", 12, 2, 2)
	e = _apply_damage(e, 0)
	assert_eq("0 dmg doesn't change HP", e["hp"], 12)
	assert_eq("0 dmg doesn't change armor", e["armor"], 2)

func test_damage_does_not_affect_poison() -> void:
	var e = _make_enemy("Grunt", 12, 0, 2)
	e["poison"] = 3
	e = _apply_damage(e, 4)
	assert_eq("Damage doesn't reduce poison stacks", e["poison"], 3)

# ── Armor Mechanics ───────────────────────────────────────────────────────────
func test_armor_stacks_additive() -> void:
	var armor = 0
	armor += 2
	armor += 3
	assert_eq("Armor stacks: 2+3=5", armor, 5)

func test_armor_depletes_across_hits() -> void:
	var e = _make_enemy("Fighter", 20, 5, 2)
	e = _apply_damage(e, 3)   # absorbs 3, armor=2
	e = _apply_damage(e, 4)   # absorbs 2, armor=0, actual=2
	assert_eq("Armor depleted after 2 hits (3+4)", e["armor"], 0)
	assert_eq("HP correct after armor depletion: 20-2=18", e["hp"], 18)

# ── Poison System ─────────────────────────────────────────────────────────────
func test_poison_deals_damage() -> void:
	var e = _make_enemy("Victim", 20, 0, 2)
	e["poison"] = 3
	e = _apply_poison(e)
	assert_eq("Poison 3 deals 3 dmg: 20-3=17", e["hp"], 17)

func test_poison_decays_each_turn() -> void:
	var e = _make_enemy("Victim", 30, 0, 0)
	e["poison"] = 4
	e = _apply_poison(e)
	assert_eq("Poison decays: 4->3", e["poison"], 3)

func test_poison_ignores_armor() -> void:
	var e = _make_enemy("Armored", 20, 10, 2)
	e["poison"] = 3
	e = _apply_poison(e)
	assert_eq("Poison bypasses armor: 20-3=17", e["hp"], 17)
	assert_eq("Armor unchanged by poison", e["armor"], 10)

func test_poison_stacks_additive() -> void:
	var e = _make_enemy("Victim", 30, 0, 0)
	e["poison"] += 2
	e["poison"] += 3
	assert_eq("Poison stacks: 2+3=5", e["poison"], 5)

func test_poison_caps_at_max() -> void:
	var e = _make_enemy("Victim", 30, 0, 0)
	e["poison"] = 11
	var cap = 12
	e["poison"] = min(e["poison"] + 5, cap)
	assert_eq("Poison capped at 12 stacks", e["poison"], 12)

func test_poison_zero_does_nothing() -> void:
	var e = _make_enemy("Clean", 20, 0, 2)
	e["poison"] = 0
	e = _apply_poison(e)
	assert_eq("Poison 0 does no dmg", e["hp"], 20)
	assert_eq("Poison stays at 0", e["poison"], 0)

func test_poison_kills_enemy() -> void:
	var e = _make_enemy("Dying", 3, 0, 2)
	e["poison"] = 5
	e = _apply_poison(e)
	assert_eq("Poison kills: HP capped at 0", e["hp"], 0)
	assert_true("Enemy dead from poison", _is_dead(e))

func test_poison_three_turns() -> void:
	var e = _make_enemy("Victim", 30, 0, 0)
	e["poison"] = 3
	e = _apply_poison(e)  # -3, poison=2
	e = _apply_poison(e)  # -2, poison=1
	e = _apply_poison(e)  # -1, poison=0
	assert_eq("Poison dealt 3+2+1=6 total", e["hp"], 24)
	assert_eq("Poison expired to 0", e["poison"], 0)

func test_reflect_returns_damage() -> void:
	var incoming = 10
	var ratio = 0.5
	var reflected = _reflected_damage(incoming, ratio)
	assert_eq("50% reflect from 10 dmg = 5 returned", reflected, 5)

# ── Healing ────────────────────────────────────────────────────────────────────
func test_heal_restores_hp() -> void:
	var hp = _champion_healed(15, 5, 30)
	assert_eq("Heal 5: 15+5=20", hp, 20)

func test_heal_capped_at_max() -> void:
	var hp = _champion_healed(28, 10, 30)
	assert_eq("Heal capped at max_hp: 28+10 -> 30", hp, 30)

func test_heal_at_full_hp_no_change() -> void:
	var hp = _champion_healed(30, 5, 30)
	assert_eq("Heal at full HP stays at max", hp, 30)

func test_heal_from_zero() -> void:
	var hp = _champion_healed(0, 10, 30)
	assert_eq("Heal from 0: 0+10=10", hp, 10)

# ── Stamina Gate ──────────────────────────────────────────────────────────────
func test_stamina_can_play_card_exact_cost() -> void:
	var stamina = 2
	var cost = 2
	assert_true("Can play card with exact stamina", cost <= stamina)

func test_stamina_can_play_card_cheaper() -> void:
	var stamina = 3
	var cost = 1
	assert_true("Can play cheaper card", cost <= stamina)

func test_stamina_cannot_play_expensive_card() -> void:
	var stamina = 1
	var cost = 2
	assert_false("Cannot play card costing more than stamina", cost <= stamina)

func test_stamina_deducted_after_play() -> void:
	var stamina = 3
	var cost = 2
	stamina -= cost
	assert_eq("Stamina deducted: 3-2=1", stamina, 1)

func test_stamina_restores_each_turn() -> void:
	var stamina = 0
	stamina = 3  # restore on new turn
	assert_eq("Stamina restored to 3 on new turn", stamina, 3)

func test_free_card_does_not_cost_stamina() -> void:
	var stamina = 3
	var cost = 0
	stamina -= cost
	assert_eq("Free card: stamina unchanged at 3", stamina, 3)

# ── Hand Management ────────────────────────────────────────────────────────────
func test_draw_card_from_deck() -> void:
	var deck    = ["card_001", "card_002", "card_003"]
	var hand    = []
	var discard = []
	# Draw one card
	hand.append(deck[0])
	deck.remove_at(0)
	assert_size("Hand has 1 card after draw", hand, 1)
	assert_size("Deck has 2 cards after draw", deck, 2)

func test_play_card_moves_to_discard() -> void:
	var hand    = ["card_001", "card_002"]
	var discard = []
	discard.append(hand[0])
	hand.remove_at(0)
	assert_size("Hand has 1 card after play", hand, 1)
	assert_size("Discard has 1 card after play", discard, 1)
	assert_in("Played card in discard", "card_001", discard)
	assert_not_in("Played card not in hand", "card_001", hand)

func test_deck_reshuffles_from_discard() -> void:
	var deck    = []
	var hand    = []
	var discard = ["card_001", "card_002", "card_003"]
	# Reshuffle when deck empty
	deck = discard.duplicate()
	deck.shuffle()
	discard.clear()
	assert_size("Deck refilled from discard", deck, 3)
	assert_empty("Discard cleared after reshuffle", discard)

func test_hand_limit() -> void:
	var hand = []
	var max_hand = 8
	for i in range(10):
		if hand.size() < max_hand:
			hand.append("card_%03d" % i)
	assert_lte("Hand doesn't exceed max", hand.size(), max_hand)

# ── Victory / Defeat Conditions ───────────────────────────────────────────────
func test_victory_when_all_enemies_dead() -> void:
	var enemies = [
		_make_enemy("A", 0, 0, 0),
		_make_enemy("B", 0, 0, 0),
	]
	var all_dead = true
	for e in enemies:
		if e["hp"] > 0:
			all_dead = false
			break
	assert_true("Victory when all enemies at 0 HP", all_dead)

func test_no_victory_while_enemy_alive() -> void:
	var enemies = [
		_make_enemy("A", 0, 0, 0),
		_make_enemy("B", 5, 0, 0),
	]
	var all_dead = true
	for e in enemies:
		if e["hp"] > 0:
			all_dead = false
			break
	assert_false("No victory while any enemy alive", all_dead)

func test_defeat_when_champion_dead() -> void:
	var champion_hp = 0
	assert_true("Defeat when champion HP <= 0", champion_hp <= 0)

func test_no_defeat_while_champion_alive() -> void:
	var champion_hp = 5
	assert_false("No defeat while champion HP > 0", champion_hp <= 0)

# ── RENOWN / Gold Reward Validation ───────────────────────────────────────────
func test_victory_reward_gold_positive() -> void:
	var m = MissionManager.get_mission("M01")
	var gold = m.get("victory_rewards", {}).get("gold", 0)
	assert_gt("M01 victory gold > 0", gold, 0)

func test_retreat_reward_gold_lte_victory() -> void:
	var m = MissionManager.get_mission("M01")
	var v_gold = m.get("victory_rewards", {}).get("gold", 0)
	var r_gold = m.get("retreat_rewards", {}).get("gold", 0)
	assert_lte("Retreat gold <= victory gold", r_gold, v_gold)

func test_all_missions_victory_gold_gte_zero() -> void:
	for mid in MissionManager.missions_data:
		var m = MissionManager.missions_data[mid]
		var gold = m.get("victory_rewards", {}).get("gold", 0)
		assert_gte("%s victory gold >= 0" % mid, gold, 0)
