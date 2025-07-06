extends TextureRect

@export var is_first_table = true

var _image: Image


func _ready() -> void:
    _image = Image.create_empty(256, 240, false, Image.FORMAT_RGB8)
    texture = ImageTexture.create_from_image(_image)


func draw_nametable():
    if not len(NesRenderer.palettes):
        return
        
    _palette = NesRenderer.palettes[selected_palette]

    for address in NesRenderer.nametable_data.keys():
        var pattern_table_id =
    
    texture.update(_image)
