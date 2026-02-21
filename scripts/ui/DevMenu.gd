extends Control
## DEV MODE — Jump to any mission or scene instantly for testing

func _ready() -> void:
	_build_ui()

func _build_ui() -> void:
	var bg = ColorRect.new()
	bg.color = Color(0.05, 0.08, 0.05)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var scroll = ScrollContainer.new()
	scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(scroll)

	var vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 10)
	scroll.add_child(vbox)

	# Title
	var title = Label.new()
	title.text = "⚙ DEV MODE"
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", Color(0.4, 1.0, 0.4))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	var warn = Label.new()
	warn.text = "Not visible in final build. Use to skip directly to any scene."
	warn.add_theme_font_size_override("font_size", 11)
	warn.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	warn.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(warn)

	vbox.add_child(_sep())

	# ── Quick Nav ──
	_section(vbox, "QUICK NAV")
	var nav = HBoxContainer.new()
	nav.add_theme_constant_override("separation", 8)
	vbox.add_child(nav)
	nav.add_child(_btn("Main Menu",   Color(0.3,0.3,0.3), func(): get_tree().change_scene_to_file("res://scenes/Main.tscn")))
	nav.add_child(_btn("Hub",         Color(0.1,0.3,0.4), func(): _go_hub()))
	nav.add_child(_btn("Shop",        Color(0.1,0.3,0.1), func(): _go_shop()))
	nav.add_child(_btn("Deck Builder",Color(0.1,0.1,0.4), func(): _go_deck()))

	vbox.add_child(_sep())

	# ── Set Resources ──
	_section(vbox, "SET RESOURCES (applied on launch)")
	var res_row = HBoxContainer.new()
	res_row.add_theme_constant_override("separation", 8)
	vbox.add_child(res_row)
	res_row.add_child(_btn("Gold +500",  Color(0.3,0.25,0.0), func(): GameState.add_gold(500)))
	res_row.add_child(_btn("Gold +100",  Color(0.25,0.2,0.0), func(): GameState.add_gold(100)))
	res_row.add_child(_btn("Max RENOWN", Color(0.2,0.2,0.1),  func(): GameState.change_meter("RENOWN", 20)))
	res_row.add_child(_btn("Max PIETY",  Color(0.2,0.1,0.2),  func(): GameState.change_meter("PIETY",  10)))
	res_row.add_child(_btn("Max FAVOR",  Color(0.1,0.2,0.2),  func(): GameState.change_meter("FAVOR",  10)))
	res_row.add_child(_btn("Zero HEAT",  Color(0.1,0.1,0.25), func(): GameState.change_meter("HEAT", -GameState.HEAT)))
	res_row.add_child(_btn("Clear DEBT", Color(0.1,0.25,0.1), func(): GameState.change_meter("DEBT", -GameState.DEBT)))

	vbox.add_child(_sep())

	# ── Unlock All Missions ──
	_section(vbox, "UNLOCK MISSIONS")
	var unlock_row = HBoxContainer.new()
	unlock_row.add_theme_constant_override("separation", 8)
	vbox.add_child(unlock_row)
	unlock_row.add_child(_btn("Unlock M01-M10", Color(0.2,0.2,0.35), func(): _unlock_range("M", 1, 10)))
	unlock_row.add_child(_btn("Unlock M11-M20", Color(0.2,0.2,0.35), func(): _unlock_range("M", 11, 20)))
	unlock_row.add_child(_btn("Unlock All Sides",Color(0.15,0.25,0.2),func(): _unlock_sides()))
	unlock_row.add_child(_btn("Complete M01",   Color(0.15,0.3,0.15), func(): GameState.complete_mission("M01")))

	vbox.add_child(_sep())

	# ── Main Missions ──
	_section(vbox, "JUMP TO MAIN MISSION")
	var main_grid = GridContainer.new()
	main_grid.columns = 5
	main_grid.add_theme_constant_override("h_separation", 6)
	main_grid.add_theme_constant_override("v_separation", 6)
	vbox.add_child(main_grid)
	for i in range(1, 21):
		var mid = "M%02d" % i
		main_grid.add_child(_mission_btn(mid))

	vbox.add_child(_sep())

	# ── Side Missions ──
	_section(vbox, "JUMP TO SIDE MISSION")
	var side_grid = GridContainer.new()
	side_grid.columns = 5
	side_grid.add_theme_constant_override("h_separation", 6)
	side_grid.add_theme_constant_override("v_separation", 6)
	vbox.add_child(side_grid)
	for sid in ["S01","S02","S06","S13","S14"]:
		side_grid.add_child(_mission_btn(sid))

	vbox.add_child(_sep())

	# ── Back ──
	var back = _btn("← BACK TO MAIN MENU", Color(0.25,0.1,0.1), func(): get_tree().change_scene_to_file("res://scenes/Main.tscn"))
	back.custom_minimum_size = Vector2(0, 42)
	vbox.add_child(back)

