extends Node2D

var frame_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	frame_count+=0.1
	var i = 0
	for sprite in get_children():
		var color: Color = Color(1,fmod(frame_count+i,3),1,1)
		sprite.modulate = color
		i+=1
