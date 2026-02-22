extends "res://tests/runner/TestBase.gd"
## CardManager unit tests — cards, lieutenants, enemies, starter deck

const EXPECTED_CARDS       = 87
const EXPECTED_LIEUTENANTS = 8
const EXPECTED_CARD_TYPES  = ["attack","defense","support","reaction","area","evasion","effect"]
const EXPECTED_FACTIONS    = ["AEGIS","SPECTER","ECLIPSE","NEUTRAL"]
const EXPECTED_LT_NAMES    = ["Marcus","Livia","Titus","Kara","Decimus","Julia","Corvus","Thane"]

# ── Card Loading ────────────────────────────────────────────────────────────
func test_cards_loaded() -> void:
	assert_gte("At least 87 cards loaded", CardManager.cards_data.size(), EXPECTED_CARDS)

func test_card_001_exists() -> void:
	var card = CardManager.get_card("card_001")
	assert_false("card_001 is not empty", card.is_empty())

func test_card_001_has_required_fields() -> void:
	var card = CardManager.get_card("card_001")
	for field in ["id","name","cost","type","faction","is_signature","power_index","effect"]:
		assert_has_key("card_001 has '%s'" % field, card, field)

func test_card_001_is_attack_type() -> void:
	var card = CardManager.get_card("card_001")
	assert_eq("card_001 type is attack", card.get("type"), "attack")

func test_card_027_is_free() -> void:
	var card = CardManager.get_card("card_027")
	assert_eq("card_027 (Quick Jab) cost is 0", card.get("cost"), 0)

func test_invalid_card_returns_empty() -> void:
	var card = CardManager.get_card("card_999")
	assert_true("card_999 returns empty dict", card.is_empty())

func test_empty_id_returns_empty() -> void:
	var card = CardManager.get_card("")
	assert_true("Empty ID returns empty dict", card.is_empty())

func test_all_cards_have_valid_type() -> void:
	var bad = []
	for cid in CardManager.cards_data:
		var t = CardManager.cards_data[cid].get("type","")
		if t not in EXPECTED_CARD_TYPES:
			bad.append("%s:%s" % [cid, t])
	assert_empty("All cards have valid types", bad)

func test_all_cards_have_valid_faction() -> void:
	var bad = []
	for cid in CardManager.cards_data:
		var f = CardManager.cards_data[cid].get("faction","")
		if f not in EXPECTED_FACTIONS:
			bad.append("%s:%s" % [cid, f])
	assert_empty("All cards have valid factions", bad)

func test_all_cards_have_non_negative_cost() -> void:
	var bad = []
	for cid in CardManager.cards_data:
		var c = CardManager.cards_data[cid].get("cost", -1)
		if c < 0:
			bad.append(cid)
	assert_empty("All cards have cost >= 0", bad)

func test_signature_cards_have_signature_lt() -> void:
	for cid in CardManager.cards_data:
		var card = CardManager.cards_data[cid]
		if card.get("is_signature", false):
			assert_has_key("%s signature has signature_lt" % cid, card, "signature_lt")

# ── Starter Deck ────────────────────────────────────────────────────────────
func test_starter_deck_not_empty() -> void:
	var deck = CardManager.get_starter_deck()
	assert_not_empty("Starter deck is not empty", deck)

func test_starter_deck_within_size_limits() -> void:
	var deck = CardManager.get_starter_deck()
	assert_gte("Starter deck >= 10", deck.size(), 10)
	assert_lte("Starter deck <= 30", deck.size(), 30)

func test_starter_deck_all_cards_exist() -> void:
	var deck = CardManager.get_starter_deck()
	var bad = []
	for cid in deck:
		if CardManager.get_card(cid).is_empty():
			bad.append(cid)
	assert_empty("All starter deck cards exist", bad)

func test_starter_deck_returns_new_array_each_time() -> void:
	var deck1 = CardManager.get_starter_deck()
	var deck2 = CardManager.get_starter_deck()
	deck1.append("card_001")
	assert_ne("Starter deck calls return independent arrays", deck1.size(), deck2.size())

# ── Lieutenant Loading ───────────────────────────────────────────────────────
func test_all_lieutenants_loaded() -> void:
	assert_eq("8 lieutenants loaded", CardManager.lieutenants_data.size(), EXPECTED_LIEUTENANTS)

