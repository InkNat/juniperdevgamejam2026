extends Node

@export var grocery_tab: ShopTab
@export var store_tab: ShopTab
@export var settings_tab: ShopTab

# Called when the node enters the scene tree for the first time.
func _ready():
	close_all()

func _input(event):
	if (grocery_tab.is_open or store_tab.is_open or settings_tab.is_open):
		get_viewport().set_input_as_handled()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func groceries():
	if (grocery_tab.is_open): 
		close_all()
		return
	settings_tab.open_empty()
	store_tab.open_empty()
	grocery_tab.open()

func store():
	if (store_tab.is_open): 
		close_all()
		return
	settings_tab.open_empty()
	store_tab.open()
	grocery_tab.close()

func settings():
	if (settings_tab.is_open): 
		close_all()
		return
	settings_tab.open()
	store_tab.close()
	grocery_tab.close()

func close_all():
	settings_tab.close()
	store_tab.close()
	grocery_tab.close()
