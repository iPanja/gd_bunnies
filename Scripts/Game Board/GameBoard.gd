extends PieceManager
class_name GameBoard

# Preferences/Parameters
@export var biome: Biome
@export var piece_size = 72
@export var padding = 24

@onready var rows = biome.rows+2
@onready var cols = biome.cols+2

@onready var vsize = Vector2(cols*piece_size + (cols-1) * padding, rows*piece_size + (rows-1) * padding)

# Data
var is_revealed = []
var board: Array[SlotData] = []
var sourceIndex = -1
var sinkIndex = -1

# Signals - potential ideas
signal on_board_update(board: Array[SlotData])

# Signal connections


# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	self.columns = cols
	
	board = get_random_board()
	draw_board()
	
	print(vsize)
	self.get_parent().set_size(vsize)

var trig = false
func _process(delta):
	if Input.is_key_pressed(KEY_A) && !trig:
		trig = true
		begin_waterflow()

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
	rboard[27] = SlotSource
	sourceIndex = 21
	sinkIndex = 27
	
	return rboard

func draw_board() -> void:
	# Efficiently update board by only modifying those slots that have changed
	for index in range(get_child_count()):
		if index >= board.size(): # Edge case
			break
		
		var previous_slot = get_child(index)
		
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

#
#	[PIECES]
#
func get_slot(index: int):
	return board[index]

func set_slot(index: int, slot_data: SlotData):
	board[index] = slot_data
	super(index, slot_data)

func set_slot_by_offset(offset: Vector2, slot_data: SlotData):
	set_slot(get_index_by_offset(offset), slot_data)

func get_index_by_offset(offset: Vector2):
	var row = int(offset.y / piece_size)
	var col = int(offset.x / piece_size)
	return row*cols + col

func begin_waterflow():
	# Begin animation/dfs chain
	cascade(sourceIndex)

func cascade(index: int):
	var boardSlot = get_child(index)
	var slot = get_slot(index)
	
	for inout in slot.get_inouts():
		# Find neighbor
		var move = slot.get_move_of_direction(inout)
		var drow = move[0]
		var dcol = move[1]
		var neighborIndex = index + drow*(cols+2) + dcol
		if neighborIndex >= 0 && neighborIndex < board.size():
			var neighbor: BoardSlot = get_child(neighborIndex)
			var neighborSlot: SlotData = get_slot(neighborIndex)
			
			var exit = slot.opposite_direction(inout)
			
			if neighborSlot.get_inouts().has(exit) && !neighbor.is_locked:
				# Trigger animation
				print("triggering ", neighborIndex)
				neighbor.lock()
				neighbor.play_water_animation()
	boardSlot.lock()

func on_water_animation_finish(slot: BoardSlot):
	cascade(slot.index)
