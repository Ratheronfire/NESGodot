extends NES_TextureRect

@export var selected_palette = 0

@export var is_first_table = true


func draw_pattern_table():
    clear_cache()

    var image = Image.create(128, 128, false, Image.FORMAT_RGBA8)
    var palettes = NesRenderer.get_palettes()

    for tile_x in range(16):
        for tile_y in range(16):
            var tile_data = get_tile_data(is_first_table, tile_y * 16 + tile_x)

            draw_tile(tile_x, tile_y, image, tile_data, palettes[selected_palette])
    
    texture = ImageTexture.create_from_image(image)
