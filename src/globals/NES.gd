extends Node

const NTSC_SECONDS_PER_CYCLE := 0.0000005589
const PAL_SECONDS_PER_CYCLE := 0.0000006015

const NTSC_CYCLES_PER_SCANLINE := 113.6666666667
const PAL_CYCLES_PER_SCANLINE := 106.5625

const NTSC_SCANLINES := 240
const PAL_SCANLINES := 239

const NTSC_VBLANK_SCANLINES := 20
const PAL_VBLANK_SCANLINES := 70

var last_delta: float

var last_instruction: Opcodes.InstructionData

## The number of CPU instructions to run per second. -1 to run at max speed, 0 to run by manual steps only.
@export var instructions_per_second: int = 0

## Sets the speed of the emulated CPU. 1.0 equals the default value (60fps for NTSC/50fps for PAL), and 0.0 means the CPU is stopped.
@export var cpu_speed_multiplier: float = 0.0

@onready var _cpu_memory = []
@onready var _ppu_memory = []
@onready var registers = {
	Consts.CPU_Registers.A:  0x00,
	Consts.CPU_Registers.X:  0x00,
	Consts.CPU_Registers.Y:  0x00,
	Consts.CPU_Registers.PC: 0xFFFC,
	Consts.CPU_Registers.SP: 0xFD,
	Consts.CPU_Registers.P:  0x34
}

var pending_interrupt := Consts.Interrupts.NONE

# The CPU loop runs too fast, so for now I'll apply this throttle value to roughly approximate 60fps.
var _fps_throttle := 0.0140186916

var cycles: int:
	get:
		return _cycles
var _cycles := 0
var _cycles_before_next_instruction := 0

var scanline: int:
	get:
		return _scanline
var _scanline := 0

var frame: int:
	get:
		return _frame
var _frame := 0

var _seconds_this_cycle := 0.0
var _seconds_this_scanline := 0.0

var _rom_mapper: NES_Mapper

var _nmi_vector: int
var _reset_vector: int
var _irq_vector: int

var _is_running = false

var _test_prev_frame := 0
var _fps_history := []

signal ticked


func _ready():
	init()


func _process(delta: float) -> void:
	var frame_diff = _frame - _test_prev_frame
	
	_fps_history.append((_frame - _test_prev_frame) / delta)
	if len(_fps_history) > 100:
		_fps_history.pop_front()
	
	var fps_avg = 0.0
	for fps in _fps_history:
		fps_avg += fps
	fps_avg /= len(_fps_history)
	
	#print("Current framerate: %f" % fps_avg)
	
	_test_prev_frame = _frame


func init():
	_cpu_memory = []
	for i in range(Consts.CPU_MEMORY_SIZE):
		_cpu_memory.append(0)
	
	_ppu_memory = []
	for i in range(Consts.PPU_MEMORY_SIZE):
		_ppu_memory.append(0)
	
	registers = {
		Consts.CPU_Registers.A:  0x00,
		Consts.CPU_Registers.X:  0x00,
		Consts.CPU_Registers.Y:  0x00,
		Consts.CPU_Registers.PC: 0xFFFC,
		Consts.CPU_Registers.SP: 0xFD,
		Consts.CPU_Registers.P:  0x34
	}


func cpu_loop():
	var last_tick = float(Time.get_ticks_usec())
	
	var runs_per_frame = 10000
	var runs = 0
	
	while _is_running:
		var tick = float(Time.get_ticks_usec())
		var delta = (tick - last_tick) / 1000000.0
		last_delta = delta
		
		runs += 1
		if runs >= runs_per_frame:
			runs = 0
			ticked.emit.call_deferred()
			await get_tree().process_frame
		
		var adjusted_delta = delta * cpu_speed_multiplier * _fps_throttle
		_seconds_this_cycle += adjusted_delta
		_seconds_this_scanline += adjusted_delta
		
		if _seconds_this_cycle >= NTSC_SECONDS_PER_CYCLE:
			_seconds_this_cycle = 0.0
			
			_cycles += 1
			_cycles_before_next_instruction -= 1
			
			if _seconds_this_scanline > NTSC_CYCLES_PER_SCANLINE * NTSC_SECONDS_PER_CYCLE:
				_scanline += 1
			
			if _scanline > NTSC_SCANLINES:
				# VBlank begins.
				
				_cpu_memory[Consts.PPU_REGISTERS + Consts.PPU_Registers.PPUSTATUS] |= 0x80
				var ppu_ctrl = _cpu_memory[Consts.PPU_REGISTERS + Consts.PPU_Registers.PPUCTRL]
				
				if ppu_ctrl & 0x80 == 1:
					pending_interrupt = Consts.Interrupts.NMI
			
			if _scanline > NTSC_SCANLINES + NTSC_VBLANK_SCANLINES:
				# VBlank ends.
				
				_frame += 1
				_scanline = 0
				
				_cpu_memory[Consts.PPU_REGISTERS + Consts.PPU_Registers.PPUSTATUS] &= 0x7F
			
			if _cycles_before_next_instruction <= 0:
				tick()
		
		last_tick = tick


