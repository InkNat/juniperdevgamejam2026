class_name Wheel extends Node2D


@export var wheel: Node2D
@export var red_arrow: Node2D
@export var cogwheel: Node3D
@export var click_audio: PackedScene
@export var tile_tooltip: PackedScene
@export var wheel_size: WheelSize = WheelSize.Medium
@export var stickers: Node2D

@export var sprite_scale: float = 128

var tiles: Array[Tile]

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

var _setup: bool = false

func setup(p_tiles: Array[Tile]):
	tiles = p_tiles
	_setup = true
	var tiles_len = len(tiles)
	segments = tiles_len
	wheel.material.set_shader_parameter("separator_count", tiles_len)
	wheel_range_min = wheel.material.get_shader_parameter("minLength")
	wheel_range_max = wheel.material.get_shader_parameter("maxLength")
	var average_wr = (wheel_range_max+wheel_range_min)/2.0
	var image: Image = Image.create_empty(ceil(tiles_len/128.0)*128,1,false,Image.FORMAT_RGBA8)
	for i in range(tiles_len):
		image.set_pixel(i,0, tiles[i].color)
		var j = i+0.5
		var pos = Vector2(sin(j/float(tiles_len/TAU)), -cos(j/float(tiles_len/TAU)))*sprite_scale*average_wr
		var tt = tile_tooltip.instantiate()
		tt.tile = tiles[i]
		stickers.add_child(tt)
		tt.position = pos
	image.decompress()
	var texture: ImageTexture = ImageTexture.create_from_image(image)
	wheel.material.set_shader_parameter("color_sampler", texture)

func click():
	add_child(click_audio.instantiate())
	var result = floor((wheel_rotation) * segments)
	print(result)
	for sticker in stickers.get_child(result).get_children():
		if sticker is not Sticker: continue
		if sticker.sticker_data.get_tag() == "clicker":
			trigger(result, 0.05)

func _input(event):
	if not _setup: return
	if (event.is_action_pressed("Click")):
		var pos = get_global_mouse_position()-position
		var length = pos.length()/sprite_scale
		if (length > wheel_range_min and length < wheel_range_max):
			var chosen_tile = floor(fmod((-atan2(pos.x, pos.y)/TAU)+0.5+wheel_rotation,1)*segments)
			var cs = Game.instance.pop_sticker()
			if (cs != null):
				cs.reparent(stickers.get_child(chosen_tile),true)
				cs.scale = Vector2(0.5,0.5)
			print(chosen_tile)

func rotate_wheel(p_wheel_rotation: float):
	if not _setup: return
	wheel_rotation = p_wheel_rotation
	for subwheel in subwheels:
		var gear_offset = (1/(pow(2,wheel_size)*16))
		var gear_ratio = 1*(pow(2,wheel_size-subwheel.wheel_size))
		subwheel.rotate_wheel((wheel_rotation+gear_offset)*-gear_ratio)

func _process(delta):
	if not _setup: return 
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

func clover_randf(clover_count: int):
	var e = randf()
	for i in range(clover_count):
		var f = randf()
		if e < f: e = f
	return e

func trigger(index: int, multiplier = 1):
	var tags = []
	for sticker in stickers.get_child(index).get_children():
		if sticker is not Sticker: continue
		tags.append(sticker.sticker_data.get_tag())
		
	var star_count = 0
	for c in stickers.get_children():
		for s in c.get_children():
			if s is not Sticker: continue
			if s.sticker_data.get_tag() == "star":
				star_count+=1
	var clover_count = 0
	for c in stickers.get_children():
		for s in c.get_children():
			if s is not Sticker: continue
			if s.sticker_data.get_tag() == "lucky_clover":
				clover_count+=1
	
	var money = tiles[index].base_reward
	
	var bonus_money = 0
	
	var raspberry_count = 0
	var mulberry_count = 0
	var plaster_count = 0
	var heart_count = 0
	
	for effect in tags:
		match effect:
			"coin":
				bonus_money+=1000
			"bill":
				bonus_money+=5000
			"debit_card":
				bonus_money+=20000
			"plaster":
				plaster_count+=1
			"star":
				bonus_money+=star_count*500
			"horseshoe":
				if clover_randf(clover_count) >= 0.8:
					bonus_money+=10000
			"motivational":
				MainWheel.instance.motivation+=0.25
			"affectionate":
				heart_count+=1
			"apple_sticker":
				if clover_randf(clover_count) >= 0.9:
					var apple = Game.instance.apple.create_item()
					var result = GridSlots.instance.add_item(apple)
					if not result: apple.queue_free()
			"drill":
				trigger((index+(segments/2))%segments)
			"nosey_neighbor":
				var mult = (clover_randf(clover_count)*0.5)+0.25
				trigger((index+1)%segments, mult)
				trigger((index-1)%segments, mult)
	for i in range(plaster_count):
		money *= (0.5 - (clover_randf(clover_count)*0.25))
	for i in range(heart_count):
		money = pow(money,1.2)
	money += bonus_money
	
	for effect in MainWheel.instance.global_tags:
		match effect:
			"raspberry":
				raspberry_count+=1
			"mulberry":
				mulberry_count+=1
	
	Game.instance.cash_money += (ceil((money+(raspberry_count*100))*pow(1.5,mulberry_count))) * multiplier

func land():
	for sub_wheel in subwheels:
		sub_wheel.land()
	var result = floor((wheel_rotation) * segments)
	print("landed on tile " + str(result))
	trigger(result)
