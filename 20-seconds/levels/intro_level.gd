class_name IntroLevel
extends Level


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	HAS_INTRO = true
	SELECTABLE = false

func _loaded():
	super._loaded()
	pass

func _process(delta):
	super._process(delta)
	if G.player:
		G.player.set_state(Player.State.DISABLE_COMPLETELY)
	pass

func _player_spawning_animation_finished():
	super._player_spawning_animation_finished()
	
	var testQueue: Array[Textbox.MsgInfo] = [
		Textbox.MsgInfo.new(G.agentName, "erm what the frick", Textbox.Mode.PerChar),
		Textbox.MsgInfo.new(G.agentName, "yeah um... that was awkward", Textbox.Mode.PerChar),
		Textbox.MsgInfo.new(G.agentName, "FRICK", Textbox.Mode.Instant)
	]
	G.send_queue_to_message_box(testQueue)

enum LvlState {
	FirstPhase,
	TimerOn,
}

var lvlstate: LvlState = LvlState.FirstPhase

func _player_spawning_loading_finished():
	G.player.set_state(Player.State.DISABLE_COMPLETELY)
	if not G.inGameUI:
		await G.start_game(false)
	G.inGameUI.hide_ui()

	var queue: Array[Textbox.MsgInfo] = [
		Textbox.MsgInfo.new("", "CONNECTING TO HOST", Textbox.Mode.Instant, 0.25),
		Textbox.MsgInfo.new("", "CONNECTING TO HOST.", Textbox.Mode.Instant, 0.25),
		Textbox.MsgInfo.new("", "CONNECTING TO HOST..", Textbox.Mode.Instant, 0.25),
		Textbox.MsgInfo.new("", "CONNECTING TO HOST...", Textbox.Mode.Instant, 1),
		Textbox.MsgInfo.new("", G.agentName+" CONNECTED!", Textbox.Mode.Instant, 2),
		Textbox.MsgInfo.new(G.agentName, "Hello!", Textbox.Mode.PerChar),
		Textbox.MsgInfo.new(G.agentName, "Agent Arms! It's an honor for you to volunteer to test our training simulation!", Textbox.Mode.PerChar),
		Textbox.MsgInfo.new(G.agentName, "You've actually done work in the field so your feedback will be greatly appreciated!", Textbox.Mode.PerChar),
	]
	G.send_queue_to_message_box(queue)

func _message_box_finished():
	super._message_box_finished()
	match lvlstate:
		LvlState.FirstPhase:
			lvlstate = LvlState.TimerOn
			G.inGameUI.show_ui()
			var queue: Array[Textbox.MsgInfo] = [
				Textbox.MsgInfo.new(G.agentName, "So, without further ado! Let's get this training started for you!", Textbox.Mode.PerChar),
				Textbox.MsgInfo.new(G.agentName, ".", Textbox.Mode.Instant, 1, TextboxPortrait.Emotion.Default, false),
				Textbox.MsgInfo.new(G.agentName, "..", Textbox.Mode.Instant, 1, TextboxPortrait.Emotion.Default, false),
				Textbox.MsgInfo.new(G.agentName, "...", Textbox.Mode.Instant, 1, TextboxPortrait.Emotion.Default, false),
				Textbox.MsgInfo.new(G.agentName, "OH I'M SO SORRY!", Textbox.Mode.Instant, 0, TextboxPortrait.Emotion.Surprised),
				Textbox.MsgInfo.new(G.agentName, "LET ME ENABLE YOUR VISOR FIRST HAHA", Textbox.Mode.Instant, 0, TextboxPortrait.Emotion.Surprised),
			]
			G.send_queue_to_message_box(queue)
		LvlState.TimerOn:
			levelConcluded.emit()
			pass
	pass
