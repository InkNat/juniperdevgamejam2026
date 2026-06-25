extends RigidBody3D

@export var animated_sprite: AnimatedSprite3D
var speed: float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animated_sprite.speed_scale = speed
