extends NES_Image

@export var nametable_id := 0


func _ready() -> void:
	for row in get_children():
		for texture in row.get_children():
			texture.nametable_id = nametable_id
			draw_requested.connect(texture.on_draw_requested)


func draw_nametable():
	draw_requested.emit()
