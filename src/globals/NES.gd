extends Node

const NTSC_SECONDS_PER_CYCLE := 0.0000005589
const PAL_SECONDS_PER_CYCLE := 0.0000006015

const NTSC_CYCLES_PER_SCANLINE := 113.6666666667
const PAL_CYCLES_PER_SCANLINE := 106.5625

const NTSC_SCANLINES := 240
const PAL_SCANLINES := 239

const NTSC_VBLANK_SCANLINES := 20
const PAL_VBLANK_SCANLINES := 70

## The number of CPU instructions to run per second. -1 to run at max speed, 0 to run by manual steps only.
@export var instructions_per_second: int = 0

## Sets the speed of the emulated CPU. 1.0 equals the default value (60fps for NTSC/50fps for PAL), and 0.0 means the CPU is stopped.
@export var cpu_speed_multiplier: float = 0.0

@export var controllers: Array[NES_Controller]

@export var verbose_output = false

var is_stepping = false

var cpu_memory: CPU_Memory
var ppu_memory: PPU_Memory

var pending_interrupt := Consts.Interrupts.NONE

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

var _next_frame_start_time := 0.0
var _seconds_this_cycle := 0.0
var _seconds_this_scanline := 0.0

var _nmi_started := false

var _rom_mapper: NES_Mapper

var _nmi_vector: int
var _reset_vector: int
var _irq_vector: int

@onready var _instruction_data = Opcodes.InstructionData.new()

var _is_running = false

@onready var _cpu_thread: Thread = Thread.new()

var fps_avg := 0.0
var _test_prev_frame := 0
var _fps_history := []

var _frame_start_time := 0.0
var _prev_frame_start_time := 0.0

signal ticked
signal render_start
signal render_end


func _ready():
	init()


func _process(delta: float) -> void:
	_fps_history.append((_frame_start_time - _prev_frame_start_time) / 1000.0)
	if len(_fps_history) > 10:
		_fps_history.pop_front()
	
	fps_avg = 0.0
	for fps in _fps_history:
		fps_avg += fps
	fps_avg /= len(_fps_history)

	fps_avg = 1 / fps_avg
	
	_test_prev_frame = _frame


func init():
	cpu_memory = preload("res://src/globals/CPU_Memory.gd").new(CPU_Memory.CPU_MEMORY_SIZE)
	ppu_memory = preload("res://src/globals/PPU_Memory.gd").new(PPU_Memory.PPU_MEMORY_SIZE)

	cpu_memory.ppu_register_touched.connect(ppu_memory.on_ppu_register_touched)

	for controller in controllers:
		controller.init()


