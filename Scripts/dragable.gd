extends Sprite2D

var dragging: bool = false
var dragging_offset: Vector2
var attachement: Vector2 = position

func _ready():
	pass
func _process(delta):
	if dragging: while_dragging()
	else:
		position = position.lerp(attachement, delta*10)


func start_dragging(_offset: Vector2):
	print("draggin")
	dragging = true
	dragging_offset = _offset
func stop_dragging():
	dragging = false
	for other_area: Area2D in $AttachDetector.get_overlapping_areas():
		var oa_parent = other_area.get_parent()
		if not oa_parent: continue
		attachement = oa_parent.position
	
func while_dragging():
	var mouse_pos = get_global_mouse_position()
	position = mouse_pos+dragging_offset


func _unhandled_input(event):
	if event.is_action_released("Click"):
		if dragging:
			stop_dragging()
		return
	elif event.is_action_pressed("Click"):
		var space = get_world_2d().direct_space_state
		var mouse_pos = get_global_mouse_position()
	
		var parameters = PhysicsPointQueryParameters2D.new();
		parameters.position = mouse_pos;
		parameters.collide_with_areas = true
	
		if space.intersect_point(parameters, 1):
			start_dragging(position-mouse_pos)
