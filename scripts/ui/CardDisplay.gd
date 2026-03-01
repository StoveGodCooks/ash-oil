extends Control
## Card display — faction glyph design, built entirely in code.
## Swap to real portrait art later with zero code changes.
## Batch 5A: Enhanced layered faction zones, glyphs, cost badges, name ribbons.

signal card_pressed()

# ── Size variants ──
enum CardSize { SMALL = 0, MEDIUM = 1, LARGE = 2 }

# ── Parchment & Wax palette (legacy, override with UITheme) ──
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
const TYPE_ICON: Dictionary = {
	"attack": "⚔",
	"defense": "🛡",
	"support": "✚",
	"reaction": "↺",
	"area": "◉",
	"evasion": "🜁",
	"effect": "✦",
}
const TYPE_COLOR: Dictionary = {
	"attack": Color(0.95, 0.28, 0.28, 0.95),
	"defense": Color(0.40, 0.74, 1.0, 0.95),
	"support": Color(0.35, 0.95, 0.55, 0.95),
	"reaction": Color(0.95, 0.82, 0.36, 0.95),
	"area": Color(0.96, 0.45, 0.18, 0.95),
	"evasion": Color(0.72, 0.88, 1.0, 0.95),
	"effect": Color(0.86, 0.62, 1.0, 0.95),
}

# ── Card State ──
var current_size: CardSize = CardSize.MEDIUM
var current_card_id: String = ""

