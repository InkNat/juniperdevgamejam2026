class_name ItemData extends Resource

static var item_scene: PackedScene = load("res://Scenes/item.tscn")

@export var base_cost: int
@export var icon: Texture2D
@export var name: String
@export var description: String

func _init(p_base_cost = 0, p_name = "", p_decription = ""):
	base_cost = p_base_cost
	name = p_name
	description = p_decription

func create_item() -> Item:
	var item = item_scene.instantiate()
	item.sprite.texture = icon
	item.item_data = self
	return item
