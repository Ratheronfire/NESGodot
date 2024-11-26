# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
class_name OpcodesTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://src/globals/Opcodes.gd'

func before_test():
	NES.init()


func test_LDA() -> void:
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.LDA(context)
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(1)
	
	NES.cpu_memory[0x20] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 0x20)
	Opcodes.LDA(context)
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(2)
	
	NES.cpu_memory[0x21] = 3
	NES.registers[Consts.CPU_Registers.X] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage_X, 0x20)
	Opcodes.LDA(context)
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(3)
	
	NES.cpu_memory[0x1234] = 4
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.LDA(context)
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(4)
	
	NES.cpu_memory[0x1236] = 5
	NES.registers[Consts.CPU_Registers.X] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_X, 0x1234)
	Opcodes.LDA(context)
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(5)
	
	NES.cpu_memory[0x1236] = 5
	NES.registers[Consts.CPU_Registers.Y] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_Y, 0x1234)
	Opcodes.LDA(context)
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(5)
	
	NES.cpu_memory[0x1234] = 7
	NES.cpu_memory[0x09] = 0x34
	NES.cpu_memory[0x0A] = 0x12
	NES.registers[Consts.CPU_Registers.X] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZPInd_X, 0x07)
	Opcodes.LDA(context)
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(7)
	
	NES.cpu_memory[0x3456] = 8
	NES.cpu_memory[0xFF] = 0x56
	NES.cpu_memory[0x00] = 0x34
	NES.registers[Consts.CPU_Registers.X] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZPInd_X, 0xFE)
	Opcodes.LDA(context)
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(8)
	
	NES.cpu_memory[0x5678] = 9
	NES.cpu_memory[0x07] = 0x76
	NES.cpu_memory[0x08] = 0x56
	NES.registers[Consts.CPU_Registers.Y] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZPInd_Y, 0x07)
	Opcodes.LDA(context)
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(9)
	
	NES.cpu_memory[0x6789] = 10
	NES.cpu_memory[0xFF] = 0x87
	NES.cpu_memory[0x00] = 0x67
	NES.registers[Consts.CPU_Registers.Y] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZPInd_Y, 0xFF)
	Opcodes.LDA(context)
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(10)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 0)
	Opcodes.LDA(context)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.LDA(context)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 0x81)
	Opcodes.LDA(context)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_LDX() -> void:
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.LDX(context)
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(1)
	
	NES.cpu_memory[0x20] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 0x20)
	Opcodes.LDX(context)
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(2)
	
	NES.cpu_memory[0x21] = 3
	NES.registers[Consts.CPU_Registers.Y] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage_Y, 0x20)
	Opcodes.LDX(context)
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(3)
	
	NES.cpu_memory[0x1234] = 4
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.LDX(context)
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(4)
	
	NES.cpu_memory[0x1236] = 5
	NES.registers[Consts.CPU_Registers.Y] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_Y, 0x1234)
	Opcodes.LDX(context)
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(5)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 0)
	Opcodes.LDX(context)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.LDX(context)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 0x81)
	Opcodes.LDX(context)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_LDY() -> void:
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.LDY(context)
	assert_int(NES.registers[Consts.CPU_Registers.Y]).is_equal(1)
	
	NES.cpu_memory[0x20] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 0x20)
	Opcodes.LDY(context)
	assert_int(NES.registers[Consts.CPU_Registers.Y]).is_equal(2)
	
	NES.cpu_memory[0x21] = 3
	NES.registers[Consts.CPU_Registers.X] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage_X, 0x20)
	Opcodes.LDY(context)
	assert_int(NES.registers[Consts.CPU_Registers.Y]).is_equal(3)
	
	NES.cpu_memory[0x1234] = 4
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.LDY(context)
	assert_int(NES.registers[Consts.CPU_Registers.Y]).is_equal(4)
	
	NES.cpu_memory[0x1236] = 5
	NES.registers[Consts.CPU_Registers.X] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_X, 0x1234)
	Opcodes.LDY(context)
	assert_int(NES.registers[Consts.CPU_Registers.Y]).is_equal(5)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 0)
	Opcodes.LDY(context)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.LDY(context)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 0x81)
	Opcodes.LDY(context)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_STA() -> void:
	NES.registers[Consts.CPU_Registers.A] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 0x20)
	Opcodes.STA(context)
	assert_int(NES.cpu_memory[0x20]).is_equal(2)
	
	NES.registers[Consts.CPU_Registers.A] = 3
	NES.registers[Consts.CPU_Registers.X] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage_X, 0)
	Opcodes.STA(context)
	assert_int(NES.cpu_memory[0xFF]).is_equal(3)
	
	NES.registers[Consts.CPU_Registers.A] = 4
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.STA(context)
	assert_int(NES.cpu_memory[0x1234]).is_equal(4)
	
	NES.registers[Consts.CPU_Registers.A] = 5
	NES.registers[Consts.CPU_Registers.X] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_X, 0x1234)
	Opcodes.STA(context)
	assert_int(NES.cpu_memory[0x1236]).is_equal(5)
	
	NES.registers[Consts.CPU_Registers.A] = 6
	NES.registers[Consts.CPU_Registers.Y] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_Y, 0x1234)
	Opcodes.STA(context)
	assert_int(NES.cpu_memory[0x1236]).is_equal(6)
	
	NES.cpu_memory[0x09] = 0x34
	NES.cpu_memory[0x0A] = 0x12
	NES.registers[Consts.CPU_Registers.A] = 7
	NES.registers[Consts.CPU_Registers.X] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZPInd_X, 0x07)
	Opcodes.STA(context)
	assert_int(NES.cpu_memory[0x1234]).is_equal(7)
	
	NES.cpu_memory[0x07] = 0x34
	NES.cpu_memory[0x08] = 0x12
	NES.registers[Consts.CPU_Registers.A] = 8
	NES.registers[Consts.CPU_Registers.Y] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZPInd_Y, 0x07)
	Opcodes.STA(context)
	assert_int(NES.cpu_memory[0x1236]).is_equal(8)


