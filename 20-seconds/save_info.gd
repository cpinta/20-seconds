class_name SaveInfo

class GameInfo:
	var levelInfos: Array[LevelInfo] = []
	var lastLevelBeat: int = -1

class LevelInfo:
	var bestTime: float = 20
	var timesStarted: int = 0
	var timesFinished: int = 0
