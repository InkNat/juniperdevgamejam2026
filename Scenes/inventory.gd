class_name Inventory extends Node2D

static var instance: Inventory

var is_open: bool = false
@export var target: Node2D
@export var slots: GridSlots
@export var trash_slot: TrashSlot

func _ready():
	instance = self

func toggle():
	if is_open: close()
	else: open()

func is_empty() -> bool:
	return slots.is_empty() and trash_slot.item == null

func open():
	is_open = true
	MiniTutorial.show_tutorial("inventory")
	var tween = get_tree().create_tween()
	tween.tween_property(target,"position",Vector2.ZERO, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
func close():
	is_open = false
	var tween = get_tree().create_tween()
	tween.tween_property(target,"position",Vector2(59,0), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