func test_STX() -> void:
	NES.registers[Consts.CPU_Registers.X] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 0x20)
	Opcodes.STX(context)
	assert_int(NES.cpu_memory[0x20]).is_equal(2)
	
	NES.registers[Consts.CPU_Registers.X] = 3
	NES.registers[Consts.CPU_Registers.Y] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage_Y, 0x20)
	Opcodes.STX(context)
	assert_int(NES.cpu_memory[0x21]).is_equal(3)
	
	NES.registers[Consts.CPU_Registers.X] = 4
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.STX(context)
	assert_int(NES.cpu_memory[0x1234]).is_equal(4)


func test_STY() -> void:
	NES.registers[Consts.CPU_Registers.A] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 0x20)
	Opcodes.STA(context)
	assert_int(NES.cpu_memory[0x20]).is_equal(2)
	
	NES.registers[Consts.CPU_Registers.A] = 3
	NES.registers[Consts.CPU_Registers.X] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage_X, 0x20)
	Opcodes.STA(context)
	assert_int(NES.cpu_memory[0x21]).is_equal(3)
	
	NES.registers[Consts.CPU_Registers.A] = 4
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.STA(context)
	assert_int(NES.cpu_memory[0x1234]).is_equal(4)


func test_ADC() -> void:
	NES.registers[Consts.CPU_Registers.A] = 1
	NES.set_status_flag(Consts.StatusFlags.Carry, false)

	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.ADC(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(2)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 2
	NES.cpu_memory[0x1] = 1
	NES.set_status_flag(Consts.StatusFlags.Carry, false)

	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 1)
	Opcodes.ADC(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(3)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 3
	NES.registers[Consts.CPU_Registers.X] = 1
	NES.cpu_memory[0x2] = 1
	NES.set_status_flag(Consts.StatusFlags.Carry, false)

	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage_X, 1)
	Opcodes.ADC(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(4)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 4
	NES.cpu_memory[0x1234] = 1
	NES.set_status_flag(Consts.StatusFlags.Carry, false)

	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.ADC(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(5)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 5
	NES.registers[Consts.CPU_Registers.X] = 2
	NES.cpu_memory[0x1236] = 1
	NES.set_status_flag(Consts.StatusFlags.Carry, false)

	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_X, 0x1234)
	Opcodes.ADC(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(6)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 6
	NES.registers[Consts.CPU_Registers.Y] = 3
	NES.cpu_memory[0x1237] = 1
	NES.set_status_flag(Consts.StatusFlags.Carry, false)

	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_Y, 0x1234)
	Opcodes.ADC(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(7)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	
	Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 1)
	
	NES.registers[Consts.CPU_Registers.A] = 0x7F
	NES.set_status_flag(Consts.StatusFlags.Carry, true)
	Opcodes.ADC(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0x81)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 0xFF
	NES.set_status_flag(Consts.StatusFlags.Carry, false)
	Opcodes.ADC(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Overflow)).is_not_zero()


