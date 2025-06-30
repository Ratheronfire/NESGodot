class_name CPU_Memory
extends Memory


func init_registers() -> void:
    _registers = {
        Consts.CPU_Registers.A:  0x00,
        Consts.CPU_Registers.X:  0x00,
        Consts.CPU_Registers.Y:  0x00,
        Consts.CPU_Registers.PC: read_word(0xFFFC),
        Consts.CPU_Registers.SP: 0xFD,
        Consts.CPU_Registers.P:  0x34
    }


func can_write_byte(address: int) -> bool:
    return true


func _get_byte_value(address: int) -> int:
    if address >= 0x0800 and address < 0x2000:
        var relative_address = address % 0x0800
        return memory_bytes[relative_address]
    elif address >= 0x2008 and address < 0x4000:
        var relative_address = 0x2000 + ((address - 0x2000) % 0x08)
        return memory_bytes[relative_address]
    
    return super._get_byte_value(address)


func _process_read_byte_side_effects(address: int):
    if address == Consts.PPU_REGISTERS + Consts.PPU_Registers.PPUSTATUS:
        memory_bytes[address] &= 0x7F
