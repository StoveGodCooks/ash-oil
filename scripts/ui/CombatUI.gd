extends Control
## Full combat screen with UI built programmatically

# ============ COMBAT STATE ============
var champion_hp: int = 30
var champion_max_hp: int = 30
var champion_armor: int = 0

var lt_name: String = "Marcus"
var lt_hp: int = 25
var lt_max_hp: int = 25
var lt_armor: int = 2

var enemies: Array = []
var hand: Array = []
var deck: Array = []
var discard_pile: Array = []

var stamina: int = 3
var mana: int = 0
var turn: int = 1
var combat_over: bool = false
var player_won: bool = false

# ============ UI REFERENCES ============
var log_label: Label
var stamina_label: Label
var mana_label: Label
var turn_label: Label
var champion_label: Label
var lt_label: Label
var hand_container: HBoxContainer
var end_turn_btn: Button
var enemy_labels: Array = []

func _ready() -> void:
	_init_state()
	_build_ui()
	_start_turn()

func _init_state() -> void:
	champion_hp = 30
	champion_max_hp = 30
	champion_armor = 0
	lt_name = "Marcus"
	lt_hp = 25
	lt_max_hp = 25
	lt_armor = 2

	# Load enemies from current mission
	var mid = GameState.current_mission_id
	if mid == "":
		mid = "M01"
	enemies = CardManager.get_mission_enemies(mid)
	if enemies.is_empty():
		# Fallback so combat never crashes
		enemies = [
			{"name": "Grunt", "hp": 12, "max_hp": 12, "armor": 0, "damage": 2, "poison": 0}
		]

	deck = GameState.current_deck.duplicate()
	deck.shuffle()
	hand = []
	discard_pile = []
	stamina = 3
	mana = 0
	turn = 1
	combat_over = false

func _build_ui() -> void:
	var bg = ColorRect.new()
	bg.color = Color(0.08, 0.06, 0.05, 1)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var main_vbox = VBoxContainer.new()
	main_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_vbox.add_theme_constant_override("separation", 8)
	add_child(main_vbox)

	# Title bar
	var title_bar = HBoxContainer.new()
	title_bar.custom_minimum_size = Vector2(0, 40)
	main_vbox.add_child(title_bar)

	var mid = GameState.current_mission_id
	if mid == "":
		mid = "M01"
	var m_data = MissionManager.get_mission(mid)
	var m_name = m_data.get("name", mid).to_upper()
	var m_loc  = m_data.get("location", "Unknown")
	var mission_label = Label.new()
	mission_label.text = "  %s: %s — %s" % [mid, m_name, m_loc]
	mission_label.add_theme_font_size_override("font_size", 14)
	title_bar.add_child(mission_label)

	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_bar.add_child(spacer)

	turn_label = Label.new()
	turn_label.text = "Turn 1"
	turn_label.add_theme_font_size_override("font_size", 14)
	title_bar.add_child(turn_label)

	# Enemy zone
	var enemy_panel = PanelContainer.new()
	enemy_panel.custom_minimum_size = Vector2(0, 120)
	main_vbox.add_child(enemy_panel)

	var enemy_hbox = HBoxContainer.new()
	enemy_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	enemy_panel.add_child(enemy_hbox)

	for i in range(enemies.size()):
		var e_container = VBoxContainer.new()
		e_container.custom_minimum_size = Vector2(180, 100)
		e_container.alignment = BoxContainer.ALIGNMENT_CENTER
		enemy_hbox.add_child(e_container)

		var e_label = Label.new()
		e_label.text = _get_enemy_display(i)
		e_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		e_label.add_theme_font_size_override("font_size", 13)
		e_container.add_child(e_label)
		enemy_labels.append(e_label)

	# Player zone
	var player_panel = PanelContainer.new()
	player_panel.custom_minimum_size = Vector2(0, 80)
	main_vbox.add_child(player_panel)

	var player_hbox = HBoxContainer.new()
	player_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	player_panel.add_child(player_hbox)

	champion_label = Label.new()
	champion_label.text = _get_champion_display()
	champion_label.add_theme_font_size_override("font_size", 13)
	champion_label.custom_minimum_size = Vector2(220, 0)
	player_hbox.add_child(champion_label)

	lt_label = Label.new()
	lt_label.text = _get_lt_display()
	lt_label.add_theme_font_size_override("font_size", 13)
	lt_label.custom_minimum_size = Vector2(220, 0)
	player_hbox.add_child(lt_label)

	# Resources
	var res_hbox = HBoxContainer.new()
	res_hbox.custom_minimum_size = Vector2(0, 35)
	res_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	main_vbox.add_child(res_hbox)

	stamina_label = Label.new()
	stamina_label.text = "Stamina: 3/3"
	stamina_label.add_theme_font_size_override("font_size", 14)
	stamina_label.custom_minimum_size = Vector2(160, 0)
	res_hbox.add_child(stamina_label)

	mana_label = Label.new()
	mana_label.text = "Mana: 0"
	mana_label.add_theme_font_size_override("font_size", 14)
	mana_label.custom_minimum_size = Vector2(100, 0)
	res_hbox.add_child(mana_label)

	# Hand zone label
	var hand_title = Label.new()
	hand_title.text = "Hand:"
	hand_title.add_theme_font_size_override("font_size", 12)
	main_vbox.add_child(hand_title)

	# Hand container (scroll)
	var scroll = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(0, 100)
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	main_vbox.add_child(scroll)

	hand_container = HBoxContainer.new()
	hand_container.add_theme_constant_override("separation", 6)
	scroll.add_child(hand_container)

	# Action buttons
	var action_hbox = HBoxContainer.new()
	action_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	action_hbox.add_theme_constant_override("separation", 20)
	main_vbox.add_child(action_hbox)

	end_turn_btn = Button.new()
	end_turn_btn.text = "END TURN"
	end_turn_btn.custom_minimum_size = Vector2(160, 45)
	end_turn_btn.pressed.connect(_on_end_turn)
	action_hbox.add_child(end_turn_btn)

	var retreat_btn = Button.new()
	retreat_btn.text = "RETREAT"
	retreat_btn.custom_minimum_size = Vector2(120, 45)
	retreat_btn.pressed.connect(_on_retreat)
	action_hbox.add_child(retreat_btn)

	# Combat log
	var log_title = Label.new()
	log_title.text = "Combat Log:"
	log_title.add_theme_font_size_override("font_size", 11)
	main_vbox.add_child(log_title)

	log_label = Label.new()
	log_label.text = "Combat begins..."
	log_label.add_theme_font_size_override("font_size", 11)
	log_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	log_label.custom_minimum_size = Vector2(0, 60)
	main_vbox.add_child(log_label)