func test_SBC() -> void:
	NES.registers[Consts.CPU_Registers.A] = 1
	NES.set_status_flag(Consts.StatusFlags.Carry, true)

	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.SBC(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 0x83
	NES.set_status_flag(Consts.StatusFlags.Carry, false)
	Opcodes.SBC(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0x81)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 0
	NES.set_status_flag(Consts.StatusFlags.Carry, true)
	Opcodes.SBC(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0xFF)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Overflow)).is_not_zero()


func test_INC() -> void:
	NES.set_status_flag(Consts.StatusFlags.Zero, false)
	NES.set_status_flag(Consts.StatusFlags.Negative, false)
	
	NES.cpu_memory[0] = 5
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 0)
	Opcodes.INC(context)
	
	assert_int(NES.cpu_memory[0]).is_equal(6)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.cpu_memory[1] = 6
	NES.registers[Consts.CPU_Registers.X] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage_X, 0)
	Opcodes.INC(context)
	
	assert_int(NES.cpu_memory[1]).is_equal(7)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.cpu_memory[0x1234] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.INC(context)
	
	assert_int(NES.cpu_memory[0x1234]).is_equal(0)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.cpu_memory[0x1233] = 0x7F
	NES.registers[Consts.CPU_Registers.X] = -1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_X, 0x1234)
	Opcodes.INC(context)
	
	assert_int(NES.cpu_memory[0x1233]).is_equal(0x80)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_INX() -> void:
	NES.set_status_flag(Consts.StatusFlags.Zero, false)
	NES.set_status_flag(Consts.StatusFlags.Negative, false)
	
	NES.registers[Consts.CPU_Registers.X] = 5
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.INX(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(6)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.X] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.INX(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(0)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.X] = 0x7F
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.INX(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(0x80)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_INY() -> void:
	NES.set_status_flag(Consts.StatusFlags.Zero, false)
	NES.set_status_flag(Consts.StatusFlags.Negative, false)
	
	NES.registers[Consts.CPU_Registers.Y] = 5
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.INY(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.Y]).is_equal(6)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.Y] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.INY(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.Y]).is_equal(0)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.Y] = 0x7F
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.INY(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.Y]).is_equal(0x80)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_DEC() -> void:
	NES.set_status_flag(Consts.StatusFlags.Zero, false)
	NES.set_status_flag(Consts.StatusFlags.Negative, false)
	
	NES.cpu_memory[0] = 5
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 0)
	Opcodes.DEC(context)
	
	assert_int(NES.cpu_memory[0]).is_equal(4)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.cpu_memory[1] = 6
	NES.registers[Consts.CPU_Registers.X] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage_X, 0)
	Opcodes.DEC(context)
	
	assert_int(NES.cpu_memory[1]).is_equal(5)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.cpu_memory[0x1233] = 1
	NES.registers[Consts.CPU_Registers.X] = -1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_X, 0x1234)
	Opcodes.DEC(context)
	
	assert_int(NES.cpu_memory[0x1233]).is_equal(0)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.cpu_memory[0x1234] = 0
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.DEC(context)
	
	assert_int(NES.cpu_memory[0x1234]).is_equal(0xFF)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_DEX() -> void:
	NES.set_status_flag(Consts.StatusFlags.Zero, false)
	NES.set_status_flag(Consts.StatusFlags.Negative, false)
	
	NES.registers[Consts.CPU_Registers.X] = 5
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.DEX(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(4)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.X] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.DEX(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(0)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.X] = 0
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.DEX(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(0xFF)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_DEY() -> void:
	NES.set_status_flag(Consts.StatusFlags.Zero, false)
	NES.set_status_flag(Consts.StatusFlags.Negative, false)
	
	NES.registers[Consts.CPU_Registers.Y] = 5
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.DEY(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.Y]).is_equal(4)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.Y] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.DEY(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.Y]).is_equal(0)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.Y] = 0
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.DEY(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.Y]).is_equal(0xFF)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_ASL() -> void:
	NES.set_status_flag(Consts.StatusFlags.Carry, 0)
	NES.registers[Consts.CPU_Registers.A] = 1
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.ASL(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(2)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	
	NES.set_status_flag(Consts.StatusFlags.Carry, 0)
	NES.registers[Consts.CPU_Registers.A] = 0x40
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.ASL(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0x80)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	
	NES.set_status_flag(Consts.StatusFlags.Carry, 0)
	NES.registers[Consts.CPU_Registers.A] = 0x80
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.ASL(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_zero()
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()


func test_LSR() -> void:
	NES.set_status_flag(Consts.StatusFlags.Carry, 0)
	NES.registers[Consts.CPU_Registers.A] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.LSR(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(1)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	
	NES.set_status_flag(Consts.StatusFlags.Carry, 0)
	NES.registers[Consts.CPU_Registers.A] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.LSR(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_zero()
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	
	NES.set_status_flag(Consts.StatusFlags.Carry, 0)
	NES.registers[Consts.CPU_Registers.A] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.LSR(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0x7F)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()


func test_ROL() -> void:
	NES.set_status_flag(Consts.StatusFlags.Carry, 0)
	NES.registers[Consts.CPU_Registers.A] = 1
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.ROL(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(2)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	
	NES.set_status_flag(Consts.StatusFlags.Carry, 1)
	NES.registers[Consts.CPU_Registers.A] = 0x40
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.ROL(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0x81)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	
	NES.set_status_flag(Consts.StatusFlags.Carry, 0)
	NES.registers[Consts.CPU_Registers.A] = 0x80
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.ROL(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_zero()
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()


func test_ROR() -> void:
	NES.set_status_flag(Consts.StatusFlags.Carry, 0)
	NES.registers[Consts.CPU_Registers.A] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.ROR(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(1)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	
	NES.set_status_flag(Consts.StatusFlags.Carry, 1)
	NES.registers[Consts.CPU_Registers.A] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.ROR(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0x80)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	
	NES.set_status_flag(Consts.StatusFlags.Carry, 0)
	NES.registers[Consts.CPU_Registers.A] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.ROR(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0x7F)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()


func test_AND() -> void:
	NES.registers[Consts.CPU_Registers.A] = 3
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.AND(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(1)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 0x82
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 0x80)
	Opcodes.AND(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0x80)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 0)
	Opcodes.AND(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()


func test_ORA() -> void:
	NES.registers[Consts.CPU_Registers.A] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.ORA(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(3)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 0x80)
	Opcodes.ORA(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0x82)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 0
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 0)
	Opcodes.ORA(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()


func test_EOR() -> void:
	NES.registers[Consts.CPU_Registers.A] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 3)
	Opcodes.EOR(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(1)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 0x82
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 0x01)
	Opcodes.EOR(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0x83)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 0xFF)
	Opcodes.EOR(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()


func test_CMP() -> void:
	NES.registers[Consts.CPU_Registers.A] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.CMP(context)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 0x03)
	Opcodes.CMP(context)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 0xFF)
	Opcodes.CMP(context)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 2
	NES.cpu_memory[1] = 0x3
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 1)
	Opcodes.CMP(context)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 2
	NES.registers[Consts.CPU_Registers.X] = 3
	NES.cpu_memory[4] = 0x3
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage_X, 1)
	Opcodes.CMP(context)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 0xFF
	NES.cpu_memory[0x1234] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.CMP(context)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 0xEE
	NES.registers[Consts.CPU_Registers.X] = 4
	NES.cpu_memory[0x1238] = 0xEE
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_X, 0x1234)
	Opcodes.CMP(context)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 0xDD
	NES.registers[Consts.CPU_Registers.Y] = 6
	NES.cpu_memory[0x123A] = 0xDD
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_Y, 0x1234)
	Opcodes.CMP(context)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.cpu_memory[0x1221] = 0xCC
	NES.cpu_memory[0x09] = 0x21
	NES.cpu_memory[0x0A] = 0x12
	NES.registers[Consts.CPU_Registers.A] = 0xCC
	NES.registers[Consts.CPU_Registers.X] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZPInd_X, 0x07)
	Opcodes.CMP(context)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.cpu_memory[0x5678] = 0xBB
	NES.cpu_memory[0x07] = 0x76
	NES.cpu_memory[0x08] = 0x56
	NES.registers[Consts.CPU_Registers.A] = 0xBB
	NES.registers[Consts.CPU_Registers.Y] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZPInd_Y, 0x07)
	Opcodes.CMP(context)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()


