class_name ItemData extends Resource

static var item_scene: PackedScene = load("res://Scenes/item.tscn")

@export var base_cost: int
@export var icon: Texture2D
@export var name: String
@export var tag: String
@export_multiline var description: String
@export var background_color: Color

func _init(p_base_cost = 0, p_icon = null, p_name = "", p_tag = "", p_decription = "", p_background_color = Color.WHITE):
	base_cost = p_base_cost
	name = p_name
	tag = p_tag
	description = p_decription
	background_color = p_background_color
	icon = p_icon

func create_item() -> Item:
	var item = item_scene.instantiate()
	item.sprite.texture = icon
	item.item_data = self
	return item
