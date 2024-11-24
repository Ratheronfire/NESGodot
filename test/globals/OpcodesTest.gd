# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
class_name OpcodesTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://src/globals/Opcodes.gd'

func before_test():
	Nes.init()


func test_LDA() -> void:
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.LDA(context)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(1)
	
	Nes.memory[0x20] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 0x20)
	Opcodes.LDA(context)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(2)
	
	Nes.memory[0x21] = 3
	Nes.registers[Consts.CPU_Registers.X] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage_X, 0x20)
	Opcodes.LDA(context)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(3)
	
	Nes.memory[0x1234] = 4
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.LDA(context)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(4)
	
	Nes.memory[0x1236] = 5
	Nes.registers[Consts.CPU_Registers.X] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_X, 0x1234)
	Opcodes.LDA(context)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(5)
	
	Nes.memory[0x1236] = 5
	Nes.registers[Consts.CPU_Registers.Y] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_Y, 0x1234)
	Opcodes.LDA(context)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(5)
	
	Nes.memory[0x1234] = 7
	Nes.memory[0x09] = 0x34
	Nes.memory[0x0A] = 0x12
	Nes.registers[Consts.CPU_Registers.X] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZPInd_X, 0x07)
	Opcodes.LDA(context)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(7)
	
	Nes.memory[0x3456] = 8
	Nes.memory[0xFF] = 0x56
	Nes.memory[0x00] = 0x34
	Nes.registers[Consts.CPU_Registers.X] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZPInd_X, 0xFE)
	Opcodes.LDA(context)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(8)
	
	Nes.memory[0x5678] = 9
	Nes.memory[0x07] = 0x76
	Nes.memory[0x08] = 0x56
	Nes.registers[Consts.CPU_Registers.Y] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZPInd_Y, 0x07)
	Opcodes.LDA(context)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(9)
	
	Nes.memory[0x6789] = 10
	Nes.memory[0xFF] = 0x87
	Nes.memory[0x00] = 0x67
	Nes.registers[Consts.CPU_Registers.Y] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZPInd_Y, 0xFF)
	Opcodes.LDA(context)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(10)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 0)
	Opcodes.LDA(context)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.LDA(context)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 0x81)
	Opcodes.LDA(context)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_LDX() -> void:
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.LDX(context)
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(1)
	
	Nes.memory[0x20] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 0x20)
	Opcodes.LDX(context)
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(2)
	
	Nes.memory[0x21] = 3
	Nes.registers[Consts.CPU_Registers.Y] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage_Y, 0x20)
	Opcodes.LDX(context)
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(3)
	
	Nes.memory[0x1234] = 4
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.LDX(context)
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(4)
	
	Nes.memory[0x1236] = 5
	Nes.registers[Consts.CPU_Registers.Y] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_Y, 0x1234)
	Opcodes.LDX(context)
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(5)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 0)
	Opcodes.LDX(context)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.LDX(context)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 0x81)
	Opcodes.LDX(context)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_LDY() -> void:
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.LDY(context)
	assert_int(Nes.registers[Consts.CPU_Registers.Y]).is_equal(1)
	
	Nes.memory[0x20] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 0x20)
	Opcodes.LDY(context)
	assert_int(Nes.registers[Consts.CPU_Registers.Y]).is_equal(2)
	
	Nes.memory[0x21] = 3
	Nes.registers[Consts.CPU_Registers.X] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage_X, 0x20)
	Opcodes.LDY(context)
	assert_int(Nes.registers[Consts.CPU_Registers.Y]).is_equal(3)
	
	Nes.memory[0x1234] = 4
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.LDY(context)
	assert_int(Nes.registers[Consts.CPU_Registers.Y]).is_equal(4)
	
	Nes.memory[0x1236] = 5
	Nes.registers[Consts.CPU_Registers.X] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_X, 0x1234)
	Opcodes.LDY(context)
	assert_int(Nes.registers[Consts.CPU_Registers.Y]).is_equal(5)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 0)
	Opcodes.LDY(context)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.LDY(context)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 0x81)
	Opcodes.LDY(context)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_STA() -> void:
	Nes.registers[Consts.CPU_Registers.A] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 0x20)
	Opcodes.STA(context)
	assert_int(Nes.memory[0x20]).is_equal(2)
	
	Nes.registers[Consts.CPU_Registers.A] = 3
	Nes.registers[Consts.CPU_Registers.X] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage_X, 0x20)
	Opcodes.STA(context)
	assert_int(Nes.memory[0x21]).is_equal(3)
	
	Nes.registers[Consts.CPU_Registers.A] = 4
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.STA(context)
	assert_int(Nes.memory[0x1234]).is_equal(4)
	
	Nes.registers[Consts.CPU_Registers.A] = 5
	Nes.registers[Consts.CPU_Registers.X] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_X, 0x1234)
	Opcodes.STA(context)
	assert_int(Nes.memory[0x1236]).is_equal(5)
	
	Nes.registers[Consts.CPU_Registers.A] = 6
	Nes.registers[Consts.CPU_Registers.Y] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_Y, 0x1234)
	Opcodes.STA(context)
	assert_int(Nes.memory[0x1236]).is_equal(6)
	
	Nes.memory[0x09] = 0x34
	Nes.memory[0x0A] = 0x12
	Nes.registers[Consts.CPU_Registers.A] = 7
	Nes.registers[Consts.CPU_Registers.X] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZPInd_X, 0x07)
	Opcodes.STA(context)
	assert_int(Nes.memory[0x1234]).is_equal(7)
	
	Nes.memory[0x07] = 0x34
	Nes.memory[0x08] = 0x12
	Nes.registers[Consts.CPU_Registers.A] = 8
	Nes.registers[Consts.CPU_Registers.Y] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZPInd_Y, 0x07)
	Opcodes.STA(context)
	assert_int(Nes.memory[0x1236]).is_equal(8)


