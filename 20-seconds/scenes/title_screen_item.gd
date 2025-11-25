extends PanelContainer
class_name TitleScreenItem

@export var text: String
var label: Label
var styleBox: StyleBoxFlat

@export var isSelected: bool = false

const UNSELECTED_COLOR_A: float = 0.2
const SELECTED_COLOR_A: float = 1
const SELECTED_LERP: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label = $MarginContainer/Label
	label.text = text
	styleBox = self.get_theme_stylebox("panel").duplicate()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isSelected:
		styleBox.bg_color.a = lerp(styleBox.bg_color.a, SELECTED_COLOR_A, SELECTED_LERP * delta)
		pass
	else:
		styleBox.bg_color.a = lerp(styleBox.bg_color.a, UNSELECTED_COLOR_A, SELECTED_LERP * delta)
		
		pass
	pass
