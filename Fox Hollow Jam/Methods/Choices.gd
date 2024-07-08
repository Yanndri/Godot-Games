extends Control

@export var option1 : PanelContainer
@export var option2 : PanelContainer
@export var option3 : PanelContainer
@export var reroll : Button
@export var confirm : Button
@export var Simulation : CanvasLayer

@export var button_options : ButtonGroup

var option1_value = 0; var option2_value = 0; var option3_value = 0;

var creature_data = []
var creature_chose : Resource

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
			creature_chose = creature_data[option1_value]
		elif button_method == "Button_2":
			creature_chose = creature_data[option2_value]
		elif button_method == "Button_3":
			creature_chose = creature_data[option3_value]
		confirm.disabled = false
	else:
		confirm.disabled = true
	
	if Counts.evolution_points <= 1:
		reroll.disabled = true
	else:
		reroll.disabled = false

func _on_confirm_pressed():
	print("Confirm :", creature_chose.name)
	Simulation.creature(creature_chose)

func _on_reroll_pressed():
	change_options()
	Counts.evolution_points -= 1

func return_creature_chose():
	return creature_chose
