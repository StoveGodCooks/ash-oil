extends Control
## Full combat screen with UI built programmatically

## ============ LIEUTENANT COMBAT STATE ============
class LTCombatState:
	var name: String = ""
	var hp: int = 0
	var max_hp: int = 0
	var armor: int = 0
	var active: bool = false

	func _init(p_name: String = "", p_hp: int = 0, p_max_hp: int = 0, p_armor: int = 0, p_active: bool = false) -> void:
		name = p_name
		hp = p_hp
		max_hp = p_max_hp
		armor = p_armor
		active = p_active

const LOG_AUTOWRAP_MODE: TextServer.AutowrapMode = TextServer.AutowrapMode.AUTOWRAP_WORD
const MAX_HAND_SIZE: int = 8
const BASE_TURN_DRAW: int = 3
const HAND_FAN_MAX_DEGREES: float = 5.0
const CARD_HOVER_LIFT_PX: float = 14.0
const CARD_HOVER_TIME: float = 0.15
const CARD_PLAY_MOVE_TIME: float = 0.35
const CARD_PLAY_PULSE_TIME: float = 0.10
const CARD_POPUP_HIDE_DELAY: float = 0.10
const MAX_POISON_STACKS: int = 12
const HAND_REFLOW_TIME: float = 0.20
const HAND_REFLOW_SHIFT: float = 112.0
const CARD_DISPLAY_SCRIPT = preload("res://scripts/ui/CardDisplay.gd")
const CARD_DISPLAY_SCENE = preload("res://scenes/CardDisplay.tscn")
const ENEMY_SLOT_COUNT: int = 5
const UI_BG: Color = Color(0.07, 0.06, 0.05, 1.0)
const UI_TEXT: Color = Color(0.90, 0.88, 0.84, 1.0)
const UI_TEXT_MUTED: Color = Color(0.72, 0.71, 0.69, 1.0)
const UI_ACCENT_WARM: Color = Color(0.83, 0.65, 0.40, 1.0)
const UI_ACCENT_COLD: Color = Color(0.58, 0.76, 0.92, 1.0)
const RAIL_WIDTH: float = 140.0
const PLAYER_RAIL_SIDE_MARGIN: float = 0.0
const ENEMY_RAIL_SIDE_MARGIN: float = 8.0
const PLAYER_RAIL_Y_OFFSET: float = 9.0
const ENEMY_RAIL_Y_OFFSET: float = -9.0

# ============ COMBAT STATE ============
var champion_hp: int = 30
var champion_max_hp: int = 30
var champion_armor: int = 0
var last_ui_champion_armor: int = 0  # tracks armor for animation

var lieutenant_states: Array[LTCombatState] = []  # Up to 4 LTs on battlefield
var lt_label: Label  # Display label (for first LT status)

var enemies: Array = []
var hand: Array = []
var deck: Array = []
var discard_pile: Array = []
var selected_enemy_idx: int = -1

var command_points: int = 5
var max_command_points: int = 5
var last_ui_command_points: int = 5  # tracks CP for animation
var gear_start_cp_bonus: int = 0    # flat bonus CP at combat start (from gear)
var turn: int = 1
var combat_over: bool = false
var player_won: bool = false
var current_mission_id: String = "M01"
var current_mission_data: Dictionary = {}
var opening_draw_bonus: int = 0
var gear_flat_damage_bonus: int = 0
var gear_draw_per_turn_bonus: int = 0
var gear_opening_draw_bonus: int = 0
var reflect_ratio: float = 0.0            # percent of incoming dmg reflected back (0.0–1.0)
var reflect_turns: int = 0                # remaining turns the reflect buff is active
var hazard_data: Dictionary = {}          # optional mission hazard (damage-over-time, etc.)
var hazard_intro_shown: bool = false

const VIGNETTE_GRAIN_SHADER = preload("res://ui/shaders/vignette_grain.gdshader")
const GLOW_RIM_SHADER = preload("res://ui/shaders/ui_glow_rim.gdshader")

# ============ UI REFERENCES ============
var atmosphere_fx: ColorRect
var log_label: Label
var health_label: Label
var cp_label: Label
var turn_label: Label
var champion_label: Label
var hand_container: HBoxContainer
var play_target_marker: Control
var end_turn_btn: Button
var undo_btn: Button
var enemy_labels: Array = []
var enemy_party_cards: Array = []
var is_play_animating: bool = false
var enemy_card_slots: Array = []
var enemy_card_slot_labels: Array = []
var debug_status_label: Label
var enemy_target_reticle_label: Label
var enemy_portrait_panel_ref: Control
var enemy_focus_name_label: Label
var enemy_focus_hp_bar: ProgressBar
var enemy_focus_hp_label: Label
var enemy_health_label: Label
var enemy_armor_label: Label
var player_portrait_panel_ref: Control
var hover_tooltip_panel: PanelContainer
var hover_tooltip_label: Label
var card_popup_panel: PanelContainer = null
var hover_card_display: Control = null
var hover_effect_label: Label = null
var card_popup_tween: Tween = null
var card_popup_hide_timer: Timer = null
var last_popup_card_id: String = ""
var player_hp_bar: ProgressBar
var player_hp_ghost_bar: ProgressBar
var player_stats_panel_ref: Control
var player_party_cards: Array = []
var unit_popout_backdrop: ColorRect
var unit_popout_panel: PanelContainer
var unit_popout_label: Label
var rail_overlay: Control
var player_rail_ref: PanelContainer
var enemy_rail_ref: PanelContainer
var enemy_zone_ref: Control
var player_zone_ref: Control
var last_ui_champion_hp: int = 30
var animation_speed: float = 1.0
var skip_enemy_animation: bool = false
var turn_log_panel: PanelContainer
var turn_log_label: Label
var turn_log_toggle_btn: Button
var turn_log_collapsed: bool = true
var turn_undo_stack: Array = []
var _log_lines: Array = []

const STONE_PANEL_SHADER = preload("res://ui/shaders/ui_panel_stone.gdshader")
const PARCHMENT_TEXTURE = preload("res://assets/ui/roman/parchment.png")

func _apply_panel_style(panel: PanelContainer, tone: int = 0) -> void:
	if panel == null:
		return
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.10, 0.09, 0.82)
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.corner_radius_top_left = 5
	style.corner_radius_top_right = 5
	style.corner_radius_bottom_left = 5
	style.corner_radius_bottom_right = 5
	style.border_color = Color(0.32, 0.28, 0.24, 0.90)
	
	var mat := ShaderMaterial.new()
	mat.shader = STONE_PANEL_SHADER
	var tint := Color(0.12, 0.10, 0.09, 0.82)
	var texture_str := 0.35
	var edge_glow := 0.15
	
	match tone:
		1:
			style.bg_color = Color(0.15, 0.11, 0.09, 0.86)
			style.border_color = Color(0.45, 0.34, 0.24, 0.92)
			tint = style.bg_color
			texture_str = 0.45
			edge_glow = 0.10
		2:
			style.bg_color = Color(0.10, 0.10, 0.11, 0.82)
			style.border_color = Color(0.28, 0.30, 0.34, 0.90)
			tint = style.bg_color
			texture_str = 0.25
			edge_glow = 0.20
		3:
			style.bg_color = Color(0.11, 0.10, 0.09, 0.90)
			style.border_color = Color(0.52, 0.41, 0.28, 0.95)
			tint = style.bg_color
			texture_str = 0.40
			edge_glow = 0.30
		_:
			pass
			
	panel.add_theme_stylebox_override("panel", style)
	mat.set_shader_parameter("tint_color", tint)
	mat.set_shader_parameter("texture_albedo", PARCHMENT_TEXTURE)
	mat.set_shader_parameter("texture_strength", texture_str)
	mat.set_shader_parameter("edge_glow_strength", edge_glow)
	panel.material = mat

func _style_section_title(label: Label, accent: bool = false) -> void:
	if label == null:
		return
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", UI_ACCENT_WARM if accent else UI_TEXT_MUTED)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func _ready() -> void:
	set_process_unhandled_input(true)
	animation_speed = clampf(float(GameState.get_accessibility_setting("animation_speed", 1.0)), 0.5, 2.0)
	_init_state()
	_build_ui()
	var viewport := get_viewport()
	if viewport and not viewport.size_changed.is_connected(_on_viewport_size_changed):
		viewport.size_changed.connect(_on_viewport_size_changed)
	_position_rails.call_deferred()
	_start_turn()
	_apply_text_scale_from_accessibility()

func _on_viewport_size_changed() -> void:
	_position_rails.call_deferred()

func _position_rails() -> void:
	if rail_overlay == null or player_rail_ref == null or enemy_rail_ref == null:
		return
	if enemy_zone_ref == null or player_zone_ref == null:
		return
	await get_tree().process_frame
	var overlay_rect: Rect2 = rail_overlay.get_global_rect()
	var enemy_rect: Rect2 = enemy_zone_ref.get_global_rect()
	var player_rect: Rect2 = player_zone_ref.get_global_rect()
	var vp_h: float = float(get_viewport_rect().size.y)
	var enemy_visible_height: float = maxf(0.0, minf(enemy_rect.position.y + enemy_rect.size.y, vp_h) - maxf(enemy_rect.position.y, 0.0))
	var player_visible_top: float = maxf(0.0, player_rect.position.y)
	var player_visible_height: float = maxf(0.0, minf(player_rect.position.y + player_rect.size.y, vp_h) - player_visible_top)
	var mirrored_height: float = floorf(minf(enemy_visible_height, player_visible_height))
	if mirrored_height <= 0.0:
		return
	var player_y: float = player_visible_top - overlay_rect.position.y
	var enemy_y: float = enemy_rect.position.y - overlay_rect.position.y
	player_rail_ref.position = Vector2(PLAYER_RAIL_SIDE_MARGIN, player_y + PLAYER_RAIL_Y_OFFSET)
	player_rail_ref.size = Vector2(RAIL_WIDTH, mirrored_height)
	enemy_rail_ref.position = Vector2(overlay_rect.size.x - ENEMY_RAIL_SIDE_MARGIN - RAIL_WIDTH, enemy_y + ENEMY_RAIL_Y_OFFSET)
	enemy_rail_ref.size = player_rail_ref.size

func _init_state() -> void:
	champion_hp = 30
	champion_max_hp = 30
	champion_armor = 0
	last_ui_champion_armor = 0
	gear_flat_damage_bonus = 0
	gear_draw_per_turn_bonus = 0
	gear_opening_draw_bonus = 0
	gear_start_cp_bonus = 0
	max_command_points = 5
	last_ui_command_points = 5
	_init_lieutenant_state()
	_resolve_mission_context()

	enemies = CardManager.get_mission_enemies(current_mission_id)
	if enemies.is_empty():
		enemies = [{"name": "Grunt", "hp": 12, "max_hp": 12, "armor": 0, "damage": 2, "poison": 0}]
	_ensure_valid_enemy_target()

	deck = GameState.current_deck.duplicate()
	if deck.is_empty():
		deck = CardManager.get_starter_deck().duplicate()
	deck.shuffle()
	hand = []
	discard_pile = []
	command_points = max_command_points
	turn = 1
	combat_over = false
	last_ui_champion_hp = champion_hp
	reflect_ratio = 0.0
	reflect_turns = 0
	hazard_intro_shown = false
	_apply_equipped_gear_bonuses()

