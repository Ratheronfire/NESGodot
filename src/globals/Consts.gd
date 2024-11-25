extends Node

## The NES's CPU registers.
enum CPU_Registers {
	A  = 0x0, ## The accumulator.
	X  = 0x1, ## The X index.
	Y  = 0x2, ## The Y index.
	PC = 0x3, ## The program counter.
	SP = 0x4, ## The stack pointer.
	P  = 0x5  ## Status flags. Explained in [Consts.StatusFlags].
}

## The status flags making up the SR register.
enum StatusFlags {
	Carry            = 0x01, ## The carry flag for arithmetic and shift operations.
	Zero             = 0x02, ## Set to 1 if the previous instruction evaluated to zero.
	InterruptDisable = 0x04, ## When this flag is enabled, IRQ interrupts are blocked.
	Decimal          = 0x08, ## Enables binary-coded decimal mode. Unused on the NES.
	B_1              = 0x10, ## Set by the CPU following interrupts. Set to 0 after NMI or IRQ, and 1 after BRK or PHP.
	B_2              = 0x20, ## This flag is always set to 1.
	Overflow         = 0x40, ## Set to 1 if arithmetic instructions overflow.
	Negative         = 0x80  ## Set to 1 if the previous instruction resulted in a negative value (mirrors bit 7 of the resulting number).
}

enum PPU_Registers {
	PPUCTRL   = 0x0,
	PPUMASK   = 0x1,
	PPUSTATUS = 0x2,
	OAMADDR   = 0x3,
	OAMDATA1  = 0x4,
	PPUSCROLL = 0x5,
	PPUADDR   = 0x6,
	OAMDATA2  = 0x7
}

## The different modes of addressing data for an instruction.
enum AddressingModes {
	Implied, ## This instruction's addressing mode is implied (e.g. RTS).
	Accumulator, ## This instruction acts on the accumulator (e.g. LSR A).
	Immediate, ## The value passed to the instruction is used as the addressed value directly.
	Absolute, ## Fetches the value from a 16-bit address anywhere in memory.
	Absolute_X, ## Fetches the value from a 16-bit address anywhere in memory, indexed by X.
	Absolute_Y, ## Fetches the value from a 16-bit address anywhere in memory, indexed by Y.
	ZeroPage, ## Fetches the value from the zero page.
	ZeroPage_X, ## Fetches the value from the zero page, indexed by X.
	ZeroPage_Y, ## Fetches the value from the zero page, indexed by Y.
	Relative, ## Fetches a value from an address relative to the program counter. Limited to 128 in either direction.
	Indirect, ## Fetches a 16-bit address, then treats that value as an address and fetches from that.
	ZPInd_X, ## Indexed indirect. Fetches a zero-page address indexed by X, then fetches from the address specified. (d,x)
	ZPInd_Y ## Indirect indexed. Fetches a zero-page address, then fetches from the address specified, indexed by Y. (d),y
}


# NES RAM Values
const MEMORY_SIZE = 0x10000

const WORK_RAM_ADDRESS  = 0x0000
const WORK_RAM_MIRROR   = 0x0800
const PPU_REGISTERS     = 0x2000
const PPU_MIRROR        = 0x2008
const APU_IO            = 0x4000
const CARTRIDGE_ADDRESS = 0x4020

const WORK_RAM_SIZE = 0x0800
const PPU_RAM_SIZE  = 0x0008


# Opcode values
const BYTES_PER_MODE = {
	AddressingModes.Implied: 1,
	AddressingModes.Accumulator: 1,
	AddressingModes.Immediate: 2,
	AddressingModes.Absolute: 3,
	AddressingModes.Absolute_X: 3,
	AddressingModes.Absolute_Y: 3,
	AddressingModes.ZeroPage: 2,
	AddressingModes.ZeroPage_X: 2,
	AddressingModes.ZeroPage_Y: 2,
	AddressingModes.Relative: 2,
	AddressingModes.Indirect: 3,
	AddressingModes.ZPInd_X: 2,
	AddressingModes.ZPInd_Y: 2
}

