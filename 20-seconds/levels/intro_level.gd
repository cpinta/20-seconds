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

enum State {
	FirstPhase,
	TimerOn,
}

var state: State = State.FirstPhase

func _player_spawning_loading_finished():
	G.player.set_state(Player.State.DISABLE_COMPLETELY)
	G.inGameUI.hide_ui()

	var queue: Array[Textbox.MsgInfo] = [
		Textbox.MsgInfo.new("", "", Textbox.Mode.Instant, 1),
		Textbox.MsgInfo.new("", "PENGNU v11.27.25\n>", Textbox.Mode.PerChar),
		Textbox.MsgInfo.new("", "sim -gj -s 20", Textbox.Mode.PerCharContinuing),
		Textbox.MsgInfo.new("", "WELCOME TO THE FIELD TRAINING SIMULATION", Textbox.Mode.Instant),
		Textbox.MsgInfo.new("", "CONNECTING TO HOST", Textbox.Mode.Instant, 0.25),
		Textbox.MsgInfo.new("", "CONNECTING TO HOST.", Textbox.Mode.Instant, 0.25),
		Textbox.MsgInfo.new("", "CONNECTING TO HOST..", Textbox.Mode.Instant, 0.25),
		Textbox.MsgInfo.new("", "CONNECTING TO HOST...", Textbox.Mode.Instant, 1),
		Textbox.MsgInfo.new("", G.agentName+" CONNECTED!", Textbox.Mode.Instant, 2),
		Textbox.MsgInfo.new(G.agentName, "Hello!", Textbox.Mode.PerChar),
		Textbox.MsgInfo.new(G.agentName, "Agent Arms it is an honor for you to sacrifice your precious time for this!", Textbox.Mode.PerChar),
		Textbox.MsgInfo.new(G.agentName, "You are our first tester who has actually done work in the field so your feedback will be greatly appreciated for Q.A!", Textbox.Mode.PerChar),
	]
	G.send_queue_to_message_box(queue)

func _message_box_finished():
	super._message_box_finished()
	match state:
		State.FirstPhase:
			state = State.TimerOn
			G.inGameUI.show_ui()
			var queue: Array[Textbox.MsgInfo] = [
				Textbox.MsgInfo.new(G.agentName, "So, without further ado! Let's get this training started for you!", Textbox.Mode.PerChar),
				Textbox.MsgInfo.new(G.agentName, ".", Textbox.Mode.Instant, 1),
				Textbox.MsgInfo.new(G.agentName, "..", Textbox.Mode.Instant, 1),
				Textbox.MsgInfo.new(G.agentName, "...", Textbox.Mode.Instant, 1),
				Textbox.MsgInfo.new(G.agentName, "OH I'M SO SORRY!", Textbox.Mode.Instant),
				Textbox.MsgInfo.new(G.agentName, "LET ME ENABLE YOUR VISOR FIRST HAHA", Textbox.Mode.Instant),
			]
			G.send_queue_to_message_box(queue)
		State.TimerOn:
			levelConcluded.emit()
			pass
	pass
