extends Camera2D
class_name GameCamera

var target: Player

var TARGET_LEAD: Vector2 = Vector2(50, 50)
var TARGET_LERP: float = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not target:
		if get_tree().get_node_count_in_group("player") > 0:
			target = get_tree().get_nodes_in_group("player")[0]
		pass
	else:
		global_position = lerp(global_position, target.global_position + (Vector2(target.direction, target.inputVector.y) * TARGET_LEAD), TARGET_LERP * delta)
		
		pass
	pass
