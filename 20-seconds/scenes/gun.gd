extends Weapon
class_name Gun

var sprite: Sprite2D

var gunPoint: Node2D
var gunPointPos: Vector2
var bulletScene: PackedScene = preload("res://scenes/base_bullet.tscn")
var bulletHeavyScene: PackedScene = preload("res://scenes/base_bullet_heavy.tscn")

var gunPointScale: float = 0.01

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = $gun
	gunPoint = $gun/gunPoint
	gunPointPos = gunPoint.position
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func use_item(direction: Vector2, isCharged: bool):
	super.use_item(direction, isCharged)
	shoot_bullet(direction, isCharged)

func shoot_bullet(direction: Vector2, isCharged: bool):
	var bullet: Bullet = null
	if isCharged:
		bullet = await G.spawn(bulletHeavyScene)
	else:
		bullet = await G.spawn(bulletScene)
	bullet.initialize(direction)
	bullet.global_position = gunPoint.global_position
	bullet.rotation = direction.angle()
	pass

func set_direction(direction: Vector2):
	if direction.x > 0:
		sprite.flip_h = false
		gunPoint.position.x = gunPointPos.x
		pass
	else:
		sprite.flip_h = true
		gunPoint.position.x = -gunPointPos.x
		pass
	pass
