class_name MiniLightController extends Node2D

static var instance: MiniLightController

static var state: LightState = LightState.Idle
static var tile: Tile = null
static var time: float = 2
static func reset():
	state = LightState.Idle
	tile = null
	time  = 2

@export var alternance: int = 2

enum LightState {
	Idle,
	Spinning,
	Winning,
	Dead
}

var frame_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	match state:
		LightState.Spinning:
			frame_count+=0.03
		LightState.Winning:
			frame_count+=0.15
			time-=delta
			if (time < 0):
				state = LightState.Idle
		_:frame_count+=0.01
	
	var i = 0
	for sprite in get_children():
		match state:
			LightState.Spinning:
				sprite.modulate = Color.from_hsv(fmod(frame_count+(i/8.0),alternance),0.9,0.9)
			LightState.Winning:
				if tile == null: return
				if fmod(i+frame_count,alternance) <= 1:
					sprite.modulate = tile.color
				else:
					sprite.modulate = Color(0.03, 0.03, 0.03, 1.0)
			LightState.Dead:
				sprite.modulate = Color(0.03, 0.03, 0.03, 1.0)
			_:
				if fmod(i+frame_count,alternance) <= 1:
					sprite.modulate = Color(1,1,1,1)
				else:
					sprite.modulate = Color(0.03, 0.03, 0.03, 1.0)
		i+=1
