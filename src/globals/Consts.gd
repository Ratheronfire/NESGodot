extends Node

## The NES's CPU registers.
enum CPU_Registers {
	A  = 0x0, ## The accumulator.
	X  = 0x1, ## The X index.
	Y  = 0x2, ## The Y index.
	PC = 0x3, ## The program counter.
	SP = 0x4, ## The stack pointer.
	P  = 0x5,  ## Status flags. Explained in [Consts.StatusFlags].
	PPU_V = 0x10, ## PPU internal register: During rendering, used for the scroll position. Outside of rendering, used as the current VRAM address.
	PPU_T = 0x11, ## PPU internal register: During rendering, specifies the starting coarse-x scroll for the next scanline and the starting y scroll for the screen. Outside of rendering, holds the scroll or VRAM address before transferring it to v.
	PPU_X = 0x12, ## The fine-x position of the current scroll, used during rendering alongside v.
	PPU_W = 0x13, ## Toggles on each write to either PPUSCROLL or PPUADDR, indicating whether this is the first or second write. Clears on reads of PPUSTATUS. Sometimes called the 'write latch' or 'write toggle'.
}

## The different sections of memory that can be accessed.
enum MemoryTypes {
	CPU,
	PPU
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
	PPUCTRL   = 0x2000,
	PPUMASK   = 0x2001,
	PPUSTATUS = 0x2002,
	OAMADDR   = 0x2003,
	OAMDATA1  = 0x2004,
	PPUSCROLL = 0x2005,
	PPUADDR   = 0x2006,
	PPUDATA   = 0x2007
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

enum Interrupts {
	IRQ,
	NMI,
	BRK,
	NONE
}


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

const OPCODE_DATA = {
	0x00: {
		'instruction': 'BRK',
		'address_mode': AddressingModes.Immediate,
		'cycles': 7
	},
	0x01: {
		'instruction': 'ORA',
		'address_mode': AddressingModes.ZPInd_X,
		'cycles': 6
	},
	0x05: {
		'instruction': 'ORA',
		'address_mode': AddressingModes.ZeroPage,
		'cycles': 3
	},
	0x06: {
		'instruction': 'ASL',
		'address_mode': AddressingModes.ZeroPage,
		'cycles': 5
	},
	0x08: {
		'instruction': 'PHP',
		'address_mode': AddressingModes.Implied,
		'cycles': 3
	},
	0x09: {
		'instruction': 'ORA',
		'address_mode': AddressingModes.Immediate,
		'cycles': 2
	},
	0x0A: {
		'instruction': 'ASL',
		'address_mode': AddressingModes.Accumulator,
		'cycles': 2
	},
	0x0D: {
		'instruction': 'ORA',
		'address_mode': AddressingModes.Absolute,
		'cycles': 4
	},
	0x0E: {
		'instruction': 'ASL',
		'address_mode': AddressingModes.Absolute,
		'cycles': 6
	},
	0x10: {
		'instruction': 'BPL',
		'address_mode': AddressingModes.Relative,
		'cycles': 2
	},
	0x11: {
		'instruction': 'ORA',
		'address_mode': AddressingModes.ZPInd_Y,
		'cycles': 5
	},
	0x15: {
		'instruction': 'ORA',
		'address_mode': AddressingModes.ZeroPage_X,
		'cycles': 4
	},
	0x16: {
		'instruction': 'ASL',
		'address_mode': AddressingModes.ZeroPage_X,
		'cycles': 6
	},
	0x18: {
		'instruction': 'CLC',
		'address_mode': AddressingModes.Implied,
		'cycles': 2
	},
	0x19: {
		'instruction': 'ORA',
		'address_mode': AddressingModes.Absolute_Y,
		'cycles': 4
	},
	0x1D: {
		'instruction': 'ORA',
		'address_mode': AddressingModes.Absolute_X,
		'cycles': 4
	},
	0x1E: {
		'instruction': 'ASL',
		'address_mode': AddressingModes.Absolute_X,
		'cycles': 7
	},
	0x20: {
		'instruction': 'JSR',
		'address_mode': AddressingModes.Absolute,
		'cycles': 6
	},
	0x21: {
		'instruction': 'AND',
		'address_mode': AddressingModes.ZPInd_X,
		'cycles': 6
	},
	0x24: {
		'instruction': 'BIT',
		'address_mode': AddressingModes.ZeroPage,
		'cycles': 3
	},
	0x25: {
		'instruction': 'AND',
		'address_mode': AddressingModes.ZeroPage,
		'cycles': 3
	},
	0x26: {
		'instruction': 'ROL',
		'address_mode': AddressingModes.ZeroPage,
		'cycles': 5
	},
	0x28: {
		'instruction': 'PLP',
		'address_mode': AddressingModes.Implied,
		'cycles': 4
	},
	0x29: {
		'instruction': 'AND',
		'address_mode': AddressingModes.Immediate,
		'cycles': 2
	},
	0x2A: {
		'instruction': 'ROL',
		'address_mode': AddressingModes.Accumulator,
		'cycles': 2
	},
	0x2C: {
		'instruction': 'BIT',
		'address_mode': AddressingModes.Absolute,
		'cycles': 4
	},
	0x2D: {
		'instruction': 'AND',
		'address_mode': AddressingModes.Absolute,
		'cycles': 4
	},
	0x2E: {
		'instruction': 'ROL',
		'address_mode': AddressingModes.Absolute,
		'cycles': 6
	},
	0x30: {
		'instruction': 'BMI',
		'address_mode': AddressingModes.Relative,
		'cycles': 2
	},
	0x31: {
		'instruction': 'AND',
		'address_mode': AddressingModes.ZPInd_Y,
		'cycles': 5
	},
	0x35: {
		'instruction': 'AND',
		'address_mode': AddressingModes.ZeroPage_X,
		'cycles': 4
	},
	0x36: {
		'instruction': 'ROL',
		'address_mode': AddressingModes.ZeroPage_X,
		'cycles': 6
	},
	0x38: {
		'instruction': 'SEC',
		'address_mode': AddressingModes.Implied,
		'cycles': 2
	},
	0x39: {
		'instruction': 'AND',
		'address_mode': AddressingModes.Absolute_Y,
		'cycles': 4
	},
	0x3D: {
		'instruction': 'AND',
		'address_mode': AddressingModes.Absolute_X,
		'cycles': 4
	},
	0x3E: {
		'instruction': 'ROL',
		'address_mode': AddressingModes.Absolute_X,
		'cycles': 7
	},
	0x40: {
		'instruction': 'RTI',
		'address_mode': AddressingModes.Absolute,
		'cycles': 6
	},
	0x41: {
		'instruction': 'EOR',
		'address_mode': AddressingModes.ZPInd_X,
		'cycles': 6
	},
	0x45: {
		'instruction': 'EOR',
		'address_mode': AddressingModes.ZeroPage,
		'cycles': 3
	},
	0x46: {
		'instruction': 'LSR',
		'address_mode': AddressingModes.ZeroPage,
		'cycles': 5
	},
	0x48: {
		'instruction': 'PHA',
		'address_mode': AddressingModes.Implied,
		'cycles': 3
	},
	0x49: {
		'instruction': 'EOR',
		'address_mode': AddressingModes.Immediate,
		'cycles': 2
	},
	0x4A: {
		'instruction': 'LSR',
		'address_mode': AddressingModes.Accumulator,
		'cycles': 2
	},
	0x4C: {
		'instruction': 'JMP',
		'address_mode': AddressingModes.Absolute,
		'cycles': 3
	},
	0x4D: {
		'instruction': 'EOR',
		'address_mode': AddressingModes.Absolute,
		'cycles': 4
	},
	0x4E: {
		'instruction': 'LSR',
		'address_mode': AddressingModes.Absolute,
		'cycles': 6
	},
	0x50: {
		'instruction': 'BVC',
		'address_mode': AddressingModes.Relative,
		'cycles': 2
	},
	0x51: {
		'instruction': 'EOR',
		'address_mode': AddressingModes.ZPInd_Y,
		'cycles': 5
	},
	0x55: {
		'instruction': 'EOR',
		'address_mode': AddressingModes.ZeroPage_X,
		'cycles': 4
	},
	0x56: {
		'instruction': 'LSR',
		'address_mode': AddressingModes.ZeroPage_X,
		'cycles': 6
	},
	0x58: {
		'instruction': 'CLI',
		'address_mode': AddressingModes.Implied,
		'cycles': 2
	},
	0x59: {
		'instruction': 'EOR',
		'address_mode': AddressingModes.Absolute_Y,
		'cycles': 4
	},
	0x5D: {
		'instruction': 'EOR',
		'address_mode': AddressingModes.Absolute_X,
		'cycles': 4
	},
	0x5E: {
		'instruction': 'LSR',
		'address_mode': AddressingModes.Absolute_X,
		'cycles': 7
	},
	0x60: {
		'instruction': 'RTS',
		'address_mode': AddressingModes.Absolute,
		'cycles': 6
	},
	0x61: {
		'instruction': 'ADC',
		'address_mode': AddressingModes.ZPInd_X,
		'cycles': 6
	},
	0x65: {
		'instruction': 'ADC',
		'address_mode': AddressingModes.ZeroPage,
		'cycles': 3
	},
	0x66: {
		'instruction': 'ROR',
		'address_mode': AddressingModes.ZeroPage,
		'cycles': 5
	},
	0x68: {
		'instruction': 'PLA',
		'address_mode': AddressingModes.Implied,
		'cycles': 4
	},
	0x69: {
		'instruction': 'ADC',
		'address_mode': AddressingModes.Immediate,
		'cycles': 2
	},
	0x6A: {
		'instruction': 'ROR',
		'address_mode': AddressingModes.Accumulator,
		'cycles': 2
	},
	0x6C: {
		'instruction': 'JMP',
		'address_mode': AddressingModes.Indirect,
		'cycles': 5
	},
	0x6D: {
		'instruction': 'ADC',
		'address_mode': AddressingModes.Absolute,
		'cycles': 4
	},
	0x6E: {
		'instruction': 'ROR',
		'address_mode': AddressingModes.Absolute,
		'cycles': 6
	},
	0x70: {
		'instruction': 'BVS',
		'address_mode': AddressingModes.Relative,
		'cycles': 2
	},
	0x71: {
		'instruction': 'ADC',
		'address_mode': AddressingModes.ZPInd_Y,
		'cycles': 5
	},
	0x75: {
		'instruction': 'ADC',
		'address_mode': AddressingModes.ZeroPage_X,
		'cycles': 4
	},
	0x76: {
		'instruction': 'ROR',
		'address_mode': AddressingModes.ZeroPage_X,
		'cycles': 6
	},
	0x78: {
		'instruction': 'SEI',
		'address_mode': AddressingModes.Implied,
		'cycles': 2
	},
	0x79: {
		'instruction': 'ADC',
		'address_mode': AddressingModes.Absolute_Y,
		'cycles': 4
	},
	0x7D: {
		'instruction': 'ADC',
		'address_mode': AddressingModes.Absolute_X,
		'cycles': 4
	},
	0x7E: {
		'instruction': 'ROR',
		'address_mode': AddressingModes.Absolute_X,
		'cycles': 7
	},
	0x80: {
		'instruction': 'BIT',
		'address_mode': AddressingModes.Immediate,
		'cycles': -1 # This one isn't listed?
	},
	0x81: {
		'instruction': 'STA',
		'address_mode': AddressingModes.ZPInd_X,
		'cycles': 6
	},
	0x84: {
		'instruction': 'STY',
		'address_mode': AddressingModes.ZeroPage,
		'cycles': 3
	},
	0x85: {
		'instruction': 'STA',
		'address_mode': AddressingModes.ZeroPage,
		'cycles': 3
	},
	0x86: {
		'instruction': 'STX',
		'address_mode': AddressingModes.ZeroPage,
		'cycles': 3
	},
	0x88: {
		'instruction': 'DEY',
		'address_mode': AddressingModes.Implied,
		'cycles': 2
	},
	0x8A: {
		'instruction': 'TXA',
		'address_mode': AddressingModes.Implied,
		'cycles': 2
	},
	0x8C: {
		'instruction': 'STY',
		'address_mode': AddressingModes.Absolute,
		'cycles': 4
	},
	0x8D: {
		'instruction': 'STA',
		'address_mode': AddressingModes.Absolute,
		'cycles': 4
	},
	0x8E: {
		'instruction': 'STX',
		'address_mode': AddressingModes.Absolute,
		'cycles': 4
	},
	0x90: {
		'instruction': 'BCC',
		'address_mode': AddressingModes.Relative,
		'cycles': 2
	},
	0x91: {
		'instruction': 'STA',
		'address_mode': AddressingModes.ZPInd_Y,
		'cycles': 6
	},
	0x94: {
		'instruction': 'STY',
		'address_mode': AddressingModes.ZeroPage_X,
		'cycles': 4
	},
	0x95: {
		'instruction': 'STA',
		'address_mode': AddressingModes.ZeroPage_X,
		'cycles': 4
	},
	0x96: {
		'instruction': 'STX',
		'address_mode': AddressingModes.ZeroPage_Y,
		'cycles': 4
	},
	0x98: {
		'instruction': 'TYA',
		'address_mode': AddressingModes.Implied,
		'cycles': 2
	},
	0x99: {
		'instruction': 'STA',
		'address_mode': AddressingModes.Absolute_Y,
		'cycles': 5
	},
	0x9A: {
		'instruction': 'TXS',
		'address_mode': AddressingModes.Implied,
		'cycles': 2
	},
	0x9D: {
		'instruction': 'STA',
		'address_mode': AddressingModes.Absolute_X,
		'cycles': 5
	},
	0xA0: {
		'instruction': 'LDY',
		'address_mode': AddressingModes.Immediate,
		'cycles': 2
	},
	0xA1: {
		'instruction': 'LDA',
		'address_mode': AddressingModes.ZPInd_X,
		'cycles': 6
	},
	0xA2: {
		'instruction': 'LDX',
		'address_mode': AddressingModes.Immediate,
		'cycles': 2
	},
	0xA4: {
		'instruction': 'LDY',
		'address_mode': AddressingModes.ZeroPage,
		'cycles': 3
	},
	0xA5: {
		'instruction': 'LDA',
		'address_mode': AddressingModes.ZeroPage,
		'cycles': 3
	},
	0xA6: {
		'instruction': 'LDX',
		'address_mode': AddressingModes.ZeroPage,
		'cycles': 3
	},
	0xA8: {
		'instruction': 'TAY',
		'address_mode': AddressingModes.Implied,
		'cycles': 2
	},
	0xA9: {
		'instruction': 'LDA',
		'address_mode': AddressingModes.Immediate,
		'cycles': 2
	},
	0xAA: {
		'instruction': 'TAX',
		'address_mode': AddressingModes.Implied,
		'cycles': 2
	},
	0xAC: {
		'instruction': 'LDY',
		'address_mode': AddressingModes.Absolute,
		'cycles': 4
	},
	0xAD: {
		'instruction': 'LDA',
		'address_mode': AddressingModes.Absolute,
		'cycles': 4
	},
	0xAE: {
		'instruction': 'LDX',
		'address_mode': AddressingModes.Absolute,
		'cycles': 4
	},
	0xB0: {
		'instruction': 'BCS',
		'address_mode': AddressingModes.Relative,
		'cycles': 2
	},
	0xB1: {
		'instruction': 'LDA',
		'address_mode': AddressingModes.ZPInd_Y,
		'cycles': 5
	},
	0xB4: {
		'instruction': 'LDY',
		'address_mode': AddressingModes.ZeroPage_X,
		'cycles': 4
	},
	0xB5: {
		'instruction': 'LDA',
		'address_mode': AddressingModes.ZeroPage_X,
		'cycles': 4
	},
	0xB6: {
		'instruction': 'LDX',
		'address_mode': AddressingModes.ZeroPage_Y,
		'cycles': 4
	},
	0xB8: {
		'instruction': 'CLV',
		'address_mode': AddressingModes.Implied,
		'cycles': 2
	},
	0xB9: {
		'instruction': 'LDA',
		'address_mode': AddressingModes.Absolute_Y,
		'cycles': 4
	},
	0xBA: {
		'instruction': 'TSX',
		'address_mode': AddressingModes.Implied,
		'cycles': 2
	},
	0xBC: {
		'instruction': 'LDY',
		'address_mode': AddressingModes.Absolute_X,
		'cycles': 4
	},
	0xBD: {
		'instruction': 'LDA',
		'address_mode': AddressingModes.Absolute_X,
		'cycles': 4
	},
	0xBE: {
		'instruction': 'LDX',
		'address_mode': AddressingModes.Absolute_Y,
		'cycles': 4
	},
	0xC0: {
		'instruction': 'CPY',
		'address_mode': AddressingModes.Immediate,
		'cycles': 2
	},
	0xC1: {
		'instruction': 'CMP',
		'address_mode': AddressingModes.ZPInd_X,
		'cycles': 6
	},
	0xC4: {
		'instruction': 'CPY',
		'address_mode': AddressingModes.ZeroPage,
		'cycles': 3
	},
	0xC5: {
		'instruction': 'CMP',
		'address_mode': AddressingModes.ZeroPage,
		'cycles': 3
	},
	0xC6: {
		'instruction': 'DEC',
		'address_mode': AddressingModes.ZeroPage,
		'cycles': 5
	},
	0xC8: {
		'instruction': 'INY',
		'address_mode': AddressingModes.Implied,
		'cycles': 2
	},
	0xC9: {
		'instruction': 'CMP',
		'address_mode': AddressingModes.Immediate,
		'cycles': 2
	},
	0xCA: {
		'instruction': 'DEX',
		'address_mode': AddressingModes.Implied,
		'cycles': 2
	},
	0xCC: {
		'instruction': 'CPY',
		'address_mode': AddressingModes.Absolute,
		'cycles': 4
	},
	0xCD: {
		'instruction': 'CMP',
		'address_mode': AddressingModes.Absolute,
		'cycles': 4
	},
	0xCE: {
		'instruction': 'DEC',
		'address_mode': AddressingModes.Absolute,
		'cycles': 6
	},
	0xD0: {
		'instruction': 'BNE',
		'address_mode': AddressingModes.Relative,
		'cycles': 2
	},
	0xD1: {
		'instruction': 'CMP',
		'address_mode': AddressingModes.ZPInd_Y,
		'cycles': 5
	},
	0xD5: {
		'instruction': 'CMP',
		'address_mode': AddressingModes.ZeroPage_X,
		'cycles': 4
	},
	0xD6: {
		'instruction': 'DEC',
		'address_mode': AddressingModes.ZeroPage_X,
		'cycles': 6
	},
	0xD8: {
		'instruction': 'CLD',
		'address_mode': AddressingModes.Implied,
		'cycles': 2
	},
	0xD9: {
		'instruction': 'CMP',
		'address_mode': AddressingModes.Absolute_Y,
		'cycles': 4
	},
	0xDD: {
		'instruction': 'CMP',
		'address_mode': AddressingModes.Absolute_X,
		'cycles': 4
	},
	0xDE: {
		'instruction': 'DEC',
		'address_mode': AddressingModes.Absolute_X,
		'cycles': 7
	},
	0xE0: {
		'instruction': 'CPX',
		'address_mode': AddressingModes.Immediate,
		'cycles': 2
	},
	0xE1: {
		'instruction': 'SBC',
		'address_mode': AddressingModes.ZPInd_X,
		'cycles': 6
	},
	0xE4: {
		'instruction': 'CPX',
		'address_mode': AddressingModes.ZeroPage,
		'cycles': 3
	},
	0xE5: {
		'instruction': 'SBC',
		'address_mode': AddressingModes.ZeroPage,
		'cycles': 3
	},
	0xE6: {
		'instruction': 'INC',
		'address_mode': AddressingModes.ZeroPage,
		'cycles': 5
	},
	0xE8: {
		'instruction': 'INX',
		'address_mode': AddressingModes.Implied,
		'cycles': 2
	},
	0xE9: {
		'instruction': 'SBC',
		'address_mode': AddressingModes.Immediate,
		'cycles': 2
	},
	0xEA: {
		'instruction': 'NOP',
		'address_mode': AddressingModes.Implied,
		'cycles': 2
	},
	0xEC: {
		'instruction': 'CPX',
		'address_mode': AddressingModes.Absolute,
		'cycles': 4
	},
	0xED: {
		'instruction': 'SBC',
		'address_mode': AddressingModes.Absolute,
		'cycles': 4
	},
	0xEE: {
		'instruction': 'INC',
		'address_mode': AddressingModes.Absolute,
		'cycles': 6
	},
	0xF0: {
		'instruction': 'BEQ',
		'address_mode': AddressingModes.Relative,
		'cycles': 2
	},
	0xF1: {
		'instruction': 'SBC',
		'address_mode': AddressingModes.ZPInd_Y,
		'cycles': 5
	},
	0xF5: {
		'instruction': 'SBC',
		'address_mode': AddressingModes.ZeroPage_X,
		'cycles': 4
	},
	0xF6: {
		'instruction': 'INC',
		'address_mode': AddressingModes.ZeroPage_X,
		'cycles': 6
	},
	0xF8: {
		'instruction': 'SED',
		'address_mode': AddressingModes.Implied,
		'cycles': 2
	},
	0xF9: {
		'instruction': 'SBC',
		'address_mode': AddressingModes.Absolute_Y,
		'cycles': 4
	},
	0xFD: {
		'instruction': 'SBC',
		'address_mode': AddressingModes.Absolute_X,
		'cycles': 4
	},
	0xFE: {
		'instruction': 'INC',
		'address_mode': AddressingModes.Absolute_X,
		'cycles': 7
	},
}

func get_opcode(instruction: String, address_mode: AddressingModes):
	for opcode in OPCODE_DATA.keys():
		var opcode_data = OPCODE_DATA[opcode]
		if opcode_data['instruction'] == instruction and opcode_data['address_mode'] == address_mode:
			return opcode
	
	return 0x0
