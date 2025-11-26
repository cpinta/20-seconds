extends Button
class_name LevelButton

var lblTime: Label
var levelIndex: int = -1 

signal sbtn_pressed(index: int)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lblTime = $Time
	lblTime.text = ""
	pass # Replace with function body.

func initialize(index: int, time: float):
	text = str(index)
	levelIndex = index
	if time != 20:
		lblTime.text = str(time)
	pass

func btn_pressed():
	sbtn_pressed.emit(levelIndex)
	pass