func test_STX() -> void:
	Nes.registers[Consts.CPU_Registers.X] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 0x20)
	Opcodes.STX(context)
	assert_int(Nes.memory[0x20]).is_equal(2)
	
	Nes.registers[Consts.CPU_Registers.X] = 3
	Nes.registers[Consts.CPU_Registers.Y] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage_Y, 0x20)
	Opcodes.STX(context)
	assert_int(Nes.memory[0x21]).is_equal(3)
	
	Nes.registers[Consts.CPU_Registers.X] = 4
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.STX(context)
	assert_int(Nes.memory[0x1234]).is_equal(4)


func test_STY() -> void:
	Nes.registers[Consts.CPU_Registers.A] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 0x20)
	Opcodes.STA(context)
	assert_int(Nes.memory[0x20]).is_equal(2)
	
	Nes.registers[Consts.CPU_Registers.A] = 3
	Nes.registers[Consts.CPU_Registers.X] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage_X, 0x20)
	Opcodes.STA(context)
	assert_int(Nes.memory[0x21]).is_equal(3)
	
	Nes.registers[Consts.CPU_Registers.A] = 4
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.STA(context)
	assert_int(Nes.memory[0x1234]).is_equal(4)


func test_ADC() -> void:
	Nes.registers[Consts.CPU_Registers.A] = 1
	Nes.set_status_flag(Consts.StatusFlags.Carry, false)

	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.ADC(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(2)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 2
	Nes.memory[0x1] = 1
	Nes.set_status_flag(Consts.StatusFlags.Carry, false)

	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 1)
	Opcodes.ADC(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(3)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 3
	Nes.registers[Consts.CPU_Registers.X] = 1
	Nes.memory[0x2] = 1
	Nes.set_status_flag(Consts.StatusFlags.Carry, false)

	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage_X, 1)
	Opcodes.ADC(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(4)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 4
	Nes.memory[0x1234] = 1
	Nes.set_status_flag(Consts.StatusFlags.Carry, false)

	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.ADC(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(5)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 5
	Nes.registers[Consts.CPU_Registers.X] = 2
	Nes.memory[0x1236] = 1
	Nes.set_status_flag(Consts.StatusFlags.Carry, false)

	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_X, 0x1234)
	Opcodes.ADC(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(6)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 6
	Nes.registers[Consts.CPU_Registers.Y] = 3
	Nes.memory[0x1237] = 1
	Nes.set_status_flag(Consts.StatusFlags.Carry, false)

	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_Y, 0x1234)
	Opcodes.ADC(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(7)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	
	Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 1)
	
	Nes.registers[Consts.CPU_Registers.A] = 0x7F
	Nes.set_status_flag(Consts.StatusFlags.Carry, true)
	Opcodes.ADC(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0x81)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 0xFF
	Nes.set_status_flag(Consts.StatusFlags.Carry, false)
	Opcodes.ADC(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Overflow)).is_not_zero()