func cpu_loop():
	var last_tick = float(Time.get_ticks_msec())

	_frame_start_time = last_tick
	_prev_frame_start_time = last_tick
	
	var runs_per_frame = 20000
	var runs = 0

	var frames_rendered = 0

	while _is_running:
		if runs >= runs_per_frame:
			runs = 0
			await get_tree().process_frame
		
		var tick_time = float(Time.get_ticks_msec())
		var delta = (tick_time - last_tick) / 1000.0

		var adjusted_delta = delta * cpu_speed_multiplier

		# _seconds_this_cycle += adjusted_delta
		# _seconds_this_scanline += adjusted_delta
		# if _seconds_this_cycle >= NTSC_SECONDS_PER_CYCLE:
			# _seconds_this_cycle = 0.0

		var frames_to_render = max(1, floor(cpu_speed_multiplier / 100))

		if cpu_speed_multiplier == 0.0:
			await get_tree().process_frame
			continue
		
		_cycles += _cycles_before_next_instruction
		
		if _next_frame_start_time > 0:
			_next_frame_start_time -= adjusted_delta
			await get_tree().process_frame
			continue
		
		if _cycles > NTSC_CYCLES_PER_SCANLINE * _scanline:
			_scanline += 1
		
		if not _nmi_started and _scanline > NTSC_SCANLINES and cpu_memory.read_byte(Consts.PPU_Registers.PPUSTATUS, false) & 0x80 == 0:
			# VBlank begins.

			var ppu_status = cpu_memory.read_byte(Consts.PPU_Registers.PPUSTATUS, false)
			var ppu_ctrl = cpu_memory.read_byte(Consts.PPU_Registers.PPUCTRL, false)
			
			cpu_memory.write_byte(Consts.PPU_Registers.PPUSTATUS, ppu_status | 0x80, false)
			
			if ppu_ctrl & 0x80 > 0:
				pending_interrupt = Consts.Interrupts.NMI
				_nmi_started = true
			
			render_start.emit()
		
		if _scanline > NTSC_SCANLINES + NTSC_VBLANK_SCANLINES:
			# VBlank ends.

			_prev_frame_start_time = _frame_start_time
			_frame_start_time = last_tick

			_frame += 1
			_scanline = 0
			_cycles = 0
			
			var ppu_status = cpu_memory.read_byte(Consts.PPU_Registers.PPUSTATUS, false)
			cpu_memory.write_byte(Consts.PPU_Registers.PPUSTATUS, ppu_status & 0x7F, false)

			frames_rendered += 1
			
			render_end.emit.call_deferred()
			ticked.emit.call_deferred()

			if frames_rendered >= frames_to_render:
				_next_frame_start_time = NTSC_SECONDS_PER_CYCLE * NTSC_CYCLES_PER_SCANLINE * (NTSC_SCANLINES + NTSC_VBLANK_SCANLINES)

				await get_tree().process_frame
				frames_rendered = 0

			_nmi_started = false
		
		runs += 1
		
		var pc = cpu_memory.registers[Consts.CPU_Registers.PC]
		
		if pending_interrupt == Consts.Interrupts.NMI:
			var old_pc = cpu_memory.registers[Consts.CPU_Registers.PC]

			Opcodes.push_to_stack(old_pc >> 8)
			Opcodes.push_to_stack(old_pc & 0xFF)
			Opcodes.push_to_stack(cpu_memory.registers[Consts.CPU_Registers.P])

			if verbose_output:
				print("[%d]: Jumping to NMI; $%02X -> $%02X" % [Time.get_ticks_usec(), old_pc, _nmi_vector])

			cpu_memory.registers[Consts.CPU_Registers.PC] = _nmi_vector

			_cycles_before_next_instruction = 5 # TODO: Is this right?
			
			pending_interrupt = Consts.Interrupts.NONE
			
			var ppu_status = cpu_memory.read_byte(Consts.PPU_Registers.PPUSTATUS, false)
			cpu_memory.write_byte(Consts.PPU_Registers.PPUSTATUS, ppu_status | 0x80, false)
			
			continue
		
		if pc in _cached_opcode_data:
			var opcode_data = _cached_opcode_data[pc]

			_instruction_data.opcode = opcode_data[0]
			_instruction_data.context.value = opcode_data[1]
			_instruction_data.context.address_mode = Consts.OPCODE_DATA[opcode_data[0]]['address_mode']
		else:
			var next_opcode = cpu_memory.read_byte(pc, false)
			
			if next_opcode == 0xFF or next_opcode == 0 or next_opcode not in Consts.OPCODE_DATA:
				print("[Thread ID %s] Invalid opcode %02X encountered at address $%04X, stopping execution." % [_cpu_thread.get_id(), next_opcode, pc])
				_is_running = false
				_cpu_thread.wait_to_finish()
				return
			
			_instruction_data.opcode = next_opcode
			_instruction_data.context.address_mode = Consts.OPCODE_DATA[next_opcode]['address_mode']

			var bytes_to_read = Consts.BYTES_PER_MODE[_instruction_data.context.address_mode] - 1

			var value_low = 0
			var value_high = 0
			
			if bytes_to_read >= 1:
				value_low = cpu_memory.read_byte(pc + 1, false)
			if bytes_to_read >= 2:
				value_high = cpu_memory.read_byte(pc + 2, false)
			
			_instruction_data.context.value = value_low + (value_high << 8)

			_cached_opcode_data[pc] = [next_opcode, _instruction_data.context.value]
		
		if verbose_output:
			print('Executing instruction: %s' % str(_instruction_data))
		
		var address = 0x0
		var address_value = 0x0
		if _instruction_data.context.address_mode == Consts.AddressingModes.Immediate:
			address_value = _instruction_data.context.value
		elif _instruction_data.context.address_mode == Consts.AddressingModes.Accumulator:
			address_value = cpu_memory.registers[Consts.CPU_Registers.A]
		elif _instruction_data.context.address_mode == Consts.AddressingModes.Implied:
			address_value = cpu_memory.registers[Consts.CPU_Registers.A]
		elif _instruction_data.instruction not in ['STA', 'STX', 'STY']:
			address = _instruction_data.context.value
			
			if _instruction_data.context.address_mode == Consts.AddressingModes.Indirect:
				# Getting the indrect address value (we'll look up the value later.)
				if address & 0x00FF == 0xFF:
					# Indirect addressing cannot cross page boundaries,
					#   so the high bit is read from the start of the page instead.
					address = cpu_memory.memory_bytes[address] + \
						(cpu_memory.memory_bytes[address - 0xFF] << 8)
				else:
					address = cpu_memory.read_word(address)

			elif _instruction_data.context.address_mode == Consts.AddressingModes.Absolute_X \
					or _instruction_data.context.address_mode == Consts.AddressingModes.ZeroPage_X \
					or _instruction_data.context.address_mode == Consts.AddressingModes.ZPInd_X:
				# Indexing by X
				address += cpu_memory.registers[Consts.CPU_Registers.X]
			elif _instruction_data.context.address_mode == Consts.AddressingModes.Absolute_Y \
					or _instruction_data.context.address_mode == Consts.AddressingModes.ZeroPage_Y:
				# Indexing by Y (ZPInd_Y is handled separately below.)
				address += cpu_memory.registers[Consts.CPU_Registers.Y]
			elif _instruction_data.context.address_mode == Consts.AddressingModes.Relative:
				# Relative indexing is limited to a signed byte
				if address > 0x80:
					address -= 0x100
				assert(address >= -128 and address <= 127)
				
			if _instruction_data.context.address_mode == Consts.AddressingModes.ZeroPage_X \
					or _instruction_data.context.address_mode == Consts.AddressingModes.ZeroPage_Y:
				# Ensuring we stay on the zero page
				address %= 0x100
			elif _instruction_data.context.address_mode == Consts.AddressingModes.ZPInd_X:
				# Ensuring we stay on the zero page, and grabbing the high byte while we're at it
				var high_address = (address + 1) % 256
				address %= 0x100
				
				address = cpu_memory.read_byte(address) + (cpu_memory.read_byte(high_address) << 8)
			elif _instruction_data.context.address_mode == Consts.AddressingModes.ZPInd_Y:
				# ZPInd_Y works slightly differently
				var high_address = (address + 1) % 256
				
				address = cpu_memory.read_byte(address) + (cpu_memory.read_byte(high_address) << 8)
				address += cpu_memory.registers[Consts.CPU_Registers.Y]
			
			address %= 0x10000
			
			address_value = cpu_memory.read_byte(address)
		
		match _instruction_data.instruction:
			'LDA':
				cpu_memory.registers[Consts.CPU_Registers.A] = address_value
				
				if address_value == 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if address_value >= 0x80:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
			'LDX':
				cpu_memory.registers[Consts.CPU_Registers.X] = address_value
				
				if address_value == 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if address_value >= 0x80:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
			'LDY':
				cpu_memory.registers[Consts.CPU_Registers.Y] = address_value
				
				if address_value == 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if address_value >= 0x80:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
			'BNE':
				if _instruction_data.context.address_mode != Consts.AddressingModes.Relative:
					assert(false, "Invalid addressing method for branch.")
				
				if !cpu_memory.registers[Consts.CPU_Registers.P] & Consts.StatusFlags.Zero:
					if address != 0:
						cpu_memory.registers[Consts.CPU_Registers.PC] += address + 2
			'BEQ':
				if _instruction_data.context.address_mode != Consts.AddressingModes.Relative:
					assert(false, "Invalid addressing method for branch.")
				
				if cpu_memory.registers[Consts.CPU_Registers.P] & Consts.StatusFlags.Zero:
					if address != 0:
						cpu_memory.registers[Consts.CPU_Registers.PC] += address + 2
			'BCC':
				if _instruction_data.context.address_mode != Consts.AddressingModes.Relative:
					assert(false, "Invalid addressing method for branch.")
				
				if !cpu_memory.registers[Consts.CPU_Registers.P] & Consts.StatusFlags.Carry:
					cpu_memory.registers[Consts.CPU_Registers.PC] += address + 2
			'BCS':
				if _instruction_data.context.address_mode != Consts.AddressingModes.Relative:
					assert(false, "Invalid addressing method for branch.")
				
				if cpu_memory.registers[Consts.CPU_Registers.P] & Consts.StatusFlags.Carry:
					cpu_memory.registers[Consts.CPU_Registers.PC] += address + 2
			'BPL':
				if _instruction_data.context.address_mode != Consts.AddressingModes.Relative:
					assert(false, "Invalid addressing method for branch.")
				
				if !cpu_memory.registers[Consts.CPU_Registers.P] & Consts.StatusFlags.Negative:
					if address != 0:
						cpu_memory.registers[Consts.CPU_Registers.PC] += address + 2
			'BMI':
				if _instruction_data.context.address_mode != Consts.AddressingModes.Relative:
					assert(false, "Invalid addressing method for branch.")
				
				if cpu_memory.registers[Consts.CPU_Registers.P] & Consts.StatusFlags.Negative:
					if address != 0:
						cpu_memory.registers[Consts.CPU_Registers.PC] += address + 2
			'BVC':
				if _instruction_data.context.address_mode != Consts.AddressingModes.Relative:
					assert(false, "Invalid addressing method for branch.")
				
				if !cpu_memory.registers[Consts.CPU_Registers.P] & Consts.StatusFlags.Overflow:
					if address != 0:
						cpu_memory.registers[Consts.CPU_Registers.PC] += address + 2
			'BVS':
				if _instruction_data.context.address_mode != Consts.AddressingModes.Relative:
					assert(false, "Invalid addressing method for branch.")
				
				if cpu_memory.registers[Consts.CPU_Registers.P] & Consts.StatusFlags.Overflow:
					if address != 0:
						cpu_memory.registers[Consts.CPU_Registers.PC] += address + 2
			'INC':
				address_value += 1
				
				address_value &= 0xFF
				
				if address_value == 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if address_value >= 0x80:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
				cpu_memory.write_byte(address, address_value)
			'INX':
				var x = cpu_memory.registers[Consts.CPU_Registers.X]
				
				x += 1
				
				x &= 0xFF
				
				if x == 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if x >= 0x80:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
				cpu_memory.registers[Consts.CPU_Registers.X] = x
			'INY':
				var y = cpu_memory.registers[Consts.CPU_Registers.Y]
				
				y += 1
				
				y &= 0xFF
				
				if y == 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if y >= 0x80:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
				cpu_memory.registers[Consts.CPU_Registers.Y] = y
			'DEC':
				address_value -= 1
				if address_value < 0:
					address_value = 0x100 + address_value
				
				address_value &= 0xFF
				
				if address_value == 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if address_value >= 0x80:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
				cpu_memory.write_byte(address, address_value)
			'DEX':
				var x = cpu_memory.registers[Consts.CPU_Registers.X]
				
				x -= 1
				if x < 0:
					x = 0x100 + x
				
				x &= 0xFF
				
				if x == 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if x >= 0x80:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
				
				cpu_memory.registers[Consts.CPU_Registers.X] = x
			'DEY':
				var y = cpu_memory.registers[Consts.CPU_Registers.Y]
				
				y -= 1
				if y < 0:
					y = 0x100 + y
				
				y &= 0xFF
				
				if y == 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if y >= 0x80:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
				
				cpu_memory.registers[Consts.CPU_Registers.Y] = y
			'AND':
				var a = cpu_memory.registers[Consts.CPU_Registers.A]
				a &= address_value
				
				if a == 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if a >= 0x80:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
				cpu_memory.registers[Consts.CPU_Registers.A] = a
			'ORA':
				var a = cpu_memory.registers[Consts.CPU_Registers.A]
				a |= address_value
				
				if a == 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if a >= 0x80:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
				cpu_memory.registers[Consts.CPU_Registers.A] = a
			'EOR':
				var a = cpu_memory.registers[Consts.CPU_Registers.A]
				a ^= address_value
				
				if a == 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if a >= 0x80:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
				cpu_memory.registers[Consts.CPU_Registers.A] = a
			'CMP':
				var a = cpu_memory.registers[Consts.CPU_Registers.A]
				
				if a >= address_value:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Carry
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Carry
				if a == address_value:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if (a - address_value) & 0x80 > 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
			'CPX':
				var x = cpu_memory.registers[Consts.CPU_Registers.X]
				
				if x >= address_value:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Carry
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Carry
				if x == address_value:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if (x - address_value) & 0x80 > 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
			'CPY':
				var y = cpu_memory.registers[Consts.CPU_Registers.Y]
				
				if y >= address_value:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Carry
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Carry
				if y == address_value:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if (y - address_value) & 0x80 > 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
			'BIT':
				var a = cpu_memory.registers[Consts.CPU_Registers.A]
				
				if a & address_value == 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if address_value & 0x80 > 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
				if address_value & 0x40 > 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Overflow
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Overflow
			'STA':
				write_value_to_memory(_instruction_data, cpu_memory.registers[Consts.CPU_Registers.A])
			'STX':
				write_value_to_memory(_instruction_data, cpu_memory.registers[Consts.CPU_Registers.X])
			'STY':
				write_value_to_memory(_instruction_data, cpu_memory.registers[Consts.CPU_Registers.Y])
			'TAX':
				transfer(_instruction_data, Consts.CPU_Registers.A, Consts.CPU_Registers.X, true)
			'TXA':
				transfer(_instruction_data, Consts.CPU_Registers.X, Consts.CPU_Registers.A, true)
			'TAY':
				transfer(_instruction_data, Consts.CPU_Registers.A, Consts.CPU_Registers.Y, true)
			'TYA':
				transfer(_instruction_data, Consts.CPU_Registers.Y, Consts.CPU_Registers.A, true)
			'TSX':
				transfer(_instruction_data, Consts.CPU_Registers.SP, Consts.CPU_Registers.X, true)
			'TXS':
				transfer(_instruction_data, Consts.CPU_Registers.X, Consts.CPU_Registers.SP, false)
			'ADC':
				var a = cpu_memory.registers[Consts.CPU_Registers.A]
				var new_a = a
				
				if cpu_memory.registers[Consts.CPU_Registers.P] & Consts.StatusFlags.Carry:
					new_a += 1
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Carry
				
				new_a += address_value

				var overflowed = (new_a ^ a) & (new_a ^ address_value) & 0x80 > 0
				
				if overflowed:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Overflow
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Overflow
				if new_a > 0xFF:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Carry
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Carry

				new_a &= 0xFF
				
				if new_a == 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if new_a >= 0x80:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
				cpu_memory.registers[Consts.CPU_Registers.A] = new_a
			'SBC':
				var a = cpu_memory.registers[Consts.CPU_Registers.A]
				var new_a = a
				
				if not cpu_memory.registers[Consts.CPU_Registers.P] & Consts.StatusFlags.Carry:
					new_a -= 1
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Carry
				
				new_a -= address_value

				var overflowed = (new_a ^ a) & (new_a ^ ~address_value) & 0x80 > 0
				
				if !(new_a < 0):
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Carry
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Carry
				if overflowed:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Overflow
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Overflow

				new_a = (0x100 + new_a) & 0xFF
				
				if new_a == 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if new_a >= 0x80:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
				
				cpu_memory.registers[Consts.CPU_Registers.A] = new_a
			'ASL':
				var shifted_value = (address_value << 1) & 0xFF
				
				if address_value & 0x80:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Carry
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Carry
				if shifted_value == 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if shifted_value >= 0x80:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
				
				write_value_to_memory(_instruction_data, shifted_value)
			'LSR':
				var shifted_value = (address_value >> 1) & 0xFF
				
				if address_value & 0x01:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Carry
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Carry
				if shifted_value == 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if shifted_value >= 0x80:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
				
				write_value_to_memory(_instruction_data, shifted_value)
			'ROL':
				var shifted_value = (address_value << 1) & 0xFF
				if cpu_memory.registers[Consts.CPU_Registers.P] & Consts.StatusFlags.Carry > 0:
					shifted_value |= 0x01
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Carry
				
				if address_value & 0x80:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Carry
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Carry
				if shifted_value == 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if shifted_value >= 0x80:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
				
				write_value_to_memory(_instruction_data, shifted_value)
			'ROR':
				var shifted_value = (address_value >> 1) & 0xFF
				if cpu_memory.registers[Consts.CPU_Registers.P] & Consts.StatusFlags.Carry > 0:
					shifted_value |= 0x80
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Carry
				
				if address_value & 0x01:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Carry
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Carry
				if shifted_value == 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if shifted_value >= 0x80:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
				
				write_value_to_memory(_instruction_data, shifted_value)
			'PHA':
				Opcodes.push_to_stack(cpu_memory.registers[Consts.CPU_Registers.A])
			'PLA':
				cpu_memory.registers[Consts.CPU_Registers.A] = Opcodes.pull_from_stack()

				var a = cpu_memory.registers[Consts.CPU_Registers.A]
				
				if a == 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
				if a & 0x80 > 0:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative
			'PHP':
				Opcodes.push_to_stack(cpu_memory.registers[Consts.CPU_Registers.P])
				
				var state_stack_addr = 0x0100 + cpu_memory.registers[Consts.CPU_Registers.SP] + 1
				var state_flags = cpu_memory.read_byte(state_stack_addr)
				cpu_memory.write_byte(state_stack_addr, state_flags | 0x30)
			'PLP':
				cpu_memory.registers[Consts.CPU_Registers.P] = Opcodes.pull_from_stack() & 0b11101111
			'JMP':
				if _instruction_data.context.address_mode != Consts.AddressingModes.Absolute and _instruction_data.context.address_mode != Consts.AddressingModes.Indirect:
					assert(false, "Invalid addressing method for jump.")
				
				var new_pc = cpu_memory.registers[Consts.CPU_Registers.PC]

				var new_address = _instruction_data.context.value if _instruction_data.context.address_mode == Consts.AddressingModes.Absolute else address
				cpu_memory.registers[Consts.CPU_Registers.PC] = new_address

				if verbose_output:
					print("[%d]: Jumped; $%02X -> $%02X" % [Time.get_ticks_usec(), new_pc, cpu_memory.registers[Consts.CPU_Registers.PC]])
			'JSR':
				if _instruction_data.context.address_mode != Consts.AddressingModes.Absolute:
					assert(false, "Invalid addressing method for jump.")
				
				var new_pc = cpu_memory.registers[Consts.CPU_Registers.PC] + 2
				Opcodes.push_to_stack(new_pc >> 8)
				Opcodes.push_to_stack(new_pc & 0xFF)
				
				cpu_memory.registers[Consts.CPU_Registers.PC] = _instruction_data.context.value

				if verbose_output:
					print("[%d]: Jumped to subroutine; $%02X -> $%02X" % [Time.get_ticks_usec(), new_pc, cpu_memory.registers[Consts.CPU_Registers.PC]])
			'RTS':
				var new_pc = cpu_memory.registers[Consts.CPU_Registers.PC]

				cpu_memory.registers[Consts.CPU_Registers.PC] = Opcodes.pull_from_stack() + (Opcodes.pull_from_stack() << 8) + 1
				
				if verbose_output:
					print("[%d]: Returned from subroutine; $%02X -> $%02X" % [Time.get_ticks_usec(), new_pc, cpu_memory.registers[Consts.CPU_Registers.PC]])
			'RTI':
				var new_pc = cpu_memory.registers[Consts.CPU_Registers.PC]

				cpu_memory.registers[Consts.CPU_Registers.P] = Opcodes.pull_from_stack()
				cpu_memory.registers[Consts.CPU_Registers.PC] = Opcodes.pull_from_stack() + (Opcodes.pull_from_stack() << 8)
				
				if verbose_output:
					print("[%d]: Returned from interrupt; $%02X -> $%02X" % [Time.get_ticks_usec(), new_pc, cpu_memory.registers[Consts.CPU_Registers.PC]])
			'CLC':
				if false:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Carry
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Carry
			'SEC':
				if true:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Carry
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Carry
			'CLD':
				if false:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Decimal
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Decimal
			'SED':
				if true:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Decimal
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Decimal
			'CLI':
				if false:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.InterruptDisable
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.InterruptDisable
			'SEI':
				if true:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.InterruptDisable
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.InterruptDisable
			'CLV':
				if false:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Overflow
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Overflow
			'BRK':
				var new_pc = cpu_memory.registers[Consts.CPU_Registers.PC]
				Opcodes.push_to_stack(new_pc & 0xFF)
				Opcodes.push_to_stack(new_pc >> 8)
				
				if 1:
					cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.InterruptDisable
				else:
					cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.InterruptDisable
				
				Opcodes.push_to_stack(cpu_memory.registers[Consts.CPU_Registers.P])
				
				var state_stack_addr = 0x0100 + cpu_memory.registers[Consts.CPU_Registers.SP] + 1
				var state_flags = cpu_memory.read_byte(state_stack_addr)
				cpu_memory.write_byte(state_stack_addr, state_flags | 0x10)
				
				cpu_memory.registers[Consts.CPU_Registers.PC] = 0xFFFE
		
		_cycles_before_next_instruction = Consts.OPCODE_DATA[_instruction_data.opcode]['cycles']
		
		#if instruction_data.address_mode in [
			#Consts.AddressingModes.Absolute_X, Consts.AddressingModes.Absolute_Y,
			#Consts.AddressingModes.ZPInd_Y, Consts.AddressingModes.Relative
		#]:
			#if starting_operand & 0xFF00 != instruction_data.value & 0xFF00:
				#_cycles_before_next_instruction += 1
		
		if cpu_memory.registers[Consts.CPU_Registers.PC] == pc:
			# Don't increment the program counter if we just jumped
			cpu_memory.registers[Consts.CPU_Registers.PC] += _instruction_data.bytes_to_read
		
		if is_stepping:
			is_stepping = false
			cpu_speed_multiplier = 0.0
			ticked.emit.call_deferred()
		
		last_tick = tick_time


