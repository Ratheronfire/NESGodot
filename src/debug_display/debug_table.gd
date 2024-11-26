@tool
extends VBoxContainer

@export var bytes_per_row: int = 16
@export var bytes_per_page: int = 256

@export var _rows: Array[NES_DebugRow]

@export var page: int:
	set(value):
		page = value
		for row in _rows:
			row.page = value

@onready var page_number_field = $HBoxContainer/PageNumber
@onready var page_total_field = $HBoxContainer/Page2
@onready var first_button = $HBoxContainer/FirstButton
@onready var prev_button = $HBoxContainer/PrevButton
@onready var next_button = $HBoxContainer/NextButton
@onready var last_button = $HBoxContainer/LastButton

@onready var _total_pages = 0
var _page_num_input = 0

var memory_category = 0

signal table_category_updated


func _ready() -> void:
	_set_memory_category(0)


func _set_memory_page(page_index: int):
	page = clamp(page_index, 0, _total_pages)
	
	first_button.disabled = page == 0
	prev_button.disabled = page == 0
	next_button.disabled = page == _total_pages
	last_button.disabled = page == _total_pages
	
	page_number_field.text = str(page)
	page_number_field.set_caret_column(page_number_field.text.length())


func _set_memory_category(category_index: int):
	page = 0
	_total_pages = len(NES.cpu_memory if category_index == 0 else NES.ppu_memory) / bytes_per_page - 1
	page_total_field.text = "Of %d" % _total_pages
	
	memory_category = category_index
	table_category_updated.emit(memory_category)


func _on_first_button_pressed():
	_set_memory_page(0)


func _on_prev_button_pressed():
	_set_memory_page(page - 1)


func _on_next_button_pressed():
	_set_memory_page(page + 1)


func _on_last_button_pressed():
	_set_memory_page(_total_pages)


func _on_page_number_text_changed():
	var new_text = page_number_field.text
	if not new_text.is_valid_int() or int(new_text) < 0 or int(new_text) >= _total_pages:
		page_number_field.text = _page_num_input
		return
	
	_set_memory_page(int(new_text))
	_page_num_input = new_text


func _on_memory_category_option_button_item_selected(index: int) -> void:
	_set_memory_category(index)
