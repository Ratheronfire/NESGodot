class_name NES_Image
extends Control

signal draw_requested


func draw_tile(x: int, y: int, image: Image, tile_data: Array[int], palette: NesRenderer.Palette):
    var image_pixel_base = Vector2(x * 8, y * 8)

    for i in range(len(tile_data)):
        var pixel = tile_data[i]
        var pixel_offset = Vector2(i % 8, i / 8)

        image.set_pixel(
            image_pixel_base.x + pixel_offset.x,
            image_pixel_base.y + pixel_offset.y,
            palette.colors[pixel]
        )
