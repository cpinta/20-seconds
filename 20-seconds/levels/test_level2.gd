class_name TestLevel2
extends Level


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	#Game.speak_for_time("RULE 1: Make a good tutorial", 9999, 0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	pass

func _loaded():
	super._loaded()
	var testQueue: Array[Textbox.MsgInfo] = [
		Textbox.MsgInfo.new("AGENT", "erm what the frick", Textbox.Mode.PerChar),
		Textbox.MsgInfo.new("AGENT", "yeah um... that was awkward", Textbox.Mode.PerChar),
		Textbox.MsgInfo.new("AGENT", "FRICK", Textbox.Mode.Instant)
	]
	G.send_queue_to_message_box(testQueue)
	pass
