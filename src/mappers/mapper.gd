class_name NES_Mapper
extends Resource

const HEADER_SIZE = 0x10

const MAPPER_SCRIPTS = {
    0x0: preload("res://src/mappers/nrom.gd")
}

## The different possible file formats an NES ROM may be ripped using.
enum FileFormat {
    NONE, ## No valid format could be found.
    INES, ## Created by Marat Fayzullin for INES, used in most official and unofficial projects.
    NES_2, ## An extended version of the INES format.
    FDS, ## Created by Fan Wan Yang and Shu Kondo for fwNES; mainly useful for Famicom Disk System rips.
    TNES, ## Used for 3DS Virtual Console titles.
}

var mapper_id: int:
    get = get_mapper_id

var _rom_bytes: PackedByteArray

var _format: FileFormat

var _16_kb_prg_chunks: int = 1
var _8_kb_chr_chunks: int = 1


func open_rom(path: String):
    _rom_bytes = FileAccess.get_file_as_bytes(path)
    
    _format = determine_format(_rom_bytes)
    
    if _format in [FileFormat.INES, FileFormat.NES_2]:
        _16_kb_prg_chunks = _rom_bytes[4]
        _8_kb_chr_chunks = _rom_bytes[5]


func _copy_bank_to_ram(rom_address: int, ram_address: int, length: int, to_ppu: bool = false) -> void:
    print("Copying 0x%04X bytes from ROM 0x%04X to RAM 0x%04X." % [
        length,
        rom_address,
        ram_address
    ])
    
    var dest_memory = Consts.MemoryTypes.PPU if to_ppu else Consts.MemoryTypes.CPU
    
    var memory_size = -1.0
    if dest_memory == Consts.MemoryTypes.CPU:
        memory_size = NES.cpu_memory.get_memory_size()
    elif dest_memory == Consts.MemoryTypes.PPU:
        memory_size = NES.ppu_memory.get_memory_size()
    
    assert(len(_rom_bytes) - rom_address >= length)
    assert(memory_size - ram_address >= length)
    
    for i in range(length):
        if dest_memory == Consts.MemoryTypes.CPU:
            NES.cpu_memory.write_byte(ram_address + i, _rom_bytes[rom_address + i])
        elif dest_memory == Consts.MemoryTypes.PPU:
            NES.ppu_memory.write_byte(ram_address + i, _rom_bytes[rom_address + i])


func load_initial_map() -> void:
    pass


func get_mapper_id() -> int:
    return -1


static func determine_format(bytes: PackedByteArray) -> FileFormat:
    if bytes.slice(0, 4) == PackedByteArray([0x4E, 0x45, 0x53, 0x1A]):
        if bytes[7] & 0x0C == 0x08:
            return FileFormat.NES_2
        
        return FileFormat.INES
    elif bytes.slice(0, 4) == PackedByteArray([0x46, 0x44, 0x53, 0x1A]):
        return FileFormat.FDS
    elif bytes.slice(0, 4) == PackedByteArray([0x54, 0x4E, 0x45, 0x53]):
        return FileFormat.FDS
    
    return FileFormat.NONE

static func create_mapper(rom_path: String) -> NES_Mapper:
    var mapper: NES_Mapper = NES_Mapper.new()
    
    var bytes = FileAccess.get_file_as_bytes(rom_path)
    var header_format = determine_format(bytes)
    
    var mapper_id = 0x0
    if header_format == FileFormat.INES or header_format == FileFormat.NES_2:
        mapper_id = bytes[7] & 0b11110000 | bytes[6] >> 4
    elif header_format == FileFormat.TNES:
        var tnes_mapper_id = bytes[4]
        
        var mapper_translations = {
            0: 0,
            1: 1,
            2: 9,
            3: 4,
            4: 10,
            5: 5,
            6: 2,
            7: 3,
            9: 7,
            31: 86
        }
        
        if tnes_mapper_id in mapper_translations:
            mapper_id = mapper_translations[tnes_mapper_id]
    
    print('ROM header details: ROM format %s; Mapper ID %d.' % [FileFormat.find_key(header_format), mapper_id])
    
    if mapper_id in MAPPER_SCRIPTS:
        mapper.set_script(MAPPER_SCRIPTS[mapper_id])
        mapper.open_rom(rom_path)
    else:
        return null
    
    return mapper
