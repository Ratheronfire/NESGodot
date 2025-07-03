extends Node


class InstructionData:
	var opcode: int
	var context: OperandAddressingContext
	
	var instruction: String:
		get = get_instruction
	var bytes_to_read: int:
		get = get_bytes_to_read
	
	func _init(opcode: int, context: OperandAddressingContext):
		self.opcode = opcode
		self.context = context
	
	func get_instruction():
		return Consts.OPCODE_DATA[self.opcode]['instruction']
	
	func get_bytes_to_read():
		if not self.context:
			return -1
		
		return Consts.BYTES_PER_MODE[self.context.address_mode]
	
	func execute():
		var opcode_func = Callable(Opcodes, self.instruction)
		opcode_func.call(self.context)
	
	func _to_string():
		var operand_str = " $%02X" % context.value
		
		if context.address_mode in [Consts.AddressingModes.Accumulator, Consts.AddressingModes.Implied]:
			operand_str = ""
		elif context.address_mode == Consts.AddressingModes.Immediate:
			operand_str = " #$%02X" % context.value
		elif context.address_mode == Consts.AddressingModes.Absolute:
			operand_str = " #$%04X" % context.value
		elif context.address_mode == Consts.AddressingModes.Indirect:
			operand_str = " ($%04X)" % context.value
		elif context.address_mode == Consts.AddressingModes.Absolute_X:
			operand_str = " $%04X,X" % context.value
		elif context.address_mode == Consts.AddressingModes.Absolute_Y:
			operand_str = " $%04X,Y" % context.value
		elif context.address_mode == Consts.AddressingModes.ZeroPage_X:
			operand_str = " $%02X,X" % context.value
		elif context.address_mode == Consts.AddressingModes.ZeroPage_Y:
			operand_str = " $%02X,Y" % context.value
		elif context.address_mode == Consts.AddressingModes.ZPInd_X:
			operand_str = " ($%02X,X)" % context.value
		elif context.address_mode == Consts.AddressingModes.ZPInd_Y:
			operand_str = " ($%02X),Y" % context.value
		
		return self.instruction + operand_str


class OperandAddressingContext:
	var address_mode: int
	var value: int
	
	func _init(address_mode: int, value = 0, is_hex=true):
		self.address_mode = address_mode
		
		if value is String:
			value = value.replace('$', '')
			value = Helpers.hex_string_to_decimal(value) if is_hex else int(value)
		self.value = value


func LDA(context: OperandAddressingContext):
	var value = _read_value_from_memory(context)
	NES.cpu_memory.registers[Consts.CPU_Registers.A] = value
	
	NES.set_status_flag(Consts.StatusFlags.Zero, value == 0)
	NES.set_status_flag(Consts.StatusFlags.Negative, value >= 0x80)


func LDX(context: OperandAddressingContext):
	var value = _read_value_from_memory(context)
	NES.cpu_memory.registers[Consts.CPU_Registers.X] = value
	
	NES.set_status_flag(Consts.StatusFlags.Zero, value == 0)
	NES.set_status_flag(Consts.StatusFlags.Negative, value >= 0x80)


func LDY(context: OperandAddressingContext):
	var value = _read_value_from_memory(context)
	NES.cpu_memory.registers[Consts.CPU_Registers.Y] = value
	
	NES.set_status_flag(Consts.StatusFlags.Zero, value == 0)
	NES.set_status_flag(Consts.StatusFlags.Negative, value >= 0x80)


func STA(context: OperandAddressingContext):
	_write_value_to_memory(context, NES.cpu_memory.registers[Consts.CPU_Registers.A])


func STX(context: OperandAddressingContext):
	_write_value_to_memory(context, NES.cpu_memory.registers[Consts.CPU_Registers.X])


func STY(context: OperandAddressingContext):
	_write_value_to_memory(context, NES.cpu_memory.registers[Consts.CPU_Registers.Y])


