extends Control
## Roman landing page composition for Ash & Oil.

class RomanAwning extends Control:
	var tint := Color(0.240, 0.192, 0.138, 0.30)

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		var apex := Vector2(size.x * 0.5, size.y)
		draw_line(Vector2(0, 0), apex, tint, 1.0)
		draw_line(Vector2(size.x, 0), apex, tint, 1.0)


class RomanDivider extends Control:
	var tint := UITheme.CLR_BRONZE

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		UITheme.draw_section_divider(self, size.y * 0.5, size.x, tint)


var start_btn: Button
var continue_btn: Button

func _ready() -> void:
	var bg := ColorRect.new()
	bg.color = UITheme.CLR_VOID
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	var awning := RomanAwning.new()
	awning.name = "Awning"
	awning.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(awning)

	var top_ornament := RomanDivider.new()
	top_ornament.name = "TopOrnament"
	top_ornament.custom_minimum_size = Vector2(600, 18)
	top_ornament.anchor_left = 0.5
	top_ornament.anchor_right = 0.5
	top_ornament.anchor_top = 0.24
	top_ornament.anchor_bottom = 0.24
	top_ornament.offset_left = -300
	top_ornament.offset_right = 300
	top_ornament.offset_top = -9
	top_ornament.offset_bottom = 9
	top_ornament.z_index = 1
	add_child(top_ornament)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var column := VBoxContainer.new()
	column.name = "CenterColumn"
	column.custom_minimum_size = Vector2(600, 0)
	column.alignment = BoxContainer.ALIGNMENT_CENTER
	column.add_theme_constant_override("separation", 16)
	center.add_child(column)

	var title_block := VBoxContainer.new()
	title_block.custom_minimum_size = Vector2(560, 0)
	title_block.alignment = BoxContainer.ALIGNMENT_CENTER
	title_block.add_theme_constant_override("separation", 0)
	title_block.z_index = 5
	column.add_child(title_block)

	var ash_row := HBoxContainer.new()
	ash_row.add_theme_constant_override("separation", 12)
	ash_row.alignment = BoxContainer.ALIGNMENT_CENTER
	title_block.add_child(ash_row)

	var left_line := Label.new()
	left_line.text = "────────"
	left_line.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	left_line.add_theme_color_override("font_color", UITheme.CLR_BRONZE)
	ash_row.add_child(left_line)

	var ash := Label.new()
	ash.text = "A S H"
	ash.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ash.add_theme_font_size_override("font_size", 56)
	ash.add_theme_color_override("font_color", UITheme.CLR_GOLD)
	ash_row.add_child(ash)

	var right_line := Label.new()
	right_line.text = "────────"
	right_line.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	right_line.add_theme_color_override("font_color", UITheme.CLR_BRONZE)
	ash_row.add_child(right_line)

	var amp_spacer_top := Control.new()
	amp_spacer_top.custom_minimum_size = Vector2(0, 8)
	title_block.add_child(amp_spacer_top)

	var amp := Label.new()
	amp.text = "&"
	amp.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	amp.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_HEADER)
	amp.add_theme_color_override("font_color", UITheme.CLR_BRONZE)
	title_block.add_child(amp)

	var amp_spacer_bottom := Control.new()
	amp_spacer_bottom.custom_minimum_size = Vector2(0, 8)
	title_block.add_child(amp_spacer_bottom)

	var oil := Label.new()
	oil.text = "O I L"
	oil.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	oil.add_theme_font_size_override("font_size", 56)
	oil.add_theme_color_override("font_color", UITheme.CLR_GOLD)
	title_block.add_child(oil)

	var subtitle := Label.new()
	subtitle.text = "A GLADIATOR'S CHRONICLE"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	subtitle.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	column.add_child(subtitle)

	var divider_spacer := Control.new()
	divider_spacer.custom_minimum_size = Vector2(0, 40)
	column.add_child(divider_spacer)

	var mid_divider := RomanDivider.new()
	mid_divider.name = "MidDivider"
	mid_divider.custom_minimum_size = Vector2(560, 18)
	column.add_child(mid_divider)

	var btn_col := VBoxContainer.new()
	btn_col.alignment = BoxContainer.ALIGNMENT_CENTER
	btn_col.add_theme_constant_override("separation", 16)
	column.add_child(btn_col)

	start_btn = Button.new()
	start_btn.text = "NEW CAMPAIGN"
	start_btn.custom_minimum_size = Vector2(280, 52)
	_apply_button_theme(start_btn, "primary")
	start_btn.pressed.connect(_on_start_pressed)
	btn_col.add_child(start_btn)

	continue_btn = Button.new()
	continue_btn.text = "CONTINUE"
	continue_btn.custom_minimum_size = Vector2(280, 52)
	_apply_button_theme(continue_btn, "secondary")
	continue_btn.disabled = not SaveManager.save_exists(1)
	if continue_btn.disabled:
		continue_btn.modulate = Color(1.0, 1.0, 1.0, 0.55)
	continue_btn.pressed.connect(_on_continue_pressed)
	btn_col.add_child(continue_btn)

	if OS.is_debug_build():
		var dev_btn := Button.new()
		dev_btn.text = "DEV MODE"
		dev_btn.custom_minimum_size = Vector2(200, 40)
		_apply_button_theme(dev_btn, "secondary")
		dev_btn.pressed.connect(_on_dev_pressed)
		btn_col.add_child(dev_btn)

	var version := Label.new()
	version.text = "v0.4 - Phase 4 Complete"
	version.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	version.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
	version.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	version.anchor_left = 0.5
	version.anchor_right = 0.5
	version.anchor_top = 1.0
	version.anchor_bottom = 1.0
	version.offset_left = -160
	version.offset_right = 160
	version.offset_top = -20 - UITheme.FONT_SIZE_FINE
	version.offset_bottom = -20
	add_child(version)

	_fade_in(column, 0.0)

	print("=== ASH & OIL - MAIN MENU LOADED ===")
	print("GameState online: RENOWN=%d HEAT=%d" % [GameState.renown, GameState.heat])
	print("Missions available: ", MissionManager.get_available_missions())

