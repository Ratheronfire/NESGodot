extends TextureRect

@export var row: int
@export var column: int

@export var is_first_table = true


func on_draw_requested():
    if not len(NesRenderer.palettes):
        return
    
    var nametable_address = PPU_Memory.NAMETABLE_0 if is_first_table else PPU_Memory.NAMETABLE_1
    var nametable_byte = NES.ppu_memory.memory_bytes[nametable_address + column + row * 32]

    texture = NesRenderer.get_tile_image(nametable_byte, NesRenderer.palettes[0], false)
