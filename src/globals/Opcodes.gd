extends Node


class OperandAddressingContext:
	var address_mode: int
	var value_low: int
	var value_high: int = -1
	
	func _init(address_mode: int, value_low, value_high = 0):
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
	Nes.set_status_flag(Consts.StatusFlags.Negative, value >= 0x80)


func LDX(context: OperandAddressingContext):
	var value = _read_value_from_memory(context)
	Nes.registers[Consts.CPU_Registers.X] = value
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, value == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, value >= 0x80)


func LDY(context: OperandAddressingContext):
	var value = _read_value_from_memory(context)
	Nes.registers[Consts.CPU_Registers.Y] = value
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, value == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, value >= 0x80)


func STA(context: OperandAddressingContext):
	_write_value_to_memory(context, Nes.registers[Consts.CPU_Registers.A])


func STX(context: OperandAddressingContext):
	_write_value_to_memory(context, Nes.registers[Consts.CPU_Registers.X])


func STY(context: OperandAddressingContext):
	_write_value_to_memory(context, Nes.registers[Consts.CPU_Registers.Y])


func ADC(context: OperandAddressingContext):
	var a = Nes.registers[Consts.CPU_Registers.A]
	
	if Nes.get_status_flag(Consts.StatusFlags.Carry):
		a += 1
		Nes.set_status_flag(Consts.StatusFlags.Carry, false)
	
	a += context.value_low
	
	Nes.set_status_flag(Consts.StatusFlags.Overflow, a >= 0xFF)
	a &= 0xFF
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, a == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, a >= 0x80)
	Nes.registers[Consts.CPU_Registers.A] = a


func SBC(context: OperandAddressingContext):
	var a = Nes.registers[Consts.CPU_Registers.A]
	
	if not Nes.get_status_flag(Consts.StatusFlags.Carry):
		a -= 1
		Nes.set_status_flag(Consts.StatusFlags.Carry, true)
	
	a -= context.value_low
	if a < 0:
		a = 0x100 + a
	
	Nes.set_status_flag(Consts.StatusFlags.Overflow, a >= 0xFF)
	a &= 0xFF
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, a == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, a >= 0x80)
	
	Nes.registers[Consts.CPU_Registers.A] = a


func INC(context: OperandAddressingContext):
	var a = Nes.registers[Consts.CPU_Registers.A]
	
	a += 1
	
	Nes.set_status_flag(Consts.StatusFlags.Overflow, a >= 0xFF)
	a &= 0xFF
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, a == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, a >= 0x80)
	Nes.registers[Consts.CPU_Registers.A] = a


func INX(context: OperandAddressingContext):
	var x = Nes.registers[Consts.CPU_Registers.X]
	
	x += 1
	
	Nes.set_status_flag(Consts.StatusFlags.Overflow, x >= 0xFF)
	x &= 0xFF
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, x == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, x >= 0x80)
	Nes.registers[Consts.CPU_Registers.X] = x


func INY(context: OperandAddressingContext):
	var y = Nes.registers[Consts.CPU_Registers.Y]
	
	y += 1
	
	Nes.set_status_flag(Consts.StatusFlags.Overflow, y >= 0xFF)
	y &= 0xFF
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, y == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, y >= 0x80)
	Nes.registers[Consts.CPU_Registers.Y] = y


func DEC(context: OperandAddressingContext):
	var a = Nes.registers[Consts.CPU_Registers.A]
	
	a -= 1
	if a < 0:
		a = 0x100 + a
	
	Nes.set_status_flag(Consts.StatusFlags.Overflow, a >= 0xFF)
	a &= 0xFF
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, a == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, a >= 0x80)
	
	Nes.registers[Consts.CPU_Registers.A] = a


func DEX(context: OperandAddressingContext):
	var x = Nes.registers[Consts.CPU_Registers.X]
	
	x -= 1
	if x < 0:
		x = 0x100 + x
	
	Nes.set_status_flag(Consts.StatusFlags.Overflow, x >= 0xFF)
	x &= 0xFF
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, x == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, x >= 0x80)
	
	Nes.registers[Consts.CPU_Registers.X] = x


