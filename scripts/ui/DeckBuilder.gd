extends Control
## Deck builder — view and manage your current deck.
## Batch 6: Restyled to match UITheme visual language.

const CARD_DISPLAY_SCENE := preload("res://scenes/CardDisplay.tscn")

var deck_list: VBoxContainer
var collection_list: VBoxContainer
var deck_count_label: Label
var collection_count_label: Label
var msg_label: Label

# Preview panel refs
var preview_card_display: Control
var preview_name_lbl: Label
var preview_faction_lbl: Label
var preview_stats_lbl: Label
var preview_placeholder: Label


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = UITheme.CLR_VOID
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	var root := VBoxContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("separation", 0)
	add_child(root)

	# ── Header ────────────────────────────────────────────────────────────────
	var header := PanelContainer.new()
	header.custom_minimum_size = Vector2(0, 56)
	var header_style := UITheme.panel_raised()
	header_style.border_color = UITheme.CLR_GOLD
	header_style.border_width_bottom = 2
	header_style.border_width_top = 0
	header_style.border_width_left = 0
	header_style.border_width_right = 0
	header.add_theme_stylebox_override("panel", header_style)
	root.add_child(header)

	var header_row := HBoxContainer.new()
	header_row.add_theme_constant_override("separation", 12)
	header.add_child(header_row)

	var back_btn := Button.new()
	UITheme.style_button(back_btn, "← HUB", 44)
	back_btn.pressed.connect(func() -> void: get_tree().change_scene_to_file("res://scenes/MainHub.tscn"))
	header_row.add_child(back_btn)

	var title_lbl := Label.new()
	title_lbl.text = "CODEX ARMORUM  ·  DECK BUILDER"
	title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_HEADER)
	title_lbl.add_theme_color_override("font_color", UITheme.CLR_GOLD)
	header_row.add_child(title_lbl)

	deck_count_label = Label.new()
	deck_count_label.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	deck_count_label.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	deck_count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	header_row.add_child(deck_count_label)

	# ── Body: three-column (deck | collection | card preview) ─────────────────
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 0)
	root.add_child(body)

	body.add_child(_build_deck_column())
	body.add_child(_build_divider_v())
	body.add_child(_build_collection_column())
	body.add_child(_build_divider_v())
	body.add_child(_build_preview_column())

	# ── Footer ────────────────────────────────────────────────────────────────
	var footer := PanelContainer.new()
	footer.custom_minimum_size = Vector2(0, 36)
	var footer_style := UITheme.panel_base()
	footer_style.border_width_top = 1
	footer_style.border_color = UITheme.CLR_BRONZE
	footer.add_theme_stylebox_override("panel", footer_style)
	root.add_child(footer)

	var footer_row := HBoxContainer.new()
	footer_row.add_theme_constant_override("separation", 12)
	footer.add_child(footer_row)

	msg_label = Label.new()
	msg_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	msg_label.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	msg_label.add_theme_color_override("font_color", UITheme.CLR_BRONZE)
	footer_row.add_child(msg_label)

	var hint_lbl := Label.new()
	hint_lbl.text = "MIN 10 · MAX 30 · UP TO 4 COPIES PER CARD"
	hint_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
	hint_lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	footer_row.add_child(hint_lbl)

	_refresh()


func _build_deck_column() -> Control:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", UITheme.panel_base())
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 0)
	panel.add_child(col)

	var hdr := _section_header("YOUR DECK", "⚔")
	col.add_child(hdr)

	col.add_child(_divider())

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	col.add_child(scroll)

	deck_list = VBoxContainer.new()
	deck_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	deck_list.add_theme_constant_override("separation", 4)
	scroll.add_child(deck_list)

	return panel


func _build_collection_column() -> Control:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", UITheme.panel_base())
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 0)
	panel.add_child(col)

	var hdr := _section_header("COLLECTION", "📜")
	col.add_child(hdr)

	col.add_child(_divider())

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	col.add_child(scroll)

	collection_list = VBoxContainer.new()
	collection_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	collection_list.add_theme_constant_override("separation", 4)
	scroll.add_child(collection_list)

	return panel


