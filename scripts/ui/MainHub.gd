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
var relationship_label: Label
var mission_list: VBoxContainer
var mission_detail: Label
var deploy_btn: Button
var selected_mission_id: String = ""
var mission_briefer: PanelContainer
var mission_log_panel: PanelContainer
var mission_log: ScrollContainer
var accessibility_panel: PanelContainer

func _ready() -> void:
	_build_ui()
	_refresh()

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = UITheme.background_color()
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
	accessibility_panel = _build_accessibility_panel()
	add_child(accessibility_panel)

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

	var meters_container := PanelContainer.new()
	meters_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	meters_container.add_theme_stylebox_override("panel", UITheme.make_panel_style(true))
	col.add_child(meters_container)

	var meters_box := VBoxContainer.new()
	meters_box.add_theme_constant_override("separation", UITheme.PAD_SM)
	meters_container.add_child(meters_box)

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

	var rel_panel := PanelContainer.new()
	rel_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	rel_panel.add_theme_stylebox_override("panel", UITheme.make_panel_style())
	col.add_child(rel_panel)
	var rel_box := VBoxContainer.new()
	rel_box.add_theme_constant_override("separation", UITheme.PAD_SM)
	rel_panel.add_child(rel_box)
	var rel_title := Label.new()
	rel_title.text = "RELATIONSHIPS"
	UITheme.style_header(rel_title, UITheme.FONT_SUBHEADER, true)
	rel_box.add_child(rel_title)
	relationship_label = Label.new()
	relationship_label.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_WORD
	UITheme.style_body(relationship_label, UITheme.FONT_BODY)
	rel_box.add_child(relationship_label)
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

	# One cycle row per slot
	for slot in ["weapon", "armor", "accessory"]:
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 4)
		box.add_child(row)

		var slot_lbl := Label.new()
		slot_lbl.text = slot.capitalize() + ":"
		slot_lbl.custom_minimum_size = Vector2(72, 0)
		UITheme.style_body(slot_lbl, UITheme.FONT_BODY)
		row.add_child(slot_lbl)

		var prev_btn := Button.new()
		prev_btn.text = "◀"
		prev_btn.custom_minimum_size = Vector2(28, 28)
		prev_btn.add_theme_font_size_override("font_size", 12)
		row.add_child(prev_btn)

		var name_lbl := Label.new()
		name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_lbl.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_OFF
		UITheme.style_body(name_lbl, UITheme.FONT_BODY)
		name_lbl.name = "gear_name_%s" % slot
		row.add_child(name_lbl)

		var next_btn := Button.new()
		next_btn.text = "▶"
		next_btn.custom_minimum_size = Vector2(28, 28)
		next_btn.add_theme_font_size_override("font_size", 12)
		row.add_child(next_btn)

		prev_btn.pressed.connect(func(_s = slot): _cycle_gear(_s, -1))
		next_btn.pressed.connect(func(_s = slot): _cycle_gear(_s, +1))

	gear_label = Label.new()
	gear_label.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_WORD
	gear_label.visible = false   # kept for compat, hidden in favour of row labels
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

	var a11y_btn := Button.new()
	UITheme.style_button(a11y_btn, "ACCESSIBILITY", 60)
	a11y_btn.pressed.connect(_on_accessibility_pressed)
	row.add_child(a11y_btn)

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
	_refresh_gear_labels()
	relationship_label.text = _relationship_text()
	_refresh_missions()

