class_name Game extends Node2D

static var instance: Game
@export var tooltip : Tooltip
@export var camera: Camera2D
@export var hamster_slot: Node2D
@export var main_wheel: Node2D
@export var spin_button: Node2D
@export var money_label: Label
@export var audio_player: PackedScene
@export var shop_tabs: Node2D
@export var test_sticker: PackedScene
var _camera_zoom: float = 1.0
var cash_money: int = 2000

var current_sticker: Sticker

# Called when the node enters the scene tree for the first time.
func _init():
	instance = self

func _ready():
	hamster_slot.place_first_item.connect(spin_button.open_sign)
	spin_button.sign_clicked.connect(hamster_slot.consume_and_spin)
	hamster_slot.spin.connect(func (): 
		main_wheel.spin(hamster_slot.get_tags()))

static func play_and_die(audio: AudioStream, pitch: float = 1, volume = 1): instance._play_and_die(audio, pitch, volume)

func _play_and_die(audio: AudioStream, pitch: float = 1, volume = 1):
	var e: AudioStreamPlayer = audio_player.instantiate()
	e.stream = audio
	e.pitch_scale = pitch
	e.volume_linear = volume
	add_child(e)

func pop_sticker() -> Sticker:
	var result = current_sticker
	current_sticker = null
	return result

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	money_label.text = str(cash_money) + "$"
	var space = get_world_2d().direct_space_state
	var mouse_pos = get_global_mouse_position()
	
	_camera_zoom = clamp(_camera_zoom,0.3,1)
	camera.zoom = lerp(camera.zoom,Vector2(_camera_zoom*2,_camera_zoom*2),delta*20)
	
	if (Input.is_action_just_pressed("Small") and current_sticker == null):
		current_sticker = test_sticker.instantiate()
		add_child(current_sticker)
	
	if (current_sticker != null):
		current_sticker.position = mouse_pos
	
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
	var viewport_size:Rect2 = get_viewport_rect()
	
	tooltip.update_minimum_size()
	tooltip.global_position = Vector2(
		clamp(mouse_pos.x,0,viewport_size.size.x-tooltip.size.x),
		clamp(mouse_pos.y,0,viewport_size.size.y-tooltip.size.y)
	) 
	tooltip.visible = show_tooltip
