@tool
extends RichTextEffect
class_name jump

# Syntax: [jump angle=3.141][/jump]
var bbcode = "jump"

const SPLITTERS = [" ", ".", ","]

var _w_char = 0
var _last = 999


func _process_custom_fx(char_fx):
	if char_fx.relative_index < _last or char_fx in SPLITTERS:
		_w_char = char_fx.relative_index
	
	_last = char_fx.relative_index
	var t = abs(sin(char_fx.elapsed_time * 8.0 + _w_char * PI * .025)) * 4.0
	var angle = deg_to_rad(char_fx.env.get("angle", 0))
	char_fx.offset.x += sin(angle) * t
	char_fx.offset.y += cos(angle) * t
	return true
