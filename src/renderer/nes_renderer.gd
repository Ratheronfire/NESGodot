extends Node

@onready var PALETTE_LOOKUPS = {
    'NTSC': FileAccess.get_file_as_bytes('res://assets/palette_data/2C02G_wiki.pal')
}

## A dictionary mapping PPU addresses to their corresponding 8x1 slivers of palette indices for their given tile.
##   (Note that the keys are the addresses of the low bitplane bytes, and the high bytes are ignored.)
var pattern_table_data := {}
## A dictionary mapping PPU addresses to their corresponding nametable entries, stored as pattern table IDs.
var nametable_data := {}
## A dictionary mapping PPU addresses to their corresponding attribute table entries, stored as an array of palette IDs for each metatile.
var attribute_table_data := {}
## A list of palettes, stored as lists of Color objects.
var palettes := []

signal renderer_updated


func _ready() -> void:
    NES.ppu_memory.ppu_updated.connect(_on_ppu_updated)
    reset()


func reset():
    for byte in range(PPU_Memory.NAMETABLE_0):
        if byte % 16 < 8:
            pattern_table_data[byte] = [0, 0, 0, 0, 0, 0, 0, 0]
    
    for byte in range(PPU_Memory.NAMETABLE_0, PPU_Memory.ATTRIBUTE_TABLE_0):
        nametable_data[byte] = 0x0
    for byte in range(PPU_Memory.NAMETABLE_1, PPU_Memory.ATTRIBUTE_TABLE_1):
        nametable_data[byte] = 0x0
    for byte in range(PPU_Memory.NAMETABLE_2, PPU_Memory.ATTRIBUTE_TABLE_2):
        nametable_data[byte] = 0x0
    for byte in range(PPU_Memory.NAMETABLE_3, PPU_Memory.ATTRIBUTE_TABLE_3):
        nametable_data[byte] = 0x0
    
    for byte in range(PPU_Memory.ATTRIBUTE_TABLE_0, PPU_Memory.NAMETABLE_1):
        attribute_table_data[byte] = [0, 0, 0, 0]
    for byte in range(PPU_Memory.ATTRIBUTE_TABLE_1, PPU_Memory.NAMETABLE_2):
        attribute_table_data[byte] = [0, 0, 0, 0]
    for byte in range(PPU_Memory.ATTRIBUTE_TABLE_2, PPU_Memory.NAMETABLE_3):
        attribute_table_data[byte] = [0, 0, 0, 0]
    for byte in range(PPU_Memory.ATTRIBUTE_TABLE_3, 0x3000):
        attribute_table_data[byte] = [0, 0, 0, 0]

    palettes = [
        [Color.GRAY, Color.GRAY, Color.GRAY, Color.GRAY],
        [Color.GRAY, Color.GRAY, Color.GRAY, Color.GRAY],
        [Color.GRAY, Color.GRAY, Color.GRAY, Color.GRAY],
        [Color.GRAY, Color.GRAY, Color.GRAY, Color.GRAY],
        [Color.GRAY, Color.GRAY, Color.GRAY, Color.GRAY],
        [Color.GRAY, Color.GRAY, Color.GRAY, Color.GRAY],
        [Color.GRAY, Color.GRAY, Color.GRAY, Color.GRAY],
        [Color.GRAY, Color.GRAY, Color.GRAY, Color.GRAY]
    ]


func _on_ppu_updated(pattern_table_updates: Array, nametable_updates: Array, attribute_table_updates: Array, palette_updates: Array):
    var modified_pattern_table_addresses = []
    for address in pattern_table_updates:
        if address % 16 >= 8:
            # This is the high byte of the bitplane pair; operating via the low byte for consistency.
            if address - 8 in pattern_table_updates:
                # ...Unless the low byte is present already, in which case we'd be repeating work.
                continue
            
            address -= 8
        
        var low_byte = NES.ppu_memory.memory_bytes[address]
        var high_byte = NES.ppu_memory.memory_bytes[address + 8]

        var pixels: Array[int] = []

        # For each bit of these bytes:
        for i in range(7, -1, -1):
            var bit_1_set = low_byte >> i & 0x1 == 1
            var bit_2_set = high_byte >> i & 0x1 == 1

            # Assigning the appropriate palette based on the two bytes
            if not bit_1_set and not bit_2_set:
                pixels.append(0)
            elif bit_1_set and not bit_2_set:
                pixels.append(1)
            elif not bit_1_set and bit_2_set:
                pixels.append(2)
            else:
                pixels.append(3)
        
        pattern_table_data[address] = pixels
        modified_pattern_table_addresses.append(address)
    
    for address in nametable_updates:
        nametable_data[address] = NES.ppu_memory.memory_bytes[address]
    
    for address in attribute_table_updates:
        var value = NES.ppu_memory.memory_bytes[address]

        attribute_table_data[address] = [
            value & 0x03,
            value >> 2 & 0x03,
            value >> 4 & 0x03,
            value >> 6 & 0x03
        ]
    
    for address in palette_updates:
        var palette_update = NES.ppu_memory.memory_bytes[address]

        var hex_value = NES.ppu_memory.memory_bytes[palette_update]
        var palette_file_index = hex_value * 3

        var palette_index = (address - PPU_Memory.PALETTE_DATA) / 4
        var color_index = 3 - (address - PPU_Memory.PALETTE_DATA) % 4
        
        palettes[palette_index][color_index].r = PALETTE_LOOKUPS['NTSC'][palette_file_index] / 255.0
        palettes[palette_index][color_index].g = PALETTE_LOOKUPS['NTSC'][palette_file_index + 1] / 255.0
        palettes[palette_index][color_index].b = PALETTE_LOOKUPS['NTSC'][palette_file_index + 2] / 255.0
    
    renderer_updated.emit(
        modified_pattern_table_addresses.duplicate(),
        nametable_updates.duplicate(),
        attribute_table_updates.duplicate(),
        palette_updates.duplicate()
    )
