extends Slot

@export var _grid_size_x : int
@export var _grid_size_y : int
@export var _cell_size : int

var contents = []

func _ready():
	for i in range(_grid_size_x*_grid_size_y):
		contents.append(null)

func get_index_from_vec(vec: Vector2) -> int:
	return (_grid_size_x * vec.y) + vec.x

func _insert(item: Item) -> bool:
	var cell_position = floor((item.global_position-global_position)/_cell_size)
	cell_position = Vector2(clamp(cell_position.x, 0, _grid_size_x-1), clamp(cell_position.y, 0, _grid_size_y-1))
	
	var index = get_index_from_vec(cell_position)
	if contents[index] != null:
		return false
	contents[index] = item
	
	cell_position *= _cell_size
	cell_position += Vector2(_cell_size/2,_cell_size/2)
	
	item.attachement = cell_position
	item.reparent(self, true)
	return true

func can_retrieve(_item: Item) -> bool:
	return true

func retrieve(item: Item):
	var index = contents.find(item)
	if (index == -1): return
	contents[index] = null
