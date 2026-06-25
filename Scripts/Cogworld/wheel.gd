class_name Wheel extends Node2D


@export var wheel: Node2D
@export var red_arrow: Node2D
@export var cogwheel: Node3D
@export var click_audio: PackedScene
@export var wheel_size: WheelSize = WheelSize.Medium
@export var stickers: Node2D

@export var tiles: Array[Tile]

enum WheelSize {
	Small = 0,
	Medium = 1,
	Large = 2
}

var segments
var previousSegment = 0

var wheel_rotation : float

var subwheels: Array[Wheel]
var wheel_range_min
var wheel_range_max

func _ready():
	var tiles_len = len(tiles)
	segments = tiles_len
	wheel.material.set_shader_parameter("separator_count", tiles_len)
	wheel_range_min = wheel.material.get_shader_parameter("minLength")
	wheel_range_max = wheel.material.get_shader_parameter("maxLength")
	var image: Image = Image.create_empty(ceil(tiles_len/2.0)*2,1,false,Image.FORMAT_RGBA8)
	for i in range(tiles_len):
		image.set_pixel(i,0, tiles[i].color)
		var j = i+0.5
		var pos = Vector2(sin(j/float(tiles_len/TAU)), -cos(j/float(tiles_len/TAU)))*128*wheel_range_max
		var sticker = Node2D.new()
		stickers.add_child(sticker)
		sticker.position = pos
	image.decompress()
	var texture: ImageTexture = ImageTexture.create_from_image(image)
	wheel.material.set_shader_parameter("color_sampler", texture)

func click():
	add_child(click_audio.instantiate())

func _input(event):
	if (event.is_action_pressed("Click")):
		var pos = get_global_mouse_position()-position
		var length = pos.length()/128.0
		if (length > wheel_range_min and length < wheel_range_max):
			var chosen_tile = floor(fmod((-atan2(pos.x, pos.y)/TAU)+0.5+wheel_rotation,1)*16)
			var cs = Game.instance.pop_sticker()
			if (cs != null):
				cs.reparent(stickers.get_child(chosen_tile),true)
				cs.scale = Vector2(0.5,0.5)
			print(chosen_tile)

func rotate_wheel(p_wheel_rotation: float):
	wheel_rotation = p_wheel_rotation
	for subwheel in subwheels:
		var gear_offset = (1/(pow(2,wheel_size)*16))
		var gear_ratio = 1*(pow(2,wheel_size-subwheel.wheel_size))
		subwheel.rotate_wheel((wheel_rotation+gear_offset)*-gear_ratio)

func _process(delta):
	wheel_rotation = fmod(wheel_rotation,1)
	
	wheel.material.set_shader_parameter("angle_offset", wheel_rotation)
	cogwheel.rotation.y = wheel_rotation*TAU
	stickers.rotation = -wheel_rotation*TAU
	
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
	print("landed on tile " + str(result))
	for sticker in stickers.get_child(result).get_children():
		if sticker is not Sticker: continue
		sticker.effect()
	Game.instance.cash_money += tiles[result].base_reward
