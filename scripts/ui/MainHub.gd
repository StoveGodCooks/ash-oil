extends Control
## Main hub shell (Batch 2): frame, bars, meters, navigation, and content host.


class SectionDivider extends Control:
	var tint: Color = UITheme.CLR_BRONZE

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		UITheme.draw_section_divider(self, size.y * 0.5, size.x, tint)


class NavOrnament extends Control:
	var tint: Color = UITheme.CLR_BRONZE

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		var center := Vector2(size.x * 0.5, size.y * 0.5)
		var half: float = minf(size.x, size.y) * 0.28
		draw_line(center + Vector2(-half, -half), center + Vector2(half, half), tint, 1.5)
		draw_line(center + Vector2(half, -half), center + Vector2(-half, half), tint, 1.5)


const TAB_DEFS: Array[Dictionary] = [
	{"id": "missions", "roman": "I", "label": "MISSIONS", "kind": "context"},
	{"id": "map", "roman": "II", "label": "MAP", "kind": "context"},
	{"id": "squad", "roman": "III", "label": "SQUAD", "kind": "context"},
	{"id": "loadout", "roman": "IV", "label": "LOADOUT", "kind": "context"},
	{"id": "shop", "roman": "V", "label": "SHOP", "kind": "scene", "scene": "res://scenes/ShopUI.tscn"},
	{"id": "intel", "roman": "VI", "label": "INTEL", "kind": "context"},
	{"id": "log", "roman": "VII", "label": "LOG", "kind": "context"},
	{"id": "deck", "roman": "VIII", "label": "DECK", "kind": "scene", "scene": "res://scenes/DeckBuilder.tscn"},
]

const TAB_HINTS: Dictionary = {
	"missions": "SELECT A MISSION CONTRACT",
	"map": "REVIEW ROUTES AND REGIONS",
	"squad": "MANAGE ACTIVE LIEUTENANTS",
	"loadout": "ADJUST CASSIAN'S GEAR",
	"shop": "VISIT THE MARKET",
	"intel": "REVIEW FACTIONS AND RELATIONSHIPS",
	"log": "READ THE CAMPAIGN RECORD",
	"deck": "EDIT YOUR DECK",
}

const METER_DEFS: Array[Dictionary] = [
	{"abbr": "REP", "name": "REPUTATION", "legacy": "RENOWN"},
	{"abbr": "DNG", "name": "DANGER", "legacy": "HEAT"},
	{"abbr": "FTH", "name": "FAITH", "legacy": "PIETY"},
	{"abbr": "ALY", "name": "ALLIES", "legacy": "FAVOR"},
	{"abbr": "CST", "name": "COST", "legacy": "DEBT"},
	{"abbr": "RES", "name": "RESISTANCE", "legacy": "DREAD"},
]

var top_bar: PanelContainer
var meters_strip: PanelContainer
var main_row: HBoxContainer
var left_nav: PanelContainer
var content_panel: PanelContainer
var bottom_bar: PanelContainer

var top_bar_phase_label: Label
var top_bar_masthead_label: Label
var top_gold_value_label: Label
var top_deck_value_label: Label
var top_completed_value_label: Label

var meter_bars: Dictionary = {}
var meter_tooltip_nodes: Dictionary = {}

var nav_buttons: Array[Button] = []
var nav_accent_by_index: Dictionary = {}
var nav_roman_by_index: Dictionary = {}
var nav_name_by_index: Dictionary = {}
var save_button: Button

var content_header_tab_label: Label
var content_header_context_label: Label
var content_placeholder_title: Label
var content_placeholder_body: Label

var bottom_hint_label: Label
var bottom_shortcut_label: Label
var bottom_status_label: Label

var selected_tab_index := 0
var _runtime_hash := ""


func _ready() -> void:
	_build_ui()
	_connect_runtime_signals()
	_refresh_runtime_values()
	_set_active_tab(0, false)
	call_deferred("_grab_selected_tab_focus")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		_select_relative_tab(-1)
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_right"):
		_select_relative_tab(1)
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_accept"):
		_execute_tab_action(selected_tab_index)
		get_viewport().set_input_as_handled()


func _process(_delta: float) -> void:
	_refresh_runtime_values()


