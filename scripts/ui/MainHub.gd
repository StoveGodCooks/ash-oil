extends Control
## Central hub screen — mission select, shops, meters, lieutenants

# ============ THEME — Parchment & Wax ============
const CLR_BG       = Color(0.08, 0.065, 0.050)   # Near-black warm brown
const CLR_BG_TOP   = Color(0.13, 0.100, 0.075)   # Slightly lighter top
const CLR_ACCENT   = Color(0.86, 0.700, 0.360)   # Aged gold (titles, highlights)
const CLR_TEXT     = Color(0.90, 0.840, 0.680)   # Parchment cream
const CLR_MUTED    = Color(0.58, 0.520, 0.400)   # Warm grey-brown
const CLR_CARD     = Color(0.14, 0.110, 0.080)   # Dark parchment panel
const CLR_CARD_EDGE= Color(0.42, 0.320, 0.160)   # Aged gold border
const CLR_BTN      = Color(0.20, 0.160, 0.115)   # Dark leather button
const CLR_BTN_ALT  = Color(0.14, 0.220, 0.150)   # Muted forest green
const CLR_BTN_WARN = Color(0.28, 0.200, 0.090)   # Amber warning
const CLR_BTN_DANGER= Color(0.26, 0.095, 0.090)  # Dark blood red

# ============ UI REFS ============
var gold_label: Label
var meters_label: Label
var mission_list: VBoxContainer
var lt_label: Label
var status_label: Label
var gear_slot_labels: Dictionary = {}    # {slot: label}
var gear_slot_btns: Dictionary = {}      # {slot: [prev_btn, next_btn]}

func _ready() -> void:
	_build_ui()
	_refresh()

