extends Control
class_name SecTimer

enum State {
	Blank,
	Countdown,
	Frozen
}

var state: State = State.Countdown
var lbl: Label
var audio: AudioStreamPlayer

var asDadada: Array[AudioStream] = [
	load("res://audio/kalimba6.mp3"),
	load("res://audio/kalimba chime 1.mp3")
	]

const SECONDS = 20

const NEW_RECORD: String = "NEW RECORD!!"
const FIRST_CLEAR: String = "FIRST CLEAR!"
const LBL_TIME: float = 0.5
var lblTimer: float = 0

var timer: float = 20
var oldTimer: float = 20

var numbers: Array[TextureRect]
var numtexs: Array[CompressedTexture2D] = [
	preload("res://sprites/timer sprite0.png"),
	preload("res://sprites/timer sprite1.png"),
	preload("res://sprites/timer sprite2.png"),
	preload("res://sprites/timer sprite3.png"),
	preload("res://sprites/timer sprite4.png"),
	preload("res://sprites/timer sprite5.png"),
	preload("res://sprites/timer sprite6.png"),
	preload("res://sprites/timer sprite7.png"),
	preload("res://sprites/timer sprite8.png"),
	preload("res://sprites/timer sprite9.png"),
]

signal timeRanOut

func _ready() -> void:
	
	numbers.append($"MarginContainer/Timer/Panel/0")
	numbers.append($"MarginContainer/Timer/Panel/1")
	numbers.append($"MarginContainer/Timer/Panel/2")
	numbers.append($"MarginContainer/Timer/Panel/3")
	
	audio = $AudioStreamPlayer
	lbl = $LowerText
	lbl.visible = false
	
	set_timer()
	state = State.Frozen
	pass

func play_sound(stream: AudioStream):
	audio.stream = stream
	audio.play()

func play_random_sound(arr: Array[AudioStream]):
	play_sound(arr.pick_random())

func set_timer():
	timer = SECONDS
	oldTimer = SECONDS
	lbl.visible = false
	_show_timer_time(timer)

func _process(delta: float) -> void:
	get_parent().size.y = 0
	if Input.is_action_just_released("toggle_timer"):
		if state == State.Blank:
			resume_timer()
		else:
			pause_timer()
		pass
	match state:
		State.Blank:
			visible = false
			pass
		State.Frozen:
			visible = true
			pass
		State.Countdown:
			visible = true
			if timer > 0:
				timer -= delta
			else:
				timer = 0
				_show_timer_time(timer)
				timeRanOut.emit()
				state = State.Frozen
			_show_timer_time(timer)
			oldTimer = timer
			pass
	if lbl.text != "":
		if lblTimer > 0:
			lblTimer -= delta
		else:
			lblTimer = LBL_TIME
			lbl.visible = not lbl.visible
	else:
		lbl.visible = false

func start_timer():
	set_timer()
	state = State.Countdown
	pass

func pause_timer():
	state = State.Frozen
	lbl.text = ""
	
func resume_timer():
	state = State.Countdown

func level_finished(earlierTime: float, timesPlayed: int):
	if timesPlayed == 0:
		lbl.text = FIRST_CLEAR
		play_sound(asDadada[0])
		return
	if earlierTime < timer:
		lbl.text = NEW_RECORD
		play_sound(asDadada[1])
		return

func _show_timer_time(time: float):
	var string: String = "0000"
	
	@warning_ignore("narrowing_conversion")
	var minute: int = time/60
	@warning_ignore("narrowing_conversion")
	var secs: int = time - (minute * 60)
	var secsStr: String = str(secs)
	var msecs: float = (time * 100) - floor(time) * 100
	var msecsStr: String = str(msecs)
	
	if len(msecsStr) > 1:
		string[3] = msecsStr[1]
		string[2] = msecsStr[0]
		pass
	else:
		string[3] = msecsStr[0]
		
	
	if len(secsStr) > 1:
		string[1] = secsStr[1]
		string[0] = secsStr[0]
	else:
		string[1] = secsStr[0]
		
	
	var i = 0
	while i < len(numbers):
		numbers[i].texture = numtexs[int(string[i])]
		i += 1
		pass
		
	pass
