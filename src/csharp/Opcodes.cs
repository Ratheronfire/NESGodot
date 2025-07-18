using System;
using System.Linq;
using System.Text.RegularExpressions;
using Godot;

public partial class NES : Node
{    
    public void LDA(OperandAddressingContext context)
    {
        var value = ReadValueFromMemory(context);
        cpu.Registers[Consts.CpuRegisters.A] = value;

        UpdateStatusFlags(value, Consts.StatusFlags.Zero, Consts.StatusFlags.Negative);
    }
    
    public void LDX(OperandAddressingContext context)
    {
        var value = ReadValueFromMemory(context);
        cpu.Registers[Consts.CpuRegisters.X] = value;

        UpdateStatusFlags(value, Consts.StatusFlags.Zero, Consts.StatusFlags.Negative);
    }
    
    public void LDY(OperandAddressingContext context)
    {
        var value = ReadValueFromMemory(context);
        cpu.Registers[Consts.CpuRegisters.Y] = value;

        UpdateStatusFlags(value, Consts.StatusFlags.Zero, Consts.StatusFlags.Negative);
    }

    public void STA(OperandAddressingContext context)
    {
        WriteValueToMemory(context, cpu.Registers[Consts.CpuRegisters.A]);
    }

    public void STX(OperandAddressingContext context)
    {
        WriteValueToMemory(context, cpu.Registers[Consts.CpuRegisters.X]);
    }

    public void STY(OperandAddressingContext context)
    {
        WriteValueToMemory(context, cpu.Registers[Consts.CpuRegisters.Y]);
    }

    public void ADC(OperandAddressingContext context)
    {
        var a = cpu.Registers[Consts.CpuRegisters.A];
        var newA = a;

        if (cpu.GetStatusFlag(Consts.StatusFlags.Carry))
        {
            newA += 1;
            cpu.SetStatusFlag(Consts.StatusFlags.Carry, false);
        }

        var addedValue = ReadValueFromMemory(context);
        newA += addedValue;

        var overflowed = ((newA ^ a) & (newA ^ addedValue) & 0x80) > 0;

        cpu.SetStatusFlag(Consts.StatusFlags.Overflow, overflowed);
        cpu.SetStatusFlag(Consts.StatusFlags.Carry, newA > 0xFF);

        newA &= 0xFF;

        cpu.Registers[Consts.CpuRegisters.A] = newA;

        UpdateStatusFlags(newA, Consts.StatusFlags.Zero, Consts.StatusFlags.Negative);
    }

    public void SBC(OperandAddressingContext context)
    {
        var a = cpu.Registers[Consts.CpuRegisters.A];
        var newA = a;

        if (!cpu.GetStatusFlag(Consts.StatusFlags.Carry))
        {
            newA -= 1;
            cpu.SetStatusFlag(Consts.StatusFlags.Carry, true);
        }

        var subtractedValue = ReadValueFromMemory(context);
        newA -= subtractedValue;

        var overflowed = ((newA ^ a) & (newA ^ ~subtractedValue) & 0x80) > 0;

        cpu.SetStatusFlag(Consts.StatusFlags.Overflow, overflowed);
        cpu.SetStatusFlag(Consts.StatusFlags.Carry, !(newA < 0));

        newA = (0x100 + newA) & 0xFF;

        cpu.Registers[Consts.CpuRegisters.A] = newA;

        UpdateStatusFlags(newA, Consts.StatusFlags.Zero, Consts.StatusFlags.Negative);
    }

    public void INC(OperandAddressingContext context)
    {
        var value = ReadValueFromMemory(context);
        var address = DetermineMemoryAddress(context);

        value = (value + 1) & 0xFF;

        cpu.WriteByte(address, value);

        UpdateStatusFlags(value, Consts.StatusFlags.Zero, Consts.StatusFlags.Negative);
    }

    public void INX(OperandAddressingContext context)
    {
        var x = cpu.Registers[Consts.CpuRegisters.X];

        x = (x + 1) & 0xFF;

        cpu.Registers[Consts.CpuRegisters.X] = x;

        UpdateStatusFlags(x, Consts.StatusFlags.Zero, Consts.StatusFlags.Negative);
    }

