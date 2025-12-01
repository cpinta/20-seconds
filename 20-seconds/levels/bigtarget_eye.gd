extends Node2D

var sprites: Array[BigTargetEyeInner] = []

func _ready() -> void:
	find_descendant_inner_nodes(self)

func _process(delta: float) -> void:
	look_toward(get_global_mouse_position())

func find_descendant_inner_nodes(node: Node):
	for child in node.get_children():
		if child is BigTargetEyeInner:
			sprites.append(child)
		find_descendant_inner_nodes(child)

func look_toward(pos: Vector2):
	for i in range(0, sprites.size()):
		sprites[i].look_toward(pos)
		pass
	pass
