class_name NES_TextureRect
extends TextureRect

var _cached_tile_data = {}


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


func get_tile_data(is_first_table: bool, pixel_index: int) -> Array[int]:
    var cache_key = [is_first_table, pixel_index]

    if not cache_key in _cached_tile_data:
        _cached_tile_data[cache_key] = NesRenderer.get_tile_data(is_first_table, pixel_index)
    
    return _cached_tile_data[cache_key]


func clear_cache():
    _cached_tile_data = {}
