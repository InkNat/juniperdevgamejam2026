class_name Wheel extends Node2D

@onready var trigger_sound = load("res://Sounds/trigger.wav")

@export var wheel: Node2D
@export var red_arrow: Node2D
@export var red_arrow_curve: Curve
@export var cogwheel: Node3D
@export var click_audio: AudioStream
@export var tile_tooltip: PackedScene
@export var wheel_size: WheelSize = WheelSize.Medium
@export var stickers: Node2D
@export var wheel_stickers: Node2D

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

var rain_bow_bow_tiles: Array[Tile] = []

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
	Game.instance.play_and_die(click_audio)
	var result = tile_result()
	if has_stickers(result, "clicker"):
		trigger(result, TriggerTrace.new(), 0.05)
	
	var spinach = MainWheel.instance.food_count("spinach")*0.01
	MainWheel.instance.spinach_mult += spinach
	if (spinach > 0):
		Multipliers.instance.set_display_text("spinach", str(int(MainWheel.instance.spinach_mult*100)) + "%")
		
	var popcorn = MainWheel.instance.food_count("popcorn")
	if popcorn > 0:
		trigger(result, TriggerTrace.new(), popcorn*0.025)

func _input(event):
	if not _setup: return
	if Game.instance.current_sticker == null: return
	var is_wheel: bool = Game.instance.current_sticker.sticker_data.wheel_sticker
	if is_wheel and self is MainWheel:
		return
	if (event.is_action_pressed("Click")):
		var pos = get_global_mouse_position()-position
		var length = pos.length()/sprite_scale
		if length < wheel_range_min:
			if is_wheel:
				var cs = Game.instance.pop_sticker()
				if (cs != null):
					Game.play_and_die(Sticker.sound_stick)
					cs.reparent(wheel_stickers,true)
					cs.scale = Vector2(0.5,0.5)
			else:
				for e in wheel_stickers.get_children():
					if e is Sticker:
						if (e.get_child_count() > 1): continue
						if e.sticker_data.get_tag() == "halo":
							var cs = Game.instance.pop_sticker()
							Game.play_and_die(Sticker.sound_stick)
							cs.reparent(e,true)
							cs.position = Vector2.ZERO
							cs.rotation = 0
							cs.scale = Vector2(1,1)
		elif (length > wheel_range_min and length < wheel_range_max):
			var chosen_tile = floor(fmod((-atan2(pos.x, pos.y)/TAU)+0.5+wheel_rotation,1)*segments)
			if (stickers.get_child(chosen_tile).get_child_count() > 3): return
			var cs = Game.instance.pop_sticker()
			if (cs != null):
				Game.play_and_die(Sticker.sound_stick)
				cs.reparent(stickers.get_child(chosen_tile),true)
				cs.scale = Vector2(0.5,0.5)

func rotate_wheel(p_wheel_rotation: float):
	if not _setup: return
	wheel_rotation = p_wheel_rotation
	for subwheel in subwheels:
		var gear_offset = (1/(pow(2,wheel_size)*16))
		var gear_ratio = 1*(pow(2,wheel_size-subwheel.wheel_size))
		subwheel.rotate_wheel((wheel_rotation+gear_offset)*-gear_ratio)

func normalized_wheel_rotation() -> float:
	return fmod(wheel_rotation,1)

func tile_result() -> int:
	return floor(fmod(wheel_rotation*wheel_speed(),1)*segments)

func wheel_speed() -> float:
	return pow(2,len(get_wheel_stickers("gear_ratio")))

func has_wheel_sticker(_name: String) -> bool:
	for e in wheel_stickers.get_children():
		if e is Sticker:
			if e.sticker_data.get_tag() == _name: return true
	return false
func get_wheel_stickers(_name: String, check_exhaust: bool = false) -> Array[Sticker]:
	var result: Array[Sticker] = []
	for e in wheel_stickers.get_children():
		if e is Sticker:
			if e.sticker_data.get_tag() == _name:
				if check_exhaust:
					if e.exhausted: 
						continue
					elif e.sticker_data.exhausts: 
						e.exhaust()
				result.append(e)
	return result



