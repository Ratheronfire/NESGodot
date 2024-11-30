class_name ScriptPanel
extends Panel

enum FileType {
	Script = 0,
	ROM = 1
}

@onready var debug_display = get_parent()

@onready var file_dialog = $"../FileDialog"
@onready var file_text = $VBoxContainer/HBoxContainer/ScriptPath
@onready var step_button = $VBoxContainer/HBoxContainer2/StepButton

var _file_type: FileType = FileType.Script

var _file_path: String

var _speed_settings = [
	0.0,
	0.001,
	0.1,
	0.5,
	0.75,
	1.0,
	2.0,
	5.0,
	10.0
]


func _ready():
	_on_FileDialog_file_selected("res://src/test_script.txt")
	run_script()


func run_script():
	NES.start_running()


func _on_LoadButton_pressed():
	file_dialog.popup_centered()


func _on_FileDialog_file_selected(path):
	_file_path = path
	file_text.text = _file_path
	
	if _file_type == FileType.Script:
		var file = FileAccess.open(_file_path, FileAccess.READ)
		
		var script = file.get_as_text()
		var bytecode = NES.compile_script(script)
		
		file.close()
		
		for i in range(len(bytecode)):
			NES.cpu_memory[i + Consts.CARTRIDGE_ADDRESS] = bytecode[i]
		
		NES.registers[Consts.CPU_Registers.PC] = Consts.CARTRIDGE_ADDRESS
	elif _file_type == FileType.ROM:
		NES.setup_rom(_file_path)


func _on_RunScriptButton_pressed():
	run_script()


func _on_StepByStepCheckBox_toggled(button_pressed):
	NES.run_step_by_step = button_pressed
	step_button.disabled = !button_pressed


func _on_cpu_speed_slider_drag_ended(value_changed: bool) -> void:
	var slider_value = $VBoxContainer/HBoxContainer2/CPUSpeedSlider.value
	
	NES.cpu_speed_multiplier = _speed_settings[slider_value]
	
	step_button.disabled = slider_value != 0
	
	if slider_value == 0:
		$VBoxContainer/HBoxContainer2/CPUSpeedIndicator.text = "CPU Paused"
	else:
		$VBoxContainer/HBoxContainer2/CPUSpeedIndicator.text = "%0.4f%% Speed" % (_speed_settings[slider_value] * 100)


func _on_StepButton_pressed():
	NES.tick()


func _on_file_type_option_button_item_selected(index: int) -> void:
	$VBoxContainer/RunScriptButton.text = "Run Script" if index == 0 else "Run ROM"
	_file_type = index
