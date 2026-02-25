extends SceneTree

const OUT_PATH := "res://assets/ui/placeholder.png"
const IMG_SIZE := 128

const CLR_STONE_MID := Color(0.170, 0.135, 0.095, 1.0)
const CLR_BRONZE := Color(0.620, 0.440, 0.160, 1.0)
const CLR_MUTED := Color(0.500, 0.450, 0.360, 1.0)

func _init() -> void:
	var image := Image.create(IMG_SIZE, IMG_SIZE, false, Image.FORMAT_RGBA8)
	image.fill(CLR_STONE_MID)

	_draw_border(image, 2, CLR_BRONZE)
	_draw_question_mark(image, CLR_MUTED)

	var err := image.save_png(ProjectSettings.globalize_path(OUT_PATH))
	if err != OK:
		push_error("Failed to write placeholder PNG: %s" % OUT_PATH)
	quit()

func _draw_border(image: Image, border: int, color: Color) -> void:
	var max_x := image.get_width() - 1
	var max_y := image.get_height() - 1
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			if x < border or x > max_x - border or y < border or y > max_y - border:
				image.set_pixel(x, y, color)

func _draw_question_mark(image: Image, color: Color) -> void:
	var pattern: Array[String] = [
		"01110",
		"10001",
		"00001",
		"00010",
		"00100",
		"00000",
		"00100",
	]
	var scale: int = 10
	var glyph_w: int = pattern[0].length() * scale
	var glyph_h: int = pattern.size() * scale
	var start_x: int = int((image.get_width() - glyph_w) * 0.5)
	var start_y: int = int((image.get_height() - glyph_h) * 0.5)
	for row in range(pattern.size()):
		var row_pattern: String = pattern[row]
		for col in range(row_pattern.length()):
			if row_pattern[col] != "1":
				continue
			for py in range(scale):
				for px in range(scale):
					image.set_pixel(start_x + col * scale + px, start_y + row * scale + py, color)
