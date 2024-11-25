@tool
class_name NES_DebugByte
extends RichTextLabel

@export var row_byte: int

var rom_byte: int


func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		text = "%02X" % Nes.memory[rom_byte]