extends TextureRect
class_name ButtonHint

var texUnpressed: CompressedTexture2D = preload("res://sprites/key 32pt.png")
var texPressed: CompressedTexture2D = preload("res://sprites/key down 32pt.png")
var lblKey: Label
var lblContainer: CenterContainer

const _unpressedY: float = -2
const _pressedY: float = 3
const _pressedScaleY: float = 0.8

@export var actionName: String = ""
@export var actionIndex: int = 0

var idleyAnimate: bool = false
var animatedWhenPressed: bool = true
var idleTimer: float = 0
const IDLE_TIME_PER_FRAME: float = 1


func _ready() -> void:
	lblKey = $CenterContainer/Label
	lblContainer = $CenterContainer
	set_action(actionName)
	pass

func set_action(string:String):
	actionName = string
	lblKey.text = InputMap.action_get_events(actionName)[actionIndex].as_text_physical_keycode()
	match lblKey.text:
		"Up":
			lblKey.text = "↑"
			pass
		"Down":
			lblKey.text = "↓"
			pass
		"Left":
			lblKey.text = "←"
			pass
		"Right":
			lblKey.text = "→"
			pass
		pass
		
	await get_tree().process_frame
	position.x -= lblContainer.size.x/2
	size.x = lblContainer.size.x
	pass

func _process(delta: float) -> void:
	
	if animatedWhenPressed:
		if actionName != null and actionName != "":
			if InputMap.has_action(actionName):
				if Input.is_action_pressed(actionName):
					press()
					return
				else:
					unpress()
		
		pass
	if idleyAnimate:
		if idleTimer < IDLE_TIME_PER_FRAME:
			idleTimer += delta
		else:
			idleTimer = 0
			if get_is_pressed():
				unpress()
			else:
				press()
	
	pass

func get_is_pressed():
	return texture.resource_name == texPressed.resource_name

func press():
	texture = texPressed
	lblContainer.position.y = _pressedY
	lblContainer.scale.y = _pressedScaleY
	
	
func unpress():
	texture = texUnpressed
	lblContainer.position.y = _unpressedY
	lblContainer.scale.y = 1
