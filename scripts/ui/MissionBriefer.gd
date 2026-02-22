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

var current_mission_id: String = ""
var on_ready_callback: Callable = func(): pass

func _ready() -> void:
	_build_ui()
	ready_button.pressed.connect(_on_ready_pressed)
	# Start hidden
	hide()

func _build_ui() -> void:
	# Create main layout
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)

	# Title
	title_label = Label.new()
	title_label.add_theme_font_size_override("font_size", 14)
	title_label.add_theme_color_override("font_color", Color.GOLD)
	vbox.add_child(title_label)

	# Brief
	brief_label = Label.new()
	brief_label.add_theme_font_size_override("font_size", 10)
	brief_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	brief_label.custom_minimum_size = Vector2(300, 40)
	vbox.add_child(brief_label)

	# Who hunts
	hunts_label = Label.new()
	hunts_label.add_theme_font_size_override("font_size", 9)
	hunts_label.add_theme_color_override("font_color", Color.RED)
	vbox.add_child(hunts_label)

	# Who helps
	helps_label = Label.new()
	helps_label.add_theme_font_size_override("font_size", 9)
	helps_label.add_theme_color_override("font_color", Color.GREEN)
	vbox.add_child(helps_label)

	# Monologue
	monologue_label = Label.new()
	monologue_label.add_theme_font_size_override("font_size", 9)
	monologue_label.add_theme_color_override("font_color", Color.GRAY)
	monologue_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	monologue_label.custom_minimum_size = Vector2(300, 30)
	vbox.add_child(monologue_label)

	# Meter changes separator
	var meter_sep = Label.new()
	meter_sep.text = "─ Meter Changes ─"
	meter_sep.add_theme_font_size_override("font_size", 9)
	meter_sep.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(meter_sep)

	# Meters container
	meters_container = VBoxContainer.new()
	meters_container.add_theme_constant_override("separation", 4)
	vbox.add_child(meters_container)

	# Ready button
	ready_button = Button.new()
	ready_button.text = "Ready"
	ready_button.custom_minimum_size = Vector2(100, 30)
	vbox.add_child(ready_button)

	add_child(vbox)

func set_mission(mission_id: String) -> void:
	current_mission_id = mission_id
	var hook = NarrativeManager.get_mission_hook(mission_id)

	if hook.is_empty():
		print("⚠ No hook for mission: ", mission_id)
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
	monologue_label.text = hook.get("monologue", "")

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
		var color = Color.GREEN if amount > 0 else Color.RED if amount < 0 else Color.GRAY

		var meter_label = Label.new()
		meter_label.text = "%s %s%d" % [display_name, sign, amount]
		meter_label.add_theme_color_override("font_color", color)
		meters_container.add_child(meter_label)

func _on_ready_pressed() -> void:
	hide()
	on_ready_callback.call()

func set_ready_callback(callback: Callable) -> void:
	on_ready_callback = callback
