class_name Item extends Area2D

@export var sprite: Sprite2D
var _dragging: bool = false
var _dragging_offset: Vector2
var attachement: Vector2 = position
var item_data: ItemData

func _ready():
	pass

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	if _dragging: 
		position = mouse_pos+_dragging_offset
	else:
		position = position.lerp(attachement, delta*10)

func get_tooltip() -> TooltipData:
	if _dragging: return null
	return TooltipData.new(item_data.icon,item_data.name, item_data.description)

func click_press():
	var mouse_pos = get_global_mouse_position()
	_dragging = true
	_dragging_offset = position-mouse_pos

func click_release():
	_dragging = false
	for other_area: Area2D in get_overlapping_areas():
		var oa_parent = other_area.get_parent()
		if oa_parent is Slot:
			oa_parent.insert_item(self)
