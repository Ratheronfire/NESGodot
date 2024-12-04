@tool
class_name NES_DebugByte
extends RichTextLabel

@export var row_byte: int

var rom_byte: int

var memory_category: Consts.MemoryTypes = Consts.MemoryTypes.CPU


func _ready() -> void:
	if not Engine.is_editor_hint():
		get_parent().get_parent().get_parent().table_category_updated.connect(on_table_category_updated)
		NES.ticked.connect(on_ticked)


func on_ticked() -> void:
	update()


func on_table_category_updated(memory_category: int):
	if not Engine.is_editor_hint():
		self.memory_category = memory_category
		update()


func update():
	if not Engine.is_editor_hint():
		text = "%02X" % NES.read_byte(rom_byte, memory_category)
