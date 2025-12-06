extends Level

const CAMERA_ZOOM: float = 1

var bossLevels: Array[PackedScene]= [
	load("res://levels/boss level1.tscn"),
	load("res://levels/bosslevel2.tscn"),
	load("res://levels/bosslevel3.tscn")
]


enum BossPhase{
	SHOWINGUP,
	HERE,
	DYING
}

var phase: BossPhase = BossPhase.SHOWINGUP

var bigTarget: BigTarget
var currentBossLevel: BossLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	HAS_INTRO = true
	HAS_GUN = true
	bigTarget = $"big target"
	bigTarget.targetDied.connect(_target_died)
	G.isBossFight = false
	
	pass # Replace with function body.

func _target_died():
	G.inGameUI.timer.pause_timer()
	msg_progress = 20
	G.player.set_state(Player.State.DISABLE_COMPLETELY)
	currentBossLevel.queue_free()
	bigTarget.queue_free()
	G.isBossFight = false
	var queue: Array[Textbox.MsgInfo] = [
		Textbox.MsgInfo.new(G.agentName, "Mr. Arms! Agent Bear Arms! You did it!", Textbox.Mode.PerChar,0, TextboxPortrait.Emotion.Surprised),
		Textbox.MsgInfo.new(G.agentName, "The corrupted target was defeated!", Textbox.Mode.PerChar,0, TextboxPortrait.Emotion.Surprised),
		Textbox.MsgInfo.new(G.agentName, "Alright, wanna go get lunch or something?", Textbox.Mode.PerChar),
	]
	G.send_queue_to_message_box(queue)
	pass

var firstDest: Vector2 = Vector2(0, -75)

func _loaded():
	super._loaded()
	G.inGameUI.show_ui()
	#G.camera.useBaseZoom = false
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	
	match(phase):
		BossPhase.SHOWINGUP:
			pass
		BossPhase.HERE:
			pass
		BossPhase.DYING:
			pass
	
	pass

func _player_spawning_animation_finished():
	super._player_spawning_animation_finished()
	
	if not HAS_INTRO:
		return
	var queue: Array[Textbox.MsgInfo] = [
		Textbox.MsgInfo.new(G.agentName, "Agent, I have no clue what is happening!!", Textbox.Mode.PerChar,0, TextboxPortrait.Emotion.Surprised),
		Textbox.MsgInfo.new(G.agentName, "Everything seems to be out of my control!!", Textbox.Mode.PerChar,0, TextboxPortrait.Emotion.Surprised),
		Textbox.MsgInfo.new(G.agentName, "Don't move a muscle! I don't want the sim to break even more!!!", Textbox.Mode.PerChar,0, TextboxPortrait.Emotion.Surprised),
	]
	G.send_queue_to_message_box(queue)

func _player_spawning_loading_finished():
	super._player_spawning_loading_finished()

var msg_progress = 0
func _message_box_finished():
	super._message_box_finished()
	if msg_progress == 0:
		bigTarget.eyeFollow = BigTarget.EyeFollow.Center
		bigTarget.set_dest(firstDest)
		msg_progress += 1
		var queue: Array[Textbox.MsgInfo] = [
			Textbox.MsgInfo.new(G.agentName, "I can't seem to get the simulation headset off of you but lets all stay calm...", Textbox.Mode.PerChar),
			Textbox.MsgInfo.new(G.agentName, "HOLY ICE CAPS WHAT IS THAT!?!", Textbox.Mode.PerChar,0, TextboxPortrait.Emotion.Surprised)
		]
		G.send_queue_to_message_box(queue)
	elif msg_progress == 1:
		msg_progress += 1
		G.isBossFight = true
		
		_start_level_input()
		phase = BossPhase.HERE
		bigTarget.set_is_tangible(true)
		bigTarget.eyeFollow = BigTarget.EyeFollow.Player
		await get_tree().create_timer(1, true, false, true).timeout
		var queue: Array[Textbox.MsgInfo] = [
			Textbox.MsgInfo.new(G.agentName, "Agent! It seems that that thing is a target that gained sentience!", Textbox.Mode.PerChar,0, TextboxPortrait.Emotion.Surprised),
			Textbox.MsgInfo.new(G.agentName, "It seems to be what is messing up the simulation", Textbox.Mode.PerChar),
			Textbox.MsgInfo.new(G.agentName, "From what I can tell, you need to destroy targets in order to damage it.", Textbox.Mode.PerChar),
			Textbox.MsgInfo.new(G.agentName, "I'll see if I can do anything to combat it on my end", Textbox.Mode.PerChar)
		]
		G.player.inputVector = Vector2.ZERO
		G.send_queue_to_message_box(queue)

	elif msg_progress == 2:
		msg_progress += 1
		_start_level_input()
		await get_tree().create_timer(1, true, false, true).timeout
		await spawn_boss_level(randi_range(0, bossLevels.size()-1))
		var queue: Array[Textbox.MsgInfo] = [
			Textbox.MsgInfo.new(G.agentName, "The target seems to want to trap you in here forever what you've done to his friends!", Textbox.Mode.PerChar, 0, TextboxPortrait.Emotion.Surprised),
			Textbox.MsgInfo.new(G.agentName, "These level replicas seem to have safezones at the end of each of them", Textbox.Mode.PerChar),
			Textbox.MsgInfo.new(G.agentName, "Getting there seems to reset the timer! That should stall some time for you!", Textbox.Mode.PerChar)
		]
		G.send_queue_to_message_box(queue)
	elif msg_progress == 3:
		msg_progress += 1
		_start_level_input()
		pass
	elif msg_progress == 4:
		var queue: Array[Textbox.MsgInfo] = [
			Textbox.MsgInfo.new(G.agentName, "There seems to be safezones at the end of each of these level replicas", Textbox.Mode.PerChar),
			Textbox.MsgInfo.new(G.agentName, "Getting there seems to reset the timer!", Textbox.Mode.PerChar)
		]
		G.send_queue_to_message_box(queue)
	elif msg_progress == 20:
		levelConcluded.emit()
		G.load_titlescreen()
		pass
		

var lastBossLevelSpawned: int = 0
var bossLevelsSpawned:int = 0

func spawn_random_boss_level():
	var rand = lastBossLevelSpawned
	while rand == lastBossLevelSpawned:
		rand = randi_range(0, bossLevels.size()-1)
	spawn_boss_level(rand)

func spawn_boss_level(index: int):
	lastBossLevelSpawned = index
	if tiles:
		tiles.queue_free()
	currentBossLevel = await G.spawn(bossLevels[index])
	currentBossLevel.bosslevelGoalReached.connect(bossLevelBeat)
	currentBossLevel.targetHit.connect(bigTarget.take_damage)
	currentBossLevel.reparent(self)
	
	G.inGameUI.timer.set_timer()
	currentBossLevel.global_position = G.player.global_position - currentBossLevel.start.global_position
	bigTarget.set_dest(currentBossLevel.bigtargetpos.global_position)
	bossLevelsSpawned += 1
	
	G.player.velocity = Vector2.ZERO

func bossLevelBeat():
	currentBossLevel.queue_free()
	currentBossLevel = null
	await spawn_random_boss_level()
	pass
