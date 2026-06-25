class_name HamsterManager extends RigidBody3D

@export var animated_sprite: AnimatedSprite3D
@export var collision_noise: AudioStream
var speed: float = 1
var previous = 0

var _pos
var _rot

var shove_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_rot = rotation
	_pos = position
	freeze = true
	body_entered.connect(random_hurt)

func shove():
	freeze = false
	shove_time = 1
	linear_velocity = Vector3((randf()-0.5),randf(),0).normalized() * 30
func reset():
	freeze = true
	position = _pos
	rotation = _rot
	speed = 1
	animated_sprite.play("omori_wobbler")
func run():
	animated_sprite.play("running")

func random_hurt(_other):
	var _speed = linear_velocity.length()
	Game.play_and_die(collision_noise, (randf()+1)/2,_speed/30)
	animated_sprite.stop()
	var e = (randi()%9)+1
	if e == previous: e+=1
	animated_sprite.play("hurt_"+str(e))
	previous = e

func _process(delta):
	if (Input.is_action_just_pressed("Medium")):
		shove()
	
	animated_sprite.speed_scale = speed
	if (position.length() > 10):
		position = _pos
	if (linear_velocity.length() < 0.01 and not freeze):
		shove_time -= delta
		if (shove_time < 0):
			reset()