func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.color = UITheme.CLR_VOID
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	var root := VBoxContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("separation", 0)
	add_child(root)

	top_bar = PanelContainer.new()
	top_bar.custom_minimum_size = Vector2(0, 56)
	top_bar.add_theme_stylebox_override("panel", _frame_style(UITheme.CLR_VOID, UITheme.CLR_GOLD, 0, 0, 0, 2))
	root.add_child(top_bar)

	meters_strip = PanelContainer.new()
	meters_strip.custom_minimum_size = Vector2(0, 32)
	meters_strip.add_theme_stylebox_override("panel", _frame_style(UITheme.CLR_STONE, UITheme.CLR_BRONZE, 0, 0, 0, 1))
	root.add_child(meters_strip)

	main_row = HBoxContainer.new()
	main_row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_row.add_theme_constant_override("separation", 0)
	root.add_child(main_row)

	left_nav = PanelContainer.new()
	left_nav.custom_minimum_size = Vector2(220, 0)
	left_nav.add_theme_stylebox_override("panel", _frame_style(UITheme.CLR_STONE, UITheme.CLR_BRONZE, 0, 0, 1, 0))
	main_row.add_child(left_nav)

	content_panel = PanelContainer.new()
	content_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_panel.add_theme_stylebox_override("panel", _frame_style(UITheme.CLR_STONE_MID, UITheme.CLR_BRONZE, 1, 0, 0, 0))
	main_row.add_child(content_panel)

	bottom_bar = PanelContainer.new()
	bottom_bar.custom_minimum_size = Vector2(0, 36)
	bottom_bar.add_theme_stylebox_override("panel", _frame_style(UITheme.CLR_VOID, UITheme.CLR_BRONZE, 0, 1, 0, 0))
	root.add_child(bottom_bar)

	_build_top_bar()
	_build_meters_strip()
	_build_left_nav()
	_build_content_panel()
	_build_bottom_bar()


func _build_top_bar() -> void:
	var pad := MarginContainer.new()
	pad.size_flags_vertical = Control.SIZE_EXPAND_FILL
	pad.add_theme_constant_override("margin_left", 12)
	pad.add_theme_constant_override("margin_right", 12)
	top_bar.add_child(pad)

	var row := HBoxContainer.new()
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 0)
	pad.add_child(row)

	var left_col := VBoxContainer.new()
	left_col.custom_minimum_size = Vector2(200, 0)
	left_col.size_flags_vertical = Control.SIZE_EXPAND_FILL
	left_col.alignment = BoxContainer.ALIGNMENT_CENTER
	left_col.add_theme_constant_override("separation", 2)
	row.add_child(left_col)

	var cassian := Label.new()
	cassian.text = "CASSIAN"
	cassian.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_HEADER)
	cassian.add_theme_color_override("font_color", UITheme.CLR_GOLD)
	left_col.add_child(cassian)

	top_bar_phase_label = Label.new()
	top_bar_phase_label.text = "PHASE I - SURVIVAL"
	top_bar_phase_label.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
	top_bar_phase_label.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	left_col.add_child(top_bar_phase_label)

	var center_col := VBoxContainer.new()
	center_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center_col.size_flags_vertical = Control.SIZE_EXPAND_FILL
	center_col.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_child(center_col)

	top_bar_masthead_label = Label.new()
	top_bar_masthead_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	top_bar_masthead_label.text = "── ✦  ASH AND OIL  ✦ ──"
	top_bar_masthead_label.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	top_bar_masthead_label.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	center_col.add_child(top_bar_masthead_label)

	var right_col := HBoxContainer.new()
	right_col.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_col.alignment = BoxContainer.ALIGNMENT_CENTER
	right_col.add_theme_constant_override("separation", 16)
	row.add_child(right_col)

	top_gold_value_label = _make_top_stat(right_col, "⚖", UITheme.CLR_GOLD)
	top_deck_value_label = _make_top_stat(right_col, "⚔", UITheme.CLR_VELLUM)
	top_completed_value_label = _make_top_stat(right_col, "✓", UITheme.CLR_VELLUM)

	if OS.is_debug_build():
		var dev_btn := Button.new()
		dev_btn.text = "DEV"
		dev_btn.custom_minimum_size = Vector2(56, 28)
		dev_btn.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
		dev_btn.add_theme_stylebox_override("normal", UITheme.btn_secondary())
		dev_btn.add_theme_stylebox_override("hover", UITheme.btn_secondary_hover())
		dev_btn.add_theme_stylebox_override("pressed", UITheme.btn_active())
		dev_btn.pressed.connect(_on_dev_pressed)
		right_col.add_child(dev_btn)


