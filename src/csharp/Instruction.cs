using Godot;

public partial class NES : Node
{
    public struct OperandAddressingContext
    {
        public Consts.AddressingModes addressingMode;
        public int value;
    }

    public struct InstructionData
    {
        public int opcode;
        public Consts.OpcodeData opcodeData;
        public OperandAddressingContext context;

        public override string ToString()
        {
            string operandStr = " $%02X";

            if (context.addressingMode == Consts.AddressingModes.Accumulator ||
                    context.addressingMode == Consts.AddressingModes.Implied)
            {
                operandStr = "";
            }
            else if (context.addressingMode == Consts.AddressingModes.Immediate)
            {
                operandStr = " #$%02X";
            }
            else if (context.addressingMode == Consts.AddressingModes.Absolute)
            {
                operandStr = " #$%04X";
            }
            else if (context.addressingMode == Consts.AddressingModes.Indirect)
            {
                operandStr = " ($%04X)";
            }
            else if (context.addressingMode == Consts.AddressingModes.Absolute_X)
            {
                operandStr = " $%04X,X";
            }
            else if (context.addressingMode == Consts.AddressingModes.Absolute_Y)
            {
                operandStr = " $%04X,Y";
            }
            else if (context.addressingMode == Consts.AddressingModes.ZeroPage_X)
            {
                operandStr = " $%02X,X";
            }
            else if (context.addressingMode == Consts.AddressingModes.ZeroPage_Y)
            {
                operandStr = " $%02X,Y";
            }
            else if (context.addressingMode == Consts.AddressingModes.ZPInd_X)
            {
                operandStr = " ($%02X,X)";
            }
            else if (context.addressingMode == Consts.AddressingModes.ZPInd_Y)
            {
                operandStr = " ($%02X),Y";
            }

            return opcodeData.instruction + string.Format(operandStr, context.value);
        }
    }
}