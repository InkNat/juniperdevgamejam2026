class_name Item extends Area2D

var _dragging: bool = false
var _dragging_offset: Vector2
var attachement: Vector2 = position

func _ready():
	pass

func _process(delta):
	if _dragging: while_dragging()
	else:
		position = position.lerp(attachement, delta*10)

func start_dragging(_offset: Vector2):
	_dragging = true
	_dragging_offset = _offset

func stop_dragging():
	_dragging = false
	for other_area: Area2D in get_overlapping_areas():
		var oa_parent = other_area.get_parent()
		if oa_parent is Slot:
			oa_parent.insert_item(self)
	
func while_dragging():
	var mouse_pos = get_global_mouse_position()
	position = mouse_pos+_dragging_offset

func _unhandled_input(event):
	if event.is_action_released("Click"):
		if _dragging:
			stop_dragging()
		return
	elif event.is_action_pressed("Click"):
		var space = get_world_2d().direct_space_state
		var mouse_pos = get_global_mouse_position()
	
		var parameters = PhysicsPointQueryParameters2D.new();
		parameters.position = mouse_pos;
		parameters.collide_with_areas = true
	
		var result = space.intersect_point(parameters)
		for dict in result:
			print(dict["collider"])
			if dict["collider"] == self:
				start_dragging(position-mouse_pos)