    public void INY(OperandAddressingContext context)
    {
        var y = cpu.Registers[Consts.CpuRegisters.Y];

        y = (y + 1) & 0xFF;

        cpu.Registers[Consts.CpuRegisters.Y] = y;

        UpdateStatusFlags(y, Consts.StatusFlags.Zero, Consts.StatusFlags.Negative);
    }

    public void DEC(OperandAddressingContext context)
    {
        var value = ReadValueFromMemory(context);
        var address = DetermineMemoryAddress(context);

        value--;
        if (value < 0)
        {
            value = (0x100 + value) & 0xFF;
        }

        cpu.WriteByte(address, value);

        UpdateStatusFlags(value, Consts.StatusFlags.Zero, Consts.StatusFlags.Negative);
    }

    public void DEX(OperandAddressingContext context)
    {
        var x = cpu.Registers[Consts.CpuRegisters.X];

        x--;
        if (x < 0)
        {
            x = (0x100 + x) & 0xFF;
        }

        cpu.Registers[Consts.CpuRegisters.X] = x;

        UpdateStatusFlags(x, Consts.StatusFlags.Zero, Consts.StatusFlags.Negative);
    }

    public void DEY(OperandAddressingContext context)
    {
        var y = cpu.Registers[Consts.CpuRegisters.Y];

        y--;
        if (y < 0)
        {
            y = (0x100 + y) & 0xFF;
        }

        cpu.Registers[Consts.CpuRegisters.Y] = y;

        UpdateStatusFlags(y, Consts.StatusFlags.Zero, Consts.StatusFlags.Negative);
    }

    public void ASL(OperandAddressingContext context)
    {
        var value = ReadValueFromMemory(context);

        var shiftedValue = (value << 1) & 0xFF;

        WriteValueToMemory(context, shiftedValue);

        cpu.SetStatusFlag(Consts.StatusFlags.Carry, (value & 0x80) > 0);
        UpdateStatusFlags(shiftedValue, Consts.StatusFlags.Zero, Consts.StatusFlags.Negative);
    }

    public void LSR(OperandAddressingContext context)
    {
        var value = ReadValueFromMemory(context);

        var shiftedValue = (value >> 1) & 0xFF;

        WriteValueToMemory(context, shiftedValue);

        cpu.SetStatusFlag(Consts.StatusFlags.Carry, (value & 0x01) > 0);
        UpdateStatusFlags(shiftedValue, Consts.StatusFlags.Zero, Consts.StatusFlags.Negative);
    }

    public void ROL(OperandAddressingContext context)
    {
        var value = ReadValueFromMemory(context);

        var shiftedValue = (value << 1) & 0xFF;
        if (cpu.GetStatusFlag(Consts.StatusFlags.Carry))
        {
            shiftedValue |= 0x01;
            cpu.SetStatusFlag(Consts.StatusFlags.Carry, false);
        }

        WriteValueToMemory(context, shiftedValue);

        cpu.SetStatusFlag(Consts.StatusFlags.Carry, (value & 0x80) > 0);
        UpdateStatusFlags(shiftedValue, Consts.StatusFlags.Zero, Consts.StatusFlags.Negative);
    }

    public void ROR(OperandAddressingContext context)
    {
        var value = ReadValueFromMemory(context);

        var shiftedValue = (value >> 1) & 0xFF;
        if (cpu.GetStatusFlag(Consts.StatusFlags.Carry))
        {
            shiftedValue |= 0x80;
            cpu.SetStatusFlag(Consts.StatusFlags.Carry, false);
        }

        WriteValueToMemory(context, shiftedValue);

        cpu.SetStatusFlag(Consts.StatusFlags.Carry, (value & 0x01) > 0);
        UpdateStatusFlags(shiftedValue, Consts.StatusFlags.Zero, Consts.StatusFlags.Negative);
    }

    public void AND(OperandAddressingContext context)
    {
        var a = cpu.Registers[Consts.CpuRegisters.A];

        a &= ReadValueFromMemory(context);
        cpu.Registers[Consts.CpuRegisters.A] = a;

        UpdateStatusFlags(a, Consts.StatusFlags.Zero, Consts.StatusFlags.Negative);
    }

