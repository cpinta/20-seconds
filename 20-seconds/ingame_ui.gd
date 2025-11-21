extends CanvasLayer
class_name InGameUI

var lblSpeed: Label
var target: Player

var frameCount: int = 0
const FRAME_COUNT_MAX: int = 10000
const UPDATE_UI_EVERY: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lblSpeed = $Control/topHalf/left/MarginContainer/lblSpeed
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not target:
		if get_tree().get_node_count_in_group("player") > 0:
			target = get_tree().get_nodes_in_group("player")[0]
		else:
			return
	
	if target:
		if frameCount % UPDATE_UI_EVERY == 0:
			lblSpeed.text = str(abs(floor(target.velocity.x)))
	
	frameCount += 1
	if frameCount > FRAME_COUNT_MAX:
		frameCount = 0
		pass
	pass
