extends Node2D

@export var puzzle_container: ColorRect
@export var tile_map: TileMap
@export var puzzle_level: PuzzleLevel

@onready var rows = puzzle_level.piece_ids.size()
@onready var cols = puzzle_level.piece_ids[0].size()
var piece_size = 72
var padding = 24
var isRevealed = []

enum layers{
	PIECES = 0,
	HIDDEN = 1
}

# Called when the node enters the scene tree for the first time.
func _ready():
	puzzle_level.load_pieces()
	setInitialTiles()

	puzzle_container.set_position(Vector2(375,125))
	puzzle_container.set_size(Vector2(piece_size*cols + 2*padding, piece_size*rows + 2*padding))
	tile_map.position = Vector2(padding, padding)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("click"):
		var local_pos = tile_map.get_local_mouse_position()
		var tile_map_pos: Vector2i = tile_map.local_to_map(local_pos)
		
		if !isRevealed[tile_map_pos.x][tile_map_pos.y]:
			# If the piece's cover ("? tile") is still visible => remove it
			removeTileCover(tile_map_pos)
			isRevealed[tile_map_pos.x][tile_map_pos.y] = true
		else:
			# Rotate tile
			rotateTile(tile_map_pos)

func setInitialTiles():
	_setRevealedArray()
	# Set hidden cover layer above it
	for x in cols:
		for y in rows:
			var piece := puzzle_level.pieces[x][y] as PuzzlePiece
			# Hidden tile cover
			tile_map.set_cell(layers.HIDDEN, Vector2i(x, y), 0, Vector2i(0, 0), 0)
			# Actual tile behind it
			tile_map.set_cell(layers.PIECES, Vector2i(x, y), piece.piece_id, Vector2i(0, 0), piece.get_alt_id())

func _setRevealedArray():
	isRevealed = []
	for x in rows:
		var row = []
		for y in cols:
			row.append(false)
		isRevealed.append(row)

func removeTileCover(tile_pos: Vector2i):
	tile_map.set_cell(layers.HIDDEN, tile_pos, -1, Vector2i(0, 0), 0)
	
func rotateTile(tile_pos: Vector2i, layer: int = layers.PIECES):
	var piece := puzzle_level.pieces[tile_pos.x][tile_pos.y] as PuzzlePiece
	var rot = piece.rotate()
	var alt_id = piece.get_alt_id()
	
	tile_map.set_cell(layer, tile_pos, piece.piece_id, Vector2i(0, 0), alt_id) # rotate via alt. texture
