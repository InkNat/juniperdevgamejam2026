class_name Item extends Node2D

@export var sprite: Sprite2D
@export var pick_item_audio: AudioStream
var _dragging: bool = false
var _dragging_offset: Vector2
var attachement: Vector2 = position
var item_data: ItemData

var color: Tile

func _ready():
	if item_data.color_based:
		color = Game.instance.get_pepper_color()
		sprite.material.set_shader_parameter("hue_shift",color.hue_shift)

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	if _dragging: 
		position = mouse_pos+_dragging_offset
		if (Input.is_action_just_released("Click")):
			click_release()
	else:
		position = position.lerp(attachement, delta*10)

func get_tooltip() -> TooltipData:
	if _dragging: return null
	var name = item_data.name
	var hue_shift = 0
	if item_data.color_based:
		name = color.name + " " + name
		hue_shift = color.hue_shift
	return TooltipData.new(item_data.icon, item_data.background_color,name, item_data.description,2,hue_shift)

func get_tag() -> String:
	if item_data.color_based:
		return item_data.tag + "_" + color.name.to_snake_case()
	return item_data.tag

func click_press():
	Game.play_and_die(pick_item_audio)
	var mouse_pos = get_global_mouse_position()
	_dragging = true
	_dragging_offset = position-mouse_pos+Vector2(0,-2)

func click_release():
	position -= +Vector2(0,-2)
	_dragging = false
	for other_area: Area2D in $Area2D.get_overlapping_areas():
		var oa_parent = other_area.get_parent()
		if oa_parent is Slot:
			oa_parent.insert_item(self)
