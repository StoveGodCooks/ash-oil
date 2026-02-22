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

static func make_panel_style(alt: bool = false) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = COLOR_BG_PANEL_ALT if alt else COLOR_BG_PANEL
	s.border_color = COLOR_BORDER
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
	var s := StyleBoxFlat.new()
	s.bg_color = color
	s.border_color = COLOR_BORDER
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
	btn.text = label
	btn.custom_minimum_size = Vector2(0, h)
	btn.add_theme_font_size_override("font_size", FONT_BODY)
	btn.add_theme_color_override("font_color", COLOR_TEXT)
	btn.add_theme_stylebox_override("normal", make_button_style(COLOR_BUTTON))
	btn.add_theme_stylebox_override("hover", make_button_style(COLOR_BUTTON_HOVER))
	btn.add_theme_stylebox_override("pressed", make_button_style(COLOR_BUTTON_PRESS))

static func style_header(label: Label, size: int = FONT_SUBHEADER, gold: bool = false) -> void:
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", COLOR_GOLD if gold else COLOR_TEXT)

static func style_body(label: Label, size: int = FONT_BODY, dim: bool = false) -> void:
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", COLOR_TEXT_DIM if dim else COLOR_TEXT)

static func rarity_color(rarity: String) -> Color:
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
