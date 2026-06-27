extends Node2D

@onready var music_slider : Slider = $Control/MusicSlider
@onready var sounds_slider = $Control/SoundsSlider
@onready var restart_button = $Control/RestartButton
@onready var snap_button = $Control/SnapButton
@onready var quit_button = $Control/QuitButton

# Called when the node enters the scene tree for the first time.
func _ready():
	music_slider.value = AudioServer.get_bus_volume_db(1)
	sounds_slider.value = AudioServer.get_bus_volume_db(2)
	snap_button.pressed.connect(func():
		Game.instance.camera.position = Vector2.ZERO
		)
	quit_button.pressed.connect(func(): Main.instance.switch_scene("main_menu"))
	restart_button.pressed.connect(func(): Main.instance.switch_scene("game"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if music_slider.value == music_slider.min_value:
		AudioServer.set_bus_volume_db(1,-1000)
	else:
		AudioServer.set_bus_volume_db(1, music_slider.value)
		
	if sounds_slider.value == sounds_slider.min_value:
		AudioServer.set_bus_volume_db(2,-1000)
	else:
		AudioServer.set_bus_volume_db(2, sounds_slider.value)
