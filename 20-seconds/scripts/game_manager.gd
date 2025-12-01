class_name GameManager
extends Node2D

enum State {TITLE_SCREEN=0, IN_GAME=1, PAUSED=2, END=3}

var gameSaveInfo: SaveInfo.GameInfo = SaveInfo.GameInfo.new()

var state: State = State.IN_GAME

var levelIndex = 0
var curLevelObj: Level
var levelPaths: Array[String]


var backgrounds: Array[Background] = []

const BACKGROUND_COUNT: int = 3
const BACKGROUND_SCALE_MULT: float = 1
const BACKGROUND_SPEED_MULT: float = 0.5
const BACKGROUND_ALPHA_MULT: float = 0.8

var inGameUI: InGameUI
var inGameUIScene: PackedScene = preload("res://scenes/ingame_ui.tscn")

var levelSelect: LevelSelect
var levelSelectScene: PackedScene = preload("res://scenes/level_select.tscn")

var pauseScreen: PauseScreen
var pauseScreenScene: PackedScene = preload("res://scenes/pause_screen.tscn")

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

var palettes = {
	"jump" : Color.hex(0x8769ffff),
	"crouch" : Color.hex(0xffc857ff),
	"walljump" : Color.hex(0xd479c8ff),
	"gun" : Color.hex(0x00b459ff),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	levelPaths.append("res://levels/intro_level.tscn");
	levelPaths.append("res://levels/level1.tscn");
	levelPaths.append("res://levels/level2.tscn");
	levelPaths.append("res://levels/level3.tscn");
	levelPaths.append("res://levels/level wj1.tscn");
	levelPaths.append("res://levels/level wj2.tscn");
	levelPaths.append("res://levels/level wj3.tscn");
	levelPaths.append("res://levels/level wj4.tscn");
	levelPaths.append("res://levels/level crouch1.tscn");
	levelPaths.append("res://levels/level crouchslide1.tscn");
	levelPaths.append("res://levels/level slantslide1.tscn");
	levelPaths.append("res://levels/level gun1.tscn");
	levelPaths.append("res://levels/level gun2.tscn");
	levelPaths.append("res://levels/level gunhold.tscn");
	levelPaths.append("res://levels/level gunhold2.tscn");
	levelPaths.append("res://levels/level gun island.tscn");
	levelPaths.append("res://levels/big level with slants.tscn");
	levelPaths.append("res://levels/slant heaven.tscn");
	await load_titlescreen()
	spawn_backgrounds()
	
	load_save_info()
	pass # Replace with function body.

func load_save_info():
	for i in range(0, levelPaths.size()):
		gameSaveInfo.levelInfos.append(SaveInfo.LevelInfo.new())
		if i == 0:
			gameSaveInfo.levelInfos.back().selectable = false
			pass
	gameSaveInfo.lastLevelBeat = levelPaths.size()

func spawn_backgrounds():
	for i in range(0, BACKGROUND_COUNT):
		backgrounds.append(await spawn(load("res://scenes/background.tscn")))
		if i == 0:
			continue
		backgrounds.back().z_index -= i
		backgrounds.back().OFFSET_SPEED *= BACKGROUND_SPEED_MULT/i
		backgrounds.back().texture_scale *= BACKGROUND_SCALE_MULT * i
		backgrounds.back().color.a *= BACKGROUND_ALPHA_MULT/(i * 0.01)
		pass

func pause_backgrounds():
	for i in range(0, backgrounds.size()):
		backgrounds[i].isActive = false

func resume_backgrounds():
	for i in range(0, backgrounds.size()):
		backgrounds[i].isActive = true

func set_backgrounds_color(color:Color):
	for i in range(0, backgrounds.size()):
		backgrounds[i].set_background_color(color)

func set_backgrounds_color_from_level(level: Level):
	if level.paletteName == "":
		set_backgrounds_color(level.color)
	else:
		set_backgrounds_color(palettes[level.paletteName])

func load_titlescreen():
	state = State.TITLE_SCREEN
	titleScreen = await spawn(load("res://scenes/title_screen.tscn"))
	titleScreen.startPressed.connect(start_game)

func load_level_select():
	if levelSelect:
		return
	if titleScreen:
		titleScreen.queue_free()
	if pauseScreen:
		pauseScreen.queue_free()
	levelSelect = await spawn(levelSelectScene)
	levelSelect.initialize(gameSaveInfo)
	levelSelect.level_selected.connect(load_level)

func spawn_ui():
	inGameUI = await spawn(inGameUIScene)
	inGameUI.textbox.textboxClosed.connect(message_box_finished)
	inGameUI.timer.timeRanOut.connect(restart_current_level)
	gm_levelInputStarted.connect(inGameUI.timer.start_timer)
	gm_level_goal_reached.connect(inGameUI.timer.pause_timer)
	gm_pause.connect(inGameUI.timer.pause_timer)
	gm_resume.connect(inGameUI.timer.resume_timer)
	sendMessageQueue.connect(inGameUI.textbox.add_queue)

signal gm_resume
func resume_game():
	state = State.IN_GAME
	gm_resume.emit()
	resume_backgrounds()
	if levelSelect:
		levelSelect.queue_free()
	if pauseScreen:
		pauseScreen.queue_free()

signal gm_pause
func pause_game():
	state = State.PAUSED
	gm_pause.emit()
	pause_backgrounds()
	if not pauseScreen:
		load_pause_screen()

func load_pause_screen():
	pauseScreen = await spawn(pauseScreenScene)
	pauseScreen.btnResume.pressed.connect(resume_game)
	pauseScreen.btnLevelSelect.pressed.connect(load_level_select)

func start_game(loadLevel: bool = true):
	if titleScreen:
		titleScreen.queue_free()
	state = State.IN_GAME
	await spawn_ui()
	if loadLevel:
		await load_level(0)
	pass

func restart_current_level():
	await player.instantly_die()
	load_current_level(true)
	print("level restarted")
	pass

func restart_game():
	unload_current_level()
	load_intro()

func load_intro():
	#Game.gameUI.centerText.set_color(Color.WHITE)
	state = State.IN_GAME

func intro_ended():
	#intro.queue_free()
	load_level(0)
	state = State.IN_GAME
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
		State.TITLE_SCREEN:
			pass
		State.IN_GAME:
			pass
		State.PAUSED:
			pass
		State.END:
			pass
	pass

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	match state:
		State.TITLE_SCREEN:
			if Input.is_action_just_pressed("pause"):
				load_level_select()
			pass
		State.IN_GAME:
			if Input.is_action_just_pressed("pause"):
				if curLevelObj:
					if curLevelObj.state == Level.State.IN_PROGRESS:
						pause_game()
			if Input.is_action_just_pressed("restart"):
				if curLevelObj:
					if curLevelObj.state == Level.State.IN_PROGRESS:
						restart_current_level()
		State.PAUSED:
			if Input.is_action_just_pressed("pause"):
				resume_game()
				pass
			pass
		State.END:
			pass
	pass

func next_level():
	if gameSaveInfo:
		gameSaveInfo.levelInfos[levelIndex].timesFinished += 1
		if gameSaveInfo.lastLevelBeat < levelIndex:
			gameSaveInfo.lastLevelBeat = levelIndex
			pass 
		if inGameUI.timer.timer:
			if gameSaveInfo.levelInfos[levelIndex].bestTime < inGameUI.timer.timer:
				gameSaveInfo.levelInfos[levelIndex].bestTime = inGameUI.timer.timer
	
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

func load_current_level(isRetry: bool = false):
	load_level(levelIndex, isRetry)

signal gm_levelInputStarted
func load_level(index: int, isRetry = false) -> bool:
	if index < len(levelPaths):
		state = State.IN_GAME
		
		if index == levelIndex:
			if player:
				player.global_position = curLevelObj.start.global_position
		
		levelIndex = index
		if levelSelect:
			levelSelect.queue_free()
		if curLevelObj:
			gm_message_box_finished.disconnect(curLevelObj._message_box_finished)
			gm_player_spawning_anim_finished.disconnect(curLevelObj._player_spawning_animation_finished)
			gm_player_spawning_load_finished.disconnect(curLevelObj._player_spawning_loading_finished)
			curLevelObj.queue_free()
			await get_tree().process_frame
			
		#gameUI.centerText.set_center_text("", 0, 0)
		curLevelObj = await spawn(load(levelPaths[index]))
		curLevelObj.levelConcluded.connect(next_level)
		curLevelObj.levelInputStarted.connect(_level_input_started)
		curLevelObj.levelGoalReached.connect(_level_goal_reached)
		curLevelObj.index = index
		
		gameSaveInfo.levelInfos[index].timesStarted += 1
		
		gm_message_box_finished.connect(curLevelObj._message_box_finished)
		gm_player_spawning_anim_finished.connect(curLevelObj._player_spawning_animation_finished)
		gm_player_spawning_load_finished.connect(curLevelObj._player_spawning_loading_finished)
		
		levelLoaded.connect(curLevelObj._loaded)
		
		if isRetry:
			curLevelObj.HAS_INTRO = false
		
		
		set_backgrounds_color_from_level(curLevelObj)
		resume_backgrounds()
		
		if not player:
			await spawn_player()
		gm_player_spawning_load_finished.emit()
		if not camera:
			await spawn_camera()
			
		reset_player()
		player.global_position = curLevelObj.start.global_position
		camera.global_position = player.global_position
		
		if not inGameUI:
			await spawn_ui()
		inGameUI.timer.set_timer()
		levelLoaded.emit()
		return true
	return false

signal gm_level_goal_reached
func _level_goal_reached():
	gm_level_goal_reached.emit()
	pause_backgrounds()

func _level_input_started():
	gm_levelInputStarted.emit()

func spawn_camera():
	camera = await spawn(cameraScene)
	levelLoaded.connect(camera._level_loaded)

func spawn_player():
	player = await spawn(playerScene)
	gm_levelInputStarted.connect(player.enable_input)
	disablePlayerInput.connect(player.disable_input)
	gm_level_goal_reached.connect(player.freeze)
	gm_pause.connect(player.freeze)
	gm_resume.connect(player.unfreeze)
	
	player.plyr_spawning_anim_finished.connect(_player_spawning_anim_finished)
	player.dying_finished.connect(restart_current_level)
	

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
