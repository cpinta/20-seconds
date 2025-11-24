extends CanvasLayer
class_name InGameUI

var lblDebug: Label
var target: Player
var textbox: Textbox
var timer: SecTimer

var frameCount: int = 0
const FRAME_COUNT_MAX: int = 10000
const UPDATE_UI_EVERY: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lblDebug = $Control/topHalf/left/MarginContainer/VBoxContainer/lblDebug
	textbox = $Control/bottomHalf/Textbox
	timer = $Control/topHalf/right/Panel/Timer
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not target:
		if get_tree().get_node_count_in_group("player") > 0:
			target = get_tree().get_nodes_in_group("player")[0]
		else:
			return
	
	if G.debug:
		if target:
			lblDebug.text = str(abs(floor(target.velocity.x)))
			lblDebug.text += "\nInput:\t"+str(target.inputVector)
			lblDebug.text += "\nPlr:  \t"+str(floor(target.global_position.x))+", "+str(floor(target.global_position.y))
			lblDebug.text += "\nLast vel:  \t"+str(floor(target.lastVelSlant.x))+", "+str(floor(target.lastVelSlant.y))
			if G.camera:
				lblDebug.text += "\nCam:\t"+str(floor(G.camera.global_position.x))+", "+str(floor(G.camera.global_position.y))
	
	frameCount += 1
	if frameCount > FRAME_COUNT_MAX:
		frameCount = 0
		pass
	pass
