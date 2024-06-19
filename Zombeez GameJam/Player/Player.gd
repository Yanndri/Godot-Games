extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

@onready var character = $Character
@onready var hand = $Hand
@onready var gun = $Hand/Gun
@onready var barrel = $Hand/Gun/Barrel
@onready var aim_dir = $aim_direction #checks the direction of the mouse
@onready var bullet_scene : PackedScene = preload("res://Player/bullet.tscn")
@onready var bullet = bullet_scene.instantiate()
@onready var GUI_weapon = $"../CanvasLayer/GUI weapon"
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var rate_of_fire = Timer.new()

var knockback_resistance = 0.05

var shooting : bool

func _ready():
	rate_of_fire.one_shot = true
	add_child(rate_of_fire)

func _input(event):
	if event is InputEventMouseMotion:
		var mousePos = get_global_mouse_position()
		hand.look_at(mousePos)

	if event is InputEventMouseButton:
		if event.button_index == 1: # if mouse pressed left click
			shooting = !shooting

func _physics_process(delta):
	if shooting:
		if rate_of_fire.time_left == 0 && GUI_weapon.bullet_remaining() > 0:
			gun.shoot()
			rate_of_fire.wait_time = gun.rate_of_fire
			rate_of_fire.start()
			recoil()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = (direction * SPEED)
	else:
		velocity.x = lerp(velocity.x, 0.0, knockback_resistance)
	
	update_animation(direction)
	move_and_slide()

func _process(_delta):
	if hand.global_rotation_degrees > -90 && hand.global_rotation_degrees < 90:
		hand.scale.y = 1
		character.flip_h = false
	else:
		hand.scale.y = -1
		character.flip_h = true

func update_animation(direction):
	if not is_on_floor() && velocity.y < -50:
		character.animation = "jump"
		character.frame = 1 
	else:
		if direction || velocity.x > 250 || velocity.x < -250:
			character.play("running")
		else:
			character.play("default")

func recoil():
	#var distance = aim_dir.position.distance_to(position)
	aim_dir.position = get_local_mouse_position()
	var x = clamp(aim_dir.position.x, -128, 128)
	var y = clamp(aim_dir.position.y, -128, 128)
	aim_dir.position = Vector2(x, y).normalized() * 16 * gun.power
	velocity += -aim_dir.position
	#print(-aim_dir.position)
	return -aim_dir.position.x

func gun_changed():
	rate_of_fire.stop()
