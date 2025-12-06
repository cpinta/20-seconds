class_name BossLevel
extends Node2D

enum State {
	PRE_LEVEL,
	IN_PROGRESS,
	POST_LEVEL
}

var state: State = State.PRE_LEVEL

var tiles: TilesPlatform
@export var color: Color = Color.CORNFLOWER_BLUE
@export var paletteName: String = ""

var closeExitTiles: TilesPlatform


var audio: AudioStreamPlayer

var start: Node2D
var bigtargetpos: Node2D

var endPos: Node2D
var endPosRadius: float = 0

var targets: Array[Target] = []
var targetTotal: int

var closeExitPos: Vector2

const TARGET_HIT_PITCH_BASE: float = 0.2
const TARGET_HIT_PITCH_MAX: float = 1

# pre concluded
signal bosslevelGoalReached
signal bosslevelTimerStart
signal targetHit

func _init():
	pass

func _ready():
	tiles = $platform
	var keys: Array = G.palettes.keys()
	tiles.color = G.palettes[keys[randi_range(0, keys.size()-1)]]
	closeExitTiles = $closeexit
	closeExitPos = closeExitTiles.global_position
	closeExitTiles.global_position = Vector2(10000, -1000)
	closeExitTiles.visible = false
	start = $start
	start.global_position.y -= 0.012
	
	bigtargetpos = $BigTargetPos
	
	endPos = $end
	endPosRadius = ($end/CollisionShape2D.shape as CircleShape2D).radius
	
	find_descendant_target_nodes(self)
	
	targetTotal = targets.size()
	
	audio = AudioStreamPlayer.new()
	self.add_child.call_deferred(audio)
	if not audio.is_inside_tree():
		await audio.ready
	audio.reparent(self)
	audio.stream = load("res://audio/kalimba4.mp3")

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	
	
	if playerInside:
		if G.player.isOnGround:
			boss_level_beat()
	pass

func _physics_process(delta: float) -> void:
	if G.player.global_position.distance_to(endPos.global_position) < endPosRadius:
		playerInside = true
		pass
	else:
		playerInside = false
		pass

var playerInside: bool = false

func boss_level_beat():
	bosslevelGoalReached.emit()
	pass

func find_descendant_target_nodes(node: Node):
	for child in node.get_children():
		if child.is_in_group("target"):
			targets.append(child)
			targets.back().wasDestroyed.connect(target_was_destroyed)
		find_descendant_target_nodes(child)

func set_descendant_tiles_color(node: Node, color: Color):
	for child in node.get_children():
		if child is TilesPlatform:
			child.set_color(color)
		set_descendant_tiles_color(child, color)

# called when level is first loaded
func _loaded():
	pass

@warning_ignore("shadowed_variable")
func set_level_color(color: Color):
	tiles.set_color(color)
	pass

func target_was_destroyed(target: Target):
	target.wasDestroyed.disconnect(target_was_destroyed)
	targets.erase(target)
	targetHit.emit()
	audio.pitch_scale = ((targetTotal - targets.size())/float(targetTotal)) * (TARGET_HIT_PITCH_MAX - TARGET_HIT_PITCH_BASE) + TARGET_HIT_PITCH_BASE
	audio.play()
	if targets.size() == 0:
		
		pass
	pass
