extends TextureRect
class_name TextboxPortrait

var texRect: TextureRect
var colorRect: ColorRect

const TIME_BT_FRAMES: float = 0.1
const TIME_BT_FRAMES_SURPRISED: float = 0.2
var CURRENT_TIME_BT_FRAMES
var frameTimer: float = 0

enum AnimState {
	Idle,
	Talking
}

enum Emotion {
	Default,
	Surprised
}

var animState: AnimState
var emotion: Emotion

var defaultFrames: Array[Texture] = [
	load("res://sprites/penguin/penguin_1.png"),
	load("res://sprites/penguin/penguin_2.png")
]

var surprisedFrames: Array[Texture] = [
	load("res://sprites/penguin/penguin_3.png"),
	load("res://sprites/penguin/penguin_4.png")
]

var isTalking: bool = false
var animIndex: int = 0

var currentFrames: Array[Texture]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texRect = $TextureRect
	colorRect = $ColorRect
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isTalking:
		if frameTimer > 0:
			frameTimer -= delta
		else:
			animIndex += 1
			if animIndex >= currentFrames.size():
				animIndex = 0
			texRect.texture = currentFrames[animIndex]
			frameTimer = CURRENT_TIME_BT_FRAMES
		pass
	pass

func stop_talking():
	isTalking = false
	if currentFrames:
		texRect.texture = currentFrames[0]

func set_state(newEmotion: Emotion, newTalking: bool = true):
	emotion = newEmotion
	isTalking = newTalking
	frameTimer = 0
	animIndex = 0
	match emotion:
		Emotion.Default:
			currentFrames = defaultFrames
			CURRENT_TIME_BT_FRAMES = TIME_BT_FRAMES
		Emotion.Surprised:
			currentFrames = surprisedFrames
			CURRENT_TIME_BT_FRAMES = TIME_BT_FRAMES_SURPRISED
	texRect.texture = currentFrames[animIndex]
