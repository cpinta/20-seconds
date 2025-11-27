extends CanvasLayer
class_name PauseScreen

var btnResume: Button
var btnLevelSelect: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	btnResume = $Control/Buttons/VBoxContainer/Resume
	btnLevelSelect = $Control/Buttons/VBoxContainer/LevelSelect
