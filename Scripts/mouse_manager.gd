extends Node2D

@export var tooltip : Control
@export var texture_rect : TextureRect
@export var name_label : Label
@export var description_label : RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var space = get_world_2d().direct_space_state
	var mouse_pos = get_global_mouse_position()
	
	position = mouse_pos
	
	var parameters = PhysicsPointQueryParameters2D.new();
	parameters.position = mouse_pos;
	parameters.collide_with_areas = true
	var show_tooltip = false
	var result = space.intersect_point(parameters)
	for dict in result:
		var collider = dict["collider"]
		if Input.is_action_just_pressed("Click") and collider.has_method("click_press"):
			collider.click_press()
		elif Input.is_action_just_released("Click")  and collider.has_method("click_release"):
			collider.click_release()
		
		if collider.has_method("get_tooltip"):
			var tooltip_data: TooltipData = collider.get_tooltip()
			if (tooltip_data == null): continue
			show_tooltip = true
			texture_rect.texture = tooltip_data.icon
			name_label.text = tooltip_data.name
			description_label.text = tooltip_data.description
			break
	tooltip.visible = show_tooltip
