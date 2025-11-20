extends Item
class_name HoldableItem

var holder: Entity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact():
	pass

func use_item(direction: Vector2, isCharged: bool):
	pass
