class_name Tile extends Resource

@export var color: Color
@export var base_reward: int
@export_range(-180,180) var hue_shift : float = 0
@export var name: String

func _init(p_color: Color = Color.WHITE, p_reward: int = 0, p_hue_shift = 0, p_name: String = ""):
	color = p_color
	base_reward = p_reward
	hue_shift = p_hue_shift
	name = p_name
