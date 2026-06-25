class_name GroceryCard extends Slot

@export var _name_label: Label
@export var _price_label: Label
@export var item_attach: Node2D
@export var bar_code: Sprite2D
@export var background: Sprite2D
var _sold_item: ItemData
var cost: int
var index

signal clicked(item_data)

func _ready():
	bar_code.material.set_shader_parameter("seed",float(index+1))

func set_sold_item(item: ItemData):
	_name_label.text = item.name
	cost = item.base_cost
	_price_label.text = str(cost) + "$"
	_sold_item = item
	background.modulate = item.background_color
	_price_label.modulate = item.background_color
	refresh_item()

func refresh_item():
	var item: Item = _sold_item.create_item()
	add_child(item)
	item.position = item_attach.position
	item.attachement = item_attach.position

func _can_insert(_item: Item) -> bool: return false
func _insert(_item: Item): pass

func can_retrieve(_item: Item) -> bool:
	return Game.instance.cash_money >= cost

func _retrieve(_item: Item):
	Game.instance.cash_money -= cost
	refresh_item()
