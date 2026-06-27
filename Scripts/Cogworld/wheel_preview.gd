extends Node2D

@onready var sound: AudioStream = load("res://Sounds/wheel_place.wav")
var wheel_size
var wheel_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	MiniTutorial.show_tutorial("place_wheel", false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func safe_delete():
	for e in get_children():
		if e is Proxy: e.delete()

func place_wheel_here():
	MiniTutorial.instance.hide_tutorial()
	Game.instance.play_and_die(sound)
	Game.instance.camera_weight()
	Cogworld.instance.place_wheel_at(wheel_size,wheel_position)
