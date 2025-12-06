class_name SlantLevel
extends Level

func _ready():
	super._ready()
	HAS_INTRO = false

func _process(delta):
	super._process(delta)
	if G.player:
		if G.player.state != Player.State.DYING:
			if abs(G.player.global_position.x) > 4000 or abs(G.player.global_position.y) > 1000:
				G.player.die()
	pass

func _player_spawning_animation_finished():
	super._player_spawning_animation_finished()

func _player_spawning_loading_finished():
	super._player_spawning_loading_finished()

func _message_box_finished():
	super._message_box_finished()
	_start_level_input()
