class_name Level
extends Node2D

var tiles: TilesPlatform
@export var color: Color
var start: Node2D

# Called when the node enters the scene tree for the first time.
func _init():
	pass

func _ready():
	tiles = $platform
	start = $start
	set_level_color(color)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func loaded():
	pass

func set_level_color(color: Color):
	tiles.set_color(color)
	pass
