extends Control
## Cleaner Forum Market: readable cards, clear gear row, right-side preview.

const CARD_PREVIEW_SCENE := preload("res://scenes/ui/CardPreviewPanel.tscn")
const GEAR_PREVIEW_SCENE := preload("res://scenes/ui/GearPreviewPanel.tscn")
const TEX_CREST := "res://assets/ui/roman/crest.png"
const TEX_BANNER := "res://assets/ui/roman/banner.png"
const TEX_SEAL := "res://assets/ui/roman/seal.png"

var shop_pool: Array = []
var gear_pool: Array[Dictionary] = []

var gold_label: Label
var msg_label: Label
var card_grid: GridContainer
var gear_grid: GridContainer
var card_preview: PanelContainer
var gear_preview: PanelContainer

func _ready() -> void:
	_generate_shop_pool()
	_build_gear_pool()
	_build_ui()
	_refresh_top()
	_rebuild_lists()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_close_previews()

func _generate_shop_pool() -> void:
	var ids = CardManager.cards_data.keys()
	ids.shuffle()
	shop_pool.clear()
	for id in ids:
		var card := CardManager.get_card(id)
		if bool(card.get("is_signature", false)):
			continue
		if id not in GameState.current_deck:
			shop_pool.append(id)
		if shop_pool.size() >= 9:
			break

func _build_gear_pool() -> void:
	gear_pool.clear()
	var all_gear: Array[Dictionary] = []
	for gear_id in CardManager.gear_data.keys():
		if GameState.has_gear(gear_id):
			continue
		var gear: Dictionary = CardManager.get_gear(gear_id)
		if gear.is_empty():
			continue
		all_gear.append(gear.duplicate())
	if all_gear.is_empty():
		return
	all_gear.shuffle()
	for gear in all_gear:
		gear_pool.append(gear)
		if gear_pool.size() >= 6:
			break

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = UITheme.background_color()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var root := MarginContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("margin_left", UITheme.PAD_LG)
	root.add_theme_constant_override("margin_top", UITheme.PAD_LG)
	root.add_theme_constant_override("margin_right", UITheme.PAD_LG)
	root.add_theme_constant_override("margin_bottom", UITheme.PAD_LG)
	add_child(root)

	var page := VBoxContainer.new()
	page.add_theme_constant_override("separation", UITheme.PAD_MD)
	root.add_child(page)

	page.add_child(_build_header())
	page.add_child(_build_cards_panel())
	page.add_child(_build_gear_panel())
	page.add_child(_build_footer())

	card_preview = CARD_PREVIEW_SCENE.instantiate() as PanelContainer
	add_child(card_preview)
	card_preview.buy_requested.connect(_on_buy_card)

	gear_preview = GEAR_PREVIEW_SCENE.instantiate() as PanelContainer
	add_child(gear_preview)
	gear_preview.buy_requested.connect(_on_buy_gear)

func _build_header() -> Control:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", UITheme.make_panel_style())

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", UITheme.PAD_MD)
	panel.add_child(row)

	var left := HBoxContainer.new()
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.add_theme_constant_override("separation", UITheme.PAD_SM)
	row.add_child(left)

	var crest := _make_texture(TEX_CREST, Vector2(44, 44))
	left.add_child(crest)

	var title_col := VBoxContainer.new()
	title_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_col.add_theme_constant_override("separation", 2)
	left.add_child(title_col)

	var banner := _make_texture(TEX_BANNER, Vector2(270, 26))
	title_col.add_child(banner)

	var title := Label.new()
	title.text = "FORUM MARKET — MERCHANTS OF THE ARENA"
	UITheme.style_header(title, UITheme.FONT_SUBHEADER, true)
	title_col.add_child(title)

	gold_label = Label.new()
	gold_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	UITheme.style_body(gold_label, UITheme.FONT_BODY)
	gold_label.add_theme_color_override("font_color", UITheme.COLOR_GOLD)
	var right := VBoxContainer.new()
	right.alignment = BoxContainer.ALIGNMENT_END
	right.add_child(gold_label)

	var seal := _make_texture(TEX_SEAL, Vector2(34, 34))
	right.add_child(seal)
	row.add_child(right)
	return panel