    public void ORA(OperandAddressingContext context)
    {
        var a = cpu.Registers[Consts.CpuRegisters.A];

        a |= ReadValueFromMemory(context);
        cpu.Registers[Consts.CpuRegisters.A] = a;

        UpdateStatusFlags(a, Consts.StatusFlags.Zero, Consts.StatusFlags.Negative);
    }

    public void EOR(OperandAddressingContext context)
    {
        var a = cpu.Registers[Consts.CpuRegisters.A];

        a ^= ReadValueFromMemory(context);
        cpu.Registers[Consts.CpuRegisters.A] = a;

        UpdateStatusFlags(a, Consts.StatusFlags.Zero, Consts.StatusFlags.Negative);
    }

    public void CMP(OperandAddressingContext context)
    {
        var a = cpu.Registers[Consts.CpuRegisters.A];
        var value = ReadValueFromMemory(context);

        cpu.SetStatusFlag(Consts.StatusFlags.Negative, ((a - value) & 0x80) > 0);
        UpdateStatusFlags(a, Consts.StatusFlags.Carry, Consts.StatusFlags.Zero);
    }

    public void CPX(OperandAddressingContext context)
    {
        var x = cpu.Registers[Consts.CpuRegisters.X];
        var value = ReadValueFromMemory(context);

        cpu.SetStatusFlag(Consts.StatusFlags.Negative, ((x - value) & 0x80) > 0);
        UpdateStatusFlags(x, Consts.StatusFlags.Carry, Consts.StatusFlags.Zero);
    }

    public void CPY(OperandAddressingContext context)
    {
        var y = cpu.Registers[Consts.CpuRegisters.Y];
        var value = ReadValueFromMemory(context);

        cpu.SetStatusFlag(Consts.StatusFlags.Negative, ((y - value) & 0x80) > 0);
        UpdateStatusFlags(y, Consts.StatusFlags.Carry, Consts.StatusFlags.Zero);
    }

    public void BIT(OperandAddressingContext context)
    {
        var a = cpu.Registers[Consts.CpuRegisters.A];
        var value = ReadValueFromMemory(context);

        cpu.SetStatusFlag(Consts.StatusFlags.Zero, (a & value) == 0);
        cpu.SetStatusFlag(Consts.StatusFlags.Negative, (value & 0x80) > 0);
        cpu.SetStatusFlag(Consts.StatusFlags.Overflow, (value & 0x40) > 0);
    }

    public void BCC(OperandAddressingContext context)
    {
        if (context.addressingMode != Consts.AddressingModes.Relative)
        {
            GD.PrintErr("Invalid accessing method for branch.");
            return;
        }

        if (cpu.GetStatusFlag(Consts.StatusFlags.Carry))
        {
            return;
        }

        var address = DetermineMemoryAddress(context);
        if (address != 0)
        {
            cpu.Registers[Consts.CpuRegisters.PC] += address + 2;            
        }
    }

    public void BCS(OperandAddressingContext context)
    {
        if (context.addressingMode != Consts.AddressingModes.Relative)
        {
            GD.PrintErr("Invalid accessing method for branch.");
            return;
        }

        if (!cpu.GetStatusFlag(Consts.StatusFlags.Carry))
        {
            return;
        }

        var address = DetermineMemoryAddress(context);
        if (address != 0)
        {
            cpu.Registers[Consts.CpuRegisters.PC] += address + 2;            
        }
    }

    public void BNE(OperandAddressingContext context)
    {
        if (context.addressingMode != Consts.AddressingModes.Relative)
        {
            GD.PrintErr("Invalid accessing method for branch.");
            return;
        }

        if (cpu.GetStatusFlag(Consts.StatusFlags.Zero))
        {
            return;
        }

        var address = DetermineMemoryAddress(context);
        if (address != 0)
        {
            cpu.Registers[Consts.CpuRegisters.PC] += address + 2;            
        }
    }

    public void BEQ(OperandAddressingContext context)
    {
        if (context.addressingMode != Consts.AddressingModes.Relative)
        {
            GD.PrintErr("Invalid accessing method for branch.");
            return;
        }

        if (!cpu.GetStatusFlag(Consts.StatusFlags.Zero))
        {
            return;
        }

        var address = DetermineMemoryAddress(context);
        if (address != 0)
        {
            cpu.Registers[Consts.CpuRegisters.PC] += address + 2;            
        }
    }

