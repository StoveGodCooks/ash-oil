extends ScrollContainer
## Mission Log / Journal
## Shows chronological list of completed missions with story outcomes
## Each entry shows: monologue, meter deltas, faction encounters, phase markers

@onready var log_container: VBoxContainer = %LogContainer

var mission_entries: Array = []

func _ready() -> void:
	# Initial build from saved missions
	_rebuild_log()

func _rebuild_log() -> void:
	# Clear existing
	for child in log_container.get_children():
		child.queue_free()

	mission_entries.clear()

	# Rebuild from completed missions
	var completed = GameState.completed_missions
	for mission_id in completed:
		add_entry(mission_id)

func add_entry(mission_id: String) -> void:
	var hook = NarrativeManager.get_mission_hook(mission_id)

	if hook.is_empty():
		return

	# Phase separator if needed
	if mission_entries.is_empty() or hook.get("phase") != _get_last_phase():
		var phase_separator = _create_phase_separator(hook.get("phase", ""))
		log_container.add_child(phase_separator)

	# Mission entry
	var entry_panel = PanelContainer.new()
	var entry_vbox = VBoxContainer.new()

	# Mission title + number
	var title = Label.new()
	var mission_num = mission_id.substr(1) if "M" in mission_id else "?"
	title.text = "[%s] %s" % [mission_id, hook.get("title", "Unknown")]
	title.add_theme_font_size_override("font_size", 11)
	title.add_theme_color_override("font_color", Color.GOLD)
	entry_vbox.add_child(title)

	# Monologue / reflection
	var monologue = hook.get("monologue", "")
	if not monologue.is_empty():
		var mono_label = Label.new()
		mono_label.text = "  \"%s\"" % monologue
		mono_label.add_theme_font_size_override("font_size", 9)
		mono_label.add_theme_color_override("font_color", Color.GRAY)
		mono_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		entry_vbox.add_child(mono_label)

	# Meter deltas
	var meter_impact = hook.get("meter_impact", {})
	if not meter_impact.is_empty():
		var meters_label = Label.new()
		var meter_text = "  Meters: "
		for meter in meter_impact:
			var val = meter_impact[meter]
			var sign = "+" if val >= 0 else ""
			meter_text += "%s %s%d  " % [meter, sign, val]
		meters_label.text = meter_text.trim_suffix("  ")
		meters_label.add_theme_font_size_override("font_size", 8)
		meters_label.add_theme_color_override("font_color", Color.GRAY)
		entry_vbox.add_child(meters_label)

	# Who hunts / helps
	var who_hunts = hook.get("who_hunts", [])
	var who_helps = hook.get("who_helps", [])
	if not who_hunts.is_empty() or not who_helps.is_empty():
		var relations_label = Label.new()
		var relations_text = "  "
		if not who_hunts.is_empty():
			relations_text += "Hunted: " + ", ".join(who_hunts) + "  "
		if not who_helps.is_empty():
			relations_text += "Allied: " + ", ".join(who_helps)
		relations_label.text = relations_text.trim_suffix("  ")
		relations_label.add_theme_font_size_override("font_size", 8)
		relations_label.add_theme_color_override("font_color", Color.LIGHT_GRAY)
		entry_vbox.add_child(relations_label)

	entry_panel.add_child(entry_vbox)
	log_container.add_child(entry_panel)

	mission_entries.append(mission_id)

func _create_phase_separator(phase: String) -> PanelContainer:
	var separator = PanelContainer.new()
	var label = Label.new()
	label.text = "─── ACT: %s ───" % phase
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", Color.GOLD)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	separator.add_child(label)
	return separator

func _get_last_phase() -> String:
	if mission_entries.is_empty():
		return ""
	var last_hook = NarrativeManager.get_mission_hook(mission_entries[-1])
	return last_hook.get("phase", "")
