extends Level

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	HAS_INTRO = true
	HAS_GUN = false
	
	pass # Replace with function body.

func _loaded():
	super._loaded()
	G.inGameUI.show_ui()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	pass

func _player_spawning_animation_finished():
	super._player_spawning_animation_finished()
	
	var queue: Array[Textbox.MsgInfo] = [
		Textbox.MsgInfo.new(G.agentName, "Odd, the timer should be longer for longer stages like this one", Textbox.Mode.PerChar),
		Textbox.MsgInfo.new(G.agentName, "I'm gonna look into that!", Textbox.Mode.PerChar),
	]
	G.send_queue_to_message_box(queue)

func _player_spawning_loading_finished():
	super._player_spawning_loading_finished()


func _message_box_finished():
	super._message_box_finished()
	_start_level_input()
