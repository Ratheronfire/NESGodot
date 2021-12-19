# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
class_name OpcodesTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://src/globals/Opcodes.gd'

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
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x34, 0x12)
	Opcodes.LDA(context)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(4)
	
	Nes.memory[0x1236] = 5
	Nes.registers[Consts.CPU_Registers.Y] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_Y, 0x34, 0x12)
	Opcodes.LDA(context)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(5)
	
	Nes.memory[0x1000] = 0x0A
	Nes.memory[0x1001] = 0x0B
	Nes.memory[0x0B0A] = 6
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Indirect, 0x00, 0x10)
	Opcodes.LDA(context)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(6)
	
	Nes.memory[0x09] = 7
	Nes.registers[Consts.CPU_Registers.X] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZPInd_X, 0x07)
	Opcodes.LDA(context)
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(7)
	
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
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x34, 0x12)
	Opcodes.STA(context)
	assert_int(Nes.memory[0x1234]).is_equal(4)
	
	Nes.registers[Consts.CPU_Registers.A] = 5
	Nes.registers[Consts.CPU_Registers.Y] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute_Y, 0x34, 0x12)
	Opcodes.LDA(context)
	assert_int(Nes.memory[0x1236]).is_equal(5)
	
	Nes.registers[Consts.CPU_Registers.A] = 7
	Nes.registers[Consts.CPU_Registers.X] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.ZPInd_X, 0x07)
	Opcodes.LDA(context)
	assert_int(Nes.memory[0x09]).is_equal(7)


func test_ADC() -> void:
	Nes.registers[Consts.CPU_Registers.A] = 1
	Nes.set_status_flag(Consts.StatusFlags.Carry, false)

	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Immediate, 1)
	Opcodes.ADC(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.A]).is_equal(2)
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Overflow)).is_zero()
	
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
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 1)
	Opcodes.CMP(context)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_not_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 2
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 0x03)
	Opcodes.CMP(context)
	
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Carry)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Zero)).is_zero()
	assert_int(Nes.get_status_flag(Consts.StatusFlags.Negative)).is_not_zero()
	
	Nes.registers[Consts.CPU_Registers.A] = 0xFF
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Accumulator, 0xFF)
	Opcodes.CMP(context)
	
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
	
	assert_int(Nes.registers[Consts.CPU_Registers.PC]).is_equal(0x1234)
	
	Nes.registers[Consts.CPU_Registers.PC] = 2
	Nes.set_status_flag(Consts.StatusFlags.Carry, 0)
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Relative, 1)
	Opcodes.BCC(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.PC]).is_equal(0x5678)


func test_JMP() -> void:
	Nes.memory[0x12] = 0x56
	Nes.memory[0x13] = 0x34
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x12, 0)
	Opcodes.JMP(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.PC]).is_equal(0x3456)
	
	Nes.memory[0x2005] = 0x12
	Nes.memory[0x2006] = 0x20
	Nes.memory[0x2012] = 0x9A
	Nes.memory[0x2013] = 0x78
	
	context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Indirect, 0x05, 0x20)
	Opcodes.JMP(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.PC]).is_equal(0x789A)


func test_JSR() -> void:
	Nes.registers[Consts.CPU_Registers.PC] = 0x1234
	Nes.registers[Consts.CPU_Registers.SP] = 0xFD
	
	Nes.memory[0x12] = 0x56
	Nes.memory[0x13] = 0x34
	
	var context = Opcodes.OperandAddressingContext.new(Consts.AddressingModes.Absolute, 0x12, 0)
	Opcodes.JSR(context)
	
	assert_int(Nes.registers[Consts.CPU_Registers.PC]).is_equal(0x3456)
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
