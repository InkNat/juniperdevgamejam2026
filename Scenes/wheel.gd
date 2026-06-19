extends Sprite2D

@export var curve: Curve

var current_spin_time: float = 0
var max_spin_time: float = 1
var segments = 16

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_spin_time < 0: return
	rotation += curve.sample(current_spin_time/max_spin_time)
	if (rotation > PI*2): rotation-=PI*2
	if current_spin_time > 0:
		current_spin_time -= delta
		if current_spin_time <= 0: land()
			

func land():
	var result = floor((rotation_degrees/360) * segments)
	get_parent().cash_money += result

func spin(spin_time: float):
	current_spin_time += spin_time
	max_spin_time = current_spin_time

func _unhandled_input(event):
	if event.is_action_pressed("Click"):
		spin(0.3)