func _refresh_missions() -> void:
	for child in mission_list.get_children():
		child.queue_free()

	var visible_missions: Array = []
	for mission_id in GameState.unlocked_missions:
		if mission_id in GameState.completed_missions:
			continue
		visible_missions.append(mission_id)

	if visible_missions.is_empty():
		var none := Label.new()
		none.text = "No missions currently available."
		UITheme.style_body(none, UITheme.FONT_BODY, true)
		mission_list.add_child(none)
		selected_mission_id = ""
		mission_detail.text = ""
		deploy_btn.disabled = true
		return

	var has_available := false
	for mission_id in visible_missions:
		var mission := MissionManager.get_mission(mission_id)
		var lock_reasons := MissionManager.get_mission_lock_reasons(str(mission_id))
		var unlocked_now := lock_reasons.is_empty()
		if unlocked_now:
			has_available = true
		var btn := Button.new()
		var suffix := ""
		if not unlocked_now and not lock_reasons.is_empty():
			suffix = " (Locked)"
		btn.text = "[%s] %s%s" % [mission_id, mission.get("name", "Unknown Mission"), suffix]
		btn.custom_minimum_size = Vector2(0, 52)
		btn.add_theme_font_size_override("font_size", UITheme.FONT_BODY)
		btn.add_theme_stylebox_override("normal", UITheme.make_button_style(UITheme.COLOR_BUTTON))
		btn.add_theme_stylebox_override("hover", UITheme.make_button_style(UITheme.COLOR_BUTTON_HOVER))
		btn.disabled = not unlocked_now
		btn.pressed.connect(_on_mission_selected.bind(mission_id))
		mission_list.add_child(btn)

	if not has_available:
		selected_mission_id = ""
		mission_detail.text = "All currently unlocked missions are relationship/faction locked."
		deploy_btn.disabled = true
		return

	if selected_mission_id == "":
		for mission_id in visible_missions:
			if MissionManager.is_mission_available(str(mission_id)):
				_on_mission_selected(str(mission_id))
				break

func _on_mission_selected(mission_id: String) -> void:
	selected_mission_id = mission_id
	var mission := MissionManager.get_mission(mission_id)
	var desc := str(mission.get("description", ""))
	var lock_reasons := MissionManager.get_mission_lock_reasons(mission_id)
	var lock_text := ""
	if not lock_reasons.is_empty():
		lock_text = "\nLOCKED: %s" % ", ".join(lock_reasons)
	mission_detail.text = "[%s] %s\n%s%s" % [mission_id, mission.get("name", "Unknown"), desc, lock_text]
	deploy_btn.disabled = not lock_reasons.is_empty()

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

func _on_accessibility_pressed() -> void:
	if accessibility_panel != null:
		accessibility_panel.visible = true

func _on_accessibility_close_pressed() -> void:
	if accessibility_panel != null:
		accessibility_panel.visible = false

func _on_accessibility_save_pressed(
		high_contrast: CheckBox,
		colorblind: CheckBox,
		large_cursor: CheckBox,
		text_scale: HSlider,
		anim_scale: HSlider
	) -> void:
	GameState.set_accessibility_setting("high_contrast", high_contrast.button_pressed)
	GameState.set_accessibility_setting("colorblind_mode", colorblind.button_pressed)
	GameState.set_accessibility_setting("large_cursor", large_cursor.button_pressed)
	GameState.set_accessibility_setting("text_scale", text_scale.value)
	GameState.set_accessibility_setting("animation_speed", anim_scale.value)
	SaveManager.auto_save()
	_on_accessibility_close_pressed()
	get_tree().change_scene_to_file("res://scenes/MainHub.tscn")

func _squad_text() -> String:
	var lines: Array[String] = []
	for lt_id in GameState.lieutenant_data.keys():
		var lt: Dictionary = GameState.lieutenant_data[lt_id]
		if bool(lt.get("recruited", false)):
			var state := "ACTIVE" if lt_id in GameState.active_lieutenants else "BENCH"
			var full_name: String = CardManager.get_lieutenant(lt_id).get("name", lt_id)
			lines.append("%s  Lv%d  Loyalty %d  [%s]" % [full_name, int(lt.get("level", 1)), int(lt.get("loyalty", 0)), state])
	if lines.is_empty():
		return "No recruited squad members."
	return "\n".join(lines)

func _gear_name(slot: String) -> String:
	var gear_id := str(GameState.equipped_gear.get(slot, ""))
	if gear_id == "":
		return "— None —"
	var gear := CardManager.get_gear(gear_id)
	return gear.get("name", gear_id) if not gear.is_empty() else gear_id

func _gear_text() -> String:
	return "Weapon: %s\nArmor: %s\nAccessory: %s" % [
		_gear_name("weapon"), _gear_name("armor"), _gear_name("accessory")]

