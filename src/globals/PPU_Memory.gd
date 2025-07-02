class_name PPU_Memory
extends Memory

const PPU_MEMORY_SIZE = 0x04000

const PATTERN_TABLE_0 = 0x0000
const PATTERN_TABLE_1 = 0x1000

const NAMETABLE_0 = 0x2000
const ATTRIBUTE_TABLE_0 = 0x23C0

const NAMETABLE_1 = 0x2400
const ATTRIBUTE_TABLE_1 = 0x27C0

const NAMETABLE_2 = 0x2800
const ATTRIBUTE_TABLE_2 = 0x2BC0

const NAMETABLE_3 = 0x2C00
const ATTRIBUTE_TABLE_3 = 0x2FC0

const NAMETABLE_SIZE = 0x03C0

const PALETTE_DATA = 0x3F00

var _buffered_ppudata_value = 0x0


func init_registers() -> void:
    _registers = {
        Consts.CPU_Registers.PPU_V: 0,
        Consts.CPU_Registers.PPU_T: 0,
        Consts.CPU_Registers.PPU_X: 0,
        Consts.CPU_Registers.PPU_W: 0
    }


func on_ppu_register_touched(cpu_address: int, cpu_address_value: int, was_read: bool):
    # Read PPUSTATUS: Clear W register
    if cpu_address == Consts.PPU_Registers.PPUSTATUS and was_read:
        _registers[Consts.CPU_Registers.PPU_W] = 0
    
    # Read PPUDATA: Update buffer for next read
    if was_read and cpu_address == Consts.PPU_Registers.PPUDATA:
        NES.cpu_memory.memory_bytes[Consts.PPU_Registers.PPUDATA] = _buffered_ppudata_value
        _buffered_ppudata_value = _memory_bytes[_registers[Consts.CPU_Registers.PPU_V]]
    
    # Write PPUSCROLL: Update x/y scroll data
    if not was_read and cpu_address == Consts.PPU_Registers.PPUSCROLL:
        # TODO: Update x/y scroll values
        _flip_w_register()
    
    # Write PPUADDR: Update high or low byte of VRAM address
    if not was_read and cpu_address == Consts.PPU_Registers.PPUADDR:
        if _registers[Consts.CPU_Registers.PPU_W] == 0:
            _registers[Consts.CPU_Registers.PPU_V] &= 0x00FF
            _registers[Consts.CPU_Registers.PPU_V] |= (cpu_address_value << 8)
        else:
            _registers[Consts.CPU_Registers.PPU_V] &= 0xFF00
            _registers[Consts.CPU_Registers.PPU_V] |= cpu_address_value

        _registers[Consts.CPU_Registers.PPU_V] &= 0x3FFF
        _flip_w_register()
    
    # Write PPUDATA: Copy data to PPU memory
    if not was_read and cpu_address == Consts.PPU_Registers.PPUDATA:
        _memory_bytes[_registers[Consts.CPU_Registers.PPU_V]] = cpu_address_value
        # print("Wrote 0x%02X to PPU at address $%02X." % [cpu_address_value, _registers[Consts.CPU_Registers.PPU_V]])
    
    # If PPUDATA was accessed, increment by the value specified in PPUCTRL
    if cpu_address == Consts.PPU_Registers.PPUDATA:
        var vram_increment_flag = NES.cpu_memory.memory_bytes[Consts.PPU_Registers.PPUCTRL] & 0x0004
        var vram_address_increment = 32 if vram_increment_flag > 0 else 1

        _registers[Consts.CPU_Registers.PPU_V] += vram_address_increment
        _registers[Consts.CPU_Registers.PPU_V] &= 0x3FFF



func can_write_byte(address: int) -> bool:
    return true


func _process_read_byte_side_effects(address: int):
    pass


func _flip_w_register():
    _registers[Consts.CPU_Registers.PPU_W] = 1 if _registers[Consts.CPU_Registers.PPU_W] == 0 else 0
