class_name Player
extends Entity

enum PlayerState {FREE=0, MOVED_BY_SPIKE=1}

var state: PlayerState = PlayerState.FREE

var invulnerable: bool = false

var imgBody: Sprite2D
var imgHead: Sprite2D
var imgFace: Sprite2D
var imgEars: Sprite2D
var imgScarf: Sprite2D
var scarfParent: Node2D
var imgHand: Sprite2D
var imgLegs: Sprite2D
var gun: Gun

var SCARF_POS_LEFT_X: float = -112
var SCARF_POS_RIGHT_X: float = 140
var SCARF_CUR_BASE_ANGLE: float = 0
var scarfAngle: float = 0

const SCARF_ROTAT_MAX_X: float = 60
const SCARF_ROTAT_MAX_Y: float = 117
const SCARF_ROTAT_MIN: float = -17

const FACE_OFFSET_Y_MAX: float = -64
const FACE_OFFSET_Y_BASE: float = 0
const FACE_OFFSET_Y_MIN: float = 45

const FACE_OFFSET_X_MAX: float = 10
const FACE_OFFSET_X_BASE: float = -50
const FACE_OFFSET_X_MIN: float = 64

const FACE_BASE_IDLE_TIME: float = 2
var faceBaseTimer: float = 0

const EARS_OFFSET_Y_MAX: float = 70
const EARS_OFFSET_Y_BASE: float = 0
const EARS_OFFSET_Y_MIN: float = -10

const EARS_OFFSET_X_MAX: float = 25
const EARS_OFFSET_X_BASE: float = 0
const EARS_OFFSET_X_MIN: float = -45

const GUN_OFFSET_X_MAX: float = -50
const GUN_OFFSET_X_BASE: float = 0
const GUN_OFFSET_X_MIN: float = 45

const GUN_SHOOT_OFFSET_X_MAX: float = 100

const GUN_OFFSET_Y_MAX: float = -50
const GUN_OFFSET_Y_BASE: float = 0
const GUN_OFFSET_Y_MIN: float = 45

const GUN_RECOIL: Vector2 = Vector2(-5, 80)
const GUN_HAND_RECOIL_X: float = 100
const GUN_EAR_RECOIL_X: float = 50

const HANDS_ANGLE_MAX: float = -90
const HANDS_ANGLE_MIN: float = 90
const HANDS_ANGLE_LERP: float = 10

const IMG_SPEED_MAX: float = 10
const IMG_SPEED_LERP: float = 5
const IMG_SPEED_MIN: float = 0.1

const CROUCH_BODY_Y: float = 100
const CROUCH_BODY_ANGLE: float = -50
const CROUCH_LEGS_Y: float = 1
const SLIDE_FRICTION_MULT: float = 0.1
const FRICTION_MULT: float = 1

const INPUT_DEADZONE: float = 0.25

var STEP_ANGLE = 10
var STEP_SPEED: float = 3
var curStepAngle: float = 0
var stepDirection: int = -1
const CROUCH_LEG_ANGLE: float = -70.0
const LEG_AIR_SWING: float = 60

var groundDetect: Area2D
var groundRayR: RayCast2D
var audio: AudioStreamPlayer2D

const ACCELERATION = 80.0
const MAX_SPEED = 80.0
const JUMP_VELOCITY = 160.0
const MAX_COLLISIONS = 6

var spikeDestination: Vector2

@export var publicVelocity: Vector2

var inputVector: Vector2
var isOnGround: bool
var isDucking: bool


func _ready():
	groundDetect = $groundDetect
	audio = $audio
	
	imgBody = $sprites/body
	imgFace = $sprites/body/head/face
	imgEars = $sprites/body/head/ears
	imgHead = $sprites/body/head
	imgLegs = $sprites/legs
	imgScarf = $"sprites/body/scarf parent/scarf back"
	scarfParent = $"sprites/body/scarf parent"
	scarfParent.visible = false
	imgHand = $sprites/body/hands
	gun = $sprites/body/hands/gun
	
	pass

func play_sound(stream: AudioStream):
	audio.stream = stream
	audio.play()
	pass

