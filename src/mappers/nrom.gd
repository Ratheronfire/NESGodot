extends NES_Mapper


func load_initial_map() -> void:
	#CPU $6000-$7FFF: Family Basic only: PRG RAM, mirrored as necessary to fill entire 8 KiB window, write protectable with an external switch
	#CPU $8000-$BFFF: First 16 KB of ROM.
	#CPU $C000-$FFFF: Last 16 KB of ROM (NROM-256) or mirror of $8000-$BFFF (NROM-128).
	
	_copy_bank_to_ram(0x0 + HEADER_SIZE, 0x8000, 0x4000)
	_copy_bank_to_ram((_16_kb_prg_chunks - 1) * 0x4000 + HEADER_SIZE, 0xC000, 0x4000)


func get_mapper_id() -> int:
	return 0x0
