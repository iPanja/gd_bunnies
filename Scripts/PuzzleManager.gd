extends Node2D

var game_board = {}
@export var puzzle_container: ColorRect
@export var tile_map: TileMap
@export var puzzle_level: PuzzleLevel

@onready var rows = puzzle_level.piece_ids.size()
@onready var cols = puzzle_level.piece_ids[0].size()
var piece_size = 72
var padding = 24
var isRevealed = []

# Called when the node enters the scene tree for the first time.
func _ready():
	setInitialTiles()
	
	puzzle_level.load_pieces()

	puzzle_container.set_position(Vector2(375,125))
	puzzle_container.set_size(Vector2(piece_size*cols + 2*padding, piece_size*rows + 2*padding))
	tile_map.position = Vector2(padding, padding)
	
	isRevealed = []
	isRevealed.resize(rows)
	for i in rows:
		var r = []
		r.resize(cols)
		r.fill(false)
		isRevealed[i] = r


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("click"):
		var local_pos = tile_map.get_local_mouse_position()
		var tile_map_pos: Vector2i = tile_map.local_to_map(local_pos)
		if !isRevealed[tile_map_pos.x][tile_map_pos.y]:
			removeTileCover(tile_map_pos)
			isRevealed[tile_map_pos.x][tile_map_pos.y] = true
		else:
			rotateTile(tile_map_pos)

func setInitialTiles():
	# Set hidden cover layer above it
	for x in cols:
		for y in rows:
			# Hidden tile cover
			tile_map.set_cell(1, Vector2(x, y), 0, Vector2i(0, 0), 0)
			# Actual tile behind it
			tile_map.set_cell(0, Vector2(x, y), puzzle_level.piece_ids[x][y], Vector2i(0, 0), 0)
			

func removeTileCover(tile_pos: Vector2i):
	tile_map.set_cell(1, tile_pos, -1, Vector2i(0, 0), 0)
	
func rotateTile(tile_pos: Vector2i, layer: int = 0):
	var piece := puzzle_level.pieces[tile_pos.x][tile_pos.y] as PuzzlePiece
	#var rot = (tile_map.get_cell_alternative_tile(layer, tile_pos) + 1) % 4
	var rot = piece.rotate() 
	
	tile_map.set_cell(layer, tile_pos, piece.piece_id, Vector2i(0, 0), rot) # rotate via alt. texture
	#puzzle_level.pieces[tile_pos.x][tile_pos.y].rotate()
