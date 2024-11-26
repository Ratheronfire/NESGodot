@tool
class_name NES_DebugByte
extends RichTextLabel

@export var row_byte: int

var rom_byte: int

var _memory_to_display: PackedByteArray


func _ready() -> void:
	if not Engine.is_editor_hint():
		get_parent().get_parent().get_parent().table_category_updated.connect(on_table_category_updated)
		NES.ticked.connect(on_ticked)
		
		_memory_to_display = NES.cpu_memory


func on_ticked() -> void:
	update()


func on_table_category_updated(memory_category: int):
	if not Engine.is_editor_hint():
		_memory_to_display = NES.cpu_memory if memory_category == 0 else NES.ppu_memory
		update()


func update():
	if not Engine.is_editor_hint() and _memory_to_display:
		text = "%02X" % _memory_to_display[rom_byte]
