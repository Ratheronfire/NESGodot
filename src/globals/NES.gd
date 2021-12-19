extends Node

export (bool) var run_step_by_step = true

onready var memory = []
onready var registers = {
	Consts.CPU_Registers.A:  0x00,
	Consts.CPU_Registers.X:  0x00,
	Consts.CPU_Registers.Y:  0x00,
	Consts.CPU_Registers.PC: 0x00,
	Consts.CPU_Registers.SP: 0xFF,
	Consts.CPU_Registers.SR: 0xFD,
	Consts.CPU_Registers.P:  0x34
}

var _is_running = false

signal tick


func _ready():
	init()


func init():
	memory = []
	for i in range(Consts.MEMORY_SIZE):
		memory.append(0)
	
	registers = {
		Consts.CPU_Registers.A:  0x00,
		Consts.CPU_Registers.X:  0x00,
		Consts.CPU_Registers.Y:  0x00,
		Consts.CPU_Registers.PC: 0x00,
		Consts.CPU_Registers.SP: 0xFF,
		Consts.CPU_Registers.SR: 0xFD,
		Consts.CPU_Registers.P:  0x34
	}


func _process(delta):
	if _is_running:
		var pc = registers[Consts.CPU_Registers.PC]
		
		var next_opcode = memory[pc]
		
		if next_opcode == 0xFF or next_opcode == 0:
			_is_running = false
			return
		
		var instruction = Consts.OPCODE_INSTRUCTIONS[next_opcode]
		var addressing_mode = Consts.OPCODE_MODES[next_opcode]
		var bytes_to_read = Consts.BYTES_PER_MODE[addressing_mode] - 1
		
		var value_low = -1
		var value_high = -1
		
		if bytes_to_read >= 1:
			value_low = memory[pc + 1]
		if bytes_to_read >= 2:
			value_high = memory[pc + 2]
		
		var context = Opcodes.OperandAddressingContext.new(addressing_mode, value_low, value_high)
		
		if not Opcodes.has_method(instruction):
			assert(false, 'Unrecognized instruction: %s' % instruction)
			return
		
		var opcode_func = funcref(Opcodes, instruction)
		opcode_func.call_func(context)
		
		registers[Consts.CPU_Registers.PC] += bytes_to_read + 1
		
		if run_step_by_step:
			_is_running = false
		
		emit_signal("tick")


func start_running():
	_is_running = true


func get_status_flag(status: int):
	return registers[Consts.CPU_Registers.SR] & status


func set_status_flag(status: int, state: bool):
	if state:
		registers[Consts.CPU_Registers.SR] |= status
	else:
		registers[Consts.CPU_Registers.SR] &= ~status


func compile_script(script: String):
	var bytecode = PoolByteArray()
	
	for line in script.split("\n"):
		line = line.split(";")[0]
		if line == "":
			continue
		
		var operands = line.split(" ")
		if len(operands) == 1:
			bytecode.append(Consts.INSTRUCTION_OPCODES[line][Consts.AddressingModes.Implied])
		elif len(operands) > 1:
			var context = Opcodes.determine_addressing_context(operands[1])
			bytecode.append(Consts.INSTRUCTION_OPCODES[operands[0]][context.address_mode])
			
			var data_byte_count = Consts.BYTES_PER_MODE[context.address_mode]
			if data_byte_count >= 2:
				bytecode.append(context.value_low)
			if data_byte_count >= 3:
				bytecode.append(context.value_high)
	
	bytecode.append(0xFF)
	return bytecode


func run_script(script: String):
	for line in script.split("\n"):
		line = line.split(";")[0]
		if line == "":
			continue
		
		var operands = line.split(" ")
		
		if not Opcodes.has_method(operands[0]):
			assert(false, 'Unrecognized opcode: %s' % operands[0])
			return
		
		var opcode_func = funcref(Opcodes, operands[0])
		if len(operands) > 1:
			opcode_func.call_func(operands[1])
		else:
			opcode_func.call_func()


func copy_ram(from: int, to: int, length: int):
	if from + length > Consts.MEMORY_SIZE or from < 0:
		print_debug("Copy failed; From region would exceed memory limits.")
		return
	elif to + length > Consts.MEMORY_SIZE or to < 0:
		print_debug("Copy failed; To region would exceed memory limits.")
		return
	elif from + length >= to:
		print_debug("Copy failed; From region would overlap To region.")
		return
	
	for i in range(length):
		memory[to + i] = memory[from + i]


func _mirror_memory_regions():
	for i in range(3):
		copy_ram(
			Consts.WORK_RAM_ADDRESS,
			Consts.WORK_RAM_MIRROR + i * Consts.WORK_RAM_SIZE,
			Consts.WORK_RAM_SIZE)
	for i in range(1022):
		copy_ram(
			Consts.PPU_REGISTERS,
			Consts.PPU_MIRROR + i * Consts.PPU_RAM_SIZE,
			Consts.PPU_RAM_SIZE)
