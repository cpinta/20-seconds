extends GPUParticles2D
class_name OneShotEmitter

signal dead

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not emitting:
		dead.emit()
		queue_free()
	pass
