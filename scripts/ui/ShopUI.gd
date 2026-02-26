extends Control
## Cleaner Forum Market: readable cards, clear gear row, right-side preview.

const CARD_PREVIEW_SCENE := preload("res://scenes/ui/CardPreviewPanel.tscn")
const GEAR_PREVIEW_SCENE  := preload("res://scenes/ui/GearPreviewPanel.tscn")
const CARD_DISPLAY_SCENE  := preload("res://scenes/CardDisplay.tscn")
const TEX_CREST  := "res://assets/ui/roman/crest.png"
const TEX_BANNER := "res://assets/ui/roman/banner.png"
const TEX_SEAL   := "res://assets/ui/roman/seal.png"

var shop_pool: Array = []
var gear_pool: Array[Dictionary] = []

var gold_label: Label
var msg_label: Label
var card_grid: GridContainer
var gear_grid: GridContainer
var gear_preview: PanelContainer
var cards_tab_btn: Button
var gear_tab_btn: Button

# Inline card preview panel refs
var preview_card_display: Control
var preview_placeholder_lbl: Label
var preview_card_name_lbl: Label
var preview_card_type_lbl: Label
var preview_card_price_lbl: Label
var preview_card_stats_lbl: Label
var preview_card_buy_btn: Button
var _selected_card_id: String = ""
var _selected_card_price: int = 0

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

func _has_lt_trait(trait_name: String) -> bool:
	for lt_id in GameState.active_lieutenants:
		var d: Dictionary = CardManager.get_lieutenant(str(lt_id))
		if str(d.get("trait", "")) == trait_name:
			return true
	return false

func _build_gear_pool() -> void:
	gear_pool.clear()
	# Corvus "Black Market": epic gear can appear; otherwise only common/rare
	var corvus_active := _has_lt_trait("Black Market")
	var max_gear_items := 8 if corvus_active else 6
	var common_rare: Array[Dictionary] = []
	var epic_legendary: Array[Dictionary] = []
	for gear_id in CardManager.gear_data.keys():
		if GameState.has_gear(gear_id):
			continue
		var gear: Dictionary = CardManager.get_gear(gear_id)
		if gear.is_empty():
			continue
		var rarity := str(gear.get("rarity", "common")).to_lower()
		if rarity in ["epic", "legendary"]:
			epic_legendary.append(gear.duplicate())
		else:
			common_rare.append(gear.duplicate())
	if common_rare.is_empty() and epic_legendary.is_empty():
		return
	common_rare.shuffle()
	epic_legendary.shuffle()
	# Fill pool: always show common/rare; add epic slots if Corvus active
	for gear in common_rare:
		gear_pool.append(gear)
		if gear_pool.size() >= max_gear_items:
			break
	if corvus_active:
		for gear in epic_legendary:
			gear_pool.append(gear)
			if gear_pool.size() >= max_gear_items + 2:
				break

var current_tab: String = "cards"  # "cards" or "gear"

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = UITheme.CLR_VOID
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var root := VBoxContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("separation", 0)
	add_child(root)

	# Header
	root.add_child(_build_header())

	# Tab bar
	root.add_child(_build_tab_bar())

	# Main content: HBox with grid (65%) + preview (35%)
	var content_hbox := HBoxContainer.new()
	content_hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_hbox.add_theme_constant_override("separation", 0)
	root.add_child(content_hbox)

	# Left side: scrollable item grid
	var left_panel := PanelContainer.new()
	left_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_panel.size_flags_stretch_ratio = 0.65
	left_panel.add_theme_stylebox_override("panel", UITheme.panel_base())
	content_hbox.add_child(left_panel)

	var left_box := VBoxContainer.new()
	left_box.add_theme_constant_override("separation", 8)
	left_panel.add_child(left_box)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	left_box.add_child(scroll)

	var grid_wrapper := VBoxContainer.new()
	grid_wrapper.add_theme_constant_override("separation", 12)
	scroll.add_child(grid_wrapper)

	# Build both grids, only one will be visible at a time
	card_grid = GridContainer.new()
	card_grid.columns = 3
	card_grid.add_theme_constant_override("h_separation", 12)
	card_grid.add_theme_constant_override("v_separation", 12)
	card_grid.visible = true
	grid_wrapper.add_child(card_grid)

	gear_grid = GridContainer.new()
	gear_grid.columns = 2
	gear_grid.add_theme_constant_override("h_separation", 12)
	gear_grid.add_theme_constant_override("v_separation", 12)
	gear_grid.visible = false
	grid_wrapper.add_child(gear_grid)

	# Right side: preview panel
	var right_panel := PanelContainer.new()
	right_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_panel.size_flags_stretch_ratio = 0.35
	right_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var preview_style := UITheme.panel_base()
	preview_style.border_color = UITheme.CLR_GOLD
	preview_style.border_width_left = 2
	preview_style.border_width_top = 0
	preview_style.border_width_right = 0
	preview_style.border_width_bottom = 0
	right_panel.add_theme_stylebox_override("panel", preview_style)
	content_hbox.add_child(right_panel)

	gear_preview = GEAR_PREVIEW_SCENE.instantiate()
	gear_preview.visible = false
	add_child(gear_preview)

	_build_preview_panel_ui(right_panel)

	# Footer
	root.add_child(_build_footer())

