class_name MiniJuicer extends Node2D

static var juicer: PackedScene = load("res://Scenes/mini_juicer.tscn")

static func juice(pos: Vector2, sound: AudioStream, text: String = "", color: Color = Color(1,1,1,1), delay: float = 0):
	
	var e = juicer.instantiate()
	Game.instance.add_child(e)
	e.position = pos + Vector2((randf()-0.5)*20,(randf()-0.5)*20)
	e.play(sound, text, color, delay)

@export var particles: CPUParticles2D
@export var ring: Sprite2D
@export var label: Label
var ring_time: float = 0

var frozen = true

func play(sound: AudioStream, text: String = "", color: Color = Color(1,1,1,1), delay: float = 0):
	get_tree().create_timer(delay).timeout.connect(func(): _play(sound, text, color))

func _play(sound: AudioStream, text: String = "", color: Color = Color(1,1,1,1)):
	Game.instance.play_and_die(sound)
	if text != "":
		label.text = text
		var tween = create_tween()
		tween.tween_property(label, "position", Vector2(0,-50),0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		tween.parallel().tween_property(label,"modulate", Color(0), 1)
	particles.emitting = true
	particles.modulate = color
	ring.modulate = color
	label.modulate = color
	frozen = false

func _process(delta):
	if frozen: return
	ring.material.set_shader_parameter("time", ring_time)
	ring_time += delta
	if (ring_time > 1):
		queue_free()
