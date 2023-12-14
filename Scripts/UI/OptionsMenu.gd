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
	
	# Load current state from settings
	sfx_toggle.button_pressed = GameSettings.settings.sfx_toggle
	music_toggle.button_pressed = GameSettings.settings.music_toggle

func on_option_toggle(value: bool, bus_name: String):
	GameSettings.set_audio_bus_toggle(bus_name, value)

func on_back_pressed():
	back_pressed.emit()
