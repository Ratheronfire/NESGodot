extends TextureRect

@export var row: int
@export var column: int

@export var is_first_table = true

@export var selected_palette = 0


func on_draw_requested():
    if not len(NesRenderer.palettes):
        return
    
    texture = NesRenderer.get_tile_image(column + row * 16, NesRenderer.palettes[selected_palette], is_first_table)


func on_selected_palette_updated(new_palette: int):
    selected_palette = new_palette
