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
	pass

var msgwave: int = 0
func _player_spawning_animation_finished():
	super._player_spawning_animation_finished()
	
	if not HAS_INTRO:
		return

	var queue: Array[Textbox.MsgInfo] = [
		Textbox.MsgInfo.new(G.agentName, "Hmm... That's odd... A chunk of this simulation was corrupted.", Textbox.Mode.PerChar),
		Textbox.MsgInfo.new(G.agentName, "HOW DO YOU GET OVER THERE NOW?!", Textbox.Mode.PerChar, 0, TextboxPortrait.Emotion.Surprised),
		Textbox.MsgInfo.new(G.agentName, "I'll be back.", Textbox.Mode.Instant, 2),
	]
		
	await get_tree().create_timer(1, true, false, true).timeout

	G.send_queue_to_message_box(queue)

func _player_spawning_loading_finished():
	super._player_spawning_loading_finished()


func _message_box_finished():
	super._message_box_finished()
	if msgwave == 0:
		msgwave += 1
		var queue: Array[Textbox.MsgInfo] = [
			Textbox.MsgInfo.new(G.agentName, "Alright, here's what we're gonna do.", Textbox.Mode.PerChar),
			Textbox.MsgInfo.new(G.agentName, "A charged gun shot's recoil might get you over the gap.", Textbox.Mode.PerChar),
			Textbox.MsgInfo.new(G.agentName, "I trust someone with your experience will be able to handle this without hurting yourself", Textbox.Mode.PerChar),
			Textbox.MsgInfo.new(G.agentName, "... please", Textbox.Mode.PerCharContinuing),
		]
		await get_tree().create_timer(1, true, false, true).timeout
		
		G.send_queue_to_message_box(queue)
	elif msgwave == 1:
		_start_level_input()
		pass
		
