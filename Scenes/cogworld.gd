class_name Cogworld extends Node2D

static var instance: Cogworld

@export var previews: Dictionary[Wheel.WheelSize,PackedScene]
@export var wheels: Dictionary[Wheel.WheelSize,PackedScene]
@export var main_cogwheel : Wheel
@export var camera: Camera2D
@export var cogworld_viewport: Node
var grid : Dictionary[Vector2i,Wheel]
var _previews: Array[Node] = []

func neighbor_checks(wheel_size_from, wheel_size_to) -> Array[Vector2i]:
	if (wheel_size_from == wheel_size_to):
		var e: int = floor(pow(2,wheel_size_to))
		return [
			Vector2i(0, e),
			Vector2i(-e, 0),
			Vector2i(e,0),
			Vector2i(0, -e)]
	elif (wheel_size_from == wheel_size_to-1):
		var e: int = floor(pow(2,wheel_size_to-1))
		return [
			Vector2i(e, e),
			Vector2i(e, -e),
			Vector2i(-e, e),
			Vector2i(-e, -e)]
	elif (wheel_size_from == wheel_size_to+1):
		var e: int = floor(pow(2,wheel_size_to))
		return [
			Vector2i(e, e),
			Vector2i(e, -e),
			Vector2i(-e, e),
			Vector2i(-e, -e)]
	else:
		return []

func _init():
	instance = self

func _ready():
	grid[Vector2i(0,0)] = main_cogwheel
	generate_previews(Wheel.WheelSize.Small)

func _process(_delta):
	if (Input.is_action_just_pressed("Small")):
		generate_previews(Wheel.WheelSize.Small)
	if (Input.is_action_just_pressed("Medium")):
		generate_previews(Wheel.WheelSize.Medium)
	if (Input.is_action_just_pressed("Big")):
		generate_previews(Wheel.WheelSize.Large)

func generate_previews(wheel_size):
	for preview in _previews:
		preview.queue_free()
	_previews = []
	
	for vec: Vector2 in get_all_empty_spots(wheel_size):
		var cl = previews[wheel_size].instantiate()
		cl.position = vec*Vector2(64,64)
		cl.wheel_position = vec
		cl.wheel_size = wheel_size
		cogworld_viewport.add_child(cl)
		_previews.append(cl)

func sync_wheel(vec: Vector2i, wheel: Wheel):
	for size in Wheel.WheelSize.values():
		for neighbor_pos in neighbor_checks(wheel.wheel_size, size):
			var neighbor: Wheel = grid.get(vec+neighbor_pos)
			if (neighbor == null): continue
			if (neighbor.wheel_size != size): continue
			neighbor.subwheels.append(wheel)
			print("connected to wheel of size " + str(neighbor.wheel_size) + " at " + str(vec+neighbor_pos))
			return

func place_wheel_at(wheel_size, vec: Vector2i):
	if (grid.get(vec) != null): return
	var scene = wheels[wheel_size]
	var inst = scene.instantiate()
	inst.position = vec*Vector2i(64,64)
	grid[vec] = inst
	cogworld_viewport.add_child(inst)
	generate_previews(wheel_size)
	sync_wheel(vec, inst)

func get_all_empty_spots(size) -> Array[Vector2i]:
	var uniquevecs: Array[Vector2i] = []
	for vec: Vector2i in grid:
		for empty_neighbor in empty_neighbors_at(size,vec):
			if not uniquevecs.has(empty_neighbor): uniquevecs.append(empty_neighbor)
	return uniquevecs

func overlap_check(check: Vector2i, wheel_coords:Vector2i, strict: bool, wheel_size, t_wheel_size) -> bool:
	
	var wheel_scale = floor(pow(2,wheel_size-1))
	var coords = check-wheel_coords
	var m = max(abs(coords.x), abs(coords.y))
	if (wheel_size == 0):
		return coords == Vector2i(0,0)
	if (m < wheel_scale): return true
	if strict && m == wheel_scale:
		if (wheel_size == t_wheel_size) or (abs(coords.x) != abs(coords.y)):
			return true
	return false

func spot_overlap(vec: Vector2i, strict: bool, t_wheel_size) -> bool:
	var wheel_size = Wheel.WheelSize.values()[-1]
	
	var wlength = floor(pow(2,wheel_size-1))
	var size = 1+(wlength*2)
	var half = floor(size/2.0)
	for _x in range(size):
		var x = _x-half
		for _y in range(size):
			var y = _y-half
			
			var xy = Vector2i(x,y)
			var coords = xy+vec
			var wheel = grid.get(coords)
			if wheel == null: continue
			print(vec)
			print("found wheel of size " + str(wheel.wheel_size) + " at " + str(coords) + " strict = " + str(strict))
			if (overlap_check(vec, coords, strict, wheel.wheel_size, t_wheel_size)):
				return true
	return false

func wheel_overlap(vec: Vector2i, wheel_size) -> bool:
	var wlength = floor(pow(2,wheel_size-1))
	var size = 1+(wlength*2)
	var half = floor(size/2.0)
	for _x in range(size):
		var x = _x-half
		for _y in range(size):
			var y = _y-half
			if (abs(x) == abs(y) and abs(x) == wlength and wlength != 0): continue
			var strict: bool = (abs(x) != wlength and abs(y) != wlength)
			if (wlength == 0): strict = true
			if (spot_overlap(vec+Vector2i(x,y),strict, wheel_size)):
				return true
	return false

func empty_neighbors_at(wheel_size: int, vec: Vector2i) -> Array[Vector2i]:
	var wheel = grid[vec]
	var result: Array[Vector2i] = []
	if (wheel == null): return result
	for check in neighbor_checks(wheel.wheel_size,wheel_size):
		if (wheel_overlap(check+vec, wheel_size)): continue
		var neighbor = grid.get(check+vec)
		if (neighbor == null):
			result.append(vec+check)
	return result