func ADC(context: OperandAddressingContext):
	var a = NES.cpu_memory.registers[Consts.CPU_Registers.A]
	
	if NES.get_status_flag(Consts.StatusFlags.Carry):
		a += 1
		NES.set_status_flag(Consts.StatusFlags.Carry, false)
	
	a += _read_value_from_memory(context)
	
	NES.set_status_flag(Consts.StatusFlags.Overflow, a >= 0xFF)
	a &= 0xFF
	
	NES.set_status_flag(Consts.StatusFlags.Zero, a == 0)
	NES.set_status_flag(Consts.StatusFlags.Negative, a >= 0x80)
	NES.cpu_memory.registers[Consts.CPU_Registers.A] = a


func SBC(context: OperandAddressingContext):
	var a = NES.cpu_memory.registers[Consts.CPU_Registers.A]
	
	if not NES.get_status_flag(Consts.StatusFlags.Carry):
		a -= 1
		NES.set_status_flag(Consts.StatusFlags.Carry, true)
	
	a -= context.value
	if a < 0:
		a = 0x100 + a
	
	NES.set_status_flag(Consts.StatusFlags.Overflow, a >= 0xFF)
	a &= 0xFF
	
	NES.set_status_flag(Consts.StatusFlags.Zero, a == 0)
	NES.set_status_flag(Consts.StatusFlags.Negative, a >= 0x80)
	
	NES.cpu_memory.registers[Consts.CPU_Registers.A] = a


func INC(context: OperandAddressingContext):
	var value = _read_value_from_memory(context)
	var address = _determine_memory_address(context)
	
	value += 1
	
	value &= 0xFF
	
	NES.set_status_flag(Consts.StatusFlags.Zero, value == 0)
	NES.set_status_flag(Consts.StatusFlags.Negative, value >= 0x80)
	NES.cpu_memory.write_byte(address, value)


func INX(context: OperandAddressingContext):
	var x = NES.cpu_memory.registers[Consts.CPU_Registers.X]
	
	x += 1
	
	x &= 0xFF
	
	NES.set_status_flag(Consts.StatusFlags.Zero, x == 0)
	NES.set_status_flag(Consts.StatusFlags.Negative, x >= 0x80)
	NES.cpu_memory.registers[Consts.CPU_Registers.X] = x


func INY(context: OperandAddressingContext):
	var y = NES.cpu_memory.registers[Consts.CPU_Registers.Y]
	
	y += 1
	
	y &= 0xFF
	
	NES.set_status_flag(Consts.StatusFlags.Zero, y == 0)
	NES.set_status_flag(Consts.StatusFlags.Negative, y >= 0x80)
	NES.cpu_memory.registers[Consts.CPU_Registers.Y] = y


func DEC(context: OperandAddressingContext):
	var value = _read_value_from_memory(context)
	var address = _determine_memory_address(context)
	
	value -= 1
	if value < 0:
		value = 0x100 + value
	
	value &= 0xFF
	
	NES.set_status_flag(Consts.StatusFlags.Zero, value == 0)
	NES.set_status_flag(Consts.StatusFlags.Negative, value >= 0x80)
	NES.cpu_memory.write_byte(address, value)


func DEX(context: OperandAddressingContext):
	var x = NES.cpu_memory.registers[Consts.CPU_Registers.X]
	
	x -= 1
	if x < 0:
		x = 0x100 + x
	
	x &= 0xFF
	
	NES.set_status_flag(Consts.StatusFlags.Zero, x == 0)
	NES.set_status_flag(Consts.StatusFlags.Negative, x >= 0x80)
	
	NES.cpu_memory.registers[Consts.CPU_Registers.X] = x


func DEY(context: OperandAddressingContext):
	var y = NES.cpu_memory.registers[Consts.CPU_Registers.Y]
	
	y -= 1
	if y < 0:
		y = 0x100 + y
	
	y &= 0xFF
	
	NES.set_status_flag(Consts.StatusFlags.Zero, y == 0)
	NES.set_status_flag(Consts.StatusFlags.Negative, y >= 0x80)
	
	NES.cpu_memory.registers[Consts.CPU_Registers.Y] = y


func ASL(context: OperandAddressingContext):
	var value = _read_value_from_memory(context)
	
	var shifted_value = (value << 1) & 0xFF
	
	var c = NES.get_status_flag(Consts.StatusFlags.Carry)
	NES.set_status_flag(Consts.StatusFlags.Carry, c | (value & 0x80))
	NES.set_status_flag(Consts.StatusFlags.Zero, shifted_value == 0)
	NES.set_status_flag(Consts.StatusFlags.Negative, shifted_value >= 0x80)
	
	_write_value_to_memory(context, shifted_value)


