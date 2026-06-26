extends Sprite2D

@export var sticker_area: Area2D
@export var label: Label

var price
var extended = false
var state = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	retract()
	sticker_area.mouse_entered.connect(func():
		if state == 1: return
		extended = true
		extend())
	sticker_area.mouse_exited.connect(func(): 
		if state != 0: return
		extended = false
		retract())

func setup(sticker_sheet: Array[StickerData], p_price: int):
	price = p_price
	label.text = str(p_price) + "$"
	var i = 0
	for sticker_data in sticker_sheet:
		if sticker_data == null: 
			i+=1
			continue
		var sticker:Sprite2D = sticker_data.create()
		sticker.position = Vector2(index_to_vec(i))+Vector2((sticker.texture.get_size().x/2.0),(sticker.texture.get_size().y/2.0) + 11)
		sticker.name = str(i)
		add_child(sticker)
		i+=1

func index_to_vec(index: int) -> Vector2i:
	var sizex = 4
	return Vector2(index%sizex, index/sizex)*16
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (state == 3): return
	if (Input.is_action_just_pressed("Click") and extended and state == 0):
		buy.call_deferred()
	if get_child_count() <= 2:
		discard()

func buy():
	if Game.instance.cash_money < price: return
	Game.instance.cash_money -= price
	Game.instance.kill_previous_sheet()
	Game.instance.popped_sticker_sheet = true
	Game.instance.shop_tabs.close_all()
	for sticker in get_children():
		if sticker is not Sticker: continue
		sticker.locked = false
	var tween = get_tree().create_tween()
	state = 1
	tween.tween_property(self, "position", Vector2(3,-120), 0.7).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): 
		Game.instance.setup_sticker_sheet(self)
		state = 2
		)
	tween.tween_property(self, "position", Vector2(0, -40), 0.7).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func extend():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)
	var result
	if (state == 0):
		result = Vector2(3,-13)
	else:
		result = Vector2(0,-107)
	tween.tween_property(self, "position", result, 0.7)

func retract():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	var result
	if (state == 0):
		result = Vector2(3,-107)
	else:
		result = Vector2(0,-40)
	tween.tween_property(self, "position", result, 0.7)

func discard():
	state = 3
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position", Vector2(0,0), 0.6)
	tween.tween_callback(queue_free)
