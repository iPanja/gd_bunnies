extends Control

@onready var carrot_label = $PanelContainer/MarginContainer/CarrotLabel
@onready var fps_label = $PanelContainer/MarginContainer/FPSLabel
@onready var timer_label = $PanelContainer/MarginContainer/TimerLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	carrot_label.text = "50 carrots"
	timer_label.text = "60 seconds"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fps_label.text = str(Engine.get_frames_per_second()) + " FPS"


func _on_puzzle_level_update_ui(remaining_sec):
	timer_label.text = "{rs} seconds".format({"rs": remaining_sec})
