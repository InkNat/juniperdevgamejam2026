class_name Game extends Node2D

static var instance: Game

@export var sticker_registry: Array[StickerData]
@export var tile_registry: Array[Tile]
@export var apple: ItemData
@export_group("References")
@export var tooltip : Tooltip
@export var camera: Camera2D
@export var hamster_slot: Node2D
@export var main_wheel: Node2D
@export var spin_button: Node2D
@export var explode_button: Node2D
@export var money_label: Label
@export var audio_player: PackedScene
@export var shop_tabs: Node2D
@export var sticker_sheet_slot: Node2D
@export var cheapest_item : ItemData
var _camera_zoom: float = 0.5
var _cash_money: int = 20
var _gained_money: int = 0
var generated_sticker_sheet: Array[StickerData]
var popped_sticker_sheet: bool = false

var global_cost_multiplier: float = 1
var pepper_color = null

var cheese_bonuses: Array[CheeseBonus]

var current_sticker: Sticker
var sold_wheels = null

var tooltip_time = 0;

var previous_tab = Shop.Tabs.None

var flash_time: float = 0

# Called when the node enters the scene tree for the first time.
func _init():
	instance = self

static func gain_money(amount: int):
	instance._cash_money+=amount
	instance._gained_money+=amount
static func spend_money(amount: int) -> bool:
	if instance._cash_money < amount: return false
	instance._cash_money-=amount
	return true
static func get_money() -> int:
	return instance._cash_money

func camera_weight():
	var tween = create_tween()
	camera.offset = Vector2(0,10)
	tween.tween_property(camera, "offset", Vector2.ZERO, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

func _ready():
	var audio_tween = create_tween()
	audio_tween.tween_property(AudioServer.get_bus_effect(1,0), "cutoff_hz", 2000, 1)
	MiniLightController.reset()
	var appl = Game.instance.apple.create_item()
	GridSlots.instance.add_item(appl)
	MiniTutorial.show_tutorial("welcome")
	land_reset(true)
	hamster_slot.place_first_item.connect(spin_button.open_sign)
	spin_button.sign_clicked.connect(hamster_slot.consume_and_spin)
	hamster_slot.spin.connect(func (): 
		main_wheel.spin(hamster_slot.get_tags()))

func random_tile() -> Tile:
	return (tile_registry[randi()%len(tile_registry)]) 
func get_pepper_color():
	if pepper_color == null: pepper_color = random_tile()
	return pepper_color

func get_cheese_bonus() -> float:
	var result: float = 1
	for cb in cheese_bonuses:
		result += cb.bonus
	return result

func can_explode() -> bool:
	return _cash_money < cheapest_item.base_cost*global_cost_multiplier and Inventory.instance.is_empty() and hamster_slot.is_empty()

static func play_and_die(audio: AudioStream, pitch: float = 1, volume = 1): instance._play_and_die(audio, pitch, volume)

func _play_and_die(audio: AudioStream, pitch: float = 1, volume = 1):
	var e: AudioStreamPlayer = audio_player.instantiate()
	e.bus = "Sounds"
	e.stream = audio
	e.pitch_scale = pitch
	e.volume_linear = volume
	add_child(e)

func kill_previous_sheet():
	if (sticker_sheet_slot.get_child_count() > 0):
		var c = sticker_sheet_slot.get_child(0)
		if c != null:
			c.discard()

func setup_sticker_sheet(sheet: Node2D):
	sheet.reparent(sticker_sheet_slot)
	sheet.position = Vector2(0,0)

func spin_reset():
	global_cost_multiplier *= 1.2
	previous_tab = shop_tabs.currently_open()
	shop_tabs.close_all()
	Inventory.instance.close()
	shop_tabs.locked = true
	_gained_money = 0

func clear_wheels():
	sold_wheels = null
func generate_wheels():
	var result: Array[WheelData] = []
	for i in range(3):
		var wheel_size = randi()%3
		var tile_count = ((randi()%8) + 1)*pow(2,wheel_size)
		var tiles: Array[Tile] = []
		tiles.resize(tile_count)
		for j in range(tile_count):
			tiles[j] = random_tile()
		var wheel_data: WheelData = WheelData.new(wheel_size,tiles)
		result.append(wheel_data)
	sold_wheels = result
func get_sold_wheels():
	return sold_wheels

func land_reset(boo: bool = false):
	popped_sticker_sheet = false
	Cogworld.instance.delete_previews()
	generate_wheels()
	pepper_color = random_tile()
	var new_bonuses: Array[CheeseBonus] = []
	for cheese_bonus in cheese_bonuses:
		cheese_bonus.tick()
		if cheese_bonus.is_valid():
			new_bonuses.append(cheese_bonus)
	cheese_bonuses = new_bonuses
	shop_tabs.locked = false
	generated_sticker_sheet = StickerSheetGenerator.new(Vector2(4,6),sticker_registry).generate_sticker_sheet()
	
	Multipliers.instance.reset()
	if not boo: 
		Inventory.instance.open()
		flash_time = 3
		shop_tabs.by_tab(previous_tab)
	

func pop_sticker() -> Sticker:
	var result = current_sticker
	current_sticker.z_index = 0
	current_sticker = null
	return result

func push_sticker(sticker: Sticker):
	current_sticker = sticker
	current_sticker.z_index = 4096
	sticker.reparent(self)
	sticker.position = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseMotion:
		tooltip_time = 0.06

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if not shop_tabs.locked and not explode_button.is_open and can_explode():
		explode_button.open_sign()
		spin_button.close_sign()
		spin_button.locked = true
	
	
	if flash_time > 0:
		flash_time-=delta
		var e = ""
		if _gained_money > 0: e = "+"
		money_label.text = e + str(_gained_money) + "$"
		money_label.modulate = Color.from_hsv(fmod(flash_time,1),0.8,0.8)
	else:
		money_label.text = str(_cash_money) + "$"
		money_label.modulate = Color(1,1,1,1)
	
	
	var space = get_world_2d().direct_space_state
	var mouse_pos = get_global_mouse_position()
	
	_camera_zoom = clamp(_camera_zoom,0.2,1.4)
	camera.zoom = lerp(camera.zoom,Vector2(_camera_zoom*2,_camera_zoom*2),delta*20)
	if (current_sticker != null):
		current_sticker.position = mouse_pos
		if Input.is_action_just_pressed("Click"):
			current_sticker.reset()
			current_sticker = null
	
	var parameters: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new();
	parameters.position = mouse_pos;
	parameters.collide_with_areas = true
	var show_tooltip = false
	var tooltip_data = null
	var result = space.intersect_point(parameters)
	
	tooltip_time-=delta

	if (current_sticker == null): for dict in result:
		var collider: Node = dict["collider"]
		var collider_parent = collider.get_parent()
		if Input.is_action_just_pressed("Click"):
			if collider_parent.has_method("click_press"):
				collider_parent.click_press()
		
		if collider_parent.has_method("get_tooltip"):
			var ttd = collider_parent.get_tooltip()
			if (ttd == null): continue
			if (tooltip_data == null or tooltip_data.priority < ttd.priority):
				tooltip_data = ttd
	
	
	if (tooltip_data != null): 
		tooltip.set_tooltip(tooltip_data)
		show_tooltip = tooltip_time <= 0
	var viewport_size:Rect2 = get_viewport_rect()
	
	tooltip.global_position = Vector2(
		clamp(mouse_pos.x,0,viewport_size.size.x-tooltip.size.x),
		clamp(mouse_pos.y,0,viewport_size.size.y-tooltip.size.y)
	) 
	tooltip.visible = show_tooltip
