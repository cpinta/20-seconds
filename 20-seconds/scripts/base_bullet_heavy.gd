extends Bullet
class_name BaseBulletHeavy

func _init() -> void:
	damage = 1
	knockback = 1
	speed = 50
	health = 100
	originalScale = 0.01
	desiredScale = 0.1

func _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
