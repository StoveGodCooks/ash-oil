extends Control
## Roman landing page composition for Ash & Oil with cinematic Colosseum background.

class SmokeParticle:
	var pos: Vector2
	var vel: Vector2
	var life: float = 1.0
	var opacity: float = 0.0
	var size: float = 0.0

class SmokeSystem extends Node2D:
	var particles: Array[SmokeParticle] = []
	var spawn_timer: float = 0.0
	var viewport_size: Vector2

	func _ready() -> void:
		viewport_size = get_viewport_rect().size

	func _process(delta: float) -> void:
		spawn_timer += delta
		# Spawn new smoke particles
		if spawn_timer > 0.05:  # ~20 particles/sec
			var new_particle = SmokeParticle.new()
			new_particle.pos = Vector2(randf_range(0, viewport_size.x), viewport_size.y + 20)
			new_particle.vel = Vector2(randf_range(-15, 15), randf_range(-25, -40))
			new_particle.opacity = randf_range(0.3, 0.6)
			new_particle.size = randf_range(30, 80)
			particles.append(new_particle)
			spawn_timer = 0.0

		# Update existing particles
		for p in particles:
			p.pos += p.vel * delta
			p.vel.y *= 0.98  # Slight deceleration
			p.life -= delta * 0.6
			p.opacity = p.life * randf_range(0.2, 0.4)

		# Remove dead particles
		particles = particles.filter(func(p): return p.life > 0)
		queue_redraw()

	func _draw() -> void:
		for p in particles:
			var alpha = clamp(p.opacity, 0.0, 0.5)
			draw_circle(p.pos, p.size, Color(0.3, 0.25, 0.2, alpha))
			draw_circle(p.pos, p.size * 0.7, Color(0.4, 0.35, 0.3, alpha * 0.6))

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
var smoke_system: SmokeSystem

func _ready() -> void:
	# Background image — graceful fallback to dark stone if image not yet imported
	var bg_tex: Texture2D = load("res://assets/backgrounds/landing_colosseum.png") if ResourceLoader.exists("res://assets/backgrounds/landing_colosseum.png") else null
	if bg_tex:
		var bg_texture_rect := TextureRect.new()
		bg_texture_rect.texture = bg_tex
		bg_texture_rect.stretch_mode = TextureRect.STRETCH_SCALE
		bg_texture_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
		bg_texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(bg_texture_rect)
	else:
		var bg_fallback := ColorRect.new()
		bg_fallback.color = Color(0.07, 0.055, 0.04)  # Deep dark stone — cinematic fallback
		bg_fallback.set_anchors_preset(Control.PRESET_FULL_RECT)
		bg_fallback.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(bg_fallback)
		push_warning("Landing background not found — ensure landing_colosseum.png is a valid PNG and reimport in Godot editor")

	# Smoke particle system (Node2D — no anchors, draws at viewport coords)
	smoke_system = SmokeSystem.new()
	smoke_system.z_index = 1
	add_child(smoke_system)

	# Vignette overlay — simple ColorRect, no custom class needed
	var vignette := ColorRect.new()
	vignette.color = Color(0, 0, 0, 0.35)
	vignette.set_anchors_preset(Control.PRESET_FULL_RECT)
	vignette.z_index = 2
	vignette.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(vignette)

	var awning := RomanAwning.new()
	awning.name = "Awning"
	awning.set_anchors_preset(Control.PRESET_FULL_RECT)
	awning.z_index = 3
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
	top_ornament.z_index = 5
	add_child(top_ornament)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.z_index = 4
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
	title_block.z_index = 10
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
	start_btn.mouse_entered.connect(_on_button_hover.bindv([start_btn, true]))
	start_btn.mouse_exited.connect(_on_button_hover.bindv([start_btn, false]))
	btn_col.add_child(start_btn)

	continue_btn = Button.new()
	continue_btn.text = "CONTINUE"
	continue_btn.custom_minimum_size = Vector2(280, 52)
	_apply_button_theme(continue_btn, "secondary")
	continue_btn.disabled = not SaveManager.save_exists(1)
	if continue_btn.disabled:
		continue_btn.modulate = Color(1.0, 1.0, 1.0, 0.55)
	continue_btn.pressed.connect(_on_continue_pressed)
	continue_btn.mouse_entered.connect(_on_button_hover.bindv([continue_btn, true]))
	continue_btn.mouse_exited.connect(_on_button_hover.bindv([continue_btn, false]))
	btn_col.add_child(continue_btn)

	if OS.is_debug_build():
		var dev_btn := Button.new()
		dev_btn.text = "DEV MODE"
		dev_btn.custom_minimum_size = Vector2(200, 40)
		_apply_button_theme(dev_btn, "secondary")
		dev_btn.pressed.connect(_on_dev_pressed)
		dev_btn.mouse_entered.connect(_on_button_hover.bindv([dev_btn, true]))
		dev_btn.mouse_exited.connect(_on_button_hover.bindv([dev_btn, false]))
		btn_col.add_child(dev_btn)

	var version := Label.new()
	version.text = "v0.10.0 - Phase 11 Complete"
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
	version.z_index = 10
	add_child(version)

	_fade_in(column, 0.0)

	print("=== ASH & OIL - CINEMATIC LANDING PAGE LOADED ===")
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

func _on_button_hover(btn: Button, hovering: bool) -> void:
	if btn.disabled:
		return

	if hovering:
		var tween := create_tween()
		tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(btn, "scale", Vector2(1.08, 1.08), 0.12)
	else:
		var tween := create_tween()
		tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.12)

func _fade_in(node: CanvasItem, delay: float) -> void:
	node.modulate = Color(1, 1, 1, 0)
	var tween := create_tween()
	tween.tween_property(node, "modulate:a", 1.0, 0.4).set_delay(delay)
