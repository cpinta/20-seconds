extends Node2D
class_name Bullet

var sender: Entity

var emitterScene: PackedScene = preload("res://scenes/gun_emitter.tscn")

var area: Area2D
var shape: CollisionShape2D

var damage: float = 0
var knockback: float = 0
var speed: float = 0
var direction: Vector2
var health: int = 1

var dist_traveled: float = 0
const MAX_DIST: float = 1000

var originalScale: float = 0.01
var desiredScale: float = 0.05

const TIME_TIL_FULL_SCALE: float = 0.04
var fullScaleTimer: float = 0

signal wasDestroyed(bullet: Bullet)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area = $area
	area.body_entered.connect(_area_entered)
	scale = Vector2.ONE * originalScale
	
	shape = $area/CollisionShape2D
	pass # Replace with function body.

func destroy():
	queue_free()
	pass

@warning_ignore("shadowed_variable")
func initialize(sender: Entity, direction: Vector2):
	self.sender = sender
	self.direction = direction
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if fullScaleTimer < TIME_TIL_FULL_SCALE:
		scale = Vector2.ONE * (originalScale + (fullScaleTimer/TIME_TIL_FULL_SCALE) * (desiredScale - originalScale))
		fullScaleTimer += delta
		pass
	else:
		scale = Vector2.ONE * desiredScale
	pass

func _physics_process(delta: float) -> void:
	
	var moveDelta: Vector2 = speed * direction * delta
	global_position += moveDelta
	if dist_traveled < MAX_DIST:
		dist_traveled += moveDelta.length()
		pass
	else:
		destroy()
		pass

func _area_entered(body: Node2D):
	if body is Entity:
		var entity = body as Entity
		if entity == sender:
			return
		if !entity.invulnerable:
			entity.get_hit(damage, knockback)
			pass
		get_hit()
	elif body is TileMapLayer:
		die()
		pass


func get_hit():
	@warning_ignore("narrowing_conversion")
	health -= damage
	if health <= 0:
		die()
	pass

@warning_ignore("unused_parameter")
func die(location: Vector2 = global_position):
	wasDestroyed.emit(self)
	var emitter = await G.spawn(emitterScene)
	
	emitter.global_position = global_position
	emitter.rotation = (-direction).angle()
	queue_free()
	pass
