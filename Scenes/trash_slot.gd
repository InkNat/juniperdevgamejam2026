extends Slot

var item: Item
@export var item_attach: Node2D

func delete():
	if (item == null): return
	item.queue_free()
	item = null

func _can_insert(_item: Item) -> bool: return item == null
func _insert(p_item: Item):
	print("e")
	item = p_item
	item.reparent(self, true)
	item.attachement = item_attach.position
func can_retrieve(_item: Item) -> bool: return true
func _retrieve(_item: Item): item = null
