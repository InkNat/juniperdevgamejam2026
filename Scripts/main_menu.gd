extends Control

@export var start_button: Button
@export var anim: Node2D
@export var anim2: Node2D
@export var anim3: Node2D
@export var rot_wobbl: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	if not MusicManager.instance.playing: MusicManager.instance.playing = true
	
	var audio_tween = create_tween()
	audio_tween.tween_property(AudioServer.get_bus_effect(1,0), "cutoff_hz", 70, 1)
	
	start_button.pressed.connect(Main.instance.start_game)
	var tween = get_tree().create_tween()
	tween.tween_interval(0.5)
	tween.tween_property(anim, "position", Vector2.ZERO, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(anim2, "position", Vector2.ZERO, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(anim3, "position", Vector2.ZERO, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	
