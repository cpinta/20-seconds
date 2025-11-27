class_name Player
extends Entity

enum State {FREE=0, DISABLE_INPUT=1, SPAWNING=2, DYING=3, DISABLE_COMPLETELY=4, DISABLE_PHYSICS = 5}

var state: State = State.DISABLE_COMPLETELY

var spriteParent: Node2D
var imgBody: Sprite2D
var imgHead: Sprite2D
var imgFace: Sprite2D
var imgEars: Sprite2D
var imgScarf: Sprite2D
var scarfParent: Node2D
var imgHand: Sprite2D
var imgLegs: Sprite2D
var gun: Gun
const gunScene: PackedScene = preload("res://scenes/gun.tscn")
var col: CollisionShape2D

var centerHead: Node2D
var centerBody: Node2D
var centerLegs: Node2D

var leftWallRay: RayCast2D
var rightWallRay: RayCast2D

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

const GUN_RECOIL: Vector2 = Vector2(-10, 20)
const GUN_RECOIL_HEAVY: Vector2 = Vector2(-150, 200)
const GUN_HAND_RECOIL_X: float = 100
const GUN_EAR_RECOIL_X: float = 50
const GUN_CHARGE_TIME: float = 1
const GUN_CHARGE_SHAKE_Y: float = 10
const GUN_CHARGE_SHAKE_SPEED: float = 1000
var gunChargeShakeDir: int = 1
var isChargingGun: bool = false
var gunChargeTimer: float = 0

const HANDS_ANGLE_MAX: float = -90
const HANDS_ANGLE_MIN: float = 90
const HANDS_ANGLE_LERP: float = 10

const IMG_SPEED_MAX: float = 10
const IMG_SPEED_LERP: float = 5
const IMG_SPEED_MIN: float = 0.1

const CROUCH_BODY_Y: float = 100
const CROUCH_BODY_ANGLE: float = -50
const CROUCH_HEAD_Y: float = 80
const CROUCH_LEGS_Y: float = 1
const SLIDE_FRICTION_MULT: float = 0.25
#const SLIDE_SLANT_FRICTION_MULT: float = 2
const FRICTION_MULT: float = 1
const CROUCH_LAND_BOOST: float = 120
const CROUCH_SPEED: float = 300
const CROUCH_LERP: float = 30
const SLIDE_MIN_SPEED: float = 40
var crouchDetect: Area2D

const COL_STAND_HEIGHT: float = 13.5
const COL_CROUCH_HEIGHT: float = 9
const COL_RADIUS: float = 8

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

const ACCELERATION = 160
const MAX_SPEED = 80.0
const MAX_CROUCH_SPEED = 20.0
const JUMP_VELOCITY = 160.0
const WALL_JUMP_VELOCITY: Vector2 = Vector2(120, 160)
const MAX_COLLISIONS = 6

const stepEmitterScene: PackedScene = preload("res://scenes/step_emitter.tscn")
const STEP_EMITTER_GAP: float = 0.05
var stepEmitterTimer: float = 0

const spawnEmitterScene: PackedScene = preload("res://scenes/reanimate_emitter.tscn")
var spawnEmitters: Array[OneShotEmitter] = []
signal plyr_spawning_anim_finished
var spawnTimer: float = 0
const SPAWN_SHOW_TIME: float = 1.5

var spikeDestination: Vector2

@export var publicVelocity: Vector2

var inputVector: Vector2
var isOnGround: bool
var isOnGroundOld: bool
var isDucking: bool
var isDuckingSlide: bool
var canUnDuck: bool


func _ready():
	groundDetect = $groundDetect
	audio = $audio
	col = $collider
	
	spriteParent = $sprites
	imgBody = $sprites/body
	imgFace = $sprites/body/head/face
	imgEars = $sprites/body/head/ears
	imgHead = $sprites/body/head
	imgLegs = $sprites/legs
	imgScarf = $"sprites/body/scarf parent/scarf back"
	scarfParent = $"sprites/body/scarf parent"
	scarfParent.visible = false
	imgHand = $sprites/body/hands
	
	centerHead = $sprites/body/head/headCenter
	centerBody = $sprites/body/bodyCenter
	centerLegs = $sprites/legs/legsCenter
	
	leftWallRay = $leftwallray
	rightWallRay = $rightwallray
	crouchDetect = $crouchDetect
	
	spawn_gun()

