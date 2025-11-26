class_name BaseLevel
extends Level

func _ready():
	super._ready()
	HAS_INTRO = false

func _process(delta):
	super._process(delta)
	pass

func _player_spawning_animation_finished():
	super._player_spawning_animation_finished()

func _player_spawning_loading_finished():
	super._player_spawning_loading_finished()

func _message_box_finished():
	super._message_box_finished()
	_start_level_input()
