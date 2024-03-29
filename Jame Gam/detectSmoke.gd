extends Area2D

var mushroom : PackedScene = preload("res://mushroom.tscn")
var mirror = "res://art/mirrorv1.png"
var attacked = false
var playerDetected = false
@onready var texture : AnimatedSprite2D = $AnimatedSprite2D
@onready var player : CharacterBody2D = $"../Player"

func _ready():
	position.y = 29


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#player.position = player.global_position
	#print(player.position)
	if playerDetected && !attacked:
		#var playerPOS = to_local(nav_agent.get_next_path_position())
		var pythagorean = sqrt(pow(player.position.x - position.x, 2))
		if pythagorean < 5:
			texture.play("attack")
		else:
			texture.play("running")
			var speed = randf_range(0.3, 1.5)
			if player.position.x > position.x: #right
				texture.flip_h = false
				position.x += speed
			elif player.position.x < position.x: #left
				position.x -= speed
				texture.flip_h = true



func _on_area_entered(area):
	if area.is_in_group("smoke") && !attacked:
		attacked = true
		texture.visible = false
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)
		var mushrooms = mushroom.instantiate()
		add_child(mushrooms)
		await get_tree().create_timer(1).timeout
		self.queue_free()
		#get_tree().change_scene_to_file("res://mushroom.tscn")
		
func _on_detect_player_body_entered(body):
	if body.is_in_group("player"):
		playerDetected = true
		#var tween = get_tree().create_tween()
		#tween.tween_property(self, "position", Vector2(player.position.x, self.position.y), 1)
 
func _on_detect_player_body_exited7(body):
	if body.is_in_group("player"):
		playerDetected = false
