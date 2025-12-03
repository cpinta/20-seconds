extends CanvasLayer
class_name SettingsScreen

var exit: Button

signal exitPressed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit = $Control/Exit
	exit.pressed.connect(_press_exit)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _press_exit():
	exitPressed.emit()
