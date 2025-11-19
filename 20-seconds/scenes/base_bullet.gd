extends Bullet
class_name BaseBullet

func _init() -> void:
	damage = 1
	knockback = 1
	speed = 200
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	pass # Replace with function body.
