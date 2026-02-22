extends Control
## Card display — faction glyph design, built entirely in code.
## Swap to real portrait art later with zero code changes.

signal card_pressed()

# ── Parchment & Wax palette ──
const CLR_BG      = Color(0.08, 0.065, 0.050)
const CLR_PANEL   = Color(0.14, 0.110, 0.080)
const CLR_BORDER  = Color(0.42, 0.320, 0.160)
const CLR_ACCENT  = Color(0.86, 0.700, 0.360)
const CLR_TEXT    = Color(0.90, 0.840, 0.680)
const CLR_MUTED   = Color(0.58, 0.520, 0.400)
const CLR_STONE   = Color(0.18, 0.155, 0.120)

const FRAME_PATH = "res://assets/cards/frame_front.png"

const FACTION_GLYPH: Dictionary = {
	"AEGIS":   "Ω",
	"SPECTER": "☽",
	"ECLIPSE": "✦",
	"NEUTRAL": "⚔",
}
const FACTION_COLOR: Dictionary = {
	"AEGIS":   Color(0.10, 0.18, 0.45, 0.90),
	"SPECTER": Color(0.22, 0.08, 0.38, 0.90),
	"ECLIPSE": Color(0.35, 0.18, 0.04, 0.90),
	"NEUTRAL": Color(0.12, 0.10, 0.08, 0.90),
}

var current_card_id: String = ""

# Internal node refs (built in _build_card)
var _faction_bg:    ColorRect
var _faction_glyph: Label
var _name_label:    Label
var _cost_label:    Label
var _stats_label:   Label
var _effect_label:  Label

func _ready() -> void:
	custom_minimum_size = Vector2(120, 180)
	mouse_filter = MOUSE_FILTER_STOP
	_build_card()
	gui_input.connect(_on_gui_input)