func LSR(context: OperandAddressingContext):
	var value = _read_value_from_memory(context)
	
	var shifted_value = (value >> 1) & 0xFF
	
	var c = NES.get_status_flag(Consts.StatusFlags.Carry)
	NES.set_status_flag(Consts.StatusFlags.Carry, c | (value & 0x01))
	NES.set_status_flag(Consts.StatusFlags.Zero, shifted_value == 0)
	NES.set_status_flag(Consts.StatusFlags.Negative, shifted_value >= 0x80)
	
	_write_value_to_memory(context, shifted_value)


func ROL(context: OperandAddressingContext):
	var value = _read_value_from_memory(context)
	
	var shifted_value = (value << 1) & 0xFF
	if NES.get_status_flag(Consts.StatusFlags.Carry) > 0:
		shifted_value |= 0x01
		NES.set_status_flag(Consts.StatusFlags.Carry, false)
	
	var c = NES.get_status_flag(Consts.StatusFlags.Carry)
	NES.set_status_flag(Consts.StatusFlags.Carry, c | (value & 0x80))
	NES.set_status_flag(Consts.StatusFlags.Zero, shifted_value == 0)
	NES.set_status_flag(Consts.StatusFlags.Negative, shifted_value >= 0x80)
	
	_write_value_to_memory(context, shifted_value)


func ROR(context: OperandAddressingContext):
	var value = _read_value_from_memory(context)
	
	var shifted_value = (value >> 1) & 0xFF
	if NES.get_status_flag(Consts.StatusFlags.Carry) > 0:
		shifted_value |= 0x80
		NES.set_status_flag(Consts.StatusFlags.Carry, false)
	
	var c = NES.get_status_flag(Consts.StatusFlags.Carry)
	NES.set_status_flag(Consts.StatusFlags.Carry, c | (value & 0x01))
	NES.set_status_flag(Consts.StatusFlags.Zero, shifted_value == 0)
	NES.set_status_flag(Consts.StatusFlags.Negative, shifted_value >= 0x80)
	
	_write_value_to_memory(context, shifted_value)


func AND(context: OperandAddressingContext):
	var a = NES.cpu_memory.registers[Consts.CPU_Registers.A]
	
	a &= context.value
	
	NES.set_status_flag(Consts.StatusFlags.Zero, a == 0)
	NES.set_status_flag(Consts.StatusFlags.Negative, a >= 0x80)
	NES.cpu_memory.registers[Consts.CPU_Registers.A] = a


func ORA(context: OperandAddressingContext):
	var a = NES.cpu_memory.registers[Consts.CPU_Registers.A]
	
	a |= context.value
	
	NES.set_status_flag(Consts.StatusFlags.Zero, a == 0)
	NES.set_status_flag(Consts.StatusFlags.Negative, a >= 0x80)
	NES.cpu_memory.registers[Consts.CPU_Registers.A] = a


func EOR(context: OperandAddressingContext):
	var a = NES.cpu_memory.registers[Consts.CPU_Registers.A]
	
	a ^= context.value
	
	NES.set_status_flag(Consts.StatusFlags.Zero, a == 0)
	NES.set_status_flag(Consts.StatusFlags.Negative, a >= 0x80)
	NES.cpu_memory.registers[Consts.CPU_Registers.A] = a


func CMP(context: OperandAddressingContext):
	var a = NES.cpu_memory.registers[Consts.CPU_Registers.A]
	var value = _read_value_from_memory(context)
	
	NES.set_status_flag(Consts.StatusFlags.Carry, a >= value)
	NES.set_status_flag(Consts.StatusFlags.Zero, a == value)
	NES.set_status_flag(Consts.StatusFlags.Negative, a - value < 0)


func CPX(context: OperandAddressingContext):
	var x = NES.cpu_memory.registers[Consts.CPU_Registers.X]
	var value = _read_value_from_memory(context)
	
	NES.set_status_flag(Consts.StatusFlags.Carry, x >= value)
	NES.set_status_flag(Consts.StatusFlags.Zero, x == value)
	NES.set_status_flag(Consts.StatusFlags.Negative, x - value < 0)


