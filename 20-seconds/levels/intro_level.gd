class_name IntroLevel
extends Level


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	HAS_INTRO = true
	
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
	
	var testQueue: Array[Textbox.MsgInfo] = [
		Textbox.MsgInfo.new("AGENT", "erm what the frick", Textbox.Mode.PerChar),
		Textbox.MsgInfo.new("AGENT", "yeah um... that was awkward", Textbox.Mode.PerChar),
		Textbox.MsgInfo.new("AGENT", "FRICK", Textbox.Mode.Instant)
	]
	G.send_queue_to_message_box(testQueue)

func _player_spawning_loading_finished():
	super._player_spawning_loading_finished()
	G.player.set_state(Player.State.DISABLE_COMPLETELY)
	G.inGameUI.hide_ui()

	var testQueue: Array[Textbox.MsgInfo] = [
		Textbox.MsgInfo.new("", "WELCOME TO THE FIELD TRAINING SIMULATION", Textbox.Mode.PerChar),
		Textbox.MsgInfo.new("", "LOADING", Textbox.Mode.Instant, 1),
		Textbox.MsgInfo.new("", "LOADING.", Textbox.Mode.Instant, 1),
		Textbox.MsgInfo.new("", "LOADING..", Textbox.Mode.Instant, 1),
		Textbox.MsgInfo.new("", "LOADING...", Textbox.Mode.Instant, 1),
	]
	G.send_queue_to_message_box(testQueue)

func _message_box_finished():
	super._message_box_finished()
	levelInputStarted.emit()
	pass