func test_SBC() -> void:
	Nes.registers[Consts.CPU_Registers.A] = 1
	Nes.set_status_flag(Consts.StatusFlags.Carry, true)

	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.SBC(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 0x83
	Nes.set_status_flag(Consts.StatusFlags.Carry, false)
	Opcodes.SBC(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0x81)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 0
	Nes.set_status_flag(Consts.StatusFlags.Carry, true)
	Opcodes.SBC(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0xFF)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Overflow)).is_not_zero()


func test_INC() -> void:
	Nes.set_status_flag(Consts.StatusFlags.Zero, false)
	Nes.set_status_flag(Consts.StatusFlags.Negative, false)
	
	Nes.memory[0] = 5
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 0)
	Opcodes.INC(context)
	
	assert_int(Nes.memory[0]).is_equal(6)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.memory[1] = 6
	Nes.registers[Consts.CPU_Registers.X] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage_X, 0)
	Opcodes.INC(context)
	
	assert_int(Nes.memory[1]).is_equal(7)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.memory[0x1234] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.INC(context)
	
	assert_int(Nes.memory[0x1234]).is_equal(0)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.memory[0x1233] = 0x7F
	Nes.registers[Consts.CPU_Registers.X] = -1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_X, 0x1234)
	Opcodes.INC(context)
	
	assert_int(Nes.memory[0x1233]).is_equal(0x80)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_INX() -> void:
	Nes.set_status_flag(Consts.StatusFlags.Zero, false)
	Nes.set_status_flag(Consts.StatusFlags.Negative, false)
	
	Nes.registers[Consts.CPU_Registers.X] = 5
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.INX(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(6)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.X] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.INX(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(0)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.X] = 0x7F
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.INX(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(0x80)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_INY() -> void:
	Nes.set_status_flag(Consts.StatusFlags.Zero, false)
	Nes.set_status_flag(Consts.StatusFlags.Negative, false)
	
	Nes.registers[Consts.CPU_Registers.Y] = 5
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.INY(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.Y]).is_equal(6)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.Y] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.INY(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.Y]).is_equal(0)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.Y] = 0x7F
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.INY(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.Y]).is_equal(0x80)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_DEC() -> void:
	Nes.set_status_flag(Consts.StatusFlags.Zero, false)
	Nes.set_status_flag(Consts.StatusFlags.Negative, false)
	
	Nes.memory[0] = 5
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 0)
	Opcodes.DEC(context)
	
	assert_int(Nes.memory[0]).is_equal(4)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.memory[1] = 6
	Nes.registers[Consts.CPU_Registers.X] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage_X, 0)
	Opcodes.DEC(context)
	
	assert_int(Nes.memory[1]).is_equal(5)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.memory[0x1233] = 1
	Nes.registers[Consts.CPU_Registers.X] = -1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_X, 0x1234)
	Opcodes.DEC(context)
	
	assert_int(Nes.memory[0x1233]).is_equal(0)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.memory[0x1234] = 0
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.DEC(context)
	
	assert_int(Nes.memory[0x1234]).is_equal(0xFF)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_DEX() -> void:
	Nes.set_status_flag(Consts.StatusFlags.Zero, false)
	Nes.set_status_flag(Consts.StatusFlags.Negative, false)
	
	Nes.registers[Consts.CPU_Registers.X] = 5
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.DEX(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(4)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.X] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.DEX(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(0)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.X] = 0
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.DEX(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(0xFF)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_DEY() -> void:
	Nes.set_status_flag(Consts.StatusFlags.Zero, false)
	Nes.set_status_flag(Consts.StatusFlags.Negative, false)
	
	Nes.registers[Consts.CPU_Registers.Y] = 5
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.DEY(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.Y]).is_equal(4)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.Y] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.DEY(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.Y]).is_equal(0)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.Y] = 0
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied)
	Opcodes.DEY(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.Y]).is_equal(0xFF)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_ASL() -> void:
	Nes.set_status_flag(Consts.StatusFlags.Carry, 0)
	Nes.registers[Consts.CPU_Registers.A] = 1
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.ASL(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(2)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	
	Nes.set_status_flag(Consts.StatusFlags.Carry, 0)
	Nes.registers[Consts.CPU_Registers.A] = 0x40
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.ASL(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0x80)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	
	Nes.set_status_flag(Consts.StatusFlags.Carry, 0)
	Nes.registers[Consts.CPU_Registers.A] = 0x80
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.ASL(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_zero()
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()


func test_LSR() -> void:
	Nes.set_status_flag(Consts.StatusFlags.Carry, 0)
	Nes.registers[Consts.CPU_Registers.A] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.LSR(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(1)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	
	Nes.set_status_flag(Consts.StatusFlags.Carry, 0)
	Nes.registers[Consts.CPU_Registers.A] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.LSR(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_zero()
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	
	Nes.set_status_flag(Consts.StatusFlags.Carry, 0)
	Nes.registers[Consts.CPU_Registers.A] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.LSR(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0x7F)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()


func test_ROL() -> void:
	Nes.set_status_flag(Consts.StatusFlags.Carry, 0)
	Nes.registers[Consts.CPU_Registers.A] = 1
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.ROL(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(2)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	
	Nes.set_status_flag(Consts.StatusFlags.Carry, 1)
	Nes.registers[Consts.CPU_Registers.A] = 0x40
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.ROL(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0x81)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	
	Nes.set_status_flag(Consts.StatusFlags.Carry, 0)
	Nes.registers[Consts.CPU_Registers.A] = 0x80
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.ROL(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_zero()
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()


func test_ROR() -> void:
	Nes.set_status_flag(Consts.StatusFlags.Carry, 0)
	Nes.registers[Consts.CPU_Registers.A] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.ROR(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(1)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	
	Nes.set_status_flag(Consts.StatusFlags.Carry, 1)
	Nes.registers[Consts.CPU_Registers.A] = 1
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.ROR(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0x80)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	
	Nes.set_status_flag(Consts.StatusFlags.Carry, 0)
	Nes.registers[Consts.CPU_Registers.A] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.ROR(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0x7F)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()


func test_AND() -> void:
	Nes.registers[Consts.CPU_Registers.A] = 3
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.AND(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(1)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 0x82
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 0x80)
	Opcodes.AND(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0x80)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 0)
	Opcodes.AND(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()


func test_ORA() -> void:
	Nes.registers[Consts.CPU_Registers.A] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.ORA(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(3)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 0x80)
	Opcodes.ORA(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0x82)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 0
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 0)
	Opcodes.ORA(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()


func test_EOR() -> void:
	Nes.registers[Consts.CPU_Registers.A] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 3)
	Opcodes.EOR(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(1)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 0x82
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 0x01)
	Opcodes.EOR(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0x83)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 0xFF)
	Opcodes.EOR(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()


func test_CMP() -> void:
	Nes.registers[Consts.CPU_Registers.A] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.CMP(context)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 0x03)
	Opcodes.CMP(context)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 0xFF)
	Opcodes.CMP(context)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 2
	Nes.memory[1] = 0x3
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 1)
	Opcodes.CMP(context)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 2
	Nes.registers[Consts.CPU_Registers.X] = 3
	Nes.memory[4] = 0x3
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage_X, 1)
	Opcodes.CMP(context)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 0xFF
	Nes.memory[0x1234] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.CMP(context)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 0xEE
	Nes.registers[Consts.CPU_Registers.X] = 4
	Nes.memory[0x1238] = 0xEE
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_X, 0x1234)
	Opcodes.CMP(context)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 0xDD
	Nes.registers[Consts.CPU_Registers.Y] = 6
	Nes.memory[0x123A] = 0xDD
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_Y, 0x1234)
	Opcodes.CMP(context)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.memory[0x1221] = 0xCC
	Nes.memory[0x09] = 0x21
	Nes.memory[0x0A] = 0x12
	Nes.registers[Consts.CPU_Registers.A] = 0xCC
	Nes.registers[Consts.CPU_Registers.X] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZPInd_X, 0x07)
	Opcodes.CMP(context)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.memory[0x5678] = 0xBB
	Nes.memory[0x07] = 0x76
	Nes.memory[0x08] = 0x56
	Nes.registers[Consts.CPU_Registers.A] = 0xBB
	Nes.registers[Consts.CPU_Registers.Y] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZPInd_Y, 0x07)
	Opcodes.CMP(context)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()


