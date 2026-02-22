extends Control
## Full combat screen with UI built programmatically

const LOG_AUTOWRAP_MODE: TextServer.AutowrapMode = TextServer.AutowrapMode.AUTOWRAP_WORD

# ── Parchment & Wax palette ──
const CLR_BG      = Color(0.08, 0.065, 0.050)
const CLR_PANEL   = Color(0.14, 0.110, 0.080)
const CLR_BORDER  = Color(0.42, 0.320, 0.160)
const CLR_ACCENT  = Color(0.86, 0.700, 0.360)
const CLR_TEXT    = Color(0.90, 0.840, 0.680)
const CLR_MUTED   = Color(0.58, 0.520, 0.400)
const CLR_BTN     = Color(0.20, 0.160, 0.115)
const CLR_DANGER  = Color(0.26, 0.095, 0.090)
const CLR_STONE   = Color(0.18, 0.155, 0.120)

const TEX_BANNER = "res://assets/ui/roman/banner.png"
const TEX_SEAL   = "res://assets/ui/roman/seal.png"

# ============ COMBAT STATE ============
var champion_hp: int = 30
var champion_max_hp: int = 30
var champion_armor: int = 0

var active_lts: Array = []  # Active lieutenants from GameState
var enemies: Array = []
var hand: Array = []
var deck: Array = []
var discard_pile: Array = []

# ============ RESOURCES (SHARED POOLS) ============
var resources: Dictionary = {
	"stamina": 5,
	"stamina_max": 5,
	"mana": 0,
	"mana_max": 10,
	"mana_regen": 2
}

# ============ TARGETING & ACTOR SYSTEM ============
var selected_target_idx: int = -1  # Currently selected enemy (-1 = none)
var current_actor: String = "champion"  # Who's acting next
var active_synergies: Dictionary = {}  # {"poison": 2, "bleed": 1, ...}

var turn: int = 1
var combat_over: bool = false
var player_won: bool = false

# ============ UI REFERENCES ============
var log_label: Label
var stamina_label: Label
var mana_label: Label
var turn_label: Label
var champion_label: Label
var lt_labels: Dictionary = {}  # {lt_name: label}
var hand_container: Control
var hovered_card_idx: int = -1
var end_turn_btn: Button
var enemy_buttons: Array = []  # Clickable enemy selection buttons
var enemy_labels: Array = []  # Display labels
var actor_selector_hbox: HBoxContainer  # For actor selection UI

# ── Card Preview Panel ──
var card_preview: PanelContainer
var preview_art_rect: ColorRect
var preview_name_label: Label
var preview_cost_label: Label
var preview_stats_label: Label
var preview_effect_label: Label

func _ready() -> void:
	_init_state()
	_build_ui()
	_start_turn()
	_fade_in(self, 0.0)

func _init_state() -> void:
	champion_hp = 30
	champion_max_hp = 30
	champion_armor = 0

	# Load active lieutenants from GameState
	active_lts = GameState.active_lieutenants.duplicate()
	if active_lts.is_empty():
		active_lts = ["Marcus"]  # Default fallback

	# M01 enemies
	enemies = [
		{"name": "Quintus",   "hp": 20, "max_hp": 20, "armor": 0, "damage": 4, "poison": 0},
		{"name": "Warrior A",  "hp": 12, "max_hp": 12, "armor": 0, "damage": 2, "poison": 0},
		{"name": "Warrior B",  "hp": 12, "max_hp": 12, "armor": 0, "damage": 2, "poison": 0},
	]

	# Initialize deck from starter deck (shared pool for all actors)
	deck = CardManager.get_starter_deck().duplicate()
	deck.shuffle()
	hand = []
	discard_pile = []

	# Initialize resource pools
	resources["stamina"] = 5
	resources["stamina_max"] = 5
	resources["mana"] = 0
	resources["mana_max"] = 10

	selected_target_idx = -1
	current_actor = "champion"
	active_synergies.clear()
	turn = 1
	combat_over = false

