extends HBoxContainer
## Reusable Meters Display Component
## Shows 6 narrative meters: REPUTATION, DANGER, FAITH, ALLIES, COST, RESISTANCE
## Can be integrated into MainHub header or CombatUI

var meter_displays: Dictionary = {}

# Map narrative meter names -> legacy GameState meter names.
var meter_map = {
	"REPUTATION": "RENOWN",
	"DANGER": "HEAT",
	"FAITH": "PIETY",
	"ALLIES": "FAVOR",
	"COST": "DEBT",
	"RESISTANCE": "DREAD",
}

# Meter configuration (for display purposes)
var meter_config = {
	"REPUTATION": {"label": "REPUTATION", "icon": "👤", "tooltip": "Who knows your name? How feared are you?"},
	"DANGER": {"label": "DANGER", "icon": "⚔", "tooltip": "Who's hunting you? How close are they?"},
	"FAITH": {"label": "FAITH", "icon": "✦", "tooltip": "Do you believe in what you're doing?"},
	"ALLIES": {"label": "ALLIES", "icon": "🤝", "tooltip": "Who stands with you? Who will die for you?"},
	"COST": {"label": "COST", "icon": "🩸", "tooltip": "What has been paid? What's the price?"},
	"RESISTANCE": {"label": "RESISTANCE", "icon": "⛓", "tooltip": "How organized is the opposition?"},
}

func _ready() -> void:
	_build_ui()
	GameState.meter_changed.connect(_on_meter_changed)
	refresh()

func _build_ui() -> void:
	# Create display for each meter
	for meter_name in meter_config.keys():
		var meter_display = _create_meter_row(meter_name)
		add_child(meter_display)

func _create_meter_row(meter_name: String) -> HBoxContainer:
	var row = HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)

	var config = meter_config[meter_name]

	# Icon
	var icon_label = Label.new()
	icon_label.text = config["icon"]
	icon_label.add_theme_font_size_override("font_size", 12)
	row.add_child(icon_label)

	# Name
	var name_label = Label.new()
	name_label.text = config["label"]
	name_label.add_theme_font_size_override("font_size", 9)
	name_label.custom_minimum_size = Vector2(80, 0)
	row.add_child(name_label)

	# Value label (updated dynamically)
	var value_label = Label.new()
	value_label.name = "ValueLabel"
	value_label.add_theme_font_size_override("font_size", 10)
	value_label.add_theme_color_override("font_color", Color.GRAY)
	row.add_child(value_label)

	# Progress bar (simple visual representation)
	var bar = ProgressBar.new()
	bar.custom_minimum_size = Vector2(60, 12)
	bar.min_value = 0
	bar.max_value = 20  # Adjust based on meter ranges
	row.add_child(bar)

	# Store bar reference for updates
	meter_displays[meter_name] = {"row": row, "value_label": value_label, "bar": bar}

	return row

func refresh() -> void:
	for meter_name in meter_config.keys():
		var legacy_name = meter_map.get(meter_name, meter_name)
		var value = GameState.get_meter(legacy_name)
		_update_meter_display(meter_name, value)

func _on_meter_changed(meter_name: String, new_value: int) -> void:
	var canonical = _resolve_canonical_meter(meter_name)
	if canonical == "":
		return
	_update_meter_display(canonical, new_value)

func _update_meter_display(meter_name: String, value: int) -> void:
	if meter_name not in meter_displays:
		return

	var display = meter_displays[meter_name]
	if display is Dictionary:
		display["value_label"].text = str(value)

		# Update bar
		var max_val = 20
		match meter_name:
			"REPUTATION": max_val = 20
			"DANGER": max_val = 15
			"FAITH": max_val = 10
			"ALLIES": max_val = 12
			"COST": max_val = 30  # Can go high
			"RESISTANCE": max_val = 20

		display["bar"].max_value = max_val
		display["bar"].value = min(value, max_val)

		# Color code by value
		var color = _get_meter_color(meter_name, value, max_val)
		display["value_label"].add_theme_color_override("font_color", color)

func _get_meter_color(meter_name: String, value: int, max_val: int) -> Color:
	# Danger and Cost are "bad" (red when high), others are "good" (green when high)
	if meter_name in ["DANGER", "COST"]:
		# High = red, Low = green
		var ratio = float(value) / float(max_val)
		return Color.GREEN.lerp(Color.RED, ratio)
	else:
		# High = green, Low = red
		var ratio = float(value) / float(max_val)
		return Color.RED.lerp(Color.GREEN, ratio)

func _resolve_canonical_meter(meter_name: String) -> String:
	if meter_name in meter_config:
		return meter_name
	for canonical in meter_map.keys():
		if meter_map[canonical] == meter_name:
			return canonical
	return ""
