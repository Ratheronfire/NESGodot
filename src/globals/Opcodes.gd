extends Node

enum AddressingModes {
	Implied,
	Immediate,
	Absolute,
	ZeroPage,
	Relative,
	Indirect,
	ZPInd_X,
	ZPInd_Y
}


class OperandAddressingContext:
	var address_mode: int
	var index_by: int
	var value: int
	
	func _init(value, address_mode: int, index_by: int = Nes.CPU_Registers.A):
		if value is String:
			value = Helpers.hex_string_to_decimal(value)
		self.value = value
		
		self.address_mode = address_mode
		self.index_by = index_by


func LDA(operand: String):
	var context = _determine_addressing_context(operand)
	var value = _read_value_from_memory(context.address_mode, context.value, context.index_by)
	Nes.registers[Nes.CPU_Registers.A] = value
	
	Nes.set_status_flag(Nes.StatusFlags.Zero, value == 0)
	Nes.set_status_flag(Nes.StatusFlags.Negative, value >= 128)


func LDX(operand: String):
	var context = _determine_addressing_context(operand)
	var value = _read_value_from_memory(context.address_mode, context.value, context.index_by)
	Nes.registers[Nes.CPU_Registers.X] = value
	
	Nes.set_status_flag(Nes.StatusFlags.Zero, value == 0)
	Nes.set_status_flag(Nes.StatusFlags.Negative, value >= 128)


func LDY(operand: String):
	var context = _determine_addressing_context(operand)
	var value = _read_value_from_memory(context.address_mode, context.value, context.index_by)
	Nes.registers[Nes.CPU_Registers.Y] = value
	
	Nes.set_status_flag(Nes.StatusFlags.Zero, value == 0)
	Nes.set_status_flag(Nes.StatusFlags.Negative, value >= 128)


func STA(operand: String):
	var context = _determine_addressing_context(operand)
	_write_value_to_memory(context.address_mode, Nes.registers[Nes.CPU_Registers.A], context.value, context.index_by)


func STX(operand: String):
	var context = _determine_addressing_context(operand)
	_write_value_to_memory(context.address_mode, Nes.registers[Nes.CPU_Registers.X], context.value, context.index_by)


func STY(operand: String):
	var context = _determine_addressing_context(operand)
	_write_value_to_memory(context.address_mode, Nes.registers[Nes.CPU_Registers.Y], context.value, context.index_by)


func ADC():
	print("Opcode not implemented.")
	assert(false)


func SBC():
	print("Opcode not implemented.")
	assert(false)


func INC():
	print("Opcode not implemented.")
	assert(false)


func INX():
	print("Opcode not implemented.")
	assert(false)


func INY():
	print("Opcode not implemented.")
	assert(false)


func DEC():
	print("Opcode not implemented.")
	assert(false)


func DEX():
	print("Opcode not implemented.")
	assert(false)


func DEY():
	print("Opcode not implemented.")
	assert(false)


func ASL(operand: String):
	var context = _determine_addressing_context(operand)
	
	var shifted_value = context.value << 1
	Nes.set_status_flag(Nes.StatusFlags.Carry, context.value & 0x80)
	Nes.set_status_flag(Nes.StatusFlags.Zero, shifted_value == 0)
	Nes.set_status_flag(Nes.StatusFlags.Negative, shifted_value >= 128)
	
	if context.address_mode == AddressingModes.Implied:
		Nes.registers[Nes.CPU_Registers.A] = shifted_value
	else:
		_write_value_to_memory(context.address_mode, context.value, context.index_by)


func LSR():
	print("Opcode not implemented.")
	assert(false)


func ROL():
	print("Opcode not implemented.")
	assert(false)


func ROR():
	print("Opcode not implemented.")
	assert(false)


func AND():
	print("Opcode not implemented.")
	assert(false)


func ORA():
	print("Opcode not implemented.")
	assert(false)


func EOR():
	print("Opcode not implemented.")
	assert(false)


func CMP():
	print("Opcode not implemented.")
	assert(false)


func CPX():
	print("Opcode not implemented.")
	assert(false)


func CPY():
	print("Opcode not implemented.")
	assert(false)


func BIT():
	print("Opcode not implemented.")
	assert(false)


func BCC():
	print("Opcode not implemented.")
	assert(false)


func BCS():
	print("Opcode not implemented.")
	assert(false)


func BNE():
	print("Opcode not implemented.")
	assert(false)


func BEQ():
	print("Opcode not implemented.")
	assert(false)


func BPL():
	print("Opcode not implemented.")
	assert(false)


func BMI():
	print("Opcode not implemented.")
	assert(false)


func BVC():
	print("Opcode not implemented.")
	assert(false)


func BVS():
	print("Opcode not implemented.")
	assert(false)


func TAX():
	_transfer(Nes.CPU_Registers.A, Nes.CPU_Registers.X)


func TXA():
	_transfer(Nes.CPU_Registers.X, Nes.CPU_Registers.A)


func TAY():
	_transfer(Nes.CPU_Registers.A, Nes.CPU_Registers.Y)


func TYA():
	_transfer(Nes.CPU_Registers.Y, Nes.CPU_Registers.A)


func TSX():
	_transfer(Nes.CPU_Registers.S, Nes.CPU_Registers.X)


func TXS():
	_transfer(Nes.CPU_Registers.X, Nes.CPU_Registers.S)


func PHA():
	print("Opcode not implemented.")
	assert(false)


func PLA():
	print("Opcode not implemented.")
	assert(false)


func PHP():
	print("Opcode not implemented.")
	assert(false)


func PLP():
	print("Opcode not implemented.")
	assert(false)