# ============ BUILD UI ============
func _build_ui() -> void:
	# Background
	var bg = ColorRect.new()
	bg.color = CLR_BG
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var gradient = TextureRect.new()
	gradient.set_anchors_preset(Control.PRESET_FULL_RECT)
	gradient.texture = _make_gradient()
	gradient.modulate = Color(1, 1, 1, 0.8)
	add_child(gradient)

	var vignette = ColorRect.new()
	vignette.color = Color(0, 0, 0, 0.20)
	vignette.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(vignette)

	var scroll = ScrollContainer.new()
	scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(scroll)

	var margin = MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 24)
	scroll.add_child(margin)

	var main_vbox = VBoxContainer.new()
	main_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_vbox.add_theme_constant_override("separation", 16)
	margin.add_child(main_vbox)

	# ── Title Bar ──
	var title_panel = PanelContainer.new()
	title_panel.add_theme_stylebox_override("panel", _make_card_style())
	main_vbox.add_child(title_panel)

	var title_margin = MarginContainer.new()
	title_margin.add_theme_constant_override("margin_left", 12)
	title_margin.add_theme_constant_override("margin_right", 12)
	title_margin.add_theme_constant_override("margin_top", 10)
	title_margin.add_theme_constant_override("margin_bottom", 10)
	title_panel.add_child(title_margin)

	var title_bar = HBoxContainer.new()
	title_bar.add_theme_constant_override("separation", 16)
	title_margin.add_child(title_bar)

	var title_box = VBoxContainer.new()
	title_box.add_theme_constant_override("separation", 2)
	title_bar.add_child(title_box)

	var title = Label.new()
	title.text = "ASH & OIL"
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", CLR_ACCENT)
	title_box.add_child(title)

	var subtitle = Label.new()
	subtitle.text = "Home Base — Contracts, Squad, and Supplies"
	subtitle.add_theme_font_size_override("font_size", 12)
	subtitle.add_theme_color_override("font_color", CLR_MUTED)
	title_box.add_child(subtitle)

	var top_spacer = Control.new()
	top_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_bar.add_child(top_spacer)

	var gold_pill = _make_pill("Gold: 0   |   Deck: 0 cards", CLR_ACCENT)
	gold_label = gold_pill.get_meta("label")
	title_bar.add_child(gold_pill)

	status_label = Label.new()
	status_label.add_theme_font_size_override("font_size", 11)
	status_label.add_theme_color_override("font_color", CLR_MUTED)
	main_vbox.add_child(status_label)

	# ── Content Layout ──
	var content = HBoxContainer.new()
	content.add_theme_constant_override("separation", 16)
	main_vbox.add_child(content)

	var left_col = VBoxContainer.new()
	left_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_col.size_flags_stretch_ratio = 0.45
	left_col.add_theme_constant_override("separation", 12)
	content.add_child(left_col)

	var right_col = VBoxContainer.new()
	right_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_col.size_flags_stretch_ratio = 0.55
	right_col.add_theme_constant_override("separation", 12)
	content.add_child(right_col)

	# ── Meters Card ──
	var meters_card = _make_section_card(left_col, "METERS")
	meters_label = Label.new()
	meters_label.add_theme_font_size_override("font_size", 12)
	meters_label.add_theme_color_override("font_color", CLR_TEXT)
	meters_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	meters_card.add_child(meters_label)

	# ── Squad Card ──
	var squad_card = _make_section_card(left_col, "SQUAD STATUS")
	lt_label = Label.new()
	lt_label.add_theme_font_size_override("font_size", 12)
	lt_label.add_theme_color_override("font_color", CLR_TEXT)
	lt_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	squad_card.add_child(lt_label)

	# ── Gear Card ──
	var gear_card = _make_section_card(left_col, "GEAR LOADOUT")
	for slot in ["weapon", "armor", "accessory"]:
		var row = HBoxContainer.new()
		row.add_theme_constant_override("separation", 6)
		gear_card.add_child(row)

		var slot_lbl = Label.new()
		slot_lbl.text = slot.to_upper() + ":"
		slot_lbl.add_theme_font_size_override("font_size", 11)
		slot_lbl.add_theme_color_override("font_color", CLR_ACCENT)
		slot_lbl.custom_minimum_size = Vector2(72, 0)
		row.add_child(slot_lbl)

		var info_lbl = Label.new()
		info_lbl.text = "—"
		info_lbl.add_theme_font_size_override("font_size", 11)
		info_lbl.add_theme_color_override("font_color", CLR_TEXT)
		info_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(info_lbl)
		gear_slot_labels[slot] = info_lbl

		var prev_btn = _make_button("<", CLR_BTN)
		prev_btn.custom_minimum_size = Vector2(28, 0)
		prev_btn.pressed.connect(_on_gear_cycle.bind(slot, -1))
		row.add_child(prev_btn)

		var next_btn = _make_button(">", CLR_BTN)
		next_btn.custom_minimum_size = Vector2(28, 0)
		next_btn.pressed.connect(_on_gear_cycle.bind(slot, 1))
		row.add_child(next_btn)

		gear_slot_btns[slot] = [prev_btn, next_btn]

	# ── Actions Card ──
	var actions_card = _make_section_card(left_col, "ACTIONS")
	var actions_hbox = HBoxContainer.new()
	actions_hbox.add_theme_constant_override("separation", 10)
	actions_card.add_child(actions_hbox)

	var shop_btn = _make_button("SHOP", CLR_BTN_ALT)
	shop_btn.pressed.connect(_on_shop_pressed)
	actions_hbox.add_child(shop_btn)

	var deck_btn = _make_button("DECK BUILDER", CLR_BTN)
	deck_btn.pressed.connect(_on_deck_pressed)
	actions_hbox.add_child(deck_btn)

	var save_btn = _make_button("SAVE GAME", CLR_BTN_WARN)
	save_btn.pressed.connect(_on_save_pressed)
	actions_hbox.add_child(save_btn)

	var menu_btn = _make_button("MAIN MENU", CLR_BTN_DANGER)
	menu_btn.pressed.connect(_on_menu_pressed)
	actions_hbox.add_child(menu_btn)

	# ── Missions Card ──
	var missions_card = _make_section_card(right_col, "AVAILABLE MISSIONS")
	mission_list = VBoxContainer.new()
	mission_list.add_theme_constant_override("separation", 8)
	missions_card.add_child(mission_list)

