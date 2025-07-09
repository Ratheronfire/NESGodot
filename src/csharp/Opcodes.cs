using System.Linq;
using Godot;

public partial class NES : Node
{
    private CPUMemory cpu;
    
    public void LDA(OperandAddressingContext context)
    {
        var value = ReadValueFromMemory(context);
        cpu.Registers[Consts.CpuRegisters.A] = value;

        // TODO: Introduce single method to update all relevant flags?
        cpu.SetStatusFlag(Consts.StatusFlags.Zero, value == 0);
        cpu.SetStatusFlag(Consts.StatusFlags.Negative, value >= 0x80);
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