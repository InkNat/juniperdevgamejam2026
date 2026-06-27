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
@export var land_sound: AudioStream

var _previous_tags = []
var skips = 0

var spinach_mult = 1

func _ready():
	instance = self
	setup(base_tiles)

func food_count(food: String) -> int:
	var result = 0
	for tag in global_tags:
		if food == tag: result+=1
	return result

func _process(delta):
	
	var time_mult = pow(-2,skips)
	
	if current_full_spin_time > 0:
		wheel_rotation += speed*delta*time_mult
		while wheel_rotation < 0: wheel_rotation+=1
		current_full_spin_time-=delta*abs(time_mult)
		if (current_full_spin_time <= 0): hamster_manager.shove()
	elif fadeout_time > 0:
		var effective_speed = spin_curve.sample(fadeout_time/(max_fadeout_time*speed)) * speed
		wheel_rotation += effective_speed*delta*time_mult
		while wheel_rotation < 0: wheel_rotation+=1
		fadeout_time -= delta*abs(time_mult)
		if fadeout_time <= 0: land()
	
	cylinder.rotation.x = wheel_rotation*-TAU
	super._process(delta)
	rotate_wheel(wheel_rotation)

func spin(tags: Array[String], multiplier:float = 1):
	MiniLightController.state = MiniLightController.LightState.Spinning
	_previous_tags = tags
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
			"cheese":
				Game.instance.cheese_bonuses.append(CheeseBonus.new())
			_:
				rest.append(tag)
	total_speed *= motivation*multiplier
	motivation = 1
	speed = total_speed
	global_tags = rest
	current_full_spin_time = total_time
	fadeout_time = max_fadeout_time*speed
	hamster_manager.speed = speed*100
	hamster_manager.run()

var respins: int = 0

func land():
	if skip_check():
		skips+=1
		spin(_previous_tags)
		return
	skips = 0
	respins = total_respins()
	HamsterManager.instance.reset()
	MiniLightController.state = MiniLightController.LightState.Winning
	MiniLightController.tile = tiles[tile_result()]
	MiniLightController.time = 20
	super.land()
	Game.instance.play_and_die(land_sound)
	if respins > 0:
		spin(_previous_tags)
		respins-=1
		return
	skips = 0
	spinach_mult = 1
	Game.instance.land_reset()
	refresh_stickers()
