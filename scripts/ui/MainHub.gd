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


class WaxSealControl extends Control:
	var seal_color: Color = UITheme.CLR_GOLD

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		UITheme.draw_wax_seal(self, size * 0.5, seal_color, 6.0)


# Professional showcase components
class HeroCard extends PanelContainer:
	var character_name: Label
	var level_badge: Label
	var hp_bar: ProgressBar
	var phase_label: Label
	var loyalty_list: VBoxContainer

	func _init() -> void:
		custom_minimum_size = Vector2(220, 0)
		size_flags_vertical = Control.SIZE_EXPAND_FILL
		add_theme_stylebox_override("panel", UITheme.panel_glass())
		mouse_filter = Control.MOUSE_FILTER_STOP

	func _ready() -> void:
		var margin := MarginContainer.new()
		margin.add_theme_constant_override("margin_left", 12)
		margin.add_theme_constant_override("margin_right", 12)
		margin.add_theme_constant_override("margin_top", 12)
		margin.add_theme_constant_override("margin_bottom", 12)
		add_child(margin)

		var col := VBoxContainer.new()
		col.add_theme_constant_override("separation", 8)
		margin.add_child(col)

		character_name = Label.new()
		character_name.text = "CASSIAN"
		character_name.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_HEADER)
		character_name.add_theme_color_override("font_color", UITheme.CLR_GOLD)
		col.add_child(character_name)

		level_badge = Label.new()
		level_badge.text = "LVL 1"
		level_badge.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
		level_badge.add_theme_color_override("font_color", UITheme.CLR_GOLD)
		col.add_child(level_badge)

		hp_bar = ProgressBar.new()
		hp_bar.custom_minimum_size = Vector2(0, 20)
		hp_bar.min_value = 0
		hp_bar.max_value = 100
		hp_bar.show_percentage = false
		hp_bar.add_theme_stylebox_override("background", UITheme.panel_inset())
		col.add_child(hp_bar)

		phase_label = Label.new()
		phase_label.text = "PHASE 1: SURVIVAL"
		phase_label.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
		phase_label.add_theme_color_override("font_color", UITheme.CLR_MUTED)
		col.add_child(phase_label)

		# Divider
		var meter_divider := ColorRect.new()
		meter_divider.custom_minimum_size = Vector2(0, 1)
		meter_divider.color = Color(UITheme.CLR_GOLD.r, UITheme.CLR_GOLD.g, UITheme.CLR_GOLD.b, 0.40)
		col.add_child(meter_divider)

		# Narrative status header
		var status_header := Label.new()
		status_header.text = "NARRATIVE STATUS"
		status_header.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
		status_header.add_theme_color_override("font_color", UITheme.CLR_GOLD)
		col.add_child(status_header)

		# Compact meter indicators
		var meters_grid := GridContainer.new()
		meters_grid.columns = 2
		meters_grid.add_theme_constant_override("h_separation", 2)
		meters_grid.add_theme_constant_override("v_separation", 2)
		col.add_child(meters_grid)
		for i in range(6):
			var meter_cell := VBoxContainer.new()
			meter_cell.add_theme_constant_override("separation", 0)
			var meter_abbr := Label.new()
			meter_abbr.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
			meter_abbr.add_theme_color_override("font_color", UITheme.CLR_MUTED)
			meter_cell.add_child(meter_abbr)
			var meter_bar := ProgressBar.new()
			meter_bar.custom_minimum_size = Vector2(0, 4)
			meter_bar.show_percentage = false
			meter_bar.min_value = 0
			meter_bar.max_value = 100
			meter_bar.add_theme_stylebox_override("background", UITheme.panel_inset())
			meter_cell.add_child(meter_bar)
			meters_grid.add_child(meter_cell)

		# Second divider
		var ally_divider := ColorRect.new()
		ally_divider.custom_minimum_size = Vector2(0, 1)
		ally_divider.color = Color(UITheme.CLR_GOLD.r, UITheme.CLR_GOLD.g, UITheme.CLR_GOLD.b, 0.40)
		col.add_child(ally_divider)

		var loyalty_header := Label.new()
		loyalty_header.text = "ALLIES"
		loyalty_header.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
		loyalty_header.add_theme_color_override("font_color", UITheme.CLR_VELLUM)
		col.add_child(loyalty_header)

		loyalty_list = VBoxContainer.new()
		loyalty_list.add_theme_constant_override("separation", 4)
		col.add_child(loyalty_list)

		col.add_child(Control.new())

	func set_hero_data(cassian_hp: int, cassian_max_hp: int, phase: int, loyalty_data: Array) -> void:
		hp_bar.max_value = cassian_max_hp
		hp_bar.value = cassian_hp
		phase_label.text = "PHASE %d: %s" % [phase, ["SURVIVAL", "HOPE", "RESISTANCE"][phase - 1]]

		loyalty_list.queue_free_children()
		for loyalty_entry in loyalty_data.slice(0, 3):
			var entry_label := Label.new()
			entry_label.text = "%s %+d" % [loyalty_entry["name"], loyalty_entry["value"]]
			entry_label.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
			if loyalty_entry["value"] > 0:
				entry_label.add_theme_color_override("font_color", UITheme.CLR_VELLUM)
			else:
				entry_label.add_theme_color_override("font_color", Color.RED)
			loyalty_list.add_child(entry_label)


class PrimaryMissionCard extends PanelContainer:
	signal enter_mission_pressed
	signal briefing_pressed

	var mission_name: Label
	var mission_desc: Label
	var enemy_count_label: Label
	var reward_label: Label
	var enter_button: Button
	var briefing_button: Button

	func _init() -> void:
		size_flags_horizontal = Control.SIZE_EXPAND_FILL
		size_flags_vertical = Control.SIZE_EXPAND_FILL
		add_theme_stylebox_override("panel", UITheme.panel_glass_accent())
		mouse_filter = Control.MOUSE_FILTER_STOP

	func _ready() -> void:
		var margin := MarginContainer.new()
		margin.add_theme_constant_override("margin_left", 16)
		margin.add_theme_constant_override("margin_right", 16)
		margin.add_theme_constant_override("margin_top", 16)
		margin.add_theme_constant_override("margin_bottom", 16)
		add_child(margin)

		var col := VBoxContainer.new()
		col.add_theme_constant_override("separation", 12)
		margin.add_child(col)

		mission_name = Label.new()
		mission_name.text = "M01: THE TOKEN"
		mission_name.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_HEADER)
		mission_name.add_theme_color_override("font_color", UITheme.CLR_GOLD)
		col.add_child(mission_name)

		mission_desc = Label.new()
		mission_desc.text = "Prove yourself in the arena."
		mission_desc.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_BODY)
		mission_desc.add_theme_color_override("font_color", UITheme.CLR_VELLUM)
		mission_desc.autowrap_mode = TextServer.AUTOWRAP_WORD
		mission_desc.custom_minimum_size = Vector2(560, 0)
		col.add_child(mission_desc)

		var stats_row := HBoxContainer.new()
		stats_row.add_theme_constant_override("separation", 20)
		col.add_child(stats_row)

		enemy_count_label = Label.new()
		enemy_count_label.text = "ENEMIES: 3"
		enemy_count_label.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
		enemy_count_label.add_theme_color_override("font_color", UITheme.CLR_GOLD)
		stats_row.add_child(enemy_count_label)

		var difficulty_label := Label.new()
		difficulty_label.text = "DIFFICULTY: ★★★"
		difficulty_label.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
		difficulty_label.add_theme_color_override("font_color", UITheme.CLR_GOLD)
		stats_row.add_child(difficulty_label)

		reward_label = Label.new()
		reward_label.text = "REWARD: 85g + 2 RENOWN"
		reward_label.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
		reward_label.add_theme_color_override("font_color", UITheme.CLR_GOLD)
		stats_row.add_child(reward_label)

		col.add_child(Control.new())

		var button_row := HBoxContainer.new()
		button_row.add_theme_constant_override("separation", 12)
		col.add_child(button_row)

		enter_button = Button.new()
		enter_button.text = "ENTER ARENA"
		enter_button.custom_minimum_size = Vector2(0, 48)
		enter_button.add_theme_stylebox_override("normal", UITheme.btn_primary())
		enter_button.add_theme_stylebox_override("hover", UITheme.btn_primary_hover())
		enter_button.add_theme_stylebox_override("pressed", UITheme.btn_active())
		enter_button.pressed.connect(func(): enter_mission_pressed.emit())
		button_row.add_child(enter_button)

		briefing_button = Button.new()
		briefing_button.text = "BRIEFING"
		briefing_button.custom_minimum_size = Vector2(150, 48)
		briefing_button.add_theme_stylebox_override("normal", UITheme.btn_secondary())
		briefing_button.add_theme_stylebox_override("hover", UITheme.btn_secondary_hover())
		briefing_button.add_theme_stylebox_override("pressed", UITheme.btn_active())
		briefing_button.pressed.connect(func(): briefing_pressed.emit())
		button_row.add_child(briefing_button)

	func set_mission_data(mission_id: String, mission_title: String, desc: String, enemy_ct: int, reward: String) -> void:
		mission_name.text = "%s: %s" % [mission_id, mission_title]
		mission_desc.text = desc
		enemy_count_label.text = "ENEMIES: %d" % enemy_ct
		reward_label.text = reward