func _build_ui() -> void:
	var bg = ColorRect.new()
	bg.color = CLR_BG
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var stone_top = ColorRect.new()
	stone_top.color = CLR_STONE
	stone_top.set_anchors_preset(Control.PRESET_TOP_WIDE)
	stone_top.custom_minimum_size = Vector2(0, 56)
	add_child(stone_top)

	var vignette = ColorRect.new()
	vignette.color = Color(0, 0, 0, 0.20)
	vignette.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(vignette)

	var main_vbox = VBoxContainer.new()
	main_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_vbox.add_theme_constant_override("separation", 8)
	add_child(main_vbox)

	# Title bar
	var title_panel = PanelContainer.new()
	title_panel.add_theme_stylebox_override("panel", _panel_style())
	main_vbox.add_child(title_panel)

	var banner_tex = _make_texture(TEX_BANNER, Vector2(520, 48))
	banner_tex.set_anchors_preset(Control.PRESET_TOP_WIDE)
	banner_tex.position = Vector2(0, 2)
	title_panel.add_child(banner_tex)

	var title_margin = MarginContainer.new()
	title_margin.add_theme_constant_override("margin_left", 10)
	title_margin.add_theme_constant_override("margin_right", 10)
	title_margin.add_theme_constant_override("margin_top", 6)
	title_margin.add_theme_constant_override("margin_bottom", 6)
	title_panel.add_child(title_margin)

	var title_bar = HBoxContainer.new()
	title_bar.custom_minimum_size = Vector2(0, 36)
	title_margin.add_child(title_bar)

	var mid = GameState.current_mission_id
	if mid == "":
		mid = "M01"
	var mdata = MissionManager.get_mission(mid)
	var mname = mdata.get("name", mid)
	var mloc = mdata.get("location", "Unknown")

	var title_left = VBoxContainer.new()
	title_left.add_theme_constant_override("separation", 2)
	title_bar.add_child(title_left)

	var mission_label = Label.new()
	mission_label.text = "%s: %s — %s" % [_format_mission_id(mid), mname, mloc]
	mission_label.add_theme_font_size_override("font_size", 14)
	mission_label.add_theme_color_override("font_color", CLR_ACCENT)
	title_left.add_child(mission_label)

	var crest = Label.new()
	crest.text = "◈  ARENA OF THE ANCIENTS  ◈"
	crest.add_theme_font_size_override("font_size", 10)
	crest.add_theme_color_override("font_color", CLR_MUTED)
	title_left.add_child(crest)

	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_bar.add_child(spacer)

	turn_label = Label.new()
	turn_label.text = "Turn 1"
	turn_label.add_theme_font_size_override("font_size", 13)
	turn_label.add_theme_color_override("font_color", CLR_TEXT)
	title_bar.add_child(turn_label)

	# Enemy zone
	var enemy_panel = PanelContainer.new()
	enemy_panel.custom_minimum_size = Vector2(0, 140)
	enemy_panel.add_theme_stylebox_override("panel", _panel_style())
	main_vbox.add_child(enemy_panel)

	var enemy_vbox = VBoxContainer.new()
	enemy_panel.add_child(enemy_vbox)

	var target_label = Label.new()
	target_label.text = "← Click enemy to target →"
	target_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	target_label.add_theme_font_size_override("font_size", 11)
	target_label.add_theme_color_override("font_color", CLR_MUTED)
	enemy_vbox.add_child(target_label)

	var enemy_hbox = HBoxContainer.new()
	enemy_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	enemy_hbox.add_theme_constant_override("separation", 8)
	enemy_vbox.add_child(enemy_hbox)

	for i in range(enemies.size()):
		var e_btn = Button.new()
		e_btn.custom_minimum_size = Vector2(160, 90)
		e_btn.text = _get_enemy_display(i)
		e_btn.add_theme_stylebox_override("normal",  _btn_style(CLR_PANEL))
		e_btn.add_theme_stylebox_override("hover",   _btn_style(CLR_PANEL.lightened(0.10)))
		e_btn.add_theme_stylebox_override("pressed", _btn_style(CLR_PANEL.darkened(0.10)))
		e_btn.add_theme_color_override("font_color", CLR_TEXT)
		e_btn.pressed.connect(_on_enemy_selected.bind(i))
		enemy_hbox.add_child(e_btn)
		enemy_buttons.append(e_btn)
		enemy_labels.append(e_btn)  # Use button as label reference

	# Player zone
	var player_panel = PanelContainer.new()
	player_panel.custom_minimum_size = Vector2(0, 100)
	player_panel.add_theme_stylebox_override("panel", _panel_style())
	main_vbox.add_child(player_panel)

	var player_hbox = HBoxContainer.new()
	player_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	player_hbox.add_theme_constant_override("separation", 12)
	player_panel.add_child(player_hbox)

	champion_label = Label.new()
	champion_label.text = _get_champion_display()
	champion_label.add_theme_font_size_override("font_size", 12)
	champion_label.custom_minimum_size = Vector2(180, 0)
	player_hbox.add_child(champion_label)

	# Show all active lieutenants
	for lt_name in active_lts:
		var lt_label_new = Label.new()
		lt_label_new.text = _get_lt_display(lt_name)
		lt_label_new.add_theme_font_size_override("font_size", 12)
		lt_label_new.custom_minimum_size = Vector2(180, 0)
		player_hbox.add_child(lt_label_new)
		lt_labels[lt_name] = lt_label_new

	# Resources (shared pool)
	var res_hbox = HBoxContainer.new()
	res_hbox.custom_minimum_size = Vector2(0, 40)
	res_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	res_hbox.add_theme_constant_override("separation", 20)
	main_vbox.add_child(res_hbox)

	var stamina_pill = _make_pill("Stamina: 5/5", CLR_ACCENT)
	stamina_label = stamina_pill.get_meta("label")
	res_hbox.add_child(stamina_pill)

	var mana_pill = _make_pill("Mana: 0/10", CLR_TEXT)
	mana_label = mana_pill.get_meta("label")
	res_hbox.add_child(mana_pill)

	# Spacer to push hand/action/log toward the bottom
	var hand_spacer = Control.new()
	hand_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_vbox.add_child(hand_spacer)

	# Hand zone label
	var hand_title = Label.new()
	hand_title.text = "Hand:"
	hand_title.add_theme_font_size_override("font_size", 12)
	main_vbox.add_child(hand_title)

	# Hand area (custom layout for fanned cards)
	hand_container = Control.new()
	hand_container.custom_minimum_size = Vector2(0, 200)
	hand_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_vbox.add_child(hand_container)

	# Action buttons
	var action_hbox = HBoxContainer.new()
	action_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	action_hbox.add_theme_constant_override("separation", 20)
	main_vbox.add_child(action_hbox)

	end_turn_btn = Button.new()
	end_turn_btn.text = "END TURN"
	end_turn_btn.custom_minimum_size = Vector2(160, 45)
	end_turn_btn.add_theme_stylebox_override("normal",  _btn_style(CLR_BTN))
	end_turn_btn.add_theme_stylebox_override("hover",   _btn_style(CLR_BTN.lightened(0.18)))
	end_turn_btn.add_theme_stylebox_override("pressed", _btn_style(CLR_BTN.darkened(0.18)))
	end_turn_btn.add_theme_color_override("font_color", CLR_ACCENT)
	end_turn_btn.pressed.connect(_on_end_turn)
	action_hbox.add_child(end_turn_btn)

	var retreat_btn = Button.new()
	retreat_btn.text = "RETREAT"
	retreat_btn.custom_minimum_size = Vector2(120, 45)
	retreat_btn.add_theme_stylebox_override("normal",  _btn_style(CLR_DANGER))
	retreat_btn.add_theme_stylebox_override("hover",   _btn_style(CLR_DANGER.lightened(0.18)))
	retreat_btn.add_theme_stylebox_override("pressed", _btn_style(CLR_DANGER.darkened(0.18)))
	retreat_btn.add_theme_color_override("font_color", CLR_TEXT)
	retreat_btn.pressed.connect(_on_retreat)
	action_hbox.add_child(retreat_btn)

	# Combat log
	var log_title = Label.new()
	log_title.text = "Combat Log:"
	log_title.add_theme_font_size_override("font_size", 11)
	log_title.add_theme_color_override("font_color", CLR_ACCENT)
	main_vbox.add_child(log_title)

	log_label = Label.new()
	log_label.text = "Combat begins..."
	log_label.add_theme_font_size_override("font_size", 11)
	log_label.add_theme_color_override("font_color", CLR_TEXT)
	log_label.autowrap_mode = LOG_AUTOWRAP_MODE
	log_label.custom_minimum_size = Vector2(0, 60)
	main_vbox.add_child(log_label)

	_build_card_preview()

