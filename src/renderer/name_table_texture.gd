extends NES_TextureRect

@export var is_first_table = true


func draw_nametable():
    clear_cache()

    var image = Image.create(256, 240, false, Image.FORMAT_RGBA8)
    var palettes = NesRenderer.get_palettes()

    var nametable_address = PPU_Memory.NAMETABLE_0 if is_first_table else PPU_Memory.NAMETABLE_1

    for i in range(PPU_Memory.NAMETABLE_SIZE):
        var nametable_byte = NES.ppu_memory.memory_bytes[i + nametable_address]
        var tile_data = get_tile_data(false, nametable_byte)
        
        draw_tile(i % 32, i / 32, image, tile_data, palettes[0])
    
    texture = ImageTexture.create_from_image(image)
