@tool
class_name NES_DebugByte
extends RichTextLabel

@export var row_byte: int

var rom_byte: int


func _ready() -> void:
	NES.ticked.connect(on_ticked)


func on_ticked() -> void:
	update()


func update():
	if not Engine.is_editor_hint() and NES.cpu_memory:
		text = "%02X" % NES.cpu_memory[rom_byte]
