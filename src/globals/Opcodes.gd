extends Node


class InstructionData:
	var opcode: int
	var context: OperandAddressingContext = OperandAddressingContext.new()
	
	var instruction: String:
		get = get_instruction
	var bytes_to_read: int:
		get = get_bytes_to_read
	
	func get_instruction():
		return Consts.OPCODE_DATA[ self.opcode]['instruction']
	
	func get_bytes_to_read():
		if not self.context:
			return -1
		
		return Consts.BYTES_PER_MODE[ self.context.address_mode]

	func determine_addressing_context(instruction: String, operand: String) -> Array:
		var regex = RegEx.new()
		var result: RegExMatch
		
		var is_hex = "$" in operand
		
		if operand == "":
			return [Consts.AddressingModes.Implied, NES.cpu_memory.registers[Consts.CPU_Registers.A]]
		elif operand == "A":
			return [Consts.AddressingModes.Accumulator, NES.cpu_memory.registers[Consts.CPU_Registers.A]]
		
		if instruction in ["BCC", "BCS", "BNE", "BEQ", "BPL", "BMI", "BVC", "BVS"]:
			return [Consts.AddressingModes.Relative, operand, is_hex]
		elif instruction == "JMP":
			regex.compile("\\(\\$?([0-9A-Fa-f]+)\\)")
			result = regex.search(operand)
			
			if result:
				return [Consts.AddressingModes.Indirect, result.get_string(1), is_hex]
			else:
				return [Consts.AddressingModes.Absolute, operand, is_hex]
		
		regex.compile("#\\$?([0-9A-Fa-f]+)")
		result = regex.search(operand)
		if result:
			return [Consts.AddressingModes.Immediate, result.get_string(1), is_hex]
		
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
			return [address_mode, value, is_hex]
		
		regex.compile("\\$([0-9A-Fa-f]+)")
		result = regex.search(operand)
		if result:
			var str_value = result.get_string(1)
			var value = Helpers.hex_string_to_decimal(str_value) if is_hex else int(str_value)
			
			var address_mode = Consts.AddressingModes.Absolute if value > 0xFF else Consts.AddressingModes.ZeroPage
			
			return [Consts.AddressingModes.Absolute, value, is_hex]
		
		regex.compile("\\(\\$?([0-9A-Fa-f]+)\\)")
		result = regex.search(operand)
		if result:
			return [Consts.AddressingModes.Indirect, result.get_string(1), is_hex]
		
		regex.compile("\\(\\$?([0-9A-Fa-f]+),X\\)")
		result = regex.search(operand)
		if result:
			return [Consts.AddressingModes.ZPInd_X, result.get_string(1), is_hex]
		
		regex.compile("\\(\\$?([0-9A-Fa-f]+)\\),Y")
		result = regex.search(operand)
		if result:
			return [Consts.AddressingModes.ZPInd_Y, result.get_string(1), is_hex]
		
		print_debug("Unable to determine addressing mode. Operand: %s" % operand)
		return []

	
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

	func set_value_from_string(string_value: String):
		value = Helpers.hex_string_to_decimal(string_value.replace('$', ''))


func push_to_stack(value):
	NES.cpu_memory.write_byte(0x0100 + NES.cpu_memory.registers[Consts.CPU_Registers.SP], value)
	NES.cpu_memory.registers[Consts.CPU_Registers.SP] = NES.cpu_memory.registers[Consts.CPU_Registers.SP] - 1


func pull_from_stack():
	NES.cpu_memory.registers[Consts.CPU_Registers.SP] = NES.cpu_memory.registers[Consts.CPU_Registers.SP] + 1
	return NES.cpu_memory.read_byte(0x0100 + NES.cpu_memory.registers[Consts.CPU_Registers.SP])
