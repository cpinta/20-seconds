extends Control
class_name Textbox

enum Mode {
	Instant,
	PerChar,
	PerCharContinuing
}

class MsgInfo:
	var username: String = ""
	var text: String = ""
	var mode: Mode = Mode.PerChar
	var forTime: float = 0
	var emotion: TextboxPortrait.Emotion
	var isTalking: bool = true
	
	@warning_ignore("shadowed_variable")
	func _init(username: String, text:String, mode: Mode = Mode.PerChar, forTime: float = 0, emotion: TextboxPortrait.Emotion = TextboxPortrait.Emotion.Default, isTalking = true) -> void:
		self.username = username
		self.text = text
		self.mode = mode
		self.forTime = forTime
		self.emotion = emotion
		self.isTalking = isTalking
		

const TIME_PER_CHAR: float = 0.0025
var charTimer: float = 0

var mode: Mode

var lblText: RichTextLabel
var buttonHint: ButtonHint
var portrait: TextboxPortrait

var allowSkipInput: bool = true
var isActive: bool = false

var messageQueue: Array[MsgInfo] = []
var currentDestText: String = ""
var currentText: String = ""
var currentSpeaker: String = ""
var talkTimer: float = 0

signal textboxClosed

func _ready() -> void:
	lblText = $"Control/margin text/Text"
	buttonHint = $"margin icons/key icon"
	portrait = $Control/MarginContainer/Portrait
	
	close()
	pass

func _process(delta: float) -> void:
	
	if isActive:
		if allowSkipInput:
			if Input.is_action_just_released("advance_text"):
				_input_pressed()
			if Input.is_action_just_released("skip_text"):
				_skip_input_pressed()
		
		if mode == Mode.PerChar or mode == Mode.PerCharContinuing:
			if currentText != currentDestText:
				if charTimer < TIME_PER_CHAR:
					charTimer += delta
				else:
					if currentText.length() < currentDestText.length():
						currentText += currentDestText[currentText.length()]
						_set_text(currentText)
						charTimer = charTimer - TIME_PER_CHAR
			else:
				if portrait.isTalking:
					portrait.stop_talking()
		
		if talkTimer > 0:
			talkTimer -= delta
		else:
			pass
		pass

func add_queue(messages: Array[MsgInfo]):
	messageQueue.clear()
	messageQueue.append_array(messages)
	isActive = true
	_open()
	_speak_next_message_in_queue()

func _speak_next_message_in_queue() -> bool:
	if messageQueue.size() > 0:
		_speak_info(messageQueue[0])
		messageQueue.remove_at(0)
		return true
	if isActive:
		close()
		textboxClosed.emit()
	return false

func _input_pressed():
	_speak_next_message_in_queue()

func _skip_input_pressed():
	while _speak_next_message_in_queue():
		pass

func close():
	visible = false
	isActive = false
	messageQueue.clear()
	_set_text("")
	pass

func _open():
	visible = true

func _set_text(text:String, emotion: TextboxPortrait.Emotion = TextboxPortrait.Emotion.Default):
	if currentSpeaker != "":
		lblText.text = currentSpeaker + "> "+ text
	else:
		lblText.text = text
	pass

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
	if not messageQueue.has(info):
		return
	set_allow_input(true)
	currentSpeaker = info.username
	if info.mode != Mode.PerCharContinuing:
		currentText = ""
	if info.forTime != 0:
		speak_for_time(info.mode, info.text, info.forTime)
	else:
		speak(info.mode, info.text)
	
	if info.username != "":
		portrait.visible = true
		portrait.set_state(info.emotion, info.isTalking)
	else:
		portrait.visible = false

func set_allow_input(value: bool):
	allowSkipInput = value
	buttonHint.visible = allowSkipInput
	pass

@warning_ignore("shadowed_variable")
func speak_for_time(mode: Mode, text: String, time:float):
	set_allow_input(false)
	isActive = true
	self.mode = mode
	speak(mode, text)
	await get_tree().create_timer(time, true, false, true).timeout
	portrait.stop_talking()
	_speak_next_message_in_queue()
