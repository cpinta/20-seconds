extends CanvasLayer
class_name InGameUI

var rootControl: Control
var topHalf: Control

var savingLabel: Label

var lblDebug: Label
var target: Player
var textbox: Textbox
var timer: SecTimer

var targetUI: TargetUI


var frameCount: int = 0
const FRAME_COUNT_MAX: int = 10000
const UPDATE_UI_EVERY: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rootControl = $Control
	topHalf = $Control/topHalf
	
	lblDebug = $Control/topHalf/left/MarginContainer/VBoxContainer/lblDebug
	textbox = $Control/bottomHalf/MarginContainer/Textbox
	timer = $Control/topHalf/right/Panel/Timer
	targetUI = $"Control/topHalf/right/Target UI"
	savingLabel = $Control/MarginContainer/Saving
	savingLabel.visible = false
	
	lblDebug.visible = G.debug

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if not target:
		if get_tree().get_node_count_in_group("player") > 0:
			target = get_tree().get_nodes_in_group("player")[0]
		else:
			return
	
	if G.debug:
		if target:
			lblDebug.text = str(abs(floor(target.velocity.length())))
			lblDebug.text += "\nInput:\t"+str(target.inputVector)
			lblDebug.text += "\nPlr:  \t"+str(floor(target.global_position.x))+", "+str(floor(target.global_position.y))
			lblDebug.text += "\nPlr Spd:  \t"+str(floor(target.velocity.x))+", "+str(floor(target.velocity.y))
			lblDebug.text += "\nLast vel:  \t"+str(target.lastVelSlant.x)+", "+str(target.lastVelSlant.y)
			lblDebug.text += "\nonGround:  \t"+str(target.isOnGround)+", "+str(target.isOnGroundOld)
			lblDebug.text += "\nisOnSlant:  \t"+str(target.isOnSlant)
			if G.camera:
				lblDebug.text += "\nCam:\t"+str(floor(G.camera.global_position.x))+", "+str(floor(G.camera.global_position.y))
				
	if G.curLevelObj:
		if targetUI.curNum != G.curLevelObj.targets.size():
			targetUI.set_count(G.curLevelObj.targets.size())
	
	frameCount += 1
	if frameCount > FRAME_COUNT_MAX:
		frameCount = 0
		pass
	pass

func show_saving():
	savingLabel.visible = true

func hide_saving():
	savingLabel.visible = false

func show_ui():
	topHalf.visible = true

func hide_ui():
	topHalf.visible = false
