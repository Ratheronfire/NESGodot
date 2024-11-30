@tool
class_name NES_DebugByte
extends RichTextLabel

@export var row_byte: int

var rom_byte: int

var _is_tracking_cpu := true


func _ready() -> void:
	if not Engine.is_editor_hint():
		get_parent().get_parent().get_parent().table_category_updated.connect(on_table_category_updated)
		NES.ticked.connect(on_ticked)


func on_ticked() -> void:
	update()


func on_table_category_updated(memory_category: int):
	if not Engine.is_editor_hint():
		_is_tracking_cpu = memory_category == 0
		update()


func update():
	if not Engine.is_editor_hint():
		text = "%02X" % NES.cpu_memory[rom_byte] if _is_tracking_cpu else NES.ppu_memory[rom_byte]