func DEY(context: OperandAddressingContext):
	var y = Nes.registers[Consts.CPU_Registers.Y]
	
	y -= 1
	if y < 0:
		y = 0x100 + y
	
	Nes.set_status_flag(Consts.StatusFlags.Overflow, y >= 0xFF)
	y &= 0xFF
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, y == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, y >= 0x80)
	
	Nes.registers[Consts.CPU_Registers.Y] = y


func ASL(context: OperandAddressingContext):
	var value = _read_value_from_memory(context)
	
	var shifted_value = (value << 1) & 0xFF
	
	var c = Nes.get_status_flag(Consts.StatusFlags.Carry)
	Nes.set_status_flag(Consts.StatusFlags.Carry, c | (value & 0x80))
	Nes.set_status_flag(Consts.StatusFlags.Zero, shifted_value == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, shifted_value >= 0x80)
	
	_write_value_to_memory(context, shifted_value)


func LSR(context: OperandAddressingContext):
	var value = _read_value_from_memory(context)
	
	var shifted_value = (value >> 1) & 0xFF
	
	var c = Nes.get_status_flag(Consts.StatusFlags.Carry)
	Nes.set_status_flag(Consts.StatusFlags.Carry, c | (value & 0x01))
	Nes.set_status_flag(Consts.StatusFlags.Zero, shifted_value == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, shifted_value >= 0x80)
	
	_write_value_to_memory(context, shifted_value)


func ROL(context: OperandAddressingContext):
	var value = _read_value_from_memory(context)
	
	var shifted_value = (value << 1) & 0xFF
	if Nes.get_status_flag(Consts.StatusFlags.Carry) > 0:
		shifted_value |= 0x01
		Nes.set_status_flag(Consts.StatusFlags.Carry, false)
	
	var c = Nes.get_status_flag(Consts.StatusFlags.Carry)
	Nes.set_status_flag(Consts.StatusFlags.Carry, c | (value & 0x80))
	Nes.set_status_flag(Consts.StatusFlags.Zero, shifted_value == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, shifted_value >= 0x80)
	
	_write_value_to_memory(context, shifted_value)


func ROR(context: OperandAddressingContext):
	var value = _read_value_from_memory(context)
	
	var shifted_value = (value >> 1) & 0xFF
	if Nes.get_status_flag(Consts.StatusFlags.Carry) > 0:
		shifted_value |= 0x80
		Nes.set_status_flag(Consts.StatusFlags.Carry, false)
	
	var c = Nes.get_status_flag(Consts.StatusFlags.Carry)
	Nes.set_status_flag(Consts.StatusFlags.Carry, c | (value & 0x01))
	Nes.set_status_flag(Consts.StatusFlags.Zero, shifted_value == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, shifted_value >= 0x80)
	
	_write_value_to_memory(context, shifted_value)


func AND(context: OperandAddressingContext):
	var a = Nes.registers[Consts.CPU_Registers.A]
	
	a &= context.value_low
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, a == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, a >= 0x80)
	Nes.registers[Consts.CPU_Registers.A] = a


func ORA(context: OperandAddressingContext):
	var a = Nes.registers[Consts.CPU_Registers.A]
	
	a |= context.value_low
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, a == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, a >= 0x80)
	Nes.registers[Consts.CPU_Registers.A] = a


func EOR(context: OperandAddressingContext):
	var a = Nes.registers[Consts.CPU_Registers.A]
	
	a ^= context.value_low
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, a == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, a >= 0x80)
	Nes.registers[Consts.CPU_Registers.A] = a


func CMP(context: OperandAddressingContext):
	var a = Nes.registers[Consts.CPU_Registers.A]
	
	Nes.set_status_flag(Consts.StatusFlags.Carry, a >= context.value_low)
	
	a -= context.value_low
	if a < 0:
		a = 0x100 + a
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, a == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, a >= 0x80)


func CPX(context: OperandAddressingContext):
	var x = Nes.registers[Consts.CPU_Registers.X]
	
	Nes.set_status_flag(Consts.StatusFlags.Carry, x >= context.value_low)
	
	x -= context.value_low
	if x < 0:
		x = 0x100 + x
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, x == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, x >= 0x80)


func CPY(context: OperandAddressingContext):
	var y = Nes.registers[Consts.CPU_Registers.Y]
	
	Nes.set_status_flag(Consts.StatusFlags.Carry, y >= context.value_low)
	
	y -= context.value_low
	if y < 0:
		y = 0x100 + y
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, y == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, y >= 0x80)