func _build_card() -> void:
	# 1 — Drop shadow (rendered first, beneath everything)
	var shadow = ColorRect.new()
	shadow.color = Color(0, 0, 0, 0.50)
	shadow.anchor_left   = 0.0; shadow.anchor_right  = 1.0
	shadow.anchor_top    = 0.0; shadow.anchor_bottom = 1.0
	shadow.offset_left   = 5;   shadow.offset_right  = 8
	shadow.offset_top    = 6;   shadow.offset_bottom = 8
	shadow.mouse_filter  = MOUSE_FILTER_IGNORE
	add_child(shadow)

	# 2 — Card base (dark parchment)
	var card_bg = ColorRect.new()
	card_bg.color = CLR_PANEL
	card_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	card_bg.mouse_filter = MOUSE_FILTER_IGNORE
	add_child(card_bg)

	# 3 — Faction colour zone (top 58%)
	_faction_bg = ColorRect.new()
	_faction_bg.color = FACTION_COLOR.get("NEUTRAL", Color(0.12, 0.10, 0.08, 0.90))
	_faction_bg.anchor_left   = 0.0; _faction_bg.anchor_right  = 1.0
	_faction_bg.anchor_top    = 0.0; _faction_bg.anchor_bottom = 0.58
	_faction_bg.offset_left   = 2;   _faction_bg.offset_right  = -2
	_faction_bg.offset_top    = 2;   _faction_bg.offset_bottom = 0
	_faction_bg.mouse_filter  = MOUSE_FILTER_IGNORE
	add_child(_faction_bg)

	# 4 — Large faction glyph (watermark style, low opacity)
	_faction_glyph = Label.new()
	_faction_glyph.text = FACTION_GLYPH.get("NEUTRAL", "⚔")
	_faction_glyph.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_faction_glyph.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	_faction_glyph.add_theme_font_size_override("font_size", 54)
	_faction_glyph.add_theme_color_override("font_color", Color(1, 1, 1, 0.16))
	_faction_glyph.anchor_left   = 0.0; _faction_glyph.anchor_right  = 1.0
	_faction_glyph.anchor_top    = 0.0; _faction_glyph.anchor_bottom = 0.58
	_faction_glyph.offset_left   = 0;   _faction_glyph.offset_right  = 0
	_faction_glyph.offset_top    = 0;   _faction_glyph.offset_bottom = 0
	_faction_glyph.mouse_filter  = MOUSE_FILTER_IGNORE
	add_child(_faction_glyph)

	# 5 — Frame PNG overlay (on top of colour layers)
	var frame_tex = TextureRect.new()
	if ResourceLoader.exists(FRAME_PATH):
		frame_tex.texture = ResourceLoader.load(FRAME_PATH)
	frame_tex.set_anchors_preset(Control.PRESET_FULL_RECT)
	frame_tex.expand_mode  = TextureRect.EXPAND_IGNORE_SIZE
	frame_tex.stretch_mode = TextureRect.STRETCH_SCALE
	frame_tex.mouse_filter = MOUSE_FILTER_IGNORE
	add_child(frame_tex)

	# 6 — Name ribbon (horizontal band at ~58% height)
	var ribbon = PanelContainer.new()
	var rib_style = StyleBoxFlat.new()
	rib_style.bg_color = Color(CLR_STONE.r, CLR_STONE.g, CLR_STONE.b, 0.95)
	rib_style.border_width_top    = 1
	rib_style.border_width_bottom = 1
	rib_style.border_color = CLR_BORDER
	ribbon.add_theme_stylebox_override("panel", rib_style)
	ribbon.anchor_left   = 0.0;  ribbon.anchor_right  = 1.0
	ribbon.anchor_top    = 0.58; ribbon.anchor_bottom = 0.58
	ribbon.offset_left   = 2;    ribbon.offset_right  = -2
	ribbon.offset_top    = 0;    ribbon.offset_bottom = 22
	ribbon.mouse_filter  = MOUSE_FILTER_IGNORE
	add_child(ribbon)

	var rib_margin = MarginContainer.new()
	rib_margin.add_theme_constant_override("margin_left",  4)
	rib_margin.add_theme_constant_override("margin_right", 4)
	rib_margin.add_theme_constant_override("margin_top",   2)
	rib_margin.add_theme_constant_override("margin_bottom",2)
	rib_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	ribbon.add_child(rib_margin)

	_name_label = Label.new()
	_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_name_label.add_theme_font_size_override("font_size", 10)
	_name_label.add_theme_color_override("font_color", CLR_ACCENT)
	_name_label.text = "Card Name"
	rib_margin.add_child(_name_label)

	# 7 — Cost badge (top-left corner)
	var cost_badge = PanelContainer.new()
	var badge_style = StyleBoxFlat.new()
	badge_style.bg_color = Color(0.05, 0.04, 0.03, 0.92)
	badge_style.border_width_right  = 1
	badge_style.border_width_bottom = 1
	badge_style.border_color = CLR_BORDER
	badge_style.corner_radius_bottom_right = 5
	badge_style.content_margin_left   = 3
	badge_style.content_margin_right  = 3
	badge_style.content_margin_top    = 1
	badge_style.content_margin_bottom = 1
	cost_badge.add_theme_stylebox_override("panel", badge_style)
	cost_badge.anchor_left   = 0.0; cost_badge.anchor_right  = 0.0
	cost_badge.anchor_top    = 0.0; cost_badge.anchor_bottom = 0.0
	cost_badge.offset_left   = 2;   cost_badge.offset_right  = 24
	cost_badge.offset_top    = 2;   cost_badge.offset_bottom = 22
	cost_badge.mouse_filter  = MOUSE_FILTER_IGNORE
	add_child(cost_badge)

	_cost_label = Label.new()
	_cost_label.text = "0"
	_cost_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_cost_label.add_theme_font_size_override("font_size", 11)
	_cost_label.add_theme_color_override("font_color", CLR_ACCENT)
	cost_badge.add_child(_cost_label)

	# 8 — Stats + effect area (below ribbon)
	var stats_area = VBoxContainer.new()
	stats_area.add_theme_constant_override("separation", 2)
	stats_area.anchor_left   = 0.0;  stats_area.anchor_right  = 1.0
	stats_area.anchor_top    = 0.58; stats_area.anchor_bottom = 1.0
	stats_area.offset_left   = 5;    stats_area.offset_right  = -5
	stats_area.offset_top    = 24;   stats_area.offset_bottom = -4
	stats_area.mouse_filter  = MOUSE_FILTER_IGNORE
	add_child(stats_area)

	_stats_label = Label.new()
	_stats_label.add_theme_font_size_override("font_size", 9)
	_stats_label.add_theme_color_override("font_color", CLR_TEXT)
	_stats_label.text = ""
	stats_area.add_child(_stats_label)

	var sep = HSeparator.new()
	sep.add_theme_color_override("color", CLR_BORDER)
	stats_area.add_child(sep)

	_effect_label = Label.new()
	_effect_label.add_theme_font_size_override("font_size", 8)
	_effect_label.add_theme_color_override("font_color", CLR_MUTED)
	_effect_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	_effect_label.text = ""
	stats_area.add_child(_effect_label)

func set_card(card_id: String) -> void:
	if card_id.is_empty():
		return
	var card = CardManager.get_card(card_id)
	if card.is_empty():
		return

	current_card_id = card_id
	var faction = card.get("faction", "NEUTRAL")

	if _faction_bg:
		_faction_bg.color = FACTION_COLOR.get(faction, FACTION_COLOR["NEUTRAL"])
	if _faction_glyph:
		_faction_glyph.text = FACTION_GLYPH.get(faction, "⚔")
	if _name_label:
		_name_label.text = card.get("name", "Unknown")
	if _cost_label:
		_cost_label.text = str(card.get("cost", 0))

	var dmg   = card.get("damage", 0)
	var armor = card.get("armor", 0)
	var heal  = card.get("heal", 0)
	var parts: Array = []
	if dmg   > 0: parts.append("⚔%d" % dmg)
	if armor > 0: parts.append("🛡+%d" % armor)
	if heal  > 0: parts.append("💚%d" % heal)
	if _stats_label:
		_stats_label.text = " | ".join(parts) if parts.size() > 0 else ""

	var effect = card.get("effect", "")
	if _effect_label:
		_effect_label.text = "" if (effect == "" or effect == "none") else effect

func set_card_size(card_size: Vector2) -> void:
	custom_minimum_size = card_size

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		card_pressed.emit()
