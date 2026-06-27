class_name MiniJuicer extends Node2D

static var juicer: PackedScene = load("res://Scenes/mini_juicer.gd")

static func juice(pos: Vector2) -> MiniJuicer:
	var e = juicer.instantiate()
	e.position = pos
	e.player()
	return e

@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var ring: Sprite2D = $Ring
@onready var label: Label = $Label
@export var sounds: Array[AudioStream]
var ring_time: float = 1

func play():
	for sound in sounds:
		Game.instance.play_and_die(sound)
	particles.emitting = true

func _process(delta):
	ring.material.set_shader_parameter("time", ring_time)
