extends Node

@export var icon: Texture
@export var tooltip_name: String
@export_multiline var description: String

func get_tooltip() -> TooltipData:
	return TooltipData.new(icon, tooltip_name, description)
