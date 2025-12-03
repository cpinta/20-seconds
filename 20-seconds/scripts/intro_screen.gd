extends CanvasLayer
class_name IntroScreen

enum Mode {
	Instant,
	PerChar,
	PerCharContinuing
}

class MsgInfo:
	var text: String = ""
	var mode: Mode = Mode.PerChar
	var forTime: float = 0
	
	@warning_ignore("shadowed_variable")
	func _init(text:String, mode: Mode = Mode.PerChar, forTime: float = 0) -> void:
		self.text = text
		self.mode = mode
		self.forTime = forTime
		

const TIME_PER_CHAR: float = 0.1
var charTimer: float = 0

var mode: Mode

var audio: AudioStreamPlayer
var audio2: AudioStreamPlayer
var acTyping: AudioStream = load("res://audio/intro typing.mp3")
var acHumming: AudioStream = load("res://audio/intro humming.mp3")
var lblText: Label

var allowSkipInput: bool = true
var isActive: bool = false

var messageQueue: Array[MsgInfo] = []
var currentDestText: String = ""
var currentText: String = ""
var talkTimer: float = 0

signal skipPressed
signal loadBackground

func _ready() -> void:
	lblText = $Control/MarginContainer/Label
	audio = $AudioStreamPlayer
	audio2 = $AudioStreamPlayer2
	audio2.stream = acHumming
	audio2.play()
	
	add_queue(
		[
			MsgInfo.new("", Mode.Instant, 2),
			MsgInfo.new("PENGNU v11.27.25\n>", Mode.Instant, 2),
			MsgInfo.new("sim -gj -s 20", Mode.PerCharContinuing, 2.25),
			MsgInfo.new("WELCOME TO THE FIELD TRAINING SIMULATION", Mode.Instant, 3),
		]
	)

func _process(delta: float) -> void:
	
	if Input.is_action_just_released("skip_text"):
		skipPressed.emit()
	if Input.is_action_just_released("pause"):
		skipPressed.emit()
	if isActive:
		
		if currentText != currentDestText:
			if mode == Mode.PerChar or mode == Mode.PerCharContinuing:
				if charTimer < TIME_PER_CHAR:
					charTimer += delta
				else:
					if currentText.length() < currentDestText.length():
						currentText += currentDestText[currentText.length()]
						_set_text(currentText)
						charTimer = charTimer - TIME_PER_CHAR
						pass
					
		
		if talkTimer > 0:
			talkTimer -= delta
		else:
			pass

func add_queue(messages: Array[MsgInfo]):
	messageQueue.clear()
	messageQueue.append_array(messages)
	isActive = true
	_speak_next_message_in_queue()

func _speak_next_message_in_queue() -> bool:
	if messageQueue.size() > 0:
		_speak_info(messageQueue[0])
		messageQueue.remove_at(0)
		return true
	else:
		skipPressed.emit()
	return false

func _set_text(text:String):
	lblText.text = text

@warning_ignore("shadowed_variable")
func speak(mode: Mode, text: String):
	isActive = true
	self.mode = mode
	if mode == Mode.PerCharContinuing:
		currentDestText += text
	else:
		currentDestText = text
	match mode:
		Mode.Instant:
			currentText = currentDestText
			_set_text(currentDestText)
			pass
		Mode.PerChar:
			pass
		pass
	pass

func _speak_info(info: MsgInfo):
	
	if info.text == "sim -gj -s 20":
		audio.stream = acTyping
		audio.play()
		pass
	if info.text == "WELCOME TO THE FIELD TRAINING SIMULATION":
		loadBackground.emit()
		audio2.stop()
		pass
	if info.mode != Mode.PerCharContinuing:
		currentText = ""
	if info.forTime != 0:
		await speak_for_time(info.mode, info.text, info.forTime)
	else:
		speak(info.mode, info.text)
	pass

@warning_ignore("shadowed_variable")
func speak_for_time(mode: Mode, text: String, time:float):
	isActive = true
	self.mode = mode
	speak(mode, text)
	await get_tree().create_timer(time, true, false, true).timeout
	_speak_next_message_in_queue()
