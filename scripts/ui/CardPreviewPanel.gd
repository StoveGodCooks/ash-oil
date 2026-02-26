extends PanelContainer

signal buy_requested(card_id: String, price: int)
signal closed

var card_id: String = ""
var card_data: Dictionary = {}
var card_price: int = 0

var title_label: Label
var cost_label: Label
var type_label: Label
var effect_label: Label
var flavor_label: Label
var buy_btn: Button
var close_btn: Button

func _ready() -> void:
	# Panel with CLR_GOLD 2px left border per spec
	var panel_style := UITheme.panel_base()
	panel_style.border_color = UITheme.CLR_GOLD
	panel_style.border_width_left = 2
	panel_style.border_width_top = 0
	panel_style.border_width_right = 0
	panel_style.border_width_bottom = 0
	add_theme_stylebox_override("panel", panel_style)
	visible = false
	size = Vector2(280, 400)
	custom_minimum_size = Vector2(280, 400)
	_build_ui()

func _build_ui() -> void:
	var root := VBoxContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("separation", UITheme.PAD_MD)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", UITheme.PAD_MD)
	margin.add_theme_constant_override("margin_right", UITheme.PAD_MD)
	margin.add_theme_constant_override("margin_top", UITheme.PAD_MD)
	margin.add_theme_constant_override("margin_bottom", UITheme.PAD_MD)
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_child(root)
	add_child(margin)

	# Header with close button
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", UITheme.PAD_SM)
	root.add_child(top)

	title_label = Label.new()
	UITheme.style_header(title_label, UITheme.FONT_SUBHEADER, true)
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(title_label)

	close_btn = Button.new()
	close_btn.text = "×"
	close_btn.custom_minimum_size = Vector2(32, 24)
	close_btn.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_HEADER)
	close_btn.pressed.connect(_on_close_pressed)
	top.add_child(close_btn)

	# Divider after header
	var divider1 = Control.new()
	divider1.custom_minimum_size = Vector2(0, 1)
	var divider1_rect = ColorRect.new()
	divider1_rect.color = UITheme.CLR_BRONZE
	divider1.add_child(divider1_rect)
	divider1_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(divider1)

	# Art area with faction tint
	var art := ColorRect.new()
	art.custom_minimum_size = Vector2(0, 120)
	art.color = UITheme.CLR_STONE_MID
	root.add_child(art)

	# Cost and type row
	cost_label = Label.new()
	UITheme.style_body(cost_label, UITheme.FONT_SECONDARY)
	cost_label.add_theme_color_override("font_color", UITheme.CLR_GOLD)
	root.add_child(cost_label)

	type_label = Label.new()
	UITheme.style_body(type_label, UITheme.FONT_SECONDARY, true)
	root.add_child(type_label)

	# Divider before stats
	var divider2 = Control.new()
	divider2.custom_minimum_size = Vector2(0, 1)
	var divider2_rect = ColorRect.new()
	divider2_rect.color = UITheme.CLR_BRONZE
	divider2.add_child(divider2_rect)
	divider2_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(divider2)

	# Effect text
	effect_label = Label.new()
	UITheme.style_body(effect_label, UITheme.FONT_BODY)
	effect_label.add_theme_color_override("font_color", UITheme.CLR_PARCHMENT)
	effect_label.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_WORD
	effect_label.custom_minimum_size = Vector2(0, 80)
	root.add_child(effect_label)

	# Flavor text
	flavor_label = Label.new()
	UITheme.style_body(flavor_label, UITheme.FONT_SECONDARY, true)
	flavor_label.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	flavor_label.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_WORD
	flavor_label.custom_minimum_size = Vector2(0, 40)
	root.add_child(flavor_label)

	# Spacer to push button down
	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(spacer)

	# Buy button
	buy_btn = Button.new()
	UITheme.style_button(buy_btn, "BUY", 48)
	buy_btn.pressed.connect(_on_buy_pressed)
	root.add_child(buy_btn)

func show_card(new_card_id: String, new_card_data: Dictionary, price: int, affordable: bool) -> void:
	card_id = new_card_id
	card_data = new_card_data
	card_price = price

	var c_name := str(card_data.get("name", card_id))
	title_label.text = c_name
	cost_label.text = "Cost: %d gold  |  Card cost: %d" % [price, int(card_data.get("cost", 0))]
	type_label.text = "Type: %s  |  Faction: %s" % [str(card_data.get("type", "")).to_upper(), str(card_data.get("faction", "NEUTRAL"))]
	effect_label.text = _build_effect_text(card_data)
	flavor_label.text = "\"Freedom has a price. Blood pays interest.\""

	if affordable:
		buy_btn.text = "BUY FOR %d GOLD" % price
		buy_btn.disabled = false
	else:
		buy_btn.text = "INSUFFICIENT GOLD"
		buy_btn.disabled = true

func slide_in() -> void:
	visible = true
	var parent_ctrl := get_parent() as Control
	if parent_ctrl == null:
		return
	var start_x: float = parent_ctrl.size.x + 8.0
	position.x = start_x
	var target_x: float = parent_ctrl.size.x - size.x - float(UITheme.PAD_LG)
	var tween := create_tween()
	tween.tween_property(self, "position:x", target_x, 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func slide_out() -> void:
	var parent_ctrl := get_parent() as Control
	if parent_ctrl == null:
		visible = false
		closed.emit()
		return
	var target_x: float = parent_ctrl.size.x + 8.0
	var tween := create_tween()
	tween.tween_property(self, "position:x", target_x, 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await tween.finished
	visible = false
	closed.emit()

func _build_effect_text(card: Dictionary) -> String:
	var parts: Array[String] = []
	# Stats with color codes (displayed as plain text, colors applied via style)
	if int(card.get("damage", 0)) > 0:
		parts.append("⚔ Damage: %d" % int(card.get("damage", 0)))
	if int(card.get("armor", 0)) > 0:
		parts.append("🛡 Armor: +%d" % int(card.get("armor", 0)))
	if int(card.get("heal", 0)) > 0:
		parts.append("💚 Heal: %d" % int(card.get("heal", 0)))
	var effect := str(card.get("effect", "none"))
	if effect != "none":
		parts.append("✨ %s" % effect.replace("_", " "))
	if parts.is_empty():
		return "No additional effects."
	return "\n".join(parts)

func _on_buy_pressed() -> void:
	buy_requested.emit(card_id, card_price)

func _on_close_pressed() -> void:
	slide_out()