func test_CPX() -> void:
	NES.registers[Consts.CPU_Registers.X] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.CPX(context)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.X] = 2
	NES.cpu_memory[1] = 0x3
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 1)
	Opcodes.CPX(context)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	
	NES.registers[Consts.CPU_Registers.X] = 0xFF
	NES.cpu_memory[0x1234] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.CPX(context)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()


func test_CPY() -> void:
	NES.registers[Consts.CPU_Registers.Y] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.CPY(context)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.Y] = 2
	NES.cpu_memory[1] = 0x3
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 1)
	Opcodes.CPY(context)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	
	NES.registers[Consts.CPU_Registers.Y] = 0xFF
	NES.cpu_memory[0x1234] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.CPY(context)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()


func test_BIT() -> void:
	NES.cpu_memory[0] = 0x81
	NES.registers[Consts.CPU_Registers.A] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 0)
	Opcodes.BIT(context)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	
	NES.cpu_memory[0] = 0xC3
	NES.registers[Consts.CPU_Registers.A] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 0)
	Opcodes.BIT(context)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Overflow)).is_not_zero()


func test_BCC() -> void:
	NES.cpu_memory[0] = 0x34
	NES.cpu_memory[1] = 0x12
	NES.cpu_memory[3] = 0x78
	NES.cpu_memory[4] = 0x56
	
	NES.registers[Consts.CPU_Registers.PC] = 2
	NES.set_status_flag(Consts.StatusFlags.Carry, 1)
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 0)
	Opcodes.BCC(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.PC]).is_equal(2)
	
	NES.set_status_flag(Consts.StatusFlags.Carry, 0)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, -4)
	Opcodes.BCC(context)
	
	var pc = NES.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0)
	assert_int(NES.get_word(pc)).is_equal(0x1234)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 1)
	Opcodes.BCC(context)
	
	pc = NES.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(3)
	assert_int(NES.get_word(pc)).is_equal(0x5678)