func CPY(context: OperandAddressingContext):
	var y = NES.cpu_memory.registers[Consts.CPU_Registers.Y]
	var value = _read_value_from_memory(context)
	
	NES.set_status_flag(Consts.StatusFlags.Carry, y >= value)
	NES.set_status_flag(Consts.StatusFlags.Zero, y == value)
	NES.set_status_flag(Consts.StatusFlags.Negative, y - value < 0)


func BIT(context: OperandAddressingContext):
	var a = NES.cpu_memory.registers[Consts.CPU_Registers.A]
	var value = _read_value_from_memory(context)
	
	NES.set_status_flag(Consts.StatusFlags.Zero, a & value == 0)
	NES.set_status_flag(Consts.StatusFlags.Negative, value & 0x80 > 0)
	NES.set_status_flag(Consts.StatusFlags.Overflow, value & 0x40 > 0)


func BCC(context: OperandAddressingContext):
	if context.address_mode != Consts.AddressingModes.Relative:
		assert(false, "Invalid addressing method for branch.")
	
	if NES.get_status_flag(Consts.StatusFlags.Carry):
		return
	
	var address = _determine_memory_address(context)
	NES.cpu_memory.registers[Consts.CPU_Registers.PC] += address + 2


func BCS(context: OperandAddressingContext):
	if context.address_mode != Consts.AddressingModes.Relative:
		assert(false, "Invalid addressing method for branch.")
	
	if not NES.get_status_flag(Consts.StatusFlags.Carry):
		return
	
	var address = _determine_memory_address(context)
	NES.cpu_memory.registers[Consts.CPU_Registers.PC] += address + 2


func BNE(context: OperandAddressingContext):
	if context.address_mode != Consts.AddressingModes.Relative:
		assert(false, "Invalid addressing method for branch.")
	
	if NES.get_status_flag(Consts.StatusFlags.Zero):
		return
	
	var address = _determine_memory_address(context)
	
	if address != 0:
		NES.cpu_memory.registers[Consts.CPU_Registers.PC] += address + 2


func BEQ(context: OperandAddressingContext):
	if context.address_mode != Consts.AddressingModes.Relative:
		assert(false, "Invalid addressing method for branch.")
	
	if not NES.get_status_flag(Consts.StatusFlags.Zero):
		return
	
	var address = _determine_memory_address(context)
	
	if address != 0:
		NES.cpu_memory.registers[Consts.CPU_Registers.PC] += address + 2


func BPL(context: OperandAddressingContext):
	if context.address_mode != Consts.AddressingModes.Relative:
		assert(false, "Invalid addressing method for branch.")
	
	if NES.get_status_flag(Consts.StatusFlags.Negative):
		return
	
	var address = _determine_memory_address(context)
	
	if address != 0:
		NES.cpu_memory.registers[Consts.CPU_Registers.PC] += address + 2


func BMI(context: OperandAddressingContext):
	if context.address_mode != Consts.AddressingModes.Relative:
		assert(false, "Invalid addressing method for branch.")
	
	if not NES.get_status_flag(Consts.StatusFlags.Negative):
		return
	
	var address = _determine_memory_address(context)
	
	if address != 0:
		NES.cpu_memory.registers[Consts.CPU_Registers.PC] += address + 2


func BVC(context: OperandAddressingContext):
	if context.address_mode != Consts.AddressingModes.Relative:
		assert(false, "Invalid addressing method for branch.")
	
	if NES.get_status_flag(Consts.StatusFlags.Overflow):
		return
	
	var address = _determine_memory_address(context)
	
	if address != 0:
		NES.cpu_memory.registers[Consts.CPU_Registers.PC] += address + 2


func BVS(context: OperandAddressingContext):
	if context.address_mode != Consts.AddressingModes.Relative:
		assert(false, "Invalid addressing method for branch.")
	
	if not NES.get_status_flag(Consts.StatusFlags.Overflow):
		return
	
	var address = _determine_memory_address(context)
	
	if address != 0:
		NES.cpu_memory.registers[Consts.CPU_Registers.PC] += address + 2


