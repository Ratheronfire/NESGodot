extends TextureRect

@export var selected_palette = 0


func draw_pattern_table(is_first_table: bool):
    var image = Image.create(128, 128, false, Image.FORMAT_RGBA8)
    var palettes = NesRenderer.get_palettes()

    for tile_x in range(16):
        for tile_y in range(16):
            var image_pixel_base = Vector2(tile_x * 8, tile_y * 8)
            var tile_data = NesRenderer.get_tile_data(is_first_table, tile_y * 16 + tile_x)

            for i in range(len(tile_data)):
                var pixel = tile_data[i]
                var pixel_offset = Vector2(i % 8, i / 8)

                image.set_pixel(
                    image_pixel_base.x + pixel_offset.x,
                    image_pixel_base.y + pixel_offset.y,
                    palettes[selected_palette].colors[pixel]
                )
    
    texture = ImageTexture.create_from_image(image)

func _on_pattern_table_test_button_pressed() -> void:
    draw_pattern_table(true)


func _on_pattern_table_test_button_2_pressed() -> void:
    draw_pattern_table(false)


func _on_palette_option_button_item_selected(index: int) -> void:
    selected_palette = index
    print("Using palette %d." % selected_palette)
