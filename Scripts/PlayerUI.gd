extends Control

@export var carrot_label: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	carrot_label.text = "50 carrots"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