func _build_ui() -> void:
	var bg = ColorRect.new()
	bg.color = UI_BG
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var main_vbox = VBoxContainer.new()
	main_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_vbox.add_theme_constant_override("separation", 8)
	add_child(main_vbox)

	# Full-screen overlay for party rails — anchors resolve against full screen.
	rail_overlay = Control.new()
	rail_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	rail_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rail_overlay.z_index = 70
	add_child(rail_overlay)

	# HEADER BAR (4%)
	var header_zone = PanelContainer.new()
	header_zone.size_flags_vertical = Control.SIZE_EXPAND_FILL
	header_zone.size_flags_stretch_ratio = 4.0
	_apply_panel_style(header_zone, 2)
	main_vbox.add_child(header_zone)

	var header_margin = MarginContainer.new()
	header_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	header_margin.add_theme_constant_override("margin_left", 12)
	header_margin.add_theme_constant_override("margin_top", 4)
	header_margin.add_theme_constant_override("margin_right", 12)
	header_margin.add_theme_constant_override("margin_bottom", 4)
	header_zone.add_child(header_margin)

	var title_bar = HBoxContainer.new()
	title_bar.custom_minimum_size = Vector2(0, 36)
	header_margin.add_child(title_bar)

	var m_name = current_mission_data.get("name", current_mission_id).to_upper()
	var m_loc = current_mission_data.get("location", "Unknown")
	var mission_label = Label.new()
	mission_label.text = "%s: %s — %s" % [current_mission_id, m_name, m_loc]
	mission_label.add_theme_font_size_override("font_size", 16)
	mission_label.add_theme_color_override("font_color", UI_TEXT)
	title_bar.add_child(mission_label)

	var header_spacer = Control.new()
	header_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_bar.add_child(header_spacer)

	turn_label = Label.new()
	turn_label.text = "Turn 1"
	turn_label.add_theme_font_size_override("font_size", 16)
	turn_label.add_theme_color_override("font_color", UI_TEXT)
	title_bar.add_child(turn_label)

	# ENEMY ZONE (30%)
	var enemy_zone = PanelContainer.new()
	enemy_zone.size_flags_vertical = Control.SIZE_EXPAND_FILL
	enemy_zone.size_flags_stretch_ratio = 28.0
	_apply_panel_style(enemy_zone, 1)
	main_vbox.add_child(enemy_zone)
	enemy_zone_ref = enemy_zone

	var enemy_bg = ColorRect.new()
	enemy_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	enemy_bg.color = Color(0.10, 0.14, 0.16, 0.50)  # Cool-dark blue zone
	enemy_zone.add_child(enemy_bg)

	var enemy_margin = MarginContainer.new()
	enemy_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	enemy_margin.add_theme_constant_override("margin_left", 12)
	enemy_margin.add_theme_constant_override("margin_top", 8)
	enemy_margin.add_theme_constant_override("margin_right", 150)
	enemy_margin.add_theme_constant_override("margin_bottom", 8)
	enemy_zone.add_child(enemy_margin)

	var enemy_row = HBoxContainer.new()
	enemy_row.add_theme_constant_override("separation", 20)
	enemy_margin.add_child(enemy_row)

	enemy_party_cards.clear()
	enemy_focus_name_label = null
	enemy_focus_hp_bar = null
	enemy_health_label = null
	enemy_armor_label = null
	enemy_labels.clear()

	var enemy_cards_panel = PanelContainer.new()
	enemy_cards_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	enemy_cards_panel.custom_minimum_size = Vector2(1040, 188)
	_apply_panel_style(enemy_cards_panel, 1)
	enemy_row.add_child(enemy_cards_panel)

	var enemy_cards_vbox = VBoxContainer.new()
	enemy_cards_vbox.add_theme_constant_override("separation", 8)
	enemy_cards_panel.add_child(enemy_cards_vbox)

	var enemy_cards_title = Label.new()
	enemy_cards_title.text = "ENEMY CARDS"
	_style_section_title(enemy_cards_title, true)
	enemy_cards_vbox.add_child(enemy_cards_title)

	var slot_row = HBoxContainer.new()
	slot_row.alignment = BoxContainer.ALIGNMENT_CENTER
	slot_row.add_theme_constant_override("separation", 15)
	enemy_cards_vbox.add_child(slot_row)

	enemy_card_slots.clear()
	enemy_card_slot_labels.clear()
	for i in range(ENEMY_SLOT_COUNT):
		var slot = PanelContainer.new()
		slot.custom_minimum_size = Vector2(100, 140)
		slot_row.add_child(slot)
		enemy_card_slots.append(slot)

		var slot_label = Label.new()
		slot_label.text = "?"
		slot_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		slot_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		slot_label.custom_minimum_size = Vector2(100, 140)
		slot_label.add_theme_font_size_override("font_size", 24)
		slot.add_child(slot_label)
		enemy_card_slot_labels.append(slot_label)

	var target_panel = PanelContainer.new()
	target_panel.custom_minimum_size = Vector2(120, 188)
	_apply_panel_style(target_panel, 3)
	enemy_row.add_child(target_panel)

	var target_vbox = VBoxContainer.new()
	target_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	target_panel.add_child(target_vbox)

	var target_title = Label.new()
	target_title.text = "TARGET"
	_style_section_title(target_title, true)
	target_vbox.add_child(target_title)

	var target_reticle = Label.new()
	target_reticle.text = "◉"
	target_reticle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	target_reticle.add_theme_font_size_override("font_size", 42)
	target_vbox.add_child(target_reticle)
	enemy_target_reticle_label = target_reticle

	# BATTLEFIELD / EFFECT LANE (32%)
	var middle_zone = PanelContainer.new()
	middle_zone.size_flags_vertical = Control.SIZE_EXPAND_FILL
	middle_zone.size_flags_stretch_ratio = 30.0
	_apply_panel_style(middle_zone, 2)
	main_vbox.add_child(middle_zone)

	var middle_bg = ColorRect.new()
	middle_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	middle_bg.color = Color(0.10, 0.10, 0.10, 0.55)
	middle_zone.add_child(middle_bg)

	# Gold divider lines at top and bottom of middle zone
	var divider_top = ColorRect.new()
	divider_top.set_anchors_preset(Control.PRESET_TOP_WIDE)
	divider_top.offset_bottom = 2
	divider_top.color = UITheme.CLR_GOLD
	divider_top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	middle_zone.add_child(divider_top)

	var divider_bottom = ColorRect.new()
	divider_bottom.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	divider_bottom.offset_top = -2
	divider_bottom.color = UITheme.CLR_GOLD
	divider_bottom.mouse_filter = Control.MOUSE_FILTER_IGNORE
	middle_zone.add_child(divider_bottom)

	var middle_margin = MarginContainer.new()
	middle_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	middle_margin.add_theme_constant_override("margin_left", 12)
	middle_margin.add_theme_constant_override("margin_top", 10)
	middle_margin.add_theme_constant_override("margin_right", 12)
	middle_margin.add_theme_constant_override("margin_bottom", 10)
	middle_zone.add_child(middle_margin)

	var middle_vbox = VBoxContainer.new()
	middle_vbox.add_theme_constant_override("separation", 14)
	middle_margin.add_child(middle_vbox)

	var effect_title = Label.new()
	effect_title.text = "Battlefield / Effect Lane"
	effect_title.add_theme_font_size_override("font_size", 13)
	effect_title.add_theme_color_override("font_color", UI_TEXT_MUTED)
	middle_vbox.add_child(effect_title)

	var battlefield_center = CenterContainer.new()
	battlefield_center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	middle_vbox.add_child(battlefield_center)

	play_target_marker = PanelContainer.new()
	play_target_marker.custom_minimum_size = Vector2(320, 120)
	_apply_panel_style(play_target_marker, 2)
	battlefield_center.add_child(play_target_marker)

	var target_label = Label.new()
	target_label.text = "Play Target"
	target_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	target_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	target_label.custom_minimum_size = Vector2(320, 120)
	target_label.add_theme_font_size_override("font_size", 30)
	target_label.add_theme_color_override("font_color", UI_TEXT)
	play_target_marker.add_child(target_label)

	log_label = Label.new()
	log_label.text = "Combat begins..."
	log_label.add_theme_font_size_override("font_size", 13)
	log_label.add_theme_color_override("font_color", UITheme.CLR_PARCHMENT)
	log_label.autowrap_mode = LOG_AUTOWRAP_MODE
	log_label.custom_minimum_size = Vector2(0, 96)
	middle_vbox.add_child(log_label)

	# PLAYER ZONE (30%)
	var player_zone = PanelContainer.new()
	player_zone.size_flags_vertical = Control.SIZE_EXPAND_FILL
	player_zone.size_flags_stretch_ratio = 33.0
	_apply_panel_style(player_zone, 1)
	main_vbox.add_child(player_zone)
	player_zone_ref = player_zone

	var player_bg = ColorRect.new()
	player_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	player_bg.color = Color(0.18, 0.12, 0.08, 0.55)  # Warm-dark orange/brown zone
	player_zone.add_child(player_bg)

	var player_margin = MarginContainer.new()
	player_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	player_margin.add_theme_constant_override("margin_left", 142)
	player_margin.add_theme_constant_override("margin_top", 8)
	player_margin.add_theme_constant_override("margin_right", 12)
	player_margin.add_theme_constant_override("margin_bottom", 8)
	player_zone.add_child(player_margin)

	var player_zone_vbox = VBoxContainer.new()
	player_zone_vbox.add_theme_constant_override("separation", 8)
	player_margin.add_child(player_zone_vbox)

	var player_row = HBoxContainer.new()
	player_row.add_theme_constant_override("separation", 18)
	player_row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	player_zone_vbox.add_child(player_row)

	player_party_cards.clear()

	# CENTER-LEFT: Stats
	var resource_panel = PanelContainer.new()
	resource_panel.custom_minimum_size = Vector2(260, 188)
	_apply_panel_style(resource_panel, 1)
	player_row.add_child(resource_panel)
	player_stats_panel_ref = resource_panel

	var res_vbox = VBoxContainer.new()
	res_vbox.add_theme_constant_override("separation", 8)
	resource_panel.add_child(res_vbox)

	var res_title = Label.new()
	res_title.text = "YOUR STATS"
	_style_section_title(res_title, false)
	res_vbox.add_child(res_title)

	champion_label = Label.new()
	champion_label.text = _get_champion_display()
	champion_label.add_theme_font_size_override("font_size", 11)
	res_vbox.add_child(champion_label)

	health_label = Label.new()
	health_label.text = "Health: %d/%d" % [champion_hp, champion_max_hp]
	health_label.add_theme_font_size_override("font_size", 16)
	health_label.add_theme_color_override("font_color", UITheme.CLR_VELLUM)
	res_vbox.add_child(health_label)

	# --- Layered HP Bar (Ghosting) ---
	var hp_container = Control.new()
	hp_container.custom_minimum_size = Vector2(240, 14)
	res_vbox.add_child(hp_container)

	# The Ghost Bar (Lighter red, sits behind)
	player_hp_ghost_bar = ProgressBar.new()
	player_hp_ghost_bar.set_anchors_preset(Control.PRESET_FULL_RECT)
	player_hp_ghost_bar.min_value = 0
	player_hp_ghost_bar.max_value = champion_max_hp
	player_hp_ghost_bar.value = champion_hp
	player_hp_ghost_bar.show_percentage = false
	var ghost_bg = StyleBoxFlat.new()
	ghost_bg.bg_color = Color(0.15, 0.10, 0.10, 0.9)
	player_hp_ghost_bar.add_theme_stylebox_override("background", ghost_bg)
	var ghost_fill = StyleBoxFlat.new()
	ghost_fill.bg_color = Color(0.85, 0.45, 0.45, 0.8) # Lighter "Ghost Blood"
	player_hp_ghost_bar.add_theme_stylebox_override("fill", ghost_fill)
	hp_container.add_child(player_hp_ghost_bar)

	# The Main Bar (Solid blood red)
	player_hp_bar = ProgressBar.new()
	player_hp_bar.set_anchors_preset(Control.PRESET_FULL_RECT)
	player_hp_bar.min_value = 0
	player_hp_bar.max_value = champion_max_hp
	player_hp_bar.value = champion_hp
	player_hp_bar.show_percentage = false
	var hp_bg_style = StyleBoxFlat.new()
	hp_bg_style.bg_color = Color(0, 0, 0, 0) # Transparent bg since ghost is behind
	player_hp_bar.add_theme_stylebox_override("background", hp_bg_style)
	var hp_fill_style = StyleBoxFlat.new()
	hp_fill_style.bg_color = UITheme.CLR_BLOOD
	player_hp_bar.add_theme_stylebox_override("fill", hp_fill_style)
	hp_container.add_child(player_hp_bar)

	var armor_label = Label.new()
	armor_label.text = "Armor tracked in card readout"
	armor_label.add_theme_font_size_override("font_size", 12)
	armor_label.add_theme_color_override("font_color", UI_ACCENT_COLD)
	res_vbox.add_child(armor_label)

	cp_label = Label.new()
	cp_label.text = "CP: %d/%d" % [command_points, max_command_points]
	cp_label.add_theme_font_size_override("font_size", 14)
	cp_label.add_theme_color_override("font_color", UITheme.CLR_GOLD)
	res_vbox.add_child(cp_label)

	lt_label = Label.new()
	lt_label.text = _get_lt_display()
	lt_label.add_theme_font_size_override("font_size", 11)
	res_vbox.add_child(lt_label)

	# CENTER-RIGHT: Hand cards
	var hand_panel = PanelContainer.new()
	hand_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hand_panel.custom_minimum_size = Vector2(640, 188)
	_apply_panel_style(hand_panel, 1)
	player_row.add_child(hand_panel)

	var hand_vbox = VBoxContainer.new()
	hand_vbox.add_theme_constant_override("separation", 6)
	hand_panel.add_child(hand_vbox)

	var hand_title = Label.new()
	hand_title.text = "YOUR HAND"
	_style_section_title(hand_title, false)
	hand_vbox.add_child(hand_title)

	var hand_center = CenterContainer.new()
	hand_center.custom_minimum_size = Vector2(0, 170)
	hand_center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	hand_vbox.add_child(hand_center)

	hand_container = HBoxContainer.new()
	hand_container.add_theme_constant_override("separation", 4)
	hand_container.alignment = BoxContainer.ALIGNMENT_CENTER
	hand_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hand_center.add_child(hand_container)

	# RIGHT: Actions
	var action_panel = PanelContainer.new()
	action_panel.custom_minimum_size = Vector2(210, 188)
	_apply_panel_style(action_panel, 3)
	player_row.add_child(action_panel)

	var action_vbox = VBoxContainer.new()
	action_vbox.add_theme_constant_override("separation", 8)
	action_panel.add_child(action_vbox)

	var action_title = Label.new()
	action_title.text = "ACTIONS"
	_style_section_title(action_title, true)
	action_vbox.add_child(action_title)

	end_turn_btn = Button.new()
	end_turn_btn.text = "END TURN"
	end_turn_btn.custom_minimum_size = Vector2(0, 60)
	UITheme.style_button(end_turn_btn, "END TURN", 60)
	end_turn_btn.pressed.connect(_on_end_turn)
	end_turn_btn.mouse_entered.connect(_on_end_turn_btn_entered)
	end_turn_btn.mouse_exited.connect(_on_end_turn_btn_exited)
	_apply_button_press_bounce(end_turn_btn)
	action_vbox.add_child(end_turn_btn)

	undo_btn = Button.new()
	undo_btn.text = "UNDO LAST PLAY"
	undo_btn.custom_minimum_size = Vector2(0, 46)
	undo_btn.disabled = true
	undo_btn.tooltip_text = "Undo card plays this turn until End Turn is pressed."
	undo_btn.add_theme_font_size_override("font_size", UITheme.FONT_SECONDARY)
	undo_btn.add_theme_color_override("font_color", UITheme.CLR_VELLUM)
	undo_btn.add_theme_stylebox_override("normal", UITheme.btn_secondary())
	undo_btn.add_theme_stylebox_override("disabled", UITheme.panel_inset())
	undo_btn.pressed.connect(_on_undo_pressed)
	_apply_button_press_bounce(undo_btn)
	action_vbox.add_child(undo_btn)

	var retreat_btn = Button.new()
	retreat_btn.text = "RETREAT"
	retreat_btn.custom_minimum_size = Vector2(0, 54)
	UITheme.style_button(retreat_btn, "RETREAT", 54)
	retreat_btn.pressed.connect(_on_retreat)
	_apply_button_press_bounce(retreat_btn)
	action_vbox.add_child(retreat_btn)

	# DEBUG / STATUS BAR (4%) — visible only in debug builds.
	var debug_zone = PanelContainer.new()
	debug_zone.size_flags_vertical = Control.SIZE_EXPAND_FILL
	debug_zone.size_flags_stretch_ratio = 4.0
	debug_zone.visible = OS.is_debug_build()
	_apply_panel_style(debug_zone, 2)
	main_vbox.add_child(debug_zone)

	debug_status_label = Label.new()
	debug_status_label.text = "Debug status bar"
	debug_status_label.add_theme_font_size_override("font_size", 12)
	debug_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	debug_zone.add_child(debug_status_label)

	# Hover tooltip panel (fades in/out near hovered card)
	hover_tooltip_panel = PanelContainer.new()
	hover_tooltip_panel.visible = false
	hover_tooltip_panel.modulate = Color(1.0, 1.0, 1.0, 0.0)
	hover_tooltip_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hover_tooltip_panel.z_index = 250
	var tooltip_style := StyleBoxFlat.new()
	tooltip_style.bg_color = Color(0.07, 0.07, 0.08, 0.96)
	tooltip_style.border_color = Color(0.34, 0.34, 0.38, 0.95)
	tooltip_style.border_width_left = 1
	tooltip_style.border_width_top = 1
	tooltip_style.border_width_right = 1
	tooltip_style.border_width_bottom = 1
	tooltip_style.corner_radius_top_left = 4
	tooltip_style.corner_radius_top_right = 4
	tooltip_style.corner_radius_bottom_left = 4
	tooltip_style.corner_radius_bottom_right = 4
	hover_tooltip_panel.add_theme_stylebox_override("panel", tooltip_style)
	add_child(hover_tooltip_panel)

	hover_tooltip_label = Label.new()
	hover_tooltip_label.autowrap_mode = LOG_AUTOWRAP_MODE
	hover_tooltip_label.add_theme_font_size_override("font_size", 12)
	hover_tooltip_label.add_theme_color_override("font_color", Color(0.92, 0.92, 0.92, 1.0))
	hover_tooltip_label.custom_minimum_size = Vector2(280, 84)
	hover_tooltip_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	hover_tooltip_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	hover_tooltip_panel.add_child(hover_tooltip_label)

	# Full card pop-out (appears above hovered hand card)
	card_popup_panel = PanelContainer.new()
	card_popup_panel.visible = false
	card_popup_panel.modulate.a = 0.0
	card_popup_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card_popup_panel.z_index = 250
	var popup_style := StyleBoxFlat.new()
	popup_style.bg_color = UITheme.CLR_STONE
	popup_style.border_color = UITheme.CLR_BRONZE
	popup_style.border_width_left = 2
	popup_style.border_width_top = 2
	popup_style.border_width_right = 2
	popup_style.border_width_bottom = 2
	popup_style.content_margin_left = 8
	popup_style.content_margin_right = 8
	popup_style.content_margin_top = 8
	popup_style.content_margin_bottom = 8
	card_popup_panel.add_theme_stylebox_override("panel", popup_style)
	add_child(card_popup_panel)

	var popup_vbox := VBoxContainer.new()
	popup_vbox.add_theme_constant_override("separation", 8)
	card_popup_panel.add_child(popup_vbox)

	hover_card_display = CARD_DISPLAY_SCENE.instantiate()
	hover_card_display.set_card_size(Vector2(160, 240))
	hover_card_display.mouse_filter = Control.MOUSE_FILTER_IGNORE
	popup_vbox.add_child(hover_card_display)

	hover_effect_label = Label.new()
	hover_effect_label.custom_minimum_size = Vector2(160, 0)
	hover_effect_label.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	hover_effect_label.add_theme_color_override("font_color", UITheme.CLR_PARCHMENT)
	hover_effect_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	hover_effect_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	popup_vbox.add_child(hover_effect_label)

	card_popup_hide_timer = Timer.new()
	card_popup_hide_timer.one_shot = true
	card_popup_hide_timer.wait_time = CARD_POPUP_HIDE_DELAY
	add_child(card_popup_hide_timer)
	card_popup_hide_timer.timeout.connect(_hide_card_popup)

	# Side-wall party rails — both parented to rail_overlay (full-screen).
	var player_rail = PanelContainer.new()
	player_rail.anchor_left = 0.0
	player_rail.anchor_right = 0.0
	player_rail.anchor_top = 0.0
	player_rail.anchor_bottom = 0.0
	player_rail.position = Vector2(PLAYER_RAIL_SIDE_MARGIN, 0.0)
	player_rail.size = Vector2(RAIL_WIDTH, 1.0)
	player_rail.z_index       = 60
	var player_rail_style := StyleBoxFlat.new()
	player_rail_style.bg_color = Color(0.10, 0.09, 0.10, 0.84)
	player_rail_style.border_color = Color(0.34, 0.30, 0.24, 0.92)
	player_rail_style.border_width_left = 1
	player_rail_style.border_width_top = 1
	player_rail_style.border_width_right = 1
	player_rail_style.border_width_bottom = 1
	player_rail_style.corner_radius_top_left = 6
	player_rail_style.corner_radius_top_right = 6
	player_rail_style.corner_radius_bottom_left = 6
	player_rail_style.corner_radius_bottom_right = 6
	player_rail.add_theme_stylebox_override("panel", player_rail_style)
	rail_overlay.add_child(player_rail)
	player_rail_ref = player_rail

	var player_rail_vbox = VBoxContainer.new()
	player_rail_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	player_rail_vbox.add_theme_constant_override("separation", 4)
	player_rail.add_child(player_rail_vbox)

	var player_rail_title = Label.new()
	player_rail_title.text = "YOUR PARTY"
	_style_section_title(player_rail_title, true)
	player_rail_title.add_theme_font_size_override("font_size", 11)
	player_rail_vbox.add_child(player_rail_title)

	for i in range(5):
		var slot = PanelContainer.new()
		slot.custom_minimum_size = Vector2(132, 40)
		slot.size_flags_vertical = Control.SIZE_EXPAND_FILL
		slot.mouse_filter = Control.MOUSE_FILTER_STOP
		var slot_style := StyleBoxFlat.new()
		slot_style.bg_color = Color(0.17, 0.13, 0.11, 0.90)
		slot_style.border_color = Color(0.45, 0.34, 0.24, 0.92)
		slot_style.border_width_left = 1
		slot_style.border_width_top = 1
		slot_style.border_width_right = 1
		slot_style.border_width_bottom = 1
		slot_style.corner_radius_top_left = 4
		slot_style.corner_radius_top_right = 4
		slot_style.corner_radius_bottom_left = 4
		slot_style.corner_radius_bottom_right = 4
		slot_style.content_margin_left = 5
		slot_style.content_margin_right = 5
		slot_style.content_margin_top = 6
		slot_style.content_margin_bottom = 6
		slot.add_theme_stylebox_override("panel", slot_style)
		player_rail_vbox.add_child(slot)
		if i == 0:
			player_portrait_panel_ref = slot
			slot_style.border_color = Color(0.72, 0.55, 0.26, 1.0)
			slot_style.border_width_left = 2
			slot_style.border_width_top = 2
			slot_style.border_width_right = 2
			slot_style.border_width_bottom = 2
			slot.add_theme_stylebox_override("panel", slot_style)

		var slot_vbox = VBoxContainer.new()
		slot_vbox.add_theme_constant_override("separation", 2)
		slot.add_child(slot_vbox)

		var unit_name = Label.new()
		unit_name.text = "Empty"
		unit_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		unit_name.add_theme_font_size_override("font_size", 10)
		unit_name.add_theme_color_override("font_color", UI_TEXT)
		slot_vbox.add_child(unit_name)

		var hp_bar = ProgressBar.new()
		hp_bar.min_value = 0
		hp_bar.max_value = 1
		hp_bar.value = 0
		hp_bar.custom_minimum_size = Vector2(122, 8)
		hp_bar.size_flags_vertical = Control.SIZE_EXPAND_FILL
		hp_bar.show_percentage = false
		slot_vbox.add_child(hp_bar)

		var unit_stats = Label.new()
		unit_stats.text = "H 0/0  A0"
		unit_stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		unit_stats.add_theme_font_size_override("font_size", 9)
		unit_stats.add_theme_color_override("font_color", UI_TEXT_MUTED)
		slot_vbox.add_child(unit_stats)

		slot.gui_input.connect(_on_unit_plate_gui_input.bind("player", i))
		slot.mouse_entered.connect(_on_unit_plate_hover_entered.bind(slot, "player", i))
		slot.mouse_exited.connect(_on_unit_plate_hover_exited.bind(slot))
		player_party_cards.append({
			"panel": slot,
			"name_label": unit_name,
			"hp_bar": hp_bar,
			"stats_label": unit_stats,
		})

	var enemy_rail = PanelContainer.new()
	enemy_rail.anchor_left = 0.0
	enemy_rail.anchor_right = 0.0
	enemy_rail.anchor_top = 0.0
	enemy_rail.anchor_bottom = 0.0
	enemy_rail.position = Vector2(0.0, 0.0)
	enemy_rail.size = Vector2(RAIL_WIDTH, 1.0)
	enemy_rail.z_index       = 60
	var enemy_rail_style := StyleBoxFlat.new()
	enemy_rail_style.bg_color = Color(0.10, 0.09, 0.10, 0.84)
	enemy_rail_style.border_color = Color(0.34, 0.30, 0.24, 0.92)
	enemy_rail_style.border_width_left = 1
	enemy_rail_style.border_width_top = 1
	enemy_rail_style.border_width_right = 1
	enemy_rail_style.border_width_bottom = 1
	enemy_rail_style.corner_radius_top_left = 6
	enemy_rail_style.corner_radius_top_right = 6
	enemy_rail_style.corner_radius_bottom_left = 6
	enemy_rail_style.corner_radius_bottom_right = 6
	enemy_rail.add_theme_stylebox_override("panel", enemy_rail_style)
	rail_overlay.add_child(enemy_rail)
	enemy_rail_ref = enemy_rail

	var enemy_rail_vbox = VBoxContainer.new()
	enemy_rail_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	enemy_rail_vbox.add_theme_constant_override("separation", 4)
	enemy_rail.add_child(enemy_rail_vbox)

	var enemy_rail_title = Label.new()
	enemy_rail_title.text = "ENEMY PARTY"
	_style_section_title(enemy_rail_title, true)
	enemy_rail_title.add_theme_font_size_override("font_size", 11)
	enemy_rail_vbox.add_child(enemy_rail_title)

	for i in range(5):
		var slot = PanelContainer.new()
		slot.custom_minimum_size = Vector2(132, 40)
		slot.size_flags_vertical = Control.SIZE_EXPAND_FILL
		slot.mouse_filter = Control.MOUSE_FILTER_STOP
		var enemy_slot_style := StyleBoxFlat.new()
		enemy_slot_style.bg_color = Color(0.17, 0.13, 0.11, 0.90)
		enemy_slot_style.border_color = Color(0.45, 0.34, 0.24, 0.92)
		enemy_slot_style.border_width_left = 1
		enemy_slot_style.border_width_top = 1
		enemy_slot_style.border_width_right = 1
		enemy_slot_style.border_width_bottom = 1
		enemy_slot_style.corner_radius_top_left = 4
		enemy_slot_style.corner_radius_top_right = 4
		enemy_slot_style.corner_radius_bottom_left = 4
		enemy_slot_style.corner_radius_bottom_right = 4
		enemy_slot_style.content_margin_left = 5
		enemy_slot_style.content_margin_right = 5
		enemy_slot_style.content_margin_top = 6
		enemy_slot_style.content_margin_bottom = 6
		slot.add_theme_stylebox_override("panel", enemy_slot_style)
		enemy_rail_vbox.add_child(slot)
		if i == 0:
			enemy_portrait_panel_ref = slot

		var slot_vbox = VBoxContainer.new()
		slot_vbox.add_theme_constant_override("separation", 2)
		slot.add_child(slot_vbox)

		var unit_name = Label.new()
		unit_name.text = "Empty"
		unit_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		unit_name.add_theme_font_size_override("font_size", 10)
		unit_name.add_theme_color_override("font_color", UI_TEXT)
		slot_vbox.add_child(unit_name)

		var hp_bar = ProgressBar.new()
		hp_bar.min_value = 0
		hp_bar.max_value = 1
		hp_bar.value = 0
		hp_bar.custom_minimum_size = Vector2(122, 8)
		hp_bar.size_flags_vertical = Control.SIZE_EXPAND_FILL
		hp_bar.show_percentage = false
		slot_vbox.add_child(hp_bar)

		var unit_stats = Label.new()
		unit_stats.text = "H 0/0  A0"
		unit_stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		unit_stats.add_theme_font_size_override("font_size", 9)
		unit_stats.add_theme_color_override("font_color", UI_TEXT_MUTED)
		slot_vbox.add_child(unit_stats)

		slot.mouse_entered.connect(_on_unit_plate_hover_entered.bind(slot, "enemy", i))
		slot.mouse_exited.connect(_on_unit_plate_hover_exited.bind(slot))
		slot.gui_input.connect(_on_unit_plate_gui_input.bind("enemy", i))
		enemy_party_cards.append({
			"panel": slot,
			"name_label": unit_name,
			"hp_bar": hp_bar,
			"stats_label": unit_stats,
		})

	unit_popout_backdrop = ColorRect.new()
	unit_popout_backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	unit_popout_backdrop.color = Color(0.0, 0.0, 0.0, 0.0)
	unit_popout_backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	unit_popout_backdrop.visible = false
	unit_popout_backdrop.z_index = 255
	unit_popout_backdrop.gui_input.connect(_on_popout_backdrop_input)
	add_child(unit_popout_backdrop)

	unit_popout_panel = PanelContainer.new()
	unit_popout_panel.anchor_left = 0.5
	unit_popout_panel.anchor_right = 0.5
	unit_popout_panel.anchor_top = 0.5
	unit_popout_panel.anchor_bottom = 0.5
	unit_popout_panel.offset_left = -170
	unit_popout_panel.offset_right = 170
	unit_popout_panel.offset_top = -120
	unit_popout_panel.offset_bottom = 120
	unit_popout_panel.z_index = 260
	unit_popout_panel.visible = false
	unit_popout_panel.modulate = Color(1.0, 1.0, 1.0, 0.0)
	unit_popout_panel.scale = Vector2(0.95, 0.95)
	var pop_style := StyleBoxFlat.new()
	pop_style.bg_color = Color(0.09, 0.09, 0.10, 0.96)
	pop_style.border_color = Color(0.42, 0.38, 0.30, 0.95)
	pop_style.border_width_left = 1
	pop_style.border_width_top = 1
	pop_style.border_width_right = 1
	pop_style.border_width_bottom = 1
	pop_style.corner_radius_top_left = 6
	pop_style.corner_radius_top_right = 6
	pop_style.corner_radius_bottom_left = 6
	pop_style.corner_radius_bottom_right = 6
	unit_popout_panel.add_theme_stylebox_override("panel", pop_style)
	add_child(unit_popout_panel)

	var pop_vbox = VBoxContainer.new()
	pop_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	pop_vbox.add_theme_constant_override("separation", 8)
	unit_popout_panel.add_child(pop_vbox)

	unit_popout_label = Label.new()
	unit_popout_label.autowrap_mode = LOG_AUTOWRAP_MODE
	unit_popout_label.add_theme_font_size_override("font_size", 13)
	unit_popout_label.add_theme_color_override("font_color", UI_TEXT)
	unit_popout_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	pop_vbox.add_child(unit_popout_label)

	var pop_close = Button.new()
	pop_close.text = "Close"
	pop_close.custom_minimum_size = Vector2(0, 32)
	pop_close.modulate = Color(1.0, 0.95, 0.88, 1.0)
	pop_close.pressed.connect(_hide_unit_popout)
	pop_vbox.add_child(pop_close)

	turn_log_panel = PanelContainer.new()
	turn_log_panel.anchor_left = 1.0
	turn_log_panel.anchor_right = 1.0
	turn_log_panel.anchor_top = 1.0
	turn_log_panel.anchor_bottom = 1.0
	turn_log_panel.offset_left = -420
	turn_log_panel.offset_right = -10
	turn_log_panel.offset_top = -180
	turn_log_panel.offset_bottom = -10
	turn_log_panel.z_index = 180
	add_child(turn_log_panel)

	var turn_log_vbox = VBoxContainer.new()
	turn_log_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	turn_log_panel.add_child(turn_log_vbox)

	turn_log_toggle_btn = Button.new()
	turn_log_toggle_btn.text = "TURN LOG  /\\"
	turn_log_toggle_btn.custom_minimum_size = Vector2(0, 28)
	turn_log_toggle_btn.pressed.connect(_toggle_turn_log)
	turn_log_vbox.add_child(turn_log_toggle_btn)

	turn_log_label = Label.new()
	turn_log_label.autowrap_mode = LOG_AUTOWRAP_MODE
	turn_log_label.add_theme_font_size_override("font_size", 12)
	turn_log_label.custom_minimum_size = Vector2(0, 130)
	turn_log_vbox.add_child(turn_log_label)
	_refresh_turn_log()
	_apply_turn_log_state()

	# --- Phase 1: AAA Atmosphere Overlay ---
	atmosphere_fx = ColorRect.new()
	atmosphere_fx.set_anchors_preset(Control.PRESET_FULL_RECT)
	atmosphere_fx.mouse_filter = Control.MOUSE_FILTER_IGNORE
	atmosphere_fx.z_index = 300 # Overlay everything
	var fx_mat = ShaderMaterial.new()
	fx_mat.shader = VIGNETTE_GRAIN_SHADER
	# Tune for a dark, dusty Roman arena
	fx_mat.set_shader_parameter("tint_color", Color(0.02, 0.015, 0.01, 1.0))
	fx_mat.set_shader_parameter("vignette_strength", 0.52)
	fx_mat.set_shader_parameter("grain_strength", 0.045)
	fx_mat.set_shader_parameter("fog_strength", 0.18)
	fx_mat.set_shader_parameter("dust_strength", 0.12)
	atmosphere_fx.material = fx_mat
	add_child(atmosphere_fx)

	_set_enemy_card_slot_state(-1, "empty")

