extends Slot

var maximum_capacity = 3
var _item_count = 0

signal spin
signal place_first_item

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_tags() -> Array[String]:
	var result: Array[String] = []
	for child in get_children():
		if child is not Item: continue
		result.append(child.item_data.tag)
	return result

func arrange_items():
	var i = 0
	for child in get_children():
		if child is not Item: continue
		var index = i-((_item_count-1)/2.0)
		child.attachement = Vector2(index*16,0);
		i+=1

func consume_and_spin():
	if _item_count == 0: return
	for child in get_children():
		if child is not Item: continue
		var item : Item = child
		item.queue_free()
	_item_count = 0
	spin.emit()

func _can_insert(_item: Item) -> bool:
	return _item_count < maximum_capacity

func _insert(item: Item):
	item.reparent(self, true)
	if (_item_count == 0): place_first_item.emit()
	_item_count+=1
	arrange_items()

func can_retrieve(_item: Item) -> bool:
	return false

func _retrieve(_item: Item):
	pass
