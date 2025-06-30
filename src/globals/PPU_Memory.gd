class_name PPU_Memory
extends Memory


func init_registers() -> void:
    _registers = {
        Consts.CPU_Registers.PPU_V: 0,
        Consts.CPU_Registers.PPU_T: 0,
        Consts.CPU_Registers.PPU_X: 0,
        Consts.CPU_Registers.PPU_W: 0
    }


func can_write_byte(address: int) -> bool:
    return true


func _process_read_byte_side_effects(address: int):
    pass
