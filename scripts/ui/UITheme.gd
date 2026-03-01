class_name UITheme
extends RefCounted

# -- STONE & EARTH (backgrounds, surfaces) ------------------------------
const CLR_VOID := Color(0.055, 0.042, 0.030)
const CLR_STONE := Color(0.110, 0.088, 0.065)
const CLR_STONE_MID := Color(0.170, 0.135, 0.095)
const CLR_STONE_LITE := Color(0.240, 0.192, 0.138)

# -- GOLD & BRONZE (accents, borders, rewards) --------------------------
const CLR_GOLD := Color(0.860, 0.700, 0.280)
const CLR_BRONZE := Color(0.620, 0.440, 0.160)
const CLR_BRASS := Color(0.780, 0.610, 0.240)

# -- BLOOD & FIRE (danger, cost, enemy) ---------------------------------
const CLR_BLOOD := Color(0.720, 0.120, 0.090)
const CLR_EMBER := Color(0.880, 0.380, 0.080)
const CLR_ASH := Color(0.450, 0.400, 0.360)

# -- VELLUM & INK (text hierarchy) --------------------------------------
const CLR_VELLUM := Color(0.920, 0.860, 0.700)
const CLR_PARCHMENT := Color(0.780, 0.720, 0.560)
const CLR_MUTED := Color(0.500, 0.450, 0.360)

# -- FACTION COLORS ------------------------------------------------------
const CLR_AEGIS := Color(0.250, 0.440, 0.780)
const CLR_SPECTER := Color(0.550, 0.220, 0.720)
const CLR_ECLIPSE := Color(0.850, 0.520, 0.080)

# -- METER COLORS --------------------------------------------------------
const CLR_METER_REPUTATION := CLR_GOLD
const CLR_METER_DANGER := CLR_BLOOD
const CLR_METER_FAITH := Color(0.680, 0.680, 0.900)
const CLR_METER_ALLIES := Color(0.280, 0.680, 0.380)
const CLR_METER_COST := CLR_EMBER
const CLR_METER_RESISTANCE := Color(0.580, 0.480, 0.780)

# Font sizing (new system)
const FONT_SIZE_TITLE := 28
const FONT_SIZE_HEADER := 20
const FONT_SIZE_SUBHEAD := 16
const FONT_SIZE_BODY := 14
const FONT_SIZE_CAPTION := 12
const FONT_SIZE_FINE := 10

# Legacy aliases kept for existing scripts.
const FONT_TITLE := FONT_SIZE_TITLE
const FONT_SECTION := FONT_SIZE_HEADER
const FONT_SUBHEADER := FONT_SIZE_SUBHEAD
const FONT_BODY := FONT_SIZE_BODY
const FONT_SECONDARY := FONT_SIZE_CAPTION
const FONT_FINE := FONT_SIZE_FINE

const PAD_SM := 10
const PAD_MD := 15
const PAD_LG := 20

const COLOR_BG := CLR_VOID
const COLOR_BG_PANEL := CLR_STONE
const COLOR_BG_PANEL_ALT := CLR_STONE_MID
const COLOR_TEXT := CLR_VELLUM
const COLOR_TEXT_DIM := CLR_PARCHMENT
const COLOR_GOLD := CLR_GOLD
const COLOR_BORDER := CLR_BRONZE
const COLOR_BUTTON := CLR_STONE_MID
const COLOR_BUTTON_HOVER := CLR_STONE_LITE
const COLOR_BUTTON_PRESS := CLR_ASH

static func _accessibility() -> Dictionary:
	if typeof(GameState) == TYPE_NIL:
		return {}
	return GameState.accessibility

static func _font_scale() -> float:
	var settings := _accessibility()
	return clampf(float(settings.get("text_scale", 1.0)), 0.8, 1.5)

static func _scaled_font(base_size: int) -> int:
	return int(round(float(base_size) * _font_scale()))

static func _new_stylebox(bg: Color, border: Color, border_width: int, corner: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.border_width_left = border_width
	style.border_width_top = border_width
	style.border_width_right = border_width
	style.border_width_bottom = border_width
	style.corner_radius_top_left = corner
	style.corner_radius_top_right = corner
	style.corner_radius_bottom_left = corner
	style.corner_radius_bottom_right = corner
	return style

static func panel_base() -> StyleBoxFlat:
	var style := _new_stylebox(CLR_STONE, CLR_BRONZE, 1, 3)
	style.content_margin_left = PAD_MD
	style.content_margin_right = PAD_MD
	style.content_margin_top = PAD_MD
	style.content_margin_bottom = PAD_MD
	return style

static func panel_raised() -> StyleBoxFlat:
	var style := _new_stylebox(CLR_STONE_MID, CLR_GOLD, 1, 4)
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.42)
	style.shadow_size = 6
	style.shadow_offset = Vector2(0, 3)
	style.content_margin_left = PAD_MD
	style.content_margin_right = PAD_MD
	style.content_margin_top = PAD_MD
	style.content_margin_bottom = PAD_MD
	return style

