extends Node2D

@onready var settings_button = %SettingsButton
@onready var swoosh_player = %SwooshPlayer

@onready var game_board_scene = $CanvasLayer/MarginContainer/Container/GameContainer/GameBoardScene
@onready var bank_scene = $CanvasLayer/MarginContainer/Container/SideBar/VBox/Bank/BankScene


var pause_menu: PackedScene = preload("res://Scenes/PauseMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	settings_button.pressed.connect(on_settings_pressed)
	game_board_scene.get_child(0).on_piece_swap_sfx.connect(on_piece_swap)
	bank_scene.on_piece_swap_sfx.connect(on_piece_swap)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("escape")):
		print("pause menu...")
		add_child(pause_menu.instantiate())

func on_settings_pressed():
	add_child(pause_menu.instantiate())

func on_piece_swap():
	if !swoosh_player.playing:
		swoosh_player.play()
