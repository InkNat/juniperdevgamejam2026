extends Slot

var maximum_capacity = 3
var _item_count = 0
var sign_open

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func arrange_items():
	var i = 0
	for child in get_children():
		if child is not Item: continue
		var index = i-((_item_count-1)/2.0)
		child.attachement = Vector2(index*16,0);
		i+=1

func _can_insert(item: Item) -> bool:
	return _item_count < maximum_capacity

func _insert(item: Item):
	item.reparent(self, true)
	_item_count+=1
	arrange_items()

func can_retrieve(_item: Item) -> bool:
	return false

func _retrieve(_item: Item):
	pass