func JMP():
	print("Opcode not implemented.")
	assert(false)


func JSR():
	print("Opcode not implemented.")
	assert(false)


func RTS():
	print("Opcode not implemented.")
	assert(false)


func RTI():
	print("Opcode not implemented.")
	assert(false)


func CLC():
	print("Opcode not implemented.")
	assert(false)


func SEC():
	print("Opcode not implemented.")
	assert(false)


func CLD():
	print("Opcode not implemented.")
	assert(false)


func SED():
	print("Opcode not implemented.")
	assert(false)


func CLI():
	print("Opcode not implemented.")
	assert(false)


func SEI():
	print("Opcode not implemented.")
	assert(false)


func CLV():
	print("Opcode not implemented.")
	assert(false)


func BRK():
	print("Opcode not implemented.")
	assert(false)


func NOP():
	pass


func _determine_addressing_context(operand: String) -> OperandAddressingContext:
	var regex = RegEx.new()
	var result: RegExMatch
	
	if operand == "A":
		return OperandAddressingContext.new(Nes.registers[Nes.CPU_Registers.A], AddressingModes.Implied)
	
	regex.compile("#\\$([0-9A-Fa-f]+)")
	result = regex.search(operand)
	if result:
		return OperandAddressingContext.new(result.get_string(1), AddressingModes.Immediate)
	
	regex.compile("\\$([0-9A-Fa-f]{4})")
	result = regex.search(operand)
	if result:
		return OperandAddressingContext.new(result.get_string(1), AddressingModes.Absolute)
	
	regex.compile("\\$()[0-9A-Fa-f]{4}),(X|Y)")
	result = regex.search(operand)
	if result:
		var index_char = result.get_string(2)
		var index_by = Nes.CPU_Registers.X if index_char == "X" else Nes.CPU_Registers.Y
		return OperandAddressingContext.new(result.get_string(1), AddressingModes.Absolute, index_by)
	
	regex.compile("\\$([0-9A-Fa-f]{4})")
	result = regex.search(operand)
	if result:
		return OperandAddressingContext.new(result.get_string(1), AddressingModes.ZeroPage)
	
	regex.compile("\\$([0-9A-Fa-f]{4})")
	result = regex.search(operand)
	if result:
		return OperandAddressingContext.new(result.get_string(1), AddressingModes.Indirect)
	
	regex.compile("\\$([0-9A-Fa-f]{2}),(X|Y)")
	result = regex.search(operand)
	if result:
		var index_char = result.get_string(2)
		var index_by = Nes.CPU_Registers.X if index_char == "X" else Nes.CPU_Registers.Y
		return OperandAddressingContext.new(result.get_string(1), AddressingModes.ZeroPage, index_by)
	
	regex.compile("\\(\\$([0-9A-Fa-f]{2}),X\\)")
	result = regex.search(operand)
	if result:
		return OperandAddressingContext.new(result.get_string(1), AddressingModes.ZPInd_X)
	
	regex.compile("\\(\\$([0-9A-Fa-f]{2})\\),Y")
	result = regex.search(operand)
	if result:
		return OperandAddressingContext.new(result.get_string(1), AddressingModes.ZPInd_Y)
	
	print_debug("Unable to determine addressing mode. Operand: %s" % operand)
	return null


func _transfer(from_register: int, to_register: int):
	Nes.registers[to_register] = Nes.registers[from_register]


func _load(to_register: int, addressing_mode: int, value: int, index_by: int = Nes.CPU_Registers.A):
	Nes.registers[to_register] = _read_value_from_memory(addressing_mode, value, index_by)


func _write_value_to_memory(addressing_mode: int, value: int, address = -1, index_by: int = Nes.CPU_Registers.A):
	if addressing_mode == AddressingModes.Immediate:
		Nes.memory[address] = value
	elif addressing_mode == AddressingModes.Absolute or addressing_mode == AddressingModes.ZeroPage:
		if index_by == Nes.CPU_Registers.X:
			address += Nes.registers[Nes.CPU_Registers.X]
		if index_by == Nes.CPU_Registers.Y:
			address += Nes.registers[Nes.CPU_Registers.Y]
		
		Nes.memory[address] = value
	elif addressing_mode == AddressingModes.Relative:
		assert(value >= -128 and value <= 127)
		
		var pc = Nes.registers[Nes.CPU_Registers.PC]
		Nes.memory[pc + address] = value
	elif addressing_mode == AddressingModes.Indirect:
		var ram_value = Nes.memory[address]
		
		Nes.memory[ram_value] = value
	else:
		print_debug("Addressing mode not implemented.")


func _read_value_from_memory(addressing_mode: int, value_or_addr: int, index_by: int = Nes.CPU_Registers.A):
	if addressing_mode == AddressingModes.Immediate:
		return value_or_addr
	elif addressing_mode == AddressingModes.Absolute or addressing_mode == AddressingModes.ZeroPage:
		if index_by == Nes.CPU_Registers.X:
			value_or_addr += Nes.registers[Nes.CPU_Registers.X]
		if index_by == Nes.CPU_Registers.Y:
			value_or_addr += Nes.registers[Nes.CPU_Registers.Y]
		
		return Nes.memory[value_or_addr]
	elif addressing_mode == AddressingModes.Relative:
		assert(value_or_addr >= -128 and value_or_addr <= 127)
		
		var pc = Nes.registers[Nes.CPU_Registers.PC]
		return Nes.memory[pc + value_or_addr]
	elif addressing_mode == AddressingModes.Indirect:
		var ram_value = Nes.memory[value_or_addr]
		
		return Nes.memory[ram_value]
	else:
		print_debug("Addressing mode not implemented.")
