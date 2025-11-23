extends Control
class_name Textbox

enum Mode {
	Instant,
	PerChar
}

class MsgInfo:
	var username: String = ""
	var text: String = ""
	var mode: Mode = Mode.PerChar
	var forTime: float = 0
	
	func _init(username: String, text:String, mode: Mode = Mode.PerChar, forTime: float = 0) -> void:
		self.username = username
		self.text = text
		self.mode = mode
		self.forTime = forTime
		

const TIME_PER_CHAR: float = 0.01
var charTimer: float = 0

var mode: Mode

var lblText: RichTextLabel
var buttonHint: ButtonHint

var allowSkipInput: bool = true
var isActive: bool = false

var messageQueue: Array[MsgInfo] = []
var currentDestText: String = ""
var currentText: String = ""
var currentSpeaker: String = ""
var talkTimer: float = 0

signal textboxClosed

func _ready() -> void:
	lblText = $"margin text/Text"
	buttonHint = $"margin icons/key icon"
	close()
	pass

func _process(delta: float) -> void:
	
	if isActive:
		if allowSkipInput:
			if Input.is_action_just_released("advance_text"):
				_input_pressed()
				pass
		
		if currentText != currentDestText:
			if mode == Mode.PerChar:
				if charTimer < TIME_PER_CHAR:
					charTimer += delta
				else:
					if currentText.length() < currentDestText.length():
						currentText += currentDestText[currentText.length()]
						_set_text(currentText)
						charTimer = 0
						pass
					
		
		if talkTimer > 0:
			talkTimer -= delta
		else:
			pass
		pass

func add_queue(messages: Array[MsgInfo]):
	messageQueue.append_array(messages)
	isActive = true
	_open()
	_speak_next_message_in_queue()

func _speak_next_message_in_queue() -> bool:
	if messageQueue.size() > 0:
		_speak_info(messageQueue[0])
		messageQueue.remove_at(0)
		return true
	return false

func _input_pressed():
	if not _speak_next_message_in_queue():
		textboxClosed.emit()
		close()

func close():
	visible = false
	messageQueue.clear()
	_set_text("")
	pass

func _open():
	visible = true
	pass

func _set_text(text:String):
	if currentSpeaker != "":
		lblText.text = currentSpeaker + "> "+ text
	else:
		lblText.text = text
	pass

func speak(mode: Mode, text: String):
	set_allow_input(true)
	isActive = true
	self.mode = mode
	currentDestText = text
	match mode:
		Mode.Instant:
			_set_text(currentDestText)
			pass
		Mode.PerChar:
			pass
		pass
	pass

func _speak_info(info: MsgInfo):
	currentSpeaker = info.username
	currentText = ""
	if info.forTime != 0:
		speak_for_time(info.mode, info.text, info.forTime)
	else:
		speak(info.mode, info.text)
	pass


func set_allow_input(value: bool):
	allowSkipInput = value
	buttonHint.visible = allowSkipInput
	pass

func speak_for_time(mode: Mode, text: String, time:float):
	set_allow_input(false)
	isActive = true
	self.mode = mode
	speak(mode, text)
	await get_tree().create_timer(time, true, false, true).timeout
	pass