const INSTRUCTION_OPCODES = {
	'LDA': {
		AddressingModes.Absolute: 0xAD,
		AddressingModes.Absolute_X: 0xBD,
		AddressingModes.Absolute_Y: 0xB9,
		AddressingModes.Immediate: 0xA9,
		AddressingModes.ZeroPage: 0xA5,
		AddressingModes.ZPInd_X: 0xA1,
		AddressingModes.ZeroPage_X: 0xB5,
		AddressingModes.ZPInd_Y: 0xB1
	},
	'LDX': {
		AddressingModes.Absolute: 0xAE,
		AddressingModes.Absolute_Y: 0xBE,
		AddressingModes.Immediate: 0xA2,
		AddressingModes.ZeroPage: 0xA6,
		AddressingModes.ZeroPage_Y: 0xB6
	},
	'LDY': {
		AddressingModes.Absolute: 0xAC,
		AddressingModes.Absolute_X: 0xBC,
		AddressingModes.Immediate: 0xA0,
		AddressingModes.ZeroPage: 0xA4,
		AddressingModes.ZeroPage_X: 0xB4
	},
	'STA': {
		AddressingModes.Absolute: 0x8D,
		AddressingModes.Absolute_X: 0x9D,
		AddressingModes.Absolute_Y: 0x99,
		AddressingModes.ZeroPage: 0x85,
		AddressingModes.ZPInd_X: 0x81,
		AddressingModes.ZeroPage_X: 0x95,
		AddressingModes.ZPInd_Y: 0x91
	},
	'STX': {
		AddressingModes.Absolute: 0x8E,
		AddressingModes.ZeroPage: 0x86,
		AddressingModes.ZeroPage_Y: 0x96
	},
	'STY': {
		AddressingModes.Absolute: 0x8C,
		AddressingModes.ZeroPage: 0x84,
		AddressingModes.ZeroPage_X: 0x94
	},
	'ADC': {
		AddressingModes.Absolute: 0x6D,
		AddressingModes.Absolute_X: 0x7D,
		AddressingModes.Absolute_Y: 0x79,
		AddressingModes.Immediate: 0x69,
		AddressingModes.ZeroPage: 0x65,
		AddressingModes.ZPInd_X: 0x61,
		AddressingModes.ZeroPage_X: 0x75,
		AddressingModes.ZPInd_Y: 0x71
	},
	'SBC': {
		AddressingModes.Absolute: 0xED,
		AddressingModes.Absolute_X: 0xFD,
		AddressingModes.Absolute_Y: 0xF9,
		AddressingModes.Immediate: 0xE9,
		AddressingModes.ZeroPage: 0xE5,
		AddressingModes.ZPInd_X: 0xE1,
		AddressingModes.ZeroPage_X: 0xF5,
		AddressingModes.ZPInd_Y: 0xF1
	},
	'INC': {
		AddressingModes.Absolute: 0xEE,
		AddressingModes.Absolute_X: 0xFE,
		AddressingModes.ZeroPage: 0xE6,
		AddressingModes.ZeroPage_X: 0xF6
	},
	'INX': {
		AddressingModes.Implied: 0xE8
	},
	'INY': {
		AddressingModes.Implied: 0xC8
	},
	'DEC': {
		AddressingModes.Absolute: 0xCE,
		AddressingModes.Absolute_X: 0xDE,
		AddressingModes.ZeroPage: 0xC6,
		AddressingModes.ZeroPage_X: 0xD6
	},
	'DEX': {
		AddressingModes.Implied: 0xCA
	},
	'DEY': {
		AddressingModes.Implied: 0x88
	},
	'ASL': {
		AddressingModes.Absolute: 0x0E,
		AddressingModes.Absolute_X: 0x1E,
		AddressingModes.Accumulator: 0x0A,
		AddressingModes.ZeroPage: 0x06,
		AddressingModes.ZeroPage_X: 0x16
	},
	'LSR': {
		AddressingModes.Absolute: 0x4E,
		AddressingModes.Absolute_X: 0x5E,
		AddressingModes.Accumulator: 0x4A,
		AddressingModes.ZeroPage: 0x46,
		AddressingModes.ZeroPage_X: 0x56
	},
	'ROL': {
		AddressingModes.Absolute: 0x2E,
		AddressingModes.Absolute_X: 0x3E,
		AddressingModes.Accumulator: 0x2A,
		AddressingModes.ZeroPage: 0x26,
		AddressingModes.ZeroPage_X: 0x36
	},
	'ROR': {
		AddressingModes.Absolute: 0x6E,
		AddressingModes.Absolute_X: 0x7E,
		AddressingModes.Accumulator: 0x6A,
		AddressingModes.ZeroPage: 0x66,
		AddressingModes.ZeroPage_X: 0x76
	},
	'AND': {
		AddressingModes.Absolute: 0x2D,
		AddressingModes.Absolute_X: 0x3D,
		AddressingModes.Absolute_Y: 0x39,
		AddressingModes.Immediate: 0x29,
		AddressingModes.ZeroPage: 0x25,
		AddressingModes.ZPInd_X: 0x21,
		AddressingModes.ZeroPage_X: 0x35,
		AddressingModes.ZPInd_Y: 0x31
	},
	'ORA': {
		AddressingModes.Absolute: 0x0D,
		AddressingModes.Absolute_X: 0x1D,
		AddressingModes.Absolute_Y: 0x19,
		AddressingModes.Immediate: 0x09,
		AddressingModes.ZeroPage: 0x05,
		AddressingModes.ZPInd_X: 0x01,
		AddressingModes.ZeroPage_X: 0x15,
		AddressingModes.ZPInd_Y: 0x11
	},
	'EOR': {
		AddressingModes.Absolute: 0x4D,
		AddressingModes.Absolute_X: 0x5D,
		AddressingModes.Absolute_Y: 0x59,
		AddressingModes.Immediate: 0x49,
		AddressingModes.ZeroPage: 0x45,
		AddressingModes.ZPInd_X: 0x41,
		AddressingModes.ZeroPage_X: 0x55,
		AddressingModes.ZPInd_Y: 0x51
	},
	'CMP': {
		AddressingModes.Absolute: 0xCD,
		AddressingModes.Absolute_X: 0xDD,
		AddressingModes.Absolute_Y: 0xD9,
		AddressingModes.Immediate: 0xC9,
		AddressingModes.ZeroPage: 0xC5,
		AddressingModes.ZPInd_X: 0xC1,
		AddressingModes.ZeroPage_X: 0xD5,
		AddressingModes.ZPInd_Y: 0xD1
	},
	'CPX': {
		AddressingModes.Absolute: 0xEC,
		AddressingModes.Immediate: 0xE0,
		AddressingModes.ZeroPage: 0xE4
	},
	'CPY': {
		AddressingModes.Absolute: 0xCC,
		AddressingModes.Immediate: 0xC0,
		AddressingModes.ZeroPage: 0xC4
	},
	'BIT': {
		AddressingModes.Absolute: 0x2C,
		AddressingModes.Immediate: 0x80,
		AddressingModes.ZeroPage: 0x24
	},
	'BCC': {
		AddressingModes.Relative: 0x90
	},
	'BCS': {
		AddressingModes.Relative: 0xB0
	},
	'BNE': {
		AddressingModes.Relative: 0xD0
	},
	'BEQ': {
		AddressingModes.Relative: 0xF0
	},
	'BPL': {
		AddressingModes.Relative: 0x10
	},
	'BMI': {
		AddressingModes.Relative: 0x30
	},
	'BVC': {
		AddressingModes.Relative: 0x50
	},
	'BVS': {
		AddressingModes.Relative: 0x70
	},
	'TAX': {
		AddressingModes.Implied: 0xAA
	},
	'TXA': {
		AddressingModes.Implied: 0x8A
	},
	'TAY': {
		AddressingModes.Implied: 0xA8
	},
	'TYA': {
		AddressingModes.Implied: 0x98
	},
	'TSX': {
		AddressingModes.Implied: 0xBA
	},
	'TXS': {
		AddressingModes.Implied: 0x9A
	},
	'PHA': {
		AddressingModes.Implied: 0x48
	},
	'PLA': {
		AddressingModes.Implied: 0x68
	},
	'PHP': {
		AddressingModes.Implied: 0x08
	},
	'PLP': {
		AddressingModes.Implied: 0x28
	},
	'JMP': {
		AddressingModes.Absolute: 0x4C,
		AddressingModes.Indirect: 0x6C
	},
	'JSR': {
		AddressingModes.Absolute: 0x20
	},
	'RTS': {
		AddressingModes.Absolute: 0x60
	},
	'RTI': {
		AddressingModes.Absolute: 0x40
	},
	'CLC': {
		AddressingModes.Implied: 0x18
	},
	'SEC': {
		AddressingModes.Implied: 0x38
	},
	'CLD': {
		AddressingModes.Implied: 0xD8
	},
	'SED': {
		AddressingModes.Implied: 0xF8
	},
	'CLI': {
		AddressingModes.Implied: 0x58
	},
	'SEI': {
		AddressingModes.Implied: 0x78
	},
	'CLV': {
		AddressingModes.Implied: 0xB8
	},
	'BRK': {
		AddressingModes.Immediate: 0x00
	},
	'NOP': {
		AddressingModes.Implied: 0xEA
	}
}

