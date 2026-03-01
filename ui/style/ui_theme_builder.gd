class_name UIThemeBuilder
extends RefCounted

const UI_PALETTE := preload("res://ui/style/ui_palette.gd")
const UI_METRICS := preload("res://ui/style/ui_metrics.gd")
const UI_TYPO := preload("res://ui/style/ui_typography.gd")

static func build_theme(accessibility: Dictionary = {}) -> Theme:
	var p := UI_PALETTE.resolve(accessibility)
	var t := Theme.new()
	var font := UI_TYPO.resolve_font()
	var size_body := UI_TYPO.scaled_size(UI_TYPO.FONT_BODY, accessibility)
	var size_sub := UI_TYPO.scaled_size(UI_TYPO.FONT_SUBHEADER, accessibility)
	var size_fine := UI_TYPO.scaled_size(UI_TYPO.FONT_SECONDARY, accessibility)

	if font != null:
		t.default_font = font
	t.default_font_size = size_body

	t.set_color("font_color", "Label", p["text"])
	t.set_color("font_outline_color", "Label", p["shadow"])
	t.set_constant("outline_size", "Label", 1)

	t.set_color("font_color", "Button", p["text"])
	t.set_color("font_focus_color", "Button", p["accent"])
	t.set_color("font_hover_color", "Button", Color(1.0, 1.0, 1.0, 1.0))
	t.set_color("font_pressed_color", "Button", Color(1.0, 1.0, 1.0, 1.0))
	t.set_color("font_disabled_color", "Button", UI_PALETTE.with_alpha(p["text_dim"], 0.85))
	t.set_constant("outline_size", "Button", 1)
	t.set_color("font_outline_color", "Button", p["shadow"])
	t.set_constant("h_separation", "Button", UI_METRICS.PAD_SM)
	t.set_constant("icon_max_width", "Button", 20)
	t.set_font_size("font_size", "Button", size_body)
	t.set_stylebox("normal", "Button", make_button_style(p))
	t.set_stylebox("hover", "Button", make_button_style(p, "hover"))
	t.set_stylebox("pressed", "Button", make_button_style(p, "pressed"))
	t.set_stylebox("focus", "Button", make_focus_style(p))
	t.set_stylebox("disabled", "Button", make_button_style(p, "disabled"))

	t.set_stylebox("panel", "PanelContainer", make_panel_style(p))
	t.set_stylebox("panel", "PopupPanel", make_panel_style(p, false, true))

	t.set_stylebox("panel", "ProgressBar", _progress_bg_style(p))
	t.set_stylebox("fill", "ProgressBar", _progress_fill_style(p))
	t.set_font_size("font_size", "ProgressBar", size_fine)
	t.set_color("font_color", "ProgressBar", p["text"])

	t.set_constant("separation", "VBoxContainer", UI_METRICS.PAD_SM)
	t.set_constant("separation", "HBoxContainer", UI_METRICS.PAD_SM)
	t.set_constant("h_separation", "GridContainer", UI_METRICS.PAD_SM)
	t.set_constant("v_separation", "GridContainer", UI_METRICS.PAD_SM)

	t.set_stylebox("focus", "LineEdit", make_focus_style(p))
	t.set_stylebox("normal", "LineEdit", make_button_style(p, "alt"))
	t.set_stylebox("read_only", "LineEdit", make_button_style(p, "disabled"))
	t.set_color("font_color", "LineEdit", p["text"])
	t.set_font_size("font_size", "LineEdit", size_body)

	t.set_stylebox("normal", "CheckBox", make_button_style(p, "alt"))
	t.set_stylebox("hover", "CheckBox", make_button_style(p, "hover"))
	t.set_stylebox("pressed", "CheckBox", make_button_style(p, "pressed"))
	t.set_stylebox("focus", "CheckBox", make_focus_style(p))
	t.set_color("font_color", "CheckBox", p["text"])
	t.set_font_size("font_size", "CheckBox", size_body)

	t.set_font_size("font_size", "HSlider", size_fine)
	t.set_color("font_color", "HSlider", p["text"])

	t.set_font_size("font_size", "RichTextLabel", size_body)
	t.set_color("default_color", "RichTextLabel", p["text"])
	t.set_font_size("normal_font_size", "RichTextLabel", size_body)
	t.set_font_size("bold_font_size", "RichTextLabel", size_sub)

	return t

