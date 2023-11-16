extends Node

var SETTINGS_FILE_PATH = "user://settings.tres"

@export var settings = ResourceLoader.load("res://Resources/Settings/Settings.tres")


func _ready():
	load_settings_file()
	#set_audio_bus("Music", settings.music_volume)
	#set_audio_bus("SFX", settings.sfx_volume)


func load_settings_file():
	if (ResourceLoader.exists(SETTINGS_FILE_PATH)):
		settings = ResourceLoader.load(SETTINGS_FILE_PATH)


func write_settings():
	ResourceSaver.save(settings, SETTINGS_FILE_PATH)


func set_audio_bus(bus_name: String, percent: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)

func write_back_volume_setting(bus_name: String, percent: float):
	settings.set_bus_volume_percent(bus_name, percent)
	write_settings()
