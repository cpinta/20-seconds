extends Entity
class_name Target

enum Type {
	Stationary,
	Moving,
	Gravity
}

const DESTINATION_MIN_DIST: float = 1
@export var SPEED: float = 1.0
const SPEED_MULT: float = 1000
@export var DIRECTION: Vector2 
@export var type: Type
var endPos: Vector2
var startPos: Vector2 

signal wasDestroyed(target:Target)

func _ready() -> void:
	endPos = $end.global_position
	startPos = global_position
	pass

func _physics_process(delta: float) -> void:
	match type:
		Type.Stationary:
			pass
		Type.Moving:
			if direction == 1:
				if global_position.distance_to(endPos) > DESTINATION_MIN_DIST:
					velocity = global_position.direction_to(endPos) * SPEED * SPEED_MULT * delta
					pass
				else:
					global_position = endPos
					direction = -1
					pass
				pass
			else:
				if global_position.distance_to(startPos) > DESTINATION_MIN_DIST:
					velocity = global_position.direction_to(startPos) * SPEED * SPEED_MULT * delta
					pass
				else:
					global_position = startPos
					direction = 1
					pass
				pass
			pass
			move_and_slide()
		Type.Gravity:
			pass

func die():
	super.die()
	wasDestroyed.emit(self)
	queue_free()
	pass
