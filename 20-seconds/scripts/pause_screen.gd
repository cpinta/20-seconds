extends CanvasLayer
class_name PauseScreen

var btnResume: Button
var btnLevelSelect: Button

signal levelSelectPressed(type:LevelSelect.Type)
signal mainMenuPressed()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	btnResume = $Control/Buttons/VBoxContainer/Resume
	btnLevelSelect = $Control/Buttons/VBoxContainer/LevelSelect
	btnLevelSelect.pressed.connect(_level_select_pressed)


func _level_select_pressed():
	levelSelectPressed.emit(LevelSelect.Type.FromPause)
func _main_menu_pressed():
	mainMenuPressed.emit()
