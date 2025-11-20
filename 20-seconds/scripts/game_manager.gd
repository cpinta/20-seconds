class_name GameManager
extends Node2D

enum GameState {TITLE_SCREEN=0, IN_GAME=1, PAUSED=2, END=3}

var state: GameState = GameState.IN_GAME

var levelIndex = 0
var curLevelObj: Level
var levelPaths: Array[String]

#var gameUI: UI

var player: Player

var coinCount: int = 0

var audio: AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#gameUI = $UI
	load_intro()
	
	
	levelPaths.append("res://levels/level_1.tscn");
	
	#load_level(0)
	pass # Replace with function body.

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
	self.add_child(node)
	if not node.is_inside_tree():
		await node.ready
	return node
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	match state:
		GameState.TITLE_SCREEN:
			pass
		GameState.IN_GAME:
			if player == null:
				if get_tree().get_node_count_in_group("player") > 0:
					player = get_tree().get_nodes_in_group("player")[0]
					#player.justDied.connect(load_death_screen)
				pass
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
	
func speak_for_time(text: String, time:float, shake:float = 0):
	#gameUI.centerText.set_center_text(text, time, shake)
	await get_tree().create_timer(time, true, false, true).timeout
	pass


	
func load_level(index: int):
	if index < len(levelPaths):
		if curLevelObj != null:
			curLevelObj.queue_free()
		#gameUI.centerText.set_center_text("", 0, 0)
		curLevelObj = load(levelPaths[index]).instantiate()
		if player == null:
			if get_tree().get_node_count_in_group("player") > 0:
				player = get_tree().get_nodes_in_group("player")[0]
				#player.justDied.connect(load_death_screen)
			pass
		pass
		player.position = Vector2(48, -64)
		self.add_child.call_deferred(curLevelObj)
		
		#player.position = get_tree().get_nodes_in_group("start")[0].global_position
		#player.position = curLevelObj.start.position
		return true
		pass
	return false
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
