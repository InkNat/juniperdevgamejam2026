@abstract class_name Slot extends Node2D

signal on_retrieve

func _get_current_item() -> Item:
	for child in get_children():
		if child is Item: return child
	return null

@abstract func _can_insert(item: Item) -> bool
@abstract func _insert(item: Item)
@abstract func can_retrieve(item: Item) -> bool
@abstract func _retrieve(item: Item)

func retrieve(item: Item):
	_retrieve(item)
	on_retrieve.emit()

func insert_item(item: Item):
	var slot_parent = item.get_parent()
	if slot_parent is not Slot: return
	if not _can_insert(item): return
	if not slot_parent.can_retrieve(item): return
	slot_parent.retrieve(item)
	_insert(item)
