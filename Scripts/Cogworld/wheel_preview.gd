extends Node2D

var wheel_size
var wheel_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func safe_delete():
	for e in get_children():
		if e is Proxy: e.delete()

func place_wheel_here():
	Cogworld.instance.place_wheel_at(wheel_size,wheel_position)
