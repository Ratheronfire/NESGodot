extends Node


class OperandAddressingContext:
	var address_mode: int
	var value_low: int
	var value_high: int = -1
	
	func _init(address_mode: int, value_low, value_high = -1):
		self.address_mode = address_mode
		
		if value_low is String:
			value_low = Helpers.hex_string_to_decimal(value_low)
		self.value_low = value_low
		if value_high is String:
			value_high = Helpers.hex_string_to_decimal(value_high)
		self.value_high = value_high


func LDA(context: OperandAddressingContext):
	var value = _read_value_from_memory(context)
	Nes.registers[Consts.CPU_Registers.A] = value
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, value == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, value >= 128)


func LDX(context: OperandAddressingContext):
	var value = _read_value_from_memory(context)
	Nes.registers[Consts.CPU_Registers.X] = value
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, value == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, value >= 128)


func LDY(context: OperandAddressingContext):
	var value = _read_value_from_memory(context)
	Nes.registers[Consts.CPU_Registers.Y] = value
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, value == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, value >= 128)


func STA(context: OperandAddressingContext):
	_write_value_to_memory(context, Nes.registers[Consts.CPU_Registers.A])


func STX(context: OperandAddressingContext):
	_write_value_to_memory(context, Nes.registers[Consts.CPU_Registers.X])


func STY(context: OperandAddressingContext):
	_write_value_to_memory(context, Nes.registers[Consts.CPU_Registers.Y])