func test_CPX() -> void:
	Nes.registers[Consts.CPU_Registers.X] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.CPX(context)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.X] = 2
	Nes.memory[1] = 0x3
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 1)
	Opcodes.CPX(context)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	
	Nes.registers[Consts.CPU_Registers.X] = 0xFF
	Nes.memory[0x1234] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.CPX(context)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()


func test_CPY() -> void:
	Nes.registers[Consts.CPU_Registers.Y] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.CPY(context)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.Y] = 2
	Nes.memory[1] = 0x3
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 1)
	Opcodes.CPY(context)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	
	Nes.registers[Consts.CPU_Registers.Y] = 0xFF
	Nes.memory[0x1234] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x1234)
	Opcodes.CPY(context)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()


func test_BIT() -> void:
	Nes.memory[0] = 0x81
	Nes.registers[Consts.CPU_Registers.A] = 2
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 0)
	Opcodes.BIT(context)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	
	Nes.memory[0] = 0xC3
	Nes.registers[Consts.CPU_Registers.A] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, 0)
	Opcodes.BIT(context)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Overflow)).is_not_zero()


func test_BCC() -> void:
	Nes.memory[0] = 0x34
	Nes.memory[1] = 0x12
	Nes.memory[3] = 0x78
	Nes.memory[4] = 0x56
	
	Nes.registers[Consts.CPU_Registers.PC] = 2
	Nes.set_status_flag(Consts.StatusFlags.Carry, 1)
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 0)
	Opcodes.BCC(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.PC]).is_equal(2)
	
	Nes.set_status_flag(Consts.StatusFlags.Carry, 0)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, -2)
	Opcodes.BCC(context)
	
	var pc = Nes.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0)
	assert_int(Nes.get_word(pc)).is_equal(0x1234)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 3)
	Opcodes.BCC(context)
	
	pc = Nes.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(3)
	assert_int(Nes.get_word(pc)).is_equal(0x5678)


