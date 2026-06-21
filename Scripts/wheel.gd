extends Slot

@export var spin_curve: Curve
@export var wheel: Node2D
@export var red_arrow: Node2D
@export var cylinder: Node3D
@export var cogwheel: Node3D
@export var click_audio: PackedScene

var maximum_capacity = 3
var _item_count = 0
var sign_open

var current_spin_time: float = 0
var max_spin_time: float = 1
var segments = 16
var previousSegment = 0
var speed: float = 1

var wheel_rotation : float

func click():
	add_child(click_audio.instantiate())

func arrange_items():
	var i = 0
	for child in get_children():
		if child is not Item: continue
		var index = i-((_item_count-1)/2.0)
		child.attachement = Vector2(index*16,0);
		i+=1

func consume_and_spin():
	if _item_count == 0: return
	for child in get_children():
		if child is not Item: continue
		var item : Item = child
		item.queue_free()
	_item_count = 0
	spin(1*(0.5+randf()),1)

func _can_insert(_item: Item) -> bool:
	return _item_count < maximum_capacity

func _insert(item: Item):
	item.reparent(self, true)
	_item_count+=1
	arrange_items()

func can_retrieve(_item: Item) -> bool:
	return false

func _retrieve(_item: Item):
	pass

func _process(delta):
	if current_spin_time < 0: return
	
	wheel_rotation += spin_curve.sample(current_spin_time/max_spin_time) * speed
	if (wheel_rotation > 1): wheel_rotation-=1
	
	wheel.material.set_shader_parameter("angle_offset", wheel_rotation)
	cylinder.rotation.x = wheel_rotation*TAU
	cogwheel.rotation.y = -wheel_rotation*TAU
	
	var currentSegment = floor(wheel_rotation*segments)
	
	if (currentSegment != previousSegment):
		click()
		previousSegment = currentSegment
	
	if current_spin_time > 0:
		current_spin_time -= delta
		if current_spin_time <= 0: land()
			

func land():
	var result = floor((wheel_rotation) * segments)
	Game.instance.cash_money += result

func spin(spin_time: float, spin_speed: float):
	current_spin_time += spin_time
	max_spin_time = current_spin_time
	speed = spin_speed

func _unhandled_input(event):
	if event.is_action_pressed("DebugSpinWheel"):
		consume_and_spin()