func _on_start_pressed() -> void:
	GameState.reset()
	GameState.current_deck = CardManager.get_starter_deck()
	GameState.current_mission_id = "M01"
	# Give free starting gear (one common per slot)
	GameState.add_gear("gear_001")   # Iron Gladius   - Weapon
	GameState.add_gear("gear_009")   # Leather Vest   - Armor
	GameState.add_gear("gear_017")   # Iron Ring      - Accessory
	GameState.equip_gear("weapon",    "gear_001")
	GameState.equip_gear("armor",     "gear_009")
	GameState.equip_gear("accessory", "gear_017")
	print("--- NEW GAME STARTED ---")
	print("Gold: %d | Deck: %d cards" % [GameState.gold, GameState.current_deck.size()])
	get_tree().change_scene_to_file("res://scenes/MainHub.tscn")

func _on_dev_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/DevMenu.tscn")

func _on_continue_pressed() -> void:
	if SaveManager.load_game(1):
		print("--- GAME LOADED ---")
		print("RENOWN: %d | HEAT: %d | Gold: %d" % [GameState.renown, GameState.heat, GameState.gold])
		get_tree().change_scene_to_file("res://scenes/CombatScreen.tscn")
	else:
		print("No save file found!")

func _apply_button_theme(btn: Button, style_kind: String) -> void:
	btn.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_BODY)
	match style_kind:
		"primary":
			btn.add_theme_color_override("font_color", UITheme.CLR_VOID)
			btn.add_theme_stylebox_override("normal", UITheme.btn_primary())
			btn.add_theme_stylebox_override("hover", UITheme.btn_primary_hover())
			btn.add_theme_stylebox_override("pressed", UITheme.btn_active())
		_:
			btn.add_theme_color_override("font_color", UITheme.CLR_VELLUM)
			btn.add_theme_stylebox_override("normal", UITheme.btn_secondary())
			btn.add_theme_stylebox_override("hover", UITheme.btn_secondary_hover())
			btn.add_theme_stylebox_override("pressed", UITheme.btn_active())

func _fade_in(node: CanvasItem, delay: float) -> void:
	node.modulate = Color(1, 1, 1, 0)
	var tween := create_tween()
	tween.tween_property(node, "modulate:a", 1.0, 0.4).set_delay(delay)
