extends Control
## Deck builder — view and manage your current deck

var deck_list: VBoxContainer
var collection_list: VBoxContainer
var deck_label: Label
var msg_label: Label

func _ready() -> void:
	_build_ui()

func _build_ui() -> void:
	var bg = ColorRect.new()
	bg.color = Color(0.07, 0.07, 0.09)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var outer = VBoxContainer.new()
	outer.set_anchors_preset(Control.PRESET_FULL_RECT)
	outer.add_theme_constant_override("separation", 10)
	add_child(outer)

	# Title
	var title = Label.new()
	title.text = "DECK BUILDER"
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color(0.9, 0.75, 0.4))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	outer.add_child(title)

	# Deck size
	deck_label = Label.new()
	deck_label.add_theme_font_size_override("font_size", 13)
	deck_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	deck_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	outer.add_child(deck_label)

	# Message
	msg_label = Label.new()
	msg_label.add_theme_font_size_override("font_size", 11)
	msg_label.add_theme_color_override("font_color", Color(0.5, 0.9, 0.5))
	msg_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	outer.add_child(msg_label)

	outer.add_child(HSeparator.new())

	# Two-column layout
	var columns = HBoxContainer.new()
	columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	columns.add_theme_constant_override("separation", 20)
	outer.add_child(columns)

	# Left: Current deck
	var left = VBoxContainer.new()
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.size_flags_vertical = Control.SIZE_EXPAND_FILL
	left.add_theme_constant_override("separation", 6)
	columns.add_child(left)

	var left_title = Label.new()
	left_title.text = "YOUR DECK"
	left_title.add_theme_font_size_override("font_size", 13)
	left_title.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	left.add_child(left_title)

	var left_scroll = ScrollContainer.new()
	left_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	left.add_child(left_scroll)

	deck_list = VBoxContainer.new()
	deck_list.add_theme_constant_override("separation", 4)
	deck_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_scroll.add_child(deck_list)

	# Right: Collection (discovered cards not in deck)
	var right = VBoxContainer.new()
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right.add_theme_constant_override("separation", 6)
	columns.add_child(right)

	var right_title = Label.new()
	right_title.text = "COLLECTION (add to deck)"
	right_title.add_theme_font_size_override("font_size", 13)
	right_title.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	right.add_child(right_title)

	var right_scroll = ScrollContainer.new()
	right_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right.add_child(right_scroll)

	collection_list = VBoxContainer.new()
	collection_list.add_theme_constant_override("separation", 4)
	collection_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_scroll.add_child(collection_list)

	outer.add_child(HSeparator.new())

	# Back button
	var back_btn = _make_button("← BACK TO HUB", Color(0.25, 0.1, 0.1))
	back_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/MainHub.tscn"))
	outer.add_child(back_btn)

	_refresh()

func _refresh() -> void:
	deck_label.text = "Deck: %d cards (min 10, max 30)" % GameState.current_deck.size()
	_build_deck_list()
	_build_collection_list()

func _build_deck_list() -> void:
	for child in deck_list.get_children():
		child.queue_free()

	# Count duplicates
	var counts: Dictionary = {}
	for id in GameState.current_deck:
		counts[id] = counts.get(id, 0) + 1

	var shown = {}
	for card_id in GameState.current_deck:
		if card_id in shown:
			continue
		shown[card_id] = true
		var card = CardManager.get_card(card_id)
		if card.is_empty():
			continue

		var row = HBoxContainer.new()
		row.add_theme_constant_override("separation", 6)
		deck_list.add_child(row)

		var count = counts[card_id]
		var lbl = Label.new()
		lbl.text = "%dx %s (%s)" % [count, card.get("name", card_id), card.get("faction", "")]
		lbl.add_theme_font_size_override("font_size", 11)
		lbl.add_theme_color_override("font_color", _faction_color(card.get("faction", "")))
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(lbl)

		if GameState.current_deck.size() > 10:
			var remove_btn = _make_button("−", Color(0.35, 0.1, 0.1))
			remove_btn.custom_minimum_size = Vector2(30, 28)
			remove_btn.pressed.connect(_on_remove.bind(card_id))
			row.add_child(remove_btn)

func _build_collection_list() -> void:
	for child in collection_list.get_children():
		child.queue_free()

	var in_deck_counts: Dictionary = {}
	for id in GameState.current_deck:
		in_deck_counts[id] = in_deck_counts.get(id, 0) + 1

	var collection = GameState.discovered_cards.duplicate()
	# Filter out cards that are maxed (4 copies) or deck is full
	var addable = []
	for card_id in collection:
		var current_count = in_deck_counts.get(card_id, 0)
		if current_count < 4:
			addable.append(card_id)

	if addable.is_empty():
		var empty = Label.new()
		empty.text = "No cards to add.\nBuy cards at the Shop."
		empty.add_theme_font_size_override("font_size", 11)
		empty.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
		collection_list.add_child(empty)
		return

	for card_id in addable:
		var card = CardManager.get_card(card_id)
		if card.is_empty():
			continue

		var row = HBoxContainer.new()
		row.add_theme_constant_override("separation", 6)
		collection_list.add_child(row)

		var count = in_deck_counts.get(card_id, 0)
		var lbl = Label.new()
		lbl.text = "%s (%s) — in deck: %d" % [card.get("name", card_id), card.get("faction", ""), count]
		lbl.add_theme_font_size_override("font_size", 11)
		lbl.add_theme_color_override("font_color", _faction_color(card.get("faction", "")))
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(lbl)

		var can_add = GameState.current_deck.size() < 30
		var add_btn = _make_button("+", Color(0.1, 0.3, 0.1))
		add_btn.custom_minimum_size = Vector2(30, 28)
		add_btn.disabled = not can_add
		add_btn.pressed.connect(_on_add.bind(card_id))
		row.add_child(add_btn)

func _on_add(card_id: String) -> void:
	if GameState.add_card(card_id):
		msg_label.text = "Added %s to deck." % CardManager.get_card(card_id).get("name", card_id)
		_refresh()
	else:
		msg_label.text = "Deck is full (30 cards max)."

func _on_remove(card_id: String) -> void:
	var idx = GameState.current_deck.find(card_id)
	if idx >= 0:
		GameState.current_deck.remove_at(idx)
		msg_label.text = "Removed one copy of %s." % CardManager.get_card(card_id).get("name", card_id)
		_refresh()

func _faction_color(faction: String) -> Color:
	match faction:
		"AEGIS":   return Color(0.5, 0.7, 1.0)
		"SPECTER": return Color(0.75, 0.5, 1.0)
		"ECLIPSE": return Color(1.0, 0.85, 0.4)
		_:         return Color(0.8, 0.8, 0.8)

func _make_button(text: String, color: Color) -> Button:
	var btn = Button.new()
	btn.text = text
	btn.add_theme_font_size_override("font_size", 12)
	btn.add_theme_color_override("font_color", Color.WHITE)
	btn.add_theme_stylebox_override("normal", _make_style(color))
	btn.add_theme_stylebox_override("hover", _make_style(color.lightened(0.15)))
	btn.add_theme_stylebox_override("pressed", _make_style(color.darkened(0.15)))
	btn.custom_minimum_size = Vector2(0, 30)
	return btn

func _make_style(color: Color) -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = color
	s.corner_radius_top_left = 4
	s.corner_radius_top_right = 4
	s.corner_radius_bottom_left = 4
	s.corner_radius_bottom_right = 4
	s.content_margin_left = 10
	s.content_margin_right = 10
	s.content_margin_top = 4
	s.content_margin_bottom = 4
	return s