func BIT(context: OperandAddressingContext):
	var a = Nes.registers[Consts.CPU_Registers.A]
	var value = _read_value_from_memory(context)
	
	Nes.set_status_flag(Consts.StatusFlags.Zero, a & value == 0)
	Nes.set_status_flag(Consts.StatusFlags.Negative, value & 0x80 > 0)
	Nes.set_status_flag(Consts.StatusFlags.Overflow, value & 0x40 > 0)


func BCC(context: OperandAddressingContext):
	if context.address_mode != Consts.AddressingModes.Relative:
		assert(false, "Invalid addressing method for branch.")
	
	if Nes.get_status_flag(Consts.StatusFlags.Carry):
		return
	
	var address = _read_value_from_memory(context, Consts.CPU_Registers.A, true)
	Nes.registers[Consts.CPU_Registers.PC] = address


func BCS(context: OperandAddressingContext):
	if context.address_mode != Consts.AddressingModes.Relative:
		assert(false, "Invalid addressing method for branch.")
	
	if not Nes.get_status_flag(Consts.StatusFlags.Carry):
		return
	
	var address = _read_value_from_memory(context, Consts.CPU_Registers.A, true)
	Nes.registers[Consts.CPU_Registers.PC] = address


func BNE(context: OperandAddressingContext):
	if context.address_mode != Consts.AddressingModes.Relative:
		assert(false, "Invalid addressing method for branch.")
	
	if not Nes.get_status_flag(Consts.StatusFlags.Zero):
		return
	
	var address = _read_value_from_memory(context, Consts.CPU_Registers.A, true)
	Nes.registers[Consts.CPU_Registers.PC] = address


func BEQ(context: OperandAddressingContext):
	if context.address_mode != Consts.AddressingModes.Relative:
		assert(false, "Invalid addressing method for branch.")
	
	if Nes.get_status_flag(Consts.StatusFlags.Zero):
		return
	
	var address = _read_value_from_memory(context, Consts.CPU_Registers.A, true)
	Nes.registers[Consts.CPU_Registers.PC] = address


func BPL(context: OperandAddressingContext):
	if context.address_mode != Consts.AddressingModes.Relative:
		assert(false, "Invalid addressing method for branch.")
	
	if Nes.get_status_flag(Consts.StatusFlags.Negative):
		return
	
	var address = _read_value_from_memory(context, Consts.CPU_Registers.A, true)
	Nes.registers[Consts.CPU_Registers.PC] = address


func BMI(context: OperandAddressingContext):
	if context.address_mode != Consts.AddressingModes.Relative:
		assert(false, "Invalid addressing method for branch.")
	
	if not Nes.get_status_flag(Consts.StatusFlags.Negative):
		return
	
	var address = _read_value_from_memory(context, Consts.CPU_Registers.A, true)
	Nes.registers[Consts.CPU_Registers.PC] = address


func BVC(context: OperandAddressingContext):
	if context.address_mode != Consts.AddressingModes.Relative:
		assert(false, "Invalid addressing method for branch.")
	
	if not Nes.get_status_flag(Consts.StatusFlags.Overflow):
		return
	
	var address = _read_value_from_memory(context, Consts.CPU_Registers.A, true)
	Nes.registers[Consts.CPU_Registers.PC] = address


func BVS(context: OperandAddressingContext):
	if context.address_mode != Consts.AddressingModes.Relative:
		assert(false, "Invalid addressing method for branch.")
	
	if Nes.get_status_flag(Consts.StatusFlags.Overflow):
		return
	
	var address = _read_value_from_memory(context, Consts.CPU_Registers.A, true)
	Nes.registers[Consts.CPU_Registers.PC] = address


func TAX(context: OperandAddressingContext):
	_transfer(Consts.CPU_Registers.A, Consts.CPU_Registers.X)


func TXA(context: OperandAddressingContext):
	_transfer(Consts.CPU_Registers.X, Consts.CPU_Registers.A)


func TAY(context: OperandAddressingContext):
	_transfer(Consts.CPU_Registers.A, Consts.CPU_Registers.Y)


func TYA(context: OperandAddressingContext):
	_transfer(Consts.CPU_Registers.Y, Consts.CPU_Registers.A)


func TSX(context: OperandAddressingContext):
	_transfer(Consts.CPU_Registers.SR, Consts.CPU_Registers.X)


