extends Node

var playing: bool = true
var total: int = 0 
var died: bool = false
var highscore: int

const SAVE_PATH = "user://savegame.cfg"

func save_highscore(record):
	var config = ConfigFile.new()
	config.set_value("GamerData", "highscore", record)
	config.save(SAVE_PATH)

func load_highscore():
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)
	
	if err != OK: return 0
		
	return config.get_value("GamerData", "highscore", 0)
