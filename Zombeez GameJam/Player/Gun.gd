extends Sprite2D

@onready var bullet_scene : PackedScene = preload("res://Player/bullet.tscn")
@onready var player = $"../.."
@onready var hand = $".."
@onready var barrel = $Barrel
@onready var GUI_weapon = $"../../../HUD/GUI weapon"
@onready var main = $"../.."

@export var pistol : Resource
@export var shotgun : Resource
@export var uzi : Resource
@export var ak : Resource
@export var machine_gun : Resource

@export var bullet_parent : Marker2D

var gun : Resource

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
var can_shoot : bool = true
var should_shoot : bool

func _input(event):
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_R):
			GUI_weapon.reload_gun()
	if event is InputEventMouseButton:
		if event.button_index == 2: # if mouse pressed left click
			GUI_weapon.reload_gun()

func shoot():
	if can_shoot != true:
		return
	for i in range(gun.bullet_count):
		if should_shoot:
			break
		var bullet = bullet_scene.instantiate()
		bullet.linear_velocity = Vector2(2000, 0).rotated(deg_to_rad(hand.global_rotation_degrees) + randf_range(-gun.spread, gun.spread))
		#bullet_parent.position = barrel.global_position
		bullet.position = barrel.global_position
		bullet.rotation = hand.rotation
		bullet.detect_layer(3) #detects enemies
		bullet_parent.add_child(bullet) # it is important to put the bullet outside the hand so that the hand rotation doesn't affect the bullet
		bullet.shoot(gun)
		barrel.fire()
		if gun.bullet_count != 1:
			player.recoil()
		GUI_weapon.bullet_remaining()
		if gun.bullet_interval > 0:
			await get_tree().create_timer(gun.bullet_interval).timeout # time until the next bullet is shot
	if gun.bullet_count == 1:
		player.recoil()
func should_gun_shoot():
	should_shoot = !should_shoot

func change_gun(gun_data):
	match gun_data.name:
		"pistol": barrel_pos = Vector2(10, -4)
		"shotgun": barrel_pos = Vector2(16, -3)
		"uzi": barrel_pos = Vector2(9, -5)
		"ak": barrel_pos = Vector2(18, -3)
		"machine_Gun": barrel_pos = Vector2(18, -3)
	gun = gun_data
	texture = gun_data.texture
	barrel.position = barrel_pos
	barrel.update_gun(gun_data.name)
	self.update_gun()
	GUI_weapon.change_gun(gun_data)

func update_gun():
	if !starting_load:
		GUI_weapon.instantiated(gun)
		starting_load = true

func gun_shot():
	gun.bullets -= 1
