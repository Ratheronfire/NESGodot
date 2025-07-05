class_name NES_Standard_Controller
extends NES_Controller

var _current_poll_index = 0

var _input_order = [
    'nes_a', 'nes_b', 'nes_select', 'nes_start',
    'nes_up', 'nes_down', 'nes_left', 'nes_right'
]


func init():
    super.init()
    NES.cpu_memory.memory_bytes[CPU_Memory.CONTROLLER_REGISTER] = 0x40


func on_controller_poll_event(is_read: bool, memory_byte: int):
    super.on_controller_poll_event(is_read, memory_byte)

    if is_read and _is_polling_active:
        var is_button_held = Input.is_action_pressed(_input_order[_current_poll_index])

        _current_poll_index += 1

        if _current_poll_index >= len(_input_order):
            _current_poll_index = 0
            _is_polling_active = false
        
        # Some games expect the 7th bit to be active
        NES.cpu_memory.memory_bytes[CPU_Memory.CONTROLLER_REGISTER] = 0x40 | (1 if is_button_held else 0)