func _process(delta):
	if abs(inputVector.x) > INPUT_DEADZONE:
		set_direction(inputVector.x)
		faceBaseTimer = FACE_BASE_IDLE_TIME
	else:
		scarfParent.rotation_degrees = lerp(scarfParent.rotation_degrees, SCARF_ROTAT_MIN, IMG_SPEED_LERP * delta)
	
	if abs(inputVector.y) > INPUT_DEADZONE:
		pass
	else:
		imgHand.rotation_degrees = lerp(imgHand.rotation_degrees, 0.0, HANDS_ANGLE_LERP * delta)
		
	if faceBaseTimer > 0:
		faceBaseTimer -= delta
	
	if abs(velocity.x) > IMG_SPEED_MIN:
		imgEars.position.x = lerp(imgEars.position.x, (min(abs(velocity.x), IMG_SPEED_MAX)/IMG_SPEED_MAX) * EARS_OFFSET_X_MAX * -direction, IMG_SPEED_LERP * delta)
		imgFace.position.x = lerp(imgFace.position.x, (min(abs(velocity.x), IMG_SPEED_MAX)/IMG_SPEED_MAX) * FACE_OFFSET_X_MAX * -direction, IMG_SPEED_LERP * delta)
		imgHand.position.x = lerp(imgHand.position.x, (min(abs(velocity.x), IMG_SPEED_MAX)/IMG_SPEED_MAX) * GUN_OFFSET_X_MAX * -direction, IMG_SPEED_LERP * delta)
		
		if isOnGround:
			
			#imgleg active stepping 
			if not isDucking:
				if abs(velocity.x) > IMG_SPEED_MIN:
					if abs(curStepAngle) < abs(stepDirection * STEP_ANGLE):
						curStepAngle += stepDirection * STEP_SPEED * abs(velocity.x) * delta
						pass
					else:
						curStepAngle = stepDirection * STEP_ANGLE + (stepDirection * -1)
						if stepDirection == 1:
							stepDirection = -1
						else:
							stepDirection = 1
					pass
		pass
	else:
		imgEars.position.x = lerp(imgEars.position.x, 0.0, IMG_SPEED_LERP * delta)
		imgHand.position.x = lerp(imgHand.position.x, 0.0, IMG_SPEED_LERP * delta)
		
		if isOnGround:
			if not isDucking:
				#imgleg stepping back to origin
				if abs(curStepAngle) > 0.1:
					if curStepAngle > 0:
						curStepAngle -= STEP_SPEED * delta
						pass
					else:
						curStepAngle += STEP_SPEED * delta
						pass
					pass
				else:
					curStepAngle = 0
					pass
				pass
		else:
			#imgleg stepping 
			pass
		pass
	
	if isOnGround:
		if isDucking:
			imgLegs.position.y = lerp(imgLegs.position.y, CROUCH_LEGS_Y, IMG_SPEED_LERP * delta)
			imgBody.position.y = lerp(imgBody.position.y, CROUCH_BODY_Y, IMG_SPEED_LERP * delta)
			imgLegs.z_index = 0
			if abs(velocity.x) > IMG_SPEED_MIN:
				if imgBody.rotation_degrees < direction * CROUCH_BODY_ANGLE:
					imgBody.rotation_degrees += -direction * STEP_SPEED * LEG_AIR_SWING * delta
				else:
					imgBody.rotation_degrees = direction * CROUCH_BODY_ANGLE
					pass
				if abs(curStepAngle) < abs(CROUCH_LEG_ANGLE):
					curStepAngle += -direction * STEP_SPEED * LEG_AIR_SWING * delta
				else:
					curStepAngle = direction * CROUCH_LEG_ANGLE
			else:
				if abs(imgBody.rotation_degrees) > 1:
					imgBody.rotation_degrees -= sign(imgBody.rotation_degrees) * IMG_SPEED_LERP
				else:
					imgBody.rotation_degrees = 0
					pass
				pass
			pass
	else:
		imgBody.position.y = lerp(imgBody.position.y, 0.0, IMG_SPEED_LERP * delta)
		
		stepDirection = direction * sign(velocity.y)
		if abs(curStepAngle) < abs(stepDirection * STEP_ANGLE):
			curStepAngle += stepDirection * STEP_SPEED * LEG_AIR_SWING * delta
			pass
		else:
			curStepAngle = stepDirection * STEP_ANGLE + (stepDirection * -1)
	imgLegs.rotation_degrees = curStepAngle
	
	if not isDucking:
		imgLegs.z_index = -1
		imgLegs.position.y = lerp(imgLegs.position.y, 0.0, IMG_SPEED_LERP * delta)
		imgBody.position.y = lerp(imgBody.position.y, 0.0, IMG_SPEED_LERP * delta)
		if abs(imgBody.rotation_degrees) > 1:
			imgBody.rotation_degrees -= sign(imgBody.rotation_degrees) * IMG_SPEED_LERP
		else:
			imgBody.rotation_degrees = 0
			pass
		pass
		
		
	if abs(inputVector.y) > INPUT_DEADZONE:
		if inputVector.y < 0:
			imgHand.rotation_degrees = lerp(imgHand.rotation_degrees, HANDS_ANGLE_MAX * direction, HANDS_ANGLE_LERP * delta)
			imgFace.position.y = lerp(imgFace.position.y, (min(abs(velocity.y), IMG_SPEED_MAX)/IMG_SPEED_MAX) * FACE_OFFSET_Y_MAX, IMG_SPEED_LERP * delta)
			imgHand.position.y = lerp(imgHand.position.y, (min(abs(velocity.y), IMG_SPEED_MAX)/IMG_SPEED_MAX) * GUN_OFFSET_Y_MAX, IMG_SPEED_LERP * delta)
			imgEars.position.y = lerp(imgEars.position.y, (min(abs(velocity.y), IMG_SPEED_MAX)/IMG_SPEED_MAX) * EARS_OFFSET_Y_MAX, IMG_SPEED_LERP * delta)
			pass
		else:
			if not isOnGround:
				imgHand.rotation_degrees = lerp(imgHand.rotation_degrees, HANDS_ANGLE_MIN * direction, HANDS_ANGLE_LERP * delta)
			else:
				imgHand.rotation_degrees = lerp(imgHand.rotation_degrees, 0.0, HANDS_ANGLE_LERP * delta)
			imgFace.position.y = lerp(imgFace.position.y, (min(abs(velocity.y), IMG_SPEED_MAX)/IMG_SPEED_MAX) * FACE_OFFSET_Y_MIN, IMG_SPEED_LERP * delta)
			imgHand.position.y = lerp(imgHand.position.y, (min(abs(velocity.y), IMG_SPEED_MAX)/IMG_SPEED_MAX) * GUN_OFFSET_Y_MIN, IMG_SPEED_LERP * delta)
			imgEars.position.y = lerp(imgEars.position.y, (min(abs(velocity.y), IMG_SPEED_MAX)/IMG_SPEED_MAX) * EARS_OFFSET_Y_MIN, IMG_SPEED_LERP * delta)
			pass
		pass
	else:
		imgHand.rotation_degrees = lerp(imgHand.rotation_degrees, 0.0, HANDS_ANGLE_LERP * delta)
		imgHand.position.y = lerp(imgHand.position.y, 0.0, IMG_SPEED_LERP * delta)
		if isOnGround:
			imgFace.position.y = lerp(imgFace.position.y, 0.0, IMG_SPEED_LERP * delta)
			imgEars.position.y = lerp(imgEars.position.y, 0.0, IMG_SPEED_LERP * delta)
			if faceBaseTimer <= 0:
				if abs(velocity.x) < IMG_SPEED_MIN:
					imgFace.position.x = lerp(imgFace.position.x, FACE_OFFSET_X_BASE * direction, IMG_SPEED_LERP * delta)
			pass
		else:
			if velocity.y > 0:
				imgFace.position.y = lerp(imgFace.position.y, (min(abs(velocity.y), IMG_SPEED_MAX)/IMG_SPEED_MAX) * FACE_OFFSET_Y_MAX, IMG_SPEED_LERP * delta)
				imgHand.position.y = lerp(imgHand.position.y, (min(abs(velocity.y), IMG_SPEED_MAX)/IMG_SPEED_MAX) * GUN_OFFSET_Y_MAX, IMG_SPEED_LERP * delta)
				imgEars.position.y = lerp(imgEars.position.y, (min(abs(velocity.y), IMG_SPEED_MAX)/IMG_SPEED_MAX) * EARS_OFFSET_Y_MAX, IMG_SPEED_LERP * delta)
				pass
			else:
				imgFace.position.y = lerp(imgFace.position.y, (min(abs(velocity.y), IMG_SPEED_MAX)/IMG_SPEED_MAX) * FACE_OFFSET_Y_MIN, IMG_SPEED_LERP * delta)
				imgHand.position.y = lerp(imgHand.position.y, (min(abs(velocity.y), IMG_SPEED_MAX)/IMG_SPEED_MAX) * GUN_OFFSET_Y_MIN, IMG_SPEED_LERP * delta)
				imgEars.position.y = lerp(imgEars.position.y, (min(abs(velocity.y), IMG_SPEED_MAX)/IMG_SPEED_MAX) * EARS_OFFSET_Y_MIN, IMG_SPEED_LERP * delta)
				pass
			pass
	
	#
	#if anim.animation.get_basename() == "walk":
		#if anim.frame != leftStep:
			