func advance_to_next_tick():
	is_stepping = true
	cpu_speed_multiplier = 1.0

func transfer(instruction: Opcodes.InstructionData, from_register: int, to_register: int, update_status_flags: bool):
	cpu_memory.registers[to_register] = cpu_memory.registers[from_register]
	
	if update_status_flags:
		if cpu_memory.registers[from_register] == 0:
			cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Zero
		else:
			cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Zero
		
		if cpu_memory.registers[from_register] >= 0x80:
			cpu_memory.registers[Consts.CPU_Registers.P] |= Consts.StatusFlags.Negative
		else:
			cpu_memory.registers[Consts.CPU_Registers.P] &= ~Consts.StatusFlags.Negative

func write_value_to_memory(instruction: Opcodes.InstructionData, value, implied_register = Consts.CPU_Registers.A):
	if instruction.context.address_mode == Consts.AddressingModes.Accumulator:
		cpu_memory.registers[Consts.CPU_Registers.A] = value
	elif instruction.context.address_mode == Consts.AddressingModes.Implied:
		cpu_memory.registers[implied_register] = value
	else:
		var address = determine_memory_address(instruction)
		cpu_memory.write_byte(address, value)

func read_value_from_memory(instruction: Opcodes.InstructionData, implied_register = Consts.CPU_Registers.A):
	if instruction.context.address_mode == Consts.AddressingModes.Immediate:
		return instruction.context.value
	elif instruction.context.address_mode == Consts.AddressingModes.Accumulator:
		return cpu_memory.registers[Consts.CPU_Registers.A]
	elif instruction.context.address_mode == Consts.AddressingModes.Implied:
		return cpu_memory.registers[implied_register]
	else:
		var address = determine_memory_address(instruction)
		
		return cpu_memory.read_byte(address)

