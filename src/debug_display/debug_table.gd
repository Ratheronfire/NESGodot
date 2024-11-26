@tool
extends SpanningTableContainer

@export var page: int:
	set(value):
		page = value
		for row in get_children():
			if row is NES_DebugRow:
				row.page = value
