using System;
using System.Collections.Generic;
using Godot;

public partial class Consts : Node
{
    public struct OpcodeData
    {
        public string instruction;
        public AddressingModes addressingMode;
        public int cycles;
    }

    /// <summary>
    /// The NES's CPU registers.
    /// </summary>
    public enum CpuRegisters
    {
        /// <summary>
        /// The accumulator.
        /// </summary>
        A = 0x0,
        /// <summary>
        /// The X index.
        /// </summary>
        X = 0x1,
        /// <summary>
        /// The Y index.
        /// </summary>
        Y = 0x2,
        /// <summary>
        /// The program counter.
        /// </summary>
        PC = 0x3,
        /// <summary>
        /// The stack pointer.
        /// </summary>
        SP = 0x4,
        /// <summary>
        /// Status flags. Explained in <seealso cref="Consts.StatusFlags"/>.
        /// </summary>
        P = 0x5,
        /// <summary>
        /// PPU internal register: During rendering, used for the scroll position. Outside of rendering, used as the current VRAM address.
        /// </summary>
        PPU_V = 0x10,
        /// <summary>
        /// PPU internal register: During rendering, specifies the starting coarse-x scroll for the next scanline and the starting y scroll for the screen. Outside of rendering, holds the scroll or VRAM address before transferring it to v.
        /// </summary>
        PPU_T = 0x11,
        /// <summary>
        /// The fine-x position of the current scroll, used during rendering alongside v.
        /// </summary>
        PPU_X = 0x12,
        /// <summary>
        /// Toggles on each write to either PPUSCROLL or PPUADDR, indicating whether this is the first or second write. Clears on reads of PPUSTATUS. Sometimes called the 'write latch' or 'write toggle'.
        /// </summary>
        PPU_W = 0x13,

    }

    /// <summary>
    /// The different sections of memory that can be accessed.
    /// </summary>
    public enum MemoryTypes
    {
        CPU,
        PPU
    }

    /// <summary>
    /// The status flags making up the SR register.
    /// </summary>
    [Flags]
    public enum StatusFlags
    {
        /// <summary>
        /// The carry flag for arithmetic and shift operations.
        /// </summary>
        Carry = 0x01,
        /// <summary>
        /// Set to 1 if the previous instruction evaluated to zero.
        /// </summary>
        Zero = 0x02,
        /// <summary>
        /// When this flag is enabled, IRQ interrupts are blocked.
        /// </summary>
        InterruptDisable = 0x04,
        /// <summary>
        /// Enables binary-coded decimal mode. Unused on the NES.
        /// </summary>
        Decimal = 0x08,
        /// <summary>
        /// Set by the CPU following interrupts. Set to 0 after NMI or IRQ, and 1 after BRK or PHP.
        /// </summary>
        B_1 = 0x10,
        /// <summary>
        /// This flag is always set to 1.
        /// </summary>
        B_2 = 0x20,
        /// <summary>
        /// Set to 1 if arithmetic instructions overflow.
        /// </summary>
        Overflow = 0x40,
        /// <summary>
        /// Set to 1 if the previous instruction resulted in a negative value (mirrors bit 7 of the resulting number).
        /// </summary>
        Negative = 0x80
    }