func _build_cards_panel() -> Control:
	var panel := PanelContainer.new()
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.size_flags_stretch_ratio = 55.0
	panel.add_theme_stylebox_override("panel", UITheme.make_panel_style(true))

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", UITheme.PAD_SM)
	panel.add_child(box)

	var title := Label.new()
	title.text = "MERCHANT CARDS"
	UITheme.style_header(title, UITheme.FONT_SUBHEADER, true)
	box.add_child(title)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(scroll)

	card_grid = GridContainer.new()
	card_grid.columns = 3
	card_grid.add_theme_constant_override("h_separation", UITheme.PAD_MD)
	card_grid.add_theme_constant_override("v_separation", UITheme.PAD_MD)
	scroll.add_child(card_grid)
	return panel

func _build_gear_panel() -> Control:
	var panel := PanelContainer.new()
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.size_flags_stretch_ratio = 30.0
	panel.add_theme_stylebox_override("panel", UITheme.make_panel_style())

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", UITheme.PAD_SM)
	panel.add_child(box)

	var title := Label.new()
	title.text = "GEAR FOR SALE"
	UITheme.style_header(title, UITheme.FONT_SUBHEADER, true)
	box.add_child(title)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(scroll)

	gear_grid = GridContainer.new()
	gear_grid.columns = 3
	gear_grid.add_theme_constant_override("h_separation", UITheme.PAD_MD)
	gear_grid.add_theme_constant_override("v_separation", UITheme.PAD_MD)
	scroll.add_child(gear_grid)
	return panel

func _build_footer() -> Control:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", UITheme.make_panel_style(true))

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", UITheme.PAD_MD)
	panel.add_child(row)

	var back_btn := Button.new()
	UITheme.style_button(back_btn, "← BACK TO HUB", 60)
	back_btn.custom_minimum_size.x = 260
	back_btn.pressed.connect(func() -> void: get_tree().change_scene_to_file("res://scenes/MainHub.tscn"))
	row.add_child(back_btn)

	msg_label = Label.new()
	msg_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	UITheme.style_body(msg_label, UITheme.FONT_BODY)
	row.add_child(msg_label)
	return panel

func _refresh_top() -> void:
	gold_label.text = "Gold: %d  |  Deck: %d/30  |  Owned Gear: %d" % [
		GameState.gold, GameState.current_deck.size(), GameState.owned_gear.size()
	]

func _rebuild_lists() -> void:
	for child in card_grid.get_children():
		child.queue_free()
	for child in gear_grid.get_children():
		child.queue_free()

	for card_id in shop_pool:
		var card := CardManager.get_card(card_id)
		if card.is_empty():
			continue
		card_grid.add_child(_make_card_btn(card_id, card))

	for gear in gear_pool:
		gear_grid.add_child(_make_gear_btn(gear))

func _make_card_btn(card_id: String, card: Dictionary) -> Button:
	var price := _card_price(card)
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(310, 150)
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_WORD
	btn.text = "%s\nCost %d | %dg\n%s" % [
		str(card.get("name", card_id)),
		int(card.get("cost", 0)),
		price,
		_card_summary(card),
	]
	btn.tooltip_text = "Click for full preview"
	btn.add_theme_font_size_override("font_size", UITheme.FONT_BODY)
	btn.add_theme_stylebox_override("normal", UITheme.make_button_style(Color(0.20, 0.15, 0.11)))
	btn.add_theme_stylebox_override("hover", UITheme.make_button_style(Color(0.34, 0.23, 0.14)))
	btn.mouse_entered.connect(_hover_in.bind(btn))
	btn.mouse_exited.connect(_hover_out.bind(btn))
	btn.pressed.connect(func() -> void:
		_close_previews()
		card_preview.call("show_card", card_id, card, price, GameState.gold >= price and GameState.current_deck.size() < 30)
		card_preview.call("slide_in")
	)
	return btn

