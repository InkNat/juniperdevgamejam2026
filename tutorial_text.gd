class_name TutorialText extends Resource

@export var title: String
@export var time: float = 0
@export_multiline var text: String

func _init(p_title: String = "", p_time: float = 0, p_text: String = ""): 
	title = p_title
	time = p_time
	text = p_text
