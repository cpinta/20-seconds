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

func _player_spawning_animation_finished():
	super._player_spawning_animation_finished()
	
	if not HAS_INTRO:
		return
	var queue: Array[Textbox.MsgInfo] = [
		Textbox.MsgInfo.new(G.agentName, "Made the targets bigger to make this one a little more doable.", Textbox.Mode.PerChar),
		Textbox.MsgInfo.new(G.agentName, "Not that I think you can't do it! It'd just be overly difficult", Textbox.Mode.PerChar),
		Textbox.MsgInfo.new(G.agentName, "Not that I think you can't do things that are diffi- I gotta go", Textbox.Mode.PerChar, 0, TextboxPortrait.Emotion.Surprised),
	]
	G.send_queue_to_message_box(queue)

func _player_spawning_loading_finished():
	super._player_spawning_loading_finished()


func _message_box_finished():
	super._message_box_finished()
	_start_level_input()
