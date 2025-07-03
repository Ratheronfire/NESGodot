extends NES_Image

@export var is_first_table = true


func _ready() -> void:
    for row in get_children():
        for texture in row.get_children():
            texture.is_first_table = is_first_table
            draw_requested.connect(texture.on_draw_requested)


func draw_nametable():
    draw_requested.emit()