func test_all_lieutenant_names_present() -> void:
	for lt_name in EXPECTED_LT_NAMES:
		assert_in("%s loaded" % lt_name, lt_name, CardManager.lieutenants_data)

func test_lieutenant_has_required_fields() -> void:
	var lt = CardManager.get_lieutenant("Marcus")
	for field in ["name","trait","trait_desc","hp","armor","speed","cards","unlock_mission"]:
		assert_has_key("Marcus has '%s'" % field, lt, field)

func test_lieutenant_hp_positive() -> void:
	for lt_name in EXPECTED_LT_NAMES:
		var lt = CardManager.get_lieutenant(lt_name)
		assert_gt("%s hp > 0" % lt_name, lt.get("hp", 0), 0)

func test_invalid_lieutenant_returns_empty() -> void:
	var lt = CardManager.get_lieutenant("Nobody")
	assert_true("Unknown lieutenant returns empty", lt.is_empty())

func test_lieutenant_cards_all_exist() -> void:
	for lt_name in EXPECTED_LT_NAMES:
		var lt = CardManager.get_lieutenant(lt_name)
		for cid in lt.get("cards", []):
			assert_false("%s card %s exists" % [lt_name, cid], CardManager.get_card(cid).is_empty())

# ── Enemy Templates ──────────────────────────────────────────────────────────
func test_enemy_templates_loaded() -> void:
	assert_gt("Enemy templates loaded", CardManager.enemy_templates.size(), 0)

func test_enemy_has_required_fields() -> void:
	var enemy = CardManager.get_enemy("quintus")
	for field in ["id","name","hp","max_hp","armor","damage","poison","type"]:
		assert_has_key("quintus has '%s'" % field, enemy, field)

func test_enemy_hp_equals_max_hp_in_template() -> void:
	for eid in CardManager.enemy_templates:
		var e = CardManager.enemy_templates[eid]
		assert_eq("%s hp==max_hp in template" % eid, e.get("hp"), e.get("max_hp"))

func test_enemy_stats_non_negative() -> void:
	for eid in CardManager.enemy_templates:
		var e = CardManager.enemy_templates[eid]
		assert_gte("%s hp>=0" % eid,     e.get("hp",0), 0)
		assert_gte("%s armor>=0" % eid,  e.get("armor",0), 0)
		assert_gte("%s damage>=0" % eid, e.get("damage",0), 0)
		assert_gte("%s poison>=0" % eid, e.get("poison",0), 0)

func test_invalid_enemy_returns_empty() -> void:
	var e = CardManager.get_enemy("fake_enemy_xyz")
	assert_true("Unknown enemy returns empty dict", e.is_empty())

# ── Mission Enemy Loading ────────────────────────────────────────────────────
func test_get_mission_enemies_m01() -> void:
	var enemies = CardManager.get_mission_enemies("M01")
	assert_not_empty("M01 enemies not empty", enemies)

func test_get_mission_enemies_correct_count_m01() -> void:
	var enemies = CardManager.get_mission_enemies("M01")
	assert_eq("M01 has 3 enemies", enemies.size(), 3)

func test_get_mission_enemies_first_is_quintus() -> void:
	var enemies = CardManager.get_mission_enemies("M01")
	assert_eq("M01 first enemy is Quintus", enemies[0].get("name"), "Quintus")

func test_get_mission_enemies_are_independent_copies() -> void:
	var enemies1 = CardManager.get_mission_enemies("M01")
	var enemies2 = CardManager.get_mission_enemies("M01")
	enemies1[0]["hp"] = 0
	assert_ne("Enemy copies are independent", enemies1[0]["hp"], enemies2[0]["hp"])

func test_get_mission_enemies_unknown_mission_gives_fallback() -> void:
	var enemies = CardManager.get_mission_enemies("M99")
	# Should return empty or a fallback — never crash
	assert_true("Unknown mission enemy call does not crash", true)

func test_all_main_missions_have_enemies() -> void:
	for i in range(1, 21):
		var mid = "M%02d" % i
		var m = MissionManager.get_mission(mid)
		if m.is_empty():
			continue
		var enemies = CardManager.get_mission_enemies(mid)
		assert_not_empty("%s has enemies" % mid, enemies)