func _start_turn() -> void:
	if combat_over:
		return
	stamina = 3
	_draw_cards(3)
	_update_all_ui()
	_log("--- Turn %d --- Draw 3 cards. Stamina restored." % turn)

func _draw_cards(n: int) -> void:
	for i in range(n):
		if hand.size() >= 8:
			break
		if deck.is_empty():
			if discard_pile.is_empty():
				break
			deck = discard_pile.duplicate()
			discard_pile.clear()
			deck.shuffle()
			_log("Deck reshuffled!")
		if not deck.is_empty():
			hand.append(deck.pop_front())

func _update_hand_ui() -> void:
	for child in hand_container.get_children():
		child.queue_free()

	for i in range(hand.size()):
		var card_id = hand[i]
		var card_data = CardManager.get_card(card_id)
		if card_data.is_empty():
			continue

		var cost = card_data.get("cost", 1)
		var can_play = (cost <= stamina)

		var btn = Button.new()
		btn.custom_minimum_size = Vector2(130, 80)
		btn.text = "[%d★] %s\n%s" % [cost, card_data.get("name", "?"), _get_card_desc(card_data)]
		btn.disabled = not can_play or combat_over
		btn.pressed.connect(_on_card_pressed.bind(i))

		var faction = card_data.get("faction", "NEUTRAL")
		if faction == "AEGIS":
			btn.modulate = Color(0.8, 0.9, 1.0)
		elif faction == "SPECTER":
			btn.modulate = Color(0.9, 0.7, 1.0)
		elif faction == "ECLIPSE":
			btn.modulate = Color(1.0, 0.9, 0.7)

		hand_container.add_child(btn)

func _get_card_desc(data: Dictionary) -> String:
	var type = data.get("type", "")
	var eff  = data.get("effect", "")
	match type:
		"attack":
			var dmg = data.get("damage", 0)
			var s = "%d dmg" % dmg
			if "poison" in eff: s += "+poison"
			return s
		"defense":
			return "+%d armor" % data.get("armor", 0)
		"support":
			var heal = data.get("heal", 0)
			if heal > 0: return "heal %d HP" % heal
			return eff
		"reaction":
			var dmg = data.get("damage", 0)
			var armor = data.get("armor", 0)
			if dmg > 0: return "react %d dmg" % dmg
			return "+%d armor" % armor
		"area":
			var dmg = data.get("damage", 0)
			if "poison" in eff: return "AoE poison"
			return "AoE %d dmg" % dmg
		"evasion":
			return "dodge / evade"
		"effect":
			return eff.replace("_", " ")
		_:
			return eff if eff != "" else type

