extends CanvasLayer
class_name TitleScreen

var start: Button
var btnLevelSelect: Button
var lblBottomLeft: Label

signal startPressed
signal settingsPressed
signal levelSelectPressed(type: LevelSelect.Type)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start = $"Control/Buttons/VBoxContainer/Start Button"
	start.pressed.connect(_start_pressed)
	var settings: Button = $"Control/Buttons/VBoxContainer/Settings Button"
	settings.pressed.connect(_settings_pressed)
	
	btnLevelSelect = $"Control/Buttons/VBoxContainer/Level Select Button"
	btnLevelSelect.pressed.connect(_level_select_pressed)
	
	lblBottomLeft = $Control/lblBottomLeft

func _start_pressed():
	startPressed.emit()
func _settings_pressed():
	settingsPressed.emit()
func _level_select_pressed():
	levelSelectPressed.emit(LevelSelect.Type.FromTitle)

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
