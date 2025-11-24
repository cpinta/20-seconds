class_name GameManager
extends Node2D

enum GameState {TITLE_SCREEN=0, IN_GAME=1, PAUSED=2, END=3}

var state: GameState = GameState.IN_GAME

var levelIndex = 0
var curLevelObj: Level
var levelPaths: Array[String]

var inGameUI: InGameUI
var inGameUIScene: PackedScene = preload("res://scenes/ingame_ui.tscn")

var player: Player
var playerScene: PackedScene = preload("res://scenes/player.tscn")

var camera: GameCamera
var cameraScene: PackedScene = preload("res://scenes/game_camera.tscn")

var coinCount: int = 0

var debug: bool = true

var audio: AudioStreamPlayer2D

signal disablePlayerInput()
signal sendMessageQueue(messages: Array[Textbox.MsgInfo])
signal levelLoaded()

# Called when the node enters the scene tree for the first time.
func _ready():
	#gameUI = $UI
	inGameUI = await spawn(inGameUIScene)
	inGameUI.textbox.textboxClosed.connect(message_box_finished)
	inGameUI.timer.timeRanOut.connect(restart_current_level)
	gm_levelInputStarted.connect(inGameUI.timer.start_timer)
	gm_level_goal_reached.connect(inGameUI.timer.pause_timer)
	
	sendMessageQueue.connect(inGameUI.textbox.add_queue)
	
	
	levelPaths.append("res://levels/test_level.tscn");
	#levelPaths.append("res://levels/test_level2.tscn");
	load_level(0)
	
	#load_level(0)
	pass # Replace with function body.

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
		levelLoaded.connect(curLevelObj._loaded)
		
		if not player:
			await spawn_player()
		else:
			player.set_state(Player.State.SPAWNING)
		if not camera:
			await spawn_camera()
			
		player.global_position = curLevelObj.start.global_position
		reset_player()
		camera.global_position = player.global_position
		curLevelObj.levelConcluded.connect(next_level)
		curLevelObj.levelInputStarted.connect(_level_input_started)
		curLevelObj.levelGoalReeached.connect(_level_goal_reached)
		gm_message_box_finished.connect(curLevelObj._message_box_finished)
		
		player_spawning_finished.connect(curLevelObj._player_spawning_finished)
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
	pass

func spawn_player():
	player = await spawn(playerScene)
	gm_levelInputStarted.connect(player.enable_input)
	disablePlayerInput.connect(player.disable_input)
	player.spawning_finished.connect(_player_spawning_finished)
	player.set_state(Player.State.SPAWNING)
	pass

signal player_spawning_finished
func _player_spawning_finished():
	player_spawning_finished.emit()
	pass

func reset_player():
	player.reset()
	pass

func unload_current_level():
	if curLevelObj != null:
		curLevelObj.queue_free()
	
func load_level_path(str: String):
	if curLevelObj != null:
		curLevelObj.queue_free()
		#gameUI.centerText.set_center_text("", 0, 0)
		curLevelObj = load(str).instantiate()
		if player == null:
			if get_tree().get_node_count_in_group("player") > 0:
				player = get_tree().get_nodes_in_group("player")[0]
				#player.justDied.connect(load_death_screen)
			pass
		pass
		player.position = Vector2(48, -48)
		self.add_child.call_deferred(curLevelObj)
		
		
		#player.position = get_tree().get_nodes_in_group("start")[0].global_position
		#player.position = curLevelObj.start.position
		return true
		pass
	pass
