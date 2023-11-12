extends GridContainer
class_name PieceManager

const SlotScene = preload("res://Scenes/BoardSlot.tscn")
const SlotInvisible = preload("res://Resources/Slots/SlotInvisible.tres")
const SlotStandard = preload("res://Resources/Slots/SlotStandard.tres")
const SlotStraight = preload("res://Resources/Slots/SlotStraight.tres")
const SlotCurved = preload("res://Resources/Slots/SlotCurved.tres")
const SlotSource = preload("res://Resources/Slots/SlotSource.tres")

var anim_stack = []

var id: int = -1
@onready var pm_manager: PMManager = get_node("/root/PmManager")

func _ready():
	id = pm_manager.register(self)

func get_slot(index: int):
	pass

func set_slot(index: int, slot_data: SlotData):
	fix_slot(index)

func set_slot_by_offset(offset: Vector2, slot_data: SlotData):
	pass

func get_index_by_offset(offset: Vector2):
	pass

func snap_board_slot(board_slot: BoardSlot, offset: Vector2):
	var index = get_index_by_offset(offset)
	board_slot.snap(get_child(index).global_position)


func animate_slot(dest_global_position: Vector2, index: int):
	var slot_data = get_slot(index)
	get_child(index).play_swap_animation(dest_global_position)

func _create_new_slot(slot_data: SlotData, index: int) -> BoardSlot:
	var slot = SlotScene.instantiate()
	slot.propogate(slot_data, index)
	add_child(slot)
	slot.connect("piece_swap", _on_puzzle_piece_dropped)
	slot.connect("swap_animation_finish", on_swap_animation_finish)
	slot.connect("water_animation_finish", on_water_animation_finish)
	slot.set_panel_texture(pm_manager.biome.tile_background)
	
	return slot

func draw_board():
	pass

# When a piece on this board has been dragged & dropped
# When the piece originally in this bank gets dragged & dropped into the main board
func _on_puzzle_piece_dropped(slot: BoardSlot):
	var mouse_position = get_global_mouse_position()
	var board_slot = slot
	
	var dest_board = get_board_collision(mouse_position)
	if dest_board:
		var offset = mouse_position - dest_board.global_position
		var dest_index = dest_board.get_index_by_offset(offset)
		
		var source_slot = get_slot(slot.index)
		var dest_slot = dest_board.get_slot(dest_index)
		
		if board_slot.is_draggable() && dest_board.get_child(dest_index).is_draggable():
			# Snap piece
			dest_board.snap_board_slot(board_slot, offset)
			# Animate other piece
			dest_board.animate_slot(board_slot.global_position, dest_index)
			# After animation => update each board
			
			if self.id != dest_board.id:
				anim_stack.append([slot.index, dest_slot])
				dest_board.anim_stack.append([dest_index, get_slot(slot.index), self])
			else:
				anim_stack.append([slot.index, dest_slot, dest_index, get_slot(slot.index)])
			
			return
	
	board_slot.reset_pos()
	
func get_board_collision(global_pos: Vector2):
	return pm_manager.get_collision_pm(global_pos)
	
func fix_slot(index: int):
	var previous_slot = get_child(index)
	previous_slot.desurface()

# When a piece coming to this board finishes that animation
# 	=> add piece to board
func on_swap_animation_finish():
	var data = anim_stack.pop_front()
	
	# At least one piece to update
	if data.size() > 1:
		set_slot(data[0], data[1])
		
		# The swap happened between the board & bank, trigger the update in the other
		if data.size() == 3:
			data[2].on_swap_animation_finish()
		else:
			# A second piece to update simultaneously (saving another draw_board() call)
			if data.size() > 3:
				set_slot(data[2], data[3])
	
	draw_board()

func on_water_animation_finish(slot: BoardSlot):
	pass

func is_inside_grid_container(position: Vector2) -> bool:
	var grid_min = self.global_position
	var grid_max = grid_min + self.get_size()
	
	return (position.x >= grid_min.x && position.x <= grid_max.x) && (position.y >= grid_min.y && position.y <= grid_max.y)
