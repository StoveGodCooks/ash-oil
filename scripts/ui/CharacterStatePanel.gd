extends PanelContainer
## Character State Indicator
## Shows Cassian's narrative phase, active threats, allied lieutenants, refusals counter
## Displays "pressure" from the narrative

var phase_label: Label
var threats_label: Label
var allies_container: VBoxContainer
var refusals_label: Label
var momentum_label: Label

func _ready() -> void:
	add_theme_stylebox_override("panel", UITheme.make_panel_style())
	_build_ui()
	GameState.meter_changed.connect(_on_meter_changed)
	refresh()

func _build_ui() -> void:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", UITheme.PAD_SM)
	add_child(box)

	var title := Label.new()
	title.text = "CHARACTER STATE"
	UITheme.style_header(title, UITheme.FONT_SUBHEADER, true)
	box.add_child(title)

	phase_label = Label.new()
	UITheme.style_body(phase_label, UITheme.FONT_BODY)
	box.add_child(phase_label)

	momentum_label = Label.new()
	UITheme.style_body(momentum_label, UITheme.FONT_BODY)
	box.add_child(momentum_label)

	threats_label = Label.new()
	UITheme.style_body(threats_label, UITheme.FONT_BODY)
	box.add_child(threats_label)

	refusals_label = Label.new()
	UITheme.style_body(refusals_label, UITheme.FONT_BODY)
	box.add_child(refusals_label)

	allies_container = VBoxContainer.new()
	allies_container.add_theme_constant_override("separation", 2)
	box.add_child(allies_container)

func refresh() -> void:
	_update_phase()
	_update_threats()
	_update_allies()
	_update_refusals()
	_update_momentum()

func _update_phase() -> void:
	var phase = GameState.story_phase
	var phase_num = 0
	match phase:
		"SURVIVAL": phase_num = 1
		"HOPE": phase_num = 2
		"RESISTANCE": phase_num = 3

	phase_label.text = "PHASE %d: %s" % [phase_num, phase]

	# Color code by phase
	var color = Color.GRAY
	match phase:
		"SURVIVAL": color = Color.YELLOW
		"HOPE": color = Color.CYAN
		"RESISTANCE": color = Color.RED

	phase_label.add_theme_color_override("font_color", color)

func _update_threats() -> void:
	var threats = GameState.threat_level
	if threats.is_empty():
		threats_label.text = "Threat: (none)"
		return

	threats_label.text = "Hunted by: " + ", ".join(threats)

	# Color by threat level
	if "Marcellus" in threats:
		threats_label.add_theme_color_override("font_color", Color.RED)
	else:
		threats_label.add_theme_color_override("font_color", Color.ORANGE)

func _update_allies() -> void:
	# Clear existing
	for child in allies_container.get_children():
		child.queue_free()

	# Show recruited lieutenants with loyalty status
	var title = Label.new()
	title.text = "ALLIES:"
	UITheme.style_body(title, UITheme.FONT_SECONDARY)
	allies_container.add_child(title)

	var recruited_count = 0
	for lt_name in GameState.lieutenant_data.keys():
		var lt_data = GameState.lieutenant_data[lt_name]
		if lt_data["recruited"]:
			recruited_count += 1
			var ally_label = Label.new()
			var loyalty = lt_data["loyalty"]
			var loyalty_text = "⭐" * max(0, loyalty) if loyalty > 0 else "✗"
			ally_label.text = "  %s %s" % [lt_name, loyalty_text]
			UITheme.style_body(ally_label, UITheme.FONT_FINE)
			allies_container.add_child(ally_label)

	if recruited_count == 0:
		var alone_label = Label.new()
		alone_label.text = "  (Standing alone)"
		UITheme.style_body(alone_label, UITheme.FONT_FINE, true)
		allies_container.add_child(alone_label)

func _update_refusals() -> void:
	refusals_label.text = "Refusals Made: %d" % GameState.refusals_made

	# Darker color as refusals increase (mounting defiance)
	var alpha = clamp(float(GameState.refusals_made) / 20.0, 0.5, 1.0)
	var color = Color(1.0, 0.0, 0.0, alpha)  # Red, increasing opacity
	refusals_label.add_theme_color_override("font_color", color)

func _update_momentum() -> void:
	momentum_label.text = "Momentum: %s" % GameState.narrative_momentum

	# Color by phase
	var color = Color.GRAY
	match GameState.narrative_momentum:
		"On the Run": color = Color.YELLOW
		"Building Opposition": color = Color.CYAN
		"Last Stand": color = Color.RED

	momentum_label.add_theme_color_override("font_color", color)

func _on_meter_changed(_meter_name: String, _new_value: int) -> void:
	# Refresh on any meter change to show updated state
	refresh()
