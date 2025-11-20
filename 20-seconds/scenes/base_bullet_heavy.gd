extends Bullet
class_name BaseBulletHeavy

func _init() -> void:
	damage = 1
	knockback = 1
	speed = 150
	health = 4
	originalScale = 0.01
	desiredScale = 0.05
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	pass # Replace with function body.
