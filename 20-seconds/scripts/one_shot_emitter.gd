extends GPUParticles2D
class_name OneShotEmitter

signal dead

@export var timer: float = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitting = true
	if timer == -1:
		timer = lifetime

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	timer -= delta
	if not emitting:
		if not timer > 0: 
			dead.emit()
			queue_free()
	pass
