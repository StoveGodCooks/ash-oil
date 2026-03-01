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
	nav.add_child(_btn("View LT Cards",Color(0.3,0.15,0.3), func(): _view_lieutenant_cards()))
	nav.add_child(_btn("View Kara Card",Color(0.4,0.2,0.0), func(): _view_kara_card()))

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
	res_row.add_child(_btn("Zero HEAT",  Color(0.1,0.1,0.25), func(): GameState.change_meter("HEAT", -GameState.heat)))
	res_row.add_child(_btn("Clear DEBT", Color(0.1,0.25,0.1), func(): GameState.change_meter("DEBT", -GameState.debt)))
	res_row.add_child(_btn("Reload Cards", Color(0.2,0.15,0.3), func(): CardManager.reload_cards()))

	vbox.add_child(_sep())

	# ── Unit Tests ──
	_section(vbox, "UNIT TESTS")
	var test_row = HBoxContainer.new()
	test_row.add_theme_constant_override("separation", 8)
	vbox.add_child(test_row)
	test_row.add_child(_btn("RUN ALL TESTS", Color(0.05, 0.3, 0.05), func(): _run_tests()))

	vbox.add_child(_sep())

	# ── Recruit Lieutenants ──
	_section(vbox, "RECRUIT LIEUTENANTS")
	var lt_row = HBoxContainer.new()
	lt_row.add_theme_constant_override("separation", 8)
	lt_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_child(lt_row)
	lt_row.add_child(_btn("Recruit ALL LTs", Color(0.3, 0.15, 0.0), func(): _recruit_all_lts()))
	for lt_id in CardManager.lieutenants_data.keys():
		lt_row.add_child(_btn(lt_id, Color(0.22, 0.12, 0.0),
			func(_id = lt_id): GameState.recruit_lieutenant(_id)))

	vbox.add_child(_sep())

	# ── Unlock All Missions ──
	_section(vbox, "UNLOCK & COMPLETE MISSIONS")
	var unlock_row = HBoxContainer.new()
	unlock_row.add_theme_constant_override("separation", 8)
	vbox.add_child(unlock_row)
	unlock_row.add_child(_btn("Unlock M01-M10",  Color(0.2,0.2,0.35), func(): _unlock_range("M", 1, 10)))
	unlock_row.add_child(_btn("Unlock M11-M20",  Color(0.2,0.2,0.35), func(): _unlock_range("M", 11, 20)))
	unlock_row.add_child(_btn("Unlock All Sides", Color(0.15,0.25,0.2), func(): _unlock_sides()))
	unlock_row.add_child(_btn("Complete M01",     Color(0.15,0.3,0.15), func(): MissionManager.complete_mission("M01")))
	unlock_row.add_child(_btn("Complete M01-M05", Color(0.1,0.3,0.1),   func(): _complete_range(1, 5)))
	unlock_row.add_child(_btn("Complete ALL",     Color(0.05,0.35,0.05), func(): _complete_all_missions()))

	vbox.add_child(_sep())

	# ── Grant Gear ──
	_section(vbox, "GRANT GEAR")
	var gear_row = HBoxContainer.new()
	gear_row.add_theme_constant_override("separation", 8)
	vbox.add_child(gear_row)
	gear_row.add_child(_btn("Grant Common Set", Color(0.2, 0.2, 0.2),   func(): _grant_gear_tier("common")))
	gear_row.add_child(_btn("Grant Rare Set",   Color(0.1, 0.2, 0.4),   func(): _grant_gear_tier("rare")))
	gear_row.add_child(_btn("Grant Epic Set",   Color(0.3, 0.1, 0.4),   func(): _grant_gear_tier("epic")))
	gear_row.add_child(_btn("Grant ALL Gear",   Color(0.05, 0.3, 0.05), func(): _grant_all_gear()))

	vbox.add_child(_sep())

	# ── Card Editor ──
	_section(vbox, "CARD EDITOR")
	var card_editor_btn = _btn("🃏 OPEN CARD EDITOR", Color(0.25, 0.15, 0.35), func(): _open_card_editor())
	card_editor_btn.custom_minimum_size = Vector2(0, 40)
	vbox.add_child(card_editor_btn)

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

