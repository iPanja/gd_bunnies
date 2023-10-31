extends Node2D

@export var speed: float
@export var destination: PackedScene

@onready var animated_sprite_2d = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Scale to screen size
	var screen_size = get_viewport_rect().size
	var scale_x = screen_size.x / 1922
	var scale_y = screen_size.y / 1082
	animated_sprite_2d.scale = Vector2(scale_x, scale_y)
	
	# Play & Hookup
	animated_sprite_2d.play("default", speed)
	animated_sprite_2d.connect("animation_looped", _on_timer_finish)

func _on_timer_finish():
	#get_tree().change_scene_to_file("res://Levels/Main.tscn")
	get_tree().change_scene_to_packed(destination)