    public void BPL(OperandAddressingContext context)
    {
        if (context.addressingMode != Consts.AddressingModes.Relative)
        {
            GD.PrintErr("Invalid accessing method for branch.");
            return;
        }

        if (cpu.GetStatusFlag(Consts.StatusFlags.Negative))
        {
            return;
        }

        var address = DetermineMemoryAddress(context);
        if (address != 0)
        {
            cpu.Registers[Consts.CpuRegisters.PC] += address + 2;            
        }
    }

    public void BMI(OperandAddressingContext context)
    {
        if (context.addressingMode != Consts.AddressingModes.Relative)
        {
            GD.PrintErr("Invalid accessing method for branch.");
            return;
        }

        if (!cpu.GetStatusFlag(Consts.StatusFlags.Negative))
        {
            return;
        }

        var address = DetermineMemoryAddress(context);
        if (address != 0)
        {
            cpu.Registers[Consts.CpuRegisters.PC] += address + 2;            
        }
    }

    public void BVC(OperandAddressingContext context)
    {
        if (context.addressingMode != Consts.AddressingModes.Relative)
        {
            GD.PrintErr("Invalid accessing method for branch.");
            return;
        }

        if (cpu.GetStatusFlag(Consts.StatusFlags.Overflow))
        {
            return;
        }

        var address = DetermineMemoryAddress(context);
        if (address != 0)
        {
            cpu.Registers[Consts.CpuRegisters.PC] += address + 2;            
        }
    }

    public void BVS(OperandAddressingContext context)
    {
        if (context.addressingMode != Consts.AddressingModes.Relative)
        {
            GD.PrintErr("Invalid accessing method for branch.");
            return;
        }

        if (!cpu.GetStatusFlag(Consts.StatusFlags.Overflow))
        {
            return;
        }

        var address = DetermineMemoryAddress(context);
        if (address != 0)
        {
            cpu.Registers[Consts.CpuRegisters.PC] += address + 2;            
        }
    }

    public void TAX(OperandAddressingContext context)
    {
        Transfer(Consts.CpuRegisters.A, Consts.CpuRegisters.X);
    }

    public void TXA(OperandAddressingContext context)
    {
        Transfer(Consts.CpuRegisters.X, Consts.CpuRegisters.A);
    }

    public void TAY(OperandAddressingContext context)
    {
        Transfer(Consts.CpuRegisters.A, Consts.CpuRegisters.Y);
    }

    public void TYA(OperandAddressingContext context)
    {
        Transfer(Consts.CpuRegisters.Y, Consts.CpuRegisters.A);
    }

    public void TSX(OperandAddressingContext context)
    {
        Transfer(Consts.CpuRegisters.SP, Consts.CpuRegisters.X);
    }

    public void TXS(OperandAddressingContext context)
    {
        Transfer(Consts.CpuRegisters.X, Consts.CpuRegisters.SP);
    }

    public void PHA(OperandAddressingContext context)
    {
        PushToStack(cpu.Registers[Consts.CpuRegisters.A]);
    }

    public void PLA(OperandAddressingContext context)
    {
        var a = PullFromStack();
        cpu.Registers[Consts.CpuRegisters.A] = a;

        UpdateStatusFlags(a, Consts.StatusFlags.Zero, Consts.StatusFlags.Negative);
    }

    public void PHP(OperandAddressingContext context)
    {
        PushToStack(cpu.Registers[Consts.CpuRegisters.P]);

        var stateStackAddress = 0x100 + cpu.Registers[Consts.CpuRegisters.SP] + 1;
        var stateFlags = cpu.ReadByte(stateStackAddress);

        cpu.WriteByte(stateStackAddress, stateFlags | 0x30);
    }

    public void PLP(OperandAddressingContext context)
    {
        cpu.Registers[Consts.CpuRegisters.P] = PullFromStack() & 0b11101111;
    }

