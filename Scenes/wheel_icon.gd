class_name WheelIcon extends Node2D

@export var wheel: Sprite2D
var scale_target: Node2D
@export var area: Area2D

var _wheel_data

var hovering = false

func _ready():
	scale_target = get_child(0)
	area.mouse_entered.connect(hover_enter)
	area.mouse_exited.connect(hover_exit)

# Called when the node enters the scene tree for the first time.
func setup(wheel_data: WheelData):
	_wheel_data = wheel_data
	var tiles = wheel_data.tiles
	var tiles_len = len(tiles)
	var image: Image = Image.create_empty(ceil(tiles_len/128.0)*128,1,false,Image.FORMAT_RGBA8)
	for i in range(tiles_len):
		image.set_pixel(i,0, tiles[i].color)
	image.decompress()
	var texture: ImageTexture = ImageTexture.create_from_image(image)
	wheel.material.set_shader_parameter("color_sampler", texture)
	wheel.material.set_shader_parameter("separator_count", float(tiles_len))

func _input(event):
	if (hovering and event.is_action_pressed("Click")):
		Game.instance.clear_wheels()
		Cogworld.instance.set_wheel_to_place(_wheel_data)
		StoreShop.instance.phase_out_wheel_slots()
		Game.instance.shop_tabs.close_all()
		get_viewport().set_input_as_handled()

func hover_enter():
	if StoreShop.instance.ss != null and StoreShop.instance.ss.extended: return
	hovering = true
	z_index = 2
	var tween = get_tree().create_tween()
	tween.tween_property(scale_target, "scale", Vector2(3,3), 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)

func hover_exit():
	hovering = false
	z_index = 0
	var tween = get_tree().create_tween()
	tween.tween_property(scale_target, "scale", Vector2(1,1), 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
