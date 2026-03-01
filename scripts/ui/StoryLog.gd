extends ScrollContainer
## Story Log / Journal
## Renders chronological narrative scenes (beats, intermissions, endings) from GameState.story_log

var log_container: VBoxContainer

func _ready() -> void:
	_build_ui()
	_refresh()
	if not NarrativeManager.scene_triggered.is_connected(_on_scene_triggered):
		NarrativeManager.scene_triggered.connect(_on_scene_triggered)

func _build_ui() -> void:
	log_container = VBoxContainer.new()
	log_container.add_theme_constant_override("separation", UITheme.PAD_SM)
	log_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	log_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(log_container)

func _on_scene_triggered(_scene_id: String, _payload: Dictionary) -> void:
	_refresh()

func _refresh() -> void:
	for child in log_container.get_children():
		child.queue_free()

	if GameState.story_log.is_empty():
		var none := Label.new()
		none.text = "No story events logged yet."
		UITheme.style_body(none, UITheme.FONT_BODY, true)
		log_container.add_child(none)
		return

	for entry in GameState.story_log:
		_add_entry(entry)

func _add_entry(entry: Dictionary) -> void:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", UITheme.make_panel_style())

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 2)

	var title := Label.new()
	title.text = "[%s] %s" % [entry.get("type", "scene"), entry.get("title", "Untitled Scene")]
	UITheme.style_header(title, UITheme.FONT_SECONDARY, true)
	vbox.add_child(title)

	var text := Label.new()
	text.text = entry.get("text", "")
	UITheme.style_body(text, UITheme.FONT_FINE, true)
	text.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_WORD
	vbox.add_child(text)

	var meta := Label.new()
	var tags: Array[String] = entry.get("tags", []) as Array
	var phase: String = str(entry.get("phase", ""))
	var stamp: int = int(entry.get("timestamp", 0))
	var meta_parts := []
	if phase != "":
		meta_parts.append("Phase: %s" % phase)
	if not tags.is_empty():
		meta_parts.append("Tags: " + ", ".join(tags))
	if stamp != 0:
		meta_parts.append("t=%d" % stamp)
	meta.text = "  ".join(meta_parts)
	UITheme.style_body(meta, UITheme.FONT_FINE, true)
	if not meta.text.is_empty():
		vbox.add_child(meta)

	panel.add_child(vbox)
	log_container.add_child(panel)
