class_name ScriptPanel
extends Panel

@onready var debug_display = get_parent()

@onready var file_dialog = $"../FileDialog"
@onready var file_text = $VBoxContainer/HBoxContainer/ScriptPath
@onready var step_button = $VBoxContainer/HBoxContainer2/StepButton

var _file_path


func _ready():
	_on_FileDialog_file_selected("res://src/test_script.txt")
	run_script()


func run_script():
	var file = FileAccess.open(_file_path, FileAccess.READ)
	var script = file.get_as_text()
	file.close()
	
	var bytecode = Nes.compile_script(script)
	
	for i in range(len(bytecode)):
		Nes.memory[i + Consts.CARTRIDGE_ADDRESS] = bytecode[i]
	Nes.registers[Consts.CPU_Registers.PC] = Consts.CARTRIDGE_ADDRESS
	
	if not Nes.run_step_by_step:
		Nes.start_running()


func _on_LoadButton_pressed():
	file_dialog.popup_centered()


func _on_FileDialog_file_selected(path):
	_file_path = path
	file_text.text = path


func _on_RunScriptButton_pressed():
	run_script()


func _on_StepByStepCheckBox_toggled(button_pressed):
	Nes.run_step_by_step = button_pressed
	step_button.disabled = !button_pressed


func _on_StepButton_pressed():
	Nes.start_running()
