extends RefCounted
class_name UIPalette

# Single source of truth for hub/UI palette and lighting.

const LIGHT_DIR := Vector2(-0.58, -0.82)

const BASE := {
	"bg_0": Color(0.035, 0.045, 0.060, 1.0),
	"bg_1": Color(0.060, 0.090, 0.125, 1.0),
	"panel": Color(0.085, 0.125, 0.165, 0.92),
	"panel_alt": Color(0.070, 0.105, 0.145, 0.94),
	"panel_focus": Color(0.115, 0.165, 0.220, 0.96),
	"text": Color(0.905, 0.940, 0.985, 1.0),
	"text_dim": Color(0.645, 0.745, 0.835, 1.0),
	"border": Color(0.285, 0.430, 0.560, 1.0),
	"shadow": Color(0.000, 0.000, 0.000, 0.55),
	"accent": Color(0.580, 0.850, 1.000, 1.0),
	"accent_soft": Color(0.330, 0.620, 0.810, 1.0),
	"accent_hot": Color(0.960, 0.770, 0.360, 1.0),
	"ok": Color(0.450, 0.880, 0.630, 1.0),
	"warn": Color(0.930, 0.810, 0.390, 1.0),
	"danger": Color(0.930, 0.380, 0.330, 1.0),
	"fog": Color(0.620, 0.790, 0.930, 0.11),
}

const HIGH_CONTRAST := {
	"bg_0": Color(0.010, 0.010, 0.010, 1.0),
	"bg_1": Color(0.050, 0.050, 0.050, 1.0),
	"panel": Color(0.080, 0.080, 0.080, 0.97),
	"panel_alt": Color(0.115, 0.115, 0.115, 0.98),
	"panel_focus": Color(0.170, 0.170, 0.170, 0.98),
	"text": Color(0.985, 0.985, 0.985, 1.0),
	"text_dim": Color(0.860, 0.860, 0.860, 1.0),
	"border": Color(0.920, 0.920, 0.920, 1.0),
	"shadow": Color(0.000, 0.000, 0.000, 0.75),
	"accent": Color(0.960, 0.960, 0.960, 1.0),
	"accent_soft": Color(0.780, 0.780, 0.780, 1.0),
	"accent_hot": Color(1.000, 0.930, 0.500, 1.0),
	"ok": Color(0.760, 1.000, 0.830, 1.0),
	"warn": Color(1.000, 0.910, 0.580, 1.0),
	"danger": Color(1.000, 0.640, 0.640, 1.0),
	"fog": Color(0.930, 0.930, 0.930, 0.08),
}

const COLORBLIND := {
	"bg_0": Color(0.045, 0.055, 0.070, 1.0),
	"bg_1": Color(0.070, 0.090, 0.120, 1.0),
	"panel": Color(0.100, 0.135, 0.180, 0.93),
	"panel_alt": Color(0.085, 0.120, 0.165, 0.95),
	"panel_focus": Color(0.125, 0.175, 0.235, 0.97),
	"text": Color(0.920, 0.940, 0.965, 1.0),
	"text_dim": Color(0.700, 0.760, 0.825, 1.0),
	"border": Color(0.300, 0.460, 0.640, 1.0),
	"shadow": Color(0.000, 0.000, 0.000, 0.58),
	"accent": Color(0.330, 0.650, 0.980, 1.0),
	"accent_soft": Color(0.250, 0.520, 0.820, 1.0),
	"accent_hot": Color(0.980, 0.800, 0.340, 1.0),
	"ok": Color(0.440, 0.820, 0.710, 1.0),
	"warn": Color(0.990, 0.830, 0.360, 1.0),
	"danger": Color(0.940, 0.500, 0.340, 1.0),
	"fog": Color(0.660, 0.800, 0.920, 0.10),
}

static func resolve(accessibility: Dictionary = {}) -> Dictionary:
	if bool(accessibility.get("high_contrast", false)):
		return HIGH_CONTRAST.duplicate()
	if bool(accessibility.get("colorblind_mode", false)):
		return COLORBLIND.duplicate()
	return BASE.duplicate()

static func with_alpha(c: Color, alpha: float) -> Color:
	return Color(c.r, c.g, c.b, alpha)
