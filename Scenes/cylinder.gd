extends CollisionPolygon3D


# Called when the node enters the scene tree for the first time.
func _init():
	for i in range(32):
		var j = i/16.0
		polygon.append(Vector2(cos(j), sin(j)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
