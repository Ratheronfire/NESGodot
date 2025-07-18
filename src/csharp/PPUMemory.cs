using System.Collections.Generic;
using System.Runtime.InteropServices;

public partial class PPUMemory : Memory
{
    public const int PPU_MEMORY_SIZE = 0x04000;

    public const int PATTERN_TABLE_0 = 0x0000;
    public const int PATTERN_TABLE_1 = 0x1000;

    public const int NAMETABLE_0 = 0x2000;
    public const int ATTRIBUTE_TABLE_0 = 0x23C0;

    public const int NAMETABLE_1 = 0x2400;
    public const int ATTRIBUTE_TABLE_1 = 0x27C0;

    public const int NAMETABLE_2 = 0x2800;
    public const int ATTRIBUTE_TABLE_2 = 0x2BC0;

    public const int NAMETABLE_3 = 0x2C00;
    public const int ATTRIBUTE_TABLE_3 = 0x2FC0;

    public const int NAMETABLE_SIZE = 0x03C0;

    public const int PALETTE_DATA = 0x3F00;

    private int bufferedPpudataValue = 0x0;

    public new static PPUMemory Instance { get; private set; }

    public override void _Ready()
    {
        base._Ready();

        CPUMemory.Instance.PpuRegisterTouched += OnPPURegisterTouched;
    }

    protected override void InitRegisters()
    {
        _registers = new Dictionary<Consts.CpuRegisters, int>()
        {
            { Consts.CpuRegisters.PPU_V, 0 },
            { Consts.CpuRegisters.PPU_T, 0 },
            { Consts.CpuRegisters.PPU_X, 0 },
            { Consts.CpuRegisters.PPU_W, 0 }
        };
    }

    protected override void ProcessPreReadByteSideEffects(int address)
    {
    }

    protected override void ProcessPreWriteByteSideEffects(int address)
    {
    }

    protected override void ProcessReadByteSideEffects(int address)
    {
    }

    protected override void ProcessWriteByteSideEffects(int address)
    {
    }

    private void OnPPURegisterTouched(int cpuAddress, int cpuAddressValue, bool wasRead)
    {
        // Read PPUSTATUS: Clear W register
        if (cpuAddress == (int)Consts.PpuRegisters.PPUSTATUS && wasRead)
        {
            _registers[Consts.CpuRegisters.PPU_W] = 0;
        }

        // Read PPUDATA: Update buffer for next read
        if (wasRead && cpuAddress == (int)Consts.PpuRegisters.PPUDATA) {
            CPUMemory.Instance.Bytes[(int)Consts.PpuRegisters.PPUDATA] = bufferedPpudataValue;
            bufferedPpudataValue = _bytes[_registers[Consts.CpuRegisters.PPU_V]];
        }

        // Write PPUSCROLL: Update x/y scroll data
        if (!wasRead && cpuAddress == (int)Consts.PpuRegisters.PPUSCROLL)
        {
            FlipWRegister();
        }

        // Write PPUADDR: Update high or low byte of VRAM address
        if (!wasRead && cpuAddress == (int)Consts.PpuRegisters.PPUADDR)
        {
            if (_registers[Consts.CpuRegisters.PPU_W] == 0)
            {
                _registers[Consts.CpuRegisters.PPU_V] &= 0x00FF;
                _registers[Consts.CpuRegisters.PPU_V] |= (cpuAddressValue << 8);
            }
            else
            {
                _registers[Consts.CpuRegisters.PPU_V] &= 0xFF00;
                _registers[Consts.CpuRegisters.PPU_V] |= cpuAddressValue;
            }

            _registers[Consts.CpuRegisters.PPU_V] &= 0x3FFF;
            FlipWRegister();
        }

        // Write PPUDATA: Copy data to PPU memory
        if (!wasRead && cpuAddress == (int)Consts.PpuRegisters.PPUDATA)
        {
            _bytes[_registers[Consts.CpuRegisters.PPU_V]] = cpuAddressValue;
        }

        // If PPUDATA was accessed, increment by the value specified in PPUCTRL
        if (cpuAddress == (int)Consts.PpuRegisters.PPUDATA)
        {
            var vramIncrementFlag = CPUMemory.Instance.Bytes[(int)Consts.PpuRegisters.PPUCTRL] & 0x0004;
            var vramAddressIncrement = vramIncrementFlag > 0 ? 32 : 1;

            _registers[Consts.CpuRegisters.PPU_V] += vramAddressIncrement;
            _registers[Consts.CpuRegisters.PPU_V] &= 0x3FFF;
        }
    }

    private void FlipWRegister() {
        _registers[Consts.CpuRegisters.PPU_W] = _registers[Consts.CpuRegisters.PPU_W] == 1 ? 0 : 1;
    }
}