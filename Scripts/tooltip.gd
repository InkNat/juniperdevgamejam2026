class_name Tooltip extends PanelContainer

@onready var background_rect : TextureRect = $HSplitContainer/Icon/Background
@onready var texture_rect : TextureRect = $HSplitContainer/Icon
@onready var name_label : Label = $HSplitContainer/MarginContainer/VBoxContainer/Name
@onready var description_label : RichTextLabel = $HSplitContainer/MarginContainer/VBoxContainer/Description

func set_tooltip(tooltip_data: TooltipData):
	if (tooltip_data.icon == null):
		texture_rect.texture = load("res://Sprites/UI/item_icon_background.png")
		texture_rect.self_modulate = Color(0)
	else:
		texture_rect.texture = tooltip_data.icon
		texture_rect.self_modulate = Color(1,1,1,1)
	name_label.text = tooltip_data.name
	background_rect.self_modulate = tooltip_data.background_color
	description_label.text = tooltip_data.description
	size = Vector2(0,0)

func _input(event):
	if (event is InputEventMouseButton):
		if event.is_action_pressed("ZoomIn"):
			Game.instance._camera_zoom += 0.1
		if event.is_action_pressed("ZoomOut"):
			Game.instance._camera_zoom -= 0.1
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("PanCamera"):
			Game.instance.camera.position-=event.relative/(Game.instance._camera_zoom*2)
