class_name CPU_Memory
extends Memory

const CPU_MEMORY_SIZE = 0x10000

const WORK_RAM_ADDRESS  = 0x0000
const WORK_RAM_MIRROR   = 0x0800
const PPU_REGISTERS     = 0x2000
const PPU_MIRROR        = 0x2008
const APU_IO            = 0x4000
const CARTRIDGE_ADDRESS = 0x8000

const CONTROLLER_REGISTER = 0x4016

const WORK_RAM_SIZE = 0x0800
const PPU_RAM_SIZE  = 0x0008

signal ppu_register_touched

signal controller_poll_event


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


func _process_pre_read_byte_side_effects(address: int):
    if address == CONTROLLER_REGISTER:
        controller_poll_event.emit(true, memory_bytes[address])


func _process_read_byte_side_effects(address: int):
    if address >= PPU_REGISTERS and address < PPU_MIRROR:
        ppu_register_touched.emit(address, memory_bytes[address], true)

    if address == Consts.PPU_Registers.PPUSTATUS:
        memory_bytes[address] &= 0x7F


func _process_write_byte_side_effects(address: int):
    if address >= PPU_REGISTERS and address < PPU_MIRROR:
        ppu_register_touched.emit(address, memory_bytes[address], false)
    
    if address == CONTROLLER_REGISTER:
        controller_poll_event.emit(false, memory_bytes[address])