func tick():
	var pc = registers[Consts.CPU_Registers.PC]
	
	if pending_interrupt == Consts.Interrupts.NMI:
		var old_pc = registers[Consts.CPU_Registers.PC]
		Opcodes.JSR(Opcodes.OperandAddressingContext.new(
			Consts.AddressingModes.Absolute, _nmi_vector
		))
		
		_cycles_before_next_instruction = 5 #TODO: Is this right?
		
		pending_interrupt = Consts.Interrupts.NONE
		
		_cpu_memory[Consts.PPU_REGISTERS + Consts.PPU_Registers.PPUSTATUS] |= 0x80
		
		return
	
	var instruction_data = get_instruction_data(pc)
	
	if instruction_data:
		var starting_operand = instruction_data.context.value
		
		instruction_data.execute()
		
		_cycles_before_next_instruction = Consts.OPCODE_DATA[instruction_data.opcode]['cycles']
		
		#if instruction_data.context.address_mode in [
			#Consts.AddressingModes.Absolute_X, Consts.AddressingModes.Absolute_Y,
			#Consts.AddressingModes.ZPInd_Y, Consts.AddressingModes.Relative
		#]:
			#if starting_operand & 0xFF00 != instruction_data.context.value & 0xFF00:
				#_cycles_before_next_instruction += 1
		
		last_instruction = instruction_data
	else:
		print('Invalid opcode, stopping.')
		_is_running = false
		return
	
	if registers[Consts.CPU_Registers.PC] == pc:
		# Don't increment the program counter if we just jumped
		registers[Consts.CPU_Registers.PC] += instruction_data.bytes_to_read


func get_instruction_data(start_byte: int):
	var next_opcode = _cpu_memory[start_byte]
	
	if next_opcode == 0xFF or next_opcode == 0:
		_is_running = false
		return
	
	var instruction = Consts.OPCODE_DATA[next_opcode]['instruction']
	var addressing_mode = Consts.OPCODE_DATA[next_opcode]['address_mode']
	var bytes_to_read = Consts.BYTES_PER_MODE[addressing_mode] - 1
	
	var value_low = 0
	var value_high = 0
	
	if bytes_to_read >= 1:
		value_low = _cpu_memory[start_byte + 1]
	if bytes_to_read >= 2:
		value_high = _cpu_memory[start_byte + 2]
	
	var context = Opcodes.OperandAddressingContext.new(addressing_mode, value_low + (value_high << 8))
	
	if not Opcodes.has_method(instruction):
		assert(false, 'Unrecognized instruction: %s' % instruction)
		return null
	
	return Opcodes.InstructionData.new(next_opcode, context)


func start_running():
	_cycles = 0
	
	ticked.emit()
	_is_running = true
	
	var cpu_thread = Thread.new()
	cpu_thread.start(cpu_loop)


func setup_rom(rom_path: String):
	_rom_mapper = NES_Mapper.create_mapper(rom_path)
	_rom_mapper.load_initial_map()
	
	_nmi_vector = read_word(0xFFFA)
	_reset_vector = read_word(0xFFFC)
	_irq_vector = read_word(0xFFFE)
	
	registers[Consts.CPU_Registers.PC] = _reset_vector


func get_status_flag(status: int):
	return registers[Consts.CPU_Registers.P] & status


func set_status_flag(status: int, state: bool):
	if state:
		registers[Consts.CPU_Registers.P] |= status
	else:
		registers[Consts.CPU_Registers.P] &= ~status


func compile_script(script: String) -> PackedByteArray:
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
			bytecode.append(Consts.get_opcode(line, Consts.AddressingModes.Implied))
		elif len(operands) > 1:
			var is_branch = operands[0] in ["BCC", "BCS", "BNE", "BEQ", "BPL", "BMI", "BVC", "BVS"]
			
			var context = Opcodes.determine_addressing_context(operands[0], operands[1])
			if is_branch:
				context.address_mode = Consts.AddressingModes.Relative
			
			bytecode.append(Consts.get_opcode(operands[0], context.address_mode))
			
			var data_byte_count = Consts.BYTES_PER_MODE[context.address_mode]
			if data_byte_count >= 2:
				bytecode.append(context.value & 0xFF)
			if data_byte_count >= 3:
				bytecode.append(context.value >> 8)
	
	bytecode.append(0xFF)
	return bytecode


func get_memory_size(memory_section: Consts.MemoryTypes = Consts.MemoryTypes.CPU) -> int:
	if memory_section == Consts.MemoryTypes.CPU:
		return len(_cpu_memory)
	elif memory_section == Consts.MemoryTypes.PPU:
		return len(_ppu_memory)
	
	return 0


func read_byte(address: int, memory_section: Consts.MemoryTypes = Consts.MemoryTypes.CPU):
	var return_value = -1
	
	if memory_section == Consts.MemoryTypes.CPU:
		return_value = _cpu_memory[address]
	elif memory_section == Consts.MemoryTypes.PPU:
		return_value = _ppu_memory[address]
	
	_process_read_byte_side_effects(address, memory_section)
	
	return return_value


func read_word(address: int, memory_section: Consts.MemoryTypes = Consts.MemoryTypes.CPU):
	return read_byte(address, memory_section) + (read_byte(address + 1, memory_section) << 8)


func write_byte(address: int, value: int, memory_section: Consts.MemoryTypes = Consts.MemoryTypes.CPU):
	if not can_write_byte(address, memory_section):
		return
	
	if memory_section == Consts.MemoryTypes.CPU:
		_cpu_memory[address] = value
	elif memory_section == Consts.MemoryTypes.PPU:
		_ppu_memory[address] = value
	else:
		print_debug("Attempted to write to invalid memory section %s." % Consts.MemoryTypes.values()[memory_section])


func can_write_byte(address: int, memory_section: Consts.MemoryTypes = Consts.MemoryTypes.CPU) -> bool:
	return true


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
		_cpu_memory[to + i] = _cpu_memory[from + i]


func _process_read_byte_side_effects(address: int, memory_section: Consts.MemoryTypes = Consts.MemoryTypes.CPU):
	if address == Consts.PPU_REGISTERS + Consts.PPU_Registers.PPUSTATUS and memory_section == Consts.MemoryTypes.CPU:
		_cpu_memory[address] &= 0x7F


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
