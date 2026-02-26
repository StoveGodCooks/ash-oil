extends PanelContainer

signal buy_requested(gear_id: String, price: int)
signal closed

var gear_id: String = ""
var gear_data: Dictionary = {}
var gear_price: int = 0

var title_label: Label
var rarity_badge: Label
var cost_label: Label
var stat_label: Label
var owned_label: Label
var buy_btn: Button

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
	size = Vector2(280, 380)
	custom_minimum_size = Vector2(280, 380)
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

	var close_btn := Button.new()
	close_btn.text = "×"
	close_btn.custom_minimum_size = Vector2(32, 24)
	close_btn.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_HEADER)
	close_btn.pressed.connect(func() -> void: slide_out())
	top.add_child(close_btn)

	# Divider after header
	var divider1 = Control.new()
	divider1.custom_minimum_size = Vector2(0, 1)
	var divider1_rect = ColorRect.new()
	divider1_rect.color = UITheme.CLR_BRONZE
	divider1.add_child(divider1_rect)
	divider1_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(divider1)

	# Icon area
	var icon := ColorRect.new()
	icon.custom_minimum_size = Vector2(0, 100)
	icon.color = UITheme.CLR_STONE_MID
	root.add_child(icon)

	# Rarity and cost
	rarity_badge = Label.new()
	UITheme.style_body(rarity_badge, UITheme.FONT_SECONDARY)
	root.add_child(rarity_badge)

	cost_label = Label.new()
	UITheme.style_body(cost_label, UITheme.FONT_SECONDARY)
	cost_label.add_theme_color_override("font_color", UITheme.CLR_GOLD)
	root.add_child(cost_label)

	# Divider before stats
	var divider2 = Control.new()
	divider2.custom_minimum_size = Vector2(0, 1)
	var divider2_rect = ColorRect.new()
	divider2_rect.color = UITheme.CLR_BRONZE
	divider2.add_child(divider2_rect)
	divider2_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(divider2)

	# Stats
	stat_label = Label.new()
	UITheme.style_body(stat_label, UITheme.FONT_BODY)
	stat_label.add_theme_color_override("font_color", UITheme.CLR_PARCHMENT)
	stat_label.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_WORD
	stat_label.custom_minimum_size = Vector2(0, 80)
	root.add_child(stat_label)

	# Owned label
	owned_label = Label.new()
	UITheme.style_body(owned_label, UITheme.FONT_SECONDARY, true)
	owned_label.add_theme_color_override("font_color", UITheme.CLR_METER_ALLIES)
	root.add_child(owned_label)

	# Spacer
	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(spacer)

	# Buy button
	buy_btn = Button.new()
	UITheme.style_button(buy_btn, "BUY", 48)
	buy_btn.pressed.connect(_on_buy_pressed)
	root.add_child(buy_btn)

func show_gear(new_gear_id: String, new_gear_data: Dictionary, price: int, affordable: bool, owned: bool) -> void:
	gear_id = new_gear_id
	gear_data = new_gear_data
	gear_price = price

	title_label.text = str(gear_data.get("name", new_gear_id))
	var rarity := str(gear_data.get("rarity", "common")).to_lower()
	rarity_badge.text = "Rarity: %s" % rarity.to_upper()
	rarity_badge.add_theme_color_override("font_color", UITheme.rarity_color(rarity))
	cost_label.text = "Cost: %d gold" % price

	stat_label.text = "Slot: %s\nDamage Mod: %+d\nArmor: %+d\nSpecial: %s" % [
		str(gear_data.get("slot", "gear")).to_upper(),
		int(gear_data.get("damage_mod", 0)),
		int(gear_data.get("armor", 0)),
		str(gear_data.get("effect", "none")).replace("_", " ")
	]

	if owned:
		owned_label.text = "Already owned"
		owned_label.add_theme_color_override("font_color", Color(0.72, 0.86, 0.66))
		buy_btn.text = "OWNED"
		buy_btn.disabled = true
	elif affordable:
		owned_label.text = ""
		buy_btn.text = "BUY FOR %d GOLD" % price
		buy_btn.disabled = false
	else:
		owned_label.text = ""
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

func _on_buy_pressed() -> void:
	buy_requested.emit(gear_id, gear_price)
