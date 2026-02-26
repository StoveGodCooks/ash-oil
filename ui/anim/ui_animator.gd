extends RefCounted
class_name UIAnimator

const UI_METRICS := preload("res://ui/style/ui_metrics.gd")

static func hover_in(node: Control, strength: float = 1.0) -> Tween:
	_kill(node, "_tw_hover")
	var tw := node.create_tween()
	tw.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.tween_property(node, "scale", Vector2.ONE * (1.0 + UI_METRICS.SCALE_HOVER * strength), UI_METRICS.DUR_HOVER_IN)
	tw.parallel().tween_property(node, "self_modulate", Color(1.07, 1.07, 1.07, 1.0), UI_METRICS.DUR_HOVER_IN)
	node.set_meta("_tw_hover", tw)
	return tw

static func hover_out(node: Control) -> Tween:
	_kill(node, "_tw_hover")
	var tw := node.create_tween()
	tw.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.tween_property(node, "scale", Vector2.ONE, UI_METRICS.DUR_HOVER_OUT)
	tw.parallel().tween_property(node, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), UI_METRICS.DUR_HOVER_OUT)
	node.set_meta("_tw_hover", tw)
	return tw

static func press(node: Control) -> Tween:
	_kill(node, "_tw_press")
	var tw := node.create_tween()
	tw.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tw.tween_property(node, "scale", Vector2.ONE * (1.0 - UI_METRICS.SCALE_PRESS), UI_METRICS.DUR_PRESS * 0.45)
	tw.tween_property(node, "scale", Vector2.ONE, UI_METRICS.DUR_PRESS * 0.55)
	node.set_meta("_tw_press", tw)
	return tw

static func select(node: Control, active: bool) -> Tween:
	_kill(node, "_tw_select")
	var tw := node.create_tween()
	tw.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	var target_scale := Vector2.ONE * (1.0 + UI_METRICS.SCALE_SELECTED) if active else Vector2.ONE
	var target_modulate := Color(1.10, 1.10, 1.12, 1.0) if active else Color(1.0, 1.0, 1.0, 1.0)
	tw.tween_property(node, "scale", target_scale, UI_METRICS.DUR_SELECT)
	tw.parallel().tween_property(node, "self_modulate", target_modulate, UI_METRICS.DUR_SELECT)
	node.set_meta("_tw_select", tw)
	return tw

static func panel_slide(panel: Control, visible_now: bool, from_offset: Vector2 = Vector2(70, 0), duration: float = -1.0) -> Tween:
	var dur := duration if duration > 0.0 else UI_METRICS.DUR_PANEL
	_kill(panel, "_tw_panel_slide")
	var base_pos: Vector2 = panel.get_meta("_panel_base_pos") if panel.has_meta("_panel_base_pos") else panel.position
	panel.set_meta("_panel_base_pos", base_pos)
	var tw := panel.create_tween()
	tw.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	if visible_now:
		panel.visible = true
		panel.position = base_pos + from_offset
		panel.modulate.a = 0.0
		tw.tween_property(panel, "position", base_pos, dur)
		tw.parallel().tween_property(panel, "modulate:a", 1.0, dur * 0.9)
	else:
		tw.tween_property(panel, "position", base_pos + from_offset, dur)
		tw.parallel().tween_property(panel, "modulate:a", 0.0, dur * 0.8)
		tw.finished.connect(func() -> void:
			if is_instance_valid(panel):
				panel.visible = false
				panel.position = base_pos
		)
	panel.set_meta("_tw_panel_slide", tw)
	return tw

static func transition_in(node: CanvasItem, duration: float = -1.0) -> Tween:
	_kill(node, "_tw_transition")
	var dur := duration if duration > 0.0 else UI_METRICS.DUR_TRANSITION
	node.modulate.a = 0.0
	node.scale = Vector2(1.03, 1.03)
	var tw := node.create_tween()
	tw.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tw.tween_property(node, "modulate:a", 1.0, dur)
	tw.parallel().tween_property(node, "scale", Vector2.ONE, dur)
	node.set_meta("_tw_transition", tw)
	return tw

static func transition_out(node: CanvasItem, duration: float = -1.0) -> Tween:
	_kill(node, "_tw_transition")
	var dur := duration if duration > 0.0 else UI_METRICS.DUR_TRANSITION
	var tw := node.create_tween()
	tw.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	tw.tween_property(node, "modulate:a", 0.0, dur * 0.9)
	tw.parallel().tween_property(node, "scale", Vector2(0.98, 0.98), dur)
	node.set_meta("_tw_transition", tw)
	return tw

static func _kill(node: Object, meta_key: String) -> void:
	if not node.has_meta(meta_key):
		return
	var tw = node.get_meta(meta_key)
	if tw is Tween:
		tw.kill()
