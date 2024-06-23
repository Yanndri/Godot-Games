extends PanelContainer

#var reloading_stylebox : StyleBox = preload("res://Resources/reloading_stylebox_texture2d.tres")

@onready var gun = $"../../Player/Hand/Gun"
@onready var GUI_weapon = $"../GUI weapon"
@onready var player = $"../../Player"

@export var buttons : ButtonGroup

var previous_slot_clicked = null
var previous_gun = null 

# Called when the node enters the scene tree for the first time.
func _ready():
	buttons.get_buttons()[0].button_pressed = true # the 1st slot is clicked automatically
	#for i in buttons.get_buttons().size():
		#buttons.get_buttons()[i].add_theme_stylebox_override("disabled", reloading_stylebox)
	
func _input(event):
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_1):
			buttons.get_buttons()[0].button_pressed = true
		elif Input.is_key_pressed(KEY_2):
			buttons.get_buttons()[1].button_pressed = true
		elif Input.is_key_pressed(KEY_3):
			buttons.get_buttons()[2].button_pressed = true
		elif Input.is_key_pressed(KEY_4):
			buttons.get_buttons()[3].button_pressed = true
		elif Input.is_key_pressed(KEY_5):
			buttons.get_buttons()[4].button_pressed = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if buttons.get_pressed_button() != null:
		var gun_type
		var slot_clicked = buttons.get_pressed_button().get_index()
		match slot_clicked:
			0 : gun_type = "pistol"
			1 : gun_type = "shotgun"
			2 : gun_type = "uzi"
			3 : gun_type = "ak"
			4 : gun_type = "machine_gun"
		gun_changed(gun_type, slot_clicked)
		

func gun_changed(gun_type, slot_clicked):
	if slot_clicked != previous_slot_clicked: # so that it only runs again if other button than the last button is pressed
		#if previous_slot_clicked != null:
			#buttons.get_buttons()[previous_slot_clicked].disabled = true
		gun.change_gun(gun_type)
		player.gun_changed()
		previous_slot_clicked = slot_clicked
		previous_gun = gun_type

