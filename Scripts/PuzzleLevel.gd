extends Node2D

@onready var settings_button = %SettingsButton

var pause_menu: PackedScene = preload("res://Scenes/PauseMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	settings_button.pressed.connect(on_settings_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("escape")):
		print("pause menu...")
		add_child(pause_menu.instantiate())

func on_settings_pressed():
	add_child(pause_menu.instantiate())