func ADC(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func SBC(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func INC(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func INX(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func INY(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func DEC(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func DEX(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func DEY(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func ASL(context: OperandAddressingContext):
	var value = _read_value_from_memory(context)
	
	var shifted_value = (value << 1) & 0xFF
	Nes.set_status_flag(Consts.StatusFlags.Carry, value | 0x80)
	Nes.set_status_flag(Consts.StatusFlags.Zero, shifted_value == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, shifted_value >= 128)
	
	_write_value_to_memory(context, shifted_value)


func LSR(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func ROL(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func ROR(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func AND(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func ORA(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func EOR(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func CMP(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func CPX(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func CPY(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func BIT(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func BCC(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func BCS(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func BNE(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func BEQ(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func BPL(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func BMI(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func BVC(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func BVS(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func TAX(context: OperandAddressingContext):
	_transfer(Consts.CPU_Registers.A, Consts.CPU_Registers.X)


func TXA(context: OperandAddressingContext):
	_transfer(Consts.CPU_Registers.X, Consts.CPU_Registers.A)


func TAY(context: OperandAddressingContext):
	_transfer(Consts.CPU_Registers.A, Consts.CPU_Registers.Y)


func TYA(context: OperandAddressingContext):
	_transfer(Consts.CPU_Registers.Y, Consts.CPU_Registers.A)


func TSX(context: OperandAddressingContext):
	_transfer(Consts.CPU_Registers.S, Consts.CPU_Registers.X)


func TXS(context: OperandAddressingContext):
	_transfer(Consts.CPU_Registers.X, Consts.CPU_Registers.S)


func PHA(context: OperandAddressingContext):
	Nes.registers[Consts.CPU_Registers.S] = Nes.registers[Consts.CPU_Registers.S] + 1
	Nes.memory[Consts.Cpu.CPU_Registers.S] = Nes.registers[Consts.CPU_Registers.A]


func PLA(context: OperandAddressingContext):
	Nes.registers[Consts.CPU_Registers.A] = Nes.memory[Consts.Cpu.CPU_Registers.S]
	Nes.registers[Consts.CPU_Registers.S] = Nes.registers[Consts.CPU_Registers.S] - 1


func PHP(context: OperandAddressingContext):
	Nes.registers[Consts.CPU_Registers.S] = Nes.registers[Consts.CPU_Registers.S] + 1
	Nes.memory[Consts.Cpu.CPU_Registers.S] = Nes.registers[Consts.CPU_Registers.P]


func PLP(context: OperandAddressingContext):
	Nes.registers[Consts.CPU_Registers.P] = Nes.memory[Consts.Cpu.CPU_Registers.S]
	Nes.registers[Consts.CPU_Registers.S] = Nes.registers[Consts.CPU_Registers.S] - 1


func JMP(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func JSR(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func RTS(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func RTI(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func CLC(context: OperandAddressingContext):
	Nes.set_status_flag(Consts.StatusFlags.Carry, false)


func SEC(context: OperandAddressingContext):
	Nes.set_status_flag(Consts.StatusFlags.Carry, true)


func CLD(context: OperandAddressingContext):
	Nes.set_status_flag(Consts.StatusFlags.Decimal, false)


func SED(context: OperandAddressingContext):
	Nes.set_status_flag(Consts.StatusFlags.Decimal, true)


func CLI(context: OperandAddressingContext):
	Nes.set_status_flag(Consts.StatusFlags.InterruptDisable, false)


func SEI(context: OperandAddressingContext):
	Nes.set_status_flag(Consts.StatusFlags.InterruptDisable, true)


func CLV(context: OperandAddressingContext):
	Nes.set_status_flag(Consts.StatusFlags.Overflow, true)


func BRK(context: OperandAddressingContext):
	print("Opcode not implemented.")
	assert(false)


func NOP(context: OperandAddressingContext):
	pass


func determine_addressing_context(operand: String) -> OperandAddressingContext:
	var regex = RegEx.new()
	var result: RegExMatch
	
	if operand == "":
		return OperandAddressingContext.new(Consts.AddressingModes.Implied, Nes.registers[Consts.CPU_Registers.A])
	elif operand == "A":
		return OperandAddressingContext.new(Consts.AddressingModes.Accumulator, Nes.registers[Consts.CPU_Registers.A])
	
	regex.compile("#\\$([0-9A-Fa-f]+)")
	result = regex.search(operand)
	if result:
		return OperandAddressingContext.new(Consts.AddressingModes.Immediate, result.get_string(1))
	
	regex.compile("\\$([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})")
	result = regex.search(operand)
	if result:
		return OperandAddressingContext.new(Consts.AddressingModes.Absolute, result.get_string(2), result.get_string(1))
	
	regex.compile("\\$([0-9A-Fa-f]{2})([0-9A-Fa-f]{2}),(X|Y)")
	result = regex.search(operand)
	if result:
		var index_char = result.get_string(3)
		var address_mode = Consts.AddressingModes.Absolute_X if index_char == "X" else Consts.AddressingModes.Absolute_Y
		return OperandAddressingContext.new(address_mode, result.get_string(2), result.get_string(1))
	
	regex.compile("\\$([0-9A-Fa-f]{2})")
	result = regex.search(operand)
	if result:
		return OperandAddressingContext.new(Consts.AddressingModes.ZeroPage, result.get_string(1))
	
	regex.compile("\\(\\$([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})\\)")
	result = regex.search(operand)
	if result:
		return OperandAddressingContext.new(Consts.AddressingModes.Indirect, result.get_string(2), result.get_string(1))
	
	regex.compile("\\$([0-9A-Fa-f]{2}),(X|Y)")
	result = regex.search(operand)
	if result:
		var index_char = result.get_string(2)
		var address_mode = Consts.AddressingModes.Absolute_X if index_char == "X" else Consts.AddressingModes.Absolute_Y
		return OperandAddressingContext.new(address_mode, result.get_string(1))
	
	regex.compile("\\(\\$([0-9A-Fa-f]{2}),X\\)")
	result = regex.search(operand)
	if result:
		return OperandAddressingContext.new(Consts.AddressingModes.ZPInd_X, result.get_string(1))
	
	regex.compile("\\(\\$([0-9A-Fa-f]{2})\\),Y")
	result = regex.search(operand)
	if result:
		return OperandAddressingContext.new(Consts.AddressingModes.ZPInd_Y, result.get_string(1))
	
	print_debug("Unable to determine addressing mode. Operand: %s" % operand)
	return null


func _transfer(from_register: int, to_register: int):
	Nes.registers[to_register] = Nes.registers[from_register]


func _write_value_to_memory(context: OperandAddressingContext, value, implied_register = Consts.CPU_Registers.A):
	if context.address_mode == Consts.AddressingModes.Accumulator:
		Nes.registers[Consts.CPU_Registers.A] = value
	elif context.address_mode == Consts.AddressingModes.Implied:
		Nes.registers[implied_register] = value
	else:
		var address = _determine_memory_address(context)
		Nes.memory[address] = value


func _read_value_from_memory(context: OperandAddressingContext, implied_register = Consts.CPU_Registers.A):
	if context.address_mode == Consts.AddressingModes.Immediate:
		return context.value_low
	elif context.address_mode == Consts.AddressingModes.Accumulator:
		return Nes.registers[Consts.CPU_Registers.A]
	elif context.address_mode == Consts.AddressingModes.Implied:
		return Nes.registers[implied_register]
	else:
		var address = _determine_memory_address(context)
		return Nes.memory[address]


func _determine_memory_address(context: OperandAddressingContext):
	var address = context.value_low
	
	if context.address_mode in [Consts.AddressingModes.Absolute, Consts.AddressingModes.Absolute_X, Consts.AddressingModes.Absolute_Y, Consts.AddressingModes.Indirect]:
		address += context.value_high * 256
	
	if context.address_mode in [Consts.AddressingModes.Absolute_X, Consts.AddressingModes.ZPInd_X, Consts.AddressingModes.ZeroPage_X]:
		address += Nes.registers[Consts.CPU_Registers.X]
	
	if context.address_mode in [Consts.AddressingModes.Absolute_Y, Consts.AddressingModes.ZPInd_Y, Consts.AddressingModes.ZeroPage_Y]:
		address += Nes.registers[Consts.CPU_Registers.Y]
	
	if context.address_mode == Consts.AddressingModes.Relative:
		assert(context.value_low >= -128 and context.value_low <= 127)
		address = Nes.registers[Consts.CPU_Registers.PC] + context.value_low
	
	if context.address_mode == Consts.AddressingModes.Indirect:
		address = Nes.memory[address] * 16 + Nes.memory[address + 1]
	
	return address
