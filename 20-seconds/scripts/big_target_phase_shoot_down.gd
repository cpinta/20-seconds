extends BigTargetPhase
class_name BTPShootDown

enum PhaseState{
	Pre,
	During,
	Post
}

var CENTER_SHOOT_POSITION: Vector2 = Vector2(0,-130.0)
var SHOOT_HORIZONTAL_RANGE: float = 200 
var SHOOT_VERTICAL_HEIGHT: float = -133.503



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
		PhaseState.Post:
			bigTarget.set_is_tangible(true)
			
			pass

func _physics_process(delta: float) -> void:
	pass

func timer_finished():
	
	pass

func shoot_random_bullet():
	var pos:Vector2 = Vector2(bigTarget.global_position.x + randf_range(-SHOOT_HORIZONTAL_RANGE, SHOOT_HORIZONTAL_RANGE), bigTarget.global_position.y + SHOOT_VERTICAL_HEIGHT)
	shoot_bullet(pos)

func shoot_bullet(pos: Vector2):
	var bullet: Bullet = null
	bullet = await G.spawn(bigTarget.bulletHeavyScene)
	bullet.global_position = pos
	bullet.initialize(bigTarget, Vector2.DOWN)
	bullet.rotation = Vector2.DOWN.angle()

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
