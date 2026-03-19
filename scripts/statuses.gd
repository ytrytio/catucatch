extends Node

var playing: bool = true
var total: int = 0 
var died: bool = false
var highscore: int

const SAVE_PATH = "user://savegame.cfg"

var music_volume: float = 1.0
var sounds_volume: float = 1.0

func _ready():
	load_settings()

func save_settings():
	var config = ConfigFile.new()
	
	config.set_value("GamerData", "highscore", highscore)
	config.set_value("Settings", "music_volume", music_volume)
	config.set_value("Settings", "sounds_volume", sounds_volume)
	
	config.save(SAVE_PATH)

func load_settings():
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)
	
	if err != OK:
		set_bus_volume("Music", 1.0)
		set_bus_volume("Sounds", 1.0)
		return
	
	highscore = config.get_value("GamerData", "highscore", 0)
	music_volume = config.get_value("Settings", "music_volume", 1.0)
	sounds_volume = config.get_value("Settings", "sounds_volume", 1.0)
	
	set_bus_volume("Music", music_volume)
	set_bus_volume("Sounds", sounds_volume)

func set_bus_volume(bus_name: String, value: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		if bus_name == "Music": music_volume = value
		if bus_name == "Sounds": sounds_volume = value
		
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
		AudioServer.set_bus_mute(bus_index, value <= 0.0)
