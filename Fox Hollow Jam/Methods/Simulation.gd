extends CanvasLayer

@export var Disaster_Simulation : PanelContainer
@export var Creature_texture : Sprite2D
@export var animation_walk : AnimationPlayer
@export var animation_points : AnimationPlayer

var disasters_data = []
var creature_data = []

var ctr = 0
var extinction_rate = 0
var extinction_multiplier = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		Counts.disaster_name = disasters_data[ctr].name
		Disaster_Simulation.change_data(disasters_data[ctr])

func disasters(disaster1_data, disaster2_data, disaster3_data):
	ctr = 0
	disasters_data = []
	disasters_data.append(disaster1_data)
	disasters_data.append(disaster2_data)
	disasters_data.append(disaster3_data)

func creature(creature_chose): # when user clicked Confirm and chose a creature
	creature_data = creature_chose
	Creature_texture.texture = creature_data.texture
	run_simulation()

func run_simulation():
	extinction_rate = 0
	extinction_multiplier = 0
	if disasters_data[ctr].can_swim:
		extinction_multiplier += 1
		if creature_data.can_swim:
			print("can_swim")
			extinction_rate -= 33
		else:
			extinction_rate += 33
	if disasters_data[ctr].can_fly:
		extinction_multiplier += 1
		if creature_data.can_fly:
			print("can_fly")
			extinction_rate -= 33
		else:
			extinction_rate += 33
	if disasters_data[ctr].is_strong:
		extinction_multiplier += 1
		if creature_data.is_strong:
			print("is_strong")
			extinction_rate -= 33
		else:
			print("died due to lack of strength")
			extinction_rate += 33
	if disasters_data[ctr].is_fast:
		extinction_multiplier += 1
		if creature_data.is_fast:
			print("is_fast")
			extinction_rate -= 33
		else:
			print("wasn't fast enough")
			extinction_rate += 33
	if disasters_data[ctr].cold_resistant:
		extinction_multiplier += 1
		if creature_data.cold_resistant:
			print("cold_resistant")
			extinction_rate -= 33
		else:
			print("lost to cold temperature")
			extinction_rate += 33
	if disasters_data[ctr].heat_resistant && creature_data.heat_resistant:
		extinction_multiplier += 1
		if creature_data.heat_resistant:
			print("heat_resistant")
			extinction_rate -= 33
		else:
			print("lost to heat temperature")
			extinction_rate += 33
	if disasters_data[ctr].low_appetite: 
		extinction_multiplier += 1
		if creature_data.low_appetite:
			print("low_apettite")
			extinction_rate -= 33
		else:
			print("lost due to hunger")
			extinction_rate += 33
	
	if disasters_data[ctr].freeze_immune:
		if creature_data.freeze_immune:
			print("freeze_immune")
			extinction_rate -= 33
	if disasters_data[ctr].lava_immune:
		if creature_data.lava_immune:
			print("lava_immune")
			extinction_rate -= 33
	
	var survival_rate = randi_range(0, 33 * extinction_multiplier)
	print(survival_rate, " ", extinction_rate, " ", extinction_multiplier)
	if survival_rate < extinction_rate:
		animation_walk.play("walk_death")
	else:
		animation_walk.play("walk")

func survived():
	Counts.year += 333
	ctr += 1
	if Counts.year > 999:
		animation_points.play("point")
		Counts.year = 333
		Counts.millenium += 1
		Counts.evolution_points += 1
	animation_walk.play("back")


func _on_proceed_pressed():
	run_simulation()
