class_name Save

class GameInfo:
	var levelInfos: Array[LevelInfo] = []
	var lastLevelBeat: int = 0
	
	func stringify() -> String:
		var string: String = "{\n\"levelInfos\": \n[\n"
		for i in range(0, levelInfos.size()):
			string += levelInfos[i].stringify()
			if i != levelInfos.size() - 1:
				string+= ",\n"
				pass
		string += "],\n"
		string += " \"lastLevelBeat\" : "+str(lastLevelBeat)+"\n}"
		return string
	
	static func parse(dict:Dictionary):
		var gameInfo: GameInfo = GameInfo.new()
		for key in dict.keys():
			if not dict[key] is Array:
				gameInfo.set(key, dict[key])
			else:
				for childDict:Dictionary in dict[key]:
					var levelInfo: LevelInfo = LevelInfo.new()
					for childKey in childDict:
						levelInfo.set(childKey, childDict[childKey])
					gameInfo.levelInfos.append(levelInfo)
		return gameInfo

class LevelInfo:
	var bestTime: float = 20
	var timesStarted: int = 0
	var timesFinished: int = 0
	var selectable: bool = true
	
	func stringify() -> String:
		var string: String = "{\n"
		var dicts: Array[Dictionary] = get_property_list()
		for i in range(3, dicts.size()):
			string += "\""+dicts[i]["name"] + "\" :" + str(self.get(dicts[i]["name"]))
			if i != dicts.size() - 1:
				string += ",\n"
			pass
		string += "\n}\n"
		return string

static var SAVE_FILE_NAME: String = 'BEARSAVEFILE'
static var SAVE_PATH: String = 'user://bear_data.ini'

static func get_save(levelCount: int) -> Variant:
	if OS.has_feature('web'):
		var config = ConfigFile.new()
		var error: Error = config.load(SAVE_PATH)
		if error:
			print("Error while loading save:",error)
			return null
		if not config.has_section(SAVE_FILE_NAME):
			print("gameInfo doesnt have save file section")
			return null
		var val = config.get_value(SAVE_FILE_NAME, SAVE_FILE_NAME)
		if not val:
			print("gameInfo is null")
			var blank = create_blank(levelCount)
			write_save(blank)
			return blank
		print("gameInfo not null")
		var json: JSON = JSON.new()
		error = json.parse(val)
		if error:
			print("save parsing error:"+str(error))
			return
		var gameInfo = Save.GameInfo.parse(json.data)
		if gameInfo is not Save.GameInfo:
			print("gameInfo not right type")
			var blank = create_blank(levelCount)
			write_save(blank)
			return blank
		return gameInfo
	else:
		print("not web. didnt grab save")
		return null

static func write_save(saveInfo: Save.GameInfo) -> bool:
	if OS.has_feature('web'):
		var config_file = ConfigFile.new()
		if saveInfo:
			print("writing: save info was not null")
			config_file.set_value(SAVE_FILE_NAME, SAVE_FILE_NAME, saveInfo.stringify())
			#print(config_file.encode_to_text())
		else:
			print("writing: save info was null")
		
		var error: Error = config_file.save(SAVE_PATH)
		if error:
			print("Error while saving:",error)
			return false
		return true
	else:
		return true

static func create_blank(levelCount: int) -> GameInfo:
	var gameSave: GameInfo = GameInfo.new()
	for i in range(0, levelCount):
		gameSave.levelInfos.append(Save.LevelInfo.new())
		if i == 0:
			gameSave.levelInfos.back().selectable = false
			pass
	if G.debug:
		gameSave.lastLevelBeat = 0
	else:
		gameSave.lastLevelBeat = 0
	
	
	return gameSave
#
#static func config_to_gameInfo(config: ConfigFile) -> GameInfo:
	#
	#if not config.has_section(SAVE_FILE_NAME):
		#print("gameInfo doesnt have save file section")
		#return null
	#
	#var val = config.get_value(SAVE_FILE_NAME, SAVE_FILE_NAME)
	#if not val:
		#print("gameInfo is null")
		#var blank = create_blank(levelCount)
		#write_save(blank)
		#return blank
	#print("gameInfo not null")
	#var gameInfo = JSON.parse_string(val)
	#pass
