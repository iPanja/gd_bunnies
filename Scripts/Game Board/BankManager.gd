extends PieceManager
class_name BankManager

@export var slot_data: SlotData
@export var main_board_pc: PanelContainer

@onready var main_board: GameBoard = main_board_pc.get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	_create_new_slot(slot_data, 0)

# When the piece originally in this bank gets dragged & dropped into the main board
func _on_puzzle_piece_dropped(slot: BoardSlot):
	var mouse_position = get_global_mouse_position()
	var board_slot = get_child(0) as BoardSlot
	
	if(main_board.is_inside_grid_container(mouse_position)):
		var offset = mouse_position - main_board.global_position
		var dest_index = main_board.get_index_by_offset(offset)
		
		# Snap piece
		main_board.snap_board_slot(board_slot, offset)
		# Animate other piece
		main_board.animate_slot(board_slot.global_position, dest_index)
		# After animation => update each board
		var dest_slot = main_board.get_slot(dest_index)
		
		anim_stack.append([0, dest_slot])
		main_board.anim_stack.append([dest_index, slot_data, self])

func snap_board_slot(board_slot: BoardSlot, offset: Vector2):
	board_slot.global_position = get_child(0).global_position

func draw_board() -> void:
	# Efficiently update board by only modifying those slots that have changed
	var previous_slot = get_child(0)
	if previous_slot.slot_data != slot_data: # Redraw
		remove_child(previous_slot)
		var slot = _create_new_slot(slot_data, 0)

func clear_bank() -> void:
	slot_data = SlotInvisible
	draw_board()

func get_slot(index: int):
	return slot_data

func set_slot(index: int, slot_data: SlotData):
	self.slot_data = slot_data

func set_slot_by_offset(offset: Vector2, slot_data: SlotData):
	set_slot(0, slot_data)

func get_index_by_offset(offset: Vector2):
	return 0
