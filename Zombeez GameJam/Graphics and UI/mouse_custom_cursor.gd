extends Node

var aim_cursor = preload("res://Art/gun_aim_icon.png")

func _ready():
	Input.set_custom_mouse_cursor(aim_cursor, Input.CURSOR_ARROW, Vector2(aim_cursor.get_width() / 2, aim_cursor.get_height() / 2))

#func _input(event):
	#if event is InputEventMouseMotion:
		#var mousePos = get_global_mouse_position()
		#position = mousePos
#
	#elif event is InputEventMouseButton:
		#if event.button_index == 1: # if mouse pressed left click
			#pass
