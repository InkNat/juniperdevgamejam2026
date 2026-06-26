class_name Proxy extends Node2D

@export var scale_target: Node2D
var camera: Camera2D
var target

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_child(0)
	camera = Cogworld.instance.camera
	if (scale_target == null):
		scale_target = target
	target.reparent.call_deferred(Game.instance, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var e = get_viewport_rect().size/2
	target.position = ((global_position-camera.position)*camera.zoom)+e
	scale_target.scale = camera.zoom
	
func delete():
	if (scale_target != target):
		if is_instance_valid(scale_target):
			scale_target.queue_free()
	if is_instance_valid(target):
		target.queue_free()
