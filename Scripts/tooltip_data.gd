class_name TooltipData

var icon: Texture
var name: String
var background_color: Color
var description: String
var priority: int
var hue_shift: float

func _init(p_icon: Texture, p_background_color: Color, p_name: String, p_description: String, p_priority: int = 0, p_hue_shift: float = 0):
	icon = p_icon
	name = p_name
	background_color = p_background_color
	description = p_description
	priority = p_priority
	hue_shift = p_hue_shift
