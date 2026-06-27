extends Control

@export var start_button: Button


# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.pressed.connect(Main.instance.start_game)