func _start_turn() -> void:
	if combat_over:
		return

	# Restore shared resources
	resources["stamina"] = resources["stamina_max"]  # Restore to 5
	resources["mana"] = min(resources["mana"] + resources["mana_regen"], resources["mana_max"])

	_draw_cards(3)
	_update_all_ui()
	_log("--- Turn %d --- Draw 3 cards. Stamina: %d | Mana: +%d → %d" % [
		turn,
		resources["stamina"],
		resources["mana_regen"],
		resources["mana"]
	])

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

func _on_enemy_selected(idx: int) -> void:
	"""Handle enemy selection for targeting"""
	if idx < 0 or idx >= enemies.size():
		return
	if enemies[idx]["hp"] <= 0:
		_log("Target is already defeated!")
		return

	selected_target_idx = idx
	_log("Selected target: %s" % enemies[idx]["name"])
	_update_all_ui()

func _update_hand_ui() -> void:
	for child in hand_container.get_children():
		child.queue_free()

	for i in range(hand.size()):
		var card_id = hand[i]
		var card_data = CardManager.get_card(card_id)
		if card_data.is_empty():
			continue

		var cost = card_data.get("cost", 1)
		var can_play = (cost <= resources["stamina"])

		# Load CardDisplay scene — add_child FIRST so @onready vars are initialized
		var card_display = load("res://scenes/CardDisplay.tscn").instantiate()
		card_display.set_card_size(Vector2(120, 180))
		card_display.pivot_offset = Vector2(60, 90)

		# Set up signals
		card_display.card_pressed.connect(func():
			if can_play and not combat_over:
				_on_card_pressed(i)
		)
		card_display.mouse_entered.connect(func(): _on_card_hover(i, card_data))
		card_display.mouse_exited.connect(func(): _on_card_unhover(i))

		# Dim if not affordable or combat over
		if not can_play or combat_over:
			card_display.modulate = Color(0.5, 0.5, 0.5, 1.0)

		hand_container.add_child(card_display)
		# set_card() AFTER add_child so @onready refs are valid
		card_display.set_card(card_id)

	_layout_hand(true)

