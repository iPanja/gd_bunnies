extends Resource
class_name PipeData

enum PipeType { straight, curved, obstacle }
enum Direction {NORTH = 0, EAST = 1, SOUTH = 2, WEST = 3}

@export var type: PipeType
@export var texture: Texture
@export var inouts: Array[Direction]

func is_draggable():
	return type == PipeType.obstacle

func get_inouts(rotation: int = 0):
	return inouts
