extends Control

@onready var option1 = get_node("%Option 1")
@onready var option2 = get_node("%Option 2")
@onready var option3 = get_node("%Option 3")

@export var button_options : ButtonGroup

var option1_value = 0; var option2_value = 0; var option3_value = 0;

var creature_data = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	dir_contents("res://resources/creature_data/")
	change_options()

func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
			creature_data.append(load(path + file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func change_options():
	var option1_changed = false; var option2_changed = false; var option3_changed = false;
	var randoms = []
	var random = randi_range(0, creature_data.size() - 1)
	for i in range(creature_data.size()):
		while randoms.has(random):
			random = randi_range(0, creature_data.size() - 1)
		randoms.append(random)
		if !option1_changed:
			option1.change_data(creature_data[random])
			option1_changed = true
			option1_value = random
		elif !option2_changed:
			option2.change_data(creature_data[random])
			option2_changed = true
			option2_value = random
		elif !option3_changed:
			option3.change_data(creature_data[random])
			option3_changed = true
			option3_value = random
	print(randoms)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if button_options.get_pressed_button() != null:
		var pressed_button = str(button_options.get_pressed_button())
		var split_text = pressed_button.split(':') # splits texts that has ':' in between
		var button_method = str(split_text[0]) # access the first splitted text
		if button_method == "Button_1":
			print(creature_data[option1_value].name)
		elif button_method == "Button_2":
			print(creature_data[option2_value].name)
		elif button_method == "Button_3":
			print(creature_data[option3_value].name)
