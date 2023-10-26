extends Control

@export var slot_data: SlotData
@export var index: int

@onready var pipe_node: Node2D = $Panel/Node2D

signal on_pipe_dropped(pipe_node, slot_data) # Signal that should be used by outside forces (Game Manager)

# Called when the node enters the scene tree for the first time.
func _ready():
	if slot_data:
		set_slot_data(slot_data)

func set_slot_data(slot_data: SlotData, index = null) -> void:
	self.slot_data = slot_data
	self.index = index
	pipe_node.set_data(slot_data.pipe_data)


func _on_node_2d_piece_dropped(piece):
	emit_signal("on_pipe_dropped", pipe_node, slot_data, index)

func reset_to_initial_pos():
	pipe_node.reset_to_initial_pos()
