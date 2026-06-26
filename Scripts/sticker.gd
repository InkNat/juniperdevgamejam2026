class_name Sticker extends Sprite2D

var sticker_data: StickerData
var previous_parent
var previous_position

var locked = true

func setup_data(p_sticker_data: StickerData):
	sticker_data = p_sticker_data
	texture = sticker_data.texture
	var area2D = Area2D.new()
	var collisionshape2d = CollisionShape2D.new()
	var rect_shape = RectangleShape2D.new()
	rect_shape.size = sticker_data.size*16
	collisionshape2d.shape = rect_shape
	add_child(area2D)
	area2D.add_child(collisionshape2d)

func click_press():
	if Game.instance.current_sticker != null: return
	if locked: return
	locked = true
	previous_parent = get_parent()
	previous_position = position
	Game.instance.push_sticker(self)

func reset():
	if not is_instance_valid(previous_parent):
		queue_free()
		return
	locked = false
	reparent(previous_parent)
	position = previous_position

func get_tooltip() -> TooltipData:
	return TooltipData.new(texture, Color(0), sticker_data.name, sticker_data.description, 1)
