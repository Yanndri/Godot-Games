extends Sprite2D

@onready var bullet_scene : PackedScene = preload("res://Player/bullet.tscn")
@onready var hand = $".."
@onready var barrel = $Barrel
@onready var GUI_weapon = $"../../../CanvasLayer/GUI weapon"
@onready var main = $"../.."

@export var pistol : Resource
@export var shotgun : Resource
@export var uzi : Resource
@export var ak : Resource
@export var machine_gun : Resource

@export var bullet_parent : Marker2D

var gun : Resource = load("res://Resources/pistol.tres")

var starting_load : bool
var weight
var power
var rate_of_fire
var max_ammo
var spread
var bullet_life_time
var bullet_count = 1

var bullet_type
var barrel_pos : Vector2

func shoot():
	for i in range(bullet_count):
		var bullet = bullet_scene.instantiate()
		bullet.damage = gun.damage
		bullet.linear_velocity = Vector2(2 * 1000, 0).rotated(deg_to_rad(hand.global_rotation_degrees) + randf_range(-spread, spread))
		bullet.position = barrel.global_position
		bullet.rotation = hand.rotation
		bullet_parent.add_child(bullet) # it is important to put the bullet outside the hand so that the hand rotation doesn't affect the bullet
		bullet.shoot(bullet_life_time, gun.bullet)
		barrel.fire()

func change_gun(gun_type):
	if gun_type == "shotgun":
		bullet_count = 8
	else:
		bullet_count = 1
	match gun_type:
		"pistol": 
			gun = pistol
			barrel_pos = Vector2(10, -4)
		"shotgun": 
			gun = shotgun
			barrel_pos = Vector2(16, -4)
		"uzi": 
			gun = uzi
			barrel_pos = Vector2(9, -5)
		"ak": 
			gun = ak
			barrel_pos = Vector2(18, -3)
		"machine_gun": 
			gun = machine_gun
			barrel_pos = Vector2(18, -3)
	texture = gun.texture
	barrel.position = barrel_pos
	barrel.update_gun(gun_type)
	update_gun()
	GUI_weapon.change_gun(gun.texture, gun)

func update_gun():
	weight = gun.weight
	power = gun.power
	rate_of_fire = gun.rate_of_fire
	max_ammo = gun.max_ammo
	spread = gun.spread
	bullet_life_time = gun.bullet_life_time
	if !starting_load:
		GUI_weapon.reload_gun()
		starting_load = true

func gun_shot():
	gun.bullet_count -= 1