func _build_meters_strip() -> void:
	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 0)
	meters_strip.add_child(row)

	for meter_def in METER_DEFS:
		var cell_pad := MarginContainer.new()
		cell_pad.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		cell_pad.add_theme_constant_override("margin_left", 6)
		cell_pad.add_theme_constant_override("margin_right", 6)
		row.add_child(cell_pad)

		var cell := HBoxContainer.new()
		cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		cell.size_flags_vertical = Control.SIZE_EXPAND_FILL
		cell.alignment = BoxContainer.ALIGNMENT_CENTER
		cell.add_theme_constant_override("separation", 6)
		cell_pad.add_child(cell)

		var abbr := Label.new()
		abbr.text = str(meter_def["abbr"])
		abbr.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
		abbr.add_theme_color_override("font_color", UITheme.CLR_MUTED)
		cell.add_child(abbr)

		var bar := ProgressBar.new()
		bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		bar.custom_minimum_size = Vector2(0, 8)
		bar.show_percentage = false
		bar.min_value = 0
		bar.max_value = 100
		bar.add_theme_stylebox_override("background", UITheme.panel_inset())
		bar.add_theme_stylebox_override("fill", _meter_fill_style(str(meter_def["name"])))
		cell.add_child(bar)

		var meter_name := str(meter_def["name"])
		meter_bars[meter_name] = bar
		meter_tooltip_nodes[meter_name] = bar

		if meter_def != METER_DEFS[METER_DEFS.size() - 1]:
			var sep := ColorRect.new()
			sep.custom_minimum_size = Vector2(1, 32)
			sep.color = UITheme.CLR_BRONZE
			row.add_child(sep)


func _build_left_nav() -> void:
	var col := VBoxContainer.new()
	col.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 0)
	left_nav.add_child(col)

	var top_decoration := NavOrnament.new()
	top_decoration.custom_minimum_size = Vector2(0, 40)
	col.add_child(top_decoration)

	var top_sep := ColorRect.new()
	top_sep.custom_minimum_size = Vector2(0, 1)
	top_sep.color = UITheme.CLR_BRONZE
	col.add_child(top_sep)

	for i in range(TAB_DEFS.size()):
		var tab_def: Dictionary = TAB_DEFS[i]
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(0, 52)
		btn.focus_mode = Control.FOCUS_ALL
		btn.text = ""
		btn.pressed.connect(_on_tab_pressed.bind(i))
		btn.mouse_entered.connect(_update_nav_states)
		btn.mouse_exited.connect(_update_nav_states)
		btn.focus_entered.connect(_update_nav_states)
		btn.focus_exited.connect(_update_nav_states)
		col.add_child(btn)
		nav_buttons.append(btn)

		var row_pad := MarginContainer.new()
		row_pad.set_anchors_preset(Control.PRESET_FULL_RECT)
		row_pad.add_theme_constant_override("margin_left", 8)
		row_pad.add_theme_constant_override("margin_right", 8)
		btn.add_child(row_pad)

		var row := HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.size_flags_vertical = Control.SIZE_EXPAND_FILL
		row.alignment = BoxContainer.ALIGNMENT_CENTER
		row.add_theme_constant_override("separation", 6)
		row_pad.add_child(row)

		var accent := ColorRect.new()
		accent.custom_minimum_size = Vector2(3, 0)
		accent.size_flags_vertical = Control.SIZE_EXPAND_FILL
		accent.color = UITheme.CLR_GOLD
		row.add_child(accent)
		nav_accent_by_index[i] = accent

		var labels := HBoxContainer.new()
		labels.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		labels.add_theme_constant_override("separation", 6)
		row.add_child(labels)

		var roman := Label.new()
		roman.text = "%s." % str(tab_def["roman"])
		roman.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
		roman.add_theme_color_override("font_color", UITheme.CLR_MUTED)
		labels.add_child(roman)
		nav_roman_by_index[i] = roman

		var name := Label.new()
		name.text = _tracked_caps(str(tab_def["label"]))
		name.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_BODY)
		name.add_theme_color_override("font_color", UITheme.CLR_PARCHMENT)
		labels.add_child(name)
		nav_name_by_index[i] = name

		if i < TAB_DEFS.size() - 1:
			var sep := ColorRect.new()
			sep.custom_minimum_size = Vector2(0, 1)
			sep.color = UITheme.CLR_BRONZE
			col.add_child(sep)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_child(spacer)

	var bottom_sep := ColorRect.new()
	bottom_sep.custom_minimum_size = Vector2(0, 1)
	bottom_sep.color = UITheme.CLR_BRONZE
	col.add_child(bottom_sep)

	save_button = Button.new()
	save_button.text = "SAVE"
	save_button.custom_minimum_size = Vector2(0, 44)
	save_button.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_BODY)
	save_button.add_theme_stylebox_override("normal", _save_button_style(false))
	save_button.add_theme_stylebox_override("hover", _save_button_style(true))
	save_button.add_theme_stylebox_override("pressed", UITheme.btn_active())
	save_button.pressed.connect(_on_save_pressed)
	col.add_child(save_button)

	var version := Label.new()
	version.text = "v0.4 - Phase 4"
	version.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	version.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
	version.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	col.add_child(version)


