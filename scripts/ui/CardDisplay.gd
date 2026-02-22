extends Control
## Card display with frame, portrait, and text overlay system

# ── Signals ──
signal card_pressed()

# ── Parchment & Wax palette (shared with other UI) ──
const CLR_BG      = Color(0.08, 0.065, 0.050)
const CLR_PANEL   = Color(0.14, 0.110, 0.080)
const CLR_BORDER  = Color(0.42, 0.320, 0.160)
const CLR_ACCENT  = Color(0.86, 0.700, 0.360)
const CLR_TEXT    = Color(0.90, 0.840, 0.680)
const CLR_MUTED   = Color(0.58, 0.520, 0.400)
const FRAME_PATH = "res://assets/cards/frame_front.png"

# ── Member variables ──
var current_card_id: String = ""
var current_faction: String = "NEUTRAL"

# ── Onready references ──
@onready var frame_texture = $FrameTexture
@onready var portrait_rect = $PortraitRect
@onready var portrait_tint = $PortraitTint
@onready var stats_panel = $StatsPanel
@onready var name_label = $StatsPanel/VBox/NameLabel
@onready var cost_label = $StatsPanel/VBox/CostLabel
@onready var stats_label = $StatsPanel/VBox/StatsLabel
@onready var effect_label = $StatsPanel/VBox/EffectLabel

func _ready() -> void:
	# Default card size: 180×270
	custom_minimum_size = Vector2(180, 270)
	mouse_filter = MOUSE_FILTER_STOP
	gui_input.connect(_on_gui_input)

func set_card(card_id: String) -> void:
	"""Load and display a card by ID"""
	if card_id.is_empty():
		return

	var card = CardManager.get_card(card_id)
	if card.is_empty():
		return

	current_card_id = card_id

	# Load or create portrait
	var hero_name = card.get("hero", card_id)
	var portrait_path = "res://assets/characters/%s.png" % hero_name.to_lower()

	# Try to load real portrait, fall back to placeholder
	var portrait_tex = load(portrait_path)
	if portrait_tex:
		portrait_rect.texture = portrait_tex
	else:
		_create_placeholder_portrait(hero_name, card.get("faction", "NEUTRAL"))

	# Set faction tint
	var faction = card.get("faction", "NEUTRAL")
	current_faction = faction
	_set_faction_tint(faction)

	# Populate text labels
	name_label.text = card.get("name", "Unknown")
	cost_label.text = "⭐%d | %s" % [card.get("cost", 0), faction]

	# Build stats string
	var dmg = card.get("damage", 0)
	var armor = card.get("armor", 0)
	var heal = card.get("heal", 0)
	var stats_parts = []
	if dmg > 0:
		stats_parts.append("⚔ %d dmg" % dmg)
	if armor > 0:
		stats_parts.append("🛡 +%d arm" % armor)
	if heal > 0:
		stats_parts.append("💚 heal %d" % heal)
	stats_label.text = " | ".join(stats_parts) if stats_parts.size() > 0 else ""

	# Effect description
	var effect = card.get("effect", "")
	effect_label.text = effect if effect != "" else ""

func set_card_size(size: Vector2) -> void:
	"""Resize card for different contexts (hand: 120×180, preview: 180×270)"""
	custom_minimum_size = size

func _create_placeholder_portrait(hero_name: String, faction: String) -> void:
	"""Create a placeholder portrait (solid color + text) until real art is available"""
	var placeholder = ColorRect.new()
	placeholder.color = _faction_to_color(faction, 0.9)
	placeholder.custom_minimum_size = Vector2(160, 180)

	# Add centered text
	var label = Label.new()
	label.text = hero_name.to_upper()
	label.add_theme_font_size_override("font_size", 16)
	label.add_theme_color_override("font_color", Color(1, 1, 1, 0.8))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	placeholder.add_child(label)

	portrait_rect.texture = null
	portrait_rect.add_child(placeholder)

func _set_faction_tint(faction: String) -> void:
	"""Set the semi-transparent tint overlay color by faction"""
	portrait_tint.color = _faction_to_color(faction, 0.20)

func _faction_to_color(faction: String, alpha: float) -> Color:
	"""Convert faction name to color with specified alpha"""
	match faction:
		"AEGIS":
			return Color(0.1, 0.2, 0.5, alpha)
		"SPECTER":
			return Color(0.3, 0.1, 0.4, alpha)
		"ECLIPSE":
			return Color(0.5, 0.3, 0.0, alpha)
		_:
			return Color(0.3, 0.3, 0.3, alpha)

func _on_gui_input(event: InputEvent) -> void:
	"""Handle input events on the card"""
	if event is InputEventMouseButton and event.pressed:
		card_pressed.emit()
