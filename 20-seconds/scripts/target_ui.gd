extends HBoxContainer
class_name TargetUI

var label: Label
var curNum: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label = $Label
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass


func set_count(amount: int):
	curNum = amount
	label.text = "x"+str(amount)
