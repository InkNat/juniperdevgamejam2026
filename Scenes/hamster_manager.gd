class_name HamsterManager extends RigidBody3D

static var instance: HamsterManager

@export var animated_sprite: AnimatedSprite3D
@export var collision_noise: AudioStream
@export var particles: CPUParticles3D
@export var sound: AudioStream
@export var music: AudioStreamPlayer
var speed: float = 1
var previous = 0

var _pos
var _rot

var tween_buffer: Tween

var shove_time = 0

var exploded = false
var explode_time = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	instance = self
	_rot = rotation
	_pos = position
	freeze = true
	body_entered.connect(random_hurt)

func explode():
	print("bam")
	music.playing = false
	Game.instance.play_and_die(sound)
	animated_sprite.visible = false
	particles.emitting = true
	MiniLightController.state = MiniLightController.LightState.Dead
	Inventory.instance.close()
	Game.instance.shop_tabs.close_all()
	Game.instance.shop_tabs.locked = true
	exploded = true

func shove():
	if (tween_buffer != null and tween_buffer.is_valid()):
		tween_buffer.kill()
	freeze = false
	shove_time = 1
	linear_velocity = Vector3((randf()-0.5),randf(),0).normalized() * 30
func reset():
	shove_time = 0
	freeze = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", _pos, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.parallel().tween_property(self, "rotation", _rot, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween_buffer = tween
	speed = 1
	animated_sprite.play("omori_wobbler")
func run():
	animated_sprite.play("running")

func random_hurt(_other):
	var _speed = linear_velocity.length()
	Game.play_and_die(collision_noise, (randf()+1)/2,0.3 + (_speed/30))
	animated_sprite.stop()
	var e = (randi()%11)
	if e == previous: e+=1
	animated_sprite.play("hurt_"+str(e))
	previous = e

func _process(delta):
	if exploded:
		explode_time-=delta
		if explode_time < 0:
			Main.instance.switch_scene("main_menu")
	
	if (Input.is_action_just_pressed("Medium")):
		shove()
	
	animated_sprite.speed_scale = speed
	if (position.length() > 10):
		position = _pos
	if (linear_velocity.length() < 0.01 and not freeze):
		shove_time -= delta
		if (shove_time < 0):
			reset()
