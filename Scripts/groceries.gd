extends Node2D

@export var item_list: Array[ItemData]
@export var grocery_card: PackedScene
@export var offscreen_x: float
@export var maximum: int
@export var scroll_audio: AudioStream

var scroll_offset: int = 0

var _shop_open: bool = false

func _ready():
	for i in range(min(len(item_list),maximum)):
		create_grocery_card(i, i)
	open_shop()

func create_grocery_card(index: int, positional_index) -> Node:
	var sold_item = item_list[index]
	var gc = grocery_card.instantiate()
	gc.set_sold_item(sold_item)
	gc.index = index
	gc.position.x = offscreen_x
	gc.position.y = positional_index * 20
	add_child(gc)
	return gc

func update_cards():
	var indices = range(maximum)
	for child in get_children():
		if (child.index == -1): continue
		var index = child.index-scroll_offset
		if (index < 0 or index >= maximum):
			child.index = -1
			tween_out(child)
			continue
		else:
			indices.erase(index)
		tween_to(child, Vector2(0,index*20))
	for index in indices:
		tween_in(create_grocery_card(index+scroll_offset, index))

func scroll_up():
	if (scroll_offset == len(item_list)-maximum): return
	scroll_offset+=1
	update_cards()
	Game.play_and_die(scroll_audio, (2+randf())/3)

func scroll_down():
	if (scroll_offset == 0): return
	scroll_offset-=1
	update_cards()
	Game.play_and_die(scroll_audio, (1.5+randf())/3)

func open_shop():
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
	_shop_open = true

func tween_to(child, to: Vector2):
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(child, "position",to,0.2)

func tween_in(child):
	var resulting_position = Vector2(0,child.position.y)
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(child, "position",resulting_position,0.2)

func tween_out(child: Node):
	var resulting_position = Vector2(offscreen_x,child.position.y)
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(child, "position",resulting_position,0.2)
	tween.tween_callback(child.queue_free)

func close_smooth():
	close_shop()

func close_shop():
	var i = 0
	for child in get_children():
		if child is not GroceryCard: continue
		var resulting_position = Vector2(offscreen_x,child.position.y)
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_QUINT)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_interval(0.01 * i)
		tween.tween_property(child, "position",resulting_position,0.3)
		i+=1
	_shop_open = false
	var tween = get_tree().create_tween()
	tween.tween_interval(1)
	tween.tween_callback(queue_free)

func _input(event):
	if (event is InputEventMouseButton):
		if event.is_action_pressed("ZoomIn"):
			scroll_down()
		if event.is_action_pressed("ZoomOut"):
			scroll_up()
