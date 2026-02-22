extends Control
## Clean, functional Home Base UI with clear mission deploy flow.

const TEX_CREST := "res://assets/ui/roman/crest.png"
const TEX_BANNER := "res://assets/ui/roman/banner.png"
const TEX_SEAL := "res://assets/ui/roman/seal.png"
const MISSION_BRIEFER_SCRIPT := preload("res://scripts/ui/MissionBriefer.gd")
const METERS_PANEL_SCRIPT := preload("res://scripts/ui/MetersPanel.gd")
const CHARACTER_STATE_PANEL_SCRIPT := preload("res://scripts/ui/CharacterStatePanel.gd")
const MISSION_LOG_SCRIPT := preload("res://scripts/ui/MissionLog.gd")

var header_stats: Label
var meters_panel: HBoxContainer
var character_state_panel: PanelContainer
var squad_label: Label
var gear_label: Label
var mission_list: VBoxContainer
var mission_detail: Label
var deploy_btn: Button
var selected_mission_id: String = ""
var mission_briefer: PanelContainer
var mission_log_panel: PanelContainer
var mission_log: ScrollContainer

func _ready() -> void:
	_build_ui()
	_refresh()

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = UITheme.COLOR_BG
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var root := MarginContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("margin_left", UITheme.PAD_LG)
	root.add_theme_constant_override("margin_top", UITheme.PAD_LG)
	root.add_theme_constant_override("margin_right", UITheme.PAD_LG)
	root.add_theme_constant_override("margin_bottom", UITheme.PAD_LG)
	add_child(root)

	var page := VBoxContainer.new()
	page.add_theme_constant_override("separation", UITheme.PAD_MD)
	root.add_child(page)

	page.add_child(_build_header())
	page.add_child(_build_body())
	page.add_child(_build_footer())

	mission_briefer = MISSION_BRIEFER_SCRIPT.new()
	mission_briefer.set_anchors_preset(Control.PRESET_CENTER)
	mission_briefer.offset_left = -220
	mission_briefer.offset_right = 220
	mission_briefer.offset_top = -260
	mission_briefer.offset_bottom = 260
	mission_briefer.z_index = 200
	add_child(mission_briefer)

	mission_log_panel = _build_mission_log_panel()
	add_child(mission_log_panel)

func _build_header() -> Control:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", UITheme.make_panel_style())

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", UITheme.PAD_MD)
	panel.add_child(row)

	var left := HBoxContainer.new()
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.add_theme_constant_override("separation", UITheme.PAD_SM)
	row.add_child(left)

	var crest := _make_texture(TEX_CREST, Vector2(44, 44))
	left.add_child(crest)

	var title_col := VBoxContainer.new()
	title_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_col.add_theme_constant_override("separation", 2)
	left.add_child(title_col)

	var banner := _make_texture(TEX_BANNER, Vector2(250, 26))
	title_col.add_child(banner)

	var title := Label.new()
	title.text = "Home Base — Contracts, Squad, and Supplies"
	UITheme.style_header(title, UITheme.FONT_SUBHEADER, true)
	title_col.add_child(title)

	header_stats = Label.new()
	UITheme.style_body(header_stats, UITheme.FONT_BODY)
	header_stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	var right := VBoxContainer.new()
	right.alignment = BoxContainer.ALIGNMENT_END
	right.add_child(header_stats)

	var seal := _make_texture(TEX_SEAL, Vector2(34, 34))
	right.add_child(seal)
	row.add_child(right)
	return panel

func _build_body() -> Control:
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", UITheme.PAD_LG)

	body.add_child(_build_left())
	body.add_child(_build_middle())
	body.add_child(_build_right())
	return body

func _build_left() -> Control:
	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.size_flags_stretch_ratio = 1.0
	col.add_theme_constant_override("separation", UITheme.PAD_MD)

	var meters_panel := PanelContainer.new()
	meters_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	meters_panel.add_theme_stylebox_override("panel", UITheme.make_panel_style(true))
	col.add_child(meters_panel)

	var meters_box := VBoxContainer.new()
	meters_box.add_theme_constant_override("separation", UITheme.PAD_SM)
	meters_panel.add_child(meters_box)

	var meters_title := Label.new()
	meters_title.text = "METERS"
	UITheme.style_header(meters_title, UITheme.FONT_SUBHEADER, true)
	meters_box.add_child(meters_title)

	meters_panel = METERS_PANEL_SCRIPT.new()
	meters_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	meters_box.add_child(meters_panel)

	character_state_panel = CHARACTER_STATE_PANEL_SCRIPT.new()
	character_state_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_child(character_state_panel)

	var squad_panel := PanelContainer.new()
	squad_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	squad_panel.add_theme_stylebox_override("panel", UITheme.make_panel_style())
	col.add_child(squad_panel)

	var squad_box := VBoxContainer.new()
	squad_box.add_theme_constant_override("separation", UITheme.PAD_SM)
	squad_panel.add_child(squad_box)

	var squad_title := Label.new()
	squad_title.text = "SQUAD STATUS"
	UITheme.style_header(squad_title, UITheme.FONT_SUBHEADER, true)
	squad_box.add_child(squad_title)

	squad_label = Label.new()
	squad_label.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_WORD
	UITheme.style_body(squad_label, UITheme.FONT_BODY)
	squad_box.add_child(squad_label)
	return col

