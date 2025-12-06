extends Level

const CAMERA_ZOOM: float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	HAS_INTRO = false
	HAS_GUN = true
	
	pass # Replace with function body.

func _loaded():
	super._loaded()
	G.inGameUI.show_ui()
	#G.camera.useBaseZoom = false
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	#
	#G.camera.zoom
	#G.camera.zoom = Vector2.ONE * CAMERA_ZOOM
	pass

func _player_spawning_animation_finished():
	super._player_spawning_animation_finished()
	
	if not HAS_INTRO:
		return
	#var queue: Array[Textbox.MsgInfo] = [
		##Textbox.MsgInfo.new(G.agentName, "You can aim your weapon any which way!", Textbox.Mode.PerChar),
		##Textbox.MsgInfo.new(G.agentName, "Just don't aim toward yourself, thanks!", Textbox.Mode.PerChar),
	#]
	#G.send_queue_to_message_box(queue)

func _player_spawning_loading_finished():
	super._player_spawning_loading_finished()


func _message_box_finished():
	super._message_box_finished()
	_start_level_input()