func determine_memory_address(instruction: Opcodes.InstructionData):
	var address = instruction.context.value
	
	if instruction.context.address_mode == Consts.AddressingModes.Indirect:
		# Getting the indrect address value (we'll look up the value later.)
		if address & 0x00FF == 0xFF:
			# Indirect addressing cannot cross page boundaries,
			#   so the high bit is read from the start of the page instead.
			address = cpu_memory.memory_bytes[address] + \
				(cpu_memory.memory_bytes[address - 0xFF] << 8)
		else:
			address = cpu_memory.read_word(address)

	elif instruction.context.address_mode == Consts.AddressingModes.Absolute_X \
			or instruction.context.address_mode == Consts.AddressingModes.ZeroPage_X \
			or instruction.context.address_mode == Consts.AddressingModes.ZPInd_X:
		# Indexing by X
		address += cpu_memory.registers[Consts.CPU_Registers.X]
	elif instruction.context.address_mode == Consts.AddressingModes.Absolute_Y \
			or instruction.context.address_mode == Consts.AddressingModes.ZeroPage_Y:
		# Indexing by Y (ZPInd_Y is handled separately below.)
		address += cpu_memory.registers[Consts.CPU_Registers.Y]
	elif instruction.context.address_mode == Consts.AddressingModes.Relative:
		# Relative indexing is limited to a signed byte
		if address > 0x80:
			address -= 0x100
		assert(address >= -128 and address <= 127)
		
	if instruction.context.address_mode == Consts.AddressingModes.ZeroPage_X \
			or instruction.context.address_mode == Consts.AddressingModes.ZeroPage_Y:
		# Ensuring we stay on the zero page
		address %= 0x100
	elif instruction.context.address_mode == Consts.AddressingModes.ZPInd_X:
		# Ensuring we stay on the zero page, and grabbing the high byte while we're at it
		var high_address = (address + 1) % 256
		address %= 0x100
		
		return cpu_memory.read_byte(address) + (cpu_memory.read_byte(high_address) << 8)
	elif instruction.context.address_mode == Consts.AddressingModes.ZPInd_Y:
		# ZPInd_Y works slightly differently
		var high_address = (address + 1) % 256
		
		address = cpu_memory.read_byte(address) + (cpu_memory.read_byte(high_address) << 8)
		address += cpu_memory.registers[Consts.CPU_Registers.Y]
	
	address %= 0x10000
	
	return address


