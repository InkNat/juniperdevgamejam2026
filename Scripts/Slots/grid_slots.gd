class_name GridSlots extends Slot

@export var _grid_size_x : int
@export var _grid_size_y : int
@export var _cell_size : int

var contents = []

func _ready():
	for i in range(_grid_size_x*_grid_size_y):
		contents.append(null)

func get_index_from_vec(vec: Vector2) -> int:
	return floor((_grid_size_x * vec.y) + vec.x)

func get_vec_from_index(index: int) -> Vector2:
	return Vector2(index%_grid_size_x, index/_grid_size_x)

func _can_insert(item: Item) -> bool:
	var cell_position = floor((item.global_position-self.global_position)/_cell_size)
	cell_position = Vector2(clamp(cell_position.x, 0, _grid_size_x-1), clamp(cell_position.y, 0, _grid_size_y-1))
	
	var index = get_index_from_vec(cell_position)
	return contents[index] == null

func _insert(item: Item):
	var cell_position = floor((item.global_position-self.global_position)/_cell_size)
	cell_position = Vector2(clamp(cell_position.x, 0, _grid_size_x-1), clamp(cell_position.y, 0, _grid_size_y-1))
	
	var index = get_index_from_vec(cell_position)
	contents[index] = item
	
	cell_position *= _cell_size
	cell_position += Vector2(_cell_size/2.0,_cell_size/2.0)
	
	item.attachement = cell_position
	item.reparent(self, true)
	return true

func is_full() -> bool:
	for e in contents:
		if e == null:
			return false
	return true

func add_item(item: Item) -> bool:
	for i in range(len(contents)):
		if (contents[i] == null):
			contents[i] = item
			item.attachement = (get_vec_from_index(i)*_cell_size)+ Vector2(_cell_size/2.0,_cell_size/2.0)
			item.position = item.attachement
			add_child(item)
			return true
	return false

func can_retrieve(_item: Item) -> bool:
	return true

func _retrieve(item: Item):
	var index = contents.find(item)
	if (index == -1): return
	contents[index] = null
