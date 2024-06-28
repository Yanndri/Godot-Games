extends PanelContainer

#var reloading_stylebox : StyleBox = preload("res://Resources/reloading_stylebox_texture2d.tres")

@onready var gun = $"../../Player/Hand/Gun"
@onready var GUI_weapon = $"../GUI weapon"
@onready var player = $"../../Player"

@export var pistol : Resource
@export var shotgun : Resource
@export var uzi : Resource
@export var ak : Resource
@export var machine_gun : Resource

@export var buttons : ButtonGroup

var previous_slot_clicked = null
var previous_gun = null 

var inventory = []

func _ready():
	add_item_inventory(pistol)
	add_item_inventory(uzi)

func add_item_inventory(collectable_data):
	inventory.append(collectable_data)
	update_inventory()

func update_inventory():
	var i = 0
	for item in inventory:
		buttons.get_buttons()[i].icon = item.texture
		buttons.get_buttons()[i].visible = true
		buttons.get_buttons()[i].button_pressed = true
		i += 1

# Called when the node enters the scene tree for the first time.
#func _ready():
	#buttons.get_buttons()[0].icon = ak.texture
	#pass
	#buttons.get_buttons()[0].button_pressed = true # the 1st slot is clicked automatically
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
		var slot_clicked = buttons.get_pressed_button().get_index()
		if buttons.get_buttons()[slot_clicked].visible != true:
			return
		gun.should_gun_shoot()
		var gun_data = inventory[slot_clicked]
		#var gun_data = uzi
		gun_changed(gun_data, slot_clicked)
		gun.should_gun_shoot()

func gun_changed(gun_data, slot_clicked):
	if slot_clicked != previous_slot_clicked: # so that it only runs again if other button than the last button is pressed
		#if previous_slot_clicked != null:
			#buttons.get_buttons()[previous_slot_clicked].button_pressed = false
		gun.change_gun(gun_data)
		player.gun_changed(gun_data)
		previous_slot_clicked = slot_clicked
		previous_gun = gun_data
