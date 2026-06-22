class_name Game extends Node2D

static var instance: Game
@export var tooltip : Tooltip
@export var camera: Camera2D
@export var hamster_slot: Node2D
@export var main_wheel: Node2D
@export var spin_button: Node2D
@export var money_label: Label
var _camera_zoom: float = 1.0
var cash_money: int = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	instance = self
	hamster_slot.place_first_item.connect(spin_button.open_sign)
	spin_button.sign_clicked.connect(hamster_slot.consume_and_spin)
	hamster_slot.spin.connect(func (): main_wheel.spin(1,0.01))

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("PanCamera"):
			camera.position-=event.relative/(_camera_zoom)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	money_label.text = str(cash_money) + "$"
	var space = get_world_2d().direct_space_state
	var mouse_pos = get_global_mouse_position()
	
	if Input.is_action_just_pressed("ZoomIn"):
		_camera_zoom += 0.1
	if Input.is_action_just_pressed("ZoomOut"):
		_camera_zoom -= 0.1
	_camera_zoom = clamp(_camera_zoom,0.3,2)
	camera.zoom = lerp(camera.zoom,Vector2(_camera_zoom*2,_camera_zoom*2),delta*20)
	
	
	tooltip.global_position = mouse_pos
	var parameters = PhysicsPointQueryParameters2D.new();
	parameters.position = mouse_pos;
	parameters.collide_with_areas = true
	var show_tooltip = false
	var result = space.intersect_point(parameters)
	for dict in result:
		var collider: Node = dict["collider"]
		var collider_parent = collider.get_parent()
		if Input.is_action_just_pressed("Click") and collider_parent.has_method("click_press"):
			collider_parent.click_press()
		
		if collider_parent.has_method("get_tooltip"):
			var tooltip_data: TooltipData = collider_parent.get_tooltip()
			if (tooltip_data == null): continue
			tooltip.set_tooltip(tooltip_data)
			show_tooltip = true
			break
	tooltip.visible = show_tooltip