class AtmosphericBackground extends ColorRect:
	func _init() -> void:
		set_anchors_preset(Control.PRESET_FULL_RECT)
		color = UITheme.CLR_VOID
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		z_index = -1

	func _ready() -> void:
		var mat := ShaderMaterial.new()
		mat.shader = preload("res://ui/shaders/ui_parallax_atmosphere.gdshader")
		mat.set_shader_parameter("phase_color", _get_phase_color())
		mat.set_shader_parameter("intensity", 0.8)
		mat.set_shader_parameter("noise_strength", 0.2)
		material = mat

	func _get_phase_color() -> Vector3:
		var phase := GameState.story_phase
		match phase:
			1:
				return Vector3(0.2, 0.18, 0.15)
			2:
				return Vector3(0.35, 0.25, 0.15)
			3:
				return Vector3(0.4, 0.15, 0.15)
			_:
				return Vector3(0.2, 0.18, 0.15)


const TAB_DEFS: Array[Dictionary] = [
	{"id": "missions", "roman": "I", "label": "MISSIONS", "kind": "context"},
	{"id": "squad", "roman": "II", "label": "SQUAD", "kind": "context"},
	{"id": "loadout", "roman": "III", "label": "LOADOUT", "kind": "context"},
	{"id": "shop", "roman": "IV", "label": "SHOP", "kind": "scene", "scene": "res://scenes/ShopUI.tscn"},
	{"id": "intel", "roman": "V", "label": "INTEL", "kind": "context"},
	{"id": "log", "roman": "VI", "label": "LOG", "kind": "context"},
	{"id": "deck", "roman": "VII", "label": "DECK", "kind": "scene", "scene": "res://scenes/DeckBuilder.tscn"},
]

