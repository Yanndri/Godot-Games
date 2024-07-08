extends Node2D

@export var Pick_UI : CanvasLayer
@export var Disaster_UI : CanvasLayer
@export var Main_Menu : CanvasLayer
@export var Simulation : CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Counts.year = 333
	Counts.evolution_points = 3
	print("Evo pts: ", Counts.evolution_points, " disaster: ", Counts.disaster_name, " millenium: ", Counts.millenium, " year: ", Counts.year)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_plan_pressed():
	Pick_UI.visible = true
	Disaster_UI.visible = false
	Simulation.visible = false

func _on_back_pressed():
	Pick_UI.visible = false
	Disaster_UI.visible = true

func _on_play_pressed():
	Disaster_UI.visible = true
	Main_Menu.visible = false

func _on_confirm_pressed():
	Simulation.visible = true
	Pick_UI.visible = false

func _on_restart_pressed():
	get_tree().reload_current_scene()

