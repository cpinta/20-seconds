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
		var target_position: Vector2 = _get_target_position()
		global_position.x = lerp(global_position.x, target_position.x, TARGET_LERP.x * delta)
		global_position.y = lerp(global_position.y, target_position.y, TARGET_LERP.y * delta)
	pass

func _get_target_position():
	var vertical: float = 0
	if target.isDucking:
		vertical = 0
		pass
	else:
		vertical = target.inputVector.y
		pass
	return Vector2(target.global_position.x + (target.direction * TARGET_LEAD.x), target.global_position.y + (vertical * TARGET_LEAD.y))

func _level_loaded():
	if not target:
		if get_tree().get_node_count_in_group("player") > 0:
			target = get_tree().get_nodes_in_group("player")[0]
		pass
	global_position = _get_target_position()
	pass