func TXS(context: OperandAddressingContext):
	_transfer(Consts.CPU_Registers.X, Consts.CPU_Registers.SR)


func PHA(context: OperandAddressingContext):
	_push_to_stack(Nes.registers[Consts.CPU_Registers.A])


func PLA(context: OperandAddressingContext):
	Nes.registers[Consts.CPU_Registers.A] = _pull_from_stack()


func PHP(context: OperandAddressingContext):
	_push_to_stack(Nes.registers[Consts.CPU_Registers.P])


func PLP(context: OperandAddressingContext):
	Nes.registers[Consts.CPU_Registers.P] = _pull_from_stack()


func JMP(context: OperandAddressingContext):
	if context.address_mode != Consts.AddressingModes.Absolute and context.address_mode != Consts.AddressingModes.Indirect:
		assert(false, "Invalid addressing method for jump.")
	
	var address = _read_value_from_memory(context, Consts.CPU_Registers.A, true)
	Nes.registers[Consts.CPU_Registers.PC] = address


func JSR(context: OperandAddressingContext):
	if context.address_mode != Consts.AddressingModes.Absolute:
		assert(false, "Invalid addressing method for jump.")
	
	var pc = Nes.registers[Consts.CPU_Registers.PC]
	_push_to_stack(pc & 0xFF)
	_push_to_stack(pc >> 8)
	
	var address = _read_value_from_memory(context, Consts.CPU_Registers.A, true)
	Nes.registers[Consts.CPU_Registers.PC] = address


func RTS(context: OperandAddressingContext):
	Nes.registers[Consts.CPU_Registers.PC] = (_pull_from_stack() << 8) + _pull_from_stack()


func RTI(context: OperandAddressingContext):
	Nes.registers[Consts.CPU_Registers.SR] = _pull_from_stack()
	Nes.registers[Consts.CPU_Registers.PC] = (_pull_from_stack() << 8) + _pull_from_stack()


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


func _push_to_stack(value):
	Nes.memory[0x0100 + Nes.registers[Consts.CPU_Registers.SP]] = value
	Nes.registers[Consts.CPU_Registers.SP] = Nes.registers[Consts.CPU_Registers.SP] - 1


func _pull_from_stack():
	Nes.registers[Consts.CPU_Registers.SP] = Nes.registers[Consts.CPU_Registers.SP] + 1
	return Nes.memory[0x0100 + Nes.registers[Consts.CPU_Registers.SP]]


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


func _read_value_from_memory(context: OperandAddressingContext, implied_register = Consts.CPU_Registers.A, reading_two_bytes = false):
	if context.address_mode == Consts.AddressingModes.Immediate:
		return context.value_low
	elif context.address_mode == Consts.AddressingModes.Accumulator:
		return Nes.registers[Consts.CPU_Registers.A]
	elif context.address_mode == Consts.AddressingModes.Implied:
		return Nes.registers[implied_register]
	else:
		var address = _determine_memory_address(context)
		
		if reading_two_bytes:
			return Nes.memory[address] + (Nes.memory[address + 1] << 8)
		
		return Nes.memory[address]


func _determine_memory_address(context: OperandAddressingContext):
	var address = context.value_low
	
	if context.address_mode in [Consts.AddressingModes.Absolute, Consts.AddressingModes.Absolute_X, Consts.AddressingModes.Absolute_Y, Consts.AddressingModes.Indirect]:
		address += context.value_high << 8
	
	if context.address_mode in [Consts.AddressingModes.Absolute_X, Consts.AddressingModes.ZPInd_X, Consts.AddressingModes.ZeroPage_X]:
		address += Nes.registers[Consts.CPU_Registers.X]
	
	if context.address_mode in [Consts.AddressingModes.Absolute_Y, Consts.AddressingModes.ZPInd_Y, Consts.AddressingModes.ZeroPage_Y]:
		address += Nes.registers[Consts.CPU_Registers.Y]
	
	if context.address_mode == Consts.AddressingModes.Relative:
		assert(context.value_low >= -128 and context.value_low <= 127)
		address = Nes.registers[Consts.CPU_Registers.PC] + context.value_low
	
	if context.address_mode == Consts.AddressingModes.Indirect:
		address = Nes.memory[address] + (Nes.memory[address + 1] << 8)
	
	return address
