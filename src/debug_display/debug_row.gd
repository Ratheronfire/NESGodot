@tool
class_name NES_DebugRow
extends HBoxContainer

const BYTES_PER_ROW: int = 16
const BYTES_PER_PAGE: int = 256

@export var row_index: int:
	set(value):
		row_index = value
		update_display()
var page: int:
	set(value):
		page = value
		update_display()


func _ready() -> void:
	page = 0
	update_display()


func update_display():
	for child in get_children():
		if child is NES_DebugByte:
			child.rom_byte = (0x10 * (row_index + (page * BYTES_PER_PAGE / BYTES_PER_ROW))) + child.row_byte
			child.update()
	
	$RowStart.text = "0x%03X0 || " % (row_index + (page * BYTES_PER_PAGE / BYTES_PER_ROW))