func _build_preview_column() -> Control:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(200, 0)
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var preview_style := UITheme.panel_base()
	preview_style.border_color = UITheme.CLR_STONE_LITE
	panel.add_theme_stylebox_override("panel", preview_style)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 8)
	panel.add_child(col)

	var hdr := _section_header("CARD DETAIL", "✦")
	col.add_child(hdr)
	col.add_child(_divider())

	# Card visual
	preview_card_display = CARD_DISPLAY_SCENE.instantiate()
	preview_card_display.set_card_size(Vector2(160, 240))
	preview_card_display.custom_minimum_size = Vector2(160, 240)
	preview_card_display.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	preview_card_display.visible = false
	col.add_child(preview_card_display)

	# Placeholder
	preview_placeholder = Label.new()
	preview_placeholder.text = "Select a card\nto see details"
	preview_placeholder.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	preview_placeholder.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	preview_placeholder.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	preview_placeholder.size_flags_vertical = Control.SIZE_EXPAND_FILL
	preview_placeholder.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	col.add_child(preview_placeholder)

	col.add_child(_divider())

	# Faction + stats text
	preview_faction_lbl = Label.new()
	preview_faction_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
	preview_faction_lbl.add_theme_color_override("font_color", UITheme.CLR_BRONZE)
	preview_faction_lbl.visible = false
	col.add_child(preview_faction_lbl)

	preview_stats_lbl = Label.new()
	preview_stats_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
	preview_stats_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
	preview_stats_lbl.add_theme_color_override("font_color", UITheme.CLR_PARCHMENT)
	preview_stats_lbl.visible = false
	col.add_child(preview_stats_lbl)

	return panel


func _section_header(title: String, icon: String) -> Control:
	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", UITheme.PAD_MD)
	pad.add_theme_constant_override("margin_right", UITheme.PAD_MD)
	pad.add_theme_constant_override("margin_top", 6)
	pad.add_theme_constant_override("margin_bottom", 6)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	pad.add_child(row)

	var icon_lbl := Label.new()
	icon_lbl.text = icon
	icon_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	icon_lbl.add_theme_color_override("font_color", UITheme.CLR_BRONZE)
	row.add_child(icon_lbl)

	var lbl := Label.new()
	lbl.text = title
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	lbl.add_theme_color_override("font_color", UITheme.CLR_GOLD)
	row.add_child(lbl)

	return pad


func _divider() -> ColorRect:
	var d := ColorRect.new()
	d.custom_minimum_size = Vector2(0, 1)
	d.color = UITheme.CLR_BRONZE
	d.color.a = 0.5
	d.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return d


func _build_divider_v() -> ColorRect:
	var d := ColorRect.new()
	d.custom_minimum_size = Vector2(1, 0)
	d.size_flags_vertical = Control.SIZE_EXPAND_FILL
	d.color = UITheme.CLR_BRONZE
	d.color.a = 0.4
	d.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return d


func _refresh() -> void:
	var deck_size := GameState.current_deck.size()
	deck_count_label.text = "Deck: %d / 30" % deck_size
	_build_deck_list()
	_build_collection_list()


func _build_deck_list() -> void:
	for child in deck_list.get_children():
		child.queue_free()

	var counts: Dictionary = {}
	for card_id in GameState.current_deck:
		counts[card_id] = counts.get(card_id, 0) + 1

	var shown: Dictionary = {}
	for card_id in GameState.current_deck:
		if card_id in shown:
			continue
		shown[card_id] = true
		var card := CardManager.get_card(card_id)
		if card.is_empty():
			continue
		deck_list.add_child(_make_deck_row(card_id, card, counts[card_id]))


func _build_collection_list() -> void:
	for child in collection_list.get_children():
		child.queue_free()

	var in_deck: Dictionary = {}
	for card_id in GameState.current_deck:
		in_deck[card_id] = in_deck.get(card_id, 0) + 1

	var addable: Array = []
	for card_id in GameState.discovered_cards:
		if in_deck.get(card_id, 0) < 4:
			addable.append(card_id)

	if addable.is_empty():
		var empty := Label.new()
		empty.text = "No cards available.\nBuy more at the Shop."
		empty.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
		empty.add_theme_color_override("font_color", UITheme.CLR_MUTED)
		empty.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		collection_list.add_child(empty)
		return

	for card_id in addable:
		var card := CardManager.get_card(card_id)
		if card.is_empty():
			continue
		collection_list.add_child(_make_collection_row(card_id, card, in_deck.get(card_id, 0)))


func _make_deck_row(card_id: String, card: Dictionary, count: int) -> Control:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", UITheme.panel_raised())

	# Faction color bar
	var faction := str(card.get("faction", "NEUTRAL"))
	var bar := ColorRect.new()
	bar.custom_minimum_size = Vector2(3, 0)
	bar.size_flags_vertical = Control.SIZE_EXPAND_FILL
	bar.color = _faction_color(faction)
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var wrapper := HBoxContainer.new()
	wrapper.add_theme_constant_override("separation", 0)
	panel.add_child(wrapper)
	wrapper.add_child(bar)

	var pad := MarginContainer.new()
	pad.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pad.add_theme_constant_override("margin_left", 8)
	pad.add_theme_constant_override("margin_right", 6)
	pad.add_theme_constant_override("margin_top", 5)
	pad.add_theme_constant_override("margin_bottom", 5)
	wrapper.add_child(pad)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	pad.add_child(row)

	var name_lbl := Label.new()
	name_lbl.text = str(card.get("name", card_id)).to_upper()
	name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	name_lbl.add_theme_color_override("font_color", UITheme.CLR_VELLUM)
	row.add_child(name_lbl)

	var count_lbl := Label.new()
	count_lbl.text = "×%d" % count
	count_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
	count_lbl.add_theme_color_override("font_color", UITheme.CLR_BRONZE)
	row.add_child(count_lbl)

	if GameState.current_deck.size() > 10:
		var remove_btn := Button.new()
		UITheme.style_button(remove_btn, "−", 28)
		remove_btn.custom_minimum_size = Vector2(28, 28)
		remove_btn.pressed.connect(_on_remove.bind(card_id))
		row.add_child(remove_btn)

	# Click to preview
	panel.gui_input.connect(func(ev: InputEvent) -> void:
		if ev is InputEventMouseButton and ev.pressed:
			_show_preview(card_id, card)
	)

	return panel


