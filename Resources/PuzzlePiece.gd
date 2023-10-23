extends Resource

class_name PuzzlePiece

@export var piece_id: int
@export var inouts = []
@export var rotation = 0 # counter-clockwise rotation

func get_augmented_inouts() -> Array:
	var augmented = []
	augmented.resize(inouts.size())
	for i in range(inouts.size()):
		var val = inouts[i] - rotation
		if val < 0:
			val = 3
		augmented[i] = val
	return augmented

func rotate() -> int:
	rotation = (rotation + 1) % 4
	return rotation