# Internal node refs (built in _build_card)
var _faction_bg:    ColorRect
var _faction_glyph: Label
var _name_label:    Label
var _cost_label:    Label
var _stats_label:   Label
var _effect_label:  Label
var _type_icon:     Label
var _hover_glow:    ColorRect
var _unplayable_x:  Label
var _frame_overlay: TextureRect
var _rarity_frame:  PanelContainer
var _portrait_image: TextureRect
var _card_shell_bg: TextureRect

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

	# 3 — Faction colour zone (top 42% per spec)
	_faction_bg = ColorRect.new()
	_faction_bg.color = FACTION_COLOR.get("NEUTRAL", Color(0.12, 0.10, 0.08, 0.90))
	_faction_bg.anchor_left   = 0.0; _faction_bg.anchor_right  = 1.0
	_faction_bg.anchor_top    = 0.0; _faction_bg.anchor_bottom = 0.42
	_faction_bg.offset_left   = 2;   _faction_bg.offset_right  = -2
	_faction_bg.offset_top    = 2;   _faction_bg.offset_bottom = 0
	_faction_bg.mouse_filter  = MOUSE_FILTER_IGNORE
	add_child(_faction_bg)

	# 4 — Large faction glyph (watermark style, 25% opacity per spec)
	_faction_glyph = Label.new()
	_faction_glyph.text = FACTION_GLYPH.get("NEUTRAL", "⚔")
	_faction_glyph.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_faction_glyph.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	_faction_glyph.add_theme_font_size_override("font_size", 54)
	_faction_glyph.add_theme_color_override("font_color", Color(1, 1, 1, 0.25))
	_faction_glyph.anchor_left   = 0.0; _faction_glyph.anchor_right  = 1.0
	_faction_glyph.anchor_top    = 0.0; _faction_glyph.anchor_bottom = 0.42
	_faction_glyph.offset_left   = 0;   _faction_glyph.offset_right  = 0
	_faction_glyph.offset_top    = 0;   _faction_glyph.offset_bottom = 0
	_faction_glyph.mouse_filter  = MOUSE_FILTER_IGNORE
	add_child(_faction_glyph)

	_type_icon = Label.new()
	_type_icon.text = "⚔"
	_type_icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_type_icon.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_type_icon.add_theme_font_size_override("font_size", 30)
	_type_icon.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 0.92))
	_type_icon.anchor_left = 0.0; _type_icon.anchor_right = 1.0
	_type_icon.anchor_top = 0.0; _type_icon.anchor_bottom = 0.42
	_type_icon.offset_top = 4
	_type_icon.offset_bottom = 0
	_type_icon.mouse_filter = MOUSE_FILTER_IGNORE
	add_child(_type_icon)

	# 4b — Portrait image (over faction bg, hidden until set)
	_portrait_image = TextureRect.new()
	_portrait_image.anchor_left   = 0.0; _portrait_image.anchor_right  = 1.0
	_portrait_image.anchor_top    = 0.0; _portrait_image.anchor_bottom = 0.42
	_portrait_image.offset_left   = 2;   _portrait_image.offset_right  = -2
	_portrait_image.offset_top    = 2;   _portrait_image.offset_bottom = 0
	_portrait_image.expand_mode   = TextureRect.EXPAND_IGNORE_SIZE
	_portrait_image.stretch_mode  = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_portrait_image.mouse_filter  = MOUSE_FILTER_IGNORE
	_portrait_image.visible = false
	add_child(_portrait_image)

	# 5 — Frame PNG overlay (on top of colour layers)
	_frame_overlay = TextureRect.new()
	if ResourceLoader.exists(FRAME_PATH):
		_frame_overlay.texture = ResourceLoader.load(FRAME_PATH)
	_frame_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_frame_overlay.expand_mode  = TextureRect.EXPAND_IGNORE_SIZE
	_frame_overlay.stretch_mode = TextureRect.STRETCH_SCALE
	_frame_overlay.mouse_filter = MOUSE_FILTER_IGNORE
	add_child(_frame_overlay)

	_rarity_frame = PanelContainer.new()
	_rarity_frame.set_anchors_preset(Control.PRESET_FULL_RECT)
	_rarity_frame.mouse_filter = MOUSE_FILTER_IGNORE
	add_child(_rarity_frame)
	_apply_rarity_style("common")

	# Hover glow (soft gold aura)
	_hover_glow = ColorRect.new()
	_hover_glow.color = Color(0.85, 0.74, 0.42, 0.0)
	_hover_glow.anchor_left = 0.0
	_hover_glow.anchor_right = 1.0
	_hover_glow.anchor_top = 0.0
	_hover_glow.anchor_bottom = 1.0
	_hover_glow.offset_left = -20
	_hover_glow.offset_right = 20
	_hover_glow.offset_top = -20
	_hover_glow.offset_bottom = 20
	_hover_glow.mouse_filter = MOUSE_FILTER_IGNORE
	add_child(_hover_glow)
	move_child(_hover_glow, 0)

	# 6 — Name ribbon (horizontal band at 42% height, 20px tall per spec)
	var ribbon = PanelContainer.new()
	var rib_style = StyleBoxFlat.new()
	rib_style.bg_color = UITheme.CLR_STONE if (UITheme != null) else Color(CLR_STONE.r, CLR_STONE.g, CLR_STONE.b, 0.85)
	rib_style.border_width_top    = 0
	rib_style.border_width_bottom = 0
	rib_style.border_color = UITheme.CLR_BRONZE if (UITheme != null) else CLR_BORDER
	ribbon.add_theme_stylebox_override("panel", rib_style)
	ribbon.anchor_left   = 0.0;  ribbon.anchor_right  = 1.0
	ribbon.anchor_top    = 0.42; ribbon.anchor_bottom = 0.42
	ribbon.offset_left   = 2;    ribbon.offset_right  = -2
	ribbon.offset_top    = 0;    ribbon.offset_bottom = 26
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
	_name_label.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION if (UITheme != null) else 12)
	_name_label.add_theme_color_override("font_color", UITheme.CLR_VELLUM if (UITheme != null) else CLR_ACCENT)
	_name_label.text = "Card Name"
	_name_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	_name_label.custom_minimum_size = Vector2(0, 20)
	rib_margin.add_child(_name_label)

	# 7 — Cost badge (top-left corner, gold circle per spec)
	var cost_badge = PanelContainer.new()
	var badge_style = StyleBoxFlat.new()
	badge_style.bg_color = UITheme.CLR_GOLD if (UITheme != null) else Color(0.86, 0.70, 0.28)
	badge_style.border_width_left = 0
	badge_style.border_width_right = 0
	badge_style.border_width_top = 0
	badge_style.border_width_bottom = 0
	badge_style.corner_radius_top_left = 11
	badge_style.corner_radius_top_right = 11
	badge_style.corner_radius_bottom_left = 11
	badge_style.corner_radius_bottom_right = 11
	badge_style.content_margin_left   = 0
	badge_style.content_margin_right  = 0
	badge_style.content_margin_top    = 0
	badge_style.content_margin_bottom = 0
	cost_badge.add_theme_stylebox_override("panel", badge_style)
	cost_badge.custom_minimum_size = Vector2(22, 22)
	cost_badge.anchor_left   = 0.0; cost_badge.anchor_right  = 0.0
	cost_badge.anchor_top    = 0.0; cost_badge.anchor_bottom = 0.0
	cost_badge.offset_left   = 5;   cost_badge.offset_right  = 27
	cost_badge.offset_top    = 5;   cost_badge.offset_bottom = 27
	cost_badge.mouse_filter  = MOUSE_FILTER_IGNORE
	add_child(cost_badge)

	_cost_label = Label.new()
	_cost_label.text = "0"
	_cost_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_cost_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_cost_label.add_theme_font_size_override("font_size", UITheme.FONT_BODY if (UITheme != null) else 14)
	_cost_label.add_theme_color_override("font_color", UITheme.CLR_VOID if (UITheme != null) else Color(0.07, 0.06, 0.05))
	cost_badge.add_child(_cost_label)

	# Card shell overlay — covers procedural design when full card art exists
	_card_shell_bg = TextureRect.new()
	_card_shell_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_card_shell_bg.expand_mode  = TextureRect.EXPAND_IGNORE_SIZE
	_card_shell_bg.stretch_mode = TextureRect.STRETCH_SCALE
	_card_shell_bg.mouse_filter = MOUSE_FILTER_IGNORE
	_card_shell_bg.visible = false
	add_child(_card_shell_bg)

	_unplayable_x = Label.new()
	_unplayable_x.text = "✖"
	_unplayable_x.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_unplayable_x.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_unplayable_x.add_theme_font_size_override("font_size", 54)
	_unplayable_x.add_theme_color_override("font_color", Color(0.92, 0.18, 0.18, 0.92))
	_unplayable_x.set_anchors_preset(Control.PRESET_FULL_RECT)
	_unplayable_x.visible = false
	_unplayable_x.mouse_filter = MOUSE_FILTER_IGNORE
	add_child(_unplayable_x)

