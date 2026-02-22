extends Control
## Card shop — buy cards using gold

# ── Parchment & Wax palette ──
const CLR_BG     = Color(0.08, 0.065, 0.050)
const CLR_PANEL  = Color(0.14, 0.110, 0.080)
const CLR_BORDER = Color(0.42, 0.320, 0.160)
const CLR_ACCENT = Color(0.86, 0.700, 0.360)
const CLR_TEXT   = Color(0.90, 0.840, 0.680)
const CLR_MUTED  = Color(0.58, 0.520, 0.400)
const CLR_BUY    = Color(0.14, 0.220, 0.150)
const CLR_DANGER = Color(0.26, 0.095, 0.090)
const CLR_STONE  = Color(0.18, 0.155, 0.120)
const CLR_SEAL   = Color(0.36, 0.12, 0.10)

var shop_pool: Array = []
var card_rows: VBoxContainer
var gear_rows: VBoxContainer
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
	bg.color = CLR_BG
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var stone_top = ColorRect.new()
	stone_top.color = CLR_STONE
	stone_top.set_anchors_preset(Control.PRESET_TOP_WIDE)
	stone_top.custom_minimum_size = Vector2(0, 56)
	add_child(stone_top)

	var vignette = ColorRect.new()
	vignette.color = Color(0, 0, 0, 0.20)
	vignette.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(vignette)

	var scroll = ScrollContainer.new()
	scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(scroll)

	var vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 10)
	scroll.add_child(vbox)

	# Title panel
	var title_panel = PanelContainer.new()
	title_panel.add_theme_stylebox_override("panel", _make_style(CLR_PANEL))
	vbox.add_child(title_panel)

	var title_margin = MarginContainer.new()
	title_margin.add_theme_constant_override("margin_left", 12)
	title_margin.add_theme_constant_override("margin_right", 12)
	title_margin.add_theme_constant_override("margin_top", 8)
	title_margin.add_theme_constant_override("margin_bottom", 8)
	title_panel.add_child(title_margin)

	var title_row = HBoxContainer.new()
	title_row.add_theme_constant_override("separation", 10)
	title_margin.add_child(title_row)

	var title = Label.new()
	title.text = "FORUM MARKET"
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", CLR_ACCENT)
	title_row.add_child(title)

	var crest = Label.new()
	crest.text = "◈  MERCHANTS OF THE ARENA  ◈"
	crest.add_theme_font_size_override("font_size", 10)
	crest.add_theme_color_override("font_color", CLR_MUTED)
	title_row.add_child(crest)

	var title_spacer = Control.new()
	title_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_row.add_child(title_spacer)

	var gold_pill = _make_pill("Gold: 0", CLR_ACCENT)
	gold_label = gold_pill.get_meta("label")
	title_row.add_child(gold_pill)

	# Message label
	msg_label = Label.new()
	msg_label.add_theme_font_size_override("font_size", 12)
	msg_label.add_theme_color_override("font_color", CLR_MUTED)
	vbox.add_child(msg_label)
	_refresh_gold()

	var sep = HSeparator.new()
	sep.add_theme_color_override("color", CLR_BORDER)
	vbox.add_child(sep)

	# Card rows
	card_rows = VBoxContainer.new()
	card_rows.add_theme_constant_override("separation", 8)
	vbox.add_child(card_rows)
	_build_card_rows()

	var sep2 = HSeparator.new()
	sep2.add_theme_color_override("color", CLR_BORDER)
	vbox.add_child(sep2)

	# Gear section header
	var gear_title = Label.new()
	gear_title.text = "GEAR FOR SALE"
	gear_title.add_theme_font_size_override("font_size", 18)
	gear_title.add_theme_color_override("font_color", CLR_ACCENT)
	gear_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(gear_title)

	var gear_seal = PanelContainer.new()
	gear_seal.custom_minimum_size = Vector2(24, 24)
	gear_seal.add_theme_stylebox_override("panel", _seal_style())
	vbox.add_child(gear_seal)

	gear_rows = VBoxContainer.new()
	gear_rows.add_theme_constant_override("separation", 6)
	vbox.add_child(gear_rows)
	_build_gear_rows()

	var sep3 = HSeparator.new()
	sep3.add_theme_color_override("color", CLR_BORDER)
	vbox.add_child(sep3)

	# Back button
	var back_btn = _make_button("← BACK TO HUB", CLR_DANGER)
	back_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/MainHub.tscn"))
	vbox.add_child(back_btn)

func _build_card_rows() -> void:
	for child in card_rows.get_children():
		child.queue_free()

	if shop_pool.is_empty():
		var empty = Label.new()
		empty.text = "Nothing for sale right now."
		empty.add_theme_color_override("font_color", CLR_MUTED)
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

		var buy_btn = _make_button("BUY %dg" % price, CLR_BUY)
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
	btn.add_theme_color_override("font_color", CLR_TEXT)
	btn.add_theme_stylebox_override("normal", _make_style(color))
	btn.add_theme_stylebox_override("hover", _make_style(color.lightened(0.15)))
	btn.add_theme_stylebox_override("pressed", _make_style(color.darkened(0.15)))
	btn.custom_minimum_size = Vector2(0, 32)
	return btn

