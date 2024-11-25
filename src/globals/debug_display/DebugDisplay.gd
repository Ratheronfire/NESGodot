class_name DebugDisplay
extends Control

@export var bytes_per_row: int = 16
@export var bytes_per_page: int = 64

@onready var a_label  = $Registers/VBoxContainer/A/Text
@onready var x_label  = $Registers/VBoxContainer/X/Text
@onready var y_label  = $Registers/VBoxContainer/Y/Text
@onready var pc_label = $Registers/VBoxContainer/PC/Text
@onready var sp_label = $Registers/VBoxContainer/SP/Text
@onready var p_label  = $Registers/VBoxContainer/P/Text

@onready var memory = $MemoryPanel/VBoxContainer/SpanningTableContainer

@onready var page_number_field = $MemoryPanel/VBoxContainer/HBoxContainer/PageNumber
@onready var page_total_field = $MemoryPanel/VBoxContainer/HBoxContainer/Page2
@onready var first_button = $MemoryPanel/VBoxContainer/HBoxContainer/FirstButton
@onready var prev_button = $MemoryPanel/VBoxContainer/HBoxContainer/PrevButton
@onready var next_button = $MemoryPanel/VBoxContainer/HBoxContainer/NextButton
@onready var last_button = $MemoryPanel/VBoxContainer/HBoxContainer/LastButton

@onready var last_delta_label = $LastDeltaPanel/RichTextLabel
@onready var last_command_label = $ScriptPanel/VBoxContainer/LastCommandLabel

@onready var _total_pages = len(Nes.memory) / bytes_per_page - 1

var _page_num_input = 0

var _page = 0


func _ready():
	Nes.ticked.connect(on_ticked)
	page_total_field.text = "Of %d" % _total_pages


func on_ticked():
	last_delta_label.text = "Last Delta: %f" % Nes.last_delta
	
	if Nes.last_instruction:
		var bytes = Consts.BYTES_PER_MODE[Nes.last_instruction.context.address_mode]
		last_command_label.text = "Last Command: %s %s(%s, %d Byte%s)" % [
			Nes.last_instruction.instruction,
			(str(Nes.last_instruction.context.value) + " ") if Nes.last_instruction.context.address_mode != Consts.AddressingModes.Implied else "",
			Consts.AddressingModes.keys()[Nes.last_instruction.context.address_mode],
			bytes, "" if bytes == 1 else "s"
		]
	
	a_label.text  = "0x%02X" % Nes.registers[Consts.CPU_Registers.A]
	x_label.text  = "0x%02X" % Nes.registers[Consts.CPU_Registers.X]
	y_label.text  = "0x%02X" % Nes.registers[Consts.CPU_Registers.Y]
	pc_label.text = "0x%02X" % Nes.registers[Consts.CPU_Registers.PC]
	sp_label.text = "0x%02X" % Nes.registers[Consts.CPU_Registers.SP]
	p_label.text  = "0b%s"   % Helpers.to_binary_string(Nes.registers[Consts.CPU_Registers.P])


func _set_memory_page(page_index: int):
	_page = clamp(page_index, 0, _total_pages)
	
	first_button.disabled = _page == 0
	prev_button.disabled = _page == 0
	next_button.disabled = _page == _total_pages
	last_button.disabled = _page == _total_pages
	
	page_number_field.text = str(_page)
	page_number_field.set_caret_column(page_number_field.text.length())
	
	memory.page = page_index
	on_ticked()


func _on_FirstButton_pressed():
	_set_memory_page(0)


func _on_PrevButton_pressed():
	_set_memory_page(_page - 1)


func _on_NextButton_pressed():
	_set_memory_page(_page + 1)


func _on_LastButton_pressed():
	_set_memory_page(_total_pages)


func _on_PageNumber_text_changed():
	var new_text = page_number_field.text
	if not new_text.is_valid_int() or int(new_text) < 0 or int(new_text) >= _total_pages:
		page_number_field.text = _page_num_input
		return
	
	_set_memory_page(int(new_text))
	_page_num_input = new_text
