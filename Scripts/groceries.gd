extends Control

@export var item_list: Array[ItemData]
@export var grocery_card: PackedScene

var _shop_open: bool = false

func _ready():
	var i = 0
	for item_data in item_list:
		var gc = grocery_card.instantiate()
		gc.set_sold_item(item_data)
		gc.position.y = i * 20
		add_child(gc)
		i+=1
	
func open_shop():
	var i = 0
	for child in get_children():
		if child is not GroceryCard: continue
		var resulting_position = Vector2(-100,child.position.y)
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_QUINT)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_interval(0.01 * i)
		tween.tween_property(child, "position",resulting_position,0.3)
		i+=1
	_shop_open = true
	
func close_shop():
	var i = 0
	for child in get_children():
		if child is not GroceryCard: continue
		var resulting_position = Vector2(0,child.position.y)
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_QUINT)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_interval(0.01 * i)
		tween.tween_property(child, "position",resulting_position,0.3)
		i+=1
	_shop_open = false
