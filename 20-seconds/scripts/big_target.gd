extends Entity
class_name BigTarget

const DESTINATION_MIN_DIST: float = 1
var SHAKE_DISTANCE_MAX: float = 5
var SHAKE_DISTANCE_MIN: float = 2
const ACTION_LERP:float = 10

var endPos: Vector2

var sprite: AnimatedSprite2D
var leye: BigTargetEye
var reye: BigTargetEye

var isShaking: bool = false
var curShakeDest: Vector2

var _isTangible: bool = false
@export var INTANGIBLE_FILTER: Color

var _isVulnerable: bool = false
@export var VULNERABLE_FILTER: Color

var eyeDestination: Vector2

var currentPhase: BigTargetPhase

var _COLLIDE_TANGIBLE_LAYER: int = 0b0010
var _COLLIDE_INTANGIBLE_LAYER: int = 0b0000
var _COLLIDE_TANGIBLE_MASK: int = 0b0101
var _COLLIDE_INTANGIBLE_MASK: int = 0b0000

var targetHitEmitterScene: PackedScene = preload("res://scenes/target_emitter.tscn")
var bulletHeavyScene: PackedScene = preload("res://scenes/base_bullet_heavy.tscn")

func _ready() -> void:
	sprite = $sprite
	leye = $sprite/leye
	reye = $sprite/reye
	#isShaking = true
	

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if G.inGameUI:
		_set_phase(BTPShootDown.new(self))
		
		pass
	
	if currentPhase:
		match currentPhase.eyeFollow:
			BigTargetPhase.EyeFollow.Player:
				eyeDestination = G.player.global_position
				_set_eye_dest(eyeDestination)
			BigTargetPhase.EyeFollow.Center:
				_set_eye_center()
			BigTargetPhase.EyeFollow.Dest:
				_set_eye_dest(eyeDestination)
		currentPhase._process(delta)
	if isShaking:
		if sprite.position.distance_to(curShakeDest) > DESTINATION_MIN_DIST * 4:
			sprite.position = lerp(sprite.position, curShakeDest, delta * ACTION_LERP)
		else:
			curShakeDest = (randf_range(SHAKE_DISTANCE_MIN, SHAKE_DISTANCE_MAX)) * (Vector2(1, 0).rotated(randf() * 2*PI))
	else:
		sprite.position = Vector2.ZERO


func set_is_tangible(value: bool):
	_isTangible = value
	if _isTangible:
		sprite.modulate = Color.WHITE
		collision_layer = _COLLIDE_TANGIBLE_LAYER
		collision_mask = _COLLIDE_TANGIBLE_MASK
	else:
		sprite.modulate = INTANGIBLE_FILTER
		collision_layer = _COLLIDE_INTANGIBLE_LAYER
		collision_mask = _COLLIDE_INTANGIBLE_MASK

func _physics_process(delta: float) -> void:
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	#var collided = move_and_slide()
	#if collided:
		#var collision = get_last_slide_collision()
		#@warning_ignore("unused_variable")
		#var entity = collision.get_collider()
	if currentPhase:
		currentPhase._physics_process(delta)
		

func _set_eye_dest(pos: Vector2):
	leye.look_toward(pos)
	reye.look_toward(pos)

func _set_eye_center():
	leye.look_toward_center()
	reye.look_toward_center()

func _set_phase(phase: BigTargetPhase):
	currentPhase = phase
	G.inGameUI.timer.timeRanOut.connect(currentPhase.timer_finished)
	currentPhase.startPhaseTimer.connect(G.inGameUI.timer.start_timer)