func _cycle_gear(slot: String, direction: int) -> void:
	# Collect all owned gear for this slot
	var owned: Array = []
	for gear_id in GameState.gear_inventory:
		var g := CardManager.get_gear(gear_id)
		if g.get("slot", "") == slot:
			if gear_id not in owned:
				owned.append(gear_id)
	if owned.is_empty():
		return
	var current := str(GameState.equipped_gear.get(slot, ""))
	var idx := owned.find(current)
	# -1 means nothing equipped — cycle to first or last
	var next_idx := wrapi(idx + direction, -1, owned.size())
	if next_idx == -1:
		GameState.equipped_gear[slot] = ""
	else:
		GameState.equip_gear(slot, owned[next_idx])
	_refresh_gear_labels()

func _refresh_gear_labels() -> void:
	for slot in ["weapon", "armor", "accessory"]:
		var lbl := find_child("gear_name_%s" % slot, true, false) as Label
		if lbl:
			lbl.text = _gear_name(slot)

func _relationship_text() -> String:
	var cult := GameState.get_faction_alignment("Cult")
	var state := GameState.get_faction_alignment("State")
	var syndicate := GameState.get_faction_alignment("Syndicate")
	var lines: Array[String] = [
		"Factions",
		"Cult %d | State %d | Syndicate %d" % [cult, state, syndicate],
	]
	var key_npcs := ["Lanista", "Varro", "Rhesus", "Iona", "Moth"]
	var npc_lines: Array[String] = []
	for npc_id in key_npcs:
		var npc_state := GameState.get_npc_state(npc_id)
		if npc_state.is_empty():
			continue
		npc_lines.append("%s: %s (%d)" % [
			npc_id,
			str(npc_state.get("level", "neutral")).capitalize(),
			int(npc_state.get("score", 0))
		])
	if npc_lines.is_empty():
		lines.append("No NPC relationship data.")
	else:
		lines.append("NPCs")
		lines.append(", ".join(npc_lines))
	return "\n".join(lines)

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

func _build_accessibility_panel() -> PanelContainer:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", UITheme.make_panel_style(true))
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.offset_left = -300
	panel.offset_right = 300
	panel.offset_top = -250
	panel.offset_bottom = 250
	panel.z_index = 191
	panel.visible = false

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", UITheme.PAD_SM)
	panel.add_child(box)

	var title := Label.new()
	title.text = "ACCESSIBILITY"
	UITheme.style_header(title, UITheme.FONT_SUBHEADER, true)
	box.add_child(title)

	var high_contrast := CheckBox.new()
	high_contrast.text = "High Contrast Mode"
	high_contrast.button_pressed = bool(GameState.get_accessibility_setting("high_contrast", false))
	box.add_child(high_contrast)

	var colorblind := CheckBox.new()
	colorblind.text = "Colorblind Mode (Blue/Gold)"
	colorblind.button_pressed = bool(GameState.get_accessibility_setting("colorblind_mode", false))
	box.add_child(colorblind)

	var large_cursor := CheckBox.new()
	large_cursor.text = "Large Cursor (Saved Preference)"
	large_cursor.button_pressed = bool(GameState.get_accessibility_setting("large_cursor", false))
	box.add_child(large_cursor)

	var text_label := Label.new()
	text_label.text = "Text Scale"
	UITheme.style_body(text_label, UITheme.FONT_BODY)
	box.add_child(text_label)
	var text_scale := HSlider.new()
	text_scale.min_value = 0.8
	text_scale.max_value = 1.5
	text_scale.step = 0.1
	text_scale.value = float(GameState.get_accessibility_setting("text_scale", 1.0))
	box.add_child(text_scale)

	var anim_label := Label.new()
	anim_label.text = "Animation Speed"
	UITheme.style_body(anim_label, UITheme.FONT_BODY)
	box.add_child(anim_label)
	var anim_scale := HSlider.new()
	anim_scale.min_value = 0.5
	anim_scale.max_value = 2.0
	anim_scale.step = 0.1
	anim_scale.value = float(GameState.get_accessibility_setting("animation_speed", 1.0))
	box.add_child(anim_scale)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", UITheme.PAD_SM)
	box.add_child(row)
	var close_btn := Button.new()
	UITheme.style_button(close_btn, "CLOSE", 48)
	close_btn.pressed.connect(_on_accessibility_close_pressed)
	row.add_child(close_btn)
	var save_btn := Button.new()
	UITheme.style_button(save_btn, "SAVE", 48)
	save_btn.pressed.connect(_on_accessibility_save_pressed.bind(high_contrast, colorblind, large_cursor, text_scale, anim_scale))
	row.add_child(save_btn)
	return panel
