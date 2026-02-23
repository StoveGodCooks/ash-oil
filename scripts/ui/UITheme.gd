extends RefCounted
class_name UITheme

const FONT_TITLE := 32
const FONT_SECTION := 24
const FONT_SUBHEADER := 16
const FONT_BODY := 14
const FONT_SECONDARY := 12
const FONT_FINE := 10

const PAD_SM := 10
const PAD_MD := 15
const PAD_LG := 20

const COLOR_BG := Color(0.07, 0.06, 0.05)
const COLOR_BG_PANEL := Color(0.16, 0.13, 0.10, 0.86)
const COLOR_BG_PANEL_ALT := Color(0.13, 0.10, 0.08, 0.92)
const COLOR_TEXT := Color(0.93, 0.90, 0.83)
const COLOR_TEXT_DIM := Color(0.74, 0.70, 0.64)
const COLOR_GOLD := Color(0.94, 0.78, 0.38)
const COLOR_BORDER := Color(0.56, 0.44, 0.26)
const COLOR_BUTTON := Color(0.29, 0.20, 0.13)
const COLOR_BUTTON_HOVER := Color(0.40, 0.27, 0.16)
const COLOR_BUTTON_PRESS := Color(0.20, 0.13, 0.09)

static func _accessibility() -> Dictionary:
	if typeof(GameState) == TYPE_NIL:
		return {}
	return GameState.accessibility

static func _font_scale() -> float:
	var settings := _accessibility()
	return clampf(float(settings.get("text_scale", 1.0)), 0.8, 1.5)

static func _palette() -> Dictionary:
	var settings := _accessibility()
	var high_contrast: bool = bool(settings.get("high_contrast", false))
	var colorblind_mode: bool = bool(settings.get("colorblind_mode", false))
	if high_contrast:
		return {
			"bg": Color(0.01, 0.01, 0.01),
			"panel": Color(0.08, 0.08, 0.08, 0.97),
			"panel_alt": Color(0.11, 0.11, 0.11, 0.98),
			"text": Color(0.98, 0.98, 0.98),
			"text_dim": Color(0.86, 0.86, 0.86),
			"gold": Color(1.0, 0.92, 0.45),
			"border": Color(0.95, 0.95, 0.95),
			"button": Color(0.15, 0.15, 0.15),
			"button_hover": Color(0.24, 0.24, 0.24),
			"button_press": Color(0.08, 0.08, 0.08),
		}
	if colorblind_mode:
		return {
			"bg": Color(0.08, 0.09, 0.11),
			"panel": Color(0.14, 0.16, 0.20, 0.88),
			"panel_alt": Color(0.12, 0.14, 0.18, 0.94),
			"text": Color(0.93, 0.94, 0.95),
			"text_dim": Color(0.73, 0.78, 0.83),
			"gold": Color(0.98, 0.83, 0.31),
			"border": Color(0.34, 0.56, 0.79),
			"button": Color(0.19, 0.28, 0.37),
			"button_hover": Color(0.24, 0.37, 0.50),
			"button_press": Color(0.14, 0.22, 0.31),
		}
	return {
		"bg": COLOR_BG,
		"panel": COLOR_BG_PANEL,
		"panel_alt": COLOR_BG_PANEL_ALT,
		"text": COLOR_TEXT,
		"text_dim": COLOR_TEXT_DIM,
		"gold": COLOR_GOLD,
		"border": COLOR_BORDER,
		"button": COLOR_BUTTON,
		"button_hover": COLOR_BUTTON_HOVER,
		"button_press": COLOR_BUTTON_PRESS,
	}

static func background_color() -> Color:
	return _palette()["bg"]

static func make_panel_style(alt: bool = false) -> StyleBoxFlat:
	var p := _palette()
	var s := StyleBoxFlat.new()
	s.bg_color = p["panel_alt"] if alt else p["panel"]
	s.border_color = p["border"]
	s.border_width_left = 2
	s.border_width_top = 2
	s.border_width_right = 2
	s.border_width_bottom = 2
	s.corner_radius_top_left = 6
	s.corner_radius_top_right = 6
	s.corner_radius_bottom_left = 6
	s.corner_radius_bottom_right = 6
	s.content_margin_left = PAD_MD
	s.content_margin_right = PAD_MD
	s.content_margin_top = PAD_MD
	s.content_margin_bottom = PAD_MD
	return s

static func make_button_style(color: Color) -> StyleBoxFlat:
	var p := _palette()
	var s := StyleBoxFlat.new()
	s.bg_color = color
	s.border_color = p["border"]
	s.border_width_left = 2
	s.border_width_top = 2
	s.border_width_right = 2
	s.border_width_bottom = 2
	s.corner_radius_top_left = 6
	s.corner_radius_top_right = 6
	s.corner_radius_bottom_left = 6
	s.corner_radius_bottom_right = 6
	s.content_margin_left = 14
	s.content_margin_right = 14
	s.content_margin_top = 10
	s.content_margin_bottom = 10
	return s

static func style_button(btn: Button, label: String, h: int = 60) -> void:
	var p := _palette()
	btn.text = label
	btn.custom_minimum_size = Vector2(0, h)
	btn.add_theme_font_size_override("font_size", int(round(float(FONT_BODY) * _font_scale())))
	btn.add_theme_color_override("font_color", p["text"])
	btn.add_theme_stylebox_override("normal", make_button_style(p["button"]))
	btn.add_theme_stylebox_override("hover", make_button_style(p["button_hover"]))
	btn.add_theme_stylebox_override("pressed", make_button_style(p["button_press"]))

static func style_header(label: Label, size: int = FONT_SUBHEADER, gold: bool = false) -> void:
	var p := _palette()
	label.add_theme_font_size_override("font_size", int(round(float(size) * _font_scale())))
	label.add_theme_color_override("font_color", p["gold"] if gold else p["text"])

static func style_body(label: Label, size: int = FONT_BODY, dim: bool = false) -> void:
	var p := _palette()
	label.add_theme_font_size_override("font_size", int(round(float(size) * _font_scale())))
	label.add_theme_color_override("font_color", p["text_dim"] if dim else p["text"])

static func rarity_color(rarity: String) -> Color:
	var colorblind_mode: bool = bool(_accessibility().get("colorblind_mode", false))
	if colorblind_mode:
		match rarity.to_lower():
			"common":
				return Color(0.70, 0.70, 0.72)
			"uncommon":
				return Color(0.39, 0.73, 0.92)
			"rare":
				return Color(0.96, 0.74, 0.30)
			"legendary":
				return Color(0.92, 0.52, 0.21)
			_:
				return Color(0.75, 0.75, 0.75)
	match rarity.to_lower():
		"common":
			return Color(0.65, 0.65, 0.65)
		"uncommon":
			return Color(0.45, 0.65, 0.95)
		"rare":
			return Color(0.95, 0.79, 0.34)
		"legendary":
			return Color(0.87, 0.32, 0.22)
		_:
			return Color(0.75, 0.75, 0.75)