func _set_enemy_card_slot_state(active_slot: int, state: String) -> void:
	for i in range(enemy_card_slot_labels.size()):
		var lbl := enemy_card_slot_labels[i] as Label
		var panel := enemy_card_slots[i] as PanelContainer
		if lbl == null or panel == null:
			continue
		lbl.text = "?"
		lbl.modulate = Color(0.65, 0.65, 0.65, 0.9)
		panel.modulate = Color(0.35, 0.30, 0.24, 0.95)
		lbl.scale = Vector2.ONE
		lbl.rotation_degrees = 0.0
		lbl.position = Vector2.ZERO
		if i == active_slot:
			match state:
				"facedown":
					lbl.text = "🂠"
					lbl.modulate = Color(0.90, 0.85, 0.72, 1.0)
					panel.modulate = Color(0.55, 0.44, 0.28, 1.0)
				"active":
					lbl.text = "!"
					lbl.modulate = Color(1.0, 0.92, 0.60, 1.0)
					panel.modulate = Color(0.75, 0.52, 0.30, 1.0)
				"persistent":
					lbl.text = "•"
					lbl.modulate = Color(0.88, 0.80, 0.62, 1.0)
					panel.modulate = Color(0.56, 0.44, 0.31, 1.0)
				"known":
					lbl.text = "?"
					lbl.modulate = Color(0.85, 0.82, 0.75, 0.6)
					panel.modulate = Color(0.46, 0.40, 0.34, 0.9)
				_:
					pass