func _run_tests() -> void:
	var runner_script = load("res://tests/runner/TestRunner.gd")
	var runner = runner_script.new()
	add_child(runner)

	var output = runner.run_all()
	runner.queue_free()

	# Show results in scrollable popup
	var dialog = Window.new()
	dialog.title = "Test Results — Ash & Oil"
	dialog.size   = Vector2i(700, 550)
	dialog.unresizable = false
	add_child(dialog)

	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	dialog.add_child(vbox)

	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(scroll)

	var lbl = Label.new()
	lbl.text = output
	lbl.add_theme_font_size_override("font_size", 11)
	lbl.add_theme_color_override("font_color", Color(0.85, 0.85, 0.85))
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
	scroll.add_child(lbl)

	var close_btn = Button.new()
	close_btn.text = "CLOSE"
	close_btn.pressed.connect(func(): dialog.queue_free())
	vbox.add_child(close_btn)

	dialog.popup_centered()

func _grant_gear_tier(rarity: String) -> void:
	for gear_id in CardManager.gear_data:
		var g = CardManager.get_gear(gear_id)
		if g.get("rarity", "") == rarity:
			GameState.add_gear(gear_id)

func _grant_all_gear() -> void:
	for gear_id in CardManager.gear_data:
		GameState.add_gear(gear_id)

func _recruit_all_lts() -> void:
	for lt_id in CardManager.lieutenants_data.keys():
		GameState.recruit_lieutenant(lt_id)

func _complete_range(from: int, to: int) -> void:
	for i in range(from, to + 1):
		var mid := "M%02d" % i
		GameState.unlock_mission(mid)
		MissionManager.complete_mission(mid)

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

# ═══════════════════════════════════════════════════════════════
# CARD EDITOR
# ═══════════════════════════════════════════════════════════════

var _card_editor_window: Window = null
var _selected_card_id: String = ""
var _card_form_inputs: Dictionary = {}

