extends Control
## Card shop — buy cards using gold

var shop_pool: Array = []
var card_rows: VBoxContainer
var gold_label: Label
var msg_label: Label

func _ready() -> void:
	_generate_shop_pool()
	_build_ui()

func _generate_shop_pool() -> void:
	# Offer 6 random cards not already in the deck
	var all_ids = CardManager.cards_data.keys()
	all_ids.shuffle()
	shop_pool = []
	for id in all_ids:
		if id not in GameState.current_deck:
			shop_pool.append(id)
		if shop_pool.size() >= 6:
			break

func _build_ui() -> void:
	var bg = ColorRect.new()
	bg.color = Color(0.07, 0.07, 0.09)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var scroll = ScrollContainer.new()
	scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(scroll)

	var vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 10)
	scroll.add_child(vbox)

	# Title
	var title = Label.new()
	title.text = "CARD MARKET"
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color(0.9, 0.75, 0.4))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	# Gold display
	gold_label = Label.new()
	gold_label.add_theme_font_size_override("font_size", 14)
	gold_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	vbox.add_child(gold_label)
	_refresh_gold()

	# Message label
	msg_label = Label.new()
	msg_label.add_theme_font_size_override("font_size", 12)
	msg_label.add_theme_color_override("font_color", Color(0.5, 0.9, 0.5))
	vbox.add_child(msg_label)

	var sep = HSeparator.new()
	vbox.add_child(sep)

	# Card rows
	card_rows = VBoxContainer.new()
	card_rows.add_theme_constant_override("separation", 8)
	vbox.add_child(card_rows)
	_build_card_rows()

	var sep2 = HSeparator.new()
	vbox.add_child(sep2)

	# Back button
	var back_btn = _make_button("← BACK TO HUB", Color(0.25, 0.1, 0.1))
	back_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/MainHub.tscn"))
	vbox.add_child(back_btn)

func _build_card_rows() -> void:
	for child in card_rows.get_children():
		child.queue_free()

	if shop_pool.is_empty():
		var empty = Label.new()
		empty.text = "Nothing for sale right now."
		empty.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
		card_rows.add_child(empty)
		return

	for card_id in shop_pool:
		var card = CardManager.get_card(card_id)
		if card.is_empty():
			continue

		var price = _card_price(card)
		var row = HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		card_rows.add_child(row)

		var info = Label.new()
		var effect_text = card.get("effect", "")
		var dmg = card.get("damage", 0)
		var armor = card.get("armor", 0)
		var heal = card.get("heal", 0)
		var stat_str = ""
		if dmg > 0: stat_str += " %ddmg" % dmg
		if armor > 0: stat_str += " +%d armor" % armor
		if heal > 0: stat_str += " heal %d" % heal
		if effect_text != "": stat_str += " [%s]" % effect_text
		info.text = "[%s] %s (cost %d)%s — %dg" % [
			card.get("faction", "?"), card.get("name", card_id),
			card.get("cost", 1), stat_str, price
		]
		info.add_theme_font_size_override("font_size", 12)
		info.add_theme_color_override("font_color", _faction_color(card.get("faction", "")))
		info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(info)

		var buy_btn = _make_button("BUY %dg" % price, Color(0.1, 0.3, 0.1))
		buy_btn.pressed.connect(_on_buy.bind(card_id, price))
		if GameState.gold < price or GameState.current_deck.size() >= 30:
			buy_btn.disabled = true
		row.add_child(buy_btn)

func _on_buy(card_id: String, price: int) -> void:
	if GameState.spend_gold(price):
		GameState.add_card(card_id)
		shop_pool.erase(card_id)
		msg_label.text = "Purchased %s!" % CardManager.get_card(card_id).get("name", card_id)
		_refresh_gold()
		_build_card_rows()
	else:
		msg_label.text = "Not enough gold."

func _refresh_gold() -> void:
	gold_label.text = "Gold: %d  |  Deck size: %d/30" % [GameState.gold, GameState.current_deck.size()]

func _card_price(card: Dictionary) -> int:
	var base = card.get("cost", 1) * 20
	var pi = card.get("power_index", 1)
	return base + (pi * 10)

func _faction_color(faction: String) -> Color:
	match faction:
		"AEGIS":    return Color(0.5, 0.7, 1.0)
		"SPECTER":  return Color(0.75, 0.5, 1.0)
		"ECLIPSE":  return Color(1.0, 0.85, 0.4)
		_:          return Color(0.8, 0.8, 0.8)

func _make_button(text: String, color: Color) -> Button:
	var btn = Button.new()
	btn.text = text
	btn.add_theme_font_size_override("font_size", 12)
	btn.add_theme_color_override("font_color", Color.WHITE)
	btn.add_theme_stylebox_override("normal", _make_style(color))
	btn.add_theme_stylebox_override("hover", _make_style(color.lightened(0.15)))
	btn.add_theme_stylebox_override("pressed", _make_style(color.darkened(0.15)))
	btn.custom_minimum_size = Vector2(0, 32)
	return btn

func _make_style(color: Color) -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = color
	s.corner_radius_top_left = 4
	s.corner_radius_top_right = 4
	s.corner_radius_bottom_left = 4
	s.corner_radius_bottom_right = 4
	s.content_margin_left = 12
	s.content_margin_right = 12
	s.content_margin_top = 4
	s.content_margin_bottom = 4
	return s
