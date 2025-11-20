extends Node2D
class_name Bullet

var sender: Entity

var area: Area2D

var damage: float = 0
var knockback: float = 0
var speed: float = 0
var direction: Vector2
var health: int = 1

var dist_traveled: float = 0
const MAX_DIST: float = 300

var originalScale: float = 0.01
var desiredScale: float = 0.05

const TIME_TIL_FULL_SCALE: float = 0.04
var fullScaleTimer: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area = $area
	area.body_entered.connect(_area_entered)
	pass # Replace with function body.

func destroy():
	queue_free()
	pass

func initialize(sender: Entity, direction: Vector2):
	self.sender = sender
	self.direction = direction
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var moveDelta: Vector2 = speed * direction * delta
	global_position += moveDelta
	if dist_traveled < MAX_DIST:
		dist_traveled += moveDelta.length()
		pass
	else:
		destroy()
		pass
	
	if fullScaleTimer < TIME_TIL_FULL_SCALE:
		scale = Vector2.ONE * (originalScale + (fullScaleTimer/TIME_TIL_FULL_SCALE) * (desiredScale - originalScale))
		fullScaleTimer += delta
		pass
	else:
		scale = Vector2.ONE * desiredScale
	pass

func _area_entered(body: Node2D):
	if body is Entity:
		var entity = body as Entity
		if entity == sender:
			return
		if !entity.invulnerable:
			entity.get_hit(damage, knockback)
			pass
		die()
	else:
		pass

func die():
	queue_free()
	pass
