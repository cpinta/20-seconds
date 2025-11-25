class_name Level
extends Node2D

var tiles: TilesPlatform
@export var color: Color
var start: Node2D

var targets: Array[Target] = []

const POST_TARGET_BREAK_WAIT: float = 2
var HAS_POST_LEVEL_SCENE: bool = false

var HAS_INTRO: bool = false

# pre concluded
signal levelGoalReeached
# last action done by level
signal levelConcluded
signal levelInputStarted

# Called when the node enters the scene tree for the first time.
func _init():
	pass

func _ready():
	tiles = $platform
	start = $start
	
	set_level_color(color)
	var targetCount: int = get_tree().get_node_count_in_group("target")
	if targetCount > 0:
		for i in range(0, targetCount):
			targets.append(get_tree().get_nodes_in_group("target")[i])
			targets.back().wasDestroyed.connect(target_was_destroyed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	pass

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
	if targets.size() == 0:
		levelGoalReeached.emit()
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
	pass

func _player_spawning_loading_finished():
	G.player.set_state(Player.State.SPAWNING)

# called post level intro
func _start_level_input():
	levelInputStarted.emit()
	pass

func _message_box_finished():
	pass

# needs to call levelConcluded.emit() at some point
func _post_level():
	pass
