extends Node2D

var pause_menu: PackedScene = preload("res://Scenes/PauseMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("escape")):
		print("pause menu...")
		add_child(pause_menu.instantiate())