func test_BCS() -> void:
	NES.cpu_memory[0] = 0x34
	NES.cpu_memory[1] = 0x12
	NES.cpu_memory[3] = 0x78
	NES.cpu_memory[4] = 0x56
	
	NES.registers[Consts.CPU_Registers.PC] = 2
	NES.set_status_flag(Consts.StatusFlags.Carry, 0)
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 0)
	Opcodes.BCS(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.PC]).is_equal(2)
	
	NES.set_status_flag(Consts.StatusFlags.Carry, 1)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, -4)
	Opcodes.BCS(context)
	
	var pc = NES.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0)
	assert_int(NES.get_word(pc)).is_equal(0x1234)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 1)
	Opcodes.BCS(context)
	
	pc = NES.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(3)
	assert_int(NES.get_word(pc)).is_equal(0x5678)


func test_BNE() -> void:
	NES.cpu_memory[0] = 0x34
	NES.cpu_memory[1] = 0x12
	NES.cpu_memory[3] = 0x78
	NES.cpu_memory[4] = 0x56
	
	NES.registers[Consts.CPU_Registers.PC] = 2
	NES.set_status_flag(Consts.StatusFlags.Zero, 1)
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 0)
	Opcodes.BNE(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.PC]).is_equal(2)
	
	NES.set_status_flag(Consts.StatusFlags.Zero, 0)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, -4)
	Opcodes.BNE(context)
	
	var pc = NES.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0)
	assert_int(NES.get_word(pc)).is_equal(0x1234)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 1)
	Opcodes.BNE(context)
	
	pc = NES.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(3)
	assert_int(NES.get_word(pc)).is_equal(0x5678)


func test_BEQ() -> void:
	NES.cpu_memory[0] = 0x34
	NES.cpu_memory[1] = 0x12
	NES.cpu_memory[3] = 0x78
	NES.cpu_memory[4] = 0x56
	
	NES.registers[Consts.CPU_Registers.PC] = 2
	NES.set_status_flag(Consts.StatusFlags.Zero, 0)
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 0)
	Opcodes.BEQ(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.PC]).is_equal(2)
	
	NES.set_status_flag(Consts.StatusFlags.Zero, 1)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, -4)
	Opcodes.BEQ(context)
	
	var pc = NES.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0)
	assert_int(NES.get_word(pc)).is_equal(0x1234)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 1)
	Opcodes.BEQ(context)
	
	pc = NES.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(3)
	assert_int(NES.get_word(pc)).is_equal(0x5678)


func test_BPL() -> void:
	NES.cpu_memory[0] = 0x34
	NES.cpu_memory[1] = 0x12
	NES.cpu_memory[3] = 0x78
	NES.cpu_memory[4] = 0x56
	
	NES.registers[Consts.CPU_Registers.PC] = 2
	NES.set_status_flag(Consts.StatusFlags.Negative, 1)
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 0)
	Opcodes.BPL(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.PC]).is_equal(2)
	
	NES.set_status_flag(Consts.StatusFlags.Negative, 0)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, -4)
	Opcodes.BPL(context)
	
	var pc = NES.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0)
	assert_int(NES.get_word(pc)).is_equal(0x1234)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 1)
	Opcodes.BPL(context)
	
	pc = NES.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(3)
	assert_int(NES.get_word(pc)).is_equal(0x5678)