static func panel_raised_hover() -> StyleBoxFlat:
	var style := _new_stylebox(CLR_STONE_LITE, CLR_GOLD, 2, 4)
	style.shadow_color = Color(1.0, 0.9, 0.3, 0.55)
	style.shadow_size = 8
	style.shadow_offset = Vector2(0, 4)
	style.content_margin_left = PAD_MD
	style.content_margin_right = PAD_MD
	style.content_margin_top = PAD_MD
	style.content_margin_bottom = PAD_MD
	return style

static func panel_inset() -> StyleBoxFlat:
	var style := _new_stylebox(CLR_VOID, CLR_BRONZE, 1, 2)
	style.content_margin_left = PAD_SM
	style.content_margin_right = PAD_SM
	style.content_margin_top = PAD_SM
	style.content_margin_bottom = PAD_SM
	return style

## Glass panel: near-transparent dark bg with full gold border + gold glow shadow.
## Used for champion boxes and featured elements over cinematic backgrounds.
static func panel_glass() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.02, 0.015, 0.01, 0.50)
	style.border_color = CLR_GOLD
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.shadow_color = Color(CLR_GOLD.r, CLR_GOLD.g, CLR_GOLD.b, 0.22)
	style.shadow_size = 8
	style.shadow_offset = Vector2(0, 2)
	style.content_margin_left = PAD_MD
	style.content_margin_right = PAD_MD
	style.content_margin_top = PAD_MD
	style.content_margin_bottom = PAD_MD
	return style

## Glass accent panel: nearly fully transparent with a single gold bottom border line.
## Used for mission cards and info blocks that float over the background.
static func panel_glass_accent() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.0, 0.0, 0.0, 0.12)
	style.border_color = CLR_GOLD
	style.border_width_bottom = 2
	style.content_margin_left = PAD_MD
	style.content_margin_right = PAD_MD
	style.content_margin_top = PAD_MD
	style.content_margin_bottom = PAD_MD
	return style

static func btn_primary() -> StyleBoxFlat:
	var style := _new_stylebox(CLR_GOLD, CLR_BRASS, 2, 3)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

static func btn_primary_hover() -> StyleBoxFlat:
	var style := _new_stylebox(CLR_BRASS, CLR_GOLD, 2, 3)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

static func btn_secondary() -> StyleBoxFlat:
	var style := _new_stylebox(Color(0, 0, 0, 0), CLR_BRONZE, 1, 3)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

static func btn_secondary_hover() -> StyleBoxFlat:
	var style := _new_stylebox(CLR_STONE_LITE, CLR_GOLD, 1, 3)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

static func btn_active() -> StyleBoxFlat:
	var style := _new_stylebox(CLR_STONE_MID, CLR_GOLD, 2, 3)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

static func btn_danger() -> StyleBoxFlat:
	var style := _new_stylebox(CLR_BLOOD, CLR_EMBER, 1, 3)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

static func btn_danger_hover() -> StyleBoxFlat:
	var style := _new_stylebox(CLR_BLOOD.lightened(0.10), CLR_EMBER, 2, 3)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

static func draw_corner_ornaments(canvas: CanvasItem, rect: Rect2, color: Color, size: float = 8.0) -> void:
	var corners := [
		Vector2(rect.position.x, rect.position.y),
		Vector2(rect.position.x + rect.size.x, rect.position.y),
		Vector2(rect.position.x, rect.position.y + rect.size.y),
		Vector2(rect.position.x + rect.size.x, rect.position.y + rect.size.y),
	]
	for center in corners:
		var top := Vector2(center.x, center.y - size * 0.5)
		var right := Vector2(center.x + size * 0.5, center.y)
		var bottom := Vector2(center.x, center.y + size * 0.5)
		var left := Vector2(center.x - size * 0.5, center.y)
		canvas.draw_line(top, right, color, 1.0)
		canvas.draw_line(right, bottom, color, 1.0)
		canvas.draw_line(bottom, left, color, 1.0)
		canvas.draw_line(left, top, color, 1.0)

static func draw_section_divider(canvas: CanvasItem, pos_y: float, width: float, color: Color) -> void:
	var center_x := width * 0.5
	canvas.draw_line(Vector2(20, pos_y), Vector2(center_x - 8.0, pos_y), color, 1.0)
	canvas.draw_line(Vector2(center_x + 8.0, pos_y), Vector2(width - 20.0, pos_y), color, 1.0)
	var top := Vector2(center_x, pos_y - 4.0)
	var right := Vector2(center_x + 4.0, pos_y)
	var bottom := Vector2(center_x, pos_y + 4.0)
	var left := Vector2(center_x - 4.0, pos_y)
	canvas.draw_line(top, right, color, 1.0)
	canvas.draw_line(right, bottom, color, 1.0)
	canvas.draw_line(bottom, left, color, 1.0)
	canvas.draw_line(left, top, color, 1.0)

