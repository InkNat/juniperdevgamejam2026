class_name StoreShop extends Node2D

static var instance: StoreShop

@export var sticker_sheet: PackedScene

@onready var wheel_slots_container: Node2D = $WheelSlots

@export var wheel_icons: Array[PackedScene]

@export var wheel_slots : Array[Node]

var ss

# Called when the node enters the scene tree for the first time.
func _ready():
	instance = self
	var sold_wheels = Game.instance.get_sold_wheels()
	var vis = false
	if sold_wheels is Array[WheelData]:
		setup_wheels(sold_wheels)
		vis = true
	for e in wheel_slots:
		e.visible = vis
	
	if (not Game.instance.popped_sticker_sheet):
		ss = sticker_sheet.instantiate()
		ss.setup(Game.instance.generated_sticker_sheet, 10000 * Game.instance.global_cost_multiplier)
		add_child(ss)

func setup_wheels(wheels: Array[WheelData]):
	for i in range(min(len(wheel_slots),len(wheels))):
		var wheel_data = wheels[i]
		var e:WheelIcon = wheel_icons[wheel_data.wheel_size].instantiate()
		e.setup(wheel_data)
		wheel_slots[i].add_child(e)
	phase_in_wheel_slots()

func phase_in_wheel_slots():
	var tween = get_tree().create_tween()
	tween.tween_property(wheel_slots_container, "position", Vector2(0,0), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)

func phase_out_wheel_slots():
	var tween = get_tree().create_tween()
	tween.tween_property(wheel_slots_container, "position", Vector2(0,50), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	
func close_smooth():
	get_tree().create_timer(1).timeout.connect(queue_free)
