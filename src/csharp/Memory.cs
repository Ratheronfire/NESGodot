using System;
using System.Collections.Generic;
using Godot;

public abstract partial class Memory : Node
{
    public static Memory Instance { get; protected set; }

    [Export]
    public int MemorySize;

    public List<int> Bytes { get => _bytes; }
    protected List<int> _bytes;

    public Dictionary<Consts.CpuRegisters, int> Registers { get => _registers; }
    protected Dictionary<Consts.CpuRegisters, int> _registers;

    public override void _Ready()
    {
        Instance = this;

        _bytes = new List<int>(MemorySize);
        InitRegisters();
    }

    public int ReadByte(int address)
    {
        ProcessPreReadByteSideEffects(address);

        int returnValue = _bytes[address % 0xFFFF];

        ProcessReadByteSideEffects(address);

        return returnValue;
    }

    public int ReadWord(int address)
    {
        return ReadByte(address) + (ReadByte(address + 1) << 8);
    }

    public void WriteByte(int address, int value)
    {
        ProcessPreWriteByteSideEffects(address);

        _bytes[address] = value;

        ProcessWriteByteSideEffects(address);
    }

    public void ClearMemory()
    {
        for (int i = 0; i < _bytes.Count; i++)
        {
            _bytes[i] = 0;
        }
    }

    protected abstract void InitRegisters();

    protected abstract void ProcessReadByteSideEffects(int address);
    protected abstract void ProcessWriteByteSideEffects(int address);
    protected abstract void ProcessPreReadByteSideEffects(int address);
    protected abstract void ProcessPreWriteByteSideEffects(int address);
}