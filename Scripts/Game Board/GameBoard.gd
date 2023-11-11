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