func _make_gear_btn(gear: Dictionary) -> Button:
	var gear_id := str(gear.get("id", ""))
	var price := int(gear.get("price", 0))
	var owned := GameState.has_gear(gear_id)
	var badge := "OWNED" if owned else str(gear.get("rarity", "common")).to_upper()

	var btn := Button.new()
	btn.custom_minimum_size = Vector2(310, 124)
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_WORD
	btn.text = "%s\n%s  |  %+d dmg  %+d armor\n%dg" % [
		str(gear.get("name", gear_id)),
		badge,
		int(gear.get("damage", 0)),
		int(gear.get("armor", 0)),
		price,
	]
	btn.tooltip_text = "Click for full preview"
	btn.add_theme_font_size_override("font_size", UITheme.FONT_BODY)
	btn.add_theme_stylebox_override("normal", UITheme.make_button_style(Color(0.17, 0.14, 0.12)))
	btn.add_theme_stylebox_override("hover", UITheme.make_button_style(Color(0.30, 0.21, 0.14)))
	btn.add_theme_color_override("font_color", UITheme.rarity_color(str(gear.get("rarity", "common"))))
	btn.mouse_entered.connect(_hover_in.bind(btn))
	btn.mouse_exited.connect(_hover_out.bind(btn))
	btn.pressed.connect(func() -> void:
		_close_previews()
		gear_preview.call("show_gear", gear_id, gear, price, GameState.gold >= price, owned)
		gear_preview.call("slide_in")
	)
	return btn

func _on_buy_card(card_id: String, price: int) -> void:
	if not (card_id in shop_pool):
		return
	if GameState.current_deck.size() >= 30:
		msg_label.text = "Deck is full."
		return
	if not GameState.spend_gold(price):
		msg_label.text = "Insufficient gold."
		return
	GameState.add_card(card_id)
	shop_pool.erase(card_id)
	_refresh_top()
	_rebuild_lists()
	msg_label.text = "Purchased %s." % CardManager.get_card(card_id).get("name", card_id)
	_close_previews()

func _on_buy_gear(gear_id: String, price: int) -> void:
	if GameState.has_gear(gear_id):
		msg_label.text = "Already owned."
		return
	if not GameState.spend_gold(price):
		msg_label.text = "Insufficient gold."
		return
	GameState.add_gear(gear_id)
	for gear in gear_pool:
		if str(gear.get("id", "")) == gear_id:
			GameState.equip_gear(str(gear.get("slot", "")), gear_id)
			break
	_refresh_top()
	_rebuild_lists()
	var gear_name := gear_id
	for gear in gear_pool:
		if str(gear.get("id", "")) == gear_id:
			gear_name = str(gear.get("name", gear_id))
			break
	msg_label.text = "Purchased and equipped %s." % gear_name
	_close_previews()

func _close_previews() -> void:
	if is_instance_valid(card_preview) and bool(card_preview.visible):
		card_preview.call("slide_out")
	if is_instance_valid(gear_preview) and bool(gear_preview.visible):
		gear_preview.call("slide_out")

func _hover_in(btn: Control) -> void:
	btn.z_index = 20
	var t := create_tween()
	t.tween_property(btn, "scale", Vector2(1.05, 1.05), 0.15).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _hover_out(btn: Control) -> void:
	btn.z_index = 0
	var t := create_tween()
	t.tween_property(btn, "scale", Vector2.ONE, 0.15).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _card_price(card: Dictionary) -> int:
	var stamina_cost: int = int(card.get("cost", 1))
	var power_index: float = float(card.get("power_index", 1.0))
	var base_price: int = 30 + (stamina_cost * 35) + int(power_index * 60.0)
	if stamina_cost >= 3:
		base_price += 35
	if bool(card.get("is_signature", false)):
		base_price += 40
	return clampi(base_price, 30, 380)

func _card_summary(card: Dictionary) -> String:
	var parts: Array[String] = []
	if int(card.get("damage", 0)) > 0:
		parts.append("%d dmg" % int(card.get("damage", 0)))
	if int(card.get("armor", 0)) > 0:
		parts.append("+%d armor" % int(card.get("armor", 0)))
	if int(card.get("heal", 0)) > 0:
		parts.append("heal %d" % int(card.get("heal", 0)))
	var effect := str(card.get("effect", "none"))
	if effect != "none":
		parts.append(effect.replace("_", " "))
	return "No special effect" if parts.is_empty() else ", ".join(parts)

func _make_texture(path: String, tex_size: Vector2) -> TextureRect:
	var tex := TextureRect.new()
	tex.texture = load(path)
	tex.custom_minimum_size = tex_size
	tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tex.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return tex
