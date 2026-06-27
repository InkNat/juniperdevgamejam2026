class_name MiniTutorial extends Node2D

static var instance: MiniTutorial

static func show_tutorial(tutorial: String, ordered: bool = true):
	instance._show_tutorial(tutorial, ordered)

@export var tutorial_text: Array[TutorialText]

@onready var label: Label = $Panel/Label

var out = false
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	instance = self
	check_tabs.call_deferred()

func check_tabs():
	var unlock_groceries = true
	var unlock_store = true
	for e: TutorialText in tutorial_text:
		match e.title:
			"grocery_tab":
				unlock_groceries = false
			"store_tab":
				unlock_store = false
	if unlock_groceries: Game.instance.shop_tabs.unlock_groceries()
	if unlock_store: Game.instance.shop_tabs.unlock_store()

func _process(delta):
	if (time > 0):
		time -= delta
		if (time <= 0):
			hide_tutorial()

func _show_tutorial(tutorial: String, ordered: bool):
	check_tabs()
	if len(tutorial_text) == 0: 
		return
	if not tutorial_text[0].title == tutorial and ordered: 
		return
	var index = 0
	for e: TutorialText in tutorial_text:
		if e.title == tutorial: break
		index+=1
	if index >= len(tutorial_text): return
	if not out: pop_in()
	
	
	var e = tutorial_text[index]
	if (e.time != 0):
		time = e.time
	label.text = e.text
	tutorial_text.remove_at(index)

func hide_tutorial():
	pop_out()

func pop_out():
	out = false
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,50), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)

func pop_in():
	out = true
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,0), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
