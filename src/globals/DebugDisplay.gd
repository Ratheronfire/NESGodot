class_name DebugDisplay
extends Control

export (int) var bytes_per_row = 16
export (int) var bytes_per_page = 64

onready var a_label  = $Registers/VBoxContainer/A/Text
onready var x_label  = $Registers/VBoxContainer/X/Text
onready var y_label  = $Registers/VBoxContainer/Y/Text
onready var pc_label = $Registers/VBoxContainer/PC/Text
onready var sp_label = $Registers/VBoxContainer/SP/Text
onready var sr_label = $Registers/VBoxContainer/SR/Text
onready var p_label  = $Registers/VBoxContainer/P/Text

onready var memory = $MemoryPanel/MemoryDisplay

onready var page_number_field = $MemoryPanel/PageNumber
onready var page_total_field = $MemoryPanel/Page2
onready var first_button = $MemoryPanel/FirstButton
onready var prev_button = $MemoryPanel/PrevButton
onready var next_button = $MemoryPanel/NextButton
onready var last_button = $MemoryPanel/LastButton

onready var _total_pages = len(Nes.memory) / bytes_per_page - 1
onready var _page_num_input = 0

var ready_to_render = true

var _page = 0


func _ready():
	Nes.connect("tick", self, "on_tick")
	page_total_field.text = "Of %d" % _total_pages


func _process(delta):
	if ready_to_render:
		a_label.text  = "0x%02X" % Nes.registers[Consts.CPU_Registers.A]
		x_label.text  = "0x%02X" % Nes.registers[Consts.CPU_Registers.X]
		y_label.text  = "0x%02X" % Nes.registers[Consts.CPU_Registers.Y]
		pc_label.text = "0x%02X" % Nes.registers[Consts.CPU_Registers.PC]
		sp_label.text = "0x%02X" % Nes.registers[Consts.CPU_Registers.SP]
		sr_label.text  = "0b%s"  % Helpers.to_binary_string(Nes.registers[Consts.CPU_Registers.SR])
		p_label.text  = "0x%02X" % Nes.registers[Consts.CPU_Registers.P]
		
		memory.text = "       ||"
		
		for i in range(bytes_per_row):
			memory.text += " %02X" % i
		memory.text += "\n" + "=======||"
		for i in range(len(memory.text) - 19):
			memory.text += "="
		memory.text += "\n"
		
		for i in range(bytes_per_page / bytes_per_row):
			memory.text += "0x%03X0 || " % (i + (_page * bytes_per_page / bytes_per_row))
			for j in range(bytes_per_row):
				var byte_index = _page * bytes_per_page + i * bytes_per_row + j
				if byte_index >= len(Nes.memory):
					return
				
				var byte = Nes.memory[byte_index]
				
				memory.text += "%02X" % byte
				
				memory.text += " "
			
			memory.text += "\n"
		
		ready_to_render = false


func on_tick():
	ready_to_render = true


func _set_memory_page(page_index: int):
	_page = clamp(page_index, 0, _total_pages)
	
	first_button.disabled = _page == 0
	prev_button.disabled = _page == 0
	next_button.disabled = _page == _total_pages
	last_button.disabled = _page == _total_pages
	
	page_number_field.text = str(_page)
	page_number_field.cursor_set_column(100)
	
	ready_to_render = true


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
	if not new_text.is_valid_integer() or int(new_text) < 0 or int(new_text) >= _total_pages:
		page_number_field.text = _page_num_input
		return
	
	_set_memory_page(int(new_text))
	_page_num_input = new_text