func _build_tab_bar() -> Control:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(0, 44)
	panel.add_theme_stylebox_override("panel", UITheme.panel_base())

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 0)
	panel.add_child(row)

	# CARDS tab
	cards_tab_btn = Button.new()
	cards_tab_btn.text = "CARDS"
	cards_tab_btn.custom_minimum_size = Vector2(120, 44)
	cards_tab_btn.add_theme_font_size_override("font_size", UITheme.FONT_BODY)
	cards_tab_btn.pressed.connect(func() -> void: _switch_tab("cards"))
	row.add_child(cards_tab_btn)

	# GEAR tab
	gear_tab_btn = Button.new()
	gear_tab_btn.text = "GEAR"
	gear_tab_btn.custom_minimum_size = Vector2(120, 44)
	gear_tab_btn.add_theme_font_size_override("font_size", UITheme.FONT_BODY)
	gear_tab_btn.pressed.connect(func() -> void: _switch_tab("gear"))
	row.add_child(gear_tab_btn)

	# Spacer
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(spacer)

	# Apply initial styling
	_update_tab_styles()

	return panel

func _update_tab_styles() -> void:
	if current_tab == "cards":
		cards_tab_btn.add_theme_color_override("font_color", UITheme.CLR_GOLD)
		cards_tab_btn.add_theme_stylebox_override("normal", UITheme.btn_active())
		gear_tab_btn.add_theme_color_override("font_color", UITheme.CLR_PARCHMENT)
		gear_tab_btn.add_theme_stylebox_override("normal", UITheme.btn_secondary())
	else:
		cards_tab_btn.add_theme_color_override("font_color", UITheme.CLR_PARCHMENT)
		cards_tab_btn.add_theme_stylebox_override("normal", UITheme.btn_secondary())
		gear_tab_btn.add_theme_color_override("font_color", UITheme.CLR_GOLD)
		gear_tab_btn.add_theme_stylebox_override("normal", UITheme.btn_active())

func _switch_tab(tab_name: String) -> void:
	if current_tab == tab_name:
		return
	current_tab = tab_name
	if tab_name == "cards":
		card_grid.visible = true
		gear_grid.visible = false
	else:
		card_grid.visible = false
		gear_grid.visible = true
	_update_tab_styles()
	msg_label.text = ""