    /// <summary>
    /// The different modes of addressing data for an instruction.
    /// </summary>
    public enum AddressingModes
    {
        /// <summary>
        /// This instruction's addressing mode is implied (e.g. RTS).
        /// </summary>
        Implied,
        /// <summary>
        /// This instruction acts on the accumulator (e.g. LSR A).
        /// </summary>
        Accumulator,
        /// <summary>
        /// The value passed to the instruction is used as the addressed value directly.
        /// </summary>
        Immediate,
        /// <summary>
        /// Fetches the value from a 16-bit address anywhere in memory.
        /// </summary>
        Absolute,
        /// <summary>
        /// Fetches the value from a 16-bit address anywhere in memory, indexed by X.
        /// </summary>
        Absolute_X,
        /// <summary>
        /// Fetches the value from a 16-bit address anywhere in memory, indexed by Y.
        /// </summary>
        Absolute_Y,
        /// <summary>
        /// Fetches the value from the zero page.
        /// </summary>
        ZeroPage,
        /// <summary>
        /// Fetches the value from the zero page, indexed by X.
        /// </summary>
        ZeroPage_X,
        /// <summary>
        /// Fetches the value from the zero page, indexed by Y.
        /// </summary>
        ZeroPage_Y,
        /// <summary>
        /// Fetches a value from an address relative to the program counter. Limited to 128 in either direction.
        /// </summary>
        Relative,
        /// <summary>
        /// Fetches a 16-bit address, then treats that value as an address and fetches from that.
        /// </summary>
        Indirect,
        /// <summary>
        /// Indexed indirect. Fetches a zero-page address indexed by X, then fetches from the address specified. (d,x)
        /// </summary>
        ZPInd_X,
        /// <summary>
        /// Indirect indexed. Fetches a zero-page address, then fetches from the address specified, indexed by Y. (d),y
        /// </summary>
        ZPInd_Y
    }

    public enum Interrupts
    {
        IRQ,
        NMI,
        BRK,
        NONE
    }

    // Opcode values
    public static readonly Dictionary<AddressingModes, int> BYTES_PER_MODE = new Dictionary<AddressingModes, int>()
    {
        {AddressingModes.Implied, 1},
        {AddressingModes.Accumulator, 1},
        {AddressingModes.Immediate, 2},
        {AddressingModes.Absolute, 3},
        {AddressingModes.Absolute_X, 3},
        {AddressingModes.Absolute_Y, 3},
        {AddressingModes.ZeroPage, 2},
        {AddressingModes.ZeroPage_X, 2},
        {AddressingModes.ZeroPage_Y, 2},
        {AddressingModes.Relative, 2},
        {AddressingModes.Indirect, 3},
        {AddressingModes.ZPInd_X, 2},
        {AddressingModes.ZPInd_Y, 2}
    };

