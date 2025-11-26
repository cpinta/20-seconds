class_name TestLevel2
extends Level


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	HAS_INTRO = true
	#Game.speak_for_time("RULE 1: Make a good tutorial", 9999, 0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	pass

func _player_spawning_animation_finished():
	super._player_spawning_animation_finished()
	var testQueue: Array[Textbox.MsgInfo] = [
		Textbox.MsgInfo.new("AGENT", "erm what the frick", Textbox.Mode.PerChar),
		Textbox.MsgInfo.new("AGENT", "yeah um... that was awkward", Textbox.Mode.PerChar),
		Textbox.MsgInfo.new("AGENT", "FRICK", Textbox.Mode.Instant)
	]
	G.send_queue_to_message_box(testQueue)

func _player_spawning_loading_finished():
	super._player_spawning_loading_finished()
	pass

func _message_box_finished():
	super._message_box_finished()
	_start_level_input()
