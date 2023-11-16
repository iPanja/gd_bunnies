extends CanvasLayer

@onready var continue_button = %ContinueButton
@onready var main_menu_button = %MainMenuButton
@onready var pause_menu_body = %PauseMenuBody

var main_menu_scene: PackedScene = preload("res://Levels/Main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	continue_button.connect("pressed", on_continue_pressed)
	main_menu_button.connect("pressed", on_main_menu_pressed)

func on_continue_pressed():
	get_tree().paused = false
	queue_free()

func on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_menu_scene)
