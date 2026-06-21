class_name Game extends Node2D

static var instance: Game
var cash_money: int = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	instance = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$MoneyLabel.text = str(cash_money) + "$"