func _get_card_desc(data: Dictionary) -> String:
	var type = data.get("type", "")
	match type:
		"attack":
			var dmg = data.get("damage", 0)
			var eff = data.get("effect", "none")
			var s = "⚔ %d dmg" % dmg
			if "poison" in eff:
				s += " + poison"
			return s
		"defense":
			return "🛡 +%d armor" % data.get("armor", 0)
		"support":
			var heal = data.get("heal", 0)
			if heal > 0:
				return "💚 heal %d HP" % heal
			return "✨ " + data.get("effect", "")
		_:
			return data.get("effect", type)

func _on_card_pressed(card_idx: int) -> void:
	if combat_over or card_idx >= hand.size():
		return

	var card_id = hand[card_idx]
	var card_data = CardManager.get_card(card_id)
	if card_data.is_empty():
		return

	var cost = card_data.get("cost", 1)
	if cost > resources["stamina"]:
		_log("Not enough stamina! (need %d, have %d)" % [cost, resources["stamina"]])
		return

	# Consume stamina from shared pool
	resources["stamina"] -= cost

	var type = card_data.get("type", "attack")
	var effect = card_data.get("effect", "none")
	var target_idx = selected_target_idx

	match type:
		"attack":
			var dmg = card_data.get("damage", 0)
			# Use selected target, or default to first alive
			if target_idx < 0:
				target_idx = _get_first_alive_enemy()
			if target_idx >= 0:
				_deal_damage_to_enemy(target_idx, dmg, current_actor)
				# Apply synergy multiplier
				if "synergy_type" in card_data:
					_apply_synergy(card_data)
				if "poison" in effect:
					var stacks = _parse_effect_stacks(effect)
					enemies[target_idx]["poison"] += stacks
					_log("%s poisoned (%d stacks)" % [enemies[target_idx]["name"], enemies[target_idx]["poison"]])

		"defense":
			var armor = card_data.get("armor", 0)
			champion_armor += armor
			_log("Champion gained %d armor (total: %d)" % [armor, champion_armor])

		"support":
			var heal = card_data.get("heal", 0)
			if heal > 0:
				champion_hp = min(champion_max_hp, champion_hp + heal)
				_log("Champion healed %d HP (%d/%d)" % [heal, champion_hp, champion_max_hp])

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

