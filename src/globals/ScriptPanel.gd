class_name ScriptPanel
extends Panel

onready var debug_display = get_parent()

onready var file_dialog = $"../FileDialog"
onready var file_text = $VBoxContainer/HBoxContainer/ScriptPath

var _file_path


func _ready():
	_on_FileDialog_file_selected("res://src/test_script.tres")


func run_script():
	var file = File.new()
	file.open(_file_path, File.READ)
	
	var script = file.get_as_text()
	file.close()
	
	Nes.run_script(script)
	debug_display.ready_to_render = true


func _on_LoadButton_pressed():
	file_dialog.popup()


func _on_FileDialog_file_selected(path):
	_file_path = path
	file_text.text = path


func _on_RunScriptButton_pressed():
	run_script()
