@tool
class_name NES_DebugByte
extends RichTextLabel

@export var row_byte: int

var rom_byte: int

@onready var memory: Memory = NES.cpu_memory


func _ready() -> void:
	if not Engine.is_editor_hint():
		get_parent().get_parent().get_parent().table_category_updated.connect(on_table_category_updated)
		NES.ticked.connect(on_ticked)


func on_ticked() -> void:
	update()


func on_table_category_updated(memory_category: int):
	if not Engine.is_editor_hint():
		if memory_category == Consts.MemoryTypes.CPU:
			memory = NES.cpu_memory
		elif memory_category == Consts.MemoryTypes.PPU:
			memory = NES.ppu_memory
		update()


func update():
	if not Engine.is_editor_hint():
		text = "%02X" % memory.read_byte(rom_byte)