func play_sound(stream: AudioStream):
	audio.stream = stream
	audio.play()
	pass

func _process(delta):
	match state:
		State.DISABLE_PHYSICS:
			return
	
	if abs(inputVector.x) > INPUT_DEADZONE:
		@warning_ignore("unused_parameter", "narrowing_conversion")
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
		if gun:
			imgHand.position.x = lerp(imgHand.position.x, (min(abs(velocity.x), IMG_SPEED_MAX)/IMG_SPEED_MAX) * GUN_OFFSET_X_MAX * -direction, IMG_SPEED_LERP * delta)
		
		if isOnGround:
			
			#imgleg active stepping 
			if not isDucking:
				if abs(velocity.x) > SLIDE_MIN_SPEED:
					_step_emit(delta)
					pass
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
		if gun:
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
			imgHead.position.y = lerp(imgHead.position.y, CROUCH_HEAD_Y, IMG_SPEED_LERP * delta)
			imgHead.z_index = 0
			#imgLegs.z_index = 0
			if isDuckingSlide:
				if round(imgBody.rotation_degrees) < direction * CROUCH_BODY_ANGLE:
					imgBody.rotation_degrees += -direction * STEP_SPEED * LEG_AIR_SWING * delta
				else:
					imgBody.rotation_degrees = direction * CROUCH_BODY_ANGLE
					pass
				if abs(curStepAngle) < abs(CROUCH_LEG_ANGLE):
					curStepAngle += -direction * STEP_SPEED * LEG_AIR_SWING * delta
				else:
					curStepAngle = direction * CROUCH_LEG_ANGLE
			else:
				if abs(imgBody.rotation_degrees) > 4:
					imgBody.rotation_degrees -= sign(imgBody.rotation_degrees) * CROUCH_SPEED * delta
				else:
					imgBody.rotation_degrees = 0
					pass
				pass
				if abs(curStepAngle) > 4:
					curStepAngle += -sign(curStepAngle) * STEP_SPEED * LEG_AIR_SWING * delta
				else:
					curStepAngle = 0
			pass
			var rect = col.shape as RectangleShape2D
			if rect.size.y > COL_CROUCH_HEIGHT:
				var newShape: RectangleShape2D = RectangleShape2D.new()
				newShape.size.y = lerp(rect.size.y, COL_CROUCH_HEIGHT, CROUCH_LERP * delta)
				newShape.size.x = COL_RADIUS
				col.shape = newShape
				col.position.y = -newShape.size.y/2
				pass
			else:
				if rect.size.y != COL_CROUCH_HEIGHT:
					var newShape: RectangleShape2D = RectangleShape2D.new()
					newShape.size.y = COL_CROUCH_HEIGHT
					newShape.size.x = COL_RADIUS
					col.shape = newShape
					col.position.y = -COL_CROUCH_HEIGHT/2
					pass
	else:
		imgBody.position.y = lerp(imgBody.position.y, 0.0, CROUCH_LERP * delta)
		
		stepDirection = direction * sign(velocity.y)
		if abs(curStepAngle) < abs(stepDirection * STEP_ANGLE):
			curStepAngle += stepDirection * STEP_SPEED * LEG_AIR_SWING * delta
			pass
		else:
			curStepAngle = stepDirection * STEP_ANGLE + (stepDirection * -1)
	imgLegs.rotation_degrees = curStepAngle
	
	if not isDucking:
		imgHead.z_index = -1
		imgLegs.z_index = -1
		imgLegs.position.y = lerp(imgLegs.position.y, 0.0, IMG_SPEED_LERP * delta)
		imgBody.position.y = lerp(imgBody.position.y, 0.0, IMG_SPEED_LERP * delta)
		imgHead.position.y = lerp(imgHead.position.y, 0.0, IMG_SPEED_LERP * delta)
		if abs(imgBody.rotation_degrees) > 4:
			imgBody.rotation_degrees -= sign(imgBody.rotation_degrees) * CROUCH_SPEED * delta
		else:
			imgBody.rotation_degrees = 0
			pass
		pass
		
		var capsule = col.shape as RectangleShape2D
		if capsule.size.y < COL_STAND_HEIGHT:
			var newShape: RectangleShape2D = RectangleShape2D.new()
			newShape.size.y = lerp(capsule.size.y, COL_STAND_HEIGHT, IMG_SPEED_LERP * delta)
			newShape.size.x = COL_RADIUS
			col.shape = newShape
			col.position.y = -newShape.size.y/2
			pass
		else:
			if capsule.size.y != COL_STAND_HEIGHT:
				var newShape: RectangleShape2D = RectangleShape2D.new()
				newShape.size.y = COL_STAND_HEIGHT
				newShape.size.x = COL_RADIUS
				col.shape = newShape
				col.position.y = -COL_STAND_HEIGHT/2
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

	if isChargingGun:
		if not gun:
			isChargingGun = false
			gunChargeTimer = 0
		if gunChargeTimer > GUN_CHARGE_TIME:
			imgFace.position.x = lerp(imgFace.position.x, FACE_OFFSET_X_MAX * -direction, IMG_SPEED_LERP * delta)
			
			var pos: float = gun.position.y
			if abs(pos) < GUN_CHARGE_SHAKE_Y:
				pos += delta * GUN_CHARGE_SHAKE_SPEED * -gunChargeShakeDir
				pass
			else:
				gunChargeShakeDir = -gunChargeShakeDir
				pos = (GUN_CHARGE_SHAKE_Y * gunChargeShakeDir) - gunChargeShakeDir
				pass
			gun.position.y = pos
	else:
		if gun:
			gun.position.y = 0
		pass
	pass

