class_name TriggerTrace

var _contents: Array[Node] = []

func check(e: Node)->bool:
	if _contents.has(e): return false
	_contents.append(e)
	return true
