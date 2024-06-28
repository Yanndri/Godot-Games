extends Sprite2D

@onready var bullet_scene : PackedScene = preload("res://Player/bullet.tscn")
@onready var barrel = $barrel
@onready var bullet_parent = $barrel/bullets

@export var drone : Resource = null

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.linear_velocity = Vector2(300, 0).rotated(deg_to_rad(global_rotation_degrees) + randf_range(-drone.spread, drone.spread))
	bullet.position = barrel.global_position
	bullet.rotation = self.rotation
	bullet.detect_layer(5)
	bullet_parent.add_child(bullet) # it is important that the rotation doesn't affect the bullet, 
									#so either put the bullet_parent on top_level in the Inspector, or put it outside the rotation
	bullet.shoot(drone) # shoot(time until it frees itself, type of bullet, bullet damage)
