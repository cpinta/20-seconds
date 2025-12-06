class_name TestLevel
extends Level


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	HAS_INTRO = false
	
	pass # Replace with function body.

func _loaded():
	super._loaded()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	pass

func _player_spawning_animation_finished():
	super._player_spawning_animation_finished()
	
	if not HAS_INTRO:
		return

func _player_spawning_loading_finished():
	super._player_spawning_loading_finished()


func _message_box_finished():
	super._message_box_finished()
	levelInputStarted.emit()
	pass