func spawn_gun():
	gun = await G.spawn(gunScene)
	gun.reparent(imgHand)
	gun.position = Vector2.ZERO
	gun.scale = Vector2.ONE
	gun.set_direction(Vector2(direction, 0))
	gun.holder = self

func despawn_gun():
	gun.queue_free()

func _step_emit(delta: float):
	if stepEmitterTimer < STEP_EMITTER_GAP:
		stepEmitterTimer += delta
		pass
	else:
		stepEmitterTimer = 0
		var stepEmitter = await G.spawn(stepEmitterScene)
		stepEmitter.scale.x = sign(velocity.x)
		stepEmitter.global_position = global_position
	pass

@warning_ignore("unused_parameter")
func _cast_ray(dir: Vector2, length: float):
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + (dir * length))
	var result = space_state.intersect_ray(query)
	if result:
		if result["collider"] is Player:
			pass
		else:
			pass
	pass

func _physics_process(delta):
	match state:
		State.FREE:
			get_inputVector()
			slide(delta)
			
			isOnGround = len(groundDetect.get_overlapping_bodies()) > 0
			
			if isOnGround:
				if abs(inputVector.y) > INPUT_DEADZONE:
					isDucking = true
					if abs(velocity.x) > SLIDE_MIN_SPEED:
						isDuckingSlide = true
					else:
						isDuckingSlide = false
				else:
					if canUnDuck:
						isDuckingSlide = false
						isDucking = false
			else:
				isDuckingSlide = false
				isDucking = false
				canUnDuck = true
			
			if isDucking:
				var temp = crouchDetect.get_overlapping_bodies()
				canUnDuck = len(crouchDetect.get_overlapping_bodies()) == 0
			
			# Add the gravity.
			if not is_on_floor():
				velocity -= get_gravity() * delta

			# Handle jump.
			if Input.is_action_just_pressed("jump") && isOnGround:
				velocity.y = JUMP_VELOCITY
			# Handle walljump
			if Input.is_action_just_pressed("jump") && not isOnGround:
				_try_wall_jump()

			if gun:
				if Input.is_action_just_pressed("shoot"):
					isChargingGun = true
					pass
				if Input.is_action_just_released("shoot"):
					isChargingGun = false
					var gunIsCharged: bool = false
					var aim: Vector2 = get_gun_aim_vector()
					var recoilVec: Vector2
					if gunChargeTimer > GUN_CHARGE_TIME:
						gunIsCharged = true
						recoilVec = GUN_RECOIL_HEAVY
						if isDucking:
							recoilVec *= SLIDE_FRICTION_MULT
						gun.shoot_bullet(aim, true)
					else:
						recoilVec = GUN_RECOIL
						gun.shoot_bullet(aim, false)
					if aim.y < 0:
						velocity.y += recoilVec.y * inputVector.y
					elif aim.y > 0:
						if gunIsCharged:
							velocity.y = recoilVec.y * inputVector.y
						else:
							velocity.y += recoilVec.y * inputVector.y
					else:
						velocity.x += recoilVec.x * direction
					
					imgEars.position.x = GUN_EAR_RECOIL_X * -direction
					imgFace.position.x = FACE_OFFSET_X_MAX * -direction
					imgHand.position.x = GUN_HAND_RECOIL_X * -direction
					
					faceBaseTimer = FACE_BASE_IDLE_TIME
					gunChargeTimer = 0
				if isChargingGun:
					if gunChargeTimer < GUN_CHARGE_TIME:
						gunChargeTimer += delta
						pass
					else:
						pass
			else:
				imgHand.position.x = lerp(imgHand.position.x, -42.0 * direction, IMG_SPEED_LERP * delta)
				pass
			if inputVector.x != 0:
				#velocity.x = inputVector.x * SPEED
				if isDucking:
					if not isDuckingSlide:
						velocity.x = move_toward(velocity.x, MAX_CROUCH_SPEED * direction, ACCELERATION * delta)
				else:
					velocity.x = move_toward(velocity.x, MAX_SPEED * direction, ACCELERATION * delta)
					
			else:
				pass
			
			publicVelocity = velocity
		State.DISABLE_INPUT:
			slide(delta)
			if not is_on_floor():
				velocity -= get_gravity() * delta
			pass
		State.SPAWNING:
			slide(delta)
			if not is_on_floor():
				velocity -= get_gravity() * delta
			spawnTimer += delta
			if spawnEmitters.size() > 0:
				if spawnTimer > SPAWN_SHOW_TIME:
					spriteParent.visible = true
			pass
		State.DYING:
			
			pass
		State.DISABLE_PHYSICS:
			pass