    public void JMP(OperandAddressingContext context)
    {
        if (context.addressingMode != Consts.AddressingModes.Absolute && context.addressingMode != Consts.AddressingModes.Indirect)
        {
            GD.PrintErr("Invalid addressing method for jump.");
            return;
        }

        var pc = cpu.Registers[Consts.CpuRegisters.PC];

        var address = context.addressingMode == Consts.AddressingModes.Absolute ? context.value : DetermineMemoryAddress(context);
        cpu.Registers[Consts.CpuRegisters.PC] = address;
    }

    public void JSR(OperandAddressingContext context)
    {
        if (context.addressingMode != Consts.AddressingModes.Absolute)
        {
            GD.PrintErr("Invalid addressing method for jump.");
            return;
        }

        var pc = cpu.Registers[Consts.CpuRegisters.PC] + 2;
        PushToStack(pc >> 8);
        PushToStack(pc & 0xFF);

        cpu.Registers[Consts.CpuRegisters.PC] = context.value;
    }

    public void RTS(OperandAddressingContext context)
    {
        var pc = cpu.Registers[Consts.CpuRegisters.PC];

        cpu.Registers[Consts.CpuRegisters.PC] = PullFromStack() + (PullFromStack() << 8) + 1;
    }

    public void RTI(OperandAddressingContext context)
    {
        var pc = cpu.Registers[Consts.CpuRegisters.PC];

        cpu.Registers[Consts.CpuRegisters.P] = PullFromStack();
        cpu.Registers[Consts.CpuRegisters.PC] = PullFromStack() + (PullFromStack() << 8) + 1;
    }

    public void CLC(OperandAddressingContext context)
    {
        cpu.SetStatusFlag(Consts.StatusFlags.Carry, false);
    }

    public void SEC(OperandAddressingContext context)
    {
        cpu.SetStatusFlag(Consts.StatusFlags.Carry, true);
    }

    public void CLD(OperandAddressingContext context)
    {
        cpu.SetStatusFlag(Consts.StatusFlags.Decimal, false);
    }

    public void SED(OperandAddressingContext context)
    {
        cpu.SetStatusFlag(Consts.StatusFlags.Decimal, true);
    }

    public void CLI(OperandAddressingContext context)
    {
        cpu.SetStatusFlag(Consts.StatusFlags.InterruptDisable, false);
    }

    public void SEI(OperandAddressingContext context)
    {
        cpu.SetStatusFlag(Consts.StatusFlags.InterruptDisable, true);
    }

    public void CLV(OperandAddressingContext context)
    {
        cpu.SetStatusFlag(Consts.StatusFlags.Overflow, false);
    }

    public void BRK(OperandAddressingContext context)
    {
        var pc = cpu.Registers[Consts.CpuRegisters.PC];
        PushToStack(pc >> 8);
        PushToStack(pc & 0xFF);

        cpu.SetStatusFlag(Consts.StatusFlags.InterruptDisable, true);
        PushToStack(cpu.Registers[Consts.CpuRegisters.P]);

        var stateStackAddress = 0x100 + cpu.Registers[Consts.CpuRegisters.SP] + 1;
        var stateFlags = cpu.ReadByte(stateStackAddress);
        cpu.WriteByte(stateStackAddress, stateFlags | 0x10);

        cpu.Registers[Consts.CpuRegisters.PC] = 0xFFFE;
    }

    public void NOP(OperandAddressingContext context)
    {
    }

    protected void PushToStack(int value)
    {
        cpu.WriteByte(0x100 + cpu.Registers[Consts.CpuRegisters.SP], value);
        cpu.Registers[Consts.CpuRegisters.SP] = cpu.Registers[Consts.CpuRegisters.SP] - 1;
    }

    protected int PullFromStack()
    {
        cpu.Registers[Consts.CpuRegisters.SP] = cpu.Registers[Consts.CpuRegisters.SP] + 1;
        return cpu.ReadByte(0x100 + cpu.Registers[Consts.CpuRegisters.SP]);
    }

    protected void Transfer(Consts.CpuRegisters fromRegister, Consts.CpuRegisters toRegister, bool updateStatusFlags = true)
    {
        cpu.Registers[toRegister] = cpu.Registers[fromRegister];

        if (updateStatusFlags)
        {
            UpdateStatusFlags(cpu.Registers[fromRegister], Consts.StatusFlags.Zero, Consts.StatusFlags.Negative);
        }
    }