func _open_card_editor() -> void:
	if _card_editor_window != null:
		_card_editor_window.grab_focus()
		return

	_card_editor_window = Window.new()
	_card_editor_window.title = "🃏 Card Editor"
	_card_editor_window.size = Vector2i(1200, 700)
	_card_editor_window.unresizable = false
	add_child(_card_editor_window)

	var main_hbox = HBoxContainer.new()
	main_hbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_hbox.add_theme_constant_override("separation", 12)
	_card_editor_window.add_child(main_hbox)

	# ── LEFT: Card List ──
	var left_panel = PanelContainer.new()
	main_hbox.add_child(left_panel)
	left_panel.custom_minimum_size = Vector2(250, 0)

	var left_vbox = VBoxContainer.new()
	left_panel.add_child(left_vbox)

	var list_title = Label.new()
	list_title.text = "CARDS"
	list_title.add_theme_font_size_override("font_size", 14)
	list_title.add_theme_color_override("font_color", Color(0.4, 1.0, 0.4))
	left_vbox.add_child(list_title)

	var card_list = ItemList.new()
	card_list.custom_minimum_size = Vector2(0, 400)
	left_vbox.add_child(card_list)
	card_list.item_selected.connect(_on_card_selected.bindv([card_list]))

	# Populate list
	for card_id in CardManager.cards_data.keys():
		var card = CardManager.get_card(card_id)
		var label = "%s [%s]" % [card.get("name", "?"), card.get("rarity", "?")]
		card_list.add_item(label)

	# ── RIGHT: Editor Form ──
	var right_panel = PanelContainer.new()
	main_hbox.add_child(right_panel)
	right_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var right_vbox = VBoxContainer.new()
	right_vbox.add_theme_constant_override("separation", 8)
	right_panel.add_child(right_vbox)

	var form_title = Label.new()
	form_title.text = "EDIT CARD"
	form_title.add_theme_font_size_override("font_size", 14)
	form_title.add_theme_color_override("font_color", Color(0.4, 1.0, 0.4))
	right_vbox.add_child(form_title)

	# Scrollable form area
	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_vbox.add_child(scroll)

	var form_vbox = VBoxContainer.new()
	form_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	form_vbox.add_theme_constant_override("separation", 6)
	scroll.add_child(form_vbox)

	# Form fields
	_add_card_form_field(form_vbox, "name", "Card Name", "LineEdit")
	_add_card_form_field(form_vbox, "type", "Type", "OptionButton", ["attack", "defense", "support", "reaction"])
	_add_card_form_field(form_vbox, "faction", "Faction", "OptionButton", ["NEUTRAL", "AEGIS", "SPECTER", "ECLIPSE"])
	_add_card_form_field(form_vbox, "rarity", "Rarity", "OptionButton", ["common", "rare", "epic", "legendary"])
	_add_card_form_field(form_vbox, "cost", "Cost", "SpinBox")

	var stats_label = Label.new()
	stats_label.text = "BASE STATS"
	stats_label.add_theme_font_size_override("font_size", 11)
	stats_label.add_theme_color_override("font_color", Color(0.6, 0.8, 0.6))
	form_vbox.add_child(stats_label)

	_add_card_form_field(form_vbox, "damage", "Damage", "SpinBox")
	_add_card_form_field(form_vbox, "armor", "Armor", "SpinBox")
	_add_card_form_field(form_vbox, "heal", "Heal", "SpinBox")

	var scaling_label = Label.new()
	scaling_label.text = "SCALING"
	scaling_label.add_theme_font_size_override("font_size", 11)
	scaling_label.add_theme_color_override("font_color", Color(0.6, 0.8, 0.6))
	form_vbox.add_child(scaling_label)

	_add_card_form_field(form_vbox, "scaling_atk", "ATK Scale", "LineEdit")
	_add_card_form_field(form_vbox, "scaling_def", "DEF Scale", "LineEdit")
	_add_card_form_field(form_vbox, "scaling_spd", "SPD Scale", "LineEdit")

	_add_card_form_field(form_vbox, "description", "Description", "TextEdit")
	_add_card_form_field(form_vbox, "portraitFile", "Portrait File", "LineEdit")
	_add_card_form_field(form_vbox, "cardShell", "Card Shell", "LineEdit")

	# Abilities section
	var abilities_label = Label.new()
	abilities_label.text = "ABILITIES"
	abilities_label.add_theme_font_size_override("font_size", 11)
	abilities_label.add_theme_color_override("font_color", Color(0.6, 0.8, 0.6))
	form_vbox.add_child(abilities_label)

	var abilities_container = VBoxContainer.new()
	abilities_container.add_theme_constant_override("separation", 4)
	form_vbox.add_child(abilities_container)
	_card_form_inputs["abilities_container"] = abilities_container

	# Buttons
	var button_hbox = HBoxContainer.new()
	button_hbox.add_theme_constant_override("separation", 8)
	right_vbox.add_child(button_hbox)

	var save_btn = Button.new()
	save_btn.text = "💾 SAVE"
	save_btn.add_theme_color_override("font_color", Color.BLACK)
	save_btn.modulate = Color.GREEN
	save_btn.pressed.connect(_save_card_from_form)
	button_hbox.add_child(save_btn)

	var reload_btn = Button.new()
	reload_btn.text = "🔄 RELOAD"
	reload_btn.add_theme_color_override("font_color", Color.WHITE)
	reload_btn.pressed.connect(func(): CardManager.reload_cards())
	button_hbox.add_child(reload_btn)

	_card_editor_window.visibility_changed.connect(func():
		if not _card_editor_window.visible:
			_card_editor_window = null
	)

	_card_editor_window.popup_centered()

func _on_card_selected(index: int, _card_list: ItemList) -> void:
	var card_ids = CardManager.cards_data.keys()
	if index < 0 or index >= card_ids.size():
		return

	_selected_card_id = card_ids[index]
	var card = CardManager.get_card(_selected_card_id)

	# Populate form
	_set_field_value("name", card.get("name", ""))
	_set_field_value("type", card.get("type", "attack"))
	_set_field_value("faction", card.get("faction", "NEUTRAL"))
	_set_field_value("rarity", card.get("rarity", "common"))
	_set_field_value("cost", card.get("cost", 1))
	_set_field_value("damage", card.get("damage", 0))
	_set_field_value("armor", card.get("armor", 0))
	_set_field_value("heal", card.get("heal", 0))
	_set_field_value("scaling_atk", card.get("power_index", 0.0))
	_set_field_value("scaling_def", card.get("power_index", 0.0))
	_set_field_value("scaling_spd", card.get("power_index", 0.0))
	_set_field_value("description", card.get("effect", ""))
	_set_field_value("portraitFile", card.get("portraitFile", ""))
	_set_field_value("cardShell", card.get("cardShell", ""))

	# Populate abilities
	_populate_abilities(card)

func _add_card_form_field(parent: VBoxContainer, key: String, label: String, control_type: String, options: Array = []) -> void:
	var hbox = HBoxContainer.new()
	parent.add_child(hbox)

	var lbl = Label.new()
	lbl.text = label
	lbl.custom_minimum_size = Vector2(120, 0)
	hbox.add_child(lbl)

	var control: Control

	match control_type:
		"LineEdit":
			control = LineEdit.new()
			control.placeholder_text = label
		"SpinBox":
			control = SpinBox.new()
			control.max_value = 100
		"TextEdit":
			control = TextEdit.new()
			control.custom_minimum_size = Vector2(0, 60)
		"OptionButton":
			control = OptionButton.new()
			for opt in options:
				control.add_item(opt)

	control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(control)
	_card_form_inputs[key] = control

func _set_field_value(key: String, value) -> void:
	if key not in _card_form_inputs:
		return

	var control = _card_form_inputs[key]

	if control is LineEdit:
		control.text = str(value)
	elif control is SpinBox:
		control.value = float(value)
	elif control is TextEdit:
		control.text = str(value)
	elif control is OptionButton:
		var text = str(value)
		for i in range(control.item_count):
			if control.get_item_text(i) == text:
				control.select(i)
				break

func _populate_abilities(card: Dictionary) -> void:
	## Display abilities for current card
	var container = _card_form_inputs.get("abilities_container", null)
	if container == null:
		return

	# Clear old abilities
	for child in container.get_children():
		child.queue_free()

	var abilities: Array = card.get("abilities", [])
	if abilities.is_empty():
		var empty_label = Label.new()
		empty_label.text = "[No abilities]"
		empty_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
		container.add_child(empty_label)
	else:
		for i in range(abilities.size()):
			var ability = abilities[i]
			_add_ability_display(container, ability, i)

	# Add button
	var add_btn = Button.new()
	add_btn.text = "+ Add Ability"
	add_btn.add_theme_color_override("font_color", Color.WHITE)
	add_btn.pressed.connect(func(): _add_new_ability())
	container.add_child(add_btn)

func _add_ability_display(parent: VBoxContainer, ability: Dictionary, index: int) -> void:
	## Display a single ability with edit/delete buttons
	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 4)
	parent.add_child(hbox)

	var name_label = Label.new()
	name_label.text = "%d. %s (cost: %d)" % [index + 1, ability.get("name", "?"), ability.get("cost", 0)]
	hbox.add_child(name_label)

	var edit_btn = Button.new()
	edit_btn.text = "✏️"
	edit_btn.custom_minimum_size = Vector2(32, 0)
	edit_btn.pressed.connect(func(): _edit_ability(index))
	hbox.add_child(edit_btn)

	var delete_btn = Button.new()
	delete_btn.text = "🗑️"
	delete_btn.custom_minimum_size = Vector2(32, 0)
	delete_btn.pressed.connect(func(): _remove_ability(index))
	hbox.add_child(delete_btn)

func _add_new_ability() -> void:
	## Add blank ability to selected card
	if _selected_card_id.is_empty():
		return

	var card = CardManager.get_card(_selected_card_id)
	if "abilities" not in card:
		card["abilities"] = []

	var new_ability = {
		"name": "New Ability",
		"cost": 1,
		"effect": ""
	}
	card["abilities"].append(new_ability)
	_populate_abilities(card)

func _remove_ability(index: int) -> void:
	## Remove ability from selected card
	if _selected_card_id.is_empty():
		return

	var card = CardManager.get_card(_selected_card_id)
	if "abilities" in card and index < card["abilities"].size():
		card["abilities"].remove_at(index)
		_populate_abilities(card)

func _edit_ability(index: int) -> void:
	## Open ability editor
	print("✎ Edit ability %d (TODO: Ability editor modal)" % index)

func _save_card_from_form() -> void:
	if _selected_card_id.is_empty():
		print("✗ No card selected")
		return

	var card = CardManager.get_card(_selected_card_id)

	# Update from form
	card["name"] = _card_form_inputs["name"].text
	card["type"] = _card_form_inputs["type"].get_item_text(_card_form_inputs["type"].selected)
	card["faction"] = _card_form_inputs["faction"].get_item_text(_card_form_inputs["faction"].selected)
	card["rarity"] = _card_form_inputs["rarity"].get_item_text(_card_form_inputs["rarity"].selected)
	card["cost"] = int(_card_form_inputs["cost"].value)
	card["damage"] = int(_card_form_inputs["damage"].value)
	card["armor"] = int(_card_form_inputs["armor"].value)
	card["heal"] = int(_card_form_inputs["heal"].value)
	card["effect"] = _card_form_inputs["description"].text
	card["portraitFile"] = _card_form_inputs["portraitFile"].text
	card["cardShell"] = _card_form_inputs["cardShell"].text

	# Save
	if CardManager.save_card(_selected_card_id, card):
		print("✓ Saved card: %s" % card["name"])
	else:
		print("✗ Failed to save card")

func _complete_all_missions() -> void:
	# Complete all main missions (M01-M20)
	for i in range(1, 21):
		var mid = "M%02d" % i
		GameState.complete_mission(mid)
	# Complete all side missions
	for sid in ["S01","S02","S03","S04","S05","S06","S07","S08","S09","S10","S11","S12","S13","S14","S15"]:
		GameState.complete_mission(sid)
	print("✓ All missions completed")

func _view_lieutenant_cards() -> void:
	var window = Window.new()
	window.title = "Lieutenant Cards"
	window.size = Vector2i(900, 700)
	window.unresizable = false
	add_child(window)

	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.add_theme_constant_override("separation", 10)
	window.add_child(vbox)

	# Title
	var title = Label.new()
	title.text = "LIEUTENANT CARDS"
	title.add_theme_font_size_override("font_size", 16)
	title.add_theme_color_override("font_color", Color(0.4, 1.0, 0.4))
	vbox.add_child(title)

	# Scroll area for lieutenants
	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(scroll)

	var content = VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 12)
	scroll.add_child(content)

	# List all lieutenants and their cards
	var all_lts = CardManager.lieutenants_data.keys()
	all_lts.sort()

	for lt_name in all_lts:
		var lt_data = CardManager.get_lieutenant(lt_name)
		var lt_display_name = lt_data.get("name", lt_name)

		# Lieutenant header
		var lt_header = Label.new()
		lt_header.text = "▸ " + lt_display_name
		lt_header.add_theme_font_size_override("font_size", 14)
		lt_header.add_theme_color_override("font_color", Color(1.0, 0.8, 0.3))
		content.add_child(lt_header)

		# Cards container (horizontal)
		var cards_container = HBoxContainer.new()
		cards_container.add_theme_constant_override("separation", 12)
		content.add_child(cards_container)

		# Display card visuals
		var cards: Array = lt_data.get("cards", [])
		for card_id in cards:
			# add_child() FIRST so _ready()/_build_card() fires before set_card()
			var card_display = load("res://scenes/CardDisplay.tscn").instantiate()
			cards_container.add_child(card_display)
			card_display.set_card_size(Vector2(120, 180))
			card_display.set_card(card_id)

		var spacer = Control.new()
		spacer.custom_minimum_size = Vector2(0, 12)
		content.add_child(spacer)

	window.popup_centered()

func _view_kara_card() -> void:
	var window = Window.new()
	window.title = "Kara - The Beast Hunter"
	window.size = Vector2i(340, 560)
	window.unresizable = false
	add_child(window)

	var center_container = CenterContainer.new()
	center_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	window.add_child(center_container)

	# add_child() FIRST so _ready()/_build_card() fires before set_card()
	# 300x510 matches the WF card shell's 1200:2040 (10:17) aspect ratio exactly
	var card_display = load("res://scenes/CardDisplay.tscn").instantiate()
	center_container.add_child(card_display)
	card_display.set_card_size(Vector2(300, 510))
	card_display.set_card("card_048")

	window.popup_centered()