func test_BMI() -> void:
	NES.cpu_memory[0] = 0x34
	NES.cpu_memory[1] = 0x12
	NES.cpu_memory[3] = 0x78
	NES.cpu_memory[4] = 0x56
	
	NES.registers[Consts.CPU_Registers.PC] = 2
	NES.set_status_flag(Consts.StatusFlags.Negative, 0)
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 0)
	Opcodes.BMI(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.PC]).is_equal(2)
	
	NES.set_status_flag(Consts.StatusFlags.Negative, 1)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, -4)
	Opcodes.BMI(context)
	
	var pc = NES.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0)
	assert_int(NES.get_word(pc)).is_equal(0x1234)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 1)
	Opcodes.BMI(context)
	
	pc = NES.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(3)
	assert_int(NES.get_word(pc)).is_equal(0x5678)


func test_BVC() -> void:
	NES.cpu_memory[0] = 0x34
	NES.cpu_memory[1] = 0x12
	NES.cpu_memory[3] = 0x78
	NES.cpu_memory[4] = 0x56
	
	NES.registers[Consts.CPU_Registers.PC] = 2
	NES.set_status_flag(Consts.StatusFlags.Overflow, 1)
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 0)
	Opcodes.BVC(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.PC]).is_equal(2)
	
	NES.set_status_flag(Consts.StatusFlags.Overflow, 0)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, -4)
	Opcodes.BVC(context)
	
	var pc = NES.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0)
	assert_int(NES.get_word(pc)).is_equal(0x1234)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 1)
	Opcodes.BVC(context)
	
	pc = NES.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(3)
	assert_int(NES.get_word(pc)).is_equal(0x5678)


func test_BVS() -> void:
	NES.cpu_memory[0] = 0x34
	NES.cpu_memory[1] = 0x12
	NES.cpu_memory[3] = 0x78
	NES.cpu_memory[4] = 0x56
	
	NES.registers[Consts.CPU_Registers.PC] = 2
	NES.set_status_flag(Consts.StatusFlags.Overflow, 0)
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 0)
	Opcodes.BVS(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.PC]).is_equal(2)
	
	NES.set_status_flag(Consts.StatusFlags.Overflow, 1)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, -4)
	Opcodes.BVS(context)
	
	var pc = NES.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0)
	assert_int(NES.get_word(pc)).is_equal(0x1234)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 1)
	Opcodes.BVS(context)
	
	pc = NES.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(3)
	assert_int(NES.get_word(pc)).is_equal(0x5678)


