extends RefCounted
class_name UITypography

const FONT_TITLE := 34
const FONT_SECTION := 22
const FONT_SUBHEADER := 17
const FONT_BODY := 14
const FONT_SECONDARY := 12
const FONT_FINE := 10

const FONT_CANDIDATES := [
	"res://assets/fonts/SairaCondensed-SemiBold.ttf",
	"res://assets/fonts/RobotoCondensed-Bold.ttf",
	"res://assets/fonts/Inter-SemiBold.ttf",
	"res://assets/ui/fonts/SairaCondensed-SemiBold.ttf",
]

static var _cached_font: Font

static func resolve_font() -> Font:
	if _cached_font != null:
		return _cached_font
	for path in FONT_CANDIDATES:
		if ResourceLoader.exists(path):
			var loaded := load(path)
			if loaded is Font:
				_cached_font = loaded
				return _cached_font
	_cached_font = ThemeDB.fallback_font
	return _cached_font

static func scale(accessibility: Dictionary = {}) -> float:
	return clampf(float(accessibility.get("text_scale", 1.0)), 0.8, 1.5)

static func scaled_size(base_size: int, accessibility: Dictionary = {}) -> int:
	return int(round(float(base_size) * scale(accessibility)))
