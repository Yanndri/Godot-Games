extends CharacterBody2D

var SPEED = 50.0
const MAX_SPEED = 30.0
const ACCEL = 2
const JUMP_VELOCITY = -400.0
const SHORT_JUMP = JUMP_VELOCITY / 2

var acceleration_speed = 0

@export var character_animation : AnimationPlayer
@export var character_sprite : Sprite2D
@onready var hand = $Hand
@onready var gun = $Hand/Gun
@onready var barrel = $Hand/Gun/Barrel
@onready var aim_dir = $aim_direction #checks the direction of the mouse
@onready var bullet_scene : PackedScene = preload("res://Player/bullet.tscn")
@onready var bullet = bullet_scene.instantiate()
@onready var HUD = $"../HUD"
@onready var GUI_weapon = $"../HUD/GUI weapon"
@onready var GUI_inventory = $"../HUD/GUI inventory"
@onready var HUD_health_bar = $"../HUD/Health_Bar/HBoxContainer/TextureProgressBar"
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var rate_of_fire = Timer.new()
var recoil_time = Timer.new()

var knockback_resistance = 0.1
var gun_data
var health = 100

var shooting : bool
var recoil_move : bool

func _ready():
	rate_of_fire.one_shot = true
	add_child(rate_of_fire)
	#recoil_time.one_shot = true
	#add_child(recoil_time)

func _input(event):
	if event is InputEventMouseMotion:
		var mousePos = get_global_mouse_position()
		hand.look_at(mousePos)

	if event is InputEventMouseButton:
		if event.button_index == 1 && gun_data != null: # if mouse pressed left click
			shooting = !shooting

func _physics_process(delta):
	if shooting:
		if rate_of_fire.time_left == 0 && gun_data.bullets > 0:
			gun.shoot()
			rate_of_fire.wait_time = gun_data.rate_of_fire
			rate_of_fire.start()
			#recoil()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	#if is_on_floor():
		#if Input.is_action_just_pressed("ui_accept"):
			#velocity.y = JUMP_VELOCITY
	#else:
		#if Input.is_action_just_released("ui_accept") and velocity.y < SHORT_JUMP:
			#velocity.y = SHORT_JUMP
	
	# part of the code to make player have knockback even if moving
	#if recoil_move && recoil_time.time_left == 0:
		#recoil_move = false

	var direction = Input.get_axis("left", "right")
	if direction && !recoil_move: # recoil move is part of the code to make player have knockback even if moving
		if direction > 0:
			acceleration_speed += ACCEL
			velocity.x = min(acceleration_speed, MAX_SPEED) + SPEED
		elif direction < 0:
			acceleration_speed += ACCEL
			velocity.x = max(-acceleration_speed, -MAX_SPEED) + -SPEED
	else:
		acceleration_speed = 0
		velocity.x = lerp(velocity.x, 0.0, knockback_resistance)
	
	update_animation(direction)
	move_and_slide()

func _process(_delta):
	if hand.global_rotation_degrees > -90 && hand.global_rotation_degrees < 90:
		hand.scale.y = 1
		character_sprite.flip_h = false
	else:
		hand.scale.y = -1
		character_sprite.flip_h = true

func update_animation(direction):
	if not is_on_floor() && velocity.y < -50:
		character_animation.play("jumping")
	else:
		if direction || velocity.x > 100 || velocity.x < -100:
			character_animation.play("running")
		else:
			character_animation.play("idle")

func recoil():
	#var distance = aim_dir.position.distance_to(position)
	aim_dir.position = get_local_mouse_position()
	var x = clamp(aim_dir.position.x, -128, 128)
	var y = clamp(aim_dir.position.y, -128, 128)
	aim_dir.position = Vector2(x, y).normalized() * 16 * gun_data.power
	velocity += -aim_dir.position
	
	# part of the code to make player have knockback even if moving
	#recoil_move = true
	#recoil_time.wait_time = 0.1
	#recoil_time.start()
	
	
	#print(-aim_dir.position)
	return -aim_dir.position.x

func gun_changed(gun_tres):
	rate_of_fire.stop()
	gun_data = gun_tres
	rate_of_fire.wait_time = gun_data.rate_of_fire + 0.3
	rate_of_fire.start()

func took_damage(damage):
	health -= damage
	HUD_health_bar.value = health
	if health <= 0:
		death()
	return damage

func death():
	return
	set_physics_process(false)
	set_process(false)
	character_animation.play("death")
	for i in range(8):
		set_collision_layer_value(i + 1, false)
		set_collision_mask_value(i + 1, false)
	set_collision_mask_value(8, true)

func collect_collectable(collectable_data):
	#gun.change_gun(collectable_data)
	hand.visible = true
	GUI_inventory.add_item_inventory(collectable_data)
	gun_changed(collectable_data)
	SPEED = 100
	HUD.visible = true
