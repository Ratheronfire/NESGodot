class_name ScriptPanel
extends Panel

enum FileType {
    Script = 0,
    ROM = 1
}

const LAST_LOADED_PATH = ".last_loaded"

@onready var debug_display = get_parent()

@onready var file_dialog = $"../FileDialog"
@onready var file_text = $VBoxContainer/HBoxContainer/ScriptPath
@onready var step_button = $VBoxContainer/HBoxContainer2/StepButton

var _file_type: FileType = FileType.ROM

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
    load_last_run()

    get_viewport().files_dropped.connect(on_files_dropped)


func init_system():
    NES.clear_memory()
    
    if _file_type == FileType.Script:
        var file = FileAccess.open(_file_path, FileAccess.READ)
        
        var script = file.get_as_text()
        var bytecode = NES.compile_script(script)
        
        file.close()
        
        for i in range(len(bytecode)):
            NES.cpu_memory.write_byte(i + CPU_Memory.CARTRIDGE_ADDRESS, bytecode[i])
        
        NES.cpu_memory.registers[Consts.CPU_Registers.PC] = CPU_Memory.CARTRIDGE_ADDRESS
    elif _file_type == FileType.ROM:
        NES.setup_rom(_file_path)


func save_last_run():
    var loaded_file = FileAccess.open(LAST_LOADED_PATH, FileAccess.WRITE)
    loaded_file.store_string(
        JSON.stringify({
            'file_path': _file_path,
            'file_type': _file_type
        })
    )
    loaded_file.close()


func load_last_run():
    var loaded_file = FileAccess.open(LAST_LOADED_PATH, FileAccess.READ)
    var loaded_file_json = JSON.parse_string(loaded_file.get_as_text())
    loaded_file.close()

    if loaded_file_json:
        _file_type = loaded_file_json['file_type']
        run_file(loaded_file_json['file_path'])


func run_file(path):
    print("Loading %s." % path)
    _file_path = path
    file_text.text = _file_path

    await NES.stop_running()
    
    init_system()
    save_last_run()

    NES.start_running()


func on_files_dropped(files):
    if len(files) == 1:
        _file_path = files[0]
        file_text.text = _file_path
    
        init_system()
        save_last_run()


func _on_LoadButton_pressed():
    file_dialog.popup_centered()


func _on_RunScriptButton_pressed():
    load_last_run()


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
    NES.advance_to_next_tick()
    NES.tick()


func _on_file_type_option_button_item_selected(index: int) -> void:
    _file_type = index


func _on_file_dialog_file_selected(path: String) -> void:
    run_file(path)