var _cached_opcode_data = {}


func clear_memory():
	cpu_memory.clear_memory()
	ppu_memory.clear_memory()
	
	_cached_opcode_data.clear()


func start_running():
	_cycles = 0
	_scanline = 0
	_frame = 0
	
	_seconds_this_cycle = 0.0
	_seconds_this_scanline = 0.0
	
	cpu_memory.init_registers()
	ppu_memory.init_registers()
	
	ticked.emit()
	_is_running = true
	
	print("Starting execution.")

	_cpu_thread.start.call_deferred(cpu_loop)


func stop_running():
	if _cpu_thread != null && (_cpu_thread.is_alive()):
		print("Waiting for previous execution to stop.")
		_is_running = false
		_cpu_thread.wait_to_finish()


func setup_rom(rom_path: String):
	var rom_bytes = FileAccess.get_file_as_bytes(rom_path)

	if len(rom_bytes) < 16000:
		# This probably isn't a ROM.
		print("ROM %s is too small, is this really a ROM?" % rom_path)
		return
	
	_rom_mapper = NES_Mapper.create_mapper(rom_path)
	if _rom_mapper == null:
		print("Unable to find mapper emulator for %s." % rom_path)
		return
	
	_rom_mapper.load_initial_map()
	
	_nmi_vector = cpu_memory.read_word(0xFFFA, false)
	_reset_vector = cpu_memory.read_word(0xFFFC, false)
	_irq_vector = cpu_memory.read_word(0xFFFE, false)
	
	cpu_memory.registers[Consts.CPU_Registers.PC] = _reset_vector


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
			bytes_so_far += Consts.BYTES_PER_MODE[context[0]]
	
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
			bytes_so_far += Consts.BYTES_PER_MODE[context[0]]
			
			for label in labels:
				if is_branch:
					operands[1] = operands[1].replace(label, str(labels[label] - bytes_so_far))
				else:
					operands[1] = operands[1].replace(label, str(CPU_Memory.CARTRIDGE_ADDRESS + labels[label]))
			
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
				context[0] = Consts.AddressingModes.Relative
			
			bytecode.append(Consts.get_opcode(operands[0], context[0]))
			
			var data_byte_count = Consts.BYTES_PER_MODE[context[0]]
			if data_byte_count >= 2:
				bytecode.append(_instruction_data.context.value & 0xFF)
			if data_byte_count >= 3:
				bytecode.append(context.value >> 8)
	
	bytecode.append(0xFF)
	return bytecode
