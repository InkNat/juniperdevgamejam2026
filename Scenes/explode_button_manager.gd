extends Sprite2D
var _current_tween: Tween

func open_sign():
	if (_current_tween != null): _current_tween.kill()
	rotation_degrees = -90
	_current_tween = get_tree().create_tween()
	_current_tween.set_trans(Tween.TRANS_ELASTIC)
	_current_tween.set_ease(Tween.EASE_OUT)
	_current_tween.tween_property(self, "rotation_degrees",0,4)
func close_sign():
	if (_current_tween != null): _current_tween.kill()
	_current_tween = get_tree().create_tween()
	_current_tween.set_trans(Tween.TRANS_BACK)
	_current_tween.set_ease(Tween.EASE_IN)
	_current_tween.tween_property(self, "rotation_degrees",-90,0.3)


func click_press():
	HamsterManager.instance.explode()
	close_sign()
