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
	add_theme_stylebox_override("panel", UITheme.make_panel_style())
	visible = false
	size = Vector2(400, 600)
	custom_minimum_size = Vector2(400, 600)
	_build_ui()

func _build_ui() -> void:
	var root := VBoxContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("separation", UITheme.PAD_SM)
	add_child(root)

	var top := HBoxContainer.new()
	root.add_child(top)

	title_label = Label.new()
	UITheme.style_header(title_label, UITheme.FONT_SUBHEADER, true)
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(title_label)

	close_btn = Button.new()
	close_btn.text = "X"
	close_btn.custom_minimum_size = Vector2(42, 36)
	close_btn.pressed.connect(_on_close_pressed)
	top.add_child(close_btn)

	var art := ColorRect.new()
	art.custom_minimum_size = Vector2(0, 220)
	art.color = Color(0.19, 0.15, 0.11, 1.0)
	root.add_child(art)

	cost_label = Label.new()
	UITheme.style_body(cost_label, UITheme.FONT_BODY)
	cost_label.add_theme_color_override("font_color", UITheme.COLOR_GOLD)
	root.add_child(cost_label)

	type_label = Label.new()
	UITheme.style_body(type_label, UITheme.FONT_SECONDARY)
	root.add_child(type_label)

	effect_label = Label.new()
	UITheme.style_body(effect_label, UITheme.FONT_SECONDARY)
	effect_label.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_WORD
	effect_label.custom_minimum_size = Vector2(0, 130)
	root.add_child(effect_label)

	flavor_label = Label.new()
	UITheme.style_body(flavor_label, UITheme.FONT_SECONDARY, true)
	flavor_label.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_WORD
	flavor_label.custom_minimum_size = Vector2(0, 60)
	root.add_child(flavor_label)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(spacer)

	buy_btn = Button.new()
	UITheme.style_button(buy_btn, "BUY", 52)
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
	if int(card.get("damage", 0)) > 0:
		parts.append("Damage: %d" % int(card.get("damage", 0)))
	if int(card.get("armor", 0)) > 0:
		parts.append("Armor: +%d" % int(card.get("armor", 0)))
	if int(card.get("heal", 0)) > 0:
		parts.append("Heal: %d" % int(card.get("heal", 0)))
	var effect := str(card.get("effect", "none"))
	if effect != "none":
		parts.append("Effect: %s" % effect.replace("_", " "))
	if parts.is_empty():
		return "No additional effects."
	return "\n".join(parts)

func _on_buy_pressed() -> void:
	buy_requested.emit(card_id, card_price)

func _on_close_pressed() -> void:
	slide_out()