const TAB_HINTS: Dictionary = {
	"missions": "SELECT A MISSION CONTRACT",
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

const MISSION_BRIEFER_SCRIPT := preload("res://scripts/ui/MissionBriefer.gd")

var top_bar: PanelContainer
var meters_strip: PanelContainer
var main_row: HBoxContainer
var left_nav: PanelContainer
var content_panel: PanelContainer
var bottom_bar: PanelContainer
var mission_briefer: PanelContainer

var top_bar_phase_label: Label
var top_bar_masthead_label: Label
var top_gold_value_label: Label
var top_deck_value_label: Label
var top_completed_value_label: Label

var meter_bars: Dictionary = {}
var meter_tooltip_nodes: Dictionary = {}
var previous_meter_values: Dictionary = {}
var previous_gold_value: int = 0

var nav_buttons: Array[Button] = []
var nav_accent_by_index: Dictionary = {}
var nav_roman_by_index: Dictionary = {}
var nav_name_by_index: Dictionary = {}
var save_button: Button

var content_header_tab_label: Label
var content_header_context_label: Label
var content_placeholder_title: Label
var content_placeholder_body: Label
var content_scroll: ScrollContainer
var content_inner: VBoxContainer

var bottom_hint_label: Label
var bottom_shortcut_label: Label

var selected_tab_index := 0
var _runtime_hash := ""
var missions_view_mode := "list"  # "list" or "map"


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
	# Cinematic hub background — graceful fallback to void if image not yet imported
	var bg_tex: Texture2D = load("res://assets/backgrounds/hub_colosseum.png") if ResourceLoader.exists("res://assets/backgrounds/hub_colosseum.png") else null
	if bg_tex:
		var bg := TextureRect.new()
		bg.texture = bg_tex
		bg.stretch_mode = TextureRect.STRETCH_SCALE
		bg.set_anchors_preset(Control.PRESET_FULL_RECT)
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bg.z_index = -1
		add_child(bg)
	else:
		var bg := ColorRect.new()
		bg.color = UITheme.CLR_VOID
		bg.set_anchors_preset(Control.PRESET_FULL_RECT)
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bg.z_index = -1
		add_child(bg)

	# Subtle vignette — deepens corners and edges
	var vignette := ColorRect.new()
	vignette.color = Color(0, 0, 0, 0.32)
	vignette.set_anchors_preset(Control.PRESET_FULL_RECT)
	vignette.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vignette.z_index = 0
	add_child(vignette)

	var root := VBoxContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("separation", 0)
	add_child(root)

	# Top bar
	top_bar = PanelContainer.new()
	top_bar.custom_minimum_size = Vector2(0, 56)
	top_bar.add_theme_stylebox_override("panel", _frame_style(Color(0, 0, 0, 0.48), UITheme.CLR_GOLD, 0, 0, 0, 2))
	root.add_child(top_bar)
	_build_top_bar()

	# Meters strip
	meters_strip = PanelContainer.new()
	meters_strip.custom_minimum_size = Vector2(0, 32)
	meters_strip.add_theme_stylebox_override("panel", _frame_style(Color(0, 0, 0, 0.30), UITheme.CLR_BRONZE, 0, 0, 0, 1))
	root.add_child(meters_strip)
	_build_meters_strip()

	# Showcase section: Hero | Mission
	var showcase_section := HBoxContainer.new()
	showcase_section.add_theme_constant_override("separation", 12)
	showcase_section.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var showcase_pad := MarginContainer.new()
	showcase_pad.add_theme_constant_override("margin_left", 0)
	showcase_pad.add_theme_constant_override("margin_right", 0)
	showcase_pad.add_theme_constant_override("margin_top", 0)
	showcase_pad.add_theme_constant_override("margin_bottom", 0)
	showcase_pad.add_child(showcase_section)
	root.add_child(showcase_pad)

	# Hero card (placeholder, can populate later)
	var hero_card := HeroCard.new()
	showcase_section.add_child(hero_card)

	# Primary mission card (placeholder, can populate later)
	var primary_mission_card := PrimaryMissionCard.new()
	primary_mission_card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	showcase_section.add_child(primary_mission_card)

	# Narrative status now integrated into HeroCard (Cassian box)

	# Tab navigation + content (existing pattern)
	var tab_row := HBoxContainer.new()
	tab_row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tab_row.add_theme_constant_override("separation", 0)
	root.add_child(tab_row)

	left_nav = PanelContainer.new()
	left_nav.custom_minimum_size = Vector2(220, 0)
	left_nav.add_theme_stylebox_override("panel", _frame_style(Color(0, 0, 0, 0.0), UITheme.CLR_GOLD, 0, 0, 1, 0))
	tab_row.add_child(left_nav)
	_build_left_nav()

	content_panel = PanelContainer.new()
	content_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_panel.add_theme_stylebox_override("panel", _frame_style(Color(0, 0, 0, 0.22), UITheme.CLR_GOLD, 1, 0, 0, 0))
	tab_row.add_child(content_panel)
	_build_content_panel()

	# Bottom bar
	bottom_bar = PanelContainer.new()
	bottom_bar.custom_minimum_size = Vector2(0, 36)
	bottom_bar.add_theme_stylebox_override("panel", _frame_style(Color(0, 0, 0, 0.48), UITheme.CLR_BRONZE, 0, 1, 0, 0))
	root.add_child(bottom_bar)
	_build_bottom_bar()

	# Mission briefing overlay
	mission_briefer = MISSION_BRIEFER_SCRIPT.new()
	mission_briefer.set_anchors_preset(Control.PRESET_FULL_RECT)
	mission_briefer.z_index = 10
	add_child(mission_briefer)


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
	cassian.mouse_filter = Control.MOUSE_FILTER_STOP
	cassian.mouse_entered.connect(func() -> void:
		cassian.add_theme_constant_override("shadow_offset_x", 1)
		cassian.add_theme_constant_override("shadow_offset_y", 1)
		cassian.add_theme_color_override("font_shadow_color", Color(UITheme.CLR_GOLD.r, UITheme.CLR_GOLD.g, UITheme.CLR_GOLD.b, 0.3))
	)
	cassian.mouse_exited.connect(func() -> void:
		cassian.remove_theme_constant_override("shadow_offset_x")
		cassian.remove_theme_constant_override("shadow_offset_y")
		cassian.remove_theme_color_override("font_shadow_color")
	)
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
			sep.color = Color(UITheme.CLR_BRONZE.r, UITheme.CLR_BRONZE.g, UITheme.CLR_BRONZE.b, 0.45)
			row.add_child(sep)


func _build_left_nav() -> void:
	var col := VBoxContainer.new()
	col.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 0)
	left_nav.add_child(col)

	var top_sep := ColorRect.new()
	top_sep.custom_minimum_size = Vector2(0, 1)
	top_sep.color = Color(UITheme.CLR_BRONZE.r, UITheme.CLR_BRONZE.g, UITheme.CLR_BRONZE.b, 0.50)
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

		var tab_label := Label.new()
		tab_label.text = _tracked_caps(str(tab_def["label"]))
		tab_label.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_BODY)
		tab_label.add_theme_color_override("font_color", UITheme.CLR_PARCHMENT)
		labels.add_child(tab_label)
		nav_name_by_index[i] = tab_label

		if i < TAB_DEFS.size() - 1:
			var sep := ColorRect.new()
			sep.custom_minimum_size = Vector2(0, 1)
			sep.color = Color(UITheme.CLR_BRONZE.r, UITheme.CLR_BRONZE.g, UITheme.CLR_BRONZE.b, 0.40)
			col.add_child(sep)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_child(spacer)

	var bottom_sep := ColorRect.new()
	bottom_sep.custom_minimum_size = Vector2(0, 1)
	bottom_sep.color = Color(UITheme.CLR_BRONZE.r, UITheme.CLR_BRONZE.g, UITheme.CLR_BRONZE.b, 0.50)
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
	var margin_wrap := MarginContainer.new()
	margin_wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin_wrap.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin_wrap.add_theme_constant_override("margin_left", 20)
	margin_wrap.add_theme_constant_override("margin_right", 20)
	margin_wrap.add_theme_constant_override("margin_top", 20)
	margin_wrap.add_theme_constant_override("margin_bottom", 20)
	content_panel.add_child(margin_wrap)

	var col := VBoxContainer.new()
	col.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 0)
	margin_wrap.add_child(col)

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

	content_scroll = ScrollContainer.new()
	content_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	col.add_child(content_scroll)

	content_inner = VBoxContainer.new()
	content_inner.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_inner.add_theme_constant_override("separation", 8)
	content_scroll.add_child(content_inner)


func _build_bottom_bar() -> void:
	var pad := MarginContainer.new()
	pad.size_flags_vertical = Control.SIZE_EXPAND_FILL
	pad.add_theme_constant_override("margin_left", 16)
	pad.add_theme_constant_override("margin_right", 16)
	bottom_bar.add_child(pad)

	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 12)
	pad.add_child(row)

	bottom_hint_label = Label.new()
	bottom_hint_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bottom_hint_label.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	bottom_hint_label.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	bottom_hint_label.text = "SELECT A TAB TO BEGIN"
	row.add_child(bottom_hint_label)

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
	bottom_hint_label.text = str(TAB_HINTS.get(str(tab_def["id"]), "SELECT A TAB TO BEGIN"))
	_update_nav_states()
	var kind := str(tab_def.get("kind", "context"))
	if kind == "context":
		# Animate tab transition with slide effect
		var tab_id := str(tab_def["id"])
		_animate_tab_transition(tab_id)
	if run_action:
		_execute_tab_action(index)

func _animate_tab_transition(new_tab_id: String) -> void:
	# Fade out and slide out old content
	var fade_out_tween := create_tween()
	fade_out_tween.set_parallel(true)
	fade_out_tween.tween_property(content_scroll, "modulate:a", 0.0, 0.10).set_trans(Tween.TRANS_LINEAR)
	fade_out_tween.tween_property(content_scroll, "position:x", content_scroll.position.x + 12.0, 0.10)

	# Wait for fade out to complete, then populate new content
	await fade_out_tween.finished
	_populate_tab_content(new_tab_id)

	# Reset position for slide in animation
	content_scroll.position.x -= 12.0
	content_scroll.modulate.a = 0.0

	# Fade in and slide in new content
	var fade_in_tween := create_tween()
	fade_in_tween.set_parallel(true)
	fade_in_tween.tween_property(content_scroll, "modulate:a", 1.0, 0.18).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	fade_in_tween.tween_property(content_scroll, "position:x", content_scroll.position.x + 12.0, 0.18).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


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
			pass
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
	bottom_hint_label.text = "PROGRESS SAVED TO SLOT 0."


func _on_dev_pressed() -> void:
	_transition_to_scene("res://scenes/DevMenu.tscn")


