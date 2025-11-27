extends Weapon
class_name Gun

var sprite: Sprite2D

var gunPoint: Node2D
var gunPointPos: Vector2
var bulletScene: PackedScene = preload("res://scenes/base_bullet.tscn")
var bulletHeavyScene: PackedScene = preload("res://scenes/base_bullet_heavy.tscn")

var emitterScene: PackedScene = preload("res://scenes/gun_emitter.tscn")

var gunPointScale: float = 0.01

var activeBullets: Array[Bullet] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = $gun
	gunPoint = $gun/gunPoint
	gunPointPos = gunPoint.position
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	pass

func use_item(dir: Vector2, isCharged: bool):
	super.use_item(dir, isCharged)
	shoot_bullet(dir, isCharged)

func shoot_bullet(dir: Vector2, isCharged: bool):
	var bullet: Bullet = null
	if isCharged:
		emit(dir)
		bullet = await G.spawn(bulletHeavyScene)
		bullet.global_position = gunPoint.global_position
		if dir.x != 0:
			bullet.global_position.y = holder.global_position.y - (bullet.shape.shape.height/4 * bullet.desiredScale)
			pass
	else:
		emit(dir)
		bullet = await G.spawn(bulletScene)
		bullet.global_position = gunPoint.global_position
	bullet.initialize(holder, dir)
	bullet.rotation = dir.angle()
	bullet.wasDestroyed.connect(bullet_was_destroyed)
	activeBullets.append(bullet)
	pass

func emit(dir: Vector2):
	var emitter: GPUParticles2D = await G.spawn(emitterScene)
	emitter.global_position = gunPoint.global_position
	emitter.rotation = dir.angle()
	
func set_direction(dir: Vector2):
	if dir.x > 0:
		sprite.flip_h = false
		gunPoint.position.x = gunPointPos.x
	else:
		sprite.flip_h = true
		gunPoint.position.x = -gunPointPos.x
	pass

func bullet_was_destroyed(bullet: Bullet):
	activeBullets.erase(bullet)
	pass

func reset():
	super.reset()
	for i in range(0, activeBullets.size()):
		if activeBullets[i]:
			activeBullets[i].queue_free()
		pass
	activeBullets.clear()
	pass