# ============ REFRESH DATA ============
func _refresh() -> void:
	# Gold
	gold_label.text = "Gold: %d   |   Deck: %d cards" % [GameState.gold, GameState.current_deck.size()]

	# Location / status
	var completed = GameState.completed_missions.size()
	status_label.text = "Location: %s  |  Missions completed: %d  |  Ending path: %s" % [
		GameState.current_location,
		completed,
		MissionManager.check_ending_path()
	]

	# Meters
	meters_label.text = (
		"RENOWN %d/20   HEAT %d/15   PIETY %d/10\n" +
		"FAVOR %d/10    DEBT %d      DREAD %d/10"
	) % [GameState.RENOWN, GameState.HEAT, GameState.PIETY, GameState.FAVOR, GameState.DEBT, GameState.DREAD]

	# Lieutenants
	var lt_lines = []
	for lt_name in GameState.lieutenant_data:
		var lt = GameState.lieutenant_data[lt_name]
		if lt["recruited"]:
			var status = "active" if lt_name in GameState.active_lieutenants else "bench"
			lt_lines.append("%s [Lv%d | Loyalty %d | %s]" % [lt_name, lt["level"], lt["loyalty"], status])
	if lt_lines.is_empty():
		lt_label.text = "No lieutenants recruited yet."
	else:
		lt_label.text = "\n".join(lt_lines)

	# Gear loadout
	_refresh_gear()

	# Missions
	for child in mission_list.get_children():
		child.queue_free()

	var available = MissionManager.get_available_missions()
	if available.is_empty():
		var none_label = Label.new()
		none_label.text = "No missions available."
		none_label.add_theme_font_size_override("font_size", 12)
		none_label.add_theme_color_override("font_color", CLR_MUTED)
		mission_list.add_child(none_label)
	else:
		for mission_id in available:
			var m = MissionManager.get_mission(mission_id)
			if m.is_empty():
				continue
			var card = PanelContainer.new()
			card.add_theme_stylebox_override("panel", _make_card_style())
			mission_list.add_child(card)

			var card_margin = MarginContainer.new()
			card_margin.add_theme_constant_override("margin_left", 10)
			card_margin.add_theme_constant_override("margin_right", 10)
			card_margin.add_theme_constant_override("margin_top", 8)
			card_margin.add_theme_constant_override("margin_bottom", 8)
			card.add_child(card_margin)

			var row = HBoxContainer.new()
			row.add_theme_constant_override("separation", 10)
			card_margin.add_child(row)

			var btn = _make_button("[%s] %s" % [mission_id, m.get("name", "Unknown")], Color(0.18, 0.26, 0.32))
			btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			btn.pressed.connect(_on_mission_pressed.bind(mission_id))
			row.add_child(btn)

			var right_col = VBoxContainer.new()
			right_col.add_theme_constant_override("separation", 2)
			right_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			row.add_child(right_col)

			var desc = Label.new()
			desc.text = m.get("description", "")
			desc.add_theme_font_size_override("font_size", 10)
			desc.add_theme_color_override("font_color", CLR_MUTED)
			desc.autowrap_mode = TextServer.AUTOWRAP_WORD
			right_col.add_child(desc)

			var loc = Label.new()
			loc.text = "Location: %s" % m.get("location", "Unknown")
			loc.add_theme_font_size_override("font_size", 9)
			loc.add_theme_color_override("font_color", CLR_TEXT)
			right_col.add_child(loc)

# ============ HELPERS ============
func _make_button(text: String, color: Color) -> Button:
	var btn = Button.new()
	btn.text = text
	btn.add_theme_font_size_override("font_size", 13)
	btn.add_theme_color_override("font_color", CLR_TEXT)
	btn.add_theme_stylebox_override("normal",  _make_style(color))
	btn.add_theme_stylebox_override("hover",   _make_style(color.lightened(0.18)))
	btn.add_theme_stylebox_override("pressed", _make_style(color.darkened(0.18)))
	btn.custom_minimum_size = Vector2(0, 38)
	return btn

func _make_style(color: Color) -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = color
	s.border_width_left   = 1
	s.border_width_right  = 1
	s.border_width_top    = 1
	s.border_width_bottom = 2
	s.border_color = CLR_CARD_EDGE        # Aged gold border on all buttons
	s.corner_radius_top_left     = 4
	s.corner_radius_top_right    = 4
	s.corner_radius_bottom_left  = 4
	s.corner_radius_bottom_right = 4
	s.content_margin_left   = 12
	s.content_margin_right  = 12
	s.content_margin_top    = 6
	s.content_margin_bottom = 6
	s.shadow_color = Color(0, 0, 0, 0.35)
	s.shadow_size  = 3
	return s

func _make_section_card(parent: Control, title: String) -> VBoxContainer:
	var panel = PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _make_card_style())
	parent.add_child(panel)

	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_bottom", 12)
	panel.add_child(margin)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	margin.add_child(vbox)

	var label = Label.new()
	label.text = title
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", CLR_ACCENT)
	vbox.add_child(label)

	var sep = HSeparator.new()
	sep.add_theme_color_override("color", CLR_CARD_EDGE)
	vbox.add_child(sep)
	return vbox

