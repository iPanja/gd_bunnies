extends GridContainer

# Preferences/Parameters
@export var biome: Biome
@export var piece_size = 72
@export var padding = 24

@onready var rows = biome.rows+2
@onready var cols = biome.cols+2

@onready var vsize = Vector2(cols*piece_size + (cols-1) * padding, rows*piece_size + (rows-1) * padding)

# Data
const SlotScene = preload("res://Scenes/BoardSlot.tscn")
const SlotStandard = preload("res://Resources/Slots/SlotStandard.tres")
const SlotStraight = preload("res://Resources/Slots/SlotStraight.tres")
const SlotCurved = preload("res://Resources/Slots/SlotCurved.tres")
const SlotInvisible = preload("res://Resources/Slots/SlotInvisible.tres")
const SlotSource = preload("res://Resources/Slots/SlotSource.tres")

# Data
var is_revealed = []
var board: Array[SlotData] = []
var anim_stack = []

# Signals - potential ideas
signal on_board_update(board: Array[SlotData])

# Signal connections


# Called when the node enters the scene tree for the first time.
func _ready():
	self.columns = cols
	
	board = get_random_board()
	draw_board()
	
	print(vsize)
	self.get_parent().set_size(vsize)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_global_mouse_position())
	pass


#
#	[BOARD DRAWING]
#
func get_random_board() -> Array[SlotData]:
	var rboard: Array[SlotData] = []
	
	# Generate pipes
	for r in range(rows):
		for c in range(cols):
			var slot: SlotData = (SlotStraight if randi() % 2 == 0 else SlotCurved)
			if (r == 0 || r == rows-1) || (c == 0 || c == cols-1):
				slot = SlotInvisible # Border reserved for sink/source nodes
			rboard.append(slot)
	
	# Testing
	rboard[21] = SlotSource
	
	return rboard
	
	# Generate sink/source
	#var isNorth = (randi() % 2 == 0)
	#var isWest = (randi() % 2 == 0)
	
	#var row = randi_range(1, rows-1)
	#var col = randi_range(1, cols-2)

func draw_board() -> void:
	# Efficiently update board by only modifying those slots that have changed
	for index in range(get_child_count()):
		var previous_slot = get_child(index)
		
		if index >= board.size(): # Edge case
			break
		
		var new_slot_data = board[index]
		if previous_slot.slot_data != new_slot_data: # Change detected => generate entirely new Slot
			remove_child(previous_slot)
			var slot = _create_new_slot(new_slot_data, index)
			move_child(slot, index)
	
	# Fill the rest of the board from board
	# 	Upon game start, this segment will initially populate the empty board
	for index in range(get_child_count(), board.size()):
		var new_slot_data = board[index]
		_create_new_slot(new_slot_data, index)

func _create_new_slot(slot_data: SlotData, index: int) -> BoardSlot:
	var slot = SlotScene.instantiate()
	slot.propogate(slot_data, index)
	add_child(slot)
	slot.connect("piece_swap", _on_puzzle_piece_dropped)
	slot.connect("swap_animation_finish", on_swap_animation_finish)
	slot.set_panel_texture(biome.tile_background)
	
	return slot

#
#	[PIECES]
#

func _on_puzzle_piece_dropped(slot: BoardSlot):
	var pipe_node = slot
	var slot_data = pipe_node.slot_data
	var index = pipe_node.index
	
	var dropped_position = get_global_mouse_position()
	if is_inside_grid_container(dropped_position):
		# Detect collision with another slot
		var offset = dropped_position - self.global_position
		var row = int(offset.y / piece_size)
		var col = int(offset.x / piece_size)
		
		var source_index = index
		var target_index = row*cols + col
		
		if board[source_index].is_draggable() && board[target_index].is_draggable():
			if target_index >= 0 and target_index < board.size() and source_index != target_index:
				# Swap pieces
				var source: SlotData = slot_data.duplicate()
				var target: SlotData = board[target_index].duplicate()
				
				# Animation
				var source_node = self.get_child(source_index)
				var dest_node = self.get_child(target_index)
				
				dest_node.play_swap_animation(source_node.global_position)
				anim_stack.append([source_index, source, target_index, target])
				
				# Snap piece that was moved, temporarily (until redraw after animation finishes)
				source_node.snap(dest_node.get_pipe_global_pos())
				
				return
	# Move piece back
	#pipe_node.call("reset_pos")
	pipe_node.reset_pos()

func is_inside_grid_container(position: Vector2) -> bool:
	var grid_min = self.global_position
	var grid_max = grid_min + self.get_size()
	
	return (position.x >= grid_min.x && position.x <= grid_max.x) && (position.y >= grid_min.y && position.y <= grid_max.y)

func on_swap_animation_finish():
	var data = anim_stack.pop_front()
	if data.size() > 3:
		board[data[0]] = data[3]
		board[data[2]] = data[1]
		draw_board()