const OPCODE_MODES = {
	0xAD: AddressingModes.Absolute,
	0xBD: AddressingModes.Absolute_X,
	0xB9: AddressingModes.Absolute_Y,
	0xA9: AddressingModes.Immediate,
	0xA5: AddressingModes.ZeroPage,
	0xA1: AddressingModes.ZPInd_X,
	0xB5: AddressingModes.ZeroPage_X,
	0xB1: AddressingModes.ZPInd_Y,
	0xAE: AddressingModes.Absolute,
	0xBE: AddressingModes.Absolute_Y,
	0xA2: AddressingModes.Immediate,
	0xA6: AddressingModes.ZeroPage,
	0xB6: AddressingModes.ZeroPage_Y,
	0xAC: AddressingModes.Absolute,
	0xBC: AddressingModes.Absolute_X,
	0xA0: AddressingModes.Immediate,
	0xA4: AddressingModes.ZeroPage,
	0xB4: AddressingModes.ZeroPage_X,
	0x8D: AddressingModes.Absolute,
	0x9D: AddressingModes.Absolute_X,
	0x99: AddressingModes.Absolute_Y,
	0x85: AddressingModes.ZeroPage,
	0x81: AddressingModes.ZPInd_X,
	0x95: AddressingModes.ZeroPage_X,
	0x91: AddressingModes.ZPInd_Y,
	0x8E: AddressingModes.Absolute,
	0x86: AddressingModes.ZeroPage,
	0x96: AddressingModes.ZeroPage_Y,
	0x8C: AddressingModes.Absolute,
	0x84: AddressingModes.ZeroPage,
	0x94: AddressingModes.ZeroPage_X,
	0x6D: AddressingModes.Absolute,
	0x7D: AddressingModes.Absolute_X,
	0x79: AddressingModes.Absolute_Y,
	0x69: AddressingModes.Immediate,
	0x65: AddressingModes.ZeroPage,
	0x61: AddressingModes.ZPInd_X,
	0x75: AddressingModes.ZeroPage_X,
	0x71: AddressingModes.ZPInd_Y,
	0xED: AddressingModes.Absolute,
	0xFD: AddressingModes.Absolute_X,
	0xF9: AddressingModes.Absolute_Y,
	0xE9: AddressingModes.Immediate,
	0xE5: AddressingModes.ZeroPage,
	0xE1: AddressingModes.ZPInd_X,
	0xF5: AddressingModes.ZeroPage_X,
	0xF1: AddressingModes.ZPInd_Y,
	0xEE: AddressingModes.Absolute,
	0xFE: AddressingModes.Absolute_X,
	0xE6: AddressingModes.ZeroPage,
	0xF6: AddressingModes.ZeroPage_X,
	0xE8: AddressingModes.Implied,
	0xC8: AddressingModes.Implied,
	0xCE: AddressingModes.Absolute,
	0xDE: AddressingModes.Absolute_X,
	0xC6: AddressingModes.ZeroPage,
	0xD6: AddressingModes.ZeroPage_X,
	0xCA: AddressingModes.Implied,
	0x88: AddressingModes.Implied,
	0x0E: AddressingModes.Absolute,
	0x1E: AddressingModes.Absolute_X,
	0x0A: AddressingModes.Accumulator,
	0x06: AddressingModes.ZeroPage,
	0x16: AddressingModes.ZeroPage_X,
	0x4E: AddressingModes.Absolute,
	0x5E: AddressingModes.Absolute_X,
	0x4A: AddressingModes.Accumulator,
	0x46: AddressingModes.ZeroPage,
	0x56: AddressingModes.ZeroPage_X,
	0x2E: AddressingModes.Absolute,
	0x3E: AddressingModes.Absolute_X,
	0x2A: AddressingModes.Accumulator,
	0x26: AddressingModes.ZeroPage,
	0x36: AddressingModes.ZeroPage_X,
	0x6E: AddressingModes.Absolute,
	0x7E: AddressingModes.Absolute_X,
	0x6A: AddressingModes.Accumulator,
	0x66: AddressingModes.ZeroPage,
	0x76: AddressingModes.ZeroPage_X,
	0x2D: AddressingModes.Absolute,
	0x3D: AddressingModes.Absolute_X,
	0x39: AddressingModes.Absolute_Y,
	0x29: AddressingModes.Immediate,
	0x25: AddressingModes.ZeroPage,
	0x21: AddressingModes.ZPInd_X,
	0x35: AddressingModes.ZeroPage_X,
	0x31: AddressingModes.ZPInd_Y,
	0x0D: AddressingModes.Absolute,
	0x1D: AddressingModes.Absolute_X,
	0x19: AddressingModes.Absolute_Y,
	0x09: AddressingModes.Immediate,
	0x05: AddressingModes.ZeroPage,
	0x01: AddressingModes.ZPInd_X,
	0x15: AddressingModes.ZeroPage_X,
	0x11: AddressingModes.ZPInd_Y,
	0x4D: AddressingModes.Absolute,
	0x5D: AddressingModes.Absolute_X,
	0x59: AddressingModes.Absolute_Y,
	0x49: AddressingModes.Immediate,
	0x45: AddressingModes.ZeroPage,
	0x41: AddressingModes.ZPInd_X,
	0x55: AddressingModes.ZeroPage_X,
	0x51: AddressingModes.ZPInd_Y,
	0xCD: AddressingModes.Absolute,
	0xDD: AddressingModes.Absolute_X,
	0xD9: AddressingModes.Absolute_Y,
	0xC9: AddressingModes.Immediate,
	0xC5: AddressingModes.ZeroPage,
	0xC1: AddressingModes.ZPInd_X,
	0xD5: AddressingModes.ZeroPage_X,
	0xD1: AddressingModes.ZPInd_Y,
	0xEC: AddressingModes.Absolute,
	0xE0: AddressingModes.Immediate,
	0xE4: AddressingModes.ZeroPage,
	0xCC: AddressingModes.Absolute,
	0xC0: AddressingModes.Immediate,
	0xC4: AddressingModes.ZeroPage,
	0x2C: AddressingModes.Absolute,
	0x80: AddressingModes.Immediate,
	0x24: AddressingModes.ZeroPage,
	0x90: AddressingModes.Relative,
	0xB0: AddressingModes.Relative,
	0xD0: AddressingModes.Relative,
	0xF0: AddressingModes.Relative,
	0x10: AddressingModes.Relative,
	0x30: AddressingModes.Relative,
	0x50: AddressingModes.Relative,
	0x70: AddressingModes.Relative,
	0xAA: AddressingModes.Implied,
	0x8A: AddressingModes.Implied,
	0xA8: AddressingModes.Implied,
	0x98: AddressingModes.Implied,
	0xBA: AddressingModes.Implied,
	0x9A: AddressingModes.Implied,
	0x48: AddressingModes.Implied,
	0x68: AddressingModes.Implied,
	0x08: AddressingModes.Implied,
	0x28: AddressingModes.Implied,
	0x4C: AddressingModes.Absolute,
	0x6C: AddressingModes.Indirect,
	0x20: AddressingModes.Absolute,
	0x60: AddressingModes.Absolute,
	0x40: AddressingModes.Absolute,
	0x18: AddressingModes.Implied,
	0x38: AddressingModes.Implied,
	0xD8: AddressingModes.Implied,
	0xF8: AddressingModes.Implied,
	0x58: AddressingModes.Implied,
	0x78: AddressingModes.Implied,
	0xB8: AddressingModes.Implied,
	0x00: AddressingModes.Immediate,
	0xEA: AddressingModes.Implied
}

