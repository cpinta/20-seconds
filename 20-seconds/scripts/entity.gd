extends CharacterBody2D
class_name Entity

var direction: int = 1
var invulnerable: bool = false
var health: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_hit(damage: float, knockback: float):
	if invulnerable:
		return
	health -= damage
	if health <= 0:
		die()
	pass

func die():
	pass
