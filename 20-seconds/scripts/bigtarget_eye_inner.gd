extends Sprite2D
class_name BigTargetEyeInner

@export var radius: float = -1
@export var enabled: bool = true
var currentDestination: Vector2

const EYE_LERP: float = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if radius == -1:
		queue_free()

func _process(delta: float) -> void:
	if not enabled:
		return
	position = Vector2.ZERO
	global_position = lerp(global_position, global_position.move_toward(global_position.direction_to(currentDestination) * radius, 3), EYE_LERP * delta)

func look_toward(pos: Vector2):
	if not enabled:
		return
	currentDestination = pos
	
func set_to_center():
	currentDestination = Vector2.ZERO