const OPCODE_INSTRUCTIONS = {
	0xAD: 'LDA',
	0xBD: 'LDA',
	0xB9: 'LDA',
	0xA9: 'LDA',
	0xA5: 'LDA',
	0xA1: 'LDA',
	0xB5: 'LDA',
	0xB1: 'LDA',
	0xAE: 'LDX',
	0xBE: 'LDX',
	0xA2: 'LDX',
	0xA6: 'LDX',
	0xB6: 'LDX',
	0xAC: 'LDY',
	0xBC: 'LDY',
	0xA0: 'LDY',
	0xA4: 'LDY',
	0xB4: 'LDY',
	0x8D: 'STA',
	0x9D: 'STA',
	0x99: 'STA',
	0x85: 'STA',
	0x81: 'STA',
	0x95: 'STA',
	0x91: 'STA',
	0x8E: 'STX',
	0x86: 'STX',
	0x96: 'STX',
	0x8C: 'STY',
	0x84: 'STY',
	0x94: 'STY',
	0x6D: 'ADC',
	0x7D: 'ADC',
	0x79: 'ADC',
	0x69: 'ADC',
	0x65: 'ADC',
	0x61: 'ADC',
	0x75: 'ADC',
	0x71: 'ADC',
	0xED: 'SBC',
	0xFD: 'SBC',
	0xF9: 'SBC',
	0xE9: 'SBC',
	0xE5: 'SBC',
	0xE1: 'SBC',
	0xF5: 'SBC',
	0xF1: 'SBC',
	0xEE: 'INC',
	0xFE: 'INC',
	0xE6: 'INC',
	0xF6: 'INC',
	0xE8: 'INX',
	0xC8: 'INY',
	0xCE: 'DEC',
	0xDE: 'DEC',
	0xC6: 'DEC',
	0xD6: 'DEC',
	0xCA: 'DEX',
	0x88: 'DEY',
	0x0E: 'ASL',
	0x1E: 'ASL',
	0x0A: 'ASL',
	0x06: 'ASL',
	0x16: 'ASL',
	0x4E: 'LSR',
	0x5E: 'LSR',
	0x4A: 'LSR',
	0x46: 'LSR',
	0x56: 'LSR',
	0x2E: 'ROL',
	0x3E: 'ROL',
	0x2A: 'ROL',
	0x26: 'ROL',
	0x36: 'ROL',
	0x6E: 'ROR',
	0x7E: 'ROR',
	0x6A: 'ROR',
	0x66: 'ROR',
	0x76: 'ROR',
	0x2D: 'AND',
	0x3D: 'AND',
	0x39: 'AND',
	0x29: 'AND',
	0x25: 'AND',
	0x21: 'AND',
	0x35: 'AND',
	0x31: 'AND',
	0x0D: 'ORA',
	0x1D: 'ORA',
	0x19: 'ORA',
	0x09: 'ORA',
	0x05: 'ORA',
	0x01: 'ORA',
	0x15: 'ORA',
	0x11: 'ORA',
	0x4D: 'EOR',
	0x5D: 'EOR',
	0x59: 'EOR',
	0x49: 'EOR',
	0x45: 'EOR',
	0x41: 'EOR',
	0x55: 'EOR',
	0x51: 'EOR',
	0xCD: 'CMP',
	0xDD: 'CMP',
	0xD9: 'CMP',
	0xC9: 'CMP',
	0xC5: 'CMP',
	0xC1: 'CMP',
	0xD5: 'CMP',
	0xD1: 'CMP',
	0xEC: 'CPX',
	0xE0: 'CPX',
	0xE4: 'CPX',
	0xCC: 'CPY',
	0xC0: 'CPY',
	0xC4: 'CPY',
	0x2C: 'BIT',
	0x80: 'BIT',
	0x24: 'BIT',
	0x90: 'BCC',
	0xB0: 'BCS',
	0xD0: 'BNE',
	0xF0: 'BEQ',
	0x10: 'BPL',
	0x30: 'BMI',
	0x50: 'BVC',
	0x70: 'BVS',
	0xAA: 'TAX',
	0x8A: 'TXA',
	0xA8: 'TAY',
	0x98: 'TYA',
	0xBA: 'TSX',
	0x9A: 'TXS',
	0x48: 'PHA',
	0x68: 'PLA',
	0x08: 'PHP',
	0x28: 'PLP',
	0x4C: 'JMP',
	0x6C: 'JMP',
	0x20: 'JSR',
	0x60: 'RTS',
	0x40: 'RTI',
	0x18: 'CLC',
	0x38: 'SEC',
	0xD8: 'CLD',
	0xF8: 'SED',
	0x58: 'CLI',
	0x78: 'SEI',
	0xB8: 'CLV',
	0x00: 'BRK',
	0xEA: 'NOP'
}
