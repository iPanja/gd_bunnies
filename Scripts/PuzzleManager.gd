extends Node2D

# "Parameters"
@export var puzzle_container: ColorRect
@export var biome: Biome

# Calculated onready
@onready var background = $Background
@onready var grid_container = $PuzzleBackdrop/GridContainer
@onready var timer = $Timer


@onready var rows = biome.rows
@onready var cols = biome.cols

@onready var remaining_sec = biome.time

# Rest
const SlotScene = preload("res://Scenes/Slot.tscn")
const SlotStandard = preload("res://Resources/Slots/SlotStandard.tres")
const SlotStraight = preload("res://Resources/Slots/SlotStraight.tres")
const SlotCurved = preload("res://Resources/Slots/SlotCurved.tres")

# Configurable
const piece_size = 72
const padding = 24

# Configurable
var isRevealed = []
var board: Array[SlotData] = []

enum layers{
	PIECES = 0,
	HIDDEN = 1
}

# Signals
signal redraw
signal update_ui(remaining_sec: int)

# Called when the node enters the scene tree for the first time.
func _ready():
	puzzle_container.set_position(Vector2(375,125))
	puzzle_container.set_size(Vector2(piece_size*cols + 2*padding, piece_size*rows + 2*padding))
	
	grid_container.columns = cols
	grid_container.set_size(Vector2(piece_size*cols, piece_size*rows))
	grid_container.position += Vector2(padding, padding)
	
	background.texture = biome.background
	
	random_board()
	populate_board(board)
	timer.start(1)
	
	self.connect("redraw", _on_redraw)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("click"):
		pass

func _setRevealedArray():
	isRevealed = []
	for x in rows:
		var row = []
		for y in cols:
			row.append(false)
		isRevealed.append(row)

func random_board():
	board = []
	for x in rows*cols:
		var slot: SlotData = (SlotStraight if randi() % 2 == 0 else SlotCurved)
		board.append(slot)

func _on_redraw():
	populate_board(board)

func populate_board(slot_datas: Array[SlotData]) -> void:
	# Destroy
	for child in grid_container.get_children():
		child.queue_free()
	# Create
	
	var index = 0
	for slot_data in slot_datas:
		var slot = SlotScene.instantiate()
		grid_container.add_child(slot)
		#slot.get_node("Panel/Node2D").connect("piece_dropped", _on_puzzle_piece_dropped)
		slot.connect("on_pipe_dropped", _on_puzzle_piece_dropped)
		
		if slot_data: # This should always be true -> no empty slots will exist on the board
			slot.set_slot_data(slot_data, index)
		index += 1

func _on_puzzle_piece_dropped(pipe_node: Node2D, slot_data: SlotData, index: int):
	#var pipe_position = pipe_node.global_position --> use mouse_position for more smoother user experience
	var pipe_position = get_global_mouse_position()
	if is_inside_grid_container(pipe_position):
		# Detect collision with another slot
		var offset = pipe_position - grid_container.global_position
		var row = int(offset.y / piece_size)
		var col = int(offset.x / piece_size)
		
		var source_index = index
		var target_index = row*cols + col
		
		if target_index >= 0 and target_index < board.size() and source_index != target_index:
			# Swap pieces
			var source: SlotData = slot_data.duplicate()
			var target: SlotData = board[target_index].duplicate()
			
			board[source_index] = target
			board[target_index] = source
			self.emit_signal("redraw")
			return
	# Move piece back
	pipe_node.call("reset_to_initial_pos")

func is_inside_grid_container(position: Vector2) -> bool:
	var grid_min = grid_container.get_window().min_size
	var grid_max = grid_container.get_window().max_size
	
	return (position.x >= grid_min.x && position.x <= grid_max.x) && (position.y >= grid_min.y && position.y <= grid_max.y)

func start_timer():
	pass

func _on_timer_timeout(): 
	remaining_sec -= 1
	emit_signal("update_ui", remaining_sec)
	if remaining_sec <= 0: # timer == 0 => game over
		pass
