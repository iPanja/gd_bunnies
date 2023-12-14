extends Node

var SETTINGS_FILE_PATH = "user://settings.tres"

@export var settings = ResourceLoader.load("res://Resources/Settings/Settings.tres")

func _ready():
	load_settings_file()
	set_audio_bus_toggle("Music", settings.music_toggle)
	set_audio_bus_toggle("SFX", settings.sfx_toggle)

# Read, Write settings file
func load_settings_file():
	if (ResourceLoader.exists(SETTINGS_FILE_PATH)):
		settings = ResourceLoader.load(SETTINGS_FILE_PATH)

func write_settings():
	ResourceSaver.save(settings, SETTINGS_FILE_PATH)

# Interact with Audio Bus
func set_audio_bus_toggle(bus_name: String, toggle: bool):
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_mute(bus_index, !toggle)
	write_back_volume_setting(bus_name, toggle)

func write_back_volume_setting(bus_name: String, toggle: bool):
	settings.set_bus_toggle(bus_name, toggle)
	write_settings()
