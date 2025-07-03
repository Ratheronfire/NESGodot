extends NES_Image

@export var is_first_table = true

@export var selected_palette: int:
    get: return selected_palette
    set(value):
        selected_palette = value
        selected_palette_updated.emit(selected_palette)


signal selected_palette_updated


func _ready() -> void:
    for row in get_children():
        for texture in row.get_children():
            texture.is_first_table = is_first_table
            
            draw_requested.connect(texture.on_draw_requested)
            selected_palette_updated.connect(texture.on_selected_palette_updated)


func draw_pattern_table():
    draw_requested.emit()
