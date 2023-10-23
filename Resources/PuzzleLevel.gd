extends Resource

class_name PuzzleLevel

@export var biome_name: String
@export var level_no: int
@export var piece_ids = []

var pieces: Array # Of type [PuzzlePiece (Resource)]

func load_pieces():
	print("PUZZLE LEVEL RESOURCE - INIT")
	print(piece_ids)
	pieces = []
	for x in piece_ids.size():
		var row = []
		for y in piece_ids[0].size():
			var piece = _load_piece(piece_ids[x][y])
			row.append(piece)
		pieces.append(row)
	
func _load_piece(piece_id: int) -> PuzzlePiece:
	match piece_id:
		2:
			return load("res://Resources/Pieces/StraightTube.tres")
		3:
			return load("res://Resources/Pieces/CurvedTube.tres")
	return null
