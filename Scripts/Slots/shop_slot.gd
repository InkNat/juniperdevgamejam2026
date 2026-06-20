extends Slot

@export var cost : int

func _insert(item: Item) -> bool:
	return false
	
func can_retrieve(item: Item) -> bool:
	if Game.instance.cash_money >= cost:
		return true
	return false

func retrieve(item: Item):
	Game.instance.cash_money -= cost