func _make_collection_row(card_id: String, card: Dictionary, in_deck_count: int) -> Control:
	var panel := PanelContainer.new()
	var s := UITheme.panel_raised()
	s.border_color = UITheme.CLR_STONE_LITE
	panel.add_theme_stylebox_override("panel", s)

	var faction := str(card.get("faction", "NEUTRAL"))
	var bar := ColorRect.new()
	bar.custom_minimum_size = Vector2(3, 0)
	bar.size_flags_vertical = Control.SIZE_EXPAND_FILL
	bar.color = _faction_color(faction)
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var wrapper := HBoxContainer.new()
	wrapper.add_theme_constant_override("separation", 0)
	panel.add_child(wrapper)
	wrapper.add_child(bar)

	var pad := MarginContainer.new()
	pad.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pad.add_theme_constant_override("margin_left", 8)
	pad.add_theme_constant_override("margin_right", 6)
	pad.add_theme_constant_override("margin_top", 5)
	pad.add_theme_constant_override("margin_bottom", 5)
	wrapper.add_child(pad)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	pad.add_child(row)

	var name_lbl := Label.new()
	name_lbl.text = str(card.get("name", card_id)).to_upper()
	name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	name_lbl.add_theme_color_override("font_color", UITheme.CLR_PARCHMENT)
	row.add_child(name_lbl)

	var in_deck_lbl := Label.new()
	in_deck_lbl.text = "in deck: %d" % in_deck_count
	in_deck_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
	in_deck_lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	row.add_child(in_deck_lbl)

	var can_add := GameState.current_deck.size() < 30
	var add_btn := Button.new()
	UITheme.style_button(add_btn, "+", 28)
	add_btn.custom_minimum_size = Vector2(28, 28)
	add_btn.disabled = not can_add
	add_btn.pressed.connect(_on_add.bind(card_id))
	row.add_child(add_btn)

	# Click to preview
	panel.gui_input.connect(func(ev: InputEvent) -> void:
		if ev is InputEventMouseButton and ev.pressed:
			_show_preview(card_id, card)
	)

	return panel


func _show_preview(card_id: String, card: Dictionary) -> void:
	preview_card_display.set_card(card_id)
	preview_card_display.visible = true
	preview_placeholder.visible = false

	var faction := str(card.get("faction", "NEUTRAL"))
	preview_faction_lbl.text = "%s  ·  %s" % [faction, str(card.get("type", "")).to_upper()]
	preview_faction_lbl.add_theme_color_override("font_color", _faction_color(faction))
	preview_faction_lbl.visible = true

	var parts: Array[String] = []
	if int(card.get("damage", 0)) > 0:
		parts.append("⚔ %d dmg" % int(card.get("damage", 0)))
	if int(card.get("armor", 0)) > 0:
		parts.append("🛡 +%d armor" % int(card.get("armor", 0)))
	if int(card.get("heal", 0)) > 0:
		parts.append("💚 heal %d" % int(card.get("heal", 0)))
	var effect := str(card.get("effect", "none"))
	if effect != "none":
		parts.append("✨ %s" % effect.replace("_", " "))
	preview_stats_lbl.text = "\n".join(parts) if not parts.is_empty() else "No special effect"
	preview_stats_lbl.visible = true


func _on_add(card_id: String) -> void:
	if GameState.add_card(card_id):
		msg_label.text = "Added %s to deck." % CardManager.get_card(card_id).get("name", card_id)
		_refresh()
	else:
		msg_label.text = "Deck is full (30 cards max)."


func _on_remove(card_id: String) -> void:
	var idx := GameState.current_deck.find(card_id)
	if idx >= 0:
		GameState.current_deck.remove_at(idx)
		msg_label.text = "Removed one copy of %s." % CardManager.get_card(card_id).get("name", card_id)
		_refresh()


func _faction_color(faction: String) -> Color:
	match faction:
		"AEGIS":   return UITheme.CLR_AEGIS
		"SPECTER": return Color(0.72, 0.45, 1.0)
		"ECLIPSE": return UITheme.CLR_GOLD
		_:         return UITheme.CLR_MUTED
