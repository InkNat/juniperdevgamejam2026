extends TextureRect

signal clicked

func _gui_input(event):
	if (event is InputEventMouseButton):
		if (event.is_action_pressed("Click")):
			clicked.emit()