func _try_wall_jump():
	if leftWallRay.is_colliding() and leftWallRay.get_collision_normal() == Vector2.RIGHT:
		wall_jump(1)
	if rightWallRay.is_colliding() and rightWallRay.get_collision_normal() == Vector2.LEFT:
		wall_jump(-1)

func wall_jump(dir: int):
	velocity.y = WALL_JUMP_VELOCITY.y
	velocity.x = dir * WALL_JUMP_VELOCITY.x
	#set_direction(dir)
	pass

func freeze():
	set_state(Player.State.DISABLE_PHYSICS)

func unfreeze():
	set_state(Player.State.FREE)

func get_gun_aim_vector() -> Vector2:
	if abs(inputVector.y) > INPUT_DEADZONE:
		if isDucking:
			if inputVector.y > INPUT_DEADZONE:
				return Vector2(direction, 0)
			else:
				return Vector2(0, inputVector.y)
		return Vector2(0, inputVector.y)
	else:
		return Vector2(direction, 0)

func collide(delta: float):
	var collision_count := 0
	var collision = move_and_collide(Vector2(velocity.x, -velocity.y) * delta)
	while collision and collision_count < MAX_COLLISIONS:
		var normal = collision.get_normal()
		var remainder = collision.get_remainder()
		velocity = Vector2(velocity.x + (-1 * abs(normal.x) * velocity.x), velocity.y + (-1 * abs(normal.y) * velocity.y))
		remainder = Vector2(remainder.x + (-1 * abs(normal.x) * remainder.x), remainder.y + (-1 * abs(normal.y) * remainder.y))
		
		collision_count += 1
		collision = move_and_collide(remainder)
		pass
	pass

