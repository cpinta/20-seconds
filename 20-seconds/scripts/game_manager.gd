class_name GameManager
extends Node2D

enum GameState {TITLE_SCREEN=0, IN_GAME=1, PAUSED=2, END=3}

var state: GameState = GameState.IN_GAME

var levelIndex = 0
var curLevelObj: Level
var levelPaths: Array[String]

var inGameUI: InGameUI
var inGameUIScene: PackedScene = preload("res://scenes/ingame_ui.tscn")

var titleScreen: TitleScreen

var player: Player
var playerScene: PackedScene = preload("res://scenes/player.tscn")

var camera: GameCamera
var cameraScene: PackedScene = preload("res://scenes/game_camera.tscn")

var coinCount: int = 0

var debug: bool = true

var audio: AudioStreamPlayer2D

var agentName: String = "AGENT"

signal disablePlayerInput()
signal sendMessageQueue(messages: Array[Textbox.MsgInfo])
signal levelLoaded()

# Called when the node enters the scene tree for the first time.
func _ready():
	levelPaths.append("res://levels/intro_level.tscn");
	levelPaths.append("res://levels/level1.tscn");
	levelPaths.append("res://levels/test_level2.tscn");
	load_titlescreen()
	
	#load_level(0)
	pass # Replace with function body.

func load_titlescreen():
	titleScreen = await spawn(load("res://scenes/title_screen.tscn"))
	titleScreen.startPressed.connect(start_game)

func spawn_ui():
	inGameUI = await spawn(inGameUIScene)
	inGameUI.textbox.textboxClosed.connect(message_box_finished)
	inGameUI.timer.timeRanOut.connect(restart_current_level)
	gm_levelInputStarted.connect(inGameUI.timer.start_timer)
	gm_level_goal_reached.connect(inGameUI.timer.pause_timer)
	sendMessageQueue.connect(inGameUI.textbox.add_queue)

func start_game():
	titleScreen.queue_free()
	spawn_ui()
	load_level(0)
	pass

func restart_current_level():
	player.set_state(Player.State.SPAWNING)
	load_current_level()
	pass

func restart_game():
	unload_current_level()
	load_intro()

func load_intro():
	#Game.gameUI.centerText.set_color(Color.WHITE)
	state = GameState.IN_GAME

func intro_ended():
	#intro.queue_free()
	load_level(0)
	state = GameState.IN_GAME
	pass

func play_sound(stream: AudioStream):
	audio.stream = stream
	audio.play()
	pass

func spawn(scene: PackedScene):
	var node = scene.instantiate()
	self.add_child.call_deferred(node)
	if not node.is_inside_tree():
		await node.ready
	return node


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	match state:
		GameState.TITLE_SCREEN:
			pass
		GameState.IN_GAME:
			pass
		GameState.PAUSED:
			pass
		GameState.END:
			pass
	pass

func next_level():
	levelIndex += 1
	if await(load_level(levelIndex)):
		
		pass
	else:
		
		pass
	
	pass
	
func send_queue_to_message_box(messages: Array[Textbox.MsgInfo]):
	sendMessageQueue.emit(messages)
	disablePlayerInput.emit()
	pass

signal gm_message_box_finished
func message_box_finished():
	gm_message_box_finished.emit()
	pass

func load_current_level():
	load_level(levelIndex)

signal gm_levelInputStarted
func load_level(index: int) -> bool:
	if index < len(levelPaths):
		if curLevelObj != null:
			curLevelObj.queue_free()
		#gameUI.centerText.set_center_text("", 0, 0)
		curLevelObj = await spawn(load(levelPaths[index]))
		curLevelObj.levelConcluded.connect(next_level)
		curLevelObj.levelInputStarted.connect(_level_input_started)
		curLevelObj.levelGoalReeached.connect(_level_goal_reached)
		gm_message_box_finished.connect(curLevelObj._message_box_finished)
		gm_player_spawning_anim_finished.connect(curLevelObj._player_spawning_animation_finished)
		gm_player_spawning_load_finished.connect(curLevelObj._player_spawning_loading_finished)
		
		levelLoaded.connect(curLevelObj._loaded)
		
		if not player:
			await spawn_player()
		gm_player_spawning_load_finished.emit()
		if not camera:
			await spawn_camera()
			
		reset_player()
		player.global_position = curLevelObj.start.global_position
		camera.global_position = player.global_position
		
		inGameUI.timer.set_timer()
		levelLoaded.emit()
		return true
	return false

signal gm_level_goal_reached
func _level_goal_reached():
	gm_level_goal_reached.emit()
	pass

func _level_input_started():
	gm_levelInputStarted.emit()

func spawn_camera():
	camera = await spawn(cameraScene)
	levelLoaded.connect(camera._level_loaded)

func spawn_player():
	player = await spawn(playerScene)
	gm_levelInputStarted.connect(player.enable_input)
	disablePlayerInput.connect(player.disable_input)
	player.plyr_spawning_anim_finished.connect(_player_spawning_anim_finished)

signal gm_player_spawning_anim_finished()
func _player_spawning_anim_finished():
	gm_player_spawning_anim_finished.emit()

signal gm_player_spawning_load_finished()
	
func reset_player():
	player.reset()

func reset_and_spawn_anim_player():
	player.reset_and_spawn()


func unload_current_level():
	if curLevelObj != null:
		curLevelObj.queue_free()
	
func load_level_path(string: String):
	if curLevelObj != null:
		curLevelObj.queue_free()
		#gameUI.centerText.set_center_text("", 0, 0)
		curLevelObj = load(string).instantiate()
		if player == null:
			if get_tree().get_node_count_in_group("player") > 0:
				player = get_tree().get_nodes_in_group("player")[0]
				#player.justDied.connect(load_death_screen)
			pass
		pass
		player.position = Vector2(48, -48)
		self.add_child.call_deferred(curLevelObj)
		return true
	pass
