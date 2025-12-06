extends Camera2D
class_name GameCamera

var target: Player

var TARGET_LEAD: Vector2 = Vector2(1, 20)
var TARGET_LEAD_MULT: float = 2
var TARGET_LEAD_MULT_SPEED: float = 150
var TARGET_LEAD_FAST_ZOOM: float = 3
var BASE_ZOOM: float = 4.5
var TARGET_LERP: Vector2 = Vector2(8, 4)

var useBaseZoom: bool

const POST_LEAVE_SCREEN_TIME: float = 5
var postLeaveTimer: float = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if not target:
		if get_tree().get_node_count_in_group("player") > 0:
			target = get_tree().get_nodes_in_group("player")[0]
		pass
	else:
		if G.state == G.State.PAUSED:
			return
		if useBaseZoom:
			#zoom = BASE_ZOOM * Vector2.ONE
			pass
			
		var target_position: Vector2 = _get_target_position()
		if not target.visibleOnScreen.is_on_screen():
			postLeaveTimer = POST_LEAVE_SCREEN_TIME
		if postLeaveTimer > 0:
			global_position.x = lerp(global_position.x, target_position.x, TARGET_LERP.x * 3 * delta)
			global_position.y = lerp(global_position.y, target_position.y, TARGET_LERP.y * 3 * delta)
			postLeaveTimer -= delta
		else:
			global_position.x = lerp(global_position.x, target_position.x, TARGET_LERP.x * delta)
			global_position.y = lerp(global_position.y, target_position.y, TARGET_LERP.y * delta)
		
	pass


func _get_target_position():
	var vertical: float = 0
	if target.isDucking and not (target.isDuckingSlide and target.velocity.y > 0):
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
