extends Sprite2D
class_name BigTargetEyeInner

@export var radius: float = -1
@export var enabled: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if radius == -1:
		queue_free()

func look_toward(pos: Vector2):
	if not enabled:
		return
	position = Vector2.ZERO
	global_position = global_position.move_toward(global_position.direction_to(pos) * radius, 3)
	
