extends PanelContainer
## Mission Briefing Panel
## Shows story context before entering a mission
## Displays who's hunting, who helps, expected meter changes, Cassian's monologue

var title_label: Label
var brief_label: Label
var hunts_label: Label
var helps_label: Label
var monologue_label: Label
var meters_container: VBoxContainer
var ready_button: Button
var cancel_button: Button
var subtitle_label: Label
var divider_top: ColorRect
var divider_mid: ColorRect

var current_mission_id: String = ""
var on_ready_callback: Callable = func(): pass

func _ready() -> void:
	_build_ui()
	ready_button.pressed.connect(_on_ready_pressed)
	# Start hidden
	hide()

func _build_ui() -> void:
	add_theme_stylebox_override("panel", UITheme.make_panel_style(true))
	custom_minimum_size = Vector2(420, 520)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", UITheme.PAD_SM)
	add_child(vbox)

	subtitle_label = Label.new()
	subtitle_label.text = "MISSION BRIEF"
	UITheme.style_header(subtitle_label, UITheme.FONT_FINE, true)
	subtitle_label.add_theme_color_override("font_color", UITheme.COLOR_TEXT_DIM)
	vbox.add_child(subtitle_label)

	title_label = Label.new()
	UITheme.style_header(title_label, UITheme.FONT_SUBHEADER, true)
	vbox.add_child(title_label)

	divider_top = ColorRect.new()
	divider_top.color = UITheme.COLOR_BORDER
	divider_top.custom_minimum_size = Vector2(0, 2)
	vbox.add_child(divider_top)

	brief_label = Label.new()
	UITheme.style_body(brief_label, UITheme.FONT_BODY)
	brief_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	brief_label.custom_minimum_size = Vector2(0, 64)
	vbox.add_child(brief_label)

	var intel_panel := PanelContainer.new()
	intel_panel.add_theme_stylebox_override("panel", UITheme.make_panel_style())
	vbox.add_child(intel_panel)

	var intel_box := VBoxContainer.new()
	intel_box.add_theme_constant_override("separation", 6)
	intel_panel.add_child(intel_box)

	var intel_title := Label.new()
	intel_title.text = "INTEL"
	UITheme.style_header(intel_title, UITheme.FONT_SECONDARY, true)
	intel_box.add_child(intel_title)

	hunts_label = Label.new()
	UITheme.style_body(hunts_label, UITheme.FONT_SECONDARY, true)
	hunts_label.add_theme_color_override("font_color", Color(0.90, 0.30, 0.28))
	intel_box.add_child(hunts_label)

	helps_label = Label.new()
	UITheme.style_body(helps_label, UITheme.FONT_SECONDARY, true)
	helps_label.add_theme_color_override("font_color", Color(0.45, 0.85, 0.55))
	intel_box.add_child(helps_label)

	divider_mid = ColorRect.new()
	divider_mid.color = UITheme.COLOR_BORDER
	divider_mid.custom_minimum_size = Vector2(0, 2)
	vbox.add_child(divider_mid)

	monologue_label = Label.new()
	UITheme.style_body(monologue_label, UITheme.FONT_SECONDARY, true)
	monologue_label.add_theme_color_override("font_color", UITheme.COLOR_TEXT_DIM)
	monologue_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	monologue_label.custom_minimum_size = Vector2(0, 60)
	vbox.add_child(monologue_label)

	var meter_title := Label.new()
	meter_title.text = "EXPECTED METER CHANGES"
	UITheme.style_header(meter_title, UITheme.FONT_SECONDARY, true)
	vbox.add_child(meter_title)

	meters_container = VBoxContainer.new()
	meters_container.add_theme_constant_override("separation", 6)
	vbox.add_child(meters_container)

	var button_row := HBoxContainer.new()
	button_row.add_theme_constant_override("separation", UITheme.PAD_SM)
	button_row.alignment = BoxContainer.ALIGNMENT_END
	vbox.add_child(button_row)

	cancel_button = Button.new()
	UITheme.style_button(cancel_button, "CANCEL", 44)
	cancel_button.custom_minimum_size = Vector2(120, 44)
	cancel_button.pressed.connect(_on_cancel_pressed)
	button_row.add_child(cancel_button)

	ready_button = Button.new()
	UITheme.style_button(ready_button, "READY", 44)
	ready_button.custom_minimum_size = Vector2(120, 44)
	button_row.add_child(ready_button)

func set_mission(mission_id: String) -> void:
	current_mission_id = mission_id
	var hook = NarrativeManager.get_mission_hook(mission_id)

	if hook.is_empty():
		print("⚠ No hook for mission: ", mission_id)
		hide()
		return

	# Set title and brief
	title_label.text = hook.get("title", mission_id)
	brief_label.text = hook.get("brief", "")

	# Show who's hunting
	var who_hunts = hook.get("who_hunts", [])
	hunts_label.text = "Hunted by: " + ", ".join(who_hunts) if not who_hunts.is_empty() else "Hunted by: (unknown)"

	# Show who helps
	var who_helps = hook.get("who_helps", [])
	helps_label.text = "You stand with: " + ", ".join(who_helps) if not who_helps.is_empty() else "You stand alone"

	# Show Cassian's monologue
	var mono = hook.get("monologue", "")
	monologue_label.text = "“%s”" % mono if mono != "" else ""

	# Show meter changes
	_display_meter_changes(hook.get("meter_impact", {}))

	show()

func _display_meter_changes(meter_impact: Dictionary) -> void:
	# Clear existing
	for child in meters_container.get_children():
		child.queue_free()

	# Map internal names to display names
	var meter_names = {
		"REPUTATION": "REPUTATION",
		"DANGER": "DANGER",
		"FAITH": "FAITH",
		"ALLIES": "ALLIES",
		"COST": "COST",
		"RESISTANCE": "RESISTANCE",
	}

	for meter_name in meter_impact.keys():
		if meter_name not in meter_names:
			continue

		var amount = meter_impact[meter_name]
		var display_name = meter_names[meter_name]
		var sign = "+" if amount >= 0 else ""
		var color = Color(0.45, 0.85, 0.55) if amount > 0 else Color(0.90, 0.30, 0.28) if amount < 0 else UITheme.COLOR_TEXT_DIM

		var meter_label = Label.new()
		meter_label.text = "%s %s%d" % [display_name, sign, amount]
		meter_label.add_theme_color_override("font_color", color)
		meter_label.add_theme_font_size_override("font_size", UITheme.FONT_SECONDARY)
		meters_container.add_child(meter_label)

func _on_ready_pressed() -> void:
	hide()
	on_ready_callback.call()

func _on_cancel_pressed() -> void:
	hide()

func set_ready_callback(callback: Callable) -> void:
	on_ready_callback = callback
