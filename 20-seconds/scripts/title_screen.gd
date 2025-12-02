extends CanvasLayer
class_name TitleScreen

var start: Button
var lblBottomLeft: Label

signal startPressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start = $"Control/Buttons/VBoxContainer/Start Button"
	start.pressed.connect(_start_pressed)
	
	lblBottomLeft = $Control/lblBottomLeft
	pass # Replace with function body.


func _start_pressed():
	startPressed.emit()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