func test_TAX() -> void:
	NES.registers[Consts.CPU_Registers.A] = 1
	NES.registers[Consts.CPU_Registers.X] = 2
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(1)
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(2)
	
	Opcodes.TAX(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(1)
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(1)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 0
	Opcodes.TAX(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0)
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(0)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 0xFF
	Opcodes.TAX(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0xFF)
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(0xFF)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_TXA() -> void:
	NES.registers[Consts.CPU_Registers.X] = 1
	NES.registers[Consts.CPU_Registers.A] = 2
	
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(1)
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(2)
	
	Opcodes.TXA(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(1)
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(1)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.X] = 0
	Opcodes.TXA(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(0)
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.X] = 0xFF
	Opcodes.TXA(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(0xFF)
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0xFF)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_TAY() -> void:
	NES.registers[Consts.CPU_Registers.A] = 1
	NES.registers[Consts.CPU_Registers.Y] = 2
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(1)
	assert_int(NES.registers[Consts.CPU_Registers.Y]).is_equal(2)
	
	Opcodes.TAY(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(1)
	assert_int(NES.registers[Consts.CPU_Registers.Y]).is_equal(1)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 0
	Opcodes.TAY(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0)
	assert_int(NES.registers[Consts.CPU_Registers.Y]).is_equal(0)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.A] = 0xFF
	Opcodes.TAY(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0xFF)
	assert_int(NES.registers[Consts.CPU_Registers.Y]).is_equal(0xFF)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_TYA() -> void:
	NES.registers[Consts.CPU_Registers.Y] = 1
	NES.registers[Consts.CPU_Registers.A] = 2
	
	assert_int(NES.registers[Consts.CPU_Registers.Y]).is_equal(1)
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(2)
	
	Opcodes.TYA(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.Y]).is_equal(1)
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(1)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.Y] = 0
	Opcodes.TYA(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.Y]).is_equal(0)
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.Y] = 0xFF
	Opcodes.TYA(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.Y]).is_equal(0xFF)
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0xFF)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_TSX() -> void:
	NES.registers[Consts.CPU_Registers.SP] = 1
	NES.registers[Consts.CPU_Registers.X] = 2
	
	assert_int(NES.registers[Consts.CPU_Registers.SP]).is_equal(1)
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(2)
	
	Opcodes.TSX(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.SP]).is_equal(1)
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(1)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.SP] = 0
	Opcodes.TSX(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.SP]).is_equal(0)
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(0)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.SP] = 0xFF
	Opcodes.TSX(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.SP]).is_equal(0xFF)
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(0xFF)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_TXS() -> void:
	NES.registers[Consts.CPU_Registers.X] = 1
	NES.registers[Consts.CPU_Registers.SP] = 2
	
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(1)
	assert_int(NES.registers[Consts.CPU_Registers.SP]).is_equal(2)
	
	Opcodes.TXS(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(1)
	assert_int(NES.registers[Consts.CPU_Registers.SP]).is_equal(1)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.X] = 0
	Opcodes.TXS(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(0)
	assert_int(NES.registers[Consts.CPU_Registers.SP]).is_equal(0)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	NES.registers[Consts.CPU_Registers.X] = 0xFF
	Opcodes.TXS(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.X]).is_equal(0xFF)
	assert_int(NES.registers[Consts.CPU_Registers.SP]).is_equal(0xFF)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_PHA() -> void:
	NES.registers[Consts.CPU_Registers.A] = 0x0F
	
	assert_int(NES.registers[Consts.CPU_Registers.SP]).is_equal(0xFD)
	
	Opcodes.PHA(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.SP]).is_equal(0xFC)
	assert_int(NES.cpu_memory[0x0100 + NES.registers[Consts.CPU_Registers.SP] + 1]).is_equal(0x0F)


func test_PLA() -> void:
	NES.cpu_memory[0x0100 + NES.registers[Consts.CPU_Registers.SP]] = 0x0F
	NES.registers[Consts.CPU_Registers.SP] = 0xFC
	
	Opcodes.PLA(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.A]).is_equal(0x0F)
	assert_int(NES.registers[Consts.CPU_Registers.SP]).is_equal(0xFD)


func test_PHP() -> void:
	NES.set_status_flag(Consts.StatusFlags.Carry, true)
	NES.set_status_flag(Consts.StatusFlags.Negative, true)
	
	assert_int(NES.registers[Consts.CPU_Registers.SP]).is_equal(0xFD)
	
	Opcodes.PHP(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.SP]).is_equal(0xFC)
	assert_int(NES.cpu_memory[0x0100 + NES.registers[Consts.CPU_Registers.SP] + 1]).is_equal(0b10110101)


func test_PLP() -> void:
	NES.cpu_memory[0x0100 + NES.registers[Consts.CPU_Registers.SP]] = 0b10110101
	NES.registers[Consts.CPU_Registers.SP] = 0xFC
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Opcodes.PLP(null)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	assert_int(NES.registers[Consts.CPU_Registers.SP]).is_equal(0xFD)


func test_JMP() -> void:
	NES.cpu_memory[0x12] = 0x56
	NES.cpu_memory[0x13] = 0x34
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x12)
	Opcodes.JMP(context)
	
	var pc = NES.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0x12)
	assert_int(NES.get_word(pc)).is_equal(0x3456)
	
	NES.cpu_memory[0x2005] = 0x12
	NES.cpu_memory[0x2006] = 0x20
	NES.cpu_memory[0x2012] = 0x9A
	NES.cpu_memory[0x2013] = 0x78
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Indirect, 0x2005)
	Opcodes.JMP(context)
	
	pc = NES.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0x2012)
	assert_int(NES.get_word(pc)).is_equal(0x789A)


func test_JSR() -> void:
	NES.registers[Consts.CPU_Registers.PC] = 0x1234
	NES.registers[Consts.CPU_Registers.SP] = 0xFD
	
	NES.cpu_memory[0x12] = 0x56
	NES.cpu_memory[0x13] = 0x34
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x12)
	Opcodes.JSR(context)
	
	var pc = NES.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0x12)
	assert_int(NES.get_word(pc)).is_equal(0x3456)
	
	assert_int(NES.registers[Consts.CPU_Registers.SP]).is_equal(0xFB)
	
	assert_int(NES.cpu_memory[0x01FD]).is_equal(0x34)
	assert_int(NES.cpu_memory[0x01FC]).is_equal(0x12)


