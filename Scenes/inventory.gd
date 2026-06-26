extends Node2D

var is_open: bool = false
@export var target: Node2D

func toggle():
	if is_open: close()
	else: open()

func open():
	is_open = true
	var tween = get_tree().create_tween()
	tween.tween_property(target,"position",Vector2.ZERO, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
func close():
	is_open = false
	var tween = get_tree().create_tween()
	tween.tween_property(target,"position",Vector2(59,0), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
