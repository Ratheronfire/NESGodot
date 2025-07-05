class_name Memory
extends Resource

var memory_bytes:
    get: return _memory_bytes

var _memory_bytes = []

var registers: Dictionary[Consts.CPU_Registers, int]:
    get: return _registers

var _registers: Dictionary[Consts.CPU_Registers, int]


func _init(memory_size: int) -> void:
    _memory_bytes = []

    for i in range(memory_size):
        _memory_bytes.append(0)
    
    init_registers()


func init_registers() -> void:
    pass

func get_memory_size() -> int:
    return len(memory_bytes)


func read_byte(address: int, process_side_effects = true) -> int:
    if process_side_effects:
        _process_pre_read_byte_side_effects(address)
    
    var return_value = _get_byte_value(address)
    
    if process_side_effects:
        _process_read_byte_side_effects(address)
    
    return return_value


func read_word(address: int, process_side_effects = true) -> int:
    return read_byte(address, process_side_effects) + (read_byte(address + 1, process_side_effects) << 8)


func write_byte(address: int, value: int, process_side_effects = true) -> void:
    if not can_write_byte(address):
        return
    
    if process_side_effects:
        _process_pre_write_byte_side_effects(address)
    
    memory_bytes[address] = value
    
    if process_side_effects:
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
    for i in range(len(memory_bytes)):
        memory_bytes[i] = 0x0


func _get_byte_value(address: int) -> int:
    return memory_bytes[address % 0xFFFF]


func _process_read_byte_side_effects(address: int):
    pass


func _process_write_byte_side_effects(address: int):
    pass


func _process_pre_read_byte_side_effects(address: int):
    pass


func _process_pre_write_byte_side_effects(address: int):
    pass