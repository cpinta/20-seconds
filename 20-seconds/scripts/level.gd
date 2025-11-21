class_name Level
extends Node2D

var tiles: TilesPlatform
@export var color: Color
var start: Node2D

var targets: Array[Target] = []

signal levelConcluded

# Called when the node enters the scene tree for the first time.
func _init():
	pass

func _ready():
	tiles = $platform
	start = $start
	set_level_color(color)
	var targetCount: int = get_tree().get_node_count_in_group("target")
	if targetCount > 0:
		for i in range(0, targetCount):
			targets.append(get_tree().get_nodes_in_group("target")[i])
			targets.back().wasDestroyed.connect(target_was_destroyed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func loaded():
	pass

func set_level_color(color: Color):
	tiles.set_color(color)
	pass

func target_was_destroyed(target: Target):
	target.wasDestroyed.disconnect(target_was_destroyed)
	targets.erase(target)
	if targets.size() == 0:
		levelConcluded.emit()
		pass
	pass