func test_BCS() -> void:
	Nes.memory[0] = 0x34
	Nes.memory[1] = 0x12
	Nes.memory[3] = 0x78
	Nes.memory[4] = 0x56
	
	Nes.registers[Consts.CPU_Registers.PC] = 2
	Nes.set_status_flag(Consts.StatusFlags.Carry, 0)
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 0)
	Opcodes.BCS(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.PC]).is_equal(2)
	
	Nes.set_status_flag(Consts.StatusFlags.Carry, 1)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, -2)
	Opcodes.BCS(context)
	
	var pc = Nes.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0)
	assert_int(Nes.get_word(pc)).is_equal(0x1234)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 3)
	Opcodes.BCS(context)
	
	pc = Nes.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(3)
	assert_int(Nes.get_word(pc)).is_equal(0x5678)


func test_BNE() -> void:
	Nes.memory[0] = 0x34
	Nes.memory[1] = 0x12
	Nes.memory[3] = 0x78
	Nes.memory[4] = 0x56
	
	Nes.registers[Consts.CPU_Registers.PC] = 2
	Nes.set_status_flag(Consts.StatusFlags.Zero, 1)
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 0)
	Opcodes.BNE(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.PC]).is_equal(2)
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, 0)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, -2)
	Opcodes.BNE(context)
	
	var pc = Nes.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0)
	assert_int(Nes.get_word(pc)).is_equal(0x1234)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 3)
	Opcodes.BNE(context)
	
	pc = Nes.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(3)
	assert_int(Nes.get_word(pc)).is_equal(0x5678)


func test_BEQ() -> void:
	Nes.memory[0] = 0x34
	Nes.memory[1] = 0x12
	Nes.memory[3] = 0x78
	Nes.memory[4] = 0x56
	
	Nes.registers[Consts.CPU_Registers.PC] = 2
	Nes.set_status_flag(Consts.StatusFlags.Zero, 0)
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 0)
	Opcodes.BEQ(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.PC]).is_equal(2)
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, 1)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, -2)
	Opcodes.BEQ(context)
	
	var pc = Nes.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0)
	assert_int(Nes.get_word(pc)).is_equal(0x1234)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 3)
	Opcodes.BEQ(context)
	
	pc = Nes.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(3)
	assert_int(Nes.get_word(pc)).is_equal(0x5678)


