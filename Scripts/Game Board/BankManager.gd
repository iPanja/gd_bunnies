extends PieceManager
class_name BankManager

@export var slot_data: SlotData

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	_create_new_slot(slot_data, 0)

func draw_board() -> void:
	# Efficiently update board by only modifying those slots that have changed
	var previous_slot = get_child(0)
	if previous_slot.slot_data != slot_data: # Redraw
		remove_child(previous_slot)
		var slot = _create_new_slot(slot_data, 0)

func get_slot(index: int):
	return slot_data

func set_slot(index: int, slot_data: SlotData):
	self.slot_data = slot_data
	super(index, slot_data)

func set_slot_by_offset(offset: Vector2, slot_data: SlotData):
	set_slot(0, slot_data)

func get_index_by_offset(offset: Vector2):
	return 0