func disable_input():
	set_state(State.DISABLE_INPUT)

func enable_input():
	set_state(State.FREE)
	
func set_state(newState: State):
	state = newState
	match state:
		State.FREE:
			spriteParent.visible = true
			pass
		State.DISABLE_INPUT:
			pass
		State.SPAWNING:
			@warning_ignore("unused_variable")
			var temp = 0
			for i in range(0, spawnEmitters.size()):
				if spawnEmitters[i]:
					spawnEmitters[i].queue_free()
			spawnEmitters.clear()
			spawnTimer = 0
			spriteParent.visible = false
			for i in range(0, 3):
				spawnEmitters.append(await G.spawn(spawnEmitterScene))
			
			spawnEmitters[0].global_position = centerBody.global_position
			spawnEmitters[0].process_material = spawnEmitters[1].process_material.duplicate()
			spawnEmitters[0].process_material.set("color", "6927C0")
			spawnEmitters[1].process_material = spawnEmitters[1].process_material.duplicate()
			spawnEmitters[1].process_material.set("color", "dc6ea5")
			spawnEmitters[1].global_position = centerBody.global_position + Vector2.UP
			spawnEmitters[2].global_position = centerHead.global_position
			
			if not spawnEmitters[0].dead.is_connected(_spawning_ended):
				spawnEmitters[0].dead.connect(_spawning_ended)
			pass
		State.DYING:
			spriteParent.visible = false
			for i in range(0, 3):
				spawnEmitters.append(await G.spawn(spawnEmitterScene))
			
			spawnEmitters[0].global_position = centerBody.global_position
			
			spawnEmitters[0].dead.connect(_dying_ended)
			pass
		State.DISABLE_COMPLETELY:
			spriteParent.visible = false
		State.DISABLE_PHYSICS:
			spriteParent.visible = true
	pass
	
signal dying_finished
func _dying_ended():
	for i in range(0, spawnEmitters.size()):
		if spawnEmitters[i]:
			spawnEmitters[i].queue_free()
	spawnEmitters.clear()
	
	dying_finished.emit()

func _spawning_ended():
	for i in range(0, spawnEmitters.size()):
		if spawnEmitters[i]:
			spawnEmitters[i].queue_free()
	spawnEmitters.clear()
	
	plyr_spawning_anim_finished.emit()

func slide(delta: float):
	velocity.y = -velocity.y
	
	var preCollsionVelocity: Vector2 = velocity
	var collided = move_and_slide()
	if collided:
		var collision = get_last_slide_collision()
		var normal = collision.get_normal()
		
		var justOnGround: bool = isOnGround
		isOnGround = len(groundDetect.get_overlapping_bodies()) > 0
		
		if justOnGround != isOnGround:
			pass
		
		var friction: float = FRICTION_MULT
		if isDuckingSlide:
			friction = SLIDE_FRICTION_MULT
			pass
		
		@warning_ignore("unused_variable")
		var temp: Vector2 = velocity
		if normal.y < 0 and normal.y != -1:
			if abs(inputVector.y) > INPUT_DEADZONE:
				if not isOnGroundOld:
					velocity = velocity.normalized() * 0.7
					velocity = normal.orthogonal() * -sign(normal.x)
					if abs(preCollsionVelocity.y) > abs(preCollsionVelocity.x):
						velocity += preCollsionVelocity.y * velocity.normalized()
					else:
						velocity *= -1
						velocity += abs(preCollsionVelocity.x) * velocity.normalized()
						pass
					#friction = SLIDE_SLANT_FRICTION_MULT
					
					lastVelSlant = velocity
					$testray.target_position = velocity
			else:
				velocity = velocity.slide(normal)
		velocity.x += -velocity.x * friction * delta
		pass
		
	velocity.y = -velocity.y
	isOnGroundOld = isOnGround

var lastVelSlant: Vector2

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

func reset():
	velocity = Vector2.ZERO
	if gun:
		gun.reset()
	pass

func reset_and_spawn():
	reset()
	set_state(State.SPAWNING)
	
