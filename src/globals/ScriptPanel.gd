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


func _on_cpu_speed_slider_drag_ended(value_changed: bool) -> void:
	var slider_value = $VBoxContainer/HBoxContainer2/CPUSpeedSlider.value
	
	if slider_value == $VBoxContainer/HBoxContainer2/CPUSpeedSlider.min_value:
		slider_value = 0
	elif slider_value == $VBoxContainer/HBoxContainer2/CPUSpeedSlider.max_value:
		slider_value = -1
	
	Nes.instructions_per_second = slider_value
	
	step_button.disabled = slider_value != 0
	
	if slider_value == -1:
		$VBoxContainer/HBoxContainer2/CPUSpeedIndicator.text = "Max Speed"
	elif slider_value == 0:
		$VBoxContainer/HBoxContainer2/CPUSpeedIndicator.text = "CPU Paused"
	else:
		$VBoxContainer/HBoxContainer2/CPUSpeedIndicator.text = "%d inst%s/sec" % [
			slider_value, "" if slider_value == 1 else "s"
		]


func _on_StepButton_pressed():
	Nes.tick()