func _connect_runtime_signals() -> void:
	if not GameState.meter_changed.is_connected(_on_game_state_changed):
		GameState.meter_changed.connect(_on_game_state_changed)
	if not GameState.mission_completed.is_connected(_on_game_state_changed_any):
		GameState.mission_completed.connect(_on_game_state_changed_any)
	if not GameState.game_loaded.is_connected(_on_game_loaded):
		GameState.game_loaded.connect(_on_game_loaded)
	if not NarrativeManager.scene_triggered.is_connected(_on_scene_triggered):
		NarrativeManager.scene_triggered.connect(_on_scene_triggered)


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
		int(GameState.renown),
		int(GameState.heat),
		int(GameState.piety),
		int(GameState.favor),
		int(GameState.dread),
	]
	if snapshot == _runtime_hash:
		return
	_runtime_hash = snapshot

	if top_bar_phase_label != null:
		top_bar_phase_label.text = _story_phase_label()
	if top_gold_value_label != null:
		var current_gold := int(GameState.gold)
		if current_gold != previous_gold_value:
			_animate_gold_change(top_gold_value_label, previous_gold_value, current_gold)
			previous_gold_value = current_gold
		else:
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
		var prev_value: float = previous_meter_values.get(meter_name, value)

		# Animate if meter changed
		if value != prev_value:
			_animate_meter_change(bar, prev_value, value, bar.max_value)
		else:
			bar.value = minf(value, bar.max_value)

		previous_meter_values[meter_name] = value
		bar.tooltip_text = "%s: %d" % [meter_name, int(value)]


func _animate_meter_change(bar: ProgressBar, _from_value: float, to_value: float, max_value: float) -> void:
	# Flash border with gold color
	var original_style := bar.get_theme_stylebox("background")
	var flash_style := UITheme.panel_inset()
	flash_style.border_color = UITheme.CLR_GOLD
	flash_style.border_width_left = 2
	flash_style.border_width_right = 2
	flash_style.border_width_top = 2
	flash_style.border_width_bottom = 2

	bar.add_theme_stylebox_override("background", flash_style)

	# Tween the value change over 400ms
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(bar, "value", minf(to_value, max_value), 0.4)

	# Flash the fill color
	var fill_style := bar.get_theme_stylebox("fill")
	if fill_style != null:
		var flash_fill_style := fill_style.duplicate() as StyleBoxFlat
		flash_fill_style.bg_color = UITheme.CLR_GOLD
		bar.add_theme_stylebox_override("fill", flash_fill_style)

		await get_tree().create_timer(0.15).timeout
		bar.add_theme_stylebox_override("fill", fill_style)

	# Restore original background style after flash
	await get_tree().create_timer(0.3).timeout
	bar.add_theme_stylebox_override("background", original_style)


func _animate_gold_change(label: Label, from_value: int, to_value: int) -> void:
	# Flash to bright white at start
	label.add_theme_color_override("font_color", Color.WHITE)
	label.text = str(from_value)

	# Numeric interpolation - interpolate displayed value over 400ms
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func() -> void:
		# Start animation
		var int_tween := create_tween()
		int_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		int_tween.tween_method(func(v: float) -> void:
			label.text = str(int(v))
		, from_value as float, to_value as float, 0.4)
	)

	# Restore color after animation
	await get_tree().create_timer(0.4).timeout
	label.add_theme_color_override("font_color", UITheme.CLR_GOLD)


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
		var tab_lbl := nav_name_by_index.get(i, null) as Label
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
			if tab_lbl != null:
				tab_lbl.add_theme_color_override("font_color", UITheme.CLR_GOLD)
				tab_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_SUBHEAD)
		elif is_hover:
			btn.add_theme_stylebox_override("normal", UITheme.btn_secondary_hover())
			btn.add_theme_stylebox_override("hover", UITheme.btn_secondary_hover())
			btn.add_theme_stylebox_override("pressed", UITheme.btn_active())
			if accent != null:
				accent.color = UITheme.CLR_BRONZE
				accent.self_modulate.a = 1.0
			if roman != null:
				roman.add_theme_color_override("font_color", UITheme.CLR_PARCHMENT)
			if tab_lbl != null:
				tab_lbl.add_theme_color_override("font_color", UITheme.CLR_VELLUM)
				tab_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_BODY)
		else:
			btn.add_theme_stylebox_override("normal", _transparent_button_style())
			btn.add_theme_stylebox_override("hover", UITheme.btn_secondary_hover())
			btn.add_theme_stylebox_override("pressed", UITheme.btn_active())
			if accent != null:
				accent.self_modulate.a = 0.0
			if roman != null:
				roman.add_theme_color_override("font_color", UITheme.CLR_MUTED)
			if tab_lbl != null:
				tab_lbl.add_theme_color_override("font_color", UITheme.CLR_PARCHMENT)
				tab_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_BODY)


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


# ══════════════════════════════════════════════════════════════════════════════
# BATCH 3 — TAB CONTENT BUILDERS
# ══════════════════════════════════════════════════════════════════════════════

func _populate_tab_content(tab_id: String) -> void:
	if content_inner == null:
		return
	for child in content_inner.get_children():
		child.queue_free()
	match tab_id:
		"missions": _build_missions_content()
		"squad":    _build_squad_content()
		"loadout":  _build_loadout_content()
		"intel":    _build_intel_content()
		"log":      _build_log_content()
		"deck":     _build_deck_content()
		_:
			var lbl := Label.new()
			lbl.text = "[ %s ]" % tab_id.to_upper()
			lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_HEADER)
			lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
			content_inner.add_child(lbl)


# ── Shared Helpers ────────────────────────────────────────────────────────────

func _gap(px: int) -> Control:
	var g := Control.new()
	g.custom_minimum_size = Vector2(0, px)
	g.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return g


func _divider_line(alpha: float = 1.0) -> ColorRect:
	var d := ColorRect.new()
	d.custom_minimum_size = Vector2(0, 1)
	d.color = UITheme.CLR_BRONZE
	d.color.a = alpha
	d.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return d


func _apply_button_press_bounce(btn: Button) -> void:
	btn.pressed.connect(func() -> void:
		var tween := create_tween()
		tween.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(btn, "scale", Vector2(0.95, 0.95), 0.1)
		tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.2)
	)


func _make_chip(text: String, bg: Color, fg: Color) -> Control:
	var chip := PanelContainer.new()
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = fg
	s.border_width_left = 1
	s.border_width_top = 1
	s.border_width_right = 1
	s.border_width_bottom = 1
	s.corner_radius_top_left = 2
	s.corner_radius_top_right = 2
	s.corner_radius_bottom_left = 2
	s.corner_radius_bottom_right = 2
	s.content_margin_left = 6
	s.content_margin_right = 6
	s.content_margin_top = 2
	s.content_margin_bottom = 2
	chip.add_theme_stylebox_override("panel", s)
	var lbl := Label.new()
	lbl.text = text
	lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
	lbl.add_theme_color_override("font_color", fg)
	chip.add_child(lbl)
	return chip


func _make_wax_seal(color: Color) -> Control:
	var seal := WaxSealControl.new()
	seal.seal_color = color
	seal.custom_minimum_size = Vector2(20, 20)
	return seal


# ── 3A  MISSIONS ─────────────────────────────────────────────────────────────

func _build_missions_content() -> void:
	# Add toggle buttons for LIST/MAP view
	var toggle_row := HBoxContainer.new()
	toggle_row.alignment = BoxContainer.ALIGNMENT_CENTER
	toggle_row.add_theme_constant_override("separation", 8)
	content_inner.add_child(toggle_row)

	var list_btn := Button.new()
	list_btn.text = "MISSIONS"
	list_btn.custom_minimum_size = Vector2(120, 40)
	list_btn.add_theme_stylebox_override("normal", UITheme.btn_secondary())
	list_btn.add_theme_stylebox_override("hover", UITheme.btn_secondary_hover())
	if missions_view_mode == "list":
		list_btn.add_theme_stylebox_override("normal", UITheme.btn_active())
	list_btn.pressed.connect(_on_missions_toggle_list)
	toggle_row.add_child(list_btn)

	var map_btn := Button.new()
	map_btn.text = "MAP"
	map_btn.custom_minimum_size = Vector2(120, 40)
	map_btn.add_theme_stylebox_override("normal", UITheme.btn_secondary())
	map_btn.add_theme_stylebox_override("hover", UITheme.btn_secondary_hover())
	if missions_view_mode == "map":
		map_btn.add_theme_stylebox_override("normal", UITheme.btn_active())
	map_btn.pressed.connect(_on_missions_toggle_map)
	toggle_row.add_child(map_btn)

	content_inner.add_child(_gap(12))

	# Build the appropriate content based on current view mode
	if missions_view_mode == "list":
		_build_missions_list()
	else:
		_build_missions_map()


