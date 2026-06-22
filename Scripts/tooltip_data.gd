class_name TooltipData

var icon: Texture
var name: String
var background_color: Color
var description: String

func _init(p_icon: Texture, p_background_color: Color, p_name: String, p_description: String):
	icon = p_icon
	name = p_name
	background_color = p_background_color
	description = p_description
