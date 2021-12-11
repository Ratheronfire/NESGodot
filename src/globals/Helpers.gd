extends Node


func hex_string_to_decimal(hex_string: String) -> int:
	if len(hex_string) == 0:
		return 0
	
	var hex_digits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F']
	var value = 0
	
	for i in range(len(hex_string)):
		var character = hex_string[len(hex_string) - i - 1].to_lower()
		value += hex_digits.find(character) * pow(16, i)
	return value


func to_binary_string(number):
	var int_number = int(number)
	
	var bin_str = ''
	
	for i in range(8):
		var bit = int_number & 0x1
		bin_str = str(bit) + bin_str
		int_number = int_number >> 1
	
	return bin_str
