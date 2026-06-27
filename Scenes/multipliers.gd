class_name Multipliers extends Node2D

static var instance: Multipliers
static var mini_display: PackedScene = load("res://Scenes/mini_display.tscn")

@export var icons: Dictionary[String, Texture]

func _ready():
	instance = self
	for key in icons:
		var value = icons[key]
		var e: MiniDisplay = mini_display.instantiate()
		e.sprite.texture = value
		add_child(e)
		e.name = key

func set_display_text(display: String, text: String):
	for d in get_children():
		if d.name == display:
			d.label.text = text
			d.visible = true
			return
	print("not found")

func reset():
	for d in get_children():
		d.visible = false

func _process(delta):
	var i = 0
	for display in get_children():
		if not display.visible: continue
		display.position.y = i*20
		i+=1
