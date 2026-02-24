extends ScrollContainer
## Mission Log / Journal
## Shows chronological list of completed missions with story outcomes
## Each entry shows: monologue, meter deltas, faction encounters, phase markers

var mission_entries: Array = []
var log_container: VBoxContainer

func _ready() -> void:
	_build_ui()
	# Initial build from saved missions
	_rebuild_log()

func _build_ui() -> void:
	log_container = VBoxContainer.new()
	log_container.add_theme_constant_override("separation", UITheme.PAD_SM)
	log_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	log_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(log_container)

func refresh() -> void:
	_rebuild_log()

func _rebuild_log() -> void:
	# Clear existing
	for child in log_container.get_children():
		child.queue_free()

	mission_entries.clear()

	# Rebuild from completed missions
	var completed = GameState.completed_missions
	if completed.is_empty():
		var none := Label.new()
		none.text = "No missions completed yet."
		UITheme.style_body(none, UITheme.FONT_BODY, true)
		log_container.add_child(none)
		return
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
	entry_panel.add_theme_stylebox_override("panel", UITheme.make_panel_style())
	var entry_vbox = VBoxContainer.new()
	entry_vbox.add_theme_constant_override("separation", 2)

	# Mission title + number
	var title = Label.new()
	title.text = "[%s] %s" % [mission_id, hook.get("title", "Unknown")]
	UITheme.style_header(title, UITheme.FONT_SECONDARY, true)
	entry_vbox.add_child(title)

	# Monologue / reflection
	var monologue = hook.get("monologue", "")
	if not monologue.is_empty():
		var mono_label = Label.new()
		mono_label.text = "  \"%s\"" % monologue
		UITheme.style_body(mono_label, UITheme.FONT_FINE, true)
		mono_label.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_WORD
		entry_vbox.add_child(mono_label)

	# Meter deltas
	var meter_impact = hook.get("meter_impact", {})
	if not meter_impact.is_empty():
		var meters_label = Label.new()
		var meter_text = "  Meters: "
		for meter in meter_impact:
			var val = meter_impact[meter]
			var sign_str = "+" if val >= 0 else ""
			meter_text += "%s %s%d  " % [meter, sign_str, val]
		meters_label.text = meter_text.trim_suffix("  ")
		UITheme.style_body(meters_label, UITheme.FONT_FINE, true)
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
		UITheme.style_body(relations_label, UITheme.FONT_FINE, true)
		entry_vbox.add_child(relations_label)

	entry_panel.add_child(entry_vbox)
	log_container.add_child(entry_panel)

	mission_entries.append(mission_id)

func _create_phase_separator(phase: String) -> PanelContainer:
	var separator = PanelContainer.new()
	separator.add_theme_stylebox_override("panel", UITheme.make_panel_style(true))
	var label = Label.new()
	label.text = "─── ACT: %s ───" % phase
	UITheme.style_header(label, UITheme.FONT_SECONDARY, true)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	separator.add_child(label)
	return separator

func _get_last_phase() -> String:
	if mission_entries.is_empty():
		return ""
	var last_hook = NarrativeManager.get_mission_hook(mission_entries[-1])
	return last_hook.get("phase", "")
