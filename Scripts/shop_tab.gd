class_name ShopTab extends Sprite2D

@export var insides: PackedScene
@export var target: Node
@export var tutorial_locked: bool
var is_open = false
var _insides

func _ready():
	if tutorial_locked:
		hide_tab()
	else:
		retract()

func unlock():
	if not tutorial_locked: return
	tutorial_locked = false
	retract()

func open():
	if tutorial_locked:
		return
	is_open = true
	extend()
	delete_insides()
	spawn_insides()
func open_empty():
	if tutorial_locked: return
	is_open = false
	extend()
	delete_insides()
func close():
	if tutorial_locked: return
	is_open = false
	retract()
	delete_insides()

func delete_insides():
	if (_insides != null): 
		if (_insides.has_method("close_smooth")):
			_insides.close_smooth()
		else:
			_insides.queue_free()

func spawn_insides():
	if (is_instance_valid(_insides)): _insides.queue_free()
	if (insides == null): return
	_insides = insides.instantiate()
	target.add_child(_insides)

func extend():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", Vector2(-120,0), 0.3)

func retract():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", Vector2(-23,0), 0.3)

func hide_tab():
	position = Vector2(0,0)