func _build_missions_list() -> void:
	var all_ids := _all_mission_ids()
	if all_ids.is_empty():
		var lbl := Label.new()
		lbl.text = "No missions available."
		lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
		content_inner.add_child(lbl)
		return
	var available := MissionManager.get_available_missions()
	var active_id := str(available[0]) if not available.is_empty() else ""
	for mid in all_ids:
		var mdata := MissionManager.get_mission(str(mid))
		if mdata.is_empty():
			continue
		content_inner.add_child(_make_mission_card(mdata, str(mid), active_id))
		content_inner.add_child(_gap(6))


func _build_missions_map() -> void:
	# Placeholder for interactive mission map
	# In a future update, this will display:
	# - An image-based mission map node with clickable regions
	# - Each region links to a mission and displays briefing info
	# - An "ENTER BATTLE" button to start the mission
	var placeholder := Label.new()
	placeholder.text = "[MISSION MAP - Coming Soon]\n\nInteractive map with clickable mission locations.\nClick a region to select a mission and view details."
	placeholder.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	placeholder.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_BODY)
	placeholder.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	content_inner.add_child(placeholder)


func _on_missions_toggle_list() -> void:
	missions_view_mode = "list"
	_animate_tab_transition("missions")


func _on_missions_toggle_map() -> void:
	missions_view_mode = "map"
	_animate_tab_transition("missions")


func _all_mission_ids() -> Array:
	var ids: Array = []
	for mid in GameState.completed_missions:
		if not ids.has(str(mid)):
			ids.append(str(mid))
	for mid in GameState.unlocked_missions:
		if not ids.has(str(mid)):
			ids.append(str(mid))
	ids.sort()
	return ids


func _make_mission_card(data: Dictionary, mid: String, active_id: String) -> Control:
	var is_completed := GameState.completed_missions.has(mid)
	var is_locked    := not MissionManager.is_mission_available(mid) and not is_completed
	var is_active    := (mid == active_id) and not is_completed and not is_locked

	# Outer wrapper holds optional gold-bar for ACTIVE state
	var wrapper := HBoxContainer.new()
	wrapper.add_theme_constant_override("separation", 0)

	if is_active:
		var accent := ColorRect.new()
		accent.custom_minimum_size = Vector2(3, 0)
		accent.size_flags_vertical = Control.SIZE_EXPAND_FILL
		accent.color = UITheme.CLR_GOLD
		wrapper.add_child(accent)

	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var card_style := UITheme.panel_raised()
	if is_completed or is_locked:
		card_style.border_color = UITheme.CLR_BRONZE
	card.add_theme_stylebox_override("panel", card_style)
	if is_completed:
		card.modulate = Color(UITheme.CLR_ASH.r + 0.15, UITheme.CLR_ASH.g + 0.10, UITheme.CLR_ASH.b + 0.08, 1.0)
	elif is_locked:
		card.modulate.a = 0.6
	wrapper.add_child(card)

	var inner := VBoxContainer.new()
	inner.add_theme_constant_override("separation", 6)
	card.add_child(inner)

	# Top row: ID · Name · Act/Type  (+ checkmark if completed)
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 6)
	inner.add_child(top)

	var id_lbl := Label.new()
	id_lbl.text = mid
	id_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	id_lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	top.add_child(id_lbl)

	var dot := Label.new()
	dot.text = " · "
	dot.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	dot.add_theme_color_override("font_color", UITheme.CLR_BRONZE)
	top.add_child(dot)

	var name_lbl := Label.new()
	name_lbl.text = str(data.get("name", "UNKNOWN")).to_upper()
	name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_SUBHEAD)
	name_lbl.add_theme_color_override("font_color", UITheme.CLR_GOLD)
	top.add_child(name_lbl)

	if is_completed:
		var check := Label.new()
		check.text = "✓"
		check.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_HEADER)
		check.add_theme_color_override("font_color", UITheme.CLR_BRONZE)
		top.add_child(check)

	var act_str := "ACT %s · %s" % [UITheme.roman_numeral(int(data.get("act", 1))), str(data.get("type", "MISSION")).to_upper()]
	var act_lbl := Label.new()
	act_lbl.text = act_str
	act_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	act_lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	top.add_child(act_lbl)

	# Divider
	inner.add_child(_divider_line(0.5))

	# Description
	var desc := Label.new()
	desc.text = str(data.get("description", ""))
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD
	desc.max_lines_visible = 2
	desc.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_BODY)
	desc.add_theme_color_override("font_color", UITheme.CLR_PARCHMENT)
	inner.add_child(desc)

	# Stats row
	var stats := HBoxContainer.new()
	stats.add_theme_constant_override("separation", 12)
	inner.add_child(stats)

	var enemies_arr := data.get("enemies", []) as Array
	var e_lbl := Label.new()
	e_lbl.text = "⚔ Enemies: %d" % enemies_arr.size()
	e_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	e_lbl.add_theme_color_override("font_color", UITheme.CLR_VELLUM)
	stats.add_child(e_lbl)

	var rewards := data.get("victory_rewards", {}) as Dictionary
	var gold_val := int(rewards.get("gold", 0))
	var r_lbl := Label.new()
	r_lbl.text = "⚖ Reward: +%d gold" % gold_val
	r_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	r_lbl.add_theme_color_override("font_color", UITheme.CLR_GOLD)
	stats.add_child(r_lbl)

	var meter_changes := data.get("meter_changes", {}) as Dictionary
	if not meter_changes.is_empty():
		var parts: Array[String] = []
		for k in meter_changes:
			var v := int(meter_changes[k])
			parts.append(("%+d %s" % [v, str(k)]))
		var m_lbl := Label.new()
		m_lbl.text = "📜 %s" % ", ".join(parts)
		m_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
		m_lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
		stats.add_child(m_lbl)

	# Buttons row
	var btns := HBoxContainer.new()
	btns.alignment = BoxContainer.ALIGNMENT_END
	btns.add_theme_constant_override("separation", 8)
	inner.add_child(btns)

	if is_completed:
		var done_lbl := Label.new()
		done_lbl.text = "COMPLETED"
		done_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
		done_lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
		btns.add_child(done_lbl)
	elif is_locked:
		var reasons := MissionManager.get_mission_lock_reasons(mid)
		var reason_text := "LOCKED" if reasons.is_empty() else ("LOCKED — %s" % str(reasons[0]))
		var lock_lbl := Label.new()
		lock_lbl.text = reason_text
		lock_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
		lock_lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
		btns.add_child(lock_lbl)
	else:
		var brief_btn := Button.new()
		UITheme.style_button(brief_btn, "BRIEFING", 36)
		brief_btn.pressed.connect(_on_briefing_pressed.bind(mid))
		_apply_button_press_bounce(brief_btn)
		btns.add_child(brief_btn)

		var enter_btn := Button.new()
		UITheme.style_button(enter_btn, "ENTER ARENA", 36)
		enter_btn.pressed.connect(_on_enter_mission_pressed.bind(mid))
		_apply_button_press_bounce(enter_btn)
		btns.add_child(enter_btn)

	# Hover animations for mission card
	if not is_completed and not is_locked:
		card.mouse_entered.connect(_on_mission_card_hover_enter.bind(card))
		card.mouse_exited.connect(_on_mission_card_hover_exit.bind(card))

	return wrapper