func _on_card_pressed(card_idx: int) -> void:
	if combat_over or card_idx >= hand.size():
		return

	var card_id = hand[card_idx]
	var card_data = CardManager.get_card(card_id)
	if card_data.is_empty():
		return

	var cost = card_data.get("cost", 1)
	if cost > stamina:
		_log("Not enough stamina! (need %d, have %d)" % [cost, stamina])
		return

	stamina -= cost

	var type = card_data.get("type", "attack")
	var effect = card_data.get("effect", "none")

	match type:
		"attack":
			var dmg = card_data.get("damage", 0)
			var target = _get_first_alive_enemy()
			if target >= 0:
				_deal_damage_to_enemy(target, dmg)
				if "poison" in effect:
					var stacks = _parse_effect_stacks(effect)
					enemies[target]["poison"] += stacks
					_log("%s poisoned (%d stacks)" % [enemies[target]["name"], enemies[target]["poison"]])

		"defense":
			var armor = card_data.get("armor", 0)
			champion_armor += armor
			_log("Champion gained %d armor (total: %d)" % [armor, champion_armor])

		"support":
			var heal = card_data.get("heal", 0)
			if heal > 0:
				champion_hp = min(champion_max_hp, champion_hp + heal)
				_log("Champion healed %d HP (%d/%d)" % [heal, champion_hp, champion_max_hp])
			elif effect == "resource_regen":
				stamina = min(3, stamina + 1)
				_log("Stamina restored +1 (%d/3)" % stamina)
			elif effect == "card_draw":
				_draw_card()
				_log("Drew a card from effect.")

		"reaction":
			var dmg = card_data.get("damage", 0)
			var armor = card_data.get("armor", 0)
			if dmg > 0:
				var target = _get_first_alive_enemy()
				if target >= 0:
					_deal_damage_to_enemy(target, dmg)
			if armor > 0:
				champion_armor += armor
				_log("Champion gained %d armor (total: %d)" % [armor, champion_armor])

		"area":
			var dmg = card_data.get("damage", 0)
			for i in range(enemies.size()):
				if enemies[i]["hp"] > 0:
					if "poison" in effect:
						var stacks = _parse_effect_stacks(effect)
						enemies[i]["poison"] += stacks
						_log("%s poisoned (%d stacks)" % [enemies[i]["name"], enemies[i]["poison"]])
					elif dmg > 0:
						_deal_damage_to_enemy(i, dmg)

		"evasion":
			# Dodge: negate next enemy attack this turn by granting temp armor
			champion_armor += 3
			_log("Evasion! +3 temp armor to absorb next hit.")
			if effect == "evasion_team":
				lt_armor += 2
				_log("%s also gains +2 armor." % lt_name)

		"effect":
			match effect:
				"reflect_damage":
					champion_armor += 2
					_log("Curse of Thorns active: +2 armor, reflects on hit.")
				"fear":
					# Reduce all enemy damage by 1 for this turn via a status flag
					for i in range(enemies.size()):
						if enemies[i]["hp"] > 0:
							enemies[i]["damage"] = max(0, enemies[i].get("damage", 0) - 1)
					_log("Intimidate! All enemy damage reduced by 1 this turn.")
				"morale_boost_all":
					champion_hp = min(champion_max_hp, champion_hp + 3)
					lt_hp = min(lt_max_hp, lt_hp + 3)
					_log("Morale Boost! Champion and %s each heal 3 HP." % lt_name)
				_:
					_log("Effect: %s applied." % effect)

	discard_pile.append(hand[card_idx])
	hand.remove_at(card_idx)

	_update_all_ui()
	_check_victory()

func _parse_effect_stacks(effect: String) -> int:
	var parts = effect.split("_")
	if parts.size() >= 2 and parts[-1].is_valid_int():
		return int(parts[-1])
	return 1

func _get_first_alive_enemy() -> int:
	for i in range(enemies.size()):
		if enemies[i]["hp"] > 0:
			return i
	return -1

func _deal_damage_to_enemy(idx: int, amount: int) -> void:
	if idx < 0 or idx >= enemies.size():
		return
	var enemy = enemies[idx]
	var absorbed = min(enemy.get("armor", 0), amount)
	enemy["armor"] = max(0, enemy.get("armor", 0) - absorbed)
	var actual = amount - absorbed
	enemy["hp"] = max(0, enemy["hp"] - actual)
	_log("Hit %s for %d dmg (%d armor) → %d/%d HP" % [enemy["name"], actual, absorbed, enemy["hp"], enemy["max_hp"]])

