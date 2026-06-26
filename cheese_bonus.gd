class_name CheeseBonus

var bonus: float = 1

func tick():
	bonus-=0.25

func is_valid() -> bool:
	return bonus > 0
