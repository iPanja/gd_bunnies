extends PanelContainer
class_name OptionsMenu

signal back_pressed

@onready var sfx_toggle = %SFXToggle
@onready var music_toggle = %MusicToggle
@onready var back_button = $%BackButton

var previous_ui: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	back_button.pressed.connect(on_back_pressed)
	sfx_toggle.toggled.connect(on_option_toggle.bind("SFX"))
	music_toggle.toggled.connect(on_option_toggle.bind("Music"))

#func on_audio_slider_changed(value: float, bus_name: String):
#	set_bus_volume_percent(bus_name, value)

func on_option_toggle(value: bool, bus_name: String):
	print(bus_name)
	print(value)
	set_bus_volume_toggle(bus_name, value)

func on_back_pressed():
	back_pressed.emit()
