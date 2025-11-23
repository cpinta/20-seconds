extends HBoxContainer
class_name SecTimer

enum State {
	Blank,
	Countdown,
	Frozen
}

var state: State = State.Countdown

const SECONDS = 21

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

func _ready() -> void:
	
	numbers.append($"MarginContainer/0")
	numbers.append($"MarginContainer2/1")
	numbers.append($"MarginContainer3/2")
	numbers.append($"MarginContainer4/3")
	
	set_timer()
	pass

func set_timer():
	timer = SECONDS
	oldTimer = SECONDS
	pass

func _process(delta: float) -> void:
	match state:
		State.Blank:
			pass
		State.Frozen:
			pass
		State.Countdown:
			if timer > 0:
				timer -= delta
			else:
				timer = 0
			show_timer_time(timer)
			oldTimer = timer
			pass
	pass

func show_timer_time(time: float):
	var str: String = "0000"
	
	var min: int = time/60
	var minStr: String = str(min)
	var secs: int = time - (min * 60)
	var secsStr: String = str(secs)
	var msecs: float = (time * 100) - floor(time) * 100
	var msecsStr: String = str(msecs)
	
	if len(msecsStr) > 1:
		str[3] = msecsStr[1]
		str[2] = msecsStr[0]
		pass
	else:
		str[3] = msecsStr[0]
		
	
	if len(secsStr) > 1:
		str[1] = secsStr[1]
		str[0] = secsStr[0]
	else:
		str[1] = secsStr[0]
		
	
	var i = 0
	while i < len(numbers):
		numbers[i].texture = numtexs[int(str[i])]
		i += 1
		pass
		
	pass
