extends HBoxContainer
class_name SecTimer

enum State {
	Blank,
	Countdown,
	Frozen
}

var state: State = State.Countdown

const SECONDS = 20

var timer
var oldTimer

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
	
	numbers.append($"0")
	numbers.append($"1")
	numbers.append($"2")
	numbers.append($"3")
	
	set_timer()
	state = State.Frozen
	pass

func set_timer():
	timer = SECONDS
	oldTimer = SECONDS
	_show_timer_time(timer)

func _process(delta: float) -> void:
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
	pass

func start_timer():
	set_timer()
	state = State.Countdown
	pass

func pause_timer():
	state = State.Frozen
	
func resume_timer():
	state = State.Countdown

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