func _physics_process(delta):
	match state:
		PlayerState.FREE:
			get_inputVector()
			collide(delta)
			
			isOnGround = len(groundDetect.get_overlapping_bodies()) > 0
			
			if isOnGround:
				if inputVector.y > 0:
					isDucking = true
				else:
					isDucking = false
			else:
				isDucking = false
			
			# Add the gravity.
			if not is_on_floor():
				velocity -= get_gravity() * delta

			# Handle jump.
			if Input.is_action_just_pressed("jump") && isOnGround:
				velocity.y = JUMP_VELOCITY

			if Input.is_action_just_pressed("shoot"):
				imgEars.position.x = GUN_EAR_RECOIL_X * -direction
				imgFace.position.x = FACE_OFFSET_X_MAX * -direction
				imgHand.position.x = GUN_HAND_RECOIL_X * -direction
				
				faceBaseTimer = FACE_BASE_IDLE_TIME
				if abs(inputVector.y) > INPUT_DEADZONE:
					gun.shoot_bullet(Vector2(0, inputVector.y))
					if inputVector.y < 0:
						velocity.y += GUN_RECOIL.y * inputVector.y
					else:
						velocity.y = GUN_RECOIL.y * inputVector.y
				else:
					gun.shoot_bullet(Vector2(direction, 0))
					velocity.x += GUN_RECOIL.x * direction
				pass

			if inputVector.x != 0 and not isDucking:
				#velocity.x = inputVector.x * SPEED
				velocity.x = move_toward(velocity.x, MAX_SPEED * direction, ACCELERATION * delta)
			else:
				var friction: float = FRICTION_MULT
				if isDucking:
					friction = SLIDE_FRICTION_MULT
					pass
				
				velocity.x = move_toward(velocity.x, 0, ACCELERATION * friction * delta)
			pass
			
			publicVelocity = velocity