func test_RTS() -> void:
	NES.registers[Consts.CPU_Registers.PC] = 0
	NES.cpu_memory[0x01FD] = 0x34
	NES.cpu_memory[0x01FC] = 0x12
	NES.registers[Consts.CPU_Registers.SP] = 0xFB
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied, 0)
	Opcodes.RTS(context)
	
	assert_int(NES.registers[Consts.CPU_Registers.PC]).is_equal(0x1234)
	assert_int(NES.registers[Consts.CPU_Registers.SP]).is_equal(0xFD)


func test_RTI() -> void:
	NES.registers[Consts.CPU_Registers.PC] = 0
	NES.cpu_memory[0x01FD] = 0x34
	NES.cpu_memory[0x01FC] = 0x12
	NES.cpu_memory[0x01FB] = 0b10110101
	NES.registers[Consts.CPU_Registers.SP] = 0xFA
	
	NES.set_status_flag(Consts.StatusFlags.Carry, 0)
	NES.set_status_flag(Consts.StatusFlags.Negative, 0)
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied, 0)
	Opcodes.RTI(context)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	
	assert_int(NES.registers[Consts.CPU_Registers.PC]).is_equal(0x1234)
	assert_int(NES.registers[Consts.CPU_Registers.SP]).is_equal(0xFD)


func test_CLC() -> void:
	NES.set_status_flag(Consts.StatusFlags.Carry, 1)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	Opcodes.CLC(null)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_zero()


func test_SEC() -> void:
	NES.set_status_flag(Consts.StatusFlags.Carry, 0)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	Opcodes.SEC(null)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()


func test_CLD() -> void:
	NES.set_status_flag(Consts.StatusFlags.Decimal, 1)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Decimal)).is_not_zero()
	Opcodes.CLD(null)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Decimal)).is_zero()


func test_SED() -> void:
	NES.set_status_flag(Consts.StatusFlags.Decimal, 0)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Decimal)).is_zero()
	Opcodes.SED(null)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Decimal)).is_not_zero()


func test_CLI() -> void:
	NES.set_status_flag(Consts.StatusFlags.InterruptDisable, 1)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.InterruptDisable)).is_not_zero()
	Opcodes.CLI(null)
	assert_int(NES.get_status_flag(Consts.StatusFlags.InterruptDisable)).is_zero()


func test_SEI() -> void:
	NES.set_status_flag(Consts.StatusFlags.InterruptDisable, 0)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.InterruptDisable)).is_zero()
	Opcodes.SEI(null)
	assert_int(NES.get_status_flag(Consts.StatusFlags.InterruptDisable)).is_not_zero()


func test_CLV() -> void:
	NES.set_status_flag(Consts.StatusFlags.Overflow, 0)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	Opcodes.CLV(null)
	assert_int(NES.get_status_flag(Consts.StatusFlags.Overflow)).is_not_zero()


func test_BRK() -> void:
	NES.registers[Consts.CPU_Registers.PC] = 0x1234
	NES.set_status_flag(Consts.StatusFlags.Carry, true)
	NES.set_status_flag(Consts.StatusFlags.Negative, true)
	
	assert_int(NES.registers[Consts.CPU_Registers.SP]).is_equal(0xFD)
	assert_int(NES.registers[Consts.CPU_Registers.PC]).is_equal(0x1234)
	
	Opcodes.BRK(null)
	
	assert_int(NES.registers[Consts.CPU_Registers.SP]).is_equal(0xFA)
	assert_int(NES.registers[Consts.CPU_Registers.PC]).is_equal(0xFFFE)
	
	assert_int(NES.cpu_memory[0x0100 + NES.registers[Consts.CPU_Registers.SP] + 1]).is_equal(0b10110101)
	assert_int(NES.cpu_memory[0x0100 + NES.registers[Consts.CPU_Registers.SP] + 2]).is_equal(0x12)
	assert_int(NES.cpu_memory[0x0100 + NES.registers[Consts.CPU_Registers.SP] + 3]).is_equal(0x34)
	
	assert_int(NES.get_status_flag(Consts.StatusFlags.InterruptDisable)).is_not_zero()
	assert_int(NES.get_status_flag(Consts.StatusFlags.B_1)).is_not_zero()


func test_NOP() -> void:
	Opcodes.NOP(null)
