extends Weapon
class_name Gun

var sprite: Sprite2D

var gunPoint: Node2D
var gunPointPos: Vector2
var bulletScene: PackedScene = preload("res://scenes/base_bullet.tscn")
var bulletHeavyScene: PackedScene = preload("res://scenes/base_bullet_heavy.tscn")
var chargeSprite: Sprite2D

const CHARGE_SCALE_MIN: float = 0.015
const CHARGE_SCALE_MAX: float = 0.1
const CHARGE_LERP: float = 20
var chargeIsShrinking: bool = false

var isCharging: bool = false

var emitterScene: PackedScene = preload("res://scenes/gun_emitter.tscn")

var gunPointScale: float = 0.01

var activeBullets: Array[Bullet] = []

var audio: AudioStreamPlayer
var asSmallShot: Array[AudioStream] = [
	load("res://audio/spow1.mp3"),
	load("res://audio/spow2.mp3"),
	load("res://audio/spow3.mp3"),
]
var asLargeShot: AudioStream = load("res://audio/big shot.mp3")
var asCharge: AudioStream = load("res://audio/gun charge.mp3")

func _ready() -> void:
	sprite = $gun
	gunPoint = $gun/gunPoint
	gunPointPos = gunPoint.position
	audio = $AudioStreamPlayer
	chargeSprite = $gun/gunPoint/chargeSprite
	chargeSprite.visible = false

func play_sound(stream: AudioStream):
	if stream == asLargeShot:
		pass
	else:
		audio.pitch_scale = 1
	audio.pitch_scale = randf_range(0.9, 1.5)
		
	audio.stream = stream
	audio.play()

func play_random_sound(arr: Array[AudioStream]):
	play_sound(arr.pick_random())

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if isCharging:
		chargeSprite.visible = true
		if chargeIsShrinking:
			if chargeSprite.scale.y > CHARGE_SCALE_MIN + 0.01:
				chargeSprite.scale = lerp(chargeSprite.scale, Vector2.ONE * CHARGE_SCALE_MIN, CHARGE_LERP * delta)
			else:
				chargeIsShrinking = false
		else:
			if chargeSprite.scale.y < CHARGE_SCALE_MAX - 0.01:
				chargeSprite.scale = lerp(chargeSprite.scale, Vector2.ONE * CHARGE_SCALE_MAX, CHARGE_LERP * delta)
			else:
				chargeIsShrinking = true
		
		if not audio.playing:
			play_sound(asCharge)
	else:
		chargeSprite.visible = false
	pass

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	pass

func use_item(dir: Vector2, isCharged: bool):
	super.use_item(dir, isCharged)
	shoot_bullet(dir, isCharged)

func shoot_bullet(dir: Vector2, isCharged: bool):
	var bullet: Bullet = null
	if isCharged:
		emit(dir)
		bullet = await G.spawn(bulletHeavyScene)
		bullet.global_position = gunPoint.global_position
		if dir.x != 0:
			bullet.global_position.y = holder.global_position.y - (bullet.shape.shape.height/4 * bullet.desiredScale)
			pass
		play_sound(asLargeShot)
	else:
		emit(dir)
		bullet = await G.spawn(bulletScene)
		bullet.global_position = gunPoint.global_position
		play_random_sound(asSmallShot)
	bullet.initialize(holder, dir)
	bullet.rotation = dir.angle()
	bullet.wasDestroyed.connect(bullet_was_destroyed)
	activeBullets.append(bullet)
	pass

func emit(dir: Vector2):
	var emitter: GPUParticles2D = await G.spawn(emitterScene)
	emitter.global_position = gunPoint.global_position
	emitter.rotation = dir.angle()
	
func set_direction(dir: Vector2):
	if dir.x > 0:
		sprite.flip_h = false
		gunPoint.position.x = gunPointPos.x
	else:
		sprite.flip_h = true
		gunPoint.position.x = -gunPointPos.x
	pass

func bullet_was_destroyed(bullet: Bullet):
	activeBullets.erase(bullet)
	pass

func reset():
	super.reset()
	for i in range(0, activeBullets.size()):
		if activeBullets[i]:
			activeBullets[i].queue_free()
		pass
	activeBullets.clear()
	pass