func _process(_delta):
	if not _setup: return 
	
	red_arrow.rotation = red_arrow_curve.sample(fmod(wheel_rotation*segments,1))
	
	var wheel_speed = wheel_speed()
	cogwheel.rotation.y = wheel_rotation*TAU
	stickers.rotation = -wheel_rotation*TAU*wheel_speed
	wheel_stickers.rotation = stickers.rotation
	wheel.material.set_shader_parameter("angle_offset", wheel_rotation*wheel_speed)
	
	var currentSegment = floor(wheel_rotation*segments)
	
	if (currentSegment != previousSegment):
		click()
		previousSegment = currentSegment

func clover_randf(clover_count: int):
	var e = randf()
	for i in range(clover_count):
		var f = randf()
		if e < f: e = f
	return e

func has_stickers(index: int, tag: String, check_exhaust: bool = false) -> bool:
	for s in stickers.get_child(index).get_children():
		if s is not Sticker: continue
		if check_exhaust:
			if s.exhausted: 
				continue
			elif s.sticker_data.exhausts: 
				s.exhaust()
		if s.sticker_data.get_tag() == tag:
			return true
	
	if (halo_check(tag)): return true
	return false

func halo_check(tag: String):
	for wheel_sticker in wheel_stickers.get_children():
		if wheel_sticker is Sticker:
			if wheel_sticker.sticker_data.get_tag() == "halo":
				print("is halo")
				if wheel_sticker.get_child_count() > 1:
					print("has child")
					for child in wheel_sticker.get_children():
						if child is not Sticker: continue
						if child.sticker_data.get_tag() == tag:
							print("haloed")
							return true

func count_stickers(index: int, tag: String, check_exhaust: bool = false) -> int:
	var result = 0
	for s in stickers.get_child(index).get_children():
		if s is not Sticker: continue
		if check_exhaust:
			if s.exhausted: 
				continue
			elif s.sticker_data.exhausts: 
				s.exhaust()
		if s.sticker_data.get_tag() == tag:
			result+=1
	if (halo_check(tag)): return true
	return result

func count_total_stickers(tag: String) -> int:
	var result = 0
	for c in range(stickers.get_child_count()):
		result += count_stickers(c, tag)
	return result

func get_sticker_list(index: int, check_exhaust: bool = false) -> Array[Sticker]:
	var result: Array[Sticker] = []
	for sticker in stickers.get_child(index).get_children():
		if sticker is not Sticker: continue
		if check_exhaust:
			if sticker.exhausted: 
				continue
			elif sticker.sticker_data.exhausts: 
				sticker.exhaust()
		result.append(sticker)
	return result

func trigger_tile(tile: Tile, trigger_trace: TriggerTrace, multiplier: float = 1):
	for c in range(len(tiles)):
		if (tiles[c] == tile):
			trigger(c, trigger_trace, multiplier)

func trigger(index: int, trigger_trace: TriggerTrace, multiplier: float = 1):
	var tile = tiles[index]
	
	if MainWheel.instance.food_count("apple_slice") > 0 and tile.base_reward < 0:
		return
	
	var trigger_count = 1 + MainWheel.instance.food_count("sun._seed") + MainWheel.instance.food_count("pepper_"+tile.name.to_snake_case())
	for e in trigger_count:
		_trigger(index, trigger_trace, multiplier)