    public static readonly Dictionary<byte, OpcodeData> OPCODE_DATA = new Dictionary<byte, OpcodeData>()
    {
        {0x00, new OpcodeData()
            {
                instruction = "BRK",
                addressingMode = AddressingModes.Immediate,
                cycles = 7
            }
        },
        {0x01, new OpcodeData()
            {
                instruction = "ORA",
                addressingMode = AddressingModes.ZPInd_X,
                cycles = 6
            }
        },
        {0x05, new OpcodeData()
            {
                instruction = "ORA",
                addressingMode = AddressingModes.ZeroPage,
                cycles = 3
            }
        },
        {0x06, new OpcodeData()
            {
                instruction = "ASL",
                addressingMode = AddressingModes.ZeroPage,
                cycles = 5
            }
        },
        {0x08, new OpcodeData()
            {
                instruction = "PHP",
                addressingMode = AddressingModes.Implied,
                cycles = 3
            }
        },
        {0x09, new OpcodeData()
            {
                instruction = "ORA",
                addressingMode = AddressingModes.Immediate,
                cycles = 2
            }
        },
        {0x0A, new OpcodeData()
            {
                instruction = "ASL",
                addressingMode = AddressingModes.Accumulator,
                cycles = 2
            }
        },
        {0x0D, new OpcodeData()
            {
                instruction = "ORA",
                addressingMode = AddressingModes.Absolute,
                cycles = 4
            }
        },
        {0x0E, new OpcodeData()
            {
                instruction = "ASL",
                addressingMode = AddressingModes.Absolute,
                cycles = 6
            }
        },
        {0x10, new OpcodeData()
            {
                instruction = "BPL",
                addressingMode = AddressingModes.Relative,
                cycles = 2
            }
        },
        {0x11, new OpcodeData()
            {
                instruction = "ORA",
                addressingMode = AddressingModes.ZPInd_Y,
                cycles = 5
            }
        },
        {0x15, new OpcodeData()
            {
                instruction = "ORA",
                addressingMode = AddressingModes.ZeroPage_X,
                cycles = 4
            }
        },
        {0x16, new OpcodeData()
            {
                instruction = "ASL",
                addressingMode = AddressingModes.ZeroPage_X,
                cycles = 6
            }
        },
        {0x18, new OpcodeData()
            {
                instruction = "CLC",
                addressingMode = AddressingModes.Implied,
                cycles = 2
            }
        },
        {0x19, new OpcodeData()
            {
                instruction = "ORA",
                addressingMode = AddressingModes.Absolute_Y,
                cycles = 4
            }
        },
        {0x1D, new OpcodeData()
            {
                instruction = "ORA",
                addressingMode = AddressingModes.Absolute_X,
                cycles = 4
            }
        },
        {0x1E, new OpcodeData()
            {
                instruction = "ASL",
                addressingMode = AddressingModes.Absolute_X,
                cycles = 7
            }
        },
        {0x20, new OpcodeData()
            {
                instruction = "JSR",
                addressingMode = AddressingModes.Absolute,
                cycles = 6
            }
        },
        {0x21, new OpcodeData()
            {
                instruction = "AND",
                addressingMode = AddressingModes.ZPInd_X,
                cycles = 6
            }
        },
        {0x24, new OpcodeData()
            {
                instruction = "BIT",
                addressingMode = AddressingModes.ZeroPage,
                cycles = 3
            }
        },
        {0x25, new OpcodeData()
            {
                instruction = "AND",
                addressingMode = AddressingModes.ZeroPage,
                cycles = 3
            }
        },
        {0x26, new OpcodeData()
            {
                instruction = "ROL",
                addressingMode = AddressingModes.ZeroPage,
                cycles = 5
            }
        },
        {0x28, new OpcodeData()
            {
                instruction = "PLP",
                addressingMode = AddressingModes.Implied,
                cycles = 4
            }
        },
        {0x29, new OpcodeData()
            {
                instruction = "AND",
                addressingMode = AddressingModes.Immediate,
                cycles = 2
            }
        },
        {0x2A, new OpcodeData()
            {
                instruction = "ROL",
                addressingMode = AddressingModes.Accumulator,
                cycles = 2
            }
        },
        {0x2C, new OpcodeData()
            {
                instruction = "BIT",
                addressingMode = AddressingModes.Absolute,
                cycles = 4
            }
        },
        {0x2D, new OpcodeData()
            {
                instruction = "AND",
                addressingMode = AddressingModes.Absolute,
                cycles = 4
            }
        },
        {0x2E, new OpcodeData()
            {
                instruction = "ROL",
                addressingMode = AddressingModes.Absolute,
                cycles = 6
            }
        },
        {0x30, new OpcodeData()
            {
                instruction = "BMI",
                addressingMode = AddressingModes.Relative,
                cycles = 2
            }
        },
        {0x31, new OpcodeData()
            {
                instruction = "AND",
                addressingMode = AddressingModes.ZPInd_Y,
                cycles = 5
            }
        },
        {0x35, new OpcodeData()
            {
                instruction = "AND",
                addressingMode = AddressingModes.ZeroPage_X,
                cycles = 4
            }
        },
        {0x36, new OpcodeData()
            {
                instruction = "ROL",
                addressingMode = AddressingModes.ZeroPage_X,
                cycles = 6
            }
        },
        {0x38, new OpcodeData()
            {
                instruction = "SEC",
                addressingMode = AddressingModes.Implied,
                cycles = 2
            }
        },
        {0x39, new OpcodeData()
            {
                instruction = "AND",
                addressingMode = AddressingModes.Absolute_Y,
                cycles = 4
            }
        },
        {0x3D, new OpcodeData()
            {
                instruction = "AND",
                addressingMode = AddressingModes.Absolute_X,
                cycles = 4
            }
        },
        {0x3E, new OpcodeData()
            {
                instruction = "ROL",
                addressingMode = AddressingModes.Absolute_X,
                cycles = 7
            }
        },
        {0x40, new OpcodeData()
            {
                instruction = "RTI",
                addressingMode = AddressingModes.Absolute,
                cycles = 6
            }
        },
        {0x41, new OpcodeData()
            {
                instruction = "EOR",
                addressingMode = AddressingModes.ZPInd_X,
                cycles = 6
            }
        },
        {0x45, new OpcodeData()
            {
                instruction = "EOR",
                addressingMode = AddressingModes.ZeroPage,
                cycles = 3
            }
        },
        {0x46, new OpcodeData()
            {
                instruction = "LSR",
                addressingMode = AddressingModes.ZeroPage,
                cycles = 5
            }
        },
        {0x48, new OpcodeData()
            {
                instruction = "PHA",
                addressingMode = AddressingModes.Implied,
                cycles = 3
            }
        },
        {0x49, new OpcodeData()
            {
                instruction = "EOR",
                addressingMode = AddressingModes.Immediate,
                cycles = 2
            }
        },
        {0x4A, new OpcodeData()
            {
                instruction = "LSR",
                addressingMode = AddressingModes.Accumulator,
                cycles = 2
            }
        },
        {0x4C, new OpcodeData()
            {
                instruction = "JMP",
                addressingMode = AddressingModes.Absolute,
                cycles = 3
            }
        },
        {0x4D, new OpcodeData()
            {
                instruction = "EOR",
                addressingMode = AddressingModes.Absolute,
                cycles = 4
            }
        },
        {0x4E, new OpcodeData()
            {
                instruction = "LSR",
                addressingMode = AddressingModes.Absolute,
                cycles = 6
            }
        },
        {0x50, new OpcodeData()
            {
                instruction = "BVC",
                addressingMode = AddressingModes.Relative,
                cycles = 2
            }
        },
        {0x51, new OpcodeData()
            {
                instruction = "EOR",
                addressingMode = AddressingModes.ZPInd_Y,
                cycles = 5
            }
        },
        {0x55, new OpcodeData()
            {
                instruction = "EOR",
                addressingMode = AddressingModes.ZeroPage_X,
                cycles = 4
            }
        },
        {0x56, new OpcodeData()
            {
                instruction = "LSR",
                addressingMode = AddressingModes.ZeroPage_X,
                cycles = 6
            }
        },
        {0x58, new OpcodeData()
            {
                instruction = "CLI",
                addressingMode = AddressingModes.Implied,
                cycles = 2
            }
        },
        {0x59, new OpcodeData()
            {
                instruction = "EOR",
                addressingMode = AddressingModes.Absolute_Y,
                cycles = 4
            }
        },
        {0x5D, new OpcodeData()
            {
                instruction = "EOR",
                addressingMode = AddressingModes.Absolute_X,
                cycles = 4
            }
        },
        {0x5E, new OpcodeData()
            {
                instruction = "LSR",
                addressingMode = AddressingModes.Absolute_X,
                cycles = 7
            }
        },
        {0x60, new OpcodeData()
            {
                instruction = "RTS",
                addressingMode = AddressingModes.Absolute,
                cycles = 6
            }
        },
        {0x61, new OpcodeData()
            {
                instruction = "ADC",
                addressingMode = AddressingModes.ZPInd_X,
                cycles = 6
            }
        },
        {0x65, new OpcodeData()
            {
                instruction = "ADC",
                addressingMode = AddressingModes.ZeroPage,
                cycles = 3
            }
        },
        {0x66, new OpcodeData()
            {
                instruction = "ROR",
                addressingMode = AddressingModes.ZeroPage,
                cycles = 5
            }
        },
        {0x68, new OpcodeData()
            {
                instruction = "PLA",
                addressingMode = AddressingModes.Implied,
                cycles = 4
            }
        },
        {0x69, new OpcodeData()
            {
                instruction = "ADC",
                addressingMode = AddressingModes.Immediate,
                cycles = 2
            }
        },
        {0x6A, new OpcodeData()
            {
                instruction = "ROR",
                addressingMode = AddressingModes.Accumulator,
                cycles = 2
            }
        },
        {0x6C, new OpcodeData()
            {
                instruction = "JMP",
                addressingMode = AddressingModes.Indirect,
                cycles = 5
            }
        },
        {0x6D, new OpcodeData()
            {
                instruction = "ADC",
                addressingMode = AddressingModes.Absolute,
                cycles = 4
            }
        },
        {0x6E, new OpcodeData()
            {
                instruction = "ROR",
                addressingMode = AddressingModes.Absolute,
                cycles = 6
            }
        },
        {0x70, new OpcodeData()
            {
                instruction = "BVS",
                addressingMode = AddressingModes.Relative,
                cycles = 2
            }
        },
        {0x71, new OpcodeData()
            {
                instruction = "ADC",
                addressingMode = AddressingModes.ZPInd_Y,
                cycles = 5
            }
        },
        {0x75, new OpcodeData()
            {
                instruction = "ADC",
                addressingMode = AddressingModes.ZeroPage_X,
                cycles = 4
            }
        },
        {0x76, new OpcodeData()
            {
                instruction = "ROR",
                addressingMode = AddressingModes.ZeroPage_X,
                cycles = 6
            }
        },
        {0x78, new OpcodeData()
            {
                instruction = "SEI",
                addressingMode = AddressingModes.Implied,
                cycles = 2
            }
        },
        {0x79, new OpcodeData()
            {
                instruction = "ADC",
                addressingMode = AddressingModes.Absolute_Y,
                cycles = 4
            }
        },
        {0x7D, new OpcodeData()
            {
                instruction = "ADC",
                addressingMode = AddressingModes.Absolute_X,
                cycles = 4
            }
        },
        {0x7E, new OpcodeData()
            {
                instruction = "ROR",
                addressingMode = AddressingModes.Absolute_X,
                cycles = 7
            }
        },
        {0x80, new OpcodeData()
            {
                instruction = "BIT",
                addressingMode = AddressingModes.Immediate,
                cycles = -1 // This one isn't listed?
            }
        },
        {0x81, new OpcodeData()
            {
                instruction = "STA",
                addressingMode = AddressingModes.ZPInd_X,
                cycles = 6
            }
        },
        {0x84, new OpcodeData()
            {
                instruction = "STY",
                addressingMode = AddressingModes.ZeroPage,
                cycles = 3
            }
        },
        {0x85, new OpcodeData()
            {
                instruction = "STA",
                addressingMode = AddressingModes.ZeroPage,
                cycles = 3
            }
        },
        {0x86, new OpcodeData()
            {
                instruction = "STX",
                addressingMode = AddressingModes.ZeroPage,
                cycles = 3
            }
        },
        {0x88, new OpcodeData()
            {
                instruction = "DEY",
                addressingMode = AddressingModes.Implied,
                cycles = 2
            }
        },
        {0x8A, new OpcodeData()
            {
                instruction = "TXA",
                addressingMode = AddressingModes.Implied,
                cycles = 2
            }
        },
        {0x8C, new OpcodeData()
            {
                instruction = "STY",
                addressingMode = AddressingModes.Absolute,
                cycles = 4
            }
        },
        {0x8D, new OpcodeData()
            {
                instruction = "STA",
                addressingMode = AddressingModes.Absolute,
                cycles = 4
            }
        },
        {0x8E, new OpcodeData()
            {
                instruction = "STX",
                addressingMode = AddressingModes.Absolute,
                cycles = 4
            }
        },
        {0x90, new OpcodeData()
            {
                instruction = "BCC",
                addressingMode = AddressingModes.Relative,
                cycles = 2
            }
        },
        {0x91, new OpcodeData()
            {
                instruction = "STA",
                addressingMode = AddressingModes.ZPInd_Y,
                cycles = 6
            }
        },
        {0x94, new OpcodeData()
            {
                instruction = "STY",
                addressingMode = AddressingModes.ZeroPage_X,
                cycles = 4
            }
        },
        {0x95, new OpcodeData()
            {
                instruction = "STA",
                addressingMode = AddressingModes.ZeroPage_X,
                cycles = 4
            }
        },
        {0x96, new OpcodeData()
            {
                instruction = "STX",
                addressingMode = AddressingModes.ZeroPage_Y,
                cycles = 4
            }
        },
        {0x98, new OpcodeData()
            {
                instruction = "TYA",
                addressingMode = AddressingModes.Implied,
                cycles = 2
            }
        },
        {0x99, new OpcodeData()
            {
                instruction = "STA",
                addressingMode = AddressingModes.Absolute_Y,
                cycles = 5
            }
        },
        {0x9A, new OpcodeData()
            {
                instruction = "TXS",
                addressingMode = AddressingModes.Implied,
                cycles = 2
            }
        },
        {0x9D, new OpcodeData()
            {
                instruction = "STA",
                addressingMode = AddressingModes.Absolute_X,
                cycles = 5
            }
        },
        {0xA0, new OpcodeData()
            {
                instruction = "LDY",
                addressingMode = AddressingModes.Immediate,
                cycles = 2
            }
        },
        {0xA1, new OpcodeData()
            {
                instruction = "LDA",
                addressingMode = AddressingModes.ZPInd_X,
                cycles = 6
            }
        },
        {0xA2, new OpcodeData()
            {
                instruction = "LDX",
                addressingMode = AddressingModes.Immediate,
                cycles = 2
            }
        },
        {0xA4, new OpcodeData()
            {
                instruction = "LDY",
                addressingMode = AddressingModes.ZeroPage,
                cycles = 3
            }
        },
        {0xA5, new OpcodeData()
            {
                instruction = "LDA",
                addressingMode = AddressingModes.ZeroPage,
                cycles = 3
            }
        },
        {0xA6, new OpcodeData()
            {
                instruction = "LDX",
                addressingMode = AddressingModes.ZeroPage,
                cycles = 3
            }
        },
        {0xA8, new OpcodeData()
            {
                instruction = "TAY",
                addressingMode = AddressingModes.Implied,
                cycles = 2
            }
        },
        {0xA9, new OpcodeData()
            {
                instruction = "LDA",
                addressingMode = AddressingModes.Immediate,
                cycles = 2
            }
        },
        {0xAA, new OpcodeData()
            {
                instruction = "TAX",
                addressingMode = AddressingModes.Implied,
                cycles = 2
            }
        },
        {0xAC, new OpcodeData()
            {
                instruction = "LDY",
                addressingMode = AddressingModes.Absolute,
                cycles = 4
            }
        },
        {0xAD, new OpcodeData()
            {
                instruction = "LDA",
                addressingMode = AddressingModes.Absolute,
                cycles = 4
            }
        },
        {0xAE, new OpcodeData()
            {
                instruction = "LDX",
                addressingMode = AddressingModes.Absolute,
                cycles = 4
            }
        },
        {0xB0, new OpcodeData()
            {
                instruction = "BCS",
                addressingMode = AddressingModes.Relative,
                cycles = 2
            }
        },
        {0xB1, new OpcodeData()
            {
                instruction = "LDA",
                addressingMode = AddressingModes.ZPInd_Y,
                cycles = 5
            }
        },
        {0xB4, new OpcodeData()
            {
                instruction = "LDY",
                addressingMode = AddressingModes.ZeroPage_X,
                cycles = 4
            }
        },
        {0xB5, new OpcodeData()
            {
                instruction = "LDA",
                addressingMode = AddressingModes.ZeroPage_X,
                cycles = 4
            }
        },
        {0xB6, new OpcodeData()
            {
                instruction = "LDX",
                addressingMode = AddressingModes.ZeroPage_Y,
                cycles = 4
            }
        },
        {0xB8, new OpcodeData()
            {
                instruction = "CLV",
                addressingMode = AddressingModes.Implied,
                cycles = 2
            }
        },
        {0xB9, new OpcodeData()
            {
                instruction = "LDA",
                addressingMode = AddressingModes.Absolute_Y,
                cycles = 4
            }
        },
        {0xBA, new OpcodeData()
            {
                instruction = "TSX",
                addressingMode = AddressingModes.Implied,
                cycles = 2
            }
        },
        {0xBC, new OpcodeData()
            {
                instruction = "LDY",
                addressingMode = AddressingModes.Absolute_X,
                cycles = 4
            }
        },
        {0xBD, new OpcodeData()
            {
                instruction = "LDA",
                addressingMode = AddressingModes.Absolute_X,
                cycles = 4
            }
        },
        {0xBE, new OpcodeData()
            {
                instruction = "LDX",
                addressingMode = AddressingModes.Absolute_Y,
                cycles = 4
            }
        },
        {0xC0, new OpcodeData()
            {
                instruction = "CPY",
                addressingMode = AddressingModes.Immediate,
                cycles = 2
            }
        },
        {0xC1, new OpcodeData()
            {
                instruction = "CMP",
                addressingMode = AddressingModes.ZPInd_X,
                cycles = 6
            }
        },
        {0xC4, new OpcodeData()
            {
                instruction = "CPY",
                addressingMode = AddressingModes.ZeroPage,
                cycles = 3
            }
        },
        {0xC5, new OpcodeData()
            {
                instruction = "CMP",
                addressingMode = AddressingModes.ZeroPage,
                cycles = 3
            }
        },
        {0xC6, new OpcodeData()
            {
                instruction = "DEC",
                addressingMode = AddressingModes.ZeroPage,
                cycles = 5
            }
        },
        {0xC8, new OpcodeData()
            {
                instruction = "INY",
                addressingMode = AddressingModes.Implied,
                cycles = 2
            }
        },
        {0xC9, new OpcodeData()
            {
                instruction = "CMP",
                addressingMode = AddressingModes.Immediate,
                cycles = 2
            }
        },
        {0xCA, new OpcodeData()
            {
                instruction = "DEX",
                addressingMode = AddressingModes.Implied,
                cycles = 2
            }
        },
        {0xCC, new OpcodeData()
            {
                instruction = "CPY",
                addressingMode = AddressingModes.Absolute,
                cycles = 4
            }
        },
        {0xCD, new OpcodeData()
            {
                instruction = "CMP",
                addressingMode = AddressingModes.Absolute,
                cycles = 4
            }
        },
        {0xCE, new OpcodeData()
            {
                instruction = "DEC",
                addressingMode = AddressingModes.Absolute,
                cycles = 6
            }
        },
        {0xD0, new OpcodeData()
            {
                instruction = "BNE",
                addressingMode = AddressingModes.Relative,
                cycles = 2
            }
        },
        {0xD1, new OpcodeData()
            {
                instruction = "CMP",
                addressingMode = AddressingModes.ZPInd_Y,
                cycles = 5
            }
        },
        {0xD5, new OpcodeData()
            {
                instruction = "CMP",
                addressingMode = AddressingModes.ZeroPage_X,
                cycles = 4
            }
        },
        {0xD6, new OpcodeData()
            {
                instruction = "DEC",
                addressingMode = AddressingModes.ZeroPage_X,
                cycles = 6
            }
        },
        {0xD8, new OpcodeData()
            {
                instruction = "CLD",
                addressingMode = AddressingModes.Implied,
                cycles = 2
            }
        },
        {0xD9, new OpcodeData()
            {
                instruction = "CMP",
                addressingMode = AddressingModes.Absolute_Y,
                cycles = 4
            }
        },
        {0xDD, new OpcodeData()
            {
                instruction = "CMP",
                addressingMode = AddressingModes.Absolute_X,
                cycles = 4
            }
        },
        {0xDE, new OpcodeData()
            {
                instruction = "DEC",
                addressingMode = AddressingModes.Absolute_X,
                cycles = 7
            }
        },
        {0xE0, new OpcodeData()
            {
                instruction = "CPX",
                addressingMode = AddressingModes.Immediate,
                cycles = 2
            }
        },
        {0xE1, new OpcodeData()
            {
                instruction = "SBC",
                addressingMode = AddressingModes.ZPInd_X,
                cycles = 6
            }
        },
        {0xE4, new OpcodeData()
            {
                instruction = "CPX",
                addressingMode = AddressingModes.ZeroPage,
                cycles = 3
            }
        },
        {0xE5, new OpcodeData()
            {
                instruction = "SBC",
                addressingMode = AddressingModes.ZeroPage,
                cycles = 3
            }
        },
        {0xE6, new OpcodeData()
            {
                instruction = "INC",
                addressingMode = AddressingModes.ZeroPage,
                cycles = 5
            }
        },
        {0xE8, new OpcodeData()
            {
                instruction = "INX",
                addressingMode = AddressingModes.Implied,
                cycles = 2
            }
        },
        {0xE9, new OpcodeData()
            {
                instruction = "SBC",
                addressingMode = AddressingModes.Immediate,
                cycles = 2
            }
        },
        {0xEA, new OpcodeData()
            {
                instruction = "NOP",
                addressingMode = AddressingModes.Implied,
                cycles = 2
            }
        },
        {0xEC, new OpcodeData()
            {
                instruction = "CPX",
                addressingMode = AddressingModes.Absolute,
                cycles = 4
            }
        },
        {0xED, new OpcodeData()
            {
                instruction = "SBC",
                addressingMode = AddressingModes.Absolute,
                cycles = 4
            }
        },
        {0xEE, new OpcodeData()
            {
                instruction = "INC",
                addressingMode = AddressingModes.Absolute,
                cycles = 6
            }
        },
        {0xF0, new OpcodeData()
            {
                instruction = "BEQ",
                addressingMode = AddressingModes.Relative,
                cycles = 2
            }
        },
        {0xF1, new OpcodeData()
            {
                instruction = "SBC",
                addressingMode = AddressingModes.ZPInd_Y,
                cycles = 5
            }
        },
        {0xF5, new OpcodeData()
            {
                instruction = "SBC",
                addressingMode = AddressingModes.ZeroPage_X,
                cycles = 4
            }
        },
        {0xF6, new OpcodeData()
            {
                instruction = "INC",
                addressingMode = AddressingModes.ZeroPage_X,
                cycles = 6
            }
        },
        {0xF8, new OpcodeData()
            {
                instruction = "SED",
                addressingMode = AddressingModes.Implied,
                cycles = 2
            }
        },
        {0xF9, new OpcodeData()
            {
                instruction = "SBC",
                addressingMode = AddressingModes.Absolute_Y,
                cycles = 4
            }
        },
        {0xFD, new OpcodeData()
            {
                instruction = "SBC",
                addressingMode = AddressingModes.Absolute_X,
                cycles = 4
            }
        },
        {0xFE, new OpcodeData()
            {
                instruction = "INC",
                addressingMode = AddressingModes.Absolute_X,
                cycles = 7
            }
        }
    };

    public static byte GetOpcode(string instruction, AddressingModes addressingMode)
    {
        foreach (var opcode in OPCODE_DATA.Keys)
        {
            var opcodeData = OPCODE_DATA[opcode];
            if (opcodeData.instruction == instruction && opcodeData.addressingMode == addressingMode) {
                return opcode;
            }
        }

        return 0x0;
    }
}