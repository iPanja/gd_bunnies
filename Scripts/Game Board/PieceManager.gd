extends GridContainer
class_name PieceManager

const SlotScene = preload("res://Scenes/BoardSlot.tscn")
const SlotInvisible = preload("res://Resources/Slots/SlotInvisible.tres")
const SlotStandard = preload("res://Resources/Slots/SlotStandard.tres")
const SlotStraight = preload("res://Resources/Slots/SlotStraight.tres")
const SlotCurved = preload("res://Resources/Slots/SlotCurved.tres")
const SlotSource = preload("res://Resources/Slots/SlotSource.tres")

var anim_stack = []

# Piece has been dragged to this index
# Step 1
	# add to board/snap
func move_from_index(index: int, destination: PieceManager):
	pass

# Piece here will animate then snap to target PieceManager
# Step 2
	# Animate
		# on_animation_finish => add to target board
func move_to_index(slot_data: SlotData, index: int):
	pass

func get_slot(index: int):
	pass

func set_slot(index: int, slot_data: SlotData):
	pass

func set_slot_by_offset(offset: Vector2, slot_data: SlotData):
	pass

func get_index_by_offset(offset: Vector2):
	pass

func snap_board_slot(board_slot: BoardSlot, offset: Vector2):
	pass

func animate_slot(dest_global_position: Vector2, index: int):
	var slot_data = get_slot(index)
	get_child(index).play_swap_animation(dest_global_position)

func _create_new_slot(slot_data: SlotData, index: int) -> BoardSlot:
	var slot = SlotScene.instantiate()
	slot.propogate(slot_data, index)
	add_child(slot)
	slot.connect("piece_swap", _on_puzzle_piece_dropped)
	slot.connect("swap_animation_finish", on_swap_animation_finish)
	#slot.set_panel_texture(biome.tile_background)
	
	return slot

func draw_board():
	pass

# When a piece on this board has been dragged & dropped
func _on_puzzle_piece_dropped(slot: BoardSlot):
	pass
	
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

func is_inside_grid_container(position: Vector2) -> bool:
	var grid_min = self.global_position
	var grid_max = grid_min + self.get_size()
	
	return (position.x >= grid_min.x && position.x <= grid_max.x) && (position.y >= grid_min.y && position.y <= grid_max.y)
