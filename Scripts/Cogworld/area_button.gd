extends Node2D

@export var target: Node
@export var method_name: String = ""

var area: Area2D
var hovering: bool
signal clicked

# Called when the node enters the scene tree for the first time.
func _ready():
	area = get_child(0)
	area.mouse_entered.connect(func(): hovering = true)
	area.mouse_exited.connect(func(): hovering = false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event):
	if (event.is_action_pressed("Click") and hovering):
		if (target != null and target.has_method(method_name)):
			target.call(method_name)
		clicked.emit()
		get_viewport().set_input_as_handled()
