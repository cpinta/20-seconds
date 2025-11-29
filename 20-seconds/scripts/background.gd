extends Polygon2D
class_name Background

const OFFSET_GOAL: float = 16
@export var OFFSET_SPEED: float = 0.05
@export var OFFSET_DIRECTION: Vector2 = -Vector2.ONE

var isActive: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isActive:
		if texture_offset.length() < OFFSET_GOAL:
			texture_offset += OFFSET_DIRECTION * OFFSET_SPEED * delta
			
			if abs(max(texture_offset.x, texture_offset.y)) > OFFSET_GOAL/texture_scale.x:
				texture_offset.x = (abs(max(texture_offset.x, texture_offset.y)) - (OFFSET_GOAL/texture_scale.x)) 
				texture_offset.y = texture_offset.x