static func make_panel_style(p: Dictionary, focused: bool = false, alt: bool = false) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	var bg: Color = p["panel_alt"] if alt else p["panel"]
	s.bg_color = p["panel_focus"] if focused else bg
	s.border_color = p["accent"] if focused else p["border"]
	s.border_width_left = UI_METRICS.STROKE_MED
	s.border_width_top = UI_METRICS.STROKE_MED
	s.border_width_right = UI_METRICS.STROKE_MED
	s.border_width_bottom = UI_METRICS.STROKE_MED
	s.corner_radius_top_left = UI_METRICS.RADIUS_MD
	s.corner_radius_top_right = UI_METRICS.RADIUS_MD
	s.corner_radius_bottom_left = UI_METRICS.RADIUS_MD
	s.corner_radius_bottom_right = UI_METRICS.RADIUS_MD
	s.shadow_color = UI_PALETTE.with_alpha(p["shadow"], UI_METRICS.SHADOW_ALPHA)
	s.shadow_size = UI_METRICS.SHADOW_SIZE
	s.content_margin_left = UI_METRICS.PAD_MD
	s.content_margin_top = UI_METRICS.PAD_MD
	s.content_margin_right = UI_METRICS.PAD_MD
	s.content_margin_bottom = UI_METRICS.PAD_MD
	return s

static func make_button_style(p: Dictionary, tone: String = "base", selected: bool = false) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	var panel: Color = p["panel"]
	var panel_alt: Color = p["panel_alt"]
	var panel_focus: Color = p["panel_focus"]
	var accent_soft: Color = p["accent_soft"]
	var danger: Color = p["danger"]
	var bg: Color = panel_alt
	match tone:
		"base":
			bg = panel_alt
		"hover":
			bg = panel_focus
		"pressed":
			bg = Color(panel_focus.r * 0.78, panel_focus.g * 0.78, panel_focus.b * 0.78, panel_focus.a)
		"disabled":
			bg = Color(panel_alt.r * 0.65, panel_alt.g * 0.65, panel_alt.b * 0.65, 0.82)
		"accent":
			bg = Color(accent_soft.r * 0.65, accent_soft.g * 0.65, accent_soft.b * 0.65, 0.92)
		"danger":
			bg = Color(danger.r * 0.45, danger.g * 0.45, danger.b * 0.45, 0.90)
		"alt":
			bg = panel

	s.bg_color = bg
	s.border_color = p["accent"] if selected else p["border"]
	s.border_width_left = UI_METRICS.STROKE_MED
	s.border_width_top = UI_METRICS.STROKE_MED
	s.border_width_right = UI_METRICS.STROKE_MED
	s.border_width_bottom = UI_METRICS.STROKE_MED
	s.corner_radius_top_left = UI_METRICS.RADIUS_SM
	s.corner_radius_top_right = UI_METRICS.RADIUS_SM
	s.corner_radius_bottom_left = UI_METRICS.RADIUS_SM
	s.corner_radius_bottom_right = UI_METRICS.RADIUS_SM
	s.shadow_color = UI_PALETTE.with_alpha(p["shadow"], 0.32)
	s.shadow_size = UI_METRICS.SHADOW_SIZE / 2
	s.content_margin_left = UI_METRICS.PAD_MD
	s.content_margin_top = UI_METRICS.PAD_SM
	s.content_margin_right = UI_METRICS.PAD_MD
	s.content_margin_bottom = UI_METRICS.PAD_SM
	return s

static func make_focus_style(p: Dictionary) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.draw_center = false
	s.border_color = p["accent_hot"]
	s.border_width_left = UI_METRICS.STROKE_HEAVY
	s.border_width_top = UI_METRICS.STROKE_HEAVY
	s.border_width_right = UI_METRICS.STROKE_HEAVY
	s.border_width_bottom = UI_METRICS.STROKE_HEAVY
	s.corner_radius_top_left = UI_METRICS.RADIUS_SM
	s.corner_radius_top_right = UI_METRICS.RADIUS_SM
	s.corner_radius_bottom_left = UI_METRICS.RADIUS_SM
	s.corner_radius_bottom_right = UI_METRICS.RADIUS_SM
	return s

static func _progress_bg_style(p: Dictionary) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = Color(p["panel"].r * 0.8, p["panel"].g * 0.8, p["panel"].b * 0.8, 0.96)
	s.corner_radius_top_left = UI_METRICS.RADIUS_SM
	s.corner_radius_top_right = UI_METRICS.RADIUS_SM
	s.corner_radius_bottom_left = UI_METRICS.RADIUS_SM
	s.corner_radius_bottom_right = UI_METRICS.RADIUS_SM
	s.border_color = p["border"]
	s.border_width_left = 1
	s.border_width_top = 1
	s.border_width_right = 1
	s.border_width_bottom = 1
	return s

static func _progress_fill_style(p: Dictionary) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = p["accent_soft"]
	s.corner_radius_top_left = UI_METRICS.RADIUS_SM
	s.corner_radius_top_right = UI_METRICS.RADIUS_SM
	s.corner_radius_bottom_left = UI_METRICS.RADIUS_SM
	s.corner_radius_bottom_right = UI_METRICS.RADIUS_SM
	return s


