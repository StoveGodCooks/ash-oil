extends Control
## Main menu - builds UI in code so scene file stays simple

# ── Parchment & Wax palette ──
const CLR_BG      = Color(0.08, 0.065, 0.050)
const CLR_PANEL   = Color(0.14, 0.110, 0.080)
const CLR_BORDER  = Color(0.42, 0.320, 0.160)
const CLR_ACCENT  = Color(0.86, 0.700, 0.360)
const CLR_TEXT    = Color(0.90, 0.840, 0.680)
const CLR_MUTED   = Color(0.58, 0.520, 0.400)
const CLR_BTN     = Color(0.20, 0.160, 0.115)
const CLR_BTN_ALT = Color(0.14, 0.220, 0.150)
const CLR_DANGER  = Color(0.26, 0.095, 0.090)
const CLR_STONE   = Color(0.18, 0.155, 0.120)
const CLR_SEAL    = Color(0.36, 0.12, 0.10)

const TEX_CREST  = "res://assets/ui/roman/crest.png"
const TEX_BANNER = "res://assets/ui/roman/banner.png"

var start_btn: Button
var continue_btn: Button

func _ready() -> void:
	# Background layers
	var bg = ColorRect.new()
	bg.color = CLR_BG
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var stone_top = ColorRect.new()
	stone_top.color = CLR_STONE
	stone_top.set_anchors_preset(Control.PRESET_TOP_WIDE)
	stone_top.custom_minimum_size = Vector2(0, 70)
	add_child(stone_top)

	var stone_bottom = ColorRect.new()
	stone_bottom.color = CLR_STONE
	stone_bottom.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	stone_bottom.custom_minimum_size = Vector2(0, 70)
	add_child(stone_bottom)

	var bg_top = ColorRect.new()
	bg_top.color = CLR_PANEL
	bg_top.set_anchors_preset(Control.PRESET_TOP_WIDE)
	bg_top.custom_minimum_size = Vector2(0, 180)
	add_child(bg_top)

	var vignette = ColorRect.new()
	vignette.color = Color(0, 0, 0, 0.25)
	vignette.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(vignette)

	# Center container
	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_CENTER)
	vbox.custom_minimum_size = Vector2(300, 400)
	vbox.position -= vbox.custom_minimum_size / 2
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(vbox)

	# Title banner
	var banner = PanelContainer.new()
	banner.custom_minimum_size = Vector2(320, 140)
	banner.add_theme_stylebox_override("panel", _panel_style(CLR_PANEL))
	vbox.add_child(banner)

	var banner_v = VBoxContainer.new()
	banner_v.alignment = BoxContainer.ALIGNMENT_CENTER
	banner_v.set_anchors_preset(Control.PRESET_FULL_RECT)
	banner.add_child(banner_v)

	# Crest line
	var crest = _make_texture(TEX_CREST, Vector2(72, 72))
	crest.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	banner_v.add_child(crest)

	var banner_tex = _make_texture(TEX_BANNER, Vector2(280, 60))
	banner_tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	banner_v.add_child(banner_tex)

	# Title
	var title = Label.new()
	title.text = "ASH  &  OIL"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", CLR_ACCENT)
	banner_v.add_child(title)

	# Subtitle
	var sub = Label.new()
	sub.text = "GLADIATOR CONTRACTS & BLOOD DEBTS"
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub.add_theme_font_size_override("font_size", 14)
	sub.add_theme_color_override("font_color", CLR_TEXT)
	banner_v.add_child(sub)

	# Spacer
	var sp1 = Control.new()
	sp1.custom_minimum_size = Vector2(0, 40)
	vbox.add_child(sp1)

	# New Game button
	start_btn = _make_button("ENTER THE ARENA", CLR_BTN)
	start_btn.custom_minimum_size = Vector2(200, 50)
	start_btn.pressed.connect(_on_start_pressed)
	vbox.add_child(start_btn)

	# Continue button
	continue_btn = _make_button("RESUME CONTRACT", CLR_BTN_ALT)
	continue_btn.custom_minimum_size = Vector2(200, 50)
	continue_btn.disabled = not SaveManager.save_exists(1)
	continue_btn.pressed.connect(_on_continue_pressed)
	vbox.add_child(continue_btn)

	# Spacer
	var sp2 = Control.new()
	sp2.custom_minimum_size = Vector2(0, 20)
	vbox.add_child(sp2)

	# Dev Mode button
	var dev_btn = _make_button("DEV MODE", CLR_DANGER)
	dev_btn.custom_minimum_size = Vector2(200, 40)
	dev_btn.pressed.connect(_on_dev_pressed)
	vbox.add_child(dev_btn)

	# Version
	var ver = Label.new()
	ver.text = "v0.4 - Phase 4 Complete"
	ver.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ver.add_theme_font_size_override("font_size", 11)
	ver.add_theme_color_override("font_color", CLR_MUTED)
	vbox.add_child(ver)

	_fade_in(vbox, 0.0)

	print("=== ASH & OIL - MAIN MENU LOADED ===")
	print("GameState online: RENOWN=%d HEAT=%d" % [GameState.RENOWN, GameState.HEAT])
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
		print("RENOWN: %d | HEAT: %d | Gold: %d" % [GameState.RENOWN, GameState.HEAT, GameState.gold])
		get_tree().change_scene_to_file("res://scenes/CombatScreen.tscn")
	else:
		print("No save file found!")

func _make_button(text: String, color: Color) -> Button:
	var btn = Button.new()
	btn.text = text
	btn.add_theme_font_size_override("font_size", 14)
	btn.add_theme_color_override("font_color", CLR_TEXT)
	btn.add_theme_stylebox_override("normal", _make_style(color))
	btn.add_theme_stylebox_override("hover", _make_style(color.lightened(0.15)))
	btn.add_theme_stylebox_override("pressed", _make_style(color.darkened(0.15)))
	return btn

func _make_style(color: Color) -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = color
	s.border_color = CLR_BORDER
	s.border_width_left = 1
	s.border_width_top = 1
	s.border_width_right = 1
	s.border_width_bottom = 2
	s.corner_radius_top_left = 6
	s.corner_radius_top_right = 6
	s.corner_radius_bottom_left = 6
	s.corner_radius_bottom_right = 6
	s.content_margin_left = 14
	s.content_margin_right = 14
	s.content_margin_top = 6
	s.content_margin_bottom = 6
	s.shadow_size = 4
	s.shadow_color = Color(0, 0, 0, 0.35)
	return s

func _panel_style(color: Color) -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = color
	s.border_color = CLR_BORDER
	s.border_width_left = 1
	s.border_width_top = 1
	s.border_width_right = 1
	s.border_width_bottom = 2
	s.corner_radius_top_left = 8
	s.corner_radius_top_right = 8
	s.corner_radius_bottom_left = 8
	s.corner_radius_bottom_right = 8
	s.content_margin_left = 10
	s.content_margin_right = 10
	s.content_margin_top = 8
	s.content_margin_bottom = 8
	s.shadow_size = 6
	s.shadow_color = Color(0, 0, 0, 0.35)
	return s

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
	tween.tween_property(node, "modulate:a", 1.0, 0.4).set_delay(delay)