static func draw_wax_seal(canvas: CanvasItem, center: Vector2, color: Color, radius: float = 6.0) -> void:
	canvas.draw_circle(center, radius, color)
	canvas.draw_arc(center, radius + 2.0, 0.0, TAU, 24, color, 1.5)

static func roman_numeral(n: int) -> String:
	var map := {
		1: "I", 2: "II", 3: "III", 4: "IV", 5: "V",
		6: "VI", 7: "VII", 8: "VIII", 9: "IX", 10: "X",
		11: "XI", 12: "XII", 13: "XIII", 14: "XIV", 15: "XV",
		16: "XVI", 17: "XVII", 18: "XVIII", 19: "XIX", 20: "XX",
	}
	return map.get(clampi(n, 1, 20), "I")

static func get_faction_color(faction: String) -> Color:
	match faction.strip_edges().to_upper():
		"AEGIS":
			return CLR_AEGIS
		"SPECTER":
			return CLR_SPECTER
		"ECLIPSE":
			return CLR_ECLIPSE
		"NEUTRAL":
			return CLR_GOLD
		_:
			return CLR_GOLD

static func get_meter_color(meter_name: String) -> Color:
	match meter_name.strip_edges().to_upper():
		"REPUTATION", "RENOWN":
			return CLR_METER_REPUTATION
		"DANGER", "HEAT":
			return CLR_METER_DANGER
		"FAITH", "PIETY":
			return CLR_METER_FAITH
		"ALLIES", "FAVOR":
			return CLR_METER_ALLIES
		"COST", "DEBT":
			return CLR_METER_COST
		"RESISTANCE", "DREAD":
			return CLR_METER_RESISTANCE
		_:
			return CLR_GOLD

static func background_color() -> Color:
	return CLR_VOID

static func make_panel_style(alt: bool = false) -> StyleBoxFlat:
	return panel_raised() if alt else panel_base()

static func make_button_style(color: Color) -> StyleBoxFlat:
	var style := _new_stylebox(color, CLR_BRONZE, 1, 3)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

static func style_button(btn: Button, label: String, h: int = 60) -> void:
	var upper := label.to_upper()
	btn.text = label
	btn.custom_minimum_size = Vector2(0, h)
	btn.add_theme_font_size_override("font_size", _scaled_font(FONT_SIZE_BODY))

	if upper.find("RETREAT") != -1 or upper.find("DELETE") != -1:
		btn.add_theme_color_override("font_color", CLR_VELLUM)
		btn.add_theme_stylebox_override("normal", btn_danger())
		btn.add_theme_stylebox_override("hover", btn_danger_hover())
		btn.add_theme_stylebox_override("pressed", btn_danger_hover())
		return

	if upper.find("BUY") != -1 \
			or upper.find("CONFIRM") != -1 \
			or upper.find("DEPLOY") != -1 \
			or upper.find("ENTER") != -1 \
			or upper.find("NEW CAMPAIGN") != -1 \
			or upper.find("SAVE") != -1 \
			or upper.find("READY") != -1:
		btn.add_theme_color_override("font_color", CLR_VOID)
		btn.add_theme_stylebox_override("normal", btn_primary())
		btn.add_theme_stylebox_override("hover", btn_primary_hover())
		btn.add_theme_stylebox_override("pressed", btn_active())
		return

	btn.add_theme_color_override("font_color", CLR_VELLUM)
	btn.add_theme_stylebox_override("normal", btn_secondary())
	btn.add_theme_stylebox_override("hover", btn_secondary_hover())
	btn.add_theme_stylebox_override("pressed", btn_active())

static func style_header(label: Label, size: int = FONT_SUBHEADER, gold: bool = false) -> void:
	label.add_theme_font_size_override("font_size", _scaled_font(size))
	label.add_theme_color_override("font_color", CLR_GOLD if gold else CLR_VELLUM)

static func style_body(label: Label, size: int = FONT_BODY, dim: bool = false) -> void:
	label.add_theme_font_size_override("font_size", _scaled_font(size))
	label.add_theme_color_override("font_color", CLR_PARCHMENT if dim else CLR_VELLUM)

static func rarity_color(rarity: String) -> Color:
	match rarity.to_lower():
		"common":
			return CLR_MUTED
		"uncommon":
			return CLR_AEGIS
		"rare":
			return CLR_GOLD
		"legendary":
			return CLR_BLOOD
		_:
			return CLR_PARCHMENT


