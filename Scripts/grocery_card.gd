class_name GroceryCard extends Slot

@export var _name_label: Label
@export var _price_label: Label
@export var item_attach: Node2D
var _sold_item: ItemData
var cost: int

func _ready():
	refresh_item()
	on_retrieve.connect(refresh_item)

func set_sold_item(item: ItemData):
	_name_label.text = item.name
	cost = item.base_cost
	_price_label.text = str(cost)
	_sold_item = item

func refresh_item():
	var item = _sold_item.create_item()
	item.position = item_attach.position
	item.attachement = item_attach.position
	add_child(item)

func _insert(_item: Item):
	pass
func _can_insert(_item: Item) -> bool:
	return false
func can_retrieve(_item: Item) -> bool:
	return Game.instance.cash_money >= cost

func _retrieve(_item: Item):
	Game.instance.cash_money -= cost
