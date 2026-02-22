extends Control
## Main menu - builds UI in code so scene file stays simple

var start_btn: Button
var continue_btn: Button

func _ready() -> void:
	# Dark background
	var bg = ColorRect.new()
	bg.color = Color(0.08, 0.06, 0.05, 1)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	# Center container
	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_CENTER)
	vbox.custom_minimum_size = Vector2(300, 400)
	vbox.position -= vbox.custom_minimum_size / 2
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(vbox)

	# Title
	var title = Label.new()
	title.text = "ASH & OIL"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 48)
	vbox.add_child(title)

	# Subtitle
	var sub = Label.new()
	sub.text = "A Tactical Card Game"
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub.add_theme_font_size_override("font_size", 16)
	vbox.add_child(sub)

	# Spacer
	var sp1 = Control.new()
	sp1.custom_minimum_size = Vector2(0, 40)
	vbox.add_child(sp1)

	# New Game button
	start_btn = Button.new()
	start_btn.text = "NEW GAME"
	start_btn.custom_minimum_size = Vector2(200, 50)
	start_btn.pressed.connect(_on_start_pressed)
	vbox.add_child(start_btn)

	# Continue button
	continue_btn = Button.new()
	continue_btn.text = "CONTINUE"
	continue_btn.custom_minimum_size = Vector2(200, 50)
	continue_btn.disabled = not SaveManager.save_exists(1)
	continue_btn.pressed.connect(_on_continue_pressed)
	vbox.add_child(continue_btn)

	# Spacer
	var sp2 = Control.new()
	sp2.custom_minimum_size = Vector2(0, 20)
	vbox.add_child(sp2)

	# Dev Mode button
	var dev_btn = Button.new()
	dev_btn.text = "DEV MODE"
	dev_btn.custom_minimum_size = Vector2(200, 40)
	dev_btn.pressed.connect(_on_dev_pressed)
	vbox.add_child(dev_btn)

	# Version
	var ver = Label.new()
	ver.text = "v0.4 - Phase 4 Complete"
	ver.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ver.add_theme_font_size_override("font_size", 11)
	vbox.add_child(ver)

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
