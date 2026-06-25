class_name Tooltip extends PanelContainer

@onready var background_rect : TextureRect = $HSplitContainer/Background
@onready var texture_rect : TextureRect = $HSplitContainer/Background/Icon
@onready var name_label : Label = $HSplitContainer/MarginContainer/VBoxContainer/Name
@onready var description_label : RichTextLabel = $HSplitContainer/MarginContainer/VBoxContainer/Description

func set_tooltip(tooltip_data: TooltipData):
	size = Vector2(0,0)
	texture_rect.texture = tooltip_data.icon
	name_label.text = tooltip_data.name
	background_rect.self_modulate = tooltip_data.background_color
	description_label.text = tooltip_data.description

func _input(event):
	if (event is InputEventMouseButton):
		if event.is_action_pressed("ZoomIn"):
			Game.instance._camera_zoom += 0.1
		if event.is_action_pressed("ZoomOut"):
			Game.instance._camera_zoom -= 0.1
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("PanCamera"):
			Game.instance.camera.position-=event.relative/(Game.instance._camera_zoom*2)