func _animate_enemy_slot_breath(duration_sec: float = 1.0) -> void:
	if skip_enemy_animation:
		return
	var dur := _scaled_time(duration_sec)
	var tw = create_tween()
	tw.set_parallel(true)
	for panel in enemy_card_slots:
		var slot_panel := panel as PanelContainer
		if slot_panel == null:
			continue
		tw.tween_property(slot_panel, "scale", Vector2(1.03, 1.03), dur * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tw.tween_property(slot_panel, "scale", Vector2.ONE, dur * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tw.finished

func _animate_enemy_card_appear(slot_idx: int) -> void:
	if slot_idx < 0 or slot_idx >= enemy_card_slot_labels.size():
		return
	_set_enemy_card_slot_state(slot_idx, "facedown")
	var lbl := enemy_card_slot_labels[slot_idx] as Label
	var panel := enemy_card_slots[slot_idx] as PanelContainer
	if lbl == null or panel == null:
		return
	lbl.position.y = -72
	lbl.rotation_degrees = 20.0
	lbl.scale = Vector2(1.0, 1.0)
	if skip_enemy_animation:
		lbl.position.y = 0.0
		lbl.rotation_degrees = 0.0
		return
	var appear_dur := _scaled_time(0.40)
	var tw = create_tween()
	tw.set_parallel(true)
	tw.tween_property(lbl, "position:y", 0.0, appear_dur).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tw.tween_property(lbl, "rotation_degrees", 0.0, appear_dur).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tw.tween_property(panel, "modulate", Color(0.80, 0.68, 0.40, 1.0), _scaled_time(0.12)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tw.tween_property(panel, "modulate", Color(0.55, 0.44, 0.28, 1.0), _scaled_time(0.20)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	DisplayServer.beep()
	await tw.finished

func _animate_enemy_card_flip(slot_idx: int) -> void:
	if slot_idx < 0 or slot_idx >= enemy_card_slot_labels.size():
		return
	var lbl := enemy_card_slot_labels[slot_idx] as Label
	if lbl == null:
		return
	if skip_enemy_animation:
		lbl.text = "⚔"
		lbl.modulate = Color(1.0, 0.92, 0.60, 1.0)
		return
	var tw = create_tween()
	tw.tween_property(lbl, "scale:x", 0.05, _scaled_time(0.10)).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await tw.finished
	lbl.text = "⚔"
	lbl.modulate = Color(1.0, 0.92, 0.60, 1.0)
	var tw2 = create_tween()
	tw2.tween_property(lbl, "scale:x", 1.0, _scaled_time(0.10)).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	DisplayServer.beep()
	await tw2.finished

func _animate_enemy_card_to_battlefield(slot_idx: int, should_persist: bool) -> void:
	if slot_idx < 0 or slot_idx >= enemy_card_slot_labels.size():
		return
	var source_lbl := enemy_card_slot_labels[slot_idx] as Label
	if source_lbl == null:
		return
	var ghost = Label.new()
	ghost.text = source_lbl.text
	ghost.add_theme_font_size_override("font_size", 36)
	ghost.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ghost.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	ghost.custom_minimum_size = Vector2(100, 140)
	ghost.z_index = 80
	add_child(ghost)
	ghost.global_position = source_lbl.get_global_rect().position
	if skip_enemy_animation:
		if should_persist:
			_set_enemy_card_slot_state(slot_idx, "persistent")
		else:
			_set_enemy_card_slot_state(slot_idx, "empty")
		ghost.queue_free()
		return

	var target_center = play_target_marker.get_global_rect().get_center()
	var target_pos = target_center - Vector2(50, 70)
	var tw = create_tween()
	tw.set_parallel(true)
	tw.tween_property(ghost, "global_position", target_pos, _scaled_time(0.30)).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tw.tween_property(ghost, "scale", Vector2(1.25, 1.25), _scaled_time(0.30)).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await tw.finished

	if should_persist:
		_set_enemy_card_slot_state(slot_idx, "persistent")
	else:
		var fade = create_tween()
		fade.tween_property(ghost, "modulate:a", 0.0, _scaled_time(0.20)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		await fade.finished
		_set_enemy_card_slot_state(slot_idx, "empty")
	ghost.queue_free()

func _refresh_target_display() -> void:
	if enemy_target_reticle_label == null:
		return
	var idx := _get_selected_enemy()
	if idx >= 0 and idx < enemies.size():
		var e: Dictionary = enemies[idx]
		var hp := int(e.get("hp", 0))
		var max_hp := int(e.get("max_hp", hp))
		var armor := int(e.get("armor", 0))
		enemy_target_reticle_label.text = "◉ %s" % str(e.get("name", "Enemy"))
		enemy_target_reticle_label.tooltip_text = "HP %d/%d  ARM %d" % [hp, max_hp, armor]
		
		# Juice: slight pulse on text when selection changes
		var pulse = create_tween()
		pulse.tween_property(enemy_target_reticle_label, "scale", Vector2(1.1, 1.1), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		pulse.tween_property(enemy_target_reticle_label, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	else:
		enemy_target_reticle_label.text = "◉"
		enemy_target_reticle_label.tooltip_text = "No target selected"

func _apply_selection_glow(panel: Control, active: bool, color_mode: int = 0) -> void:
	if panel == null:
		return
	if not active:
		panel.material = null
		return
	
	var mat := ShaderMaterial.new()
	mat.shader = GLOW_RIM_SHADER
	# Gold/Warm for selection, Red/Blood for danger, Blue/Cold for friendly focus
	var rim_col: Color = UI_ACCENT_WARM
	match color_mode:
		1: rim_col = Color(0.92, 0.28, 0.28, 1.0) # Danger/Target
		2: rim_col = UI_ACCENT_COLD # Focus/Friendly
	
	mat.set_shader_parameter("rim_color", rim_col)
	mat.set_shader_parameter("glow_strength", 1.2)
	mat.set_shader_parameter("pulse_speed", 2.2)
	mat.set_shader_parameter("pulse_amount", 0.15)
	mat.set_shader_parameter("rim_width", 0.12)
	mat.set_shader_parameter("inner_glow", 0.08)
	panel.material = mat

func _update_enemy_selection_highlight() -> void:
	var selected_idx := _get_selected_enemy()
	for i in range(enemy_party_cards.size()):
		var panel := enemy_party_cards[i].get("panel") as Control
		if panel == null:
			continue
		
		var is_selected: bool = (i == selected_idx)
		_apply_selection_glow(panel, is_selected, 0) # Use Gold for selection
		
		if not is_selected:
			var alive: bool = (i < enemies.size() and enemies[i].get("hp", 0) > 0)
			panel.modulate = Color(1.0, 1.0, 1.0, 1.0) if alive else Color(0.72, 0.72, 0.72, 0.9)

func _set_enemy_target_highlight(active: bool, valid: bool = true) -> void:
	if enemy_target_reticle_label:
		if active:
			enemy_target_reticle_label.modulate = Color(1.0, 0.45, 0.45, 1.0) if valid else Color(0.60, 0.60, 0.60, 0.90)
			enemy_target_reticle_label.mouse_default_cursor_shape = Control.CURSOR_CROSS if valid else Control.CURSOR_FORBIDDEN
			var pulse = create_tween()
			pulse.tween_property(enemy_target_reticle_label, "scale", Vector2(1.15, 1.15), 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			pulse.tween_property(enemy_target_reticle_label, "scale", Vector2.ONE, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		else:
			enemy_target_reticle_label.modulate = Color(1, 1, 1, 1)
			enemy_target_reticle_label.scale = Vector2.ONE
			enemy_target_reticle_label.mouse_default_cursor_shape = Control.CURSOR_ARROW
	
	var target_idx := _get_target_enemy()
	for i in range(enemy_party_cards.size()):
		var enemy_panel := enemy_party_cards[i].get("panel") as Control
		if enemy_panel == null:
			continue
		
		# Only apply targeted glow to the specific target or all if multi-target
		if active and valid and i == target_idx:
			_apply_selection_glow(enemy_panel, true, 1) # Red Danger Glow
		elif not active:
			# Restore selection highlight if it was selected
			var is_selected: bool = (i == _get_selected_enemy())
			_apply_selection_glow(enemy_panel, is_selected, 0)

func _start_turn() -> void:
	if combat_over:
		return
	turn_undo_stack.clear()
	_update_undo_state()
	_set_enemy_card_slot_state(-1, "empty")
	command_points = max_command_points
	last_ui_command_points = command_points  # Reset animation tracker
	if turn == 1 and gear_start_cp_bonus > 0:
		command_points += gear_start_cp_bonus
		last_ui_command_points = command_points
	var draw_count = BASE_TURN_DRAW
	draw_count += gear_draw_per_turn_bonus
	if turn == 1 and opening_draw_bonus > 0:
		draw_count += opening_draw_bonus
	if turn == 1 and gear_opening_draw_bonus > 0:
		draw_count += gear_opening_draw_bonus
	_draw_cards(draw_count)
	_update_all_ui()
	_log("--- Turn %d --- Draw %d cards. CP restored to %d." % [turn, draw_count, command_points])
	# Kara: Tracker — reveal enemy damage intent at turn start
	if _has_lt_trait("Tracker"):
		var intents: Array[String] = []
		for enemy in enemies:
			if int(enemy.get("hp", 0)) > 0:
				intents.append("%s (%d dmg)" % [str(enemy.get("name", "?")), int(enemy.get("damage", 0))])
		if not intents.is_empty():
			_log("Kara's Tracker: Enemies this turn — %s" % ", ".join(intents))

func _draw_cards(n: int) -> void:
	for i in range(n):
		if hand.size() >= MAX_HAND_SIZE:
			break
		if deck.is_empty():
			if discard_pile.is_empty():
				break
			deck = discard_pile.duplicate()
			discard_pile.clear()
			deck.shuffle()
			_log("Deck reshuffled!")
		if not deck.is_empty():
			hand.append(deck.pop_front())

func _update_hand_ui() -> void:
	for child in hand_container.get_children():
		child.queue_free()

	for i in range(hand.size()):
		var card_id = hand[i]
		var card_data = CardManager.get_card(card_id)
		if card_data.is_empty():
			continue

		var cost = card_data.get("cost", 1)
		var can_play = (cost <= command_points)

		var card_view: Control = CARD_DISPLAY_SCRIPT.new()
		card_view.custom_minimum_size = Vector2(124, 186)
		card_view.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		card_view.call("set_card_size", Vector2(124, 186))
		card_view.call("set_card", card_id)
		card_view.tooltip_text = "%s\nCost: %d\n%s" % [card_data.get("name", "?"), cost, _get_card_desc(card_data)]
		card_view.set_meta("can_play", can_play)
		card_view.set_meta("hover_card_id", card_id)
		if not can_play or combat_over:
			card_view.modulate = Color(0.72, 0.72, 0.72, 0.9)

		card_view.get_signal_connection_list("mouse_entered")
		card_view.mouse_entered.connect(_on_card_hover_entered.bind(card_view))
		card_view.mouse_exited.connect(_on_card_hover_exited.bind(card_view))
		card_view.connect("card_pressed", _on_card_pressed.bind(i, card_view))

		# Setup for slide-in animation
		card_view.modulate.a = 0.0
		card_view.position.y += 24.0

		hand_container.add_child(card_view)

	_apply_hand_fan()

	# Animate card draw with staggered entrance
	var children = hand_container.get_children()
	for idx in range(children.size()):
		var card = children[idx]
		var delay = idx * 0.05 * _scaled_time(1.0)
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(card, "modulate:a", 1.0, _scaled_time(0.20)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_delay(delay)
		tween.tween_property(card, "position:y", card.position.y - 24.0, _scaled_time(0.20)).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_delay(delay)

func _get_card_desc(data: Dictionary) -> String:
	var type = data.get("type", "")
	match type:
		"attack":
			var dmg = data.get("damage", 0)
			var eff = data.get("effect", "none")
			var total_dmg = _get_total_attack_damage(int(dmg))
			var s = "⚔ %d dmg" % total_dmg
			if "poison" in eff:
				s += " + poison"
			return s
		"defense":
			return "🛡 +%d armor" % data.get("armor", 0)
		"support":
			var heal = data.get("heal", 0)
			if heal > 0:
				return "💚 heal %d HP" % heal
			return "✨ " + data.get("effect", "")
		_:
			return data.get("effect", type)

func _apply_hand_fan() -> void:
	var card_count = hand_container.get_child_count()
	if card_count == 0:
		return

	var mid = float(card_count - 1) * 0.5
	for i in range(card_count):
		var card := hand_container.get_child(i) as Control
		if card == null:
			continue
		var rot = 0.0
		if card_count > 1:
			rot = ((float(i) - mid) / mid) * HAND_FAN_MAX_DEGREES
		card.set_meta("base_rot", rot)
		card.pivot_offset = Vector2(card.size.x * 0.5, card.size.y)
		card.rotation_degrees = rot
		card.position.y = 0.0
		card.scale = Vector2.ONE

func _on_card_hover_entered(card_btn: Control) -> void:
	if card_btn == null:
		return
	if card_popup_hide_timer and not card_popup_hide_timer.is_stopped():
		card_popup_hide_timer.stop()
	var can_play := bool(card_btn.get_meta("can_play", true))
	if card_btn.has_method("set_hovered"):
		card_btn.call("set_hovered", true)
	card_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_set_enemy_target_highlight(true, can_play)
	_show_card_popup(card_btn, str(card_btn.get_meta("hover_card_id", "")))
	card_btn.z_index = 10
	card_btn.pivot_offset = Vector2(card_btn.size.x * 0.5, card_btn.size.y)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(card_btn, "position:y", -CARD_HOVER_LIFT_PX, CARD_HOVER_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(card_btn, "scale", Vector2(1.08, 1.08), CARD_HOVER_TIME).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(card_btn, "rotation_degrees", 0.0, CARD_HOVER_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_card_hover_exited(card_btn: Control) -> void:
	if card_btn == null:
		return
	if card_btn.has_method("set_hovered"):
		card_btn.call("set_hovered", false)
	_set_enemy_target_highlight(false, true)
	if card_popup_hide_timer:
		card_popup_hide_timer.start()
	var base_rot = float(card_btn.get_meta("base_rot", 0.0))
	card_btn.z_index = 0
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(card_btn, "position:y", 0.0, CARD_HOVER_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(card_btn, "scale", Vector2.ONE, CARD_HOVER_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(card_btn, "rotation_degrees", base_rot, CARD_HOVER_TIME).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _show_hover_tooltip(card_btn: Control, text: String) -> void:
	if hover_tooltip_panel == null or hover_tooltip_label == null:
		return
	hover_tooltip_label.text = text
	var card_rect := card_btn.get_global_rect()
	var pos := Vector2(card_rect.position.x + 14.0, card_rect.position.y - 96.0)
	var viewport_size := get_viewport_rect().size
	pos.x = clamp(pos.x, 8.0, viewport_size.x - 300.0)
	pos.y = clamp(pos.y, 8.0, viewport_size.y - 100.0)
	hover_tooltip_panel.global_position = pos
	hover_tooltip_panel.visible = true
	var tw = create_tween()
	tw.tween_property(hover_tooltip_panel, "modulate:a", 1.0, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _hide_hover_tooltip() -> void:
	if hover_tooltip_panel == null:
		return
	var tw = create_tween()
	tw.tween_property(hover_tooltip_panel, "modulate:a", 0.0, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tw.finished
	hover_tooltip_panel.visible = false

func _show_card_popup(card_btn: Control, card_id: String) -> void:
	if card_popup_panel == null or hover_card_display == null or card_id.is_empty():
		return
	if card_popup_tween != null:
		card_popup_tween.kill()
	var is_same_card := last_popup_card_id == card_id and card_popup_panel.visible
	last_popup_card_id = card_id
	if not is_same_card:
		hover_card_display.call("set_card", card_id)
		var card_data := CardManager.get_card(card_id)
		var effect_desc := _get_card_desc(card_data)
		if hover_effect_label != null:
			hover_effect_label.text = "" if (effect_desc == "" or effect_desc == "none") else effect_desc
			hover_effect_label.visible = hover_effect_label.text != ""
	var card_rect := card_btn.get_global_rect()
	var viewport_size := get_viewport_rect().size
	var panel_w := 176.0
	var panel_h := 300.0
	var pos := Vector2(
		card_rect.position.x - (panel_w * 0.5) + (card_rect.size.x * 0.5),
		card_rect.position.y - panel_h - 12.0
	)
	pos.x = clamp(pos.x, 8.0, viewport_size.x - panel_w - 8.0)
	pos.y = clamp(pos.y, 8.0, viewport_size.y - panel_h - 8.0)
	card_popup_panel.global_position = pos
	card_popup_panel.visible = true
	if is_same_card and card_popup_panel.modulate.a > 0.0:
		return
	card_popup_panel.modulate.a = 0.0
	card_popup_tween = create_tween()
	card_popup_tween.tween_property(card_popup_panel, "modulate:a", 1.0, 0.10).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _hide_card_popup() -> void:
	if card_popup_panel == null:
		return
	if card_popup_tween != null:
		card_popup_tween.kill()
	card_popup_tween = create_tween()
	card_popup_tween.tween_property(card_popup_panel, "modulate:a", 0.0, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	card_popup_tween.finished.connect(func() -> void:
		card_popup_panel.visible = false
		last_popup_card_id = ""
	)

func _animate_hand_reflow(removed_idx: int) -> void:
	var moved := false
	var tw: Tween = null
	for i in range(hand_container.get_child_count()):
		if i <= removed_idx:
			continue
		var card := hand_container.get_child(i) as Control
		if card == null:
			continue
		if tw == null:
			tw = create_tween()
			tw.set_parallel(true)
		moved = true
		tw.tween_property(card, "position:x", card.position.x - HAND_REFLOW_SHIFT, HAND_REFLOW_TIME).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	if moved and tw != null:
		await tw.finished

func _toggle_turn_log() -> void:
	turn_log_collapsed = not turn_log_collapsed
	_apply_turn_log_state()

func _apply_turn_log_state() -> void:
	if turn_log_label:
		turn_log_label.visible = not turn_log_collapsed
	if turn_log_toggle_btn:
		turn_log_toggle_btn.text = "TURN LOG  \\/" if turn_log_collapsed else "TURN LOG  /\\"
	if turn_log_panel:
		turn_log_panel.offset_top = -56 if turn_log_collapsed else -180

func _refresh_turn_log() -> void:
	if turn_log_label == null:
		return
	var start_idx: int = maxi(0, _log_lines.size() - 5)
	var lines: Array = []
	for i in range(start_idx, _log_lines.size()):
		lines.append("T%d • %s" % [turn, _log_lines[i]])
	turn_log_label.text = "\n".join(lines)

func _enemy_stat_tooltip(idx: int) -> String:
	if idx < 0 or idx >= enemies.size():
		return ""
	var e = enemies[idx]
	return "%s\nHP: %d/%d\nArmor: %d\nDamage: %d\nPoison: %d\nVeteran Warrior" % [
		e.get("name", "Enemy"),
		e.get("hp", 0),
		e.get("max_hp", 0),
		e.get("armor", 0),
		e.get("damage", 0),
		e.get("poison", 0)
	]

func _on_enemy_stat_hover_entered(target_control: Control, enemy_idx: int) -> void:
	if target_control == null:
		return
	_show_hover_tooltip(target_control, _enemy_stat_tooltip(enemy_idx))

func _on_enemy_stat_hover_exited() -> void:
	_hide_hover_tooltip()

func _on_unit_plate_hover_entered(target_panel: Control, side: String, slot_idx: int) -> void:
	if target_panel == null:
		return
	var tooltip_text: String = ""
	if side == "enemy":
		tooltip_text = "Empty Enemy Slot" if slot_idx >= enemies.size() else _enemy_stat_tooltip(slot_idx)
	else:
		tooltip_text = _player_stat_tooltip(slot_idx)
	_show_hover_tooltip(target_panel, tooltip_text)
	var tw = create_tween()
	tw.set_parallel(true)
	tw.tween_property(target_panel, "scale", Vector2(1.02, 1.02), 0.10).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tw.tween_property(target_panel, "modulate", Color(1.08, 1.06, 1.02, 1.0), 0.10).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_unit_plate_hover_exited(target_panel: Control) -> void:
	_hide_hover_tooltip()
	if target_panel == null:
		return
	var tw = create_tween()
	tw.set_parallel(true)
	tw.tween_property(target_panel, "scale", Vector2.ONE, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tw.tween_property(target_panel, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _player_stat_tooltip(slot_idx: int) -> String:
	if slot_idx == 0:
		return "CHAMPION\nHP: %d/%d\nArmor: %d\nCP: %d/%d\nWarrior Stance" % [
			champion_hp, champion_max_hp, champion_armor, command_points, max_command_points
		]
	var lt_idx := slot_idx - 1
	if lt_idx < 0 or lt_idx >= lieutenant_states.size() or not lieutenant_states[lt_idx].active:
		return "Empty Lieutenant Slot"
	var lt_state = lieutenant_states[lt_idx]
	var lt_data: Dictionary = CardManager.get_lieutenant(lt_state.name)
	var unit_name := str(lt_data.get("name", lt_state.name)).to_upper()
	return "%s\nHP: %d/%d\nArmor: %d\nTrait: %s" % [
		unit_name,
		lt_state.hp,
		lt_state.max_hp,
		int(lt_data.get("armor", 0)),
		str(lt_data.get("trait", "None"))
	]

func _select_enemy(slot_idx: int) -> void:
	if slot_idx < 0 or slot_idx >= enemies.size():
		return
	if int(enemies[slot_idx].get("hp", 0)) <= 0:
		return
	selected_enemy_idx = slot_idx
	_refresh_target_display()
	_update_enemy_selection_highlight()
	_set_enemy_target_highlight(true, true)

func _on_unit_plate_gui_input(event: InputEvent, side: String, slot_idx: int) -> void:
	var mouse_event: InputEventMouseButton = event as InputEventMouseButton
	if mouse_event == null:
		return
	if side == "enemy" and mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
		_select_enemy(slot_idx)
		return

	var is_right_click := (mouse_event.button_index == MOUSE_BUTTON_RIGHT and mouse_event.pressed)
	var is_left_click_non_enemy := (mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed and side != "enemy")
	var opens_popout := is_right_click or is_left_click_non_enemy
	if not opens_popout:
		return
	var details: String = ""
	if side == "enemy":
		details = "Empty Enemy Slot" if slot_idx >= enemies.size() else _enemy_stat_tooltip(slot_idx)
	else:
		details = _player_stat_tooltip(slot_idx)
	if details == "":
		return
	if unit_popout_label:
		unit_popout_label.text = details
	_show_unit_popout()

func _on_popout_backdrop_input(event: InputEvent) -> void:
	var mouse_event: InputEventMouseButton = event as InputEventMouseButton
	if mouse_event == null:
		return
	if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
		_hide_unit_popout()

func _show_unit_popout() -> void:
	if unit_popout_panel == null:
		return
	if unit_popout_backdrop:
		unit_popout_backdrop.visible = true
	var tw = create_tween()
	tw.set_parallel(true)
	if unit_popout_backdrop:
		tw.tween_property(unit_popout_backdrop, "color:a", 0.50, 0.14).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	unit_popout_panel.visible = true
	tw.tween_property(unit_popout_panel, "modulate:a", 1.0, 0.14).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tw.tween_property(unit_popout_panel, "scale", Vector2.ONE, 0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _hide_unit_popout() -> void:
	if unit_popout_panel == null:
		return
	if not unit_popout_panel.visible:
		return
	var tw = create_tween()
	tw.set_parallel(true)
	if unit_popout_backdrop:
		tw.tween_property(unit_popout_backdrop, "color:a", 0.0, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tw.tween_property(unit_popout_panel, "modulate:a", 0.0, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tw.tween_property(unit_popout_panel, "scale", Vector2(0.95, 0.95), 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tw.finished
	unit_popout_panel.visible = false
	if unit_popout_backdrop:
		unit_popout_backdrop.visible = false

func _scaled_time(base_time: float) -> float:
	if skip_enemy_animation:
		return 0.0
	return max(0.01, base_time / max(0.5, animation_speed))

func _play_card_shortcut(slot_idx: int) -> void:
	if slot_idx < 0 or slot_idx >= hand.size():
		return
	if slot_idx >= hand_container.get_child_count():
		return
	var card_btn := hand_container.get_child(slot_idx) as Control
	if card_btn == null:
		return
	_on_card_pressed(slot_idx, card_btn)

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return
	match key_event.keycode:
		KEY_1:
			_play_card_shortcut(0)
		KEY_2:
			_play_card_shortcut(1)
		KEY_3:
			_play_card_shortcut(2)
		KEY_4:
			_play_card_shortcut(3)
		KEY_5:
			_play_card_shortcut(4)
		KEY_T:
			_on_end_turn()
		KEY_R:
			_on_retreat()
		KEY_ESCAPE:
			_hide_unit_popout()
			_set_enemy_target_highlight(false, true)
			_hide_hover_tooltip()
			_hide_card_popup()
		KEY_SPACE:
			skip_enemy_animation = true
		KEY_MINUS:
			animation_speed = clamp(animation_speed - 0.25, 0.5, 2.0)
			_log("Animation speed: %.2fx" % animation_speed)
		KEY_EQUAL:
			animation_speed = clamp(animation_speed + 0.25, 0.5, 2.0)
			_log("Animation speed: %.2fx" % animation_speed)

func _animate_play_card(card_btn: Control) -> void:
	if card_btn == null:
		return

	var ghost = card_btn.duplicate()
	ghost.custom_minimum_size = card_btn.size
	ghost.size = card_btn.size
	ghost.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ghost.modulate = card_btn.modulate
	ghost.rotation_degrees = card_btn.rotation_degrees
	ghost.scale = card_btn.scale
	ghost.z_index = 40
	add_child(ghost)
	ghost.global_position = card_btn.get_global_rect().position

	card_btn.visible = false

	var target_center = play_target_marker.get_global_rect().get_center()
	var target_pos = target_center - (ghost.size * 0.5)

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(ghost, "global_position", target_pos, CARD_PLAY_MOVE_TIME).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(ghost, "rotation_degrees", 0.0, CARD_PLAY_MOVE_TIME).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(ghost, "scale", Vector2.ONE, CARD_PLAY_MOVE_TIME).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await tween.finished

	var pulse = create_tween()
	pulse.tween_property(ghost, "scale", Vector2(1.12, 1.12), CARD_PLAY_PULSE_TIME * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	pulse.tween_property(ghost, "scale", Vector2.ONE, CARD_PLAY_PULSE_TIME * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await pulse.finished
	var flare = create_tween()
	flare.tween_property(ghost, "modulate", Color(1.0, 0.90, 0.60, 1.0), 0.10).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	flare.tween_property(ghost, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.10).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await flare.finished
	_play_card_sfx()
	ghost.queue_free()

func _play_card_sfx() -> void:
	DisplayServer.beep()

func _get_total_attack_damage(base_damage: int) -> int:
	return max(0, base_damage + gear_flat_damage_bonus)

func _on_card_pressed(card_idx: int, card_btn: Control) -> void:
	if combat_over or card_idx >= hand.size() or is_play_animating:
		return

	var card_id = hand[card_idx]
	var card_data = CardManager.get_card(card_id)
	if card_data.is_empty():
		return

	var cost = card_data.get("cost", 1)
	if cost > command_points:
		_set_enemy_target_highlight(true, false)
		if card_btn.has_method("show_unplayable"):
			card_btn.call("show_unplayable")
		card_btn.tooltip_text = "Insufficient CP\nNeed %d / Have %d" % [cost, command_points]
		_log("Not enough CP! (need %d, have %d)" % [cost, command_points])
		return

	turn_undo_stack.append(_capture_turn_state())
	_update_undo_state()

	is_play_animating = true
	end_turn_btn.disabled = true
	_hide_hover_tooltip()
	_hide_card_popup()
	if card_btn.has_method("set_selected"):
		card_btn.call("set_selected", true)
	if card_btn.has_method("pulse_cost"):
		card_btn.call("pulse_cost")
	await _animate_play_card(card_btn)
	await _animate_hand_reflow(card_idx)

	command_points -= cost
	_execute_card_logic(card_data, _get_target_enemy())

	discard_pile.append(hand[card_idx])
	hand.remove_at(card_idx)

	is_play_animating = false
	if card_btn.has_method("set_selected"):
		card_btn.call("set_selected", false)
	_update_all_ui()
	_check_victory()
	if not combat_over:
		end_turn_btn.disabled = false
	_update_undo_state()

func _execute_card_logic(card_data: Dictionary, target: int) -> void:
	var type = card_data.get("type", "attack")
	var effect = card_data.get("effect", "none")

	match type:
		"attack":
			var dmg = _get_total_attack_damage(int(card_data.get("damage", 0)))
			if target >= 0:
				_deal_damage_to_enemy(target, dmg)
				_spawn_float_text("-%d" % dmg, Color(1.0, 0.26, 0.26, 1.0), _enemy_float_origin(target), 28)
				if "poison" in effect:
					var stacks := _parse_effect_stacks(effect)
					if _has_lt_trait("Toxic"):  # Decimus: all poison +1 stack
						stacks += 1
					_add_poison(target, stacks)

		"defense":
			var armor = card_data.get("armor", 0)
			champion_armor += armor
			_spawn_float_text("+%d Armor" % armor, Color(0.45, 0.76, 1.0, 1.0), _player_float_origin(), 22)
			_log("Champion gained %d armor (total: %d)" % [armor, champion_armor])
			if effect == "team_protect":
				for lt_state in lieutenant_states:
					if lt_state.active:
						lt_state.armor += 4
				_log("All lieutenants gain +4 armor from Team Protect.")

		"support":
			var heal = card_data.get("heal", 0)
			if heal > 0:
				champion_hp = min(champion_max_hp, champion_hp + heal)
				_spawn_float_text("+%d" % heal, Color(0.20, 1.0, 0.45, 1.0), _player_float_origin(), 28)
				_log("Champion healed %d HP (%d/%d)" % [heal, champion_hp, champion_max_hp])
			_apply_support_effect(effect)

		"reaction":
			var react_dmg = _get_total_attack_damage(int(card_data.get("damage", 0)))
			var react_armor = card_data.get("armor", 0)
			if react_dmg > 0:
				if target >= 0:
					_deal_damage_to_enemy(target, react_dmg)
			if react_armor > 0:
				champion_armor += react_armor
				_log("Champion gained %d armor (total: %d)" % [react_armor, champion_armor])

		"area":
			var area_dmg = _get_total_attack_damage(int(card_data.get("damage", 0)))
			for i in range(enemies.size()):
				if enemies[i]["hp"] <= 0:
					continue
				if "poison" in effect:
					var aoe_stacks := _parse_effect_stacks(effect)
					if _has_lt_trait("Toxic"):  # Decimus: all poison +1 stack
						aoe_stacks += 1
					_add_poison(i, aoe_stacks)
				elif area_dmg > 0:
					_deal_damage_to_enemy(i, area_dmg)

		"evasion":
			champion_armor += 3
			_log("Evasion! +3 temp armor to absorb incoming hits.")
			if effect == "evasion_team":
				for lt_state in lieutenant_states:
					if lt_state.active:
						lt_state.armor += 2
				_log("All lieutenants gain +2 armor.")

		"effect":
			_apply_global_effect(effect)

func _parse_effect_stacks(effect: String) -> int:
	var parts = effect.split("_")
	if parts.size() >= 2 and parts[-1].is_valid_int():
		return int(parts[-1])
	return 1

func _add_poison(enemy_idx: int, stacks: int) -> void:
	if enemy_idx < 0 or enemy_idx >= enemies.size():
		return
	if stacks <= 0:
		return
	var enemy: Dictionary = enemies[enemy_idx] as Dictionary
	var before := int(enemy.get("poison", 0))
	var after := clampi(before + stacks, 0, MAX_POISON_STACKS)
	enemy["poison"] = after
	enemies[enemy_idx] = enemy
	_log("%s poisoned (%d → %d stacks)" % [enemy["name"], before, after])

func _get_first_alive_enemy() -> int:
	for i in range(enemies.size()):
		if enemies[i]["hp"] > 0:
			return i
	return -1

func _get_priority_enemy() -> int:
	var idx = -1
	var lowest_hp = 999999
	for i in range(enemies.size()):
		if enemies[i]["hp"] <= 0:
			continue
		var hp = int(enemies[i].get("hp", 0))
		if hp < lowest_hp:
			lowest_hp = hp
			idx = i
	return idx

func _get_selected_enemy() -> int:
	if selected_enemy_idx >= 0 and selected_enemy_idx < enemies.size():
		var enemy: Dictionary = enemies[selected_enemy_idx]
		if int(enemy.get("hp", 0)) > 0:
			return selected_enemy_idx
	return -1

func _get_target_enemy() -> int:
	var chosen := _get_selected_enemy()
	if chosen >= 0:
		return chosen
	return _get_priority_enemy()

func _ensure_valid_enemy_target() -> void:
	if _get_selected_enemy() == -1:
		selected_enemy_idx = _get_priority_enemy()
	_refresh_target_display()
	_update_enemy_selection_highlight()

func _apply_support_effect(effect: String) -> void:
	match effect:
		"resource_regen":
			command_points = min(max_command_points, command_points + 1)
			_log("CP restored +1 (%d/%d)" % [command_points, max_command_points])
		"card_draw":
			_draw_cards(1)
			_log("Drew 1 card from effect.")
		"morale_boost_team":
			champion_hp = min(champion_max_hp, champion_hp + 3)
			for lt_state in lieutenant_states:
				if lt_state.active:
					lt_state.hp = min(lt_state.max_hp, lt_state.hp + 3)
			_log("Morale Boost! All units heal 3 HP.")
		"regen_team":
			champion_hp = min(champion_max_hp, champion_hp + 5)
			for lt_state in lieutenant_states:
				if lt_state.active:
					lt_state.hp = min(lt_state.max_hp, lt_state.hp + 5)
			_log("Team Regen! All units heal 5 HP.")
		"team_buff_all":
			champion_armor += 2
			champion_hp = min(champion_max_hp, champion_hp + 2)
			for lt_state in lieutenant_states:
				if lt_state.active:
					lt_state.armor += 2
					lt_state.hp = min(lt_state.max_hp, lt_state.hp + 2)
			_log("Team Buff! +2 Armor/HP to all units.")
		_:
			pass

func _hazard_active() -> bool:
	if hazard_data.is_empty():
		return false
	var start_turn := int(hazard_data.get("start_turn", 1))
	var duration := int(hazard_data.get("duration", 0))
	if turn < start_turn:
		return false
	if duration > 0 and turn > start_turn + duration - 1:
		return false
	return true

func _log_hazard_intro() -> void:
	if hazard_intro_shown or hazard_data.is_empty():
		return
	var name := str(hazard_data.get("name", "Hazard"))
	var summary := str(hazard_data.get("summary", "Arena hazard is active."))
	_log("%s: %s" % [name, summary])
	hazard_intro_shown = true

func _apply_hazard_tick(reason: String) -> void:
	if not _hazard_active():
		return
	var dmg: int = int(hazard_data.get("damage_per_turn", 0))
	if dmg <= 0:
		return
	var applies_to := str(hazard_data.get("applies_to", "both"))
	var name := str(hazard_data.get("name", "Hazard"))
	if applies_to == "both" or applies_to == "player":
		var absorbed: int = min(champion_armor, dmg)
		champion_armor = max(0, champion_armor - absorbed)
		var actual: int = dmg - absorbed
		champion_hp = max(0, champion_hp - actual)
		_spawn_float_text("-%d" % actual, Color(0.96, 0.48, 0.38, 1.0), _player_float_origin(), 22)
	if applies_to == "both" or applies_to == "enemies":
		for i in range(enemies.size()):
			if enemies[i]["hp"] <= 0:
				continue
			enemies[i]["hp"] = max(0, enemies[i]["hp"] - dmg)
			_spawn_float_text("-%d" % dmg, Color(0.96, 0.78, 0.38, 1.0), _enemy_float_origin(i), 22)
	_log("%s deals %d damage (%s turn)" % [name, dmg, reason])

func _apply_global_effect(effect: String) -> void:
	match effect:
		"reflect_damage":
			champion_armor += 2
			_log("Curse of Thorns active: +2 armor.")
		"reflect_thorns":
			reflect_ratio = 0.5
			reflect_turns = 2
			_log("Thorns active: 50% damage reflected for 2 turns.")
		"fear":
			for i in range(enemies.size()):
				if enemies[i]["hp"] > 0:
					enemies[i]["damage"] = max(0, enemies[i].get("damage", 0) - 1)
			_log("Intimidate! Enemy damage reduced by 1 this turn.")
		"morale_boost_team":
			champion_hp = min(champion_max_hp, champion_hp + 3)
			for lt_state in lieutenant_states:
				if lt_state.active:
					lt_state.hp = min(lt_state.max_hp, lt_state.hp + 3)
			_log("Morale Boost! All units heal 3 HP.")
		"bless_team":
			champion_armor += 3
			for lt_state in lieutenant_states:
				if lt_state.active:
					lt_state.armor += 3
			_log("Blessing! +3 Armor to all units.")
		_:
			_log("Effect: %s applied." % effect)

func _deal_damage_to_enemy(idx: int, amount: int) -> void:
	if idx < 0 or idx >= enemies.size():
		return
	var enemy: Dictionary = enemies[idx] as Dictionary
	var absorbed: int = min(enemy.get("armor", 0), amount)
	enemy["armor"] = max(0, enemy.get("armor", 0) - absorbed)
	var actual: int = amount - absorbed
	enemy["hp"] = max(0, enemy["hp"] - actual)
	_log("Hit %s for %d dmg (%d armor) → %d/%d HP" % [enemy["name"], actual, absorbed, enemy["hp"], enemy["max_hp"]])
	
	if idx >= 0 and idx < enemy_party_cards.size():
		var enemy_panel := enemy_party_cards[idx].get("panel") as Control
		if enemy_panel:
			_flash_panel(enemy_panel, Color(1.0, 0.90, 0.85, 1.0))
			_shake_ui(4.5, 0.2)
			var recoil = create_tween()
			recoil.tween_property(enemy_panel, "position:x", 8.0, 0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			recoil.tween_property(enemy_panel, "position:x", 0.0, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	if idx == _get_selected_enemy() and enemy["hp"] <= 0:
		_ensure_valid_enemy_target()

func _flash_panel(panel: Control, color: Color = Color.WHITE) -> void:
	if panel == null or panel.material == null:
		return
	var mat := panel.material as ShaderMaterial
	if mat == null:
		return
	
	mat.set_shader_parameter("flash_color", color)
	var tw = create_tween()
	tw.tween_method(func(v: float): mat.set_shader_parameter("flash_intensity", v), 1.0, 0.0, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _shake_ui(intensity: float = 6.0, duration: float = 0.25) -> void:
	# Shake the main vbox for a global "hit" feel
	var main_vbox = get_child(1) as Control
	if main_vbox:
		_shake_element(main_vbox, duration, intensity)

func _on_end_turn_btn_entered() -> void:
	if end_turn_btn.disabled or combat_over:
		return
	var tw = create_tween()
	tw.set_parallel(true)
	tw.tween_property(end_turn_btn, "modulate", Color(1.0, 1.0, 0.7, 1.0), 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tw.tween_property(end_turn_btn, "scale", Vector2(1.05, 1.05), 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_end_turn_btn_exited() -> void:
	if end_turn_btn.disabled or combat_over:
		return
	var tw = create_tween()
	tw.set_parallel(true)
	tw.tween_property(end_turn_btn, "modulate", Color.WHITE, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tw.tween_property(end_turn_btn, "scale", Vector2.ONE, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)


func _apply_button_press_bounce(btn: Button) -> void:
	btn.pressed.connect(func() -> void:
		var tween := create_tween()
		tween.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(btn, "scale", Vector2(0.95, 0.95), 0.1)
		tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.2)
	)


func _shake_element(element: Control, duration: float = 0.3, intensity: float = 3.0) -> void:
	if element == null:
		return
	var original_pos := element.position
	var elapsed := 0.0
	while elapsed < duration:
		var offset := Vector2(randf_range(-intensity, intensity), randf_range(-intensity * 0.5, intensity * 0.5))
		element.position = original_pos + offset
		elapsed += get_physics_process_delta_time()
		await get_tree().process_frame
	element.position = original_pos


func _on_end_turn() -> void:
	if combat_over or is_play_animating:
		return

	_log_hazard_intro()
	turn_undo_stack.clear()
	_update_undo_state()
	end_turn_btn.disabled = true
	await _animate_enemy_slot_breath(1.0)

	# Process poison on enemies
	for i in range(enemies.size()):
		var enemy = enemies[i]
		if enemy["hp"] > 0 and enemy.get("poison", 0) > 0:
			var poison_dmg = enemy["poison"]
			enemy["hp"] = max(0, enemy["hp"] - poison_dmg)
			enemy["poison"] = max(0, enemy["poison"] - 1)
			_log("%s takes %d poison damage → %d HP" % [enemy["name"], poison_dmg, enemy["hp"]])
	_ensure_valid_enemy_target()

	_check_victory()
	if combat_over:
		return

	_log("--- ENEMY TURN ---")
	if enemy_portrait_panel_ref:
		var flash = create_tween()
		flash.tween_property(enemy_portrait_panel_ref, "modulate", Color(1.0, 0.72, 0.72, 1.0), 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		flash.tween_property(enemy_portrait_panel_ref, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	if not skip_enemy_animation:
		await get_tree().create_timer(_scaled_time(0.55)).timeout
	var slot_idx = 0
	for i in range(enemies.size()):
		var enemy: Dictionary = enemies[i] as Dictionary
		if enemy["hp"] <= 0:
			continue
		var active_slot = min(slot_idx, ENEMY_SLOT_COUNT - 1)
		var action := _get_enemy_action(enemy)
		var intent_text := _enemy_intent_text(enemy, action)
		_set_enemy_card_slot_state(active_slot, "known")
		var tele_lbl := enemy_card_slot_labels[active_slot] as Label
		if tele_lbl:
			tele_lbl.text = intent_text
		if not skip_enemy_animation:
			await get_tree().create_timer(_scaled_time(0.30)).timeout
		await _animate_enemy_card_appear(active_slot)
		await _animate_enemy_card_flip(active_slot)
		_set_enemy_card_slot_state(active_slot, "active")
		await _enemy_take_turn(i, action, active_slot)
		await _animate_enemy_card_to_battlefield(active_slot, true)
		if not skip_enemy_animation:
			await get_tree().create_timer(_scaled_time(0.45)).timeout
		slot_idx += 1

		if champion_hp <= 0:
			_on_defeat()
			return

	if reflect_turns > 0:
		reflect_turns = max(0, reflect_turns - 1)

	_apply_hazard_tick("end of round")
	if champion_hp <= 0:
		_on_defeat()
		return
	_check_victory()
	if combat_over:
		return

	turn += 1
	_start_turn()
	end_turn_btn.disabled = false
	skip_enemy_animation = false

func _capture_turn_state() -> Dictionary:
	var enemies_snapshot: Array = []
	for enemy in enemies:
		if enemy is Dictionary:
			enemies_snapshot.append((enemy as Dictionary).duplicate(true))
	var lt_states_save = []
	for lt_state in lieutenant_states:
		lt_states_save.append({"name": lt_state.name, "hp": lt_state.hp, "max_hp": lt_state.max_hp, "armor": lt_state.armor, "active": lt_state.active})
	return {
		"champion_hp": champion_hp,
		"champion_max_hp": champion_max_hp,
		"champion_armor": champion_armor,
		"lieutenant_states": lt_states_save,
		"enemies": enemies_snapshot,
		"hand": hand.duplicate(true),
		"deck": deck.duplicate(true),
		"discard_pile": discard_pile.duplicate(true),
		"command_points": command_points,
		"last_ui_command_points": last_ui_command_points,
		"max_command_points": max_command_points,
		"turn": turn,
		"combat_over": combat_over,
		"player_won": player_won,
		"log_lines": _log_lines.duplicate(true),
		"selected_enemy_idx": selected_enemy_idx,
	}

func _restore_turn_state(state: Dictionary) -> void:
	champion_hp = int(state.get("champion_hp", champion_hp))
	champion_max_hp = int(state.get("champion_max_hp", champion_max_hp))
	champion_armor = int(state.get("champion_armor", champion_armor))
	lieutenant_states.clear()
	var lt_states_data = state.get("lieutenant_states", [])
	for lt_data in lt_states_data:
		var lt_state = LTCombatState.new(
			str(lt_data.get("name", "")),
			int(lt_data.get("hp", 0)),
			int(lt_data.get("max_hp", 0)),
			int(lt_data.get("armor", 0)),
			bool(lt_data.get("active", false))
		)
		lieutenant_states.append(lt_state)
	enemies = (state.get("enemies", enemies) as Array).duplicate(true)
	hand = (state.get("hand", hand) as Array).duplicate(true)
	deck = (state.get("deck", deck) as Array).duplicate(true)
	discard_pile = (state.get("discard_pile", discard_pile) as Array).duplicate(true)
	command_points = int(state.get("command_points", command_points))
	last_ui_command_points = int(state.get("last_ui_command_points", last_ui_command_points))
	max_command_points = int(state.get("max_command_points", max_command_points))
	turn = int(state.get("turn", turn))
	combat_over = bool(state.get("combat_over", combat_over))
	player_won = bool(state.get("player_won", player_won))
	_log_lines = (state.get("log_lines", _log_lines) as Array).duplicate(true)
	selected_enemy_idx = int(state.get("selected_enemy_idx", selected_enemy_idx))


# ══════════════════════════════════════════════════════════════════════════════
# ENEMY ACTION HELPERS (boss scripting, telegraphs, damage resolution)
# ══════════════════════════════════════════════════════════════════════════════

func _get_enemy_action(enemy: Dictionary) -> Dictionary:
	var acts: Array = enemy.get("scripted_actions", [])
	if acts is Array and acts.size() > 0:
		var idx: int = wrapi(turn - 1, 0, acts.size())
		var act: Dictionary = acts[idx] as Dictionary
		if act is Dictionary:
			return act
	return {}


func _enemy_intent_text(enemy: Dictionary, action: Dictionary) -> String:
	if action.is_empty():
		return "⚔%d" % int(enemy.get("damage", 2))
	var hits: int = int(action.get("hits", 1))
	var dmg: int = int(action.get("damage", enemy.get("damage", 2)))
	var is_true: bool = bool(action.get("true_damage", false))
	var icon: String = "✦" if is_true else "⚔"
	if hits > 1:
		return "%s%dx%d" % [icon, hits, dmg]
	return "%s%d" % [icon, dmg]


func _enemy_take_turn(enemy_idx: int, action: Dictionary, _slot_idx: int) -> void:
	var enemy: Dictionary = enemies[enemy_idx] as Dictionary
	var name: String = str(action.get("name", enemy.get("name", "Enemy")))
	var hits: int = max(1, int(action.get("hits", 1)))
	var dmg: int = int(action.get("damage", enemy.get("damage", 2)))
	var armor_shred: int = int(action.get("armor_shred", 0))
	var lifesteal: int = int(action.get("lifesteal", 0))
	var true_damage: bool = bool(action.get("true_damage", false))

	if armor_shred > 0:
		var before_armor := champion_armor
		champion_armor = max(0, champion_armor - armor_shred)
		_log("%s shreds %d armor (%d → %d)" % [name, armor_shred, before_armor, champion_armor])

	var total_actual := 0
	for hit in range(hits):
		var actual := _apply_enemy_hit(dmg, true_damage, name, hit, hits)
		total_actual += actual
		if reflect_ratio > 0.0 and reflect_turns > 0 and actual > 0:
			var reflected: int = maxi(1, int(ceil(float(actual) * reflect_ratio)))
			enemy["hp"] = max(0, enemy["hp"] - reflected)
			_spawn_float_text("-%d" % reflected, Color(0.72, 0.92, 1.0, 1.0), _enemy_float_origin(enemy_idx), 24)
			_log("Thorns reflect %d dmg back to %s" % [reflected, name])
		if champion_hp <= 0:
			enemies[enemy_idx] = enemy
			return

	if lifesteal > 0 and total_actual > 0:
		var before_hp := int(enemy.get("hp", 0))
		enemy["hp"] = min(int(enemy.get("max_hp", before_hp)), before_hp + lifesteal)
		_log("%s siphons %d HP (lifesteal) → %d/%d" % [name, lifesteal, enemy["hp"], enemy.get("max_hp", enemy["hp"])])

	enemies[enemy_idx] = enemy


func _apply_enemy_hit(dmg: int, true_damage: bool, name: String, hit_idx: int, total_hits: int) -> int:
	var absorbed: int = 0
	if not true_damage:
		absorbed = min(champion_armor, dmg)
		champion_armor = max(0, champion_armor - absorbed)
	var actual: int = dmg - absorbed
	champion_hp = max(0, champion_hp - actual)
	var label := "Hit %d/%d" % [hit_idx + 1, total_hits] if total_hits > 1 else "Attack"
	var tag := "%s (%s)" % [name, label]
	var color := Color(1.0, 0.24, 0.24, 1.0)
	_spawn_float_text("-%d" % actual, color, _player_float_origin(), 28)
	_log("%s deals %d dmg%s → Champion: %d/%d HP (armor -%d)" % [
		tag,
		actual,
		" true" if true_damage else "",
		champion_hp,
		champion_max_hp,
		absorbed
	])
	return actual
	_ensure_valid_enemy_target()

func _on_undo_pressed() -> void:
	if is_play_animating or turn_undo_stack.is_empty() or combat_over:
		return
	var previous: Dictionary = turn_undo_stack.pop_back()
	_restore_turn_state(previous)
	end_turn_btn.disabled = false
	_update_all_ui()
	_set_enemy_target_highlight(false, true)
	_update_undo_state()

func _update_undo_state() -> void:
	if undo_btn == null:
		return
	undo_btn.disabled = turn_undo_stack.is_empty() or is_play_animating or combat_over

func _check_victory() -> void:
	var all_dead = true
	for enemy in enemies:
		if enemy["hp"] > 0:
			all_dead = false
			break

	if all_dead:
		_on_victory()

func _on_victory() -> void:
	combat_over = true
	player_won = true
	_log("=== VICTORY! All enemies defeated! ===")
	# Julia: Hope — heal +5 HP after every victory
	if _has_lt_trait("Hope"):
		champion_hp = min(champion_max_hp, champion_hp + 5)
		_spawn_float_text("+5", Color(0.20, 1.0, 0.45, 1.0), _player_float_origin(), 28)
		_log("Julia's Hope: +5 HP restored after victory.")
	_update_all_ui()

	MissionManager.complete_mission(current_mission_id, "victory")
	var reward_text = MissionManager.get_last_reward_text()
	if reward_text != "":
		_log(reward_text)

	end_turn_btn.text = "CONTINUE →"
	end_turn_btn.disabled = false
	end_turn_btn.pressed.disconnect(_on_end_turn)
	end_turn_btn.pressed.connect(_on_continue_after_combat)

func _on_defeat() -> void:
	combat_over = true
	player_won = false
	_log("=== DEFEAT! Champion has fallen! ===")
	MissionManager.complete_mission(current_mission_id, "defeat")
	_update_all_ui()
	end_turn_btn.text = "BACK TO MENU"
	end_turn_btn.disabled = false
	end_turn_btn.pressed.disconnect(_on_end_turn)
	end_turn_btn.pressed.connect(_on_back_to_menu)

func _on_retreat() -> void:
	if combat_over:
		return
	_log("Retreating from combat...")
	MissionManager.complete_mission(current_mission_id, "retreat")
	get_tree().change_scene_to_file("res://scenes/MainHub.tscn")

func _on_continue_after_combat() -> void:
	get_tree().change_scene_to_file("res://scenes/MainHub.tscn")

func _on_back_to_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _get_enemy_display(i: int) -> String:
	var e = enemies[i]
	if e["hp"] <= 0:
		return "%s  [DEFEATED]" % e["name"]
	var poison_str = ""
	if e.get("poison", 0) > 0:
		poison_str = "  ☠%d" % e["poison"]
	return "%s  HP %d/%d  ARM %d%s" % [e["name"], e["hp"], e["max_hp"], e.get("armor", 0), poison_str]

func _set_unit_card_ui(card: Dictionary, unit_name: String, hp: int, max_hp: int, armor: int, active: bool) -> void:
	if card.is_empty():
		return
	var panel := card.get("panel") as Control
	var name_label := card.get("name_label") as Label
	var hp_bar := card.get("hp_bar") as ProgressBar
	var stats_label := card.get("stats_label") as Label
	if panel == null or name_label == null or hp_bar == null or stats_label == null:
		return
	panel.modulate = Color(1.0, 1.0, 1.0, 1.0) if active else Color(0.72, 0.72, 0.72, 0.9)
	name_label.text = unit_name
	var safe_max := maxi(1, max_hp)
	hp_bar.max_value = safe_max
	var safe_hp: int = clampi(hp, 0, safe_max)
	hp_bar.value = safe_hp
	var hp_ratio: float = float(safe_hp) / float(safe_max)
	hp_bar.modulate = Color(1.0, 0.42, 0.42, 1.0).lerp(Color(0.46, 0.96, 0.54, 1.0), hp_ratio)
	stats_label.text = "HP %d/%d  A%d" % [max(0, hp), safe_max, max(0, armor)]
	if hp <= 0 and active:
		name_label.text += " [DOWN]"

func _update_enemy_focus_ui() -> void:
	if enemy_party_cards.is_empty():
		return
	for i in range(enemy_party_cards.size()):
		var panel := enemy_party_cards[i].get("panel") as Control
		if i >= enemies.size():
			_set_unit_card_ui(enemy_party_cards[i], "Empty", 0, 1, 0, false)
			if panel:
				panel.tooltip_text = ""
			continue
		var enemy: Dictionary = enemies[i]
		var hp := int(enemy.get("hp", 0))
		var max_hp := int(enemy.get("max_hp", hp))
		var armor := int(enemy.get("armor", 0))
		_set_unit_card_ui(enemy_party_cards[i], str(enemy.get("name", "Enemy")), hp, max_hp, armor, true)
		if panel:
			panel.tooltip_text = _enemy_stat_tooltip(i)
	_update_enemy_selection_highlight()
	_refresh_target_display()

func _update_player_party_ui() -> void:
	if player_party_cards.is_empty():
		return
	_set_unit_card_ui(player_party_cards[0], "CHAMPION", champion_hp, champion_max_hp, champion_armor, true)

	# Update all 4 LT slots from lieutenant_states array
	for slot_idx in range(1, mini(5, player_party_cards.size())):  # Slots 1-4 for LTs
		var lt_idx := slot_idx - 1
		if lt_idx >= lieutenant_states.size() or not lieutenant_states[lt_idx].active:
			_set_unit_card_ui(player_party_cards[slot_idx], "Empty", 0, 1, 0, false)
			continue
		var lt_state = lieutenant_states[lt_idx]
		var lt_data: Dictionary = CardManager.get_lieutenant(lt_state.name)
		var lt_display_name: String = str(lt_data.get("name", lt_state.name)).to_upper()
		_set_unit_card_ui(player_party_cards[slot_idx], lt_display_name, lt_state.hp, lt_state.max_hp, lt_state.armor, true)

func _get_champion_display() -> String:
	return "CHAMPION\nHP %d/%d  ARM %d\nWarrior Stance" % [champion_hp, champion_max_hp, champion_armor]

func _get_lt_display() -> String:
	if lieutenant_states.is_empty() or not lieutenant_states[0].active:
		return "No Lieutenant"
	var lt_state = lieutenant_states[0]
	var lt_data := CardManager.get_lieutenant(lt_state.name)
	var display: String = str(lt_data.get("name", lt_state.name)) if not lt_data.is_empty() else lt_state.name
	if lt_state.hp <= 0:
		return "%s [DOWN]" % display
	return "%s\n❤ %d/%d  🛡 %d" % [display, lt_state.hp, lt_state.max_hp, lt_state.armor]

func _update_all_ui() -> void:
	var hp_before := last_ui_champion_hp
	if turn_label:
		turn_label.text = "Turn %d" % turn
		_animate_turn_label()
	if health_label:
		health_label.text = "Health: %d/%d" % [champion_hp, champion_max_hp]
	if player_hp_bar:
		player_hp_bar.max_value = champion_max_hp
		if player_hp_ghost_bar:
			player_hp_ghost_bar.max_value = champion_max_hp
		
		if champion_hp < last_ui_champion_hp: # Damage taken
			# Main bar drops instantly
			player_hp_bar.value = champion_hp
			
			# Ghost bar follows after a delay
			var ghost_tw = create_tween()
			ghost_tw.tween_interval(0.4) # Wait to show the lost chunk
			ghost_tw.tween_property(player_hp_ghost_bar, "value", champion_hp, 0.45).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			
			# Flash the bar
			var flash_tw = create_tween()
			player_hp_bar.modulate = Color(1.5, 1.5, 1.5, 1.0) # Overbright flash
			flash_tw.tween_property(player_hp_bar, "modulate", Color.WHITE, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		else: # Healed or unchanged
			var hp_tw = create_tween()
			hp_tw.set_parallel(true)
			hp_tw.tween_property(player_hp_bar, "value", champion_hp, 0.30).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			if player_hp_ghost_bar:
				hp_tw.tween_property(player_hp_ghost_bar, "value", champion_hp, 0.30).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if cp_label:
		_animate_cp_update()

	_update_enemy_focus_ui()
	_update_player_party_ui()

	if champion_label:
		champion_label.text = _get_champion_display()
		# Animate armor change
		if champion_armor != last_ui_champion_armor:
			var armor_change = champion_armor - last_ui_champion_armor
			var armor_color = Color(0.70, 1.0, 0.75, 1.0) if armor_change > 0 else Color(1.0, 0.85, 0.70, 1.0)
			var tw = create_tween()
			tw.set_parallel(true)
			var armor_tween = tw.tween_property(champion_label, "modulate", Color(1.0, 1.0, 1.0, 1.0) * armor_color, _scaled_time(0.12))
			armor_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tw.tween_property(champion_label, "scale", Vector2(1.06, 1.06), _scaled_time(0.12)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			var tw2 = create_tween()
			tw2.set_parallel(true)
			tw2.tween_property(champion_label, "modulate", Color.WHITE, _scaled_time(0.18)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
			tw2.tween_property(champion_label, "scale", Vector2.ONE, _scaled_time(0.18)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
			last_ui_champion_armor = champion_armor
	if lt_label:
		lt_label.text = _get_lt_display()
	if debug_status_label and debug_status_label.visible:
		debug_status_label.text = "Turn %d | Hand %d | Deck %d | Discard %d | Anim %.2fx" % [turn, hand.size(), deck.size(), discard_pile.size(), animation_speed]

	if player_stats_panel_ref and hp_before != champion_hp:
		var flash_col := Color(1.0, 0.70, 0.70, 1.0) if champion_hp < hp_before else Color(0.70, 1.0, 0.75, 1.0)
		var flash = create_tween()
		flash.tween_property(player_stats_panel_ref, "modulate", flash_col, 0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		flash.tween_property(player_stats_panel_ref, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		# Shake effect when damage taken
		if champion_hp < hp_before:
			_shake_element(player_zone_ref, 0.3, 3.0)
	last_ui_champion_hp = champion_hp

	_update_hand_ui()
	_update_undo_state()

func _animate_turn_label() -> void:
	if not turn_label or turn == 1:
		return
	# Pulse animation when turn advances
	var tw = create_tween()
	tw.set_parallel(true)
	tw.tween_property(turn_label, "scale", Vector2(1.15, 1.15), _scaled_time(0.12)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tw.tween_property(turn_label, "modulate", Color(1.0, 1.0, 0.7, 1.0), _scaled_time(0.12)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	var tw2 = create_tween()
	tw2.set_parallel(true)
	tw2.tween_property(turn_label, "scale", Vector2.ONE, _scaled_time(0.20)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tw2.tween_property(turn_label, "modulate", Color.WHITE, _scaled_time(0.20)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _animate_cp_update() -> void:
	if not cp_label or command_points == last_ui_command_points:
		cp_label.text = "CP: %d/%d" % [command_points, max_command_points]
		return

	var cp_change = command_points - last_ui_command_points
	var cp_color = Color(0.70, 1.0, 0.75, 1.0) if cp_change > 0 else Color(1.0, 0.82, 0.45, 1.0)
	var sign_str = "+" if cp_change > 0 else ""

	# SPRING BOUNCE: Scale up and elastic snap back
	cp_label.pivot_offset = cp_label.size * 0.5
	var bounce = create_tween()
	bounce.set_parallel(true)
	bounce.tween_property(cp_label, "scale", Vector2(1.35, 1.35), _scaled_time(0.08)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	bounce.tween_property(cp_label, "modulate", cp_color, _scaled_time(0.08)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	var spring = create_tween()
	spring.set_parallel(true)
	spring.tween_property(cp_label, "scale", Vector2.ONE, _scaled_time(0.4)).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	spring.tween_property(cp_label, "modulate", Color.WHITE, _scaled_time(0.3)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	# Update text
	cp_label.text = "CP: %d/%d" % [command_points, max_command_points]

	# Spawn floating text for the change
	_spawn_float_text(sign_str + str(cp_change), cp_color, cp_label.get_global_rect().get_center(), 20)

	last_ui_command_points = command_points

func _player_float_origin() -> Vector2:
	if player_portrait_panel_ref:
		return player_portrait_panel_ref.get_global_rect().get_center()
	if champion_label:
		return champion_label.get_global_rect().get_center()
	return play_target_marker.get_global_rect().get_center()

func _enemy_float_origin(enemy_idx: int) -> Vector2:
	if enemy_idx >= 0 and enemy_idx < enemy_party_cards.size():
		var enemy_panel := enemy_party_cards[enemy_idx].get("panel") as Control
		if enemy_panel:
			return enemy_panel.get_global_rect().get_center()
	if enemy_portrait_panel_ref:
		return enemy_portrait_panel_ref.get_global_rect().get_center()
	return play_target_marker.get_global_rect().get_center()

func _spawn_float_text(text: String, color: Color, origin: Vector2, font_px: int) -> void:
	var fx = Label.new()
	fx.text = text
	fx.add_theme_font_size_override("font_size", font_px)
	fx.add_theme_color_override("font_color", color)
	fx.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	fx.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	fx.custom_minimum_size = Vector2(220, 36)
	fx.z_index = 200
	add_child(fx)
	fx.global_position = origin - Vector2(110, 18)
	var tw = create_tween()
	tw.set_parallel(true)
	tw.tween_property(fx, "global_position:y", fx.global_position.y - 48.0, 0.50).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tw.tween_property(fx, "modulate:a", 0.0, 0.50).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tw.finished
	fx.queue_free()

func _apply_text_scale_from_accessibility() -> void:
	var scale: float = clampf(float(GameState.get_accessibility_setting("text_scale", 1.0)), 0.8, 1.5)
	if is_equal_approx(scale, 1.0):
		return
	_scale_fonts_recursive(self, scale)

func _scale_fonts_recursive(node: Node, scale: float) -> void:
	if node is Label:
		var lbl := node as Label
		var size := lbl.get_theme_font_size("font_size")
		if size <= 0:
			size = 14
		lbl.add_theme_font_size_override("font_size", int(round(float(size) * scale)))
	elif node is Button:
		var btn := node as Button
		var size_btn := btn.get_theme_font_size("font_size")
		if size_btn <= 0:
			size_btn = 14
		btn.add_theme_font_size_override("font_size", int(round(float(size_btn) * scale)))
	for child in node.get_children():
		_scale_fonts_recursive(child, scale)

func _has_lt_trait(trait_name: String) -> bool:
	for lt_id in GameState.active_lieutenants:
		var d: Dictionary = CardManager.get_lieutenant(str(lt_id))
		if str(d.get("trait", "")) == trait_name:
			return true
	return false

func _init_lieutenant_state() -> void:
	var active = GameState.active_lieutenants

	# Initialize 4 LT slots from active_lieutenants
	lieutenant_states.clear()
	for i in range(4):
		if i < active.size():
			var lt_name_str = str(active[i])
			var lt_data = CardManager.get_lieutenant(lt_name_str)
			var hp = int(lt_data.get("hp", 25))
			var armor = int(lt_data.get("armor", 2))
			lieutenant_states.append(LTCombatState.new(lt_name_str, hp, hp, armor, true))
		else:
			lieutenant_states.append(LTCombatState.new("", 0, 0, 0, false))

	# Apply passive traits from ALL active lieutenants
	opening_draw_bonus = 0
	for lt_id in active:
		var d: Dictionary = CardManager.get_lieutenant(str(lt_id))
		match str(d.get("trait", "")):
			"Disciplined":  # Marcus: +1 card on opening draw
				opening_draw_bonus += 1
			"Blessed":      # Livia: +2 CP at start of combat
				command_points = min(max_command_points, command_points + 2)
				_log("Livia's Blessing: +2 starting CP.")

func _resolve_mission_context() -> void:
	current_mission_id = GameState.current_mission_id
	if current_mission_id == "":
		var available = MissionManager.get_available_missions()
		current_mission_id = "M01" if available.is_empty() else str(available[0])
		GameState.current_mission_id = current_mission_id

	current_mission_data = MissionManager.get_mission(current_mission_id)
	if current_mission_data.is_empty():
		current_mission_id = "M01"
		GameState.current_mission_id = current_mission_id
		current_mission_data = MissionManager.get_mission(current_mission_id)
	hazard_data = current_mission_data.get("hazard", {})

func _apply_equipped_gear_bonuses() -> void:
	var equipped: Dictionary = GameState.equipped_gear
	if equipped.is_empty():
		return

	var applied_names: Array = []
	var applied_effects: Array = []
	var unhandled_effects: Array = []
	var hp_bonus := 0
	var armor_bonus := 0
	var damage_bonus := 0
	var speed_bonus := 0
	var start_armor_bonus := 0
	for slot in ["weapon", "armor", "accessory"]:
		var gear_id: String = str(equipped.get(slot, ""))
		if gear_id == "":
			continue
		var gear: Dictionary = CardManager.get_gear(gear_id)
		if gear.is_empty():
			continue
		applied_names.append(str(gear.get("name", gear_id)))

		hp_bonus += int(gear.get("hp", 0))
		armor_bonus += int(gear.get("armor", 0))
		damage_bonus += int(gear.get("damage", 0))
		speed_bonus += int(gear.get("speed", 0))

		var effect: String = str(gear.get("effect", "none"))
		match effect:
			"draw_start":
				gear_opening_draw_bonus += 1
				applied_effects.append("draw_start")
			"start_armor":
				start_armor_bonus += 2
				applied_effects.append("start_armor")
			"start_mana", "start_stamina":
				gear_start_cp_bonus += 1
				applied_effects.append("start_cp")
			"stamina_regen_boost", "mana_regen_boost":
				max_command_points += 1
				applied_effects.append("cp_regen")
			"draw_bonus":
				gear_draw_per_turn_bonus += 1
				applied_effects.append("draw_bonus")
			_:
				if effect != "none" and effect != "":
					unhandled_effects.append(effect)

	gear_flat_damage_bonus += damage_bonus
	gear_draw_per_turn_bonus += maxi(0, speed_bonus)
	champion_max_hp = max(1, champion_max_hp + hp_bonus)
	champion_hp = clamp(champion_hp + hp_bonus, 1, champion_max_hp)
	champion_armor += armor_bonus + start_armor_bonus

	command_points = max_command_points + gear_start_cp_bonus
	if not applied_names.is_empty():
		_log("Gear active: %s" % ", ".join(applied_names))
		var stat_line = "Bonuses: HP %+d, ARM %+d, DMG %+d, SPD %+d" % [
			hp_bonus, armor_bonus + start_armor_bonus, damage_bonus, maxi(0, speed_bonus)
		]
		_log(stat_line)
	if not applied_effects.is_empty():
		_log("Gear effects: %s" % ", ".join(applied_effects))
	if not unhandled_effects.is_empty():
		_log("Gear effects (not implemented): %s" % ", ".join(unhandled_effects))

func _log(msg: String) -> void:
	_log_lines.append(msg)
	if _log_lines.size() > 10:
		_log_lines.pop_front()
	if log_label:
		var start_idx: int = maxi(0, _log_lines.size() - 3)
		log_label.text = "\n".join(_log_lines.slice(start_idx, _log_lines.size()))
	_refresh_turn_log()
	print("[COMBAT] " + msg)
