extends Node2D

@export var target: Node
@export var method_name: String = ""
@export var sound: AudioStream

var area: Area2D
var hovering: bool
signal clicked
signal hover_enter
signal hover_exit

# Called when the node enters the scene tree for the first time.
func _ready():
	area = get_child(0)
	area.mouse_entered.connect(func(): 
		hovering = true
		hover_enter.emit()
		)
	area.mouse_exited.connect(func(): 
		hovering = false
		hover_exit.emit()
		)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if (event.is_action_pressed("Click") and hovering):
		if (sound != null): Game.instance.play_and_die(sound)
		if (target != null and target.has_method(method_name)):
			target.call(method_name)
		clicked.emit()
		get_viewport().set_input_as_handled()