func TAX(context: OperandAddressingContext):
	_transfer(Consts.CPU_Registers.A, Consts.CPU_Registers.X)


func TXA(context: OperandAddressingContext):
	_transfer(Consts.CPU_Registers.X, Consts.CPU_Registers.A)


func TAY(context: OperandAddressingContext):
	_transfer(Consts.CPU_Registers.A, Consts.CPU_Registers.Y)


func TYA(context: OperandAddressingContext):
	_transfer(Consts.CPU_Registers.Y, Consts.CPU_Registers.A)


func TSX(context: OperandAddressingContext):
	_transfer(Consts.CPU_Registers.SP, Consts.CPU_Registers.X)


func TXS(context: OperandAddressingContext):
	_transfer(Consts.CPU_Registers.X, Consts.CPU_Registers.SP)


func PHA(context: OperandAddressingContext):
	_push_to_stack(NES.cpu_memory.registers[Consts.CPU_Registers.A])


func PLA(context: OperandAddressingContext):
	NES.cpu_memory.registers[Consts.CPU_Registers.A] = _pull_from_stack()


func PHP(context: OperandAddressingContext):
	_push_to_stack(NES.cpu_memory.registers[Consts.CPU_Registers.P])
	
	var state_stack_addr = 0x0100 + NES.cpu_memory.registers[Consts.CPU_Registers.SP] + 1
	var state_flags = NES.cpu_memory.read_byte(state_stack_addr)
	NES.cpu_memory.write_byte(state_stack_addr, state_flags | 0x10)


func PLP(context: OperandAddressingContext):
	NES.cpu_memory.registers[Consts.CPU_Registers.P] = _pull_from_stack() & 0b11101111


func JMP(context: OperandAddressingContext):
	if context.address_mode != Consts.AddressingModes.Absolute and context.address_mode != Consts.AddressingModes.Indirect:
		assert(false, "Invalid addressing method for jump.")
	
	var address = context.value if context.address_mode == Consts.AddressingModes.Absolute else _determine_memory_address(context)
	NES.cpu_memory.registers[Consts.CPU_Registers.PC] = address
	# print("Jumped to $%02X" % NES.cpu_memory.registers[Consts.CPU_Registers.PC])


func JSR(context: OperandAddressingContext):
	if context.address_mode != Consts.AddressingModes.Absolute:
		assert(false, "Invalid addressing method for jump.")
	
	var pc = NES.cpu_memory.registers[Consts.CPU_Registers.PC]
	_push_to_stack(pc & 0xFF)
	_push_to_stack(pc >> 8)
	
	NES.cpu_memory.registers[Consts.CPU_Registers.PC] = context.value
	# print("Jumped to subroutine at $%02X" % NES.cpu_memory.registers[Consts.CPU_Registers.PC])


func RTS(context: OperandAddressingContext):
	NES.cpu_memory.registers[Consts.CPU_Registers.PC] = (_pull_from_stack() << 8) + _pull_from_stack() + 3
	# print("Returned to $%02X" % NES.cpu_memory.registers[Consts.CPU_Registers.PC])


func RTI(context: OperandAddressingContext):
	NES.cpu_memory.registers[Consts.CPU_Registers.P] = _pull_from_stack()
	NES.cpu_memory.registers[Consts.CPU_Registers.PC] = (_pull_from_stack() << 8) + _pull_from_stack()
	
	# NES.cpu_speed_multiplier = 0.0
	# print("Returned from interrupt to $%02X" % NES.cpu_memory.registers[Consts.CPU_Registers.PC])


func CLC(context: OperandAddressingContext):
	NES.set_status_flag(Consts.StatusFlags.Carry, false)


func SEC(context: OperandAddressingContext):
	NES.set_status_flag(Consts.StatusFlags.Carry, true)


func CLD(context: OperandAddressingContext):
	NES.set_status_flag(Consts.StatusFlags.Decimal, false)


func SED(context: OperandAddressingContext):
	NES.set_status_flag(Consts.StatusFlags.Decimal, true)


func CLI(context: OperandAddressingContext):
	NES.set_status_flag(Consts.StatusFlags.InterruptDisable, false)


func SEI(context: OperandAddressingContext):
	NES.set_status_flag(Consts.StatusFlags.InterruptDisable, true)