func test_BPL() -> void:
	Nes.memory[0] = 0x34
	Nes.memory[1] = 0x12
	Nes.memory[3] = 0x78
	Nes.memory[4] = 0x56
	
	Nes.registers[Consts.CPU_Registers.PC] = 2
	Nes.set_status_flag(Consts.StatusFlags.Negative, 1)
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 0)
	Opcodes.BPL(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.PC]).is_equal(2)
	
	Nes.set_status_flag(Consts.StatusFlags.Negative, 0)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, -2)
	Opcodes.BPL(context)
	
	var pc = Nes.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0)
	assert_int(Nes.get_word(pc)).is_equal(0x1234)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 3)
	Opcodes.BPL(context)
	
	pc = Nes.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(3)
	assert_int(Nes.get_word(pc)).is_equal(0x5678)


func test_BMI() -> void:
	Nes.memory[0] = 0x34
	Nes.memory[1] = 0x12
	Nes.memory[3] = 0x78
	Nes.memory[4] = 0x56
	
	Nes.registers[Consts.CPU_Registers.PC] = 2
	Nes.set_status_flag(Consts.StatusFlags.Negative, 0)
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 0)
	Opcodes.BMI(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.PC]).is_equal(2)
	
	Nes.set_status_flag(Consts.StatusFlags.Negative, 1)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, -2)
	Opcodes.BMI(context)
	
	var pc = Nes.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0)
	assert_int(Nes.get_word(pc)).is_equal(0x1234)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 3)
	Opcodes.BMI(context)
	
	pc = Nes.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(3)
	assert_int(Nes.get_word(pc)).is_equal(0x5678)


func test_BVC() -> void:
	Nes.memory[0] = 0x34
	Nes.memory[1] = 0x12
	Nes.memory[3] = 0x78
	Nes.memory[4] = 0x56
	
	Nes.registers[Consts.CPU_Registers.PC] = 2
	Nes.set_status_flag(Consts.StatusFlags.Overflow, 1)
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 0)
	Opcodes.BVC(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.PC]).is_equal(2)
	
	Nes.set_status_flag(Consts.StatusFlags.Overflow, 0)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, -2)
	Opcodes.BVC(context)
	
	var pc = Nes.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0)
	assert_int(Nes.get_word(pc)).is_equal(0x1234)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 3)
	Opcodes.BVC(context)
	
	pc = Nes.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(3)
	assert_int(Nes.get_word(pc)).is_equal(0x5678)


func test_BVS() -> void:
	Nes.memory[0] = 0x34
	Nes.memory[1] = 0x12
	Nes.memory[3] = 0x78
	Nes.memory[4] = 0x56
	
	Nes.registers[Consts.CPU_Registers.PC] = 2
	Nes.set_status_flag(Consts.StatusFlags.Overflow, 0)
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 0)
	Opcodes.BVS(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.PC]).is_equal(2)
	
	Nes.set_status_flag(Consts.StatusFlags.Overflow, 1)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, -2)
	Opcodes.BVS(context)
	
	var pc = Nes.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0)
	assert_int(Nes.get_word(pc)).is_equal(0x1234)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 3)
	Opcodes.BVS(context)
	
	pc = Nes.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(3)
	assert_int(Nes.get_word(pc)).is_equal(0x5678)


