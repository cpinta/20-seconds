extends BigTargetPhase
class_name BTPShootDown

enum PhaseState{
	Pre,
	During,
	Post
}

var CENTER_SHOOT_POSITION: Vector2 = Vector2(0,-75.0)
var SHOOT_HORIZONTAL_RANGE: float = 100
var SHOOT_VERTICAL_HEIGHT: float = -133.503
var SHOOT_BULLET_EVERY: float = 1
var shootBulletMult: float = 2
var shootBulletMultTime: float =10
var bulletTimer: float = 0


var phaseState: PhaseState = PhaseState.Pre

func _init(bigTarget: BigTarget) -> void:
	super._init(bigTarget)
	phaseName = "Shoot Down"

func start():
	super.start()
	bigTarget.set_is_tangible(false)

func _process(delta: float) -> void:
	match phaseState:
		PhaseState.Pre:
			if bigTarget.global_position.distance_to(CENTER_SHOOT_POSITION) > DESTINATION_MIN_DIST:
				bigTarget.global_position = lerp(bigTarget.global_position, CENTER_SHOOT_POSITION, ACTION_LERP * delta)
			else:
				bigTarget.global_position = CENTER_SHOOT_POSITION
				phaseState = PhaseState.During
				startPhaseTimer.emit()
				bigTarget.set_is_tangible(true)
			pass
		PhaseState.During:
			eyeFollow = EyeFollow.Center
			bigTarget.isShaking = true
			
			if bulletTimer > 0:
				bulletTimer -= delta
			else:
				if G.inGameUI.timer.timer < shootBulletMultTime:
					bulletTimer = SHOOT_BULLET_EVERY / shootBulletMult
				else:
					bulletTimer = SHOOT_BULLET_EVERY
				shoot_random_bullet()
		PhaseState.Post:
			bigTarget.set_is_tangible(true)
			
			pass

func _physics_process(delta: float) -> void:
	pass

func timer_finished():
	bigTarget.set_is_tangible(false)
	
	pass

func shoot_random_bullet():
	var pos:Vector2 = Vector2(bigTarget.global_position.x + randf_range(-SHOOT_HORIZONTAL_RANGE, SHOOT_HORIZONTAL_RANGE), bigTarget.global_position.y + SHOOT_VERTICAL_HEIGHT)
	shoot_bullet(pos)

func set_phase_state(state: PhaseState):
	phaseState = state
	match phaseState:
		PhaseState.Pre:
			pass
		PhaseState.During:
			pass
		PhaseState.Post:
			pass
	pass

func was_hit():
	pass

func start_phase():
	pass

func end_phase():
	pass
