extends Node2D
class_name BigTargetEye

var sprites: Array[BigTargetEyeInner] = []

func _ready() -> void:
	find_descendant_inner_nodes(self)

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

func find_descendant_inner_nodes(node: Node):
	for child in node.get_children():
		if child is BigTargetEyeInner:
			sprites.append(child)
		find_descendant_inner_nodes(child)

func look_toward(pos: Vector2):
	for i in range(0, sprites.size()):
		sprites[i].look_toward(pos)

func look_toward_center():
	for i in range(0, sprites.size()):
		sprites[i].set_to_center()