func test_TAX() -> void:
	Nes.registers[Consts.CPU_Registers.A] = 1
	Nes.registers[Consts.CPU_Registers.X] = 2
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(1)
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(2)
	
	Opcodes.TAX(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(1)
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(1)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 0
	Opcodes.TAX(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0)
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(0)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 0xFF
	Opcodes.TAX(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0xFF)
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(0xFF)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_TXA() -> void:
	Nes.registers[Consts.CPU_Registers.X] = 1
	Nes.registers[Consts.CPU_Registers.A] = 2
	
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(1)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(2)
	
	Opcodes.TXA(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(1)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(1)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.X] = 0
	Opcodes.TXA(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(0)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.X] = 0xFF
	Opcodes.TXA(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(0xFF)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0xFF)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_TAY() -> void:
	Nes.registers[Consts.CPU_Registers.A] = 1
	Nes.registers[Consts.CPU_Registers.Y] = 2
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(1)
	assert_int(Nes.registers[Consts.CPU_Registers.Y]).is_equal(2)
	
	Opcodes.TAY(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(1)
	assert_int(Nes.registers[Consts.CPU_Registers.Y]).is_equal(1)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 0
	Opcodes.TAY(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0)
	assert_int(Nes.registers[Consts.CPU_Registers.Y]).is_equal(0)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 0xFF
	Opcodes.TAY(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0xFF)
	assert_int(Nes.registers[Consts.CPU_Registers.Y]).is_equal(0xFF)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_TYA() -> void:
	Nes.registers[Consts.CPU_Registers.Y] = 1
	Nes.registers[Consts.CPU_Registers.A] = 2
	
	assert_int(Nes.registers[Consts.CPU_Registers.Y]).is_equal(1)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(2)
	
	Opcodes.TYA(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.Y]).is_equal(1)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(1)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.Y] = 0
	Opcodes.TYA(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.Y]).is_equal(0)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.Y] = 0xFF
	Opcodes.TYA(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.Y]).is_equal(0xFF)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0xFF)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_TSX() -> void:
	Nes.registers[Consts.CPU_Registers.SP] = 1
	Nes.registers[Consts.CPU_Registers.X] = 2
	
	assert_int(Nes.registers[Consts.CPU_Registers.SP]).is_equal(1)
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(2)
	
	Opcodes.TSX(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.SP]).is_equal(1)
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(1)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.SP] = 0
	Opcodes.TSX(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.SP]).is_equal(0)
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(0)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.SP] = 0xFF
	Opcodes.TSX(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.SP]).is_equal(0xFF)
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(0xFF)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_TXS() -> void:
	Nes.registers[Consts.CPU_Registers.X] = 1
	Nes.registers[Consts.CPU_Registers.SP] = 2
	
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(1)
	assert_int(Nes.registers[Consts.CPU_Registers.SP]).is_equal(2)
	
	Opcodes.TXS(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(1)
	assert_int(Nes.registers[Consts.CPU_Registers.SP]).is_equal(1)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.X] = 0
	Opcodes.TXS(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(0)
	assert_int(Nes.registers[Consts.CPU_Registers.SP]).is_equal(0)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.X] = 0xFF
	Opcodes.TXS(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.X]).is_equal(0xFF)
	assert_int(Nes.registers[Consts.CPU_Registers.SP]).is_equal(0xFF)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()


func test_PHA() -> void:
	Nes.registers[Consts.CPU_Registers.A] = 0x0F
	
	assert_int(Nes.registers[Consts.CPU_Registers.SP]).is_equal(0xFD)
	
	Opcodes.PHA(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.SP]).is_equal(0xFC)
	assert_int(Nes.memory[0x0100 + Nes.registers[Consts.CPU_Registers.SP] + 1]).is_equal(0x0F)


func test_PLA() -> void:
	Nes.memory[0x0100 + Nes.registers[Consts.CPU_Registers.SP]] = 0x0F
	Nes.registers[Consts.CPU_Registers.SP] = 0xFC
	
	Opcodes.PLA(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(0x0F)
	assert_int(Nes.registers[Consts.CPU_Registers.SP]).is_equal(0xFD)


func test_PHP() -> void:
	Nes.set_status_flag(Consts.StatusFlags.Carry, true)
	Nes.set_status_flag(Consts.StatusFlags.Negative, true)
	
	assert_int(Nes.registers[Consts.CPU_Registers.SP]).is_equal(0xFD)
	
	Opcodes.PHP(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.SP]).is_equal(0xFC)
	assert_int(Nes.memory[0x0100 + Nes.registers[Consts.CPU_Registers.SP] + 1]).is_equal(0b10110101)


func test_PLP() -> void:
	Nes.memory[0x0100 + Nes.registers[Consts.CPU_Registers.SP]] = 0b10110101
	Nes.registers[Consts.CPU_Registers.SP] = 0xFC
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Opcodes.PLP(null)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	assert_int(Nes.registers[Consts.CPU_Registers.SP]).is_equal(0xFD)


func test_JMP() -> void:
	Nes.memory[0x12] = 0x56
	Nes.memory[0x13] = 0x34
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x12)
	Opcodes.JMP(context)
	
	var pc = Nes.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0x12)
	assert_int(Nes.get_word(pc)).is_equal(0x3456)
	
	Nes.memory[0x2005] = 0x12
	Nes.memory[0x2006] = 0x20
	Nes.memory[0x2012] = 0x9A
	Nes.memory[0x2013] = 0x78
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Indirect, 0x2005)
	Opcodes.JMP(context)
	
	pc = Nes.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0x2012)
	assert_int(Nes.get_word(pc)).is_equal(0x789A)