func _on_end_turn() -> void:
	if combat_over:
		return

	end_turn_btn.disabled = true

	# Process poison on enemies
	for i in range(enemies.size()):
		var enemy = enemies[i]
		if enemy["hp"] > 0 and enemy.get("poison", 0) > 0:
			var poison_dmg = enemy["poison"]
			enemy["hp"] = max(0, enemy["hp"] - poison_dmg)
			enemy["poison"] = max(0, enemy["poison"] - 1)
			_log("%s takes %d poison damage → %d HP" % [enemy["name"], poison_dmg, enemy["hp"]])

	_check_victory()
	if combat_over:
		return

	_log("--- ENEMY TURN ---")
	for i in range(enemies.size()):
		var enemy = enemies[i]
		if enemy["hp"] <= 0:
			continue
		var dmg = enemy.get("damage", 2)
		var absorbed = min(champion_armor, dmg)
		champion_armor = max(0, champion_armor - absorbed)
		var actual = dmg - absorbed
		champion_hp = max(0, champion_hp - actual)
		_log("%s attacks! %d dmg (-%d armor) → Champion: %d/%d HP" % [enemy["name"], actual, absorbed, champion_hp, champion_max_hp])

		if champion_hp <= 0:
			_on_defeat()
			return

	turn += 1
	_start_turn()
	end_turn_btn.disabled = false

func _check_victory() -> void:
	var all_dead = true
	for enemy in enemies:
		if enemy["hp"] > 0:
			all_dead = false
			break

	if all_dead:
		_on_victory()

func _on_victory() -> void:
	combat_over = true
	player_won = true
	_log("=== VICTORY! All enemies defeated! ===")
	_update_all_ui()

	MissionManager.complete_mission(GameState.current_mission_id, "victory")

	end_turn_btn.text = "CONTINUE →"
	end_turn_btn.disabled = false
	end_turn_btn.pressed.disconnect(_on_end_turn)
	end_turn_btn.pressed.connect(_on_continue_after_combat)

func _on_defeat() -> void:
	combat_over = true
	player_won = false
	_log("=== DEFEAT! Champion has fallen! ===")
	_update_all_ui()
	end_turn_btn.text = "BACK TO MENU"
	end_turn_btn.disabled = false
	end_turn_btn.pressed.disconnect(_on_end_turn)
	end_turn_btn.pressed.connect(_on_back_to_menu)

func _on_retreat() -> void:
	if combat_over:
		return
	_log("Retreating from combat...")
	MissionManager.complete_mission(GameState.current_mission_id, "retreat")
	get_tree().change_scene_to_file("res://scenes/MainHub.tscn")

func _on_continue_after_combat() -> void:
	get_tree().change_scene_to_file("res://scenes/MainHub.tscn")

func _on_back_to_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _get_enemy_display(i: int) -> String:
	var e = enemies[i]
	if e["hp"] <= 0:
		return "%s\n[DEFEATED]" % e["name"]
	var poison_str = ""
	if e.get("poison", 0) > 0:
		poison_str = "\n☠ Poison: %d" % e["poison"]
	return "%s\n❤ %d/%d  🛡%d%s" % [e["name"], e["hp"], e["max_hp"], e.get("armor", 0), poison_str]

func _get_champion_display() -> String:
	return "CHAMPION\n❤ %d/%d  🛡 %d" % [champion_hp, champion_max_hp, champion_armor]

func _get_lt_display() -> String:
	if lt_hp <= 0:
		return "%s [DOWN]" % lt_name
	return "%s\n❤ %d/%d  🛡 %d" % [lt_name, lt_hp, lt_max_hp, lt_armor]

func _update_all_ui() -> void:
	if turn_label:
		turn_label.text = "Turn %d" % turn
	if stamina_label:
		stamina_label.text = "Stamina: %d/3" % stamina
	if mana_label:
		mana_label.text = "Mana: %d" % mana

	for i in range(min(enemy_labels.size(), enemies.size())):
		enemy_labels[i].text = _get_enemy_display(i)

	if champion_label:
		champion_label.text = _get_champion_display()
	if lt_label:
		lt_label.text = _get_lt_display()

	_update_hand_ui()

var _log_lines: Array = []
func _log(msg: String) -> void:
	_log_lines.append(msg)
	if _log_lines.size() > 6:
		_log_lines.pop_front()
	if log_label:
		log_label.text = "\n".join(_log_lines)
	print("[COMBAT] " + msg)
