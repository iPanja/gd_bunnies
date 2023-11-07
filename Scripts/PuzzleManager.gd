extends Node2D

# "Parameters"
@export var biome: Biome

# Calculated onready
@onready var background = %Background
@onready var puzzle_backdrop_panel = %PuzzleBackdrop
@onready var grid_container = %SlotContainer
@onready var timer = %GameTimer

@onready var rows = biome.rows
@onready var cols = biome.cols

@onready var remaining_sec = biome.time

# Rest
const SlotScene = preload("res://Scenes/Slot.tscn")
const SlotStandard = preload("res://Resources/Slots/SlotStandard.tres")
const SlotStraight = preload("res://Resources/Slots/SlotStraight.tres")
const SlotCurved = preload("res://Resources/Slots/SlotCurved.tres")

const PieceScene = preload("res://Scenes/Piece.tscn")
const PipeStart: PipeData = preload("res://Resources/Pipes/StartPipe.tres")

# Configurable
const piece_size = 72
const padding = 24

# Data
var isRevealed = []
var board: Array[SlotData] = []

var sourcePipe: PuzzlePiece;
var sinkPipe: PuzzlePiece;

# Signals
signal redraw
signal update_ui(remaining_sec: int)

# Misc
var anim_stack = []

# Called when the node enters the scene tree for the first time.
func _ready():
	grid_container.columns = cols
	grid_container.set_size(Vector2(piece_size*cols, piece_size*rows))
	grid_container.position += Vector2(padding, padding)
	
	# Biome asthetics
	background.texture = biome.background
	# Stretch background to fix screen size
	var screen_size = get_viewport_rect().size
	var scale_x = screen_size.x / background.texture.get_width()
	var scale_y = screen_size.y / background.texture.get_height()
	#background.scale = Vector2(scale_x, scale_y)
	
	#puzzle_backdrop_panel.color = biome.board_background_color
	puzzle_backdrop_panel.set_texture(biome.board_backrgound)
	
	random_board()
	eff_populate_board(board)
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
	# Generate m*n board
	for x in rows*cols:
		var slot: SlotData = (SlotStraight if randi() % 2 == 0 else SlotCurved)
		board.append(slot)
		
	# Generate source and sink
	#sinkPipe = PieceScene.instantiate()
	
	sourcePipe = PieceScene.instantiate()
	puzzle_backdrop_panel.add_child(sourcePipe)
	sourcePipe.set_data(PipeStart)
	sourcePipe.isDraggable = false
	sourcePipe.position = Vector2(-72, (72+4)*2)


func _on_redraw():
	eff_populate_board(board)

func eff_populate_board(slot_datas: Array[SlotData]) -> void:
	# Efficiently udpate board by only modifying those slots that have changed
	for index in range(grid_container.get_child_count()):
		var previous_slot = grid_container.get_child(index)
		
		if index >= slot_datas.size(): # Edge case
			break
		
		var new_slot_data = slot_datas[index]
		if previous_slot.slot_data != new_slot_data: # Change detected => generate entirely new Slot
			grid_container.remove_child(previous_slot)
			var slot = _create_new_slot(new_slot_data, index)
			grid_container.move_child(slot, index)
	
	# Fill the rest of the board from slot_datas
	# 	Upon game start, this segment will initially populate the empty board
	for index in range(grid_container.get_child_count(), slot_datas.size()):
		var new_slot_data = slot_datas[index]
		_create_new_slot(new_slot_data, index)

func _create_new_slot(slot_data: SlotData, index: int) -> Slot:
	var slot = SlotScene.instantiate()
	
	grid_container.add_child(slot)
	slot.connect("on_pipe_dropped", _on_puzzle_piece_dropped)
	slot.connect("on_swap_animation_finish", on_swap_animation_finish)
	slot.set_panel_texture(biome.tile_background)
	
	if slot_data: # This should always be true -> no empty slots will exist on the board
		slot.set_slot_data(slot_data, index)
	
	return slot

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
			
			#board[source_index] = target
			#board[target_index] = source
			#self.emit_signal("redraw")
			
			# Animation
			var source_node = grid_container.get_child(target_index)
			var dest_node = grid_container.get_child(source_index)
			source_node.play_swap_animation(dest_node.global_position)
			anim_stack.append([source_index, source, target_index, target])
			
			# Snap piece that was moved, temporarily (until redraw after animation finishes)
			dest_node.set_pipe_global_position(source_node.global_position)
			
			return
	# Move piece back
	pipe_node.call("reset_to_initial_pos")

func is_inside_grid_container(position: Vector2) -> bool:
	var grid_min = grid_container.global_position
	var grid_max = grid_min + grid_container.get_size()
	
	return (position.x >= grid_min.x && position.x <= grid_max.x) && (position.y >= grid_min.y && position.y <= grid_max.y)

func _on_timer_timeout(): 
	remaining_sec -= 1
	emit_signal("update_ui", remaining_sec)
	if remaining_sec <= 0: # timer == 0 => game over
		pass

func on_swap_animation_finish():
	var data = anim_stack.pop_front()
	if data.size() > 3:
		board[data[0]] = data[3]
		board[data[2]] = data[1]
		self.emit_signal("redraw")