func _deal_damage_to_enemy(idx: int, amount: int, _actor: String = "champion") -> void:
	if idx < 0 or idx >= enemies.size():
		return
	var enemy = enemies[idx]

	# Apply synergy multiplier
	var synergy_mult = _get_synergy_multiplier(enemy)
	var final_damage = int(amount * synergy_mult)

	var absorbed = min(enemy.get("armor", 0), final_damage)
	enemy["armor"] = max(0, enemy.get("armor", 0) - absorbed)
	var actual = final_damage - absorbed
	enemy["hp"] = max(0, enemy["hp"] - actual)
	_log("Hit %s for %d dmg (%d armor) → %d/%d HP" % [enemy["name"], actual, absorbed, enemy["hp"], enemy["max_hp"]])

func _apply_synergy(card: Dictionary) -> void:
	"""Track synergy types for damage multipliers"""
	var synergy_type = card.get("synergy_type", "none")
	if synergy_type != "none":
		active_synergies[synergy_type] = active_synergies.get(synergy_type, 0) + 1

func _get_synergy_multiplier(_enemy: Dictionary) -> float:
	"""Get damage multiplier based on active synergies"""
	var mult = 1.0
	# Poison synergy: each stack adds 10% damage
	if active_synergies.get("poison", 0) > 0:
		mult += (active_synergies["poison"] * 0.1)
	return mult

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

	# Rewards/meters are applied by MissionManager from missions.json.
	MissionManager.complete_mission(GameState.current_mission_id)

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
	get_tree().change_scene_to_file("res://scenes/MainHub.tscn")

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

func _get_lt_display(lt_name: String) -> String:
	"""Get display string for a lieutenant"""
	var lt_data = CardManager.get_lieutenant(lt_name)
	var lt_hp = lt_data.get("hp", 25)
	var lt_max_hp = lt_data.get("hp", 25)
	var lt_armor = lt_data.get("armor", 2)
	if lt_hp <= 0:
		return "%s [DOWN]" % lt_name
	return "%s\n❤ %d/%d  🛡 %d" % [lt_name, lt_hp, lt_max_hp, lt_armor]

func _update_all_ui() -> void:
	if turn_label:
		turn_label.text = "Turn %d" % turn
	if stamina_label:
		stamina_label.text = "Stamina: %d/%d" % [resources["stamina"], resources["stamina_max"]]
	if mana_label:
		mana_label.text = "Mana: %d/%d" % [resources["mana"], resources["mana_max"]]

	# Update enemy buttons and labels
	for i in range(min(enemy_buttons.size(), enemies.size())):
		var btn = enemy_buttons[i]
		var e = enemies[i]

		# Show/hide button based on enemy state
		btn.visible = (e["hp"] > 0)

		# Highlight selected target
		if i == selected_target_idx and e["hp"] > 0:
			btn.modulate = Color(1.0, 1.0, 0.7)  # Gold highlight
		else:
			btn.modulate = Color(1.0, 1.0, 1.0)  # Normal

		# Update enemy label
		enemy_labels[i].text = _get_enemy_display(i)

	if champion_label:
		champion_label.text = _get_champion_display()

	# Update all lieutenant labels
	for lt_name in active_lts:
		if lt_name in lt_labels:
			lt_labels[lt_name].text = _get_lt_display(lt_name)

	_update_hand_ui()