func _build_content_panel() -> void:
	var wrap := MarginContainer.new()
	wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	wrap.size_flags_vertical = Control.SIZE_EXPAND_FILL
	wrap.add_theme_constant_override("margin_left", 20)
	wrap.add_theme_constant_override("margin_right", 20)
	wrap.add_theme_constant_override("margin_top", 20)
	wrap.add_theme_constant_override("margin_bottom", 20)
	content_panel.add_child(wrap)

	var col := VBoxContainer.new()
	col.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 0)
	wrap.add_child(col)

	var header := HBoxContainer.new()
	header.custom_minimum_size = Vector2(0, 20)
	col.add_child(header)

	content_header_tab_label = Label.new()
	content_header_tab_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_header_tab_label.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_TITLE)
	content_header_tab_label.add_theme_color_override("font_color", UITheme.CLR_GOLD)
	content_header_tab_label.text = "MISSIONS"
	header.add_child(content_header_tab_label)

	content_header_context_label = Label.new()
	content_header_context_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	content_header_context_label.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_BODY)
	content_header_context_label.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	content_header_context_label.text = ""
	header.add_child(content_header_context_label)

	var header_gap := Control.new()
	header_gap.custom_minimum_size = Vector2(0, 8)
	col.add_child(header_gap)

	var divider := SectionDivider.new()
	divider.custom_minimum_size = Vector2(0, 16)
	col.add_child(divider)

	var body_gap := Control.new()
	body_gap.custom_minimum_size = Vector2(0, 12)
	col.add_child(body_gap)

	var body_center := CenterContainer.new()
	body_center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_child(body_center)

	var body_col := VBoxContainer.new()
	body_col.alignment = BoxContainer.ALIGNMENT_CENTER
	body_col.custom_minimum_size = Vector2(320, 0)
	body_col.add_theme_constant_override("separation", 12)
	body_center.add_child(body_col)

	content_placeholder_title = Label.new()
	content_placeholder_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content_placeholder_title.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_TITLE)
	content_placeholder_title.add_theme_color_override("font_color", UITheme.CLR_GOLD)
	content_placeholder_title.text = "MISSIONS"
	body_col.add_child(content_placeholder_title)

	var body_divider := SectionDivider.new()
	body_divider.custom_minimum_size = Vector2(320, 16)
	body_col.add_child(body_divider)

	content_placeholder_body = Label.new()
	content_placeholder_body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content_placeholder_body.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_BODY)
	content_placeholder_body.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	content_placeholder_body.text = "Content loading..."
	body_col.add_child(content_placeholder_body)


func _build_bottom_bar() -> void:
	var row := HBoxContainer.new()
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 12)
	bottom_bar.add_child(row)

	bottom_hint_label = Label.new()
	bottom_hint_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bottom_hint_label.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	bottom_hint_label.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	bottom_hint_label.text = "SELECT A TAB TO BEGIN"
	row.add_child(bottom_hint_label)

	bottom_status_label = Label.new()
	bottom_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	bottom_status_label.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	bottom_status_label.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	row.add_child(bottom_status_label)

	bottom_shortcut_label = Label.new()
	bottom_shortcut_label.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
	bottom_shortcut_label.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	bottom_shortcut_label.text = "TAB: NAVIGATE    ENTER: SELECT    ESC: BACK"
	row.add_child(bottom_shortcut_label)


