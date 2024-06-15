extends Sprite2D

@onready var bullet_scene : PackedScene = preload("res://Player/bullet.tscn")
@onready var barrel = $Gun/Barrel
@onready var rate_of_fire = $rate_of_fire

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.linear_velocity = Vector2(2 * 1000, 0).rotated(deg_to_rad(global_rotation_degrees) + randf_range(-0.2, 0.2))
	barrel.add_child(bullet)
