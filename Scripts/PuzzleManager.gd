extends Node2D

var game_board = {}
@export var puzzle_container: ColorRect
@export var tile_map: TileMap

var rows = 4
var cols = 5
var pieces = {}
var piece_size = 72
var padding = 24

# Called when the node enters the scene tree for the first time.
func _ready():
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
		rotateTile(tile_map_pos)

func setInitialTiles():
	for x in cols:
		for y in rows:
			# Hidden tile cover
			tile_map.set_cell(1, Vector2(x, y), 0, Vector2i(0, 0), 0)
			# Actual tile behind it
			# TODO

func removeTile(tile_pos: Vector2i):
	tile_map.set_cell(1, tile_pos, -1, Vector2i(0, 0), 0)
	
func rotateTile(tile_pos: Vector2i):
	var rot = (tile_map.get_cell_alternative_tile(1, tile_pos) + 1) % 4
	tile_map.set_cell(1, tile_pos, 0, Vector2i(0, 0), rot) # rotate via alt. texture
