extends Node2D

@onready var player = get_node("Player")
var mirror : PackedScene = preload("res://mirror.tscn")
var enemy : PackedScene = preload("res://enemy.tscn")
var mirror1 = false
var mirror2 = false
var mirrorsPOS = [null, null]
var mirrors = [null, null]
# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("mirror", teleport)
	spawnEnemy()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	restart()
	
func spawnEnemy():
	await get_tree().create_timer(2).timeout
	spawnEnemy()
	var Enemy = enemy.instantiate()
	add_child.call_deferred(Enemy)
	var distance = randi_range(-1, 1)
	while distance == 0:
		distance = randi_range(-1, 1)
	print(distance)
	if distance != 0:
		distance = 300 * distance + player.position.x
		if mirror1 && mirror2:
			var pythagorean1 = sqrt(pow(distance - mirrorsPOS[0].x, 2))
			var pythagorean2 = sqrt(pow(distance - mirrorsPOS[1].x, 2))
			if pythagorean1 > 150 || pythagorean2 > 150:
				Enemy.position.x = distance
		else:
			Enemy.position.x = distance
	print(distance)
	
	#Enemy.position.x =
	

func restart():
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()

func _on_child_exiting_tree(node):
	if node.is_in_group("enemy"):
		var Mirror = mirror.instantiate()
		add_child.call_deferred(Mirror)
		Mirror.position.x = node.position.x
		if !mirror1:
			mirror1 = true
			#mirrorsPOS.append(node.position)
			mirrorsPOS[0] = Mirror.position
			mirrors[0] = Mirror
			print(mirrorsPOS)
			print(mirrors)
		elif mirror1 && !mirror2:
			mirror2 = true
			#mirrorsPOS.append(node.position)
			mirrorsPOS[1] = Mirror.position
			mirrors[1] = Mirror
			print(mirrorsPOS)
			print(mirrors)
		else:
			mirrors[0].queue_free()
			mirrors[0] = mirrors[1]
			mirrors[1] = Mirror
			mirrorsPOS[0] = mirrorsPOS[1]
			mirrorsPOS[1] = Mirror.position
			print(mirrorsPOS)
			print(mirrors)

func teleport():
	if mirror1 && mirror2:
		var pythagorean1 = sqrt(pow(player.position.x - mirrorsPOS[0].x, 2))
		var pythagorean2 = sqrt(pow(player.position.x - mirrorsPOS[1].x, 2))
		if pythagorean1 < 20:
			player.position.x = mirrorsPOS[1].x
		elif pythagorean2 < 20:
			player.position.x = mirrorsPOS[0].x


func _on_player_win():
	$CanvasLayer/CanvasGroup.set_deferred("visible", true)