func _trigger(index: int, trigger_trace: TriggerTrace, multiplier: float = 1):
	var rolled_tile = tiles[index]
	
	for e in get_wheel_stickers("nodal", true):
		for w in Cogworld.instance.get_neighbors_of(self):
			if trigger_trace.check(e):
				w.trigger_tile(rolled_tile, trigger_trace, multiplier)
	
	var rainbow_count = len(get_wheel_stickers("rainbow_bow"))
	if rainbow_count > 0:
		if rain_bow_bow_tiles.has(rolled_tile):
			rain_bow_bow_tiles = []
	rain_bow_bow_tiles.append(rolled_tile)
	
	var tags = get_sticker_list(index, true)
	
	var total_star_count = count_total_stickers("star")
	var clover_count = count_stickers(index, "lucky_clover")
	
	var money = rolled_tile.base_reward
	
	var bonus_money = len(rain_bow_bow_tiles)*10000*rainbow_count
	
	var raspberry_count = 0
	var mulberry_count = 0
	var plaster_count = 0
	var heart_count = 0
	
	for sticker in tags:
		var effect: String = sticker.sticker_data.get_tag()
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
				bonus_money+=total_star_count*500
			"horseshoe":
				if clover_randf(clover_count) >= 0.8:
					bonus_money+=10000
			"motivational":
				MainWheel.instance.motivation+=0.25*multiplier
			"affectionate":
				heart_count+=1
			"apple_sticker":
				MiniJuicer.juice(stickers.get_child(index).global_position, trigger_sound, "Apple!", Color(1,0.3,0.5,1), len(trigger_trace._contents)*0.1)
				if clover_randf(clover_count) >= 1-(0.1*multiplier):
					var apple = Game.instance.apple.create_item()
					var result = GridSlots.instance.add_item(apple)
					if not result: apple.queue_free()
			"drill":
				if trigger_trace.check(sticker):
					trigger((index+(segments/2))%segments,trigger_trace,multiplier)
			"nosey_neighbor":
				var mult = (clover_randf(clover_count)*0.5)+0.25
				mult *= multiplier
				if trigger_trace.check(sticker):
					trigger((index+1)%segments,trigger_trace, mult)
					trigger((index-1)%segments,trigger_trace, mult)
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
	
	var mulberry_mult = pow(1.5,mulberry_count)
	var raspberry_add = (raspberry_count*100)
	
	if (raspberry_add > 0): Multipliers.instance.set_display_text("raspberry", "+"+ str(raspberry_add))
	if (mulberry_mult > 1):  Multipliers.instance.set_display_text("mulberry", "x"+ str(floor(mulberry_mult*1000)/1000.0))
	
	var total = (ceil((money+raspberry_add)*mulberry_mult)) * multiplier * MainWheel.instance.spinach_mult * Game.instance.get_cheese_bonus()
	total = ceil(total)
	MiniJuicer.juice(stickers.get_child(index).global_position, trigger_sound, "+" + str(total) +"$", rolled_tile.color, len(trigger_trace._contents)*0.1)
	Game.instance.cash_money += total

func skip_check() -> bool:
	var result = tile_result()
	for sub_wheel in subwheels:
		if (sub_wheel.skip_check()):
			return true
	return has_stickers(result, "nuh_uh!", true)

func total_respins() -> int:
	var result = tile_result()
	var respins = 0
	var clover_count = count_stickers(result, "lucky_clover")
	for sub_wheel in subwheels:
		respins+=sub_wheel.total_respins()
	for i in range(count_stickers(result, "again!_and_again?", true)):
		respins+=1
		if clover_randf(clover_count) > 0.9:
			respins+=1
	return respins

func land():
	for sub_wheel in subwheels:
		sub_wheel.land()
	var result = tile_result()
	var credit_cards = len(get_wheel_stickers("credit_card"))
	trigger(result,TriggerTrace.new(), pow(1.5, credit_cards))

func refresh_stickers():
	for sub_wheel in subwheels:
		sub_wheel.refresh_stickers()
	for c in stickers.get_children():
		for s in c.get_children():
			if s is not Sticker: continue
			if not s.exhausted: continue
			s.refresh()
	for s in wheel_stickers.get_children():
		if s is not Sticker: continue
		if not s.exhausted: continue
		s.refresh()
