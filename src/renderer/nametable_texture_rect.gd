extends TextureRect

@export var row: int
@export var column: int

var nametable_id: int


func on_draw_requested():
	if not len(NesRenderer.palettes):
		return
	
	var nametable_byte = NES.ppu_memory.memory_bytes[PPU_Memory.NAMETABLES[nametable_id] + column + row * 32]

	var is_first_pattern_table = NES.cpu_memory.memory_bytes[Consts.PPU_Registers.PPUCTRL] & 0x10 == 0

	texture = NesRenderer.get_tile_image(nametable_byte, NesRenderer.get_palette_for_nametable_tile(nametable_id, row, column), is_first_pattern_table)
