extends Node


class Palette:
    var colors: Array[Color] = [Color.BLACK, Color.BLACK, Color.BLACK, Color.BLACK]

    func _init(color_hex_values: Array[int]) -> void:
        var palette_data = FileAccess.get_file_as_bytes('res://assets/palette_data/2C02G_wiki.pal')

        colors = []

        for hex_value in color_hex_values:
            var palette_index = hex_value * 3

            var r = palette_data[palette_index]
            var g = palette_data[palette_index + 1]
            var b = palette_data[palette_index + 2]

            colors.append(Color(r / 255.0, g / 255.0, b / 255.0))


func get_palettes() -> Array[Palette]:
    var palettes: Array[Palette] = []

    for i in range(PPU_Memory.PALETTE_DATA, PPU_Memory.PALETTE_DATA + 32, 4):
        var palette = Palette.new([
            NES.ppu_memory.memory_bytes[i],
            NES.ppu_memory.memory_bytes[i + 1],
            NES.ppu_memory.memory_bytes[i + 2],
            NES.ppu_memory.memory_bytes[i + 3],
        ])

        palettes.append(palette)

    return palettes


func get_tile_data(is_first_table: bool, pixel_index: int) -> Array[int]:
    var table_base_address = PPU_Memory.PATTERN_TABLE_0 if is_first_table else PPU_Memory.PATTERN_TABLE_1
    var pixel_address_offset = pixel_index * 16

    # Tiles are defined using 2 bit planes.
    var bit_plane_1_address = table_base_address + pixel_address_offset
    var bit_plane_2_address = table_base_address + pixel_address_offset + 8

    var pixels: Array[int] = []

    # For each byte pair of this tile:
    for i in range(8):
        var byte_1 = NES.ppu_memory.memory_bytes[bit_plane_1_address + i]
        var byte_2 = NES.ppu_memory.memory_bytes[bit_plane_2_address + i]

        # For each bit of these bytes:
        for j in range(7, -1, -1):
            var bit_1_set = byte_1 & (2**j) > 0
            var bit_2_set = byte_2 & (2**j) > 0

            # Assigning the appropriate palette based on the two bytes
            if not bit_1_set and not bit_2_set:
                pixels.append(0)
            elif bit_1_set and not bit_2_set:
                pixels.append(1)
            elif not bit_1_set and bit_2_set:
                pixels.append(2)
            else:
                pixels.append(3)
    
    return pixels
