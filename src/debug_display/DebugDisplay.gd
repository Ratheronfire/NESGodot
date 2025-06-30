class_name DebugDisplay
extends Control

@onready var a_label  = $Registers/VBoxContainer/A/Text
@onready var x_label  = $Registers/VBoxContainer/X/Text
@onready var y_label  = $Registers/VBoxContainer/Y/Text
@onready var pc_label = $Registers/VBoxContainer/PC/Text
@onready var sp_label = $Registers/VBoxContainer/SP/Text
@onready var p_label  = $Registers/VBoxContainer/P/Text
@onready var cycles_label  = $Registers/VBoxContainer/Cycles/Text
@onready var scanline_label  = $Registers/VBoxContainer/Scanline/Text
@onready var frame_label  = $Registers/VBoxContainer/Frame/Text

@onready var memory = $MemoryPanel/VBoxContainer/SpanningTableContainer

@onready var last_delta_label = $LastDeltaPanel/RichTextLabel
@onready var last_command_label = $ScriptPanel/VBoxContainer/LastCommandLabel

var _page = 0


func _ready():
	NES.ticked.connect(on_ticked)


func on_ticked():
	last_delta_label.text = "Last Delta: %f" % NES.last_delta
	
	if weakref(NES.last_instruction).get_ref():
		var bytes = Consts.BYTES_PER_MODE[NES.last_instruction.context.address_mode]
		
		last_command_label.text = "Last Command: %s %s(%s, %d Byte%s)" % [
			NES.last_instruction.instruction,
			(("$%02X" % NES.last_instruction.context.value) + " ") if NES.last_instruction.context.address_mode != Consts.AddressingModes.Implied else "",
			Consts.AddressingModes.keys()[NES.last_instruction.context.address_mode],
			bytes, "" if bytes == 1 else "s"
		]
	
	a_label.text  = "0x%02X" % NES.cpu_memory.registers[Consts.CPU_Registers.A]
	x_label.text  = "0x%02X" % NES.cpu_memory.registers[Consts.CPU_Registers.X]
	y_label.text  = "0x%02X" % NES.cpu_memory.registers[Consts.CPU_Registers.Y]
	pc_label.text = "0x%02X" % NES.cpu_memory.registers[Consts.CPU_Registers.PC]
	sp_label.text = "0x%02X" % NES.cpu_memory.registers[Consts.CPU_Registers.SP]
	p_label.text  = "0b%s"   % Helpers.to_binary_string(NES.cpu_memory.registers[Consts.CPU_Registers.P])
	cycles_label.text = str(NES.cycles)
	scanline_label.text = str(NES.scanline)
	frame_label.text = str(NES.frame)
