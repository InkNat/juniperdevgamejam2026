@abstract class_name Slot extends Node2D

func _get_current_item() -> Item:
	for child in get_children():
		if child is Item: return child
	return null

@abstract func _insert(item: Item) -> bool
@abstract func can_retrieve(item: Item) -> bool
@abstract func retrieve(item: Item)

func insert_item(item: Item):
	var slot_parent = item.get_parent()
	if slot_parent is not Slot: return
	if not slot_parent.can_retrieve(item): return
	slot_parent.retrieve(item)
	_insert(item)
