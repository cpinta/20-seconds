extends CanvasLayer
class_name LevelSelect

enum Type {
	FromPause,
	FromTitle
}

var grid: Control
var levelButtonScene: PackedScene = preload("res://scenes/level_button.tscn")
var type: Type

var messageQueue: Array[Textbox.MsgInfo] = []


signal level_selected(index: int)
signal exitPressed()

func _ready() -> void:
	grid = $Control/Buttons/Grid
	$Control/Exit.pressed.connect(_exit_pressed)

func initialize(gameInfo: Save.GameInfo, type: Type):
	self.type = type
	for i in range(0, gameInfo.lastLevelBeat):
		if not gameInfo.levelInfos[i].selectable:
			if gameInfo.lastLevelBeat > 0:
				continue
		var btn: LevelButton = await G.spawn(levelButtonScene)
		btn.initialize(i, gameInfo.levelInfos[i].bestTime)
		btn.sbtn_pressed.connect(_level_selected)
		btn.reparent(grid)

func _level_selected(index: int):
	level_selected.emit(index)

func _exit_pressed():
	exitPressed.emit()
