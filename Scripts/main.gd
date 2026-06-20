# The main node will take care of switching scenes and managing persistent data.
class_name Main extends Node

static var instance: Main

@export var scenes: Dictionary[String, PackedScene]
@export var persistent_data: Dictionary[String, Variant]
@export var default_scene: String

var current_scene: Node

const SAVE_FILE_PATH = "user://savegame.save"

func _ready():
	instance = self
	switch_scene(default_scene)
	load_persistent_data()

func start_game():
	switch_scene("game")

func quit_game():
	save_persistent_data()
	get_tree().quit()

func switch_scene(scene_name: String):
	if (current_scene != null):
		current_scene.queue_free()
	var new_scene = scenes[scene_name].instantiate()
	current_scene = new_scene
	add_child(new_scene)

func save_persistent_data():
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	save_file.store_line(JSON.stringify(persistent_data))

func load_persistent_data():
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		print("Save file not found")
		return
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	var json_string = save_file.get_line()
	var json = JSON.new()
	
	var result = json.parse(json_string)
	if not result == OK:
		print("JSON save file parsing error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	persistent_data = json.data