func _set_active_tab(index: int, run_action: bool) -> void:
	if index < 0 or index >= TAB_DEFS.size():
		return
	selected_tab_index = index
	var tab_def: Dictionary = TAB_DEFS[index]
	var tab_label := str(tab_def["label"])
	content_header_tab_label.text = tab_label
	content_placeholder_title.text = tab_label
	bottom_hint_label.text = str(TAB_HINTS.get(str(tab_def["id"]), "SELECT A TAB TO BEGIN"))
	_update_nav_states()
	if run_action:
		_execute_tab_action(index)


func _select_relative_tab(delta: int) -> void:
	if nav_buttons.is_empty():
		return
	var next := wrapi(selected_tab_index + delta, 0, nav_buttons.size())
	_set_active_tab(next, false)
	_grab_selected_tab_focus()


func _grab_selected_tab_focus() -> void:
	if selected_tab_index >= 0 and selected_tab_index < nav_buttons.size():
		nav_buttons[selected_tab_index].grab_focus()


func _on_tab_pressed(index: int) -> void:
	_set_active_tab(index, false)
	_execute_tab_action(index)


func _execute_tab_action(index: int) -> void:
	if index < 0 or index >= TAB_DEFS.size():
		return
	var tab_def: Dictionary = TAB_DEFS[index]
	var kind := str(tab_def.get("kind", "context"))
	match kind:
		"context":
			bottom_status_label.text = "TAB READY: %s" % str(tab_def["label"])
		"scene":
			_transition_to_scene(str(tab_def.get("scene", "")))
		_:
			pass


func _transition_to_scene(scene_path: String) -> void:
	if scene_path == "":
		return
	get_tree().change_scene_to_file(scene_path)


func _on_save_pressed() -> void:
	SaveManager.save_game(0)
	bottom_status_label.text = "Progress saved to slot 0."


func _on_dev_pressed() -> void:
	_transition_to_scene("res://scenes/DevMenu.tscn")


func _connect_runtime_signals() -> void:
	if not GameState.meter_changed.is_connected(_on_game_state_changed):
		GameState.meter_changed.connect(_on_game_state_changed)
	if not GameState.mission_completed.is_connected(_on_game_state_changed_any):
		GameState.mission_completed.connect(_on_game_state_changed_any)
	if not GameState.game_loaded.is_connected(_on_game_loaded):
		GameState.game_loaded.connect(_on_game_loaded)


func _on_game_state_changed(_meter_name: String, _new_value: int) -> void:
	_refresh_runtime_values()


func _on_game_state_changed_any(_value: String) -> void:
	_refresh_runtime_values()


func _on_game_loaded() -> void:
	_refresh_runtime_values()


func _refresh_runtime_values() -> void:
	var snapshot := "%s|%d|%d|%d|%d|%d|%d|%d|%d" % [
		str(GameState.story_phase),
		int(GameState.gold),
		GameState.current_deck.size(),
		GameState.completed_missions.size(),
		int(GameState.RENOWN),
		int(GameState.HEAT),
		int(GameState.PIETY),
		int(GameState.FAVOR),
		int(GameState.DREAD),
	]
	if snapshot == _runtime_hash:
		return
	_runtime_hash = snapshot

	if top_bar_phase_label != null:
		top_bar_phase_label.text = _story_phase_label()
	if top_gold_value_label != null:
		top_gold_value_label.text = str(GameState.gold)
	if top_deck_value_label != null:
		top_deck_value_label.text = str(GameState.current_deck.size())
	if top_completed_value_label != null:
		top_completed_value_label.text = str(GameState.completed_missions.size())

	for meter_def in METER_DEFS:
		var meter_name := str(meter_def["name"])
		var legacy := str(meter_def["legacy"])
		var value := float(GameState.get_meter(legacy))
		var bar := meter_bars.get(meter_name, null) as ProgressBar
		if bar == null:
			continue
		bar.max_value = _meter_max_value(legacy, value)
		bar.value = minf(value, bar.max_value)
		bar.tooltip_text = "%s: %d" % [meter_name, int(value)]


