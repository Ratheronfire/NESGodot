class_name Memory
extends Resource

var memory_bytes: PackedByteArray

var registers: Dictionary[Consts.CPU_Registers, int] = {}


func _init(memory_size: int) -> void:
	memory_bytes = PackedByteArray()

	memory_bytes.resize(memory_size)
	memory_bytes.fill(0)
	
	init_registers()


func init_registers() -> void:
	pass

func get_memory_size() -> int:
	return len(memory_bytes)


func read_byte(address: int, process_side_effects = true) -> int:
	if not process_side_effects:
		return memory_bytes[address]
	
	_process_pre_read_byte_side_effects(address)
	var return_value = memory_bytes[address]
	_process_read_byte_side_effects(address)
	
	return return_value


func read_word(address: int, process_side_effects = true) -> int:
	return read_byte(address, process_side_effects) + (read_byte(address + 1, process_side_effects) << 8)


func write_byte(address: int, value: int, process_side_effects = true) -> void:
	if not can_write_byte(address):
		return
	
	if not process_side_effects:
		memory_bytes[address] = value
		return
	
	_process_pre_write_byte_side_effects(address)
	memory_bytes[address] = value
	_process_write_byte_side_effects(address)


func can_write_byte(address: int) -> bool:
	return true


func copy_ram(from: int, to: int, length: int) -> void:
	if from + length > Consts.MEMORY_SIZE or from < 0:
		print_debug("Copy failed; From region would exceed memory limits.")
		return
	elif to + length > Consts.MEMORY_SIZE or to < 0:
		print_debug("Copy failed; To region would exceed memory limits.")
		return
	elif from + length >= to:
		print_debug("Copy failed; From region would overlap To region.")
		return
	
	for i in range(length):
		memory_bytes[to + i] = memory_bytes[from + i]


func clear_memory():
	memory_bytes.fill(0)


func _process_read_byte_side_effects(address: int):
	pass


func _process_write_byte_side_effects(address: int):
	pass


func _process_pre_read_byte_side_effects(address: int):
	pass


func _process_pre_write_byte_side_effects(address: int):
	pass
