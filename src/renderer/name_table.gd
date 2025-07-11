extends Window

@export var refresh_every_frame = false

@onready var nametable_1 = $HBoxContainer/VBoxContainer/NametableImage
@onready var nametable_2 = $HBoxContainer/VBoxContainer/NametableImage2


func _ready() -> void:
    NES.render_end.connect(on_render_end)


func _process(delta: float) -> void:
    $HBoxContainer/RightControls/DrawButton.disabled = refresh_every_frame and NES.cpu_speed_multiplier > 0


func on_render_end():
    if refresh_every_frame:
        draw_nametables()


func draw_nametables():
    nametable_1.draw_nametable()
    nametable_2.draw_nametable()


func _on_pattern_table_test_button_pressed() -> void:
    draw_nametables()


func _on_auto_update_check_box_toggled(toggled_on: bool) -> void:
    refresh_every_frame = toggled_on
