class_name Barrel
extends Marker2D

@onready var bullet_scene : PackedScene = preload("res://Player/bullet.tscn")

var hand = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	shoot(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func shoot(hand_rotation_degrees):
	var bullet = bullet_scene.instantiate()
	bullet.linear_velocity = Vector2(2 * 1000, 0).rotated(deg_to_rad(hand_rotation_degrees) + randf_range(-0.2, 0.2))
	add_child(bullet)