func _meter_max_value(legacy_meter_name: String, current_value: float) -> float:
	match legacy_meter_name:
		"RENOWN":
			return 20.0
		"HEAT":
			return 15.0
		"PIETY":
			return 10.0
		"FAVOR":
			return 10.0
		"DREAD":
			return 10.0
		"DEBT":
			return maxf(30.0, current_value)
		_:
			return maxf(20.0, current_value)


func _story_phase_label() -> String:
	var phase := str(GameState.story_phase).strip_edges().to_upper()
	match phase:
		"SURVIVAL":
			return "PHASE I — SURVIVAL"
		"HOPE":
			return "PHASE II — HOPE"
		"RESISTANCE":
			return "PHASE III — RESISTANCE"
		_:
			return "PHASE — %s" % phase


func _update_nav_states() -> void:
	for i in range(nav_buttons.size()):
		var btn := nav_buttons[i]
		var accent := nav_accent_by_index.get(i, null) as ColorRect
		var roman := nav_roman_by_index.get(i, null) as Label
		var name := nav_name_by_index.get(i, null) as Label
		var is_active := i == selected_tab_index
		var is_hover := btn.is_hovered() or btn.has_focus()
		if is_active:
			btn.add_theme_stylebox_override("normal", UITheme.btn_active())
			btn.add_theme_stylebox_override("hover", UITheme.btn_active())
			btn.add_theme_stylebox_override("pressed", UITheme.btn_active())
			if accent != null:
				accent.color = UITheme.CLR_GOLD
				accent.self_modulate.a = 1.0
			if roman != null:
				roman.add_theme_color_override("font_color", UITheme.CLR_GOLD)
			if name != null:
				name.add_theme_color_override("font_color", UITheme.CLR_GOLD)
				name.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_SUBHEAD)
		elif is_hover:
			btn.add_theme_stylebox_override("normal", UITheme.btn_secondary_hover())
			btn.add_theme_stylebox_override("hover", UITheme.btn_secondary_hover())
			btn.add_theme_stylebox_override("pressed", UITheme.btn_active())
			if accent != null:
				accent.color = UITheme.CLR_BRONZE
				accent.self_modulate.a = 1.0
			if roman != null:
				roman.add_theme_color_override("font_color", UITheme.CLR_PARCHMENT)
			if name != null:
				name.add_theme_color_override("font_color", UITheme.CLR_VELLUM)
				name.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_BODY)
		else:
			btn.add_theme_stylebox_override("normal", _transparent_button_style())
			btn.add_theme_stylebox_override("hover", UITheme.btn_secondary_hover())
			btn.add_theme_stylebox_override("pressed", UITheme.btn_active())
			if accent != null:
				accent.self_modulate.a = 0.0
			if roman != null:
				roman.add_theme_color_override("font_color", UITheme.CLR_MUTED)
			if name != null:
				name.add_theme_color_override("font_color", UITheme.CLR_PARCHMENT)
				name.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_BODY)


func _make_top_stat(parent: Node, icon_text: String, value_color: Color) -> Label:
	var col := VBoxContainer.new()
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_theme_constant_override("separation", 0)
	parent.add_child(col)

	var icon := Label.new()
	icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	icon.text = icon_text
	icon.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
	icon.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	col.add_child(icon)

	var value := Label.new()
	value.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value.text = "0"
	value.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_BODY)
	value.add_theme_color_override("font_color", value_color)
	col.add_child(value)

	return value


func _meter_fill_style(meter_name: String) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = UITheme.get_meter_color(meter_name)
	style.corner_radius_top_left = 2
	style.corner_radius_top_right = 2
	style.corner_radius_bottom_left = 2
	style.corner_radius_bottom_right = 2
	return style


func _frame_style(
		bg_color: Color,
		border_color: Color,
		border_left: int = 0,
		border_top: int = 0,
		border_right: int = 0,
		border_bottom: int = 0
	) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.border_width_left = border_left
	style.border_width_top = border_top
	style.border_width_right = border_right
	style.border_width_bottom = border_bottom
	return style


func _transparent_button_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = UITheme.CLR_VOID
	style.bg_color.a = 0.0
	style.border_color = UITheme.CLR_VOID
	style.border_color.a = 0.0
	return style


func _save_button_style(hovered: bool) -> StyleBoxFlat:
	var style := UITheme.btn_secondary_hover() if hovered else UITheme.btn_secondary()
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	return style


func _tracked_caps(text: String) -> String:
	return " ".join(text.to_upper().split(""))
