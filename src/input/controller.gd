class_name NES_Controller
extends Resource

var _last_write_value = 0x0

var _is_polling_active = false


func init() -> void:
    NES.cpu_memory.controller_poll_event.connect(on_controller_poll_event)


func on_controller_poll_event(is_read: bool, memory_byte: int):
    if not is_read and not _is_polling_active and _last_write_value & 0x1 == 0 and memory_byte & 0x1 > 0:
        _is_polling_active = true

    _last_write_value = memory_byte