extends TextureRect

@export var is_first_table = true

@export var selected_palette: int

@onready var _pattern_table_index = PPU_Memory.PATTERN_TABLE_0 if is_first_table else PPU_Memory.PATTERN_TABLE_1

var _palette := []

var _image: Image


func _ready() -> void:
    _image = Image.create_empty(128, 128, false, Image.FORMAT_RGB8)
    texture = ImageTexture.create_from_image(_image)

    NesRenderer.renderer_updated.connect(on_renderer_updated)


func draw_pattern_table():
    if not len(NesRenderer.palettes):
        return
        
    _palette = NesRenderer.palettes[selected_palette]

    for address in NesRenderer.pattern_table_data.keys():
        _update_pixel_slice(address, NesRenderer.pattern_table_data[address])
    
    texture.update(_image)


func on_renderer_updated(pattern_table_updates: Array, _nametable_updates: Array, _attribute_table_updates: Array, _palette_updates: Array):
    pass
    # if len(pattern_table_updates) > 0:
    #     print('%s: Partial render starting.' % name)

    # _palette = NesRenderer.palettes[selected_palette]
    
    # for address in pattern_table_updates:
    #     _update_pixel_slice(address, NesRenderer.pattern_table_data[address])
    
    # texture.update(_image)

    # if len(pattern_table_updates) > 0:
    #     print('%s: Partial render done after %d update(s).' % [name, len(pattern_table_updates)])
    #     print(texture.get_image())


func _update_pixel_slice(address: int, pixels: Array):
    if address & 0x01000 != _pattern_table_index:
        return
    
    var tile_id = address / 16

    var x = 8 * (tile_id << 1 & 0x1F) / 2
    var y = ((tile_id & 0x00FF) >> 4) * 8 + address % 8

    for i in range(len(pixels)):
        _image.set_pixel(x + i, y, _palette[pixels[i]])
