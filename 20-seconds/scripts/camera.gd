extends Camera2D
class_name GameCamera

var target: Player

var TARGET_LEAD: Vector2 = Vector2(20, 20)
var TARGET_LERP: Vector2 = Vector2(8, 4)

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
		var vertical: float = 0
		if target.isDucking:
			vertical = 0
			pass
		else:
			vertical = target.inputVector.y
			pass
		global_position.y = lerp(global_position.y, target.global_position.y + (vertical * TARGET_LEAD.y), TARGET_LERP.y * delta)
		global_position.x = lerp(global_position.x, target.global_position.x + (target.direction * TARGET_LEAD.x), TARGET_LERP.x * delta)
		
		pass
	pass
