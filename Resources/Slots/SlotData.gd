extends Resource
class_name SlotData

enum PipeType { straight=0, curved=1, obstacle=2, invisible=3, source=4 }
enum Direction {NORTH = 0, EAST = 1, SOUTH = 2, WEST = 3}

@export var is_locked: bool # i.e. if it is currently animated or already has been, the player shouldn't be able to move it
@export var type: PipeType
@export var texture: Texture
@export var inouts: Array[Direction]

func is_draggable():
	return (!is_locked && (type != PipeType.obstacle) && type != PipeType.source)

func get_inouts(rotation: int = 0):
	return inouts

func get_directions_moves(rotation: int = 0):
	var moves = [] #[(drow, dcol)]
	for inout in get_inouts(0):
		match inout:
			0: # North
				moves.append([1, 0])
			1: # East
				moves.append([0, 1])
			2: # South
				moves.append([-1, 0])
			3: # West
				moves.append([0, -1])
	return moves

func get_move_of_direction(dir: int):
	match dir:
		0: # North
			return[1, 0]
		1: # East
			return[0, 1]
		2: # South
			return[-1, 0]
		3: # West
			return[0, -1]

func opposite_direction(dir: int):
	match dir:
		0: # North
			return 2
		1: # East
			return 3
		2: # South
			return 0
		3: # West
			return 1
