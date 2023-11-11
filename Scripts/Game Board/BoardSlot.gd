extends Control
class_name BoardSlot

@onready var panel = $Panel
@onready var texture_rect = $TextureRect

@export var slot_data: SlotData
@export var index: int

@onready var is_draggable = slot_data.is_draggable()

var is_dragging = false
var pos_offset = Vector2.ZERO
var initial_pos = Vector2.ZERO
var tween: Tween = null

signal piece_swap(piece)
signal swap_animation_finish(piece)

#
func _ready():
	texture_rect.texture = slot_data.texture
	if slot_data.type == 3 || slot_data.type == 4:
		panel.queue_free()

func _process(delta):
	if is_dragging:
		texture_rect.position = get_global_mouse_position() - pos_offset

func propogate(slot_data: SlotData, index: int):
	self.slot_data = slot_data
	self.index = index
	
	if is_inside_tree():
		_ready()

#
#	[DRAGGING]
#

# Begin drag
func _on_button_button_down():
	initial_pos = global_position
	if is_draggable:
		is_dragging = true
		pos_offset = get_global_mouse_position() - global_position
		texture_rect.set_as_top_level(true)

# Complete drag
func _on_button_button_up():
	if is_dragging:
		is_dragging = false
		emit_signal("piece_swap", self)

func reset_pos():
	texture_rect.position = initial_pos

func snap(global_pos: Vector2):
	texture_rect.global_position = global_pos

#
#	[ANIMATION]
#
func play_swap_animation(global_destination: Vector2):
	if tween:
		tween.kill()
	
	resurface()
	
	tween = create_tween()
	tween.connect("finished", on_tween_finish)
	tween.tween_property(texture_rect, "global_position", global_destination, 0.25)

func on_tween_finish():
	emit_signal("swap_animation_finish")

#
#	NODE/UI
#
func set_panel_texture(texture: Texture2D):
	var _theme = panel.theme
	var stylebox = panel.get_theme_stylebox("panel")
	stylebox.texture = texture

#
#	[HELPER]
#
func get_pipe_pos() -> Vector2:
	return texture_rect.position

func get_pipe_global_pos() -> Vector2:
	return texture_rect.global_position

func resurface():
	texture_rect.set_as_top_level(true)
	texture_rect.global_position = global_position

func desurface():
	texture_rect.set_as_top_level(false);
	texture_rect.position = Vector2.ZERO
