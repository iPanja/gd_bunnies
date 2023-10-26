extends Node2D

@onready var sprite = $Sprite2D
@onready var timer = $Timer

var dragging = false
var pos_offset = Vector2.ZERO
var initial_pos = Vector2.ZERO

signal piece_dropped(piece)

func _process(delta):
	if dragging:
		position = get_global_mouse_position() - pos_offset

#
#	BUTTON
#
func _on_button_button_down():
	initial_pos = global_position
	# Begin drag
	dragging = true
	pos_offset = get_global_mouse_position() - global_position
	set_as_top_level(true)
	
func _on_button_button_up():
	# End drag
	dragging = false
	# Trigger snap mechanic via signal
	emit_signal("piece_dropped", self)

func reset_to_initial_pos():
	position = initial_pos

func set_data(pipe_data: PipeData) -> void:
	sprite.texture = pipe_data.texture
