extends Node2D

@export var scale_target: Node2D
var camera: Camera2D
var target

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_child(0)
	camera = Cogworld.instance.camera
	if (scale_target == null):
		scale_target = target
	target.reparent.call_deferred(Cogworld.instance, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	target.position = (global_position-camera.position)*camera.zoom/2
	scale_target.scale = camera.zoom/2