func CLV(context: OperandAddressingContext):
	NES.set_status_flag(Consts.StatusFlags.Overflow, true)


func BRK(context: OperandAddressingContext):
	var pc = NES.cpu_memory.registers[Consts.CPU_Registers.PC]
	_push_to_stack(pc & 0xFF)
	_push_to_stack(pc >> 8)
	
	NES.set_status_flag(Consts.StatusFlags.InterruptDisable, 1)
	
	_push_to_stack(NES.cpu_memory.registers[Consts.CPU_Registers.P])
	
	var state_stack_addr = 0x0100 + NES.cpu_memory.registers[Consts.CPU_Registers.SP] + 1
	var state_flags = NES.cpu_memory.read_byte(state_stack_addr)
	NES.cpu_memory.write_byte(state_stack_addr, state_flags | 0x10)
	
	NES.cpu_memory.registers[Consts.CPU_Registers.PC] = 0xFFFE


func NOP(context: OperandAddressingContext):
	pass


func determine_addressing_context(instruction: String, operand: String) -> OperandAddressingContext:
	var regex = RegEx.new()
	var result: RegExMatch
	
	var is_hex = "$" in operand
	
	if operand == "":
		return OperandAddressingContext.new(Consts.AddressingModes.Implied, NES.cpu_memory.registers[Consts.CPU_Registers.A])
	elif operand == "A":
		return OperandAddressingContext.new(Consts.AddressingModes.Accumulator, NES.cpu_memory.registers[Consts.CPU_Registers.A])
	
	if instruction in ["BCC", "BCS", "BNE", "BEQ", "BPL", "BMI", "BVC", "BVS"]:
		return OperandAddressingContext.new(Consts.AddressingModes.Relative, operand, is_hex)
	elif instruction == "JMP":
		regex.compile("\\(\\$?([0-9A-Fa-f]+)\\)")
		result = regex.search(operand)
		
		if result:
			return OperandAddressingContext.new(Consts.AddressingModes.Indirect, result.get_string(1), is_hex)
		else:
			return OperandAddressingContext.new(Consts.AddressingModes.Absolute, operand, is_hex)
	
	regex.compile("#\\$?([0-9A-Fa-f]+)")
	result = regex.search(operand)
	if result:
		return OperandAddressingContext.new(Consts.AddressingModes.Immediate, result.get_string(1), is_hex)
	
	regex.compile("\\$?([0-9A-Fa-f]+),(X|Y)")
	result = regex.search(operand)
	if result:
		var index_char = result.get_string(2)
		
		var str_value = result.get_string(1)
		var value = Helpers.hex_string_to_decimal(str_value) if is_hex else int(str_value)
		
		var address_mode
		if value > 0xFF:
			address_mode = Consts.AddressingModes.Absolute_X if index_char == "X" else Consts.AddressingModes.Absolute_Y
		else:
			address_mode = Consts.AddressingModes.ZeroPage_X if index_char == "X" else Consts.AddressingModes.ZeroPage_Y
		return OperandAddressingContext.new(address_mode, value, is_hex)
	
	regex.compile("\\$([0-9A-Fa-f]+)")
	result = regex.search(operand)
	if result:
		var str_value = result.get_string(1)
		var value = Helpers.hex_string_to_decimal(str_value) if is_hex else int(str_value)
		
		var address_mode = Consts.AddressingModes.Absolute if value > 0xFF else Consts.AddressingModes.ZeroPage
		
		return OperandAddressingContext.new(Consts.AddressingModes.Absolute, value, is_hex)
	
	regex.compile("\\(\\$?([0-9A-Fa-f]+)\\)")
	result = regex.search(operand)
	if result:
		return OperandAddressingContext.new(Consts.AddressingModes.Indirect, result.get_string(1), is_hex)
	
	regex.compile("\\(\\$?([0-9A-Fa-f]+),X\\)")
	result = regex.search(operand)
	if result:
		return OperandAddressingContext.new(Consts.AddressingModes.ZPInd_X, result.get_string(1), is_hex)
	
	regex.compile("\\(\\$?([0-9A-Fa-f]+)\\),Y")
	result = regex.search(operand)
	if result:
		return OperandAddressingContext.new(Consts.AddressingModes.ZPInd_Y, result.get_string(1), is_hex)
	
	print_debug("Unable to determine addressing mode. Operand: %s" % operand)
	return null


