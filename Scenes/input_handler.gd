extends Area2D

var hovering: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_entered.connect(func(): hovering = true)
	mouse_exited.connect(func(): hovering = false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if (not hovering): return
	print("inputed")
	get_viewport().set_input_as_handled()