func _make_card_style() -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = CLR_CARD
	s.border_width_left   = 1
	s.border_width_right  = 1
	s.border_width_top    = 1
	s.border_width_bottom = 2           # Slightly heavier base gives weight
	s.border_color = CLR_CARD_EDGE
	s.corner_radius_top_left     = 6
	s.corner_radius_top_right    = 6
	s.corner_radius_bottom_left  = 6
	s.corner_radius_bottom_right = 6
	s.shadow_color = Color(0, 0, 0, 0.4)
	s.shadow_size  = 4
	return s

func _make_pill(text: String, color: Color) -> PanelContainer:
	var panel = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = Color(color.r, color.g, color.b, 0.18)
	style.border_width_left = 1
	style.border_width_right = 1
	style.border_width_top = 1
	style.border_width_bottom = 1
	style.border_color = Color(color.r, color.g, color.b, 0.55)
	style.corner_radius_top_left = 14
	style.corner_radius_top_right = 14
	style.corner_radius_bottom_left = 14
	style.corner_radius_bottom_right = 14
	panel.add_theme_stylebox_override("panel", style)

	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_bottom", 6)
	panel.add_child(margin)

	var label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", CLR_TEXT)
	margin.add_child(label)
	panel.set_meta("label", label)
	return panel

func _make_gradient() -> Texture2D:
	var grad = Gradient.new()
	grad.colors = PackedColorArray([CLR_BG_TOP, CLR_BG])
	grad.offsets = PackedFloat32Array([0.0, 1.0])
	var tex = GradientTexture2D.new()
	tex.gradient = grad
	tex.width = 4
	tex.height = 256
	return tex

# ============ BUTTON HANDLERS ============
func _refresh_gear() -> void:
	for slot in ["weapon", "armor", "accessory"]:
		var equipped_id = GameState.get_equipped_gear(slot)
		var label = gear_slot_labels.get(slot)
		if not label:
			continue
		if equipped_id == "":
			label.text = "Empty"
			label.add_theme_color_override("font_color", CLR_MUTED)
		else:
			var g = CardManager.get_gear(equipped_id)
			var stat_parts = []
			if g.get("damage", 0) > 0: stat_parts.append("+%d Dmg" % g["damage"])
			if g.get("armor", 0) > 0:  stat_parts.append("+%d Arm" % g["armor"])
			if g.get("hp", 0) > 0:     stat_parts.append("+%d HP" % g["hp"])
			if g.get("hp", 0) < 0:     stat_parts.append("%d HP" % g["hp"])
			if g.get("speed", 0) > 0:  stat_parts.append("+%d Spd" % g["speed"])
			var rarity = g.get("rarity", "")
			var stats_str = " (%s)" % ", ".join(stat_parts) if stat_parts.size() > 0 else ""
			label.text = "%s%s" % [g.get("name", equipped_id), stats_str]
			match rarity:
				"epic":   label.add_theme_color_override("font_color", Color(0.8, 0.5, 1.0))
				"rare":   label.add_theme_color_override("font_color", Color(0.4, 0.8, 1.0))
				_:        label.add_theme_color_override("font_color", CLR_TEXT)

		# Enable cycle buttons only if there are items for this slot in inventory
		var slot_items = _get_slot_inventory(slot)
		var btns = gear_slot_btns.get(slot, [])
		for btn in btns:
			btn.disabled = slot_items.size() == 0

func _get_slot_inventory(slot: String) -> Array:
	var result = []
	for gear_id in GameState.gear_inventory:
		var g = CardManager.get_gear(gear_id)
		if g.get("slot", "") == slot:
			result.append(gear_id)
	return result

func _on_gear_cycle(slot: String, direction: int) -> void:
	var slot_items = _get_slot_inventory(slot)
	if slot_items.is_empty():
		return
	var current = GameState.get_equipped_gear(slot)
	var idx = slot_items.find(current)
	# direction: -1 = prev (or unequip), +1 = next
	if direction == 1:
		if idx == slot_items.size() - 1:
			GameState.equip_gear(slot, "")   # cycle past last = unequip
		else:
			GameState.equip_gear(slot, slot_items[idx + 1])
	else:
		if idx <= 0:
			GameState.equip_gear(slot, slot_items[slot_items.size() - 1])
		else:
			GameState.equip_gear(slot, slot_items[idx - 1])
	_refresh_gear()

func _on_mission_pressed(mission_id: String) -> void:
	if MissionManager.start_mission(mission_id):
		get_tree().change_scene_to_file("res://scenes/CombatScreen.tscn")

func _on_shop_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ShopUI.tscn")

func _on_deck_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/DeckBuilder.tscn")

func _on_save_pressed() -> void:
	SaveManager.save_game(0)
	status_label.text = "Game saved! | " + status_label.text

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