func _build_middle() -> Control:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_stretch_ratio = 1.0
	panel.add_theme_stylebox_override("panel", UITheme.make_panel_style())

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", UITheme.PAD_SM)
	panel.add_child(box)

	var title := Label.new()
	title.text = "GEAR LOADOUT"
	UITheme.style_header(title, UITheme.FONT_SUBHEADER, true)
	box.add_child(title)

	gear_label = Label.new()
	gear_label.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_WORD
	UITheme.style_body(gear_label, UITheme.FONT_BODY)
	box.add_child(gear_label)
	return panel

func _build_right() -> Control:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_stretch_ratio = 1.35
	panel.add_theme_stylebox_override("panel", UITheme.make_panel_style(true))

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", UITheme.PAD_SM)
	panel.add_child(box)

	var title := Label.new()
	title.text = "AVAILABLE MISSIONS"
	UITheme.style_header(title, UITheme.FONT_SUBHEADER, true)
	box.add_child(title)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(scroll)

	mission_list = VBoxContainer.new()
	mission_list.add_theme_constant_override("separation", UITheme.PAD_SM)
	scroll.add_child(mission_list)

	mission_detail = Label.new()
	mission_detail.custom_minimum_size = Vector2(0, 120)
	mission_detail.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_WORD
	UITheme.style_body(mission_detail, UITheme.FONT_BODY)
	box.add_child(mission_detail)

	deploy_btn = Button.new()
	UITheme.style_button(deploy_btn, "DEPLOY TO SELECTED MISSION", 56)
	deploy_btn.disabled = true
	deploy_btn.pressed.connect(_on_deploy_pressed)
	box.add_child(deploy_btn)
	return panel

func _build_footer() -> Control:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", UITheme.make_panel_style())

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", UITheme.PAD_MD)
	panel.add_child(row)

	var shop_btn := Button.new()
	UITheme.style_button(shop_btn, "SHOP", 60)
	shop_btn.pressed.connect(func() -> void: get_tree().change_scene_to_file("res://scenes/ShopUI.tscn"))
	row.add_child(shop_btn)

	var deck_btn := Button.new()
	UITheme.style_button(deck_btn, "DECK BUILDER", 60)
	deck_btn.pressed.connect(func() -> void: get_tree().change_scene_to_file("res://scenes/DeckBuilder.tscn"))
	row.add_child(deck_btn)

	var log_btn := Button.new()
	UITheme.style_button(log_btn, "MISSION LOG", 60)
	log_btn.pressed.connect(_on_log_pressed)
	row.add_child(log_btn)

	var save_btn := Button.new()
	UITheme.style_button(save_btn, "SAVE GAME", 60)
	save_btn.pressed.connect(_on_save_pressed)
	row.add_child(save_btn)

	var dev_btn := Button.new()
	UITheme.style_button(dev_btn, "DEV MENU", 60)
	dev_btn.pressed.connect(func() -> void: get_tree().change_scene_to_file("res://scenes/DevMenu.tscn"))
	row.add_child(dev_btn)

	var menu_btn := Button.new()
	UITheme.style_button(menu_btn, "MAIN MENU", 60)
	menu_btn.pressed.connect(func() -> void: get_tree().change_scene_to_file("res://scenes/Main.tscn"))
	row.add_child(menu_btn)
	return panel

func _refresh() -> void:
	header_stats.text = "Gold %d  |  Deck %d  |  Completed %d" % [
		GameState.gold, GameState.current_deck.size(), GameState.completed_missions.size()
	]

	if meters_panel != null:
		meters_panel.refresh()
	if character_state_panel != null:
		character_state_panel.refresh()
	squad_label.text = _squad_text()
	gear_label.text = _gear_text()
	_refresh_missions()