func collide(delta: float):
	var collision_count := 0
	var collision = move_and_collide(Vector2(velocity.x, -velocity.y) * delta)
	while collision and collision_count < MAX_COLLISIONS:
		var collider = collision.get_collider()
		var entity = collider.get_parent()
		#if entity is Player:
			#
			#pass
		#elif entity is Enemy:
			#var enemy = entity as Enemy
			#if self is Player:
				#if enemy.DAMAGES_ON_CONTACT:
					#enemy.attack_enemy(self, enemy.attack_damage, enemy.attack_knockback, self.global_position - enemy.global_position)
		var normal = collision.get_normal()
		var remainder = collision.get_remainder()
		var angle = collision.get_angle()
		velocity = Vector2(velocity.x + (-1 * abs(normal.x) * velocity.x), velocity.y + (-1 * abs(normal.y) * velocity.y))
		remainder = Vector2(remainder.x + (-1 * abs(normal.x) * remainder.x), remainder.y + (-1 * abs(normal.y) * remainder.y))
		
		collision_count += 1
		collision = move_and_collide(remainder)
		pass
	pass

func get_inputVector():
	inputVector.x = Input.get_axis("left", "right")
	inputVector.y = Input.get_axis("up", "down")
	return inputVector
	
func set_direction(dir: int):
	direction = dir
	if dir == -1:
		imgBody.flip_h = true
		imgEars.flip_h = true
		imgFace.flip_h = true
		imgScarf.flip_h = true
		scarfParent.position.x = SCARF_POS_LEFT_X
		SCARF_CUR_BASE_ANGLE = 180
		scarfParent.scale.y = dir
		imgHand.flip_h = true
		pass
	if dir == 1:
		imgBody.flip_h = false
		imgEars.flip_h = false
		imgFace.flip_h = false
		imgScarf.flip_h = false
		scarfParent.position.x = SCARF_POS_LEFT_X
		SCARF_CUR_BASE_ANGLE = 0
		scarfParent.scale.y = dir
		imgHand.flip_h = false
		pass
	
	if gun:
		gun.set_direction(Vector2(direction, inputVector.y))
