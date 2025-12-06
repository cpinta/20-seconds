extends Level

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	HAS_INTRO = true
	HAS_GUN = true
	
	pass # Replace with function body.

func _loaded():
	super._loaded()
	G.inGameUI.show_ui()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	if G.player:
		if G.player.state != Player.State.DYING:
			if abs(G.player.global_position.x) > 4000 or abs(G.player.global_position.y) > 1000:
				G.player.die()
	pass

var msgwave: int = 0
func _player_spawning_animation_finished():
	super._player_spawning_animation_finished()
	
	if not HAS_INTRO:
		return

	var queue: Array[Textbox.MsgInfo] = [
		Textbox.MsgInfo.new(G.agentName, "Gah! That jump looks impossible!", Textbox.Mode.PerChar, 0, TextboxPortrait.Emotion.Surprised),
		Textbox.MsgInfo.new(G.agentName, "OKAY OKAY... Why don't you try aiming down while in the air and using your charge shot!", Textbox.Mode.PerChar),
		Textbox.MsgInfo.new(G.agentName, "That should propel you to that platform!", Textbox.Mode.PerChar),
		Textbox.MsgInfo.new(G.agentName, "... should...", Textbox.Mode.PerCharContinuing),
	]
		

	G.send_queue_to_message_box(queue)

func _player_spawning_loading_finished():
	super._player_spawning_loading_finished()


func _message_box_finished():
	super._message_box_finished()
	_start_level_input()

		
