class_name StickerData extends Resource

static var sticker_scene = load("res://Scenes/Stickers/sticker.tscn")

@export var texture: Texture = null
@export var size: Vector2i = Vector2(1,1)
@export var wheel_sticker: bool = false
@export var name: String = ""
@export var exhausts: bool = false
@export_multiline var description: String = ""

func _init(p_texture: Texture = null, p_size: Vector2i = Vector2(1,1), p_wheel_sticker: bool = false, p_name: String = "", p_exhausts = false, p_description: String = ""):
	texture = p_texture
	size = p_size
	wheel_sticker = p_wheel_sticker
	name = p_name
	exhausts = p_exhausts
	description = p_description

func get_tag() -> String:
	return name.to_snake_case()

func create() -> Sticker:
	var e = sticker_scene.instantiate()
	e.setup_data(self)
	return e