# ──────────────────────────────────────────────
# CARD PREVIEW PANEL (hover to inspect)
# ──────────────────────────────────────────────
func _build_card_preview() -> void:
	card_preview = PanelContainer.new()
	card_preview.custom_minimum_size = Vector2(180, 250)
	card_preview.visible = false

	# Stone-and-gold card frame (Roman style)
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.11, 0.10)
	style.border_width_left   = 2
	style.border_width_right  = 2
	style.border_width_top    = 2
	style.border_width_bottom = 2
	style.border_color = CLR_BORDER
	style.corner_radius_top_left     = 10
	style.corner_radius_top_right    = 10
	style.corner_radius_bottom_left  = 10
	style.corner_radius_bottom_right = 10
	card_preview.add_theme_stylebox_override("panel", style)

	# Wax seal
	var seal_row = CenterContainer.new()
	seal_row.set_anchors_preset(Control.PRESET_TOP_WIDE)
	seal_row.custom_minimum_size = Vector2(0, 26)
	card_preview.add_child(seal_row)

	var seal = _make_texture(TEX_SEAL, Vector2(26, 26))
	seal_row.add_child(seal)

	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 6)
	margin.add_theme_constant_override("margin_right", 6)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_bottom", 6)
	card_preview.add_child(margin)

	var inner_vbox = VBoxContainer.new()
	inner_vbox.add_theme_constant_override("separation", 6)
	margin.add_child(inner_vbox)

	# ── Art placeholder ──
	var art_panel = PanelContainer.new()
	art_panel.custom_minimum_size = Vector2(168, 115)
	var art_style = StyleBoxFlat.new()
	art_style.bg_color = Color(0.16, 0.14, 0.12)
	art_style.border_width_left = 1
	art_style.border_width_right = 1
	art_style.border_width_top = 1
	art_style.border_width_bottom = 1
	art_style.border_color = CLR_BORDER
	art_style.corner_radius_top_left = 8
	art_style.corner_radius_top_right = 8
	art_style.corner_radius_bottom_left = 8
	art_style.corner_radius_bottom_right = 8
	art_panel.add_theme_stylebox_override("panel", art_style)
	inner_vbox.add_child(art_panel)

	var art_center = CenterContainer.new()
	art_center.set_anchors_preset(Control.PRESET_FULL_RECT)
	art_panel.add_child(art_center)

	preview_art_rect = ColorRect.new()
	preview_art_rect.custom_minimum_size = Vector2(160, 104)
	preview_art_rect.color = Color(0.22, 0.18, 0.12)
	art_center.add_child(preview_art_rect)

	# Art placeholder label
	var art_lbl = Label.new()
	art_lbl.text = "[ ART ]"
	art_lbl.add_theme_font_size_override("font_size", 11)
	art_lbl.add_theme_color_override("font_color", Color(0.4, 0.35, 0.25))
	art_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	art_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	art_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	preview_art_rect.add_child(art_lbl)

	# ── Text block ──
	var text_panel = PanelContainer.new()
	var text_style = StyleBoxFlat.new()
	text_style.bg_color = Color(0.10, 0.09, 0.08)
	text_style.border_width_left = 1
	text_style.border_width_right = 1
	text_style.border_width_top = 1
	text_style.border_width_bottom = 2
	text_style.border_color = CLR_BORDER
	text_style.corner_radius_top_left = 6
	text_style.corner_radius_top_right = 6
	text_style.corner_radius_bottom_left = 8
	text_style.corner_radius_bottom_right = 8
	text_panel.add_theme_stylebox_override("panel", text_style)
	inner_vbox.add_child(text_panel)

	var text_margin = MarginContainer.new()
	text_margin.add_theme_constant_override("margin_left", 8)
	text_margin.add_theme_constant_override("margin_right", 8)
	text_margin.add_theme_constant_override("margin_top", 6)
	text_margin.add_theme_constant_override("margin_bottom", 6)
	text_panel.add_child(text_margin)

	var text_vbox = VBoxContainer.new()
	text_vbox.add_theme_constant_override("separation", 2)
	text_margin.add_child(text_vbox)

	preview_name_label = Label.new()
	preview_name_label.add_theme_font_size_override("font_size", 12)
	preview_name_label.add_theme_color_override("font_color", Color(0.92, 0.86, 0.70))
	text_vbox.add_child(preview_name_label)

	preview_cost_label = Label.new()
	preview_cost_label.add_theme_font_size_override("font_size", 10)
	preview_cost_label.add_theme_color_override("font_color", Color(0.75, 0.68, 0.45))
	text_vbox.add_child(preview_cost_label)

	var divider = HSeparator.new()
	divider.add_theme_color_override("color", Color(0.45, 0.35, 0.18))
	text_vbox.add_child(divider)

	preview_stats_label = Label.new()
	preview_stats_label.add_theme_font_size_override("font_size", 11)
	preview_stats_label.add_theme_color_override("font_color", Color(0.85, 0.80, 0.62))
	text_vbox.add_child(preview_stats_label)

	preview_effect_label = Label.new()
	preview_effect_label.add_theme_font_size_override("font_size", 10)
	preview_effect_label.add_theme_color_override("font_color", Color(0.65, 0.62, 0.50))
	preview_effect_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	text_vbox.add_child(preview_effect_label)

	# Position near player hand (bottom-right) like a real card game
	card_preview.set_anchors_preset(Control.PRESET_TOP_LEFT)
	card_preview.size = card_preview.custom_minimum_size
	card_preview.position = Vector2(0, 0)
	add_child(card_preview)

