class_name Level
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

var audio: AudioStreamPlayer

var start: Node2D

# index is set by GameManager
var index: int = -1

var targets: Array[Target] = []
var targetTotal: int

const POST_TARGET_BREAK_WAIT: float = 3
var HAS_POST_LEVEL_SCENE: bool = false

var HAS_INTRO: bool = false
@export var HAS_GUN: bool = true
var SELECTABLE: bool = true

# pre concluded
signal levelGoalReached
# last action done by level object
signal levelConcluded
signal levelInputStarted

const TARGET_HIT_PITCH_BASE: float = 0.2
const TARGET_HIT_PITCH_MAX: float = 1

func _init():
	pass

func _ready():
	tiles = $platform
	start = $start
	start.global_position.y -= 0.012
	
	if paletteName == "":
		set_descendant_tiles_color(self, color)
	else:
		set_descendant_tiles_color(self, G.palettes[paletteName])
		
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
	audio.pitch_scale = ((targetTotal - targets.size())/float(targetTotal)) * (TARGET_HIT_PITCH_MAX - TARGET_HIT_PITCH_BASE) + TARGET_HIT_PITCH_BASE
	audio.play()
	if targets.size() == 0:
		state = State.POST_LEVEL
		levelGoalReached.emit()
		await get_tree().create_timer(POST_TARGET_BREAK_WAIT, true, false, true).timeout
		if not HAS_POST_LEVEL_SCENE:
			levelConcluded.emit()
		else:
			_post_level()
		pass
	pass

# called when player spawning animation is done
# if HAS_INTRO, intro must call levelInputStarted
func _player_spawning_animation_finished():
	if HAS_INTRO:
		G.player.set_state(Player.State.DISABLE_INPUT)
		pass
	else:
		_start_level_input()
		pass

func _player_spawning_loading_finished():
	G.player.set_state(Player.State.SPAWNING)
	if HAS_GUN:
		if not G.player.gun:
			G.player.spawn_gun()
	else:
		if G.player.gun:
			G.player.despawn_gun()

# called post level intro
func _start_level_input():
	levelInputStarted.emit()
	state = State.IN_PROGRESS
	pass

func _message_box_finished():
	pass

# needs to call levelConcluded.emit() at some point
func _post_level():
	pass
