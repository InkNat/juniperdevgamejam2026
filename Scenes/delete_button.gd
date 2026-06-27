extends "res://Scripts/Cogworld/area_button.gd"


@export var sprite: Sprite2D

var click_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	clicked.connect(func(): click_time = 0.1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	click_time-=delta
	sprite.visible = click_time > 0