func _show_card_preview(card_data: Dictionary) -> void:
	if card_preview == null or card_data.is_empty():
		return

	var faction = card_data.get("faction", "NEUTRAL")
	# Art placeholder tinted by faction
	match faction:
		"AEGIS":    preview_art_rect.color = Color(0.12, 0.18, 0.30)
		"SPECTER":  preview_art_rect.color = Color(0.18, 0.10, 0.28)
		"ECLIPSE":  preview_art_rect.color = Color(0.30, 0.20, 0.06)
		_:          preview_art_rect.color = Color(0.22, 0.18, 0.12)

	preview_name_label.text = card_data.get("name", "Unknown")
	preview_cost_label.text = "Cost: %d ★   Faction: %s" % [card_data.get("cost", 0), faction]
	preview_stats_label.text = _get_card_desc(card_data)

	var effect = card_data.get("effect", "none")
	if effect == "none" or effect == "":
		preview_effect_label.text = ""
	else:
		preview_effect_label.text = "Effect: %s" % effect

	# Reposition near bottom-right and keep on-screen
	var vp = get_viewport_rect().size
	var pad = Vector2(16, 200)
	var pos = Vector2(vp.x - card_preview.size.x - pad.x, vp.y - card_preview.size.y - pad.y)
	pos.x = max(16, pos.x)
	pos.y = max(16, pos.y)
	card_preview.position = pos

	card_preview.visible = true

func _hide_card_preview() -> void:
	if card_preview:
		card_preview.visible = false

func _on_card_hover(idx: int, card_data: Dictionary) -> void:
	hovered_card_idx = idx
	_layout_hand(true)
	_show_card_preview(card_data)

func _on_card_unhover(idx: int) -> void:
	if hovered_card_idx == idx:
		hovered_card_idx = -1
	_layout_hand(true)
	_hide_card_preview()