func _on_mission_card_hover_enter(card: PanelContainer) -> void:
	# Scale up and apply hover style
	card.add_theme_stylebox_override("panel", UITheme.panel_raised_hover())
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "scale", Vector2(1.015, 1.015), 0.13)


func _on_mission_card_hover_exit(card: PanelContainer) -> void:
	# Scale down and restore original style
	card.add_theme_stylebox_override("panel", UITheme.panel_raised())
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(card, "scale", Vector2(1.0, 1.0), 0.13)


func _on_enter_mission_pressed(mid: String) -> void:
	GameState.current_mission_id = mid
	get_tree().change_scene_to_file("res://scenes/CombatScreen.tscn")


func _on_briefing_pressed(mid: String) -> void:
	mission_briefer.set_ready_callback(func() -> void:
		GameState.current_mission_id = mid
		get_tree().change_scene_to_file("res://scenes/CombatScreen.tscn")
	)
	mission_briefer.set_mission(mid)


# ── 3B  SQUAD ────────────────────────────────────────────────────────────────

func _build_squad_content() -> void:
	var active_count := GameState.active_lieutenants.size()
	var sub_lbl := Label.new()
	sub_lbl.text = "Squad capacity: %d/2" % active_count
	sub_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	sub_lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	content_inner.add_child(sub_lbl)
	content_inner.add_child(_gap(12))

	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 16)
	grid.add_theme_constant_override("v_separation", 16)
	content_inner.add_child(grid)

	for lt_key in GameState.lieutenant_data.keys():
		var lt_state := GameState.lieutenant_data.get(str(lt_key), {}) as Dictionary
		var lt_data  := CardManager.get_lieutenant(str(lt_key))
		grid.add_child(_make_lt_card(str(lt_key), lt_data, lt_state))


func _make_lt_card(lt_key: String, lt_data: Dictionary, lt_state: Dictionary) -> Control:
	var is_recruited := bool(lt_state.get("recruited", false))
	var is_active    := GameState.active_lieutenants.has(lt_key)
	var loyalty      := int(lt_state.get("loyalty", 0))
	var faction      := str(lt_data.get("faction", "NEUTRAL"))
	var faction_col  := UITheme.get_faction_color(faction)

	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", UITheme.panel_raised())
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if not is_recruited:
		card.modulate.a = 0.4

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 8)
	card.add_child(col)

	# Portrait area
	var portrait_wrap := PanelContainer.new()
	portrait_wrap.custom_minimum_size = Vector2(0, 120)
	var ps := UITheme.panel_inset()
	ps.bg_color = UITheme.CLR_STONE_MID
	portrait_wrap.add_theme_stylebox_override("panel", ps)
	col.add_child(portrait_wrap)

	var tint := ColorRect.new()
	tint.set_anchors_preset(Control.PRESET_FULL_RECT)
	tint.color = Color(faction_col.r, faction_col.g, faction_col.b, 0.25)
	tint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	portrait_wrap.add_child(tint)

	var portrait_lbl := Label.new()
	portrait_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	portrait_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	portrait_lbl.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	portrait_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if is_recruited:
		var full_name := str(lt_data.get("name", lt_key))
		var initials  := ""
		for part in full_name.split(" "):
			if part.length() > 0:
				initials += part[0]
		portrait_lbl.text = initials.left(2).to_upper()
		portrait_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_TITLE)
		portrait_lbl.add_theme_color_override("font_color", UITheme.CLR_BRONZE)
	else:
		portrait_lbl.text = "UNKNOWN"
		portrait_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_BODY)
		portrait_lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	portrait_wrap.add_child(portrait_lbl)

	# Name
	var name_lbl := Label.new()
	name_lbl.text = str(lt_data.get("name", lt_key)).to_upper()
	name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_SUBHEAD)
	name_lbl.add_theme_color_override("font_color", UITheme.CLR_GOLD)
	col.add_child(name_lbl)

	col.add_child(_divider_line(0.5))

	# Loyalty bar (only if recruited)
	if is_recruited:
		var loy_row := HBoxContainer.new()
		loy_row.add_theme_constant_override("separation", 6)
		col.add_child(loy_row)

		var heart := Label.new()
		heart.text = "♥"
		heart.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
		heart.add_theme_color_override("font_color", UITheme.CLR_MUTED)
		loy_row.add_child(heart)

		var bar := ProgressBar.new()
		bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		bar.custom_minimum_size   = Vector2(0, 8)
		bar.show_percentage = false
		bar.min_value = 0
		bar.max_value = 10
		bar.value = clamp(loyalty, 0, 10)
		bar.add_theme_stylebox_override("background", UITheme.panel_inset())
		var t := float(clamp(loyalty, 0, 10)) / 10.0
		var fill_style := StyleBoxFlat.new()
		fill_style.bg_color = UITheme.CLR_BLOOD.lerp(UITheme.CLR_GOLD, t)
		fill_style.corner_radius_top_left    = 2
		fill_style.corner_radius_top_right   = 2
		fill_style.corner_radius_bottom_left = 2
		fill_style.corner_radius_bottom_right = 2
		bar.add_theme_stylebox_override("fill", fill_style)
		loy_row.add_child(bar)

		var val_lbl := Label.new()
		val_lbl.text = "%d/10" % clamp(loyalty, 0, 10)
		val_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
		val_lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
		loy_row.add_child(val_lbl)

		# Trait chip
		var trait_name := str(lt_data.get("trait", ""))
		if trait_name != "":
			var chips_row := HBoxContainer.new()
			chips_row.add_theme_constant_override("separation", 4)
			col.add_child(chips_row)
			var chip_bg := Color(UITheme.CLR_STONE_LITE.r, UITheme.CLR_STONE_LITE.g, UITheme.CLR_STONE_LITE.b, 0.5)
			chips_row.add_child(_make_chip(trait_name, chip_bg, UITheme.CLR_PARCHMENT))

	# Buttons
	var btn_row := HBoxContainer.new()
	btn_row.add_theme_constant_override("separation", 6)
	col.add_child(btn_row)

	if not is_recruited:
		var recruit_btn := Button.new()
		UITheme.style_button(recruit_btn, "RECRUIT", 36)
		recruit_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		recruit_btn.pressed.connect(_on_recruit_lt.bind(lt_key))
		_apply_button_press_bounce(recruit_btn)
		btn_row.add_child(recruit_btn)
	elif is_active:
		var info_btn := Button.new()
		UITheme.style_button(info_btn, "INFO", 36)
		info_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		info_btn.pressed.connect(_on_lt_info.bind(lt_key))
		_apply_button_press_bounce(info_btn)
		btn_row.add_child(info_btn)

		var manage_btn := Button.new()
		UITheme.style_button(manage_btn, "MANAGE", 36)
		manage_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		manage_btn.pressed.connect(_on_lt_manage.bind(lt_key))
		_apply_button_press_bounce(manage_btn)
		btn_row.add_child(manage_btn)
	else:
		var info_btn := Button.new()
		UITheme.style_button(info_btn, "INFO", 36)
		info_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		info_btn.pressed.connect(_on_lt_info.bind(lt_key))
		_apply_button_press_bounce(info_btn)
		btn_row.add_child(info_btn)

		var add_btn := Button.new()
		UITheme.style_button(add_btn, "ADD TO SQUAD", 36)
		add_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		add_btn.pressed.connect(_on_lt_add_to_squad.bind(lt_key))
		_apply_button_press_bounce(add_btn)
		btn_row.add_child(add_btn)

	return card


