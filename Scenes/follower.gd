extends Sprite2D

@export var target: Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	material.set_shader_parameter("offset",((-target.global_position)+(get_viewport_rect().size/2))/400)
	material.set_shader_parameter("scale", Vector2(1/Game.instance.camera.zoom.x,1/Game.instance.camera.zoom.y))