func _layout_hand(animated: bool) -> void:
	if hand_container == null:
		return

	var cards = hand_container.get_children()
	var count = cards.size()
	if count == 0:
		return

	var area = hand_container.size
	if area.x <= 0:
		area.x = 600
	if area.y <= 0:
		area.y = 140

	var center_x = area.x * 0.5
	var base_y = area.y - 24
	var radius = 320.0
	var max_angle = 18.0
	var spread = 8.0
	var total = min(max_angle, (count - 1) * spread)
	var step = 0.0
	if count > 1:
		step = total / float(count - 1)

	for i in range(count):
		var card = cards[i]
		var angle = -total * 0.5 + step * i
		var rad = deg_to_rad(angle)
		var x = center_x + sin(rad) * radius
		var y = base_y - (1.0 - cos(rad)) * radius

		var lift = 0.0
		var scl = Vector2(1, 1)
		if i == hovered_card_idx:
			lift = -22.0
			scl = Vector2(1.12, 1.12)
			card.z_index = 10
		else:
			card.z_index = 0

		var pos = Vector2(x, y + lift) - card.custom_minimum_size * 0.5

		if card.has_meta("tween"):
			var old = card.get_meta("tween")
			if old:
				old.kill()

		if animated:
			var t = create_tween()
			card.set_meta("tween", t)
			t.tween_property(card, "position", pos, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			t.tween_property(card, "rotation", rad, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			t.tween_property(card, "scale", scl, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		else:
			card.position = pos
			card.rotation = rad
			card.scale = scl

# ──────────────────────────────────────────────

func _panel_style() -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = CLR_PANEL
	s.border_width_left   = 1
	s.border_width_right  = 1
	s.border_width_top    = 1
	s.border_width_bottom = 2
	s.border_color = CLR_BORDER
	s.corner_radius_top_left     = 5
	s.corner_radius_top_right    = 5
	s.corner_radius_bottom_left  = 5
	s.corner_radius_bottom_right = 5
	s.shadow_color = Color(0, 0, 0, 0.35)
	s.shadow_size  = 3
	return s

func _btn_style(color: Color) -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = color
	s.border_width_left   = 1
	s.border_width_right  = 1
	s.border_width_top    = 1
	s.border_width_bottom = 2
	s.border_color = CLR_BORDER
	s.corner_radius_top_left     = 4
	s.corner_radius_top_right    = 4
	s.corner_radius_bottom_left  = 4
	s.corner_radius_bottom_right = 4
	s.content_margin_left   = 10
	s.content_margin_right  = 10
	s.content_margin_top    = 4
	s.content_margin_bottom = 4
	s.shadow_color = Color(0, 0, 0, 0.35)
	s.shadow_size  = 3
	return s

func _format_mission_id(id: String) -> String:
	if id.length() < 2:
		return id
	var prefix = id.substr(0, 1)
	var num = int(id.substr(1))
	var roman = _roman(num)
	return "%s %s" % [prefix, roman]

func _roman(n: int) -> String:
	if n <= 0:
		return "N"
	var vals = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
	var syms = ["M","CM","D","CD","C","XC","L","XL","X","IX","V","IV","I"]
	var out = ""
	var i = 0
	while n > 0 and i < vals.size():
		while n >= vals[i]:
			out += syms[i]
			n -= vals[i]
		i += 1
	return out

func _make_pill(text: String, color: Color) -> PanelContainer:
	var panel = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = Color(color.r, color.g, color.b, 0.18)
	style.border_width_left = 1
	style.border_width_right = 1
	style.border_width_top = 1
	style.border_width_bottom = 1
	style.border_color = Color(color.r, color.g, color.b, 0.55)
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 12
	style.corner_radius_bottom_right = 12
	panel.add_theme_stylebox_override("panel", style)

	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_bottom", 4)
	panel.add_child(margin)

	var label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", CLR_TEXT)
	margin.add_child(label)
	panel.set_meta("label", label)
	return panel

func _make_texture(path: String, tex_size: Vector2) -> TextureRect:
	var tex = TextureRect.new()
	tex.texture = load(path)
	tex.custom_minimum_size = tex_size
	tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tex.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return tex

func _fade_in(node: CanvasItem, delay: float) -> void:
	node.modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 1.0, 0.35).set_delay(delay)

var _log_lines: Array = []
func _log(msg: String) -> void:
	_log_lines.append(msg)
	if _log_lines.size() > 6:
		_log_lines.pop_front()
	if log_label:
		log_label.text = "\n".join(_log_lines)
	print("[COMBAT] " + msg)
