extends PanelContainer

@export var Disaster_1 : PanelContainer
@export var Disaster_2 : PanelContainer
@export var Disaster_3 : PanelContainer
@export var Simulation : CanvasLayer

var disaster1_data = 0; var disaster2_data = 0; var disaster3_data = 0;
var last_millenium = Counts.millenium

var randoms = []
var disaster_data = []

func _ready():
	randomize()
	dir_contents("res://resources/disaster_data/")
	change_options()
	Counts.disaster_name = disaster1_data.name

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
			disaster_data.append(load(path + file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func change_options():
	var disaster1_changed = false; var disaster2_changed = false; var disaster3_changed = false;
	var random = randi_range(0, disaster_data.size() - 1)
	for i in range(3):
		while randoms.has(random):
			random = randi_range(0, disaster_data.size() - 1)
		randoms.append(random)
		if !disaster1_changed:
			disaster1_data = disaster_data[random]
			Disaster_1.change_data(disaster_data[random])
			disaster1_changed = true
		elif !disaster2_changed:
			disaster2_data = disaster_data[random]
			Disaster_2.change_data(disaster_data[random])
			disaster2_changed = true
		elif !disaster3_changed:
			disaster3_data = disaster_data[random]
			Disaster_3.change_data(disaster_data[random])
			disaster3_changed = true
	print(disaster1_data.name, " ", disaster2_data.name, " ", disaster3_data.name)
	Simulation.disasters(disaster1_data, disaster2_data, disaster3_data)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Counts.millenium != last_millenium:
		last_millenium = Counts.millenium
		var reset_disasters = randoms.size() - disaster_data.size()
		print(randoms.size() - disaster_data.size())
		if reset_disasters >= 0 && reset_disasters < 3:
			print("Reset Disaster")
			randoms = []
		change_options()
		
