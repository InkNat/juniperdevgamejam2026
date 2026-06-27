extends Node2D


@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var ring: Sprite2D = $Ring
@onready var label: Label = $Label
@export var sounds: Array[AudioStream]

func play():
	for sound in sounds:
		Game.instance.play_and_die(sound)
	var tween = get_tree().create_tween()