func _on_recruit_lt(lt_key: String) -> void:
	GameState.recruit_lieutenant(lt_key)
	_populate_tab_content("squad")


func _on_lt_info(lt_key: String) -> void:
	var d := CardManager.get_lieutenant(lt_key)
	if bottom_hint_label:
		bottom_hint_label.text = "%s — %s" % [str(d.get("name", lt_key)), str(d.get("trait_desc", ""))]


func _on_lt_manage(lt_key: String) -> void:
	GameState.active_lieutenants.erase(lt_key)
	_populate_tab_content("squad")


func _on_lt_add_to_squad(lt_key: String) -> void:
	if GameState.active_lieutenants.size() < 2:
		GameState.active_lieutenants.append(lt_key)
	_populate_tab_content("squad")


# ── 3C  LOADOUT ───────────────────────────────────────────────────────────────

func _build_loadout_content() -> void:
	var slot_defs := [
		{"slot": "weapon",    "icon": "⚔", "label": "WEAPON"},
		{"slot": "armor",     "icon": "🛡", "label": "ARMOR"},
		{"slot": "accessory", "icon": "✦", "label": "ACCESSORY"},
	]
	for sd in slot_defs:
		var slot       := str(sd["slot"])
		var eq_id      := str(GameState.equipped_gear.get(slot, ""))
		var gear_info  := CardManager.get_gear(eq_id) if eq_id != "" else {}
		content_inner.add_child(_make_gear_slot_row(sd, slot, eq_id, gear_info))
		content_inner.add_child(_gap(6))

	content_inner.add_child(_divider_line(0.6))
	content_inner.add_child(_gap(12))

	var inv_lbl := Label.new()
	inv_lbl.text = "INVENTORY"
	inv_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	inv_lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	content_inner.add_child(inv_lbl)
	content_inner.add_child(_gap(8))

	if GameState.owned_gear.is_empty():
		var empty_lbl := Label.new()
		empty_lbl.text = "No gear owned yet."
		empty_lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
		content_inner.add_child(empty_lbl)
	else:
		var grid := GridContainer.new()
		grid.columns = 3
		grid.add_theme_constant_override("h_separation", 8)
		grid.add_theme_constant_override("v_separation", 8)
		content_inner.add_child(grid)
		for gid in GameState.owned_gear:
			var gd := CardManager.get_gear(str(gid))
			if not gd.is_empty():
				grid.add_child(_make_gear_tile(str(gid), gd))


func _make_gear_slot_row(sd: Dictionary, slot: String, eq_id: String, gear_info: Dictionary) -> Control:
	var row := PanelContainer.new()
	row.custom_minimum_size = Vector2(0, 60)
	row.add_theme_stylebox_override("panel", UITheme.panel_base())

	var hbox := HBoxContainer.new()
	hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	hbox.add_theme_constant_override("separation", 12)
	row.add_child(hbox)

	var icon := Label.new()
	icon.text = str(sd["icon"])
	icon.custom_minimum_size = Vector2(40, 0)
	icon.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	icon.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_HEADER)
	icon.add_theme_color_override("font_color", UITheme.CLR_BRONZE)
	hbox.add_child(icon)

	var slot_lbl := Label.new()
	slot_lbl.text = str(sd["label"])
	slot_lbl.custom_minimum_size = Vector2(80, 0)
	slot_lbl.vertical_alignment  = VERTICAL_ALIGNMENT_CENTER
	slot_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	slot_lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	hbox.add_child(slot_lbl)

	var name_lbl := Label.new()
	name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_lbl.vertical_alignment    = VERTICAL_ALIGNMENT_CENTER
	name_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_BODY)
	if gear_info.is_empty():
		name_lbl.text = "— NONE —"
		name_lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	else:
		name_lbl.text = str(gear_info.get("name", eq_id))
		name_lbl.add_theme_color_override("font_color", UITheme.CLR_VELLUM)
	hbox.add_child(name_lbl)

	if not gear_info.is_empty():
		var parts: Array[String] = []
		var dmg := int(gear_info.get("damage", 0))
		var arm := int(gear_info.get("armor",  0))
		var hp  := int(gear_info.get("hp",     0))
		var spd := int(gear_info.get("speed",  0))
		if dmg != 0: parts.append("DMG %+d" % dmg)
		if arm != 0: parts.append("ARM %+d" % arm)
		if hp  != 0: parts.append("HP %+d"  % hp)
		if spd != 0: parts.append("SPD %+d" % spd)
		if not parts.is_empty():
			var stats_lbl := Label.new()
			stats_lbl.text = " · ".join(parts)
			stats_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			stats_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
			stats_lbl.add_theme_color_override("font_color", UITheme.CLR_PARCHMENT)
			hbox.add_child(stats_lbl)

	# Collect slot-compatible gear from owned inventory
	var slot_gear: Array = [""]  # "" = unequip
	for gid in GameState.owned_gear:
		var gd := CardManager.get_gear(str(gid))
		if str(gd.get("slot", "")) == slot:
			slot_gear.append(str(gid))

	if slot_gear.size() > 1:
		var prev := Button.new()
		prev.text = "◀"
		prev.custom_minimum_size = Vector2(32, 32)
		prev.add_theme_stylebox_override("normal",  UITheme.btn_secondary())
		prev.add_theme_stylebox_override("hover",   UITheme.btn_secondary_hover())
		prev.add_theme_stylebox_override("pressed", UITheme.btn_active())
		prev.pressed.connect(_on_gear_cycle.bind(slot, slot_gear, -1))
		_apply_button_press_bounce(prev)
		hbox.add_child(prev)

		var nxt := Button.new()
		nxt.text = "▶"
		nxt.custom_minimum_size = Vector2(32, 32)
		nxt.add_theme_stylebox_override("normal",  UITheme.btn_secondary())
		nxt.add_theme_stylebox_override("hover",   UITheme.btn_secondary_hover())
		nxt.add_theme_stylebox_override("pressed", UITheme.btn_active())
		nxt.pressed.connect(_on_gear_cycle.bind(slot, slot_gear, 1))
		_apply_button_press_bounce(nxt)
		hbox.add_child(nxt)

	return row


func _make_gear_tile(gear_id: String, gear_data: Dictionary) -> Control:
	var tile := PanelContainer.new()
	tile.add_theme_stylebox_override("panel", UITheme.panel_raised())
	tile.custom_minimum_size    = Vector2(0, 80)
	tile.size_flags_horizontal  = Control.SIZE_EXPAND_FILL

	var is_equipped := false
	for v in GameState.equipped_gear.values():
		if str(v) == gear_id:
			is_equipped = true
			break

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 4)
	tile.add_child(col)

	var rarity_color := UITheme.rarity_color(str(gear_data.get("rarity", "common")))

	var rarity_bar := ColorRect.new()
	rarity_bar.custom_minimum_size = Vector2(0, 3)
	rarity_bar.color = rarity_color
	col.add_child(rarity_bar)

	var name_lbl := Label.new()
	name_lbl.text = str(gear_data.get("name", gear_id)).to_upper()
	name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	name_lbl.add_theme_color_override("font_color", rarity_color)
	col.add_child(name_lbl)

	var slot_lbl := Label.new()
	slot_lbl.text = str(gear_data.get("slot", "")).to_upper()
	slot_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	slot_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
	slot_lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	col.add_child(slot_lbl)

	if is_equipped:
		var eq_lbl := Label.new()
		eq_lbl.text = "EQUIPPED"
		eq_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		eq_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
		eq_lbl.add_theme_color_override("font_color", UITheme.CLR_GOLD)
		col.add_child(eq_lbl)
	else:
		tile.modulate.a = 0.75

	return tile


