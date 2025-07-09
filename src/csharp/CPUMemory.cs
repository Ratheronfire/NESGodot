using Godot;
using System;

public partial class CPUMemory : Memory
{
    public new static CPUMemory Instance { get; private set; }

    public void SetStatusFlag(Consts.StatusFlags status, bool state)
    {
        if (state)
        {
            Registers[Consts.CpuRegisters.P] |= (int) status;
        }
        else
        {
            Registers[Consts.CpuRegisters.P] &= ~(int) status;
        }
    }

    protected override void InitRegisters()
    {
        throw new NotImplementedException();
    }

    protected override void ProcessPreReadByteSideEffects(int address)
    {
        throw new NotImplementedException();
    }

    protected override void ProcessPreWriteByteSideEffects(int address)
    {
        throw new NotImplementedException();
    }

    protected override void ProcessReadByteSideEffects(int address)
    {
        throw new NotImplementedException();
    }

    protected override void ProcessWriteByteSideEffects(int address)
    {
        throw new NotImplementedException();
    }
}
