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

var sprite: Sprite2D

var emitterScene: PackedScene = preload("res://scenes/target_emitter.tscn")

const DEATH_TIME: float = 0.25
const DEATH_SCALE: float = 0.5
var deathDirection: Vector2
var deathTimer = 0
var isDying: bool = false

signal wasDestroyed(target:Target)

func _ready() -> void:
	endPos = $end.global_position
	startPos = global_position
	sprite = $sprite
	pass

func _physics_process(delta: float) -> void:
	
	if isDying:
		if deathTimer > 0:
			deathTimer -= delta
			var speed = deathDirection.normalized() * (deathTimer/DEATH_TIME * deathDirection.length())
			global_position += speed * delta
			scale = (((deathTimer/DEATH_TIME) * (1 - DEATH_SCALE)) + DEATH_SCALE) * Vector2.ONE
			
		else:
			die()
		pass
	else:
		
		match type:
			Type.Stationary:
				velocity = Vector2.ZERO
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
					
			Type.Gravity:
				pass
		var collided = move_and_slide()
		if collided:
			var collision = get_last_slide_collision()
			var entity = collision.get_collider()
			var normal = collision.get_normal()
			var remainder = collision.get_remainder()
			var angle = collision.get_angle()
			if entity is Player:
				deathDirection = -Vector2.from_angle(angle) * entity.velocity.length()
				start_death_timer()

func start_death_timer():
	sprite.self_modulate.a = sprite.self_modulate.a/2
	deathTimer = DEATH_TIME
	isDying = true
	pass

func die():
	super.die()
	emit(deathDirection.normalized())
	wasDestroyed.emit(self)
	queue_free()
	pass

func emit(direction: Vector2):
	var emitter: GPUParticles2D = await G.spawn(emitterScene)
	emitter.global_position = global_position
