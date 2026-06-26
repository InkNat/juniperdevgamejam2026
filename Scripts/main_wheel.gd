class_name MainWheel extends Wheel

static var instance: MainWheel

var global_tags: Array[String] = []
var motivation: float = 1

var current_full_spin_time: float = 0
var fadeout_time: float = 0
const max_fadeout_time:float = 2.5
var speed: float = 1
@export var packed_scene: PackedScene
@export var spin_curve: Curve
@export var cylinder: Node3D
@export var hamster_manager: HamsterManager
@export var base_tiles: Array[Tile]

func _ready():
	instance = self
	setup(base_tiles)

func _process(delta):
	
	if current_full_spin_time > 0:
		wheel_rotation += speed*delta
		current_full_spin_time-=delta
		if (current_full_spin_time <= 0): hamster_manager.shove()
	elif fadeout_time > 0:
		var effective_speed = spin_curve.sample(fadeout_time/(max_fadeout_time*speed)) * speed
		wheel_rotation += effective_speed*delta
		fadeout_time -= delta
		if fadeout_time <= 0: land()
	
	cylinder.rotation.x = wheel_rotation*-TAU
	super._process(delta)
	rotate_wheel(wheel_rotation)

func spin(tags: Array[String]):
	Game.instance.spin_reset()
	var total_time = (randf()*2)+1
	var total_speed = 1
	var rest: Array[String] = []
	for tag in tags:
		match tag:
			"oat":
				total_time += (randf()*1)+1
			"carrot":
				total_speed += 1
			_:
				rest.append(tag)
	total_speed *= motivation
	motivation = 1
	speed = total_speed
	global_tags = rest
	current_full_spin_time = total_time
	fadeout_time = max_fadeout_time*speed
	hamster_manager.speed = speed*100
	hamster_manager.run()

func land():
	super.land()
	Game.instance.land_reset()
