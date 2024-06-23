extends Sprite2D

@onready var bullet_scene : PackedScene = preload("res://Player/bullet.tscn")
@onready var barrel = $barrel
@onready var bullet_parent = $barrel/bullets

var bullet_type = preload("res://Art/Zombeez Assets/bullets/drone_bullet.png")
var damage = 20
var spread = 0
var bullet_life_time = 3

func shoot():
	var bullet = bullet_scene.instantiate()
	#bullet.damage = damage
	bullet.linear_velocity = Vector2(300, 0).rotated(deg_to_rad(global_rotation_degrees) + randf_range(-spread, spread))
	bullet.position = barrel.global_position
	bullet.rotation = self.rotation
	bullet_parent.add_child(bullet) # it is important that the rotation doesn't affect the bullet, 
									#so either put the bullet_parent on top_level in the Inspector, or put it outside the rotation
	bullet.shoot(bullet_life_time, bullet_type)