func _build_preview_panel_ui(parent: Control) -> void:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	parent.add_child(box)

	# Header label
	var preview_title := Label.new()
	preview_title.text = "CARD DETAIL"
	UITheme.style_header(preview_title, UITheme.FONT_SUBHEADER, true)
	box.add_child(preview_title)

	# ── Placeholder (shown when nothing selected) ──────────────────────────
	preview_placeholder_lbl = Label.new()
	preview_placeholder_lbl.text = "Select a card\nfrom the left."
	preview_placeholder_lbl.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_WORD
	preview_placeholder_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	preview_placeholder_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_CAPTION)
	preview_placeholder_lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	preview_placeholder_lbl.size_flags_vertical = Control.SIZE_EXPAND_FILL
	preview_placeholder_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	box.add_child(preview_placeholder_lbl)

	# ── Live CardDisplay ───────────────────────────────────────────────────
	preview_card_display = CARD_DISPLAY_SCENE.instantiate()
	preview_card_display.set_card_size(Vector2(180, 270))
	preview_card_display.custom_minimum_size = Vector2(180, 270)
	preview_card_display.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	preview_card_display.visible = false
	box.add_child(preview_card_display)

	# ── Name + type row ────────────────────────────────────────────────────
	preview_card_name_lbl = Label.new()
	preview_card_name_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_SUBHEAD)
	preview_card_name_lbl.add_theme_color_override("font_color", UITheme.CLR_GOLD)
	preview_card_name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	preview_card_name_lbl.visible = false
	box.add_child(preview_card_name_lbl)

	preview_card_type_lbl = Label.new()
	preview_card_type_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
	preview_card_type_lbl.add_theme_color_override("font_color", UITheme.CLR_MUTED)
	preview_card_type_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	preview_card_type_lbl.visible = false
	box.add_child(preview_card_type_lbl)

	# ── Stats ──────────────────────────────────────────────────────────────
	var divider1 := ColorRect.new()
	divider1.custom_minimum_size = Vector2(0, 1)
	divider1.color = UITheme.CLR_BRONZE
	divider1.color.a = 0.5
	divider1.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(divider1)

	preview_card_stats_lbl = Label.new()
	preview_card_stats_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
	preview_card_stats_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_FINE)
	preview_card_stats_lbl.add_theme_color_override("font_color", UITheme.CLR_PARCHMENT)
	preview_card_stats_lbl.visible = false
	box.add_child(preview_card_stats_lbl)

	# ── Price + buy ────────────────────────────────────────────────────────
	var divider2 := ColorRect.new()
	divider2.custom_minimum_size = Vector2(0, 1)
	divider2.color = UITheme.CLR_BRONZE
	divider2.color.a = 0.5
	divider2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(divider2)

	preview_card_price_lbl = Label.new()
	preview_card_price_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	preview_card_price_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SIZE_BODY)
	preview_card_price_lbl.add_theme_color_override("font_color", UITheme.CLR_GOLD)
	preview_card_price_lbl.visible = false
	box.add_child(preview_card_price_lbl)

	preview_card_buy_btn = Button.new()
	UITheme.style_button(preview_card_buy_btn, "BUY CARD", 44)
	preview_card_buy_btn.pressed.connect(func() -> void:
		_on_buy_card(_selected_card_id, _selected_card_price)
	)
	preview_card_buy_btn.visible = false
	box.add_child(preview_card_buy_btn)

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

func _make_card_btn(card_id: String, card: Dictionary) -> Control:
	var price := _card_price(card)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(310, 150)
	panel.add_theme_stylebox_override("panel", UITheme.panel_raised())
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	panel.gui_input.connect(func(event: InputEvent) -> void:
		if event is InputEventMouseButton and event.pressed:
			_close_previews()
			_show_card_preview(card_id, card, price)
	)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	panel.add_child(box)

	# Card name with cost badge
	var name_row := HBoxContainer.new()
	name_row.add_theme_constant_override("separation", 6)
	box.add_child(name_row)

	var card_name := Label.new()
	card_name.text = str(card.get("name", card_id)).to_upper()
	card_name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	UITheme.style_header(card_name, UITheme.FONT_BODY, true)
	name_row.add_child(card_name)

	var cost_badge := Label.new()
	cost_badge.text = str(int(card.get("cost", 0)))
	cost_badge.add_theme_font_size_override("font_size", UITheme.FONT_SECONDARY)
	cost_badge.add_theme_color_override("font_color", UITheme.CLR_VOID)
	var badge_style := StyleBoxFlat.new()
	badge_style.bg_color = UITheme.CLR_GOLD
	badge_style.corner_radius_top_left = 12
	badge_style.corner_radius_top_right = 12
	badge_style.corner_radius_bottom_left = 12
	badge_style.corner_radius_bottom_right = 12
	badge_style.content_margin_left = 8
	badge_style.content_margin_right = 8
	badge_style.content_margin_top = 4
	badge_style.content_margin_bottom = 4
	cost_badge.add_theme_stylebox_override("normal", badge_style)
	name_row.add_child(cost_badge)

	# Price display
	var price_label := Label.new()
	price_label.text = "%d gold" % price
	price_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	UITheme.style_body(price_label, UITheme.FONT_SECONDARY, false)
	price_label.add_theme_color_override("font_color", UITheme.CLR_GOLD)
	box.add_child(price_label)

	# Summary
	var summary := Label.new()
	summary.text = _card_summary(card)
	summary.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_WORD
	summary.size_flags_vertical = Control.SIZE_EXPAND_FILL
	UITheme.style_body(summary, UITheme.FONT_SECONDARY, true)
	box.add_child(summary)

	panel.mouse_entered.connect(_hover_in.bind(panel))
	panel.mouse_exited.connect(_hover_out.bind(panel))

	return panel

