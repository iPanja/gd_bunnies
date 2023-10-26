extends Resource
class_name PipeData

enum PipeType { straight, curved, obstacle }

@export var type: PipeType
@export var texture: Texture

func isDraggable():
	return type == PipeType.obstacle