func set_card(card_id: String) -> void:
	if card_id.is_empty():
		return
	var card = CardManager.get_card(card_id)
	if card.is_empty():
		push_warning("CardDisplay: no data for card_id '%s'" % card_id)
		return

	current_card_id = card_id
	var faction = card.get("faction", "NEUTRAL")
	var card_type = str(card.get("type", "attack"))

	if _faction_bg:
		_faction_bg.color = FACTION_COLOR.get(faction, FACTION_COLOR["NEUTRAL"])
	if _faction_glyph:
		_faction_glyph.text = FACTION_GLYPH.get(faction, "⚔")
	if _name_label:
		_name_label.text = card.get("name", "Unknown")
	if _cost_label:
		_cost_label.text = str(card.get("cost", 0))
	if _type_icon:
		_type_icon.text = TYPE_ICON.get(card_type, "⚔")
		_type_icon.add_theme_color_override("font_color", TYPE_COLOR.get(card_type, Color(1, 1, 1, 0.92)))

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
	_apply_rarity_style(_rarity_tier(card))

	# Full card shell — covers all procedural elements when real card art exists
	var shell_path: String = card.get("cardShell", "")
	var shell_tex: Texture2D = null
	if shell_path != "":
		shell_tex = load(shell_path) as Texture2D
		if shell_tex == null:
			push_warning("CardDisplay: failed to load cardShell '%s'" % shell_path)
	if _card_shell_bg:
		_card_shell_bg.texture = shell_tex
		_card_shell_bg.visible = shell_tex != null

	# Portrait zone — only used when no full card shell is set
	var portrait_path: String = card.get("portraitFile", "")
	if _portrait_image:
		var tex: Texture2D = null
		if shell_tex == null and portrait_path != "":
			tex = load(portrait_path) as Texture2D
			if tex == null:
				push_warning("CardDisplay: failed to load portrait '%s'" % portrait_path)
		_portrait_image.texture = tex
		_portrait_image.visible = tex != null
		if _faction_glyph:
			_faction_glyph.visible = tex == null
		if _type_icon:
			_type_icon.visible = tex == null and current_size != CardSize.SMALL

func set_card_size(card_size: Vector2) -> void:
	custom_minimum_size = card_size
	# Determine size variant based on width
	if card_size.x <= 110:
		current_size = CardSize.SMALL
	elif card_size.x <= 150:
		current_size = CardSize.MEDIUM
	else:
		current_size = CardSize.LARGE

	# Show/hide elements based on size
	if _stats_label:
		_stats_label.visible = (current_size != CardSize.SMALL)
	if _effect_label:
		_effect_label.visible = (current_size == CardSize.LARGE)
	if _type_icon:
		_type_icon.visible = (current_size != CardSize.SMALL)

func set_hovered(active: bool) -> void:
	# Avoid heavy full-card glow; keep hover emphasis to motion/outline elsewhere.
	if _hover_glow != null:
		_hover_glow.color.a = 0.0
	if _rarity_frame != null:
		_rarity_frame.modulate = Color(1.05, 1.05, 1.05, 1.0) if active else Color(1.0, 1.0, 1.0, 1.0)

func set_selected(active: bool) -> void:
	if _frame_overlay == null:
		return
	_frame_overlay.modulate = Color(1.02, 1.02, 1.00, 1.0) if active else Color(1.0, 1.0, 1.0, 1.0)

func pulse_cost() -> void:
	if _cost_label == null:
		return
	var tw = create_tween()
	tw.tween_property(_cost_label, "scale", Vector2(1.18, 1.18), 0.06).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(_cost_label, "scale", Vector2.ONE, 0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func show_unplayable() -> void:
	if _unplayable_x == null:
		return
	_unplayable_x.visible = true
	_unplayable_x.modulate.a = 1.0
	var tw = create_tween()
	tw.tween_property(_unplayable_x, "modulate:a", 0.0, 0.20).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tw.finished
	_unplayable_x.visible = false

func _rarity_tier(card: Dictionary) -> String:
	var raw = str(card.get("rarity", "")).to_lower()
	if raw in ["common", "rare", "legendary"]:
		return raw
	var power_idx = int(card.get("power_index", 0))
	if power_idx >= 8:
		return "legendary"
	if power_idx >= 5:
		return "rare"
	return "common"

func _apply_rarity_style(tier: String) -> void:
	if _rarity_frame == null:
		return
	var border_col := Color(0.65, 0.65, 0.65, 0.85)
	match tier:
		"rare":
			border_col = Color(0.96, 0.78, 0.34, 0.92)
		"legendary":
			border_col = Color(0.94, 0.28, 0.28, 0.95)
		_:
			border_col = Color(0.70, 0.70, 0.70, 0.86)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0)
	style.border_color = border_col
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	_rarity_frame.add_theme_stylebox_override("panel", style)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		card_pressed.emit()