func _build_gear_rows() -> void:
	for child in gear_rows.get_children():
		child.queue_free()

	# Sort gear: weapon → armor → accessory, then common → rare → epic
	var slot_order = ["weapon", "armor", "accessory"]
	var rarity_order = ["common", "rare", "epic"]
	var sorted_ids = []
	for slot in slot_order:
		for rarity in rarity_order:
			for gear_id in CardManager.gear_data:
				var g = CardManager.get_gear(gear_id)
				if g.get("slot", "") == slot and g.get("rarity", "") == rarity:
					sorted_ids.append(gear_id)

	if sorted_ids.is_empty():
		var empty = Label.new()
		empty.text = "No gear available."
		empty.add_theme_color_override("font_color", CLR_MUTED)
		gear_rows.add_child(empty)
		return

	for gear_id in sorted_ids:
		var g = CardManager.get_gear(gear_id)
		var price = g.get("cost", 50)
		var owned = gear_id in GameState.gear_inventory

		var row = HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		gear_rows.add_child(row)

		# Build stat string
		var stat_parts = []
		if g.get("damage", 0) != 0: stat_parts.append("%+ddmg" % g["damage"])
		if g.get("armor", 0)  != 0: stat_parts.append("%+darm" % g["armor"])
		if g.get("hp", 0)     != 0: stat_parts.append("%+dHP"  % g["hp"])
		if g.get("speed", 0)  != 0: stat_parts.append("%+dspd" % g["speed"])
		var stats_str = " (%s)" % ", ".join(stat_parts) if stat_parts.size() > 0 else ""

		var info = Label.new()
		info.text = "%s %s  [%s]%s  %s — %dg" % [
			_gear_slot_icon(g.get("slot", "")),
			g.get("name", gear_id),
			g.get("rarity", "?"),
			stats_str,
			g.get("effect_desc", ""),
			price
		]
		info.add_theme_font_size_override("font_size", 11)
		info.add_theme_color_override("font_color", _gear_rarity_color(g.get("rarity", "")))
		info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		info.autowrap_mode = TextServer.AUTOWRAP_WORD
		row.add_child(info)

		var buy_btn: Button
		if owned:
			buy_btn = _make_button("OWNED", CLR_PANEL)
			buy_btn.disabled = true
		else:
			buy_btn = _make_button("BUY %dg" % price, CLR_BUY)
			buy_btn.disabled = GameState.gold < price
			buy_btn.pressed.connect(_on_buy_gear.bind(gear_id, price))
		row.add_child(buy_btn)

func _on_buy_gear(gear_id: String, price: int) -> void:
	if GameState.spend_gold(price):
		GameState.add_gear(gear_id)
		var g = CardManager.get_gear(gear_id)
		msg_label.text = "Purchased %s!" % g.get("name", gear_id)
		_refresh_gold()
		_build_gear_rows()
	else:
		msg_label.text = "Not enough gold."

func _gear_slot_icon(slot: String) -> String:
	match slot:
		"weapon":    return "⚔"
		"armor":     return "🛡"
		"accessory": return "💍"
		_:           return "?"

func _gear_rarity_color(rarity: String) -> Color:
	match rarity:
		"epic":   return Color(0.8, 0.5, 1.0)
		"rare":   return Color(0.4, 0.8, 1.0)
		_:        return Color(0.8, 0.8, 0.8)

func _make_style(color: Color) -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = color
	s.border_color = CLR_BORDER
	s.border_width_left = 1
	s.border_width_top = 1
	s.border_width_right = 1
	s.border_width_bottom = 2
	s.corner_radius_top_left = 4
	s.corner_radius_top_right = 4
	s.corner_radius_bottom_left = 4
	s.corner_radius_bottom_right = 4
	s.content_margin_left = 12
	s.content_margin_right = 12
	s.content_margin_top = 4
	s.content_margin_bottom = 4
	s.shadow_size = 3
	s.shadow_color = Color(0, 0, 0, 0.35)
	return s

func _make_pill(text: String, color: Color) -> PanelContainer:
	var panel = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = Color(color.r, color.g, color.b, 0.18)
	style.border_width_left = 1
	style.border_width_right = 1
	style.border_width_top = 1
	style.border_width_bottom = 1
	style.border_color = Color(color.r, color.g, color.b, 0.55)
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 12
	style.corner_radius_bottom_right = 12
	panel.add_theme_stylebox_override("panel", style)

	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_bottom", 4)
	panel.add_child(margin)

	var label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", CLR_TEXT)
	margin.add_child(label)
	panel.set_meta("label", label)
	return panel

func _seal_style() -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = CLR_SEAL
	s.border_color = CLR_BORDER
	s.border_width_left = 1
	s.border_width_top = 1
	s.border_width_right = 1
	s.border_width_bottom = 1
	s.corner_radius_top_left = 12
	s.corner_radius_top_right = 12
	s.corner_radius_bottom_left = 12
	s.corner_radius_bottom_right = 12
	s.shadow_size = 3
	s.shadow_color = Color(0, 0, 0, 0.35)
	return s
