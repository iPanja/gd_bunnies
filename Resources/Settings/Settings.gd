extends Resource
class_name Settings

@export var music_toggle: bool = true
@export var sfx_toggle: bool = true

func set_bus_toggle(bus_name: String, toggle: bool):
	match bus_name:
		"Music":
			music_toggle = toggle
		"SFX":
			sfx_toggle = toggle
