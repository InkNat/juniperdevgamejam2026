class_name StickerSheetGenerator

var _registry: Array[StickerData]
var size: Vector2i
var _result: Array[StickerData] = []

func _init(p_size:Vector2i, p_registry: Array[StickerData]):
	_registry = p_registry
	size = p_size
	_result.resize(size.x*size.y)

func vec_to_index(vec: Vector2i) -> int:
	return vec.x + (vec.y * size.x)

func index_to_vec(index: int) -> Vector2i:
	return Vector2(index%size.x, index/size.x)

func empty_space_at(vec: Vector2)->bool:
	for i in len(_result):
		var sticker:StickerData = _result[i]
		if sticker == null: continue
		var pos = index_to_vec(i)
		var rect:Rect2 = Rect2(pos,sticker.size)
		if rect.has_point(vec): return false
	return true

func can_place(rect: Rect2) -> bool:
	if (not Rect2(Vector2.ZERO, size).encloses(rect)): 
		return false
	for i in len(_result):
		var sticker:StickerData = _result[i]
		var vec = index_to_vec(i)
		if sticker == null: continue
		if rect.intersects(Rect2(vec, sticker.size), false): 
			return false
	return true

func try_place_at(i: int):
	var vec = index_to_vec(i)
	if not empty_space_at(vec): 
		return
	var reg_len = len(_registry)
	var random_offset = randi()%reg_len
	for r_index in range(reg_len):
		var sticker:StickerData = _registry[0]
		#var sticker:StickerData = _registry[(r_index+random_offset)%reg_len]
		if not can_place(Rect2(vec, sticker.size)): 
			continue
		_result[i] = sticker
		return
		
func generate_sticker_sheet() -> Array[StickerData]:
	for i in range(len(_result)):
		try_place_at(i)
	return _result