func test_JSR() -> void:
	Nes.registers[Consts.CPU_Registers.PC] = 0x1234
	Nes.registers[Consts.CPU_Registers.SP] = 0xFD
	
	Nes.memory[0x12] = 0x56
	Nes.memory[0x13] = 0x34
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x12)
	Opcodes.JSR(context)
	
	var pc = Nes.registers[Consts.CPU_Registers.PC]
	assert_int(pc).is_equal(0x12)
	assert_int(Nes.get_word(pc)).is_equal(0x3456)
	
	assert_int(Nes.registers[Consts.CPU_Registers.SP]).is_equal(0xFB)
	
	assert_int(Nes.memory[0x01FD]).is_equal(0x34)
	assert_int(Nes.memory[0x01FC]).is_equal(0x12)


func test_RTS() -> void:
	Nes.registers[Consts.CPU_Registers.PC] = 0
	Nes.memory[0x01FD] = 0x34
	Nes.memory[0x01FC] = 0x12
	Nes.registers[Consts.CPU_Registers.SP] = 0xFB
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied, 0)
	Opcodes.RTS(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.PC]).is_equal(0x1234)
	assert_int(Nes.registers[Consts.CPU_Registers.SP]).is_equal(0xFD)


func test_RTI() -> void:
	Nes.registers[Consts.CPU_Registers.PC] = 0
	Nes.memory[0x01FD] = 0x34
	Nes.memory[0x01FC] = 0x12
	Nes.memory[0x01FB] = 0b10110101
	Nes.registers[Consts.CPU_Registers.SP] = 0xFA
	
	Nes.set_status_flag(Consts.StatusFlags.Carry, 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, 0)
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Implied, 0)
	Opcodes.RTI(context)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	
	assert_int(Nes.registers[Consts.CPU_Registers.PC]).is_equal(0x1234)
	assert_int(Nes.registers[Consts.CPU_Registers.SP]).is_equal(0xFD)


func test_CLC() -> void:
	Nes.set_status_flag(Consts.StatusFlags.Carry, 1)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	Opcodes.CLC(null)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_zero()


func test_SEC() -> void:
	Nes.set_status_flag(Consts.StatusFlags.Carry, 0)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	Opcodes.SEC(null)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()


func test_CLD() -> void:
	Nes.set_status_flag(Consts.StatusFlags.Decimal, 1)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Decimal)).is_not_zero()
	Opcodes.CLD(null)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Decimal)).is_zero()


func test_SED() -> void:
	Nes.set_status_flag(Consts.StatusFlags.Decimal, 0)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Decimal)).is_zero()
	Opcodes.SED(null)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Decimal)).is_not_zero()


func test_CLI() -> void:
	Nes.set_status_flag(Consts.StatusFlags.InterruptDisable, 1)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.InterruptDisable)).is_not_zero()
	Opcodes.CLI(null)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.InterruptDisable)).is_zero()


func test_SEI() -> void:
	Nes.set_status_flag(Consts.StatusFlags.InterruptDisable, 0)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.InterruptDisable)).is_zero()
	Opcodes.SEI(null)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.InterruptDisable)).is_not_zero()


func test_CLV() -> void:
	Nes.set_status_flag(Consts.StatusFlags.Overflow, 0)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	Opcodes.CLV(null)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Overflow)).is_not_zero()


func test_BRK() -> void:
	Nes.registers[Consts.CPU_Registers.PC] = 0x1234
	Nes.set_status_flag(Consts.StatusFlags.Carry, true)
	Nes.set_status_flag(Consts.StatusFlags.Negative, true)
	
	assert_int(Nes.registers[Consts.CPU_Registers.SP]).is_equal(0xFD)
	assert_int(Nes.registers[Consts.CPU_Registers.PC]).is_equal(0x1234)
	
	Opcodes.BRK(null)
	
	assert_int(Nes.registers[Consts.CPU_Registers.SP]).is_equal(0xFA)
	assert_int(Nes.registers[Consts.CPU_Registers.PC]).is_equal(0xFFFE)
	
	assert_int(Nes.memory[0x0100 + Nes.registers[Consts.CPU_Registers.SP] + 1]).is_equal(0b10110101)
	assert_int(Nes.memory[0x0100 + Nes.registers[Consts.CPU_Registers.SP] + 2]).is_equal(0x12)
	assert_int(Nes.memory[0x0100 + Nes.registers[Consts.CPU_Registers.SP] + 3]).is_equal(0x34)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.InterruptDisable)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.B_1)).is_not_zero()


func test_NOP() -> void:
	Opcodes.NOP(null)