# ── Helpers ──
func _mission_btn(mid: String) -> Button:
	var m = MissionManager.get_mission(mid)
	var label = mid
	if not m.is_empty():
		label = "%s\n%s" % [mid, m.get("name","")]
	var color = Color(0.1, 0.2, 0.35) if mid.begins_with("M") else Color(0.2, 0.15, 0.3)
	return _btn(label, color, func(): _launch_mission(mid))

func _launch_mission(mid: String) -> void:
	# Ensure we have a deck
	if GameState.current_deck.is_empty():
		GameState.current_deck = CardManager.get_starter_deck()
	GameState.current_mission_id = mid
	GameState.unlock_mission(mid)
	get_tree().change_scene_to_file("res://scenes/CombatScreen.tscn")

func _go_hub() -> void:
	if GameState.current_deck.is_empty():
		GameState.current_deck = CardManager.get_starter_deck()
	get_tree().change_scene_to_file("res://scenes/MainHub.tscn")

func _go_shop() -> void:
	if GameState.current_deck.is_empty():
		GameState.current_deck = CardManager.get_starter_deck()
	get_tree().change_scene_to_file("res://scenes/ShopUI.tscn")

func _go_deck() -> void:
	if GameState.current_deck.is_empty():
		GameState.current_deck = CardManager.get_starter_deck()
	# Add some discovered cards for testing if empty
	if GameState.discovered_cards.is_empty():
		for i in range(1, 20):
			var cid = "card_%03d" % i
			if cid not in GameState.discovered_cards:
				GameState.discovered_cards.append(cid)
	get_tree().change_scene_to_file("res://scenes/DeckBuilder.tscn")

func _unlock_range(prefix: String, from: int, to: int) -> void:
	for i in range(from, to + 1):
		GameState.unlock_mission("%s%02d" % [prefix, i])

func _unlock_sides() -> void:
	for sid in ["S01","S02","S03","S04","S05","S06","S07","S08","S09","S10","S11","S12","S13","S14","S15"]:
		GameState.unlock_mission(sid)

func _section(parent: Control, text: String) -> void:
	var lbl = Label.new()
	lbl.text = text
	lbl.add_theme_font_size_override("font_size", 13)
	lbl.add_theme_color_override("font_color", Color(0.4, 1.0, 0.4))
	parent.add_child(lbl)

func _sep() -> HSeparator:
	var s = HSeparator.new()
	s.add_theme_color_override("color", Color(0.2, 0.35, 0.2))
	return s

func _btn(text: String, color: Color, action: Callable) -> Button:
	var btn = Button.new()
	btn.text = text
	btn.add_theme_font_size_override("font_size", 12)
	btn.add_theme_color_override("font_color", Color.WHITE)
	btn.add_theme_stylebox_override("normal",  _style(color))
	btn.add_theme_stylebox_override("hover",   _style(color.lightened(0.15)))
	btn.add_theme_stylebox_override("pressed", _style(color.darkened(0.15)))
	btn.custom_minimum_size = Vector2(0, 34)
	btn.pressed.connect(action)
	return btn

func _style(color: Color) -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = color
	s.corner_radius_top_left    = 4
	s.corner_radius_top_right   = 4
	s.corner_radius_bottom_left = 4
	s.corner_radius_bottom_right= 4
	s.content_margin_left  = 10
	s.content_margin_right = 10
	s.content_margin_top   = 4
	s.content_margin_bottom= 4
	return s