func _make_gear_btn(gear: Dictionary) -> Control:
	var gear_id := str(gear.get("id", ""))
	var price := int(gear.get("price", 0))
	# Titus "Connected": -10% on all shop prices
	if _has_lt_trait("Connected"):
		price = int(float(price) * 0.9)
	var owned := GameState.has_gear(gear_id)
	var rarity := str(gear.get("rarity", "common")).to_lower()
	var badge := "OWNED" if owned else rarity.to_upper()

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(310, 124)
	panel.add_theme_stylebox_override("panel", UITheme.panel_raised())
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	panel.gui_input.connect(func(event: InputEvent) -> void:
		if event is InputEventMouseButton and event.pressed:
			_close_previews()
			gear_preview.call("show_gear", gear_id, gear, price, GameState.gold >= price, owned)
			gear_preview.call("slide_in")
	)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 4)
	panel.add_child(box)

	# Gear name
	var gear_name := Label.new()
	gear_name.text = str(gear.get("name", gear_id)).to_upper()
	UITheme.style_header(gear_name, UITheme.FONT_BODY, true)
	box.add_child(gear_name)

	# Rarity and stats row
	var stats_row := HBoxContainer.new()
	stats_row.add_theme_constant_override("separation", 8)
	box.add_child(stats_row)

	var rarity_label := Label.new()
	rarity_label.text = badge
	rarity_label.add_theme_font_size_override("font_size", UITheme.FONT_SECONDARY)
	rarity_label.add_theme_color_override("font_color", UITheme.rarity_color(rarity))
	stats_row.add_child(rarity_label)

	var dmg_label := Label.new()
	dmg_label.text = "%+d dmg" % int(gear.get("damage", 0))
	dmg_label.add_theme_font_size_override("font_size", UITheme.FONT_SECONDARY)
	UITheme.style_body(dmg_label, UITheme.FONT_SECONDARY, true)
	stats_row.add_child(dmg_label)

	var armor_label := Label.new()
	armor_label.text = "%+d armor" % int(gear.get("armor", 0))
	armor_label.add_theme_font_size_override("font_size", UITheme.FONT_SECONDARY)
	UITheme.style_body(armor_label, UITheme.FONT_SECONDARY, true)
	stats_row.add_child(armor_label)

	# Price
	var price_label := Label.new()
	price_label.text = "%d gold" % price
	price_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	UITheme.style_body(price_label, UITheme.FONT_SECONDARY, false)
	price_label.add_theme_color_override("font_color", UITheme.CLR_GOLD)
	box.add_child(price_label)

	panel.mouse_entered.connect(_hover_in.bind(panel))
	panel.mouse_exited.connect(_hover_out.bind(panel))

	return panel

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
	# Re-apply Titus discount in case signal price is stale
	var final_price := price
	if _has_lt_trait("Connected"):
		final_price = int(float(price) * 0.9)
	if not GameState.spend_gold(final_price):
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

func _show_card_preview(card_id: String, card: Dictionary, price: int) -> void:
	_selected_card_id = card_id
	_selected_card_price = price

	preview_card_display.set_card(card_id)
	preview_card_display.visible = true
	preview_placeholder_lbl.visible = false

	preview_card_name_lbl.text = str(card.get("name", card_id)).to_upper()
	preview_card_name_lbl.visible = true

	var faction := str(card.get("faction", "NEUTRAL"))
	var card_type := str(card.get("type", "")).to_upper()
	preview_card_type_lbl.text = "%s  ·  %s" % [faction, card_type]
	preview_card_type_lbl.visible = true

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
	preview_card_stats_lbl.text = "\n".join(parts) if not parts.is_empty() else "No special effect"
	preview_card_stats_lbl.visible = true

	preview_card_price_lbl.text = "⚖ %d gold" % price
	preview_card_price_lbl.visible = true

	var can_buy := GameState.gold >= price and GameState.current_deck.size() < 30
	preview_card_buy_btn.visible = true
	preview_card_buy_btn.disabled = not can_buy
	if can_buy:
		preview_card_buy_btn.add_theme_color_override("font_color", UITheme.CLR_VOID)
	else:
		preview_card_buy_btn.add_theme_color_override("font_color", UITheme.CLR_MUTED)


func _close_previews() -> void:
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
	# Titus "Connected": -10% on all shop prices
	if _has_lt_trait("Connected"):
		base_price = int(float(base_price) * 0.9)
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
