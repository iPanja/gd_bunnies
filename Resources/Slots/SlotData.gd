extends Resource
class_name SlotData

@export var pipe_data: PipeData
@export var is_locked: bool # i.e. if it is currently animated or already has been, the player shouldn't be able to move it

func isDraggable() -> bool:
	return (!is_locked && pipe_data.isDraggable())
