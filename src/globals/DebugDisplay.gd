class_name DebugDisplay
extends Control

export (int) var bytes_per_row = 16
export (int) var rows_per_page = 32

onready var a_label  = $Registers/VBoxContainer/A/Text
onready var x_label  = $Registers/VBoxContainer/X/Text
onready var y_label  = $Registers/VBoxContainer/Y/Text
onready var pc_label = $Registers/VBoxContainer/PC/Text
onready var s_label  = $Registers/VBoxContainer/S/Text
onready var p_label  = $Registers/VBoxContainer/P/Text

onready var memory = $Memory

var ready_to_render = true

var _page = 0


func _process(delta):
	if ready_to_render:
		a_label.text = "0x%02X"  % Nes.registers[Nes.CPU_Registers.A]
		x_label.text = "0x%02X"  % Nes.registers[Nes.CPU_Registers.X]
		y_label.text = "0x%02X"  % Nes.registers[Nes.CPU_Registers.Y]
		pc_label.text = "0x%02X" % Nes.registers[Nes.CPU_Registers.PC]
		s_label.text = "0x%02X"  % Nes.registers[Nes.CPU_Registers.S]
		p_label.text = "0x%02X"  % Nes.registers[Nes.CPU_Registers.P]
		
		var row_index = 0
		var page_size = rows_per_page * bytes_per_row
		
		memory.text = ''
		for i in range(_page *  page_size, page_size):
			var byte = Nes.memory[i]
			
			memory.text += "%02X" % byte
			
			row_index += 1
			if row_index >= bytes_per_row:
				memory.text += "\n"
				row_index = 0
			else:
				memory.text += " "
		
		ready_to_render = false
