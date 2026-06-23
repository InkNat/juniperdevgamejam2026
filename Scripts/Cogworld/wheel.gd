class_name Wheel extends Node2D

@export var wheel: Node2D
@export var red_arrow: Node2D
@export var cylinder: Node3D
@export var cogwheel: Node3D
@export var click_audio: PackedScene
@export var wheel_size: WheelSize = WheelSize.Medium

enum WheelSize {
	Small = 0,
	Medium = 1,
	Large = 2
}

var segments = 16
var previousSegment = 0

var wheel_rotation : float

var subwheels: Array[Wheel]

func click():
	add_child(click_audio.instantiate())

func rotate_wheel(p_wheel_rotation: float):
	wheel_rotation = p_wheel_rotation
	for subwheel in subwheels:
		var gear_offset = (1/(pow(2,wheel_size)*16))
		var gear_ratio = 1*(pow(2,wheel_size-subwheel.wheel_size))
		subwheel.rotate_wheel((wheel_rotation+gear_offset)*-gear_ratio)

func _process(delta):
	if (wheel_rotation > 1): wheel_rotation-=1
	
	wheel.material.set_shader_parameter("angle_offset", wheel_rotation)
	cogwheel.rotation.y = -wheel_rotation*TAU
	
	var currentSegment = floor(wheel_rotation*segments)
	
	if (currentSegment != previousSegment):
		click()
		previousSegment = currentSegment
	for child in get_children():
		if child is not Wheel: continue
		var wheel_child : Wheel = child
		wheel_child.wheel_rotation = (1/float(segments*2))-wheel_rotation

func land():
	var result = floor((wheel_rotation) * segments)
	Game.instance.cash_money += result
