extends Node

var last_delta: float
var _time_since_last_tick: float = 0

var last_instruction: Opcodes.InstructionData

## The number of CPU instructions to run per second. -1 to run at max speed, 0 to run by manual steps only.
@export var instructions_per_second: int = 0

@onready var memory = []
@onready var registers = {
	Consts.CPU_Registers.A:  0x00,
	Consts.CPU_Registers.X:  0x00,
	Consts.CPU_Registers.Y:  0x00,
	Consts.CPU_Registers.PC: 0xFFFC,
	Consts.CPU_Registers.SP: 0xFD,
	Consts.CPU_Registers.P:  0x34
}

var _is_running = false

signal ticked


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
		Consts.CPU_Registers.PC: 0xFFFC,
		Consts.CPU_Registers.SP: 0xFD,
		Consts.CPU_Registers.P:  0x34
	}


func _process(delta):
	last_delta = delta
	_time_since_last_tick += delta
	
	if _is_running:
		if instructions_per_second == 0 or _time_since_last_tick < 1.0 / instructions_per_second:
			return
		
		_time_since_last_tick = 0
		tick()


func tick():
	var pc = registers[Consts.CPU_Registers.PC]
	
	var instruction_data = get_instruction_data(pc)
	if instruction_data:
		instruction_data.execute()
		last_instruction = instruction_data
	else:
		print('Invalid opcode, stopping.')
		_is_running = false
		return
	
	if registers[Consts.CPU_Registers.PC] == pc:
		# Don't increment the program counter if we just jumped
		registers[Consts.CPU_Registers.PC] += instruction_data.bytes_to_read
	
	ticked.emit()


func get_instruction_data(start_byte: int):
	var next_opcode = memory[start_byte]
	
	if next_opcode == 0xFF or next_opcode == 0:
		_is_running = false
		return
	
	var instruction = Consts.OPCODE_INSTRUCTIONS[next_opcode]
	var addressing_mode = Consts.OPCODE_MODES[next_opcode]
	var bytes_to_read = Consts.BYTES_PER_MODE[addressing_mode] - 1
	
	var value_low = 0
	var value_high = 0
	
	if bytes_to_read >= 1:
		value_low = memory[start_byte + 1]
	if bytes_to_read >= 2:
		value_high = memory[start_byte + 2]
	
	var context = Opcodes.OperandAddressingContext.new(addressing_mode, value_low + (value_high << 8))
	
	if not Opcodes.has_method(instruction):
		assert(false, 'Unrecognized instruction: %s' % instruction)
		return null
	
	return Opcodes.InstructionData.new(next_opcode, context)


func start_running():
	_is_running = true


func get_status_flag(status: int):
	return registers[Consts.CPU_Registers.P] & status


func set_status_flag(status: int, state: bool):
	if state:
		registers[Consts.CPU_Registers.P] |= status
	else:
		registers[Consts.CPU_Registers.P] &= ~status


func compile_script(script: String):
	var bytecode = PackedByteArray()
	var labels = {}
	
	var lines = []
	
	# Trimming excess whitespace
	for line in script.split("\n"):
		var trimmed_line = line.strip_edges().split(";")[0]
		
		if trimmed_line != "":
			lines.append(trimmed_line)
	
	# Pre-scanning the script for labels, making note of their byte offsets
	var bytes_so_far = 0
	for line in lines:
		var operands = line.split(" ")
		
		if len(operands) == 1:
			if ":" in operands[0]:
				# This is a new label
				var label = operands[0].replace(":", "")
				labels[label] = bytes_so_far
			else:
				bytes_so_far += Consts.BYTES_PER_MODE[Consts.AddressingModes.Implied]
		else:
			var context = Opcodes.determine_addressing_context(operands[0], operands[1])
			bytes_so_far += Consts.BYTES_PER_MODE[context.address_mode]
	
	# Replacing the labels with their newly calculated addresses
	bytes_so_far = 0
	for i in range(len(lines)):
		var line = lines[i]
		
		var operands = line.split(" ")
		if len(operands) == 1:
			if not ":" in operands[0]:
				bytes_so_far += Consts.BYTES_PER_MODE[Consts.AddressingModes.Implied]
		elif len(operands) > 1:
			var is_branch = operands[0] in ["BCC", "BCS", "BNE", "BEQ", "BPL", "BMI", "BVC", "BVS"]
			
			var context = Opcodes.determine_addressing_context(operands[0], operands[1])
			bytes_so_far += Consts.BYTES_PER_MODE[context.address_mode]
			
			for label in labels:
				if is_branch:
					operands[1] = operands[1].replace(label, str(labels[label] - bytes_so_far))
				else:
					operands[1] = operands[1].replace(label, str(Consts.CARTRIDGE_ADDRESS + labels[label]))
			
			lines[i] = operands[0] + " " + operands[1]
	
	# Parsing the script into bytecode line by line
	for line in lines:
		var operands = line.split(" ")
		
		if len(operands) == 1 and not ":" in operands[0]:
			bytecode.append(Consts.INSTRUCTION_OPCODES[line][Consts.AddressingModes.Implied])
		elif len(operands) > 1:
			var is_branch = operands[0] in ["BCC", "BCS", "BNE", "BEQ", "BPL", "BMI", "BVC", "BVS"]
			
			var context = Opcodes.determine_addressing_context(operands[0], operands[1])
			if is_branch:
				context.address_mode = Consts.AddressingModes.Relative
			
			bytecode.append(Consts.INSTRUCTION_OPCODES[operands[0]][context.address_mode])
			
			var data_byte_count = Consts.BYTES_PER_MODE[context.address_mode]
			if data_byte_count >= 2:
				bytecode.append(context.value & 0xFF)
			if data_byte_count >= 3:
				bytecode.append(context.value >> 8)
	
	bytecode.append(0xFF)
	return bytecode


func get_word(address: int):
	return memory[address] + (memory[address + 1] << 8)


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
