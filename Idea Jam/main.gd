extends Node2D

@onready var player : CharacterBody2D = $Player
@onready var camera : Camera2D = $Camera2D
@onready var explosion = $TileMap/Explosion
@onready var light : DirectionalLight2D = $TileMap/DirectionalLight2D
@onready var timer : Timer = $Timer
@onready var lever = $Lever
@onready var tilemap = $TileMap
@onready var tile_lava = $TileMap/LavaTiles
@onready var paper = $Paper
@onready var PaperPanel : PanelContainer = $CanvasLayer/Control/PaperPanel
@onready var dayCount : Label = $CanvasLayer/Control/Day/Count
@onready var darkness : CanvasModulate = $Darkness
@onready var audioPlayer : AudioStreamPlayer2D = $SFX
@onready var BGMusicPlayer : AudioStreamPlayer = $BGMusic

const BGMusic = preload("res://Audio/cute-creatures-150622.mp3")
const doorOpenSound = preload("res://Audio/dorm-door-opening-6038.mp3")
const explosionSound = preload("res://Audio/dynamite-205859.mp3")
const paperSound = preload("res://Audio/Turning-Paper-Book-Page-Med-Speed-A2-www.fesliyanstudios.com-www.fesliyanstudios.com.mp3")

var cutscene : bool
var room_opened : bool
var exit_opened : bool
var lever_teleport : bool
var floor_is_lava : bool
var dark : bool

var day = 0
var max_rules = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_lava.set_layer_enabled(0, false)
	tile_lava.visible = false
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event is InputEventMouseMotion:
		print(event.position)
	
	if player.position.y < -77 && !cutscene:
		cutscene = true
		camera.position = Vector2(327, -6)
		player.position = Vector2(141, -27)
		player.play_cutscene(true)
	if event is InputEventKey and event.pressed:
		
		if event.keycode == KEY_E && !room_opened:
			if tilemap.get_cell_atlas_coords(1, Vector2i(-4, -1)) == Vector2i(3, 3):
				audioPlayer.stream = paperSound
				audioPlayer.play()
				audioPlayer.stream = doorOpenSound
				audioPlayer.play()
				room_opened = true
				print("rules: ", day)
				rules(day)
				PaperPanel.change_rules(day, lever_teleport, floor_is_lava, dark)
				day+= 1
		elif tilemap.get_cell_atlas_coords(1, Vector2i(-4, -1)) == Vector2i(3, 1):
			room_opened = false
		if event.keycode == KEY_E && !exit_opened:
			if tilemap.get_cell_atlas_coords(1, Vector2i(-1, -5)) == Vector2i(3, 3):
				audioPlayer.stream = doorOpenSound
				audioPlayer.play()
		elif tilemap.get_cell_atlas_coords(1, Vector2i(-1, -5)) == Vector2i(3, 1):
				exit_opened = false
			

func cutscene_finished():
	await get_tree().create_timer(2).timeout
	var tween = create_tween()
	audioPlayer.stream = explosionSound
	audioPlayer.play(2.5)
	explosion.frame = 0
	explosion.play("default")
	tween.parallel().tween_property(explosion, "scale", Vector2(8, 8), 2.5)
	tween.parallel().tween_property(light, "color:a", 200, 120)
	if tween.finished:
		await get_tree().create_timer(2.5).timeout
		camera.position = Vector2.ZERO
		await get_tree().create_timer(0.5).timeout
		tween.stop()
		lever_teleport = false
		floor_is_lava = false
		player.position = Vector2(-88, -50)
		camera.position = Vector2.ZERO
		light.color.a = 0
		explosion.scale = Vector2.ZERO
		dayCount.text = "Day "
		dayCount.text += str(day + 1)
		lever.reset()
		paper.reset()
		player.reset()
		darkness.visible = false
		cutscene = false
		player.play_cutscene(false)

func rules(rule_count):
	lever_teleport = false
	floor_is_lava = false
	dark = false
	var teleport_time = 1.5
	var rules = []
	if rule_count > max_rules:
		rule_count = max_rules
	var rules_chance = 0
	for i in range(rule_count):
		#var rules_chance = randi_range(1, rule_count)
		#
		#for j in range(i):
			#while rules[j] == rules_chance:
				#print("while ", j, " ", rules[j], " == ", rules_chance)
				#rules_chance = randi_range(1, rule_count)
				#print("new rules: ", rules_chance)
				#
		rules_chance += 1
		rules.append(rules_chance)
		print(rules)
		
		if rules_chance == 1 && !lever_teleport:
			print("lever teleports")
			lever.teleport(teleport_time)
			lever_teleport = true
		if rules_chance == 2 && !floor_is_lava:
			print("The floor is lava")
			floor_is_lava = true
			floor_lava()
		if rules_chance == 3 && !dark:
			print("Darkness")
			darkness.visible = true
			dark = true
			teleport_time = 20
			if lever_teleport:
				lever.teleport(teleport_time)
			player.darkness(true)

func floor_lava():
	if floor_is_lava == false:
		tile_lava.set_layer_enabled(0, false)
		tile_lava.visible = false
		return
	tile_lava.set_layer_enabled(0, true)
	tile_lava.visible = true
	await get_tree().create_timer(2).timeout
	tile_lava.set_layer_enabled(0, false)
	tile_lava.visible = false
	await get_tree().create_timer(3).timeout
	floor_lava()

func reset():
	day = 0
	dayCount.text = "Day "
	dayCount.text += str(day + 1)
	darkness.visible = false
	lever.reset()
	paper.reset()
	player.reset()
	rules(day)

func _on_bg_music_finished():
	BGMusicPlayer.stream = BGMusic
	BGMusicPlayer.play()

