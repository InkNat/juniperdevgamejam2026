class_name Shop extends Node

static var instance: Shop

enum Tabs {
	None,
	Groceries,
	Store,
	Settings
}

@export var grocery_tab: ShopTab
@export var store_tab: ShopTab
@export var settings_tab: ShopTab

var locked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	instance = self
	settings_tab.close()

#func _input(event):
	#if (grocery_tab.is_open or store_tab.is_open or settings_tab.is_open):
	#	get_viewport().set_input_as_handled()

func by_tab(tab: Tabs):
	match tab:
		Tabs.Groceries: groceries()
		Tabs.Store: store()
		Tabs.Settings: settings()

func unlock_groceries():
	grocery_tab.unlock()
	
func unlock_store():
	store_tab.unlock()

func currently_open() -> Tabs:
	if grocery_tab.is_open: return Tabs.Groceries
	elif store_tab.is_open: return Tabs.Store
	elif settings_tab.is_open: return Tabs.Settings
	else: return Tabs.None

# Called every frame. 'delta' is the elapsed time since the previous frame.
func groceries():
	if locked: return
	if (grocery_tab.is_open): 
		close_all()
		return
	settings_tab.open_empty()
	store_tab.open_empty()
	grocery_tab.open()

func store():
	if locked: return
	if (store_tab.is_open): 
		close_all()
		return
	settings_tab.open_empty()
	store_tab.open()
	grocery_tab.close()

func settings():
	if locked: return
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