    protected void WriteValueToMemory(OperandAddressingContext context, int value, Consts.CpuRegisters impliedRegister = Consts.CpuRegisters.A)
    {
        if (context.addressingMode == Consts.AddressingModes.Accumulator)
        {
            cpu.Registers[Consts.CpuRegisters.A] = value;
        }
        else if (context.addressingMode == Consts.AddressingModes.Implied)
        {
            cpu.Registers[impliedRegister] = value;
        }
        else
        {
            var address = DetermineMemoryAddress(context);
            cpu.WriteByte(address, value);
        }
    }

    protected int ReadValueFromMemory(OperandAddressingContext context, Consts.CpuRegisters impliedRegister = Consts.CpuRegisters.A)
    {
        if (context.addressingMode == Consts.AddressingModes.Immediate)
        {
            return context.value;
        }
        else if (context.addressingMode == Consts.AddressingModes.Accumulator)
        {
            return cpu.Registers[Consts.CpuRegisters.A];
        }
        else if (context.addressingMode == Consts.AddressingModes.Implied)
        {
            return cpu.Registers[impliedRegister];
        }

        var address = DetermineMemoryAddress(context);

        return cpu.ReadByte(address);
    }

    protected void UpdateStatusFlags(int resolvedValue, params Consts.StatusFlags[] flags)
    {
        foreach (var flag in flags)
        {
            // Overflow requires more advanced logic.
            switch (flag)
            {
                case Consts.StatusFlags.Zero:
                    cpu.SetStatusFlag(flag, resolvedValue == 0);
                    break;
                case Consts.StatusFlags.Negative:
                    cpu.SetStatusFlag(flag, resolvedValue >= 0x80);
                    break;
                case Consts.StatusFlags.Carry:
                    cpu.SetStatusFlag(flag, resolvedValue >= 0x80);
                    break;
            }
        }
    }

    protected int DetermineMemoryAddress(OperandAddressingContext context)
    {
        var address = context.value;

        switch (context.addressingMode)
        {
            case Consts.AddressingModes.Indirect:
                //Getting the indrect address value (we'll look up the value later.)
                if ((address & 0x00FF) == 0xFF)
                {
                    // Indirect addressing cannot cross page boundaries,
                    //   so the high bit is read from the start of the page instead.
                    address = cpu.ReadByte(address) +
                        cpu.ReadByte(address - 0xFF) << 8;
                }
                else
                {
                    address = cpu.ReadWord(address);
                }

                break;
            case Consts.AddressingModes.Absolute_X:
            case Consts.AddressingModes.ZeroPage_X:
            case Consts.AddressingModes.ZPInd_X:
                // Indexing by X
                address += cpu.Registers[Consts.CpuRegisters.X];

                break;
            case Consts.AddressingModes.Absolute_Y:
            case Consts.AddressingModes.ZeroPage_Y:
                // Indexing by Y (ZPInd_Y is handled separately below.)
                address += cpu.Registers[Consts.CpuRegisters.Y];

                break;
            case Consts.AddressingModes.Relative:
                // Relative indexing is limited to a signed byte
                if (address > 0x80)
                {
                    address -= 0x100;
                }

                break;
            default:
                break;
        }

        if (context.addressingMode == Consts.AddressingModes.ZeroPage_X || context.addressingMode == Consts.AddressingModes.ZeroPage_Y)
        {
            // Ensuring we stay on the zero page
            address %= 0x100;
        }
        else if (context.addressingMode == Consts.AddressingModes.ZPInd_X)
        {
            // Ensuring we stay on the zero page, and grabbing the high byte while we're at it
            address %= 0x100;
            var highAddress = (address + 1) % 0x100;

            return cpu.ReadByte(address) + cpu.ReadByte(highAddress) << 8;
        }
        else if (context.addressingMode == Consts.AddressingModes.ZPInd_X)
        {
            // ZPInd_Y works slightly differently
            address %= 0x100;
            var highAddress = (address + 1) % 0x100;

            address = cpu.ReadByte(address) + cpu.ReadByte(highAddress) << 8;
            address += cpu.Registers[Consts.CpuRegisters.Y];
        }

        address %= 0x10000;

        return address;
    }
}