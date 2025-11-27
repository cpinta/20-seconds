extends CanvasLayer
class_name LevelSelect

var grid: Control
var levelButtonScene: PackedScene = preload("res://scenes/level_button.tscn")

signal level_selected(index: int)

func _ready() -> void:
	grid = $Control/Buttons/Grid

func initialize(gameInfo: SaveInfo.GameInfo):
	for i in range(0, gameInfo.levelInfos.size()):
		if not gameInfo.levelInfos[i].selectable:
			continue
		var btn: LevelButton = await G.spawn(levelButtonScene)
		btn.initialize(i, gameInfo.levelInfos[i].bestTime)
		btn.sbtn_pressed.connect(_level_selected)
		btn.reparent(grid)

func _level_selected(index: int):
	level_selected.emit(index)
