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