func _push_to_stack(value):
	NES.cpu_memory.write_byte(0x0100 + NES.cpu_memory.registers[Consts.CPU_Registers.SP], value)
	NES.cpu_memory.registers[Consts.CPU_Registers.SP] = NES.cpu_memory.registers[Consts.CPU_Registers.SP] - 1


func _pull_from_stack():
	NES.cpu_memory.registers[Consts.CPU_Registers.SP] = NES.cpu_memory.registers[Consts.CPU_Registers.SP] + 1
	return NES.cpu_memory.read_byte(0x0100 + NES.cpu_memory.registers[Consts.CPU_Registers.SP])


func _transfer(from_register: int, to_register: int):
	NES.cpu_memory.registers[to_register] = NES.cpu_memory.registers[from_register]
	
	NES.set_status_flag(Consts.StatusFlags.Zero, NES.cpu_memory.registers[from_register] == 0)
	NES.set_status_flag(Consts.StatusFlags.Negative, NES.cpu_memory.registers[from_register] >= 0x80)


func _write_value_to_memory(context: OperandAddressingContext, value, implied_register = Consts.CPU_Registers.A):
	if context.address_mode == Consts.AddressingModes.Accumulator:
		NES.cpu_memory.registers[Consts.CPU_Registers.A] = value
	elif context.address_mode == Consts.AddressingModes.Implied:
		NES.cpu_memory.registers[implied_register] = value
	else:
		var address = _determine_memory_address(context)
		NES.cpu_memory.write_byte(address, value)


func _read_value_from_memory(context: OperandAddressingContext, implied_register = Consts.CPU_Registers.A):
	if context.address_mode == Consts.AddressingModes.Immediate:
		return context.value
	elif context.address_mode == Consts.AddressingModes.Accumulator:
		return NES.cpu_memory.registers[Consts.CPU_Registers.A]
	elif context.address_mode == Consts.AddressingModes.Implied:
		return NES.cpu_memory.registers[implied_register]
	else:
		var address = _determine_memory_address(context)
		
		return NES.cpu_memory.read_byte(address)


func _determine_memory_address(context: OperandAddressingContext):
	var address = context.value
	
	if context.address_mode == Consts.AddressingModes.Indirect:
		# Getting the indrect address value (we'll look up the value later.)
		address = NES.cpu_memory.read_word(address)
	elif context.address_mode in [Consts.AddressingModes.Absolute_X, Consts.AddressingModes.ZeroPage_X, Consts.AddressingModes.ZPInd_X]:
		# Indexing by X
		address += NES.cpu_memory.registers[Consts.CPU_Registers.X]
	elif context.address_mode in [Consts.AddressingModes.Absolute_Y, Consts.AddressingModes.ZeroPage_Y]:
		# Indexing by Y (ZPInd_Y is handled separately below.)
		address += NES.cpu_memory.registers[Consts.CPU_Registers.Y]
	elif context.address_mode == Consts.AddressingModes.Relative:
		# Relative indexing is limited to a signed byte
		if address > 0x80:
			address -= 0x100
		assert(address >= -128 and address <= 127)
		
	if context.address_mode in [Consts.AddressingModes.ZeroPage_X, Consts.AddressingModes.ZeroPage_Y]:
		# Ensuring we stay on the zero page
		address %= 0x100
	elif context.address_mode == Consts.AddressingModes.ZPInd_X:
		# Ensuring we stay on the zero page, and grabbing the high byte while we're at it
		var high_address = (address + 1) % 256
		address %= 256
		
		return NES.cpu_memory.read_byte(address) + (NES.cpu_memory.read_byte(high_address) << 8)
	elif context.address_mode == Consts.AddressingModes.ZPInd_Y:
		# ZPInd_Y works slightly differently
		var high_address = (address + 1) % 256
		
		address = NES.cpu_memory.read_byte(address) + (NES.cpu_memory.read_byte(high_address) << 8)
		address += NES.cpu_memory.registers[Consts.CPU_Registers.Y]
	
	return address