func _on_gear_cycle(slot: String, slot_gear: Array, direction: int) -> void:
	var current := str(GameState.equipped_gear.get(slot, ""))
	var idx      := slot_gear.find(current)
	idx = wrapi((idx if idx >= 0 else 0) + direction, 0, slot_gear.size())
	GameState.equipped_gear[slot] = slot_gear[idx]
	_populate_tab_content("loadout")


# ── 3D  INTEL ────────────────────────────────────────────────────────────────

func _build_intel_content() -> void:
	for npc_id in GameState.npc_relationships:
		var rel := GameState.npc_relationships.get(str(npc_id), {}) as Dictionary
		content_inner.add_child(_make_intel_entry(str(npc_id), rel))
		content_inner.add_child(_divider_line(0.35))
		content_inner.add_child(_gap(4))


func _make_intel_entry(npc_id: String, rel: Dictionary) -> Control:
	var row := PanelContainer.new()
	row.add_theme_stylebox_override("panel", UITheme.panel_base())

	var hbox := HBoxContainer.new()
	hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	hbox.add_theme_constant_override("separation", 12)
	row.add_child(hbox)

	var name_lbl := Label.new()
	name_lbl.text = npc_id.to_upper()
	name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_lbl.vertical_alignment    = VERTICAL_ALIGNMENT_CENTER
	name_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_BODY)
	name_lbl.add_theme_color_override("font_color", UITheme.CLR_VELLUM)
	hbox.add_child(name_lbl)

	var faction     := str(rel.get("faction", "Neutral"))
	var faction_col := UITheme.get_faction_color(faction)
	hbox.add_child(_make_chip(faction.to_upper(), Color(faction_col.r, faction_col.g, faction_col.b, 0.25), faction_col))

	var level      := str(rel.get("level", "neutral"))
	var rel_colors := {
		"hostile":  UITheme.CLR_BLOOD,
		"neutral":  UITheme.CLR_MUTED,
		"friendly": UITheme.CLR_METER_ALLIES,
		"allied":   UITheme.CLR_GOLD,
	}
	var rel_color := rel_colors.get(level, UITheme.CLR_MUTED) as Color
	var level_lbl := Label.new()
	level_lbl.text = level.to_upper()
	level_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	level_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	level_lbl.add_theme_color_override("font_color", rel_color)
	hbox.add_child(level_lbl)

	hbox.add_child(_make_wax_seal(rel_color))

	return row


# ── 3E  LOG ──────────────────────────────────────────────────────────────────

func _build_log_content() -> void:
	var story_header := Label.new()
	story_header.text = "STORY LOG"
	UITheme.style_header(story_header, UITheme.FONT_SECONDARY, true)
	content_inner.add_child(story_header)

	var story_log := preload("res://scripts/ui/StoryLog.gd").new()
	story_log.custom_minimum_size = Vector2(0, 240)
	content_inner.add_child(story_log)

	content_inner.add_child(_divider_line(0.35))

	var mission_header := Label.new()
	mission_header.text = "MISSION RECORD"
	UITheme.style_header(mission_header, UITheme.FONT_SECONDARY, true)
	content_inner.add_child(mission_header)

	if GameState.completed_missions.is_empty():
		var lbl := Label.new()
		lbl.text = "No missions completed yet."
		lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
		content_inner.add_child(lbl)
		return
	for mid in GameState.completed_missions:
		var mdata := MissionManager.get_mission(str(mid))
		content_inner.add_child(_make_log_entry(str(mid), mdata))
		content_inner.add_child(_divider_line(0.35))


func _make_log_entry(mid: String, data: Dictionary) -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)

	var id_lbl := Label.new()
	id_lbl.text = mid
	id_lbl.custom_minimum_size = Vector2(40, 0)
	id_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
	id_lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	row.add_child(id_lbl)

	var name_lbl := Label.new()
	name_lbl.text = str(data.get("name", mid))
	name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_BODY)
	name_lbl.add_theme_color_override("font_color", UITheme.CLR_PARCHMENT)
	row.add_child(name_lbl)

	var out_lbl := Label.new()
	out_lbl.text = "VICTORY"
	out_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	out_lbl.add_theme_color_override("font_color", UITheme.CLR_BRONZE)
	row.add_child(out_lbl)

	return row

# ========== Narrative Scene Modal ==========
func _on_scene_triggered(scene_id: String, payload: Dictionary) -> void:
	var modal := preload("res://scripts/ui/SceneModal.gd").new()
	modal.present(scene_id, payload)
	modal.dismissed.connect(func(_sid: String) -> void:
		_refresh_runtime_values()
	)
	get_tree().root.add_child(modal)


# ── 3F  DECK ─────────────────────────────────────────────────────────────────

func _build_deck_content() -> void:
	var deck := GameState.current_deck
	if deck.is_empty():
		var lbl := Label.new()
		lbl.text = "Your deck is empty."
		lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
		content_inner.add_child(lbl)
		return

	var sub_lbl := Label.new()
	sub_lbl.text = "%d / 30 cards" % deck.size()
	sub_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	sub_lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	content_inner.add_child(sub_lbl)
	content_inner.add_child(_gap(8))

	# Count duplicates
	var counts: Dictionary = {}
	for cid in deck:
		var s := str(cid)
		counts[s] = int(counts.get(s, 0)) + 1

	var grid := GridContainer.new()
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	content_inner.add_child(grid)

	for cid in counts:
		var cdata := CardManager.get_card(cid)
		if not cdata.is_empty():
			grid.add_child(_make_deck_tile(cid, cdata, int(counts[cid])))


func _make_deck_tile(card_id: String, card_data: Dictionary, count: int) -> Control:
	var tile := PanelContainer.new()
	tile.add_theme_stylebox_override("panel", UITheme.panel_raised())
	tile.custom_minimum_size   = Vector2(0, 90)
	tile.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 4)
	tile.add_child(col)

	# Type color bar at top
	var type_color: Color
	match str(card_data.get("type", "attack")):
		"defense": type_color = UITheme.CLR_AEGIS
		"support": type_color = UITheme.CLR_METER_ALLIES
		_:         type_color = UITheme.CLR_BLOOD
	var type_bar := ColorRect.new()
	type_bar.custom_minimum_size = Vector2(0, 3)
	type_bar.color = type_color
	col.add_child(type_bar)

	# Cost + count row
	var top_row := HBoxContainer.new()
	top_row.add_theme_constant_override("separation", 4)
	col.add_child(top_row)

	var cost_lbl := Label.new()
	cost_lbl.text = "%d CP" % int(card_data.get("cost", 1))
	cost_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
	cost_lbl.add_theme_color_override("font_color", UITheme.CLR_GOLD)
	top_row.add_child(cost_lbl)

	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_row.add_child(spacer)

	if count > 1:
		var cnt_lbl := Label.new()
		cnt_lbl.text = "×%d" % count
		cnt_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
		cnt_lbl.add_theme_color_override("font_color", UITheme.CLR_BRONZE)
		top_row.add_child(cnt_lbl)

	# Card name
	var name_lbl := Label.new()
	name_lbl.text = str(card_data.get("name", card_id)).to_upper()
	name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
	name_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	name_lbl.add_theme_color_override("font_color", UITheme.CLR_VELLUM)
	col.add_child(name_lbl)

	return tile
