extends Wheel

var current_spin_time: float = 0
var max_spin_time: float = 1
var speed: float = 1
@export var packed_scene: PackedScene
@export var spin_curve: Curve

func _process(delta):
	
	if current_spin_time < 0: return
	
	wheel_rotation += spin_curve.sample(current_spin_time/max_spin_time) * speed
	cylinder.rotation.x = wheel_rotation*TAU
	super._process(delta)
	if current_spin_time > 0:
		current_spin_time -= delta
		if current_spin_time <= 0: land()
	rotate_wheel(wheel_rotation)

func spin(spin_time: float, spin_speed: float):
	current_spin_time += spin_time
	max_spin_time = current_spin_time
	speed = spin_speed