func _refresh_missions() -> void:
	for child in mission_list.get_children():
		child.queue_free()

	var available := MissionManager.get_available_missions()
	if available.is_empty():
		var none := Label.new()
		none.text = "No missions currently available."
		UITheme.style_body(none, UITheme.FONT_BODY, true)
		mission_list.add_child(none)
		selected_mission_id = ""
		mission_detail.text = ""
		deploy_btn.disabled = true
		return

	for mission_id in available:
		var mission := MissionManager.get_mission(mission_id)
		var btn := Button.new()
		btn.text = "[%s] %s" % [mission_id, mission.get("name", "Unknown Mission")]
		btn.custom_minimum_size = Vector2(0, 52)
		btn.add_theme_font_size_override("font_size", UITheme.FONT_BODY)
		btn.add_theme_stylebox_override("normal", UITheme.make_button_style(UITheme.COLOR_BUTTON))
		btn.add_theme_stylebox_override("hover", UITheme.make_button_style(UITheme.COLOR_BUTTON_HOVER))
		btn.pressed.connect(_on_mission_selected.bind(mission_id))
		mission_list.add_child(btn)

	if selected_mission_id == "":
		_on_mission_selected(str(available[0]))

func _on_mission_selected(mission_id: String) -> void:
	selected_mission_id = mission_id
	var mission := MissionManager.get_mission(mission_id)
	var desc := str(mission.get("description", ""))
	mission_detail.text = "[%s] %s\n%s" % [mission_id, mission.get("name", "Unknown"), desc]
	deploy_btn.disabled = false

func _on_deploy_pressed() -> void:
	if selected_mission_id == "":
		return
	var hook = NarrativeManager.get_mission_hook(selected_mission_id)
	if hook.is_empty() or mission_briefer == null:
		if MissionManager.start_mission(selected_mission_id):
			get_tree().change_scene_to_file("res://scenes/CombatScreen.tscn")
		return

	mission_briefer.set_ready_callback(func() -> void:
		if MissionManager.start_mission(selected_mission_id):
			get_tree().change_scene_to_file("res://scenes/CombatScreen.tscn")
	)
	mission_briefer.set_mission(selected_mission_id)

func _on_save_pressed() -> void:
	SaveManager.save_game(0)
	header_stats.text = "Saved. " + header_stats.text

func _on_log_pressed() -> void:
	if mission_log_panel == null:
		return
	mission_log_panel.visible = true
	if mission_log != null:
		mission_log.refresh()

func _on_log_close_pressed() -> void:
	if mission_log_panel != null:
		mission_log_panel.visible = false

func _squad_text() -> String:
	var lines: Array[String] = []
	for lt_name in GameState.lieutenant_data.keys():
		var lt: Dictionary = GameState.lieutenant_data[lt_name]
		if bool(lt.get("recruited", false)):
			var state := "ACTIVE" if lt_name in GameState.active_lieutenants else "BENCH"
			lines.append("%s  Lv%d  Loyalty %d  [%s]" % [lt_name, int(lt.get("level", 1)), int(lt.get("loyalty", 0)), state])
	if lines.is_empty():
		return "No recruited squad members."
	return "\n".join(lines)

func _gear_text() -> String:
	var w := str(GameState.equipped_gear.get("weapon", ""))
	var a := str(GameState.equipped_gear.get("armor", ""))
	var x := str(GameState.equipped_gear.get("accessory", ""))
	if w == "": w = "None"
	if a == "": a = "None"
	if x == "": x = "None"
	return "Weapon: %s\nArmor: %s\nAccessory: %s" % [w, a, x]

func _make_texture(path: String, tex_size: Vector2) -> TextureRect:
	var tex := TextureRect.new()
	tex.texture = load(path)
	tex.custom_minimum_size = tex_size
	tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tex.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return tex

func _build_mission_log_panel() -> PanelContainer:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", UITheme.make_panel_style(true))
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.offset_left = -320
	panel.offset_right = 320
	panel.offset_top = -260
	panel.offset_bottom = 260
	panel.z_index = 190
	panel.visible = false

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", UITheme.PAD_SM)
	panel.add_child(box)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", UITheme.PAD_SM)
	box.add_child(header)

	var title := Label.new()
	title.text = "MISSION LOG"
	UITheme.style_header(title, UITheme.FONT_SUBHEADER, true)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)

	var close_btn := Button.new()
	UITheme.style_button(close_btn, "CLOSE", 48)
	close_btn.pressed.connect(_on_log_close_pressed)
	header.add_child(close_btn)
	header.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	mission_log = MISSION_LOG_SCRIPT.new()
	mission_log.size_flags_vertical = Control.SIZE_EXPAND_FILL
	mission_log.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mission_log.custom_minimum_size = Vector2(600, 380)
	box.add_child(mission_log)

	return panel
