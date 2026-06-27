extends Node2D

@export var tile: Tile

func get_tooltip()->TooltipData:
	MiniTutorial.show_tutorial("grocery_tab")
	if (tile.base_reward > 0):
		return TooltipData.new(null,tile.color,tile.name,"+"+str(tile.base_reward)+"$")
	else:
		return TooltipData.new(null,tile.color,tile.name,str(tile.base_reward)+"$")
