class_name Tile extends Resource

@export var color: Color
@export var base_reward: int

func _init(p_color: Color = Color.WHITE, p_reward: int = 0):
	color = p_color
	base_reward = p_reward
	
