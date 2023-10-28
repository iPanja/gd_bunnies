extends Control

@export var slot_data: SlotData
@export var index: int

@onready var panel = $Panel
@onready var pipe_node: Node2D = $Panel/Node2D

signal on_pipe_dropped(pipe_node, slot_data) # Signal that should be used by outside forces (Game Manager)
signal on_swap_animation_finish()

# Called when the node enters the scene tree for the first time.
func _ready():
	if slot_data:
		set_slot_data(slot_data)

func set_slot_data(new_slot_data: SlotData, new_index = null) -> void:
	self.slot_data = new_slot_data
	self.index = new_index
	pipe_node.set_data(new_slot_data.pipe_data)

func set_panel_texture(texture: Texture2D):
	var _theme = panel.theme
	var stylebox = panel.get_theme_stylebox("panel")
	stylebox.texture = texture
	#panel.texture = texture

func set_pipe_global_position(global_position: Vector2):
	pipe_node.global_position = global_position

func _on_node_2d_piece_dropped(_piece):
	emit_signal("on_pipe_dropped", pipe_node, slot_data, index)

func reset_to_initial_pos():
	pipe_node.reset_to_initial_pos()

func _on_node_2d_swap_animation_finish():
	emit_signal("on_swap_animation_finish")
	
func play_swap_animation(global_destination: Vector2):
	pipe_node.play_swap_animation(global_destination)
