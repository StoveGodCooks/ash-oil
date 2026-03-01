extends Control
## Modal overlay to present narrative scenes/intermissions/endings with optional choices.

signal dismissed(scene_id: String)

var _backdrop: ColorRect
var _panel: PanelContainer
var _title: Label
var _body: Label
var _meta: Label
var _portrait: TextureRect
var _choices_box: VBoxContainer
var _scene_id: String = ""

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_backdrop = ColorRect.new()
	_backdrop.color = Color(0, 0, 0, 0.55)
	_backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_backdrop)

	_panel = PanelContainer.new()
	_panel.add_theme_stylebox_override("panel", UITheme.make_panel_style())
	_panel.custom_minimum_size = Vector2(720, 420)
	_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	_panel.set_anchors_preset(Control.PRESET_CENTER)
	add_child(_panel)

	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", UITheme.PAD_SM)
	_panel.add_child(v)

	_title = Label.new()
	UITheme.style_header(_title, UITheme.FONT_TITLE, true)
	v.add_child(_title)

	_meta = Label.new()
	UITheme.style_body(_meta, UITheme.FONT_FINE, true)
	_meta.modulate = UITheme.CLR_MUTED
	v.add_child(_meta)

	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", UITheme.PAD_SM)
	v.add_child(h)

	_portrait = TextureRect.new()
	_portrait.custom_minimum_size = Vector2(160, 220)
	_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_portrait.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	_portrait.texture = null
	_portrait.visible = false
	h.add_child(_portrait)

	_body = Label.new()
	_body.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_WORD
	_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	UITheme.style_body(_body, UITheme.FONT_BODY, true)
	h.add_child(_body)

	_choices_box = VBoxContainer.new()
	_choices_box.add_theme_constant_override("separation", UITheme.PAD_SM)
	v.add_child(_choices_box)

	var close_btn := Button.new()
	close_btn.text = "CONTINUE"
	UITheme.style_button(close_btn, "CONTINUE")
	close_btn.pressed.connect(_on_close_pressed)
	_choices_box.add_child(close_btn)

	# Simple fade-in animation
	var tween := create_tween()
	_panel.modulate = Color(1, 1, 1, 0)
	_panel.scale = Vector2(0.96, 0.96)
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(_panel, "modulate:a", 1.0, 0.18)
	tween.parallel().tween_property(_panel, "scale", Vector2(1, 1), 0.18)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_close_pressed()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_accept"):
		# Trigger first non-continue choice if present, else continue
		for child in _choices_box.get_children():
			if child is Button and child.text != "CONTINUE":
				(child as Button).emit_signal("pressed")
				get_viewport().set_input_as_handled()
				return
		_on_close_pressed()
		get_viewport().set_input_as_handled()

func present(scene_id: String, scene: Dictionary) -> void:
	_scene_id = scene_id
	_title.text = scene.get("title", scene_id)
	_body.text = scene.get("text", "")
	var tags: Array = scene.get("tags", [])
	var phase: String = str(scene.get("phase", ""))
	var type: String = str(scene.get("type", ""))
	var meta_parts := []
	if type != "": meta_parts.append(type.to_upper())
	if phase != "": meta_parts.append("Phase: %s" % phase)
	if not tags.is_empty(): meta_parts.append("Tags: " + ", ".join(tags))
	_meta.text = "  •  ".join(meta_parts)

	var portrait_path: String = str(scene.get("portrait", ""))
	if portrait_path is String and portrait_path != "" and ResourceLoader.exists(portrait_path):
		_portrait.texture = load(portrait_path)
		_portrait.visible = true
	else:
		_portrait.visible = false

	# Choices (optional)
	# Scene payload may include: choices: [{label, effects:{meter_changes:{}, set_flags:[], clear_flags:[], relationship_changes:{}}, next_scene:String}]
	for child in _choices_box.get_children():
		if child is Button and child.text != "CONTINUE":
			child.queue_free()

	var choices: Array = scene.get("choices", [])
	if choices.is_empty():
		return

	for choice in choices:
		var btn := Button.new()
		btn.text = str(choice.get("label", "Continue"))
		UITheme.style_button(btn, btn.text)
		btn.pressed.connect(func() -> void:
			_apply_effects(choice.get("effects", {}))
			var next_id := str(choice.get("next_scene", ""))
			if next_id != "":
				var next_scene = NarrativeManager.get_scene(next_id)
				if next_scene.is_empty():
					next_scene = NarrativeManager.get_ending_scene(next_id)
				if not next_scene.is_empty():
					present(next_id, next_scene)
					return
			_on_close_pressed()
		)
		_choices_box.add_child(btn)

func _apply_effects(effects: Dictionary) -> void:
	var meters: Dictionary = effects.get("meter_changes", {})
	for meter in meters.keys():
		GameState.change_meter(str(meter), int(meters[meter]))

	for flag_name in effects.get("set_flags", []):
		GameState.set_relationship_flag("global", str(flag_name), true)
	for flag_name in effects.get("clear_flags", []):
		GameState.set_relationship_flag("global", str(flag_name), false)

	var rels: Dictionary = effects.get("relationship_changes", {})
	for npc_id in rels.keys():
		GameState.modify_relationship_score(str(npc_id), int(rels[npc_id]), "scene_choice")

	var factions: Dictionary = effects.get("faction_changes", {})
	for faction_id in factions.keys():
		GameState.modify_faction_alignment(str(faction_id), int(factions[faction_id]), "scene_choice")

func _on_close_pressed() -> void:
	dismissed.emit(_scene_id)
	queue_free()
