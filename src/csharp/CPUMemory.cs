using Godot;
using System;
using System.Collections.Generic;

public partial class CPUMemory : Memory
{
    public const int CPU_MEMORY_SIZE = 0x10000;

    public const int WORK_RAM_ADDRESS  = 0x0000;
    public const int WORK_RAM_MIRROR = 0x0800;
    public const int PPU_REGISTERS = 0x2000;
    public const int PPU_MIRROR = 0x2008;
    public const int APU_IO  = 0x4000;
    public const int CARTRIDGE_ADDRESS = 0x8000;

    public const int CONTROLLER_REGISTER = 0x4016;

    public const int WORK_RAM_SIZE = 0x0800;
    public const int PPU_RAM_SIZE = 0x0008;

    public new static CPUMemory Instance { get; private set; }

    [Signal]
    public delegate void PpuRegisterTouchedEventHandler(int address, int value, bool wasRead);

    [Signal]
    public delegate void ControllerPollEventHandler(int address, bool wasRead);

    public bool GetStatusFlag(Consts.StatusFlags status)
    {
        return (Registers[Consts.CpuRegisters.P] & (int)status) > 0;
    }

    public void SetStatusFlag(Consts.StatusFlags status, bool state)
    {
        if (state)
        {
            Registers[Consts.CpuRegisters.P] |= (int)status;
        }
        else
        {
            Registers[Consts.CpuRegisters.P] &= ~(int)status;
        }
    }

    protected override void InitRegisters()
    {
        _registers = new Dictionary<Consts.CpuRegisters, int>()
        {
            { Consts.CpuRegisters.A,  0x00 },
            { Consts.CpuRegisters.X,  0x00 },
            { Consts.CpuRegisters.Y,  0x00 },
            { Consts.CpuRegisters.PC, ReadWord(0xFFFC) },
            { Consts.CpuRegisters.SP, 0xFD },
            { Consts.CpuRegisters.P,  0x34 },
        };
    }

    protected override int GetByteValue(int address)
    {
        if (address >= 0x0800 && address < 0x2000)
        {
            return _bytes[address % 0x0800];
        }
        else if (address >= 0x2008 && address < 0x4000)
        {
            return _bytes[0x2000 + ((address - 0x2000) % 0x08)];
        }

        return base.GetByteValue(address);
    }

    protected override void ProcessPreReadByteSideEffects(int address)
    {
        if (address == CONTROLLER_REGISTER)
        {
            EmitSignal(SignalName.ControllerPoll, _bytes[address], true);
        }
    }

    protected override void ProcessPreWriteByteSideEffects(int address)
    {
    }

    protected override void ProcessReadByteSideEffects(int address)
    {
        if (address >= PPU_REGISTERS && address < PPU_MIRROR)
        {
            EmitSignal(SignalName.PpuRegisterTouched, _bytes[address], true);
        }

        if (address == (int)Consts.PpuRegisters.PPUSTATUS)
        {
            _bytes[address] &= 0x7F;
        }
    }

    protected override void ProcessWriteByteSideEffects(int address)
    {
        if (address >= PPU_REGISTERS && address < PPU_MIRROR)
        {
            EmitSignal(SignalName.PpuRegisterTouched, _bytes[address], false);
        }

        if (address == CONTROLLER_REGISTER)
        {
            EmitSignal(SignalName.ControllerPoll, _bytes[address], false);
        }
    }
}
