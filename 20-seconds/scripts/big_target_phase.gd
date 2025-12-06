class_name BigTargetPhase

var bigTarget: BigTarget

enum EyeFollow {
	Player,
	Center,
	Dest
}

var phaseName: String = ""
var eyeFollow: EyeFollow = EyeFollow.Player
var eyeDestination: Vector2

var doTimerTickDown: bool = false
var timer: float = 20

const ACTION_LERP:float = 10
const DESTINATION_MIN_DIST: float = 1

@warning_ignore("unused_signal")
signal phaseEnded

signal startPhaseTimer

@warning_ignore("shadowed_variable")
func _init(bigTarget: BigTarget) -> void:
	self.bigTarget = bigTarget

func _ready() -> void:
	pass # Replace with function body.

func start():
	G.inGameUI.timer.set_timer()

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	pass

func timer_finished():
	pass

func was_hit():
	pass

func start_phase():
	pass

func end_phase():
	pass
