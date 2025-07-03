extends Window

@export var refresh_every_frame = false

@onready var pattern_table_1 = $HBoxContainer/VBoxContainer/PatternTableImage
@onready var pattern_table_2 = $HBoxContainer/VBoxContainer/PatternTableImage2


func _ready() -> void:
    NES.render_end.connect(on_render_end)


func _process(delta: float) -> void:
    $HBoxContainer/RightControls/DrawButton.disabled = refresh_every_frame and NES.cpu_speed_multiplier > 0


func on_render_end():
    if refresh_every_frame:
        draw_pattern_tables()


func draw_pattern_tables():
    pattern_table_1.draw_pattern_table()
    pattern_table_2.draw_pattern_table()


func _on_pattern_table_test_button_pressed() -> void:
    draw_pattern_tables()


func _on_palette_option_button_item_selected(index: int) -> void:
    pattern_table_1.selected_palette = index
    pattern_table_2.selected_palette = index
    draw_pattern_tables()


func _on_auto_update_check_box_toggled(toggled_on: bool) -> void:
    refresh_every_frame = toggled_on
