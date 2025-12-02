extends Button

var timer: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer > 0:
		timer -= delta
	else:
		text = "Clear"
	pass

func _pressed() -> void:
	G.gameSave = Save.create_blank(G.levelPaths.size())
	Save.set_save(G.gameSave)
	text = "Save Cleared!"
	timer = 10
