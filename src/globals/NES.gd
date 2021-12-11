extends Node

enum CPU_Registers {
	A  = 0x0,
	X  = 0x1,
	Y  = 0x2,
	PC = 0x3,
	S  = 0x4,
	P  = 0x5
}

enum StatusFlags {
	Carry            = 0x01,
	Zero             = 0x02,
	InterruptDisable = 0x04,
	Decimal          = 0x08, # Unused on the NES
	B_1              = 0x10,
	B_2              = 0x20,
	Overflow         = 0x40,
	Negative         = 0x80
}

enum PPU_Registers {
	PPUCTRL   = 0x0,
	PPUMASK   = 0x1,
	PPUSTATUS = 0x2,
	OAMADDR   = 0x3,
	OAMDATA1  = 0x4,
	PPUSCROLL = 0x5,
	PPUADDR   = 0x6
	OAMDATA2  = 0x7
}

const MEMORY_SIZE = 0xFFFF

const WORK_RAM_ADDRESS  = 0x0000
const WORK_RAM_MIRROR   = 0x0800
const PPU_REGISTERS     = 0x2000
const PPU_MIRROR        = 0x2008
const APU_IO            = 0x4000
const CARTRIDGE_ADDRESS = 0x4020

const WORK_RAM_SIZE = 0x0800
const PPU_RAM_SIZE  = 0x0008


onready var memory = []
onready var registers = {
	CPU_Registers.A:  0x00,
	CPU_Registers.X:  0x00,
	CPU_Registers.Y:  0x00,
	CPU_Registers.PC: 0x00,
	CPU_Registers.S:  0xFD,
	CPU_Registers.P:  0x34
}

func _ready():
	init()


func init():
	memory = []
	for i in range(MEMORY_SIZE):
		memory.append(0)
	
	registers = {
		CPU_Registers.A:  0x00,
		CPU_Registers.X:  0x00,
		CPU_Registers.Y:  0x00,
		CPU_Registers.PC: 0x00,
		CPU_Registers.S:  0xFD,
		CPU_Registers.P:  0x34
	}


func _process(delta):
	pass


func get_status_flag(status: int):
	return registers[CPU_Registers.S] & status


func set_status_flag(status: int, state: bool):
	if state:
		registers[CPU_Registers.S] |= status
	else:
		registers[CPU_Registers.S] &= ~status


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
	if from + length > MEMORY_SIZE or from < 0:
		print_debug("Copy failed; From region would exceed memory limits.")
		return
	elif to + length > MEMORY_SIZE or to < 0:
		print_debug("Copy failed; To region would exceed memory limits.")
		return
	elif from + length >= to:
		print_debug("Copy failed; From region would overlap To region.")
		return
	
	for i in range(length):
		memory[to + i] = memory[from + i]


func _mirror_memory_regions():
	for i in range(3):
		copy_ram(WORK_RAM_ADDRESS, WORK_RAM_MIRROR + i * WORK_RAM_SIZE, WORK_RAM_SIZE)
	for i in range(1022):
		copy_ram(PPU_REGISTERS, PPU_MIRROR + i * PPU_RAM_SIZE, PPU_RAM_SIZE)
