extends Control
## Central hub screen — mission select, shops, meters, lieutenants

# ============ UI REFS ============
var gold_label: Label
var meters_label: Label
var mission_list: VBoxContainer
var lt_label: Label
var status_label: Label

func _ready() -> void:
	_build_ui()
	_refresh()

# ============ BUILD UI ============
func _build_ui() -> void:
	# Background
	var bg = ColorRect.new()
	bg.color = Color(0.07, 0.07, 0.09)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var scroll = ScrollContainer.new()
	scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
	scroll.add_theme_constant_override("margin_left", 20)
	scroll.add_theme_constant_override("margin_right", 20)
	scroll.add_theme_constant_override("margin_top", 20)
	scroll.add_theme_constant_override("margin_bottom", 20)
	add_child(scroll)

	var main_vbox = VBoxContainer.new()
	main_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_vbox.add_theme_constant_override("separation", 12)
	scroll.add_child(main_vbox)

	# ── Title ──
	var title = Label.new()
	title.text = "ASH & OIL — HOME BASE"
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color(0.9, 0.75, 0.4))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	main_vbox.add_child(title)

	_add_separator(main_vbox)

	# ── Gold & Status ──
	gold_label = Label.new()
	gold_label.add_theme_font_size_override("font_size", 14)
	gold_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	main_vbox.add_child(gold_label)

	status_label = Label.new()
	status_label.add_theme_font_size_override("font_size", 11)
	status_label.add_theme_color_override("font_color", Color(0.65, 0.65, 0.65))
	main_vbox.add_child(status_label)

	_add_separator(main_vbox)

	# ── Meters ──
	var meters_title = Label.new()
	meters_title.text = "METERS"
	meters_title.add_theme_font_size_override("font_size", 13)
	meters_title.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	main_vbox.add_child(meters_title)

	meters_label = Label.new()
	meters_label.add_theme_font_size_override("font_size", 12)
	meters_label.add_theme_color_override("font_color", Color(0.75, 0.75, 0.75))
	main_vbox.add_child(meters_label)

	_add_separator(main_vbox)

	# ── Lieutenants ──
	var lt_title = Label.new()
	lt_title.text = "SQUAD"
	lt_title.add_theme_font_size_override("font_size", 13)
	lt_title.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	main_vbox.add_child(lt_title)

	lt_label = Label.new()
	lt_label.add_theme_font_size_override("font_size", 12)
	lt_label.add_theme_color_override("font_color", Color(0.75, 0.75, 0.75))
	main_vbox.add_child(lt_label)

	_add_separator(main_vbox)

	# ── Available Missions ──
	var missions_title = Label.new()
	missions_title.text = "AVAILABLE MISSIONS"
	missions_title.add_theme_font_size_override("font_size", 13)
	missions_title.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	main_vbox.add_child(missions_title)

	mission_list = VBoxContainer.new()
	mission_list.add_theme_constant_override("separation", 6)
	main_vbox.add_child(mission_list)

	_add_separator(main_vbox)

	# ── Action Buttons ──
	var actions_title = Label.new()
	actions_title.text = "ACTIONS"
	actions_title.add_theme_font_size_override("font_size", 13)
	actions_title.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	main_vbox.add_child(actions_title)

	var actions_hbox = HBoxContainer.new()
	actions_hbox.add_theme_constant_override("separation", 10)
	main_vbox.add_child(actions_hbox)

	var shop_btn = _make_button("SHOP", Color(0.2, 0.35, 0.2))
	shop_btn.pressed.connect(_on_shop_pressed)
	actions_hbox.add_child(shop_btn)

	var deck_btn = _make_button("DECK BUILDER", Color(0.2, 0.2, 0.4))
	deck_btn.pressed.connect(_on_deck_pressed)
	actions_hbox.add_child(deck_btn)

	var save_btn = _make_button("SAVE GAME", Color(0.3, 0.25, 0.1))
	save_btn.pressed.connect(_on_save_pressed)
	actions_hbox.add_child(save_btn)

	var menu_btn = _make_button("MAIN MENU", Color(0.25, 0.1, 0.1))
	menu_btn.pressed.connect(_on_menu_pressed)
	actions_hbox.add_child(menu_btn)

# ============ REFRESH DATA ============
func _refresh() -> void:
	# Gold
	gold_label.text = "Gold: %d  |  Deck: %d cards" % [GameState.gold, GameState.current_deck.size()]

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
	) % [
		GameState.RENOWN, GameState.HEAT, GameState.PIETY,
		GameState.FAVOR, GameState.DEBT, GameState.DREAD
	]

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

	# Missions
	for child in mission_list.get_children():
		child.queue_free()

	var available = MissionManager.get_available_missions()
	if available.is_empty():
		var none_label = Label.new()
		none_label.text = "No missions available."
		none_label.add_theme_font_size_override("font_size", 12)
		none_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
		mission_list.add_child(none_label)
	else:
		for mission_id in available:
			var m = MissionManager.get_mission(mission_id)
			if m.is_empty():
				continue
			var row = HBoxContainer.new()
			row.add_theme_constant_override("separation", 10)
			mission_list.add_child(row)

			var btn = _make_button("[%s] %s" % [mission_id, m.get("name", "Unknown")], Color(0.15, 0.25, 0.35))
			btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			btn.pressed.connect(_on_mission_pressed.bind(mission_id))
			row.add_child(btn)

			var desc = Label.new()
			desc.text = m.get("description", "")
			desc.add_theme_font_size_override("font_size", 10)
			desc.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
			desc.autowrap_mode = TextServer.AUTOWRAP_WORD
			desc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			row.add_child(desc)

# ============ HELPERS ============
func _make_button(text: String, color: Color) -> Button:
	var btn = Button.new()
	btn.text = text
	btn.add_theme_font_size_override("font_size", 13)
	btn.add_theme_color_override("font_color", Color.WHITE)
	btn.add_theme_stylebox_override("normal", _make_style(color))
	btn.add_theme_stylebox_override("hover", _make_style(color.lightened(0.15)))
	btn.add_theme_stylebox_override("pressed", _make_style(color.darkened(0.15)))
	btn.custom_minimum_size = Vector2(0, 36)
	return btn

func _make_style(color: Color) -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = color
	s.corner_radius_top_left = 4
	s.corner_radius_top_right = 4
	s.corner_radius_bottom_left = 4
	s.corner_radius_bottom_right = 4
	s.content_margin_left = 12
	s.content_margin_right = 12
	s.content_margin_top = 6
	s.content_margin_bottom = 6
	return s

func _add_separator(parent: Control) -> void:
	var sep = HSeparator.new()
	sep.add_theme_color_override("color", Color(0.25, 0.25, 0.25))
	parent.add_child(sep)

# ============ BUTTON HANDLERS ============
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
