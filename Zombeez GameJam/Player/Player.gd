extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

@onready var character = $Character
@onready var hand = $Hand
@onready var gun = $Hand/Gun
@onready var barrel = $Hand/Gun/Barrel
@onready var marker = $Marker2D #checks the direction of the mouse
@onready var bullet_scene : PackedScene = preload("res://Player/bullet.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var shooting : bool

func _input(event):
	if event is InputEventMouseMotion:
		var mousePos = get_global_mouse_position()
		hand.look_at(mousePos)

	if event is InputEventMouseButton:
		if event.button_index == 1:
			shooting = !shooting
	#if event is InputEventKey:
		#if event.keycode == KEY F:
			

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.1)
			#velocity.x = move_toward(velocity.x, 0, SPEED)
	
	update_animation(direction)
	move_and_slide()

func _process(delta):
	
	if shooting:
		hand.shoot()
		jetpack()
	if hand.global_rotation_degrees > -90 && hand.global_rotation_degrees < 90:
		character.flip_h = false
		#hand.scale.y = 1
		#scale.y = 1
		#rotation = 0
	else:
		character.flip_h = true
		#hand.scale.y = -1
		#scale.y = -1
		#rotation = 22

func update_animation(direction):
	if not is_on_floor() && velocity.y < -20:
		character.animation = "jump"
		character.frame = 1 
	else:
		if direction:
			character.play("running")
		else:
			character.play("default")
	

#func shoot():
	#var bullet = bullet_scene.instantiate()
	#bullet.linear_velocity = Vector2(2 * 1000, 0).rotated(deg_to_rad(hand.global_rotation_degrees) + randf_range(-0.2, 0.2))
	#barrel.add_child(bullet)

func jetpack():
	var distance = marker.position.distance_to(position)
	marker.position = get_local_mouse_position()
	var x = clamp(marker.position.x, -128, 128)
	var y = clamp(marker.position.y, -128, 128)
	marker.position = Vector2(x / 2, y).normalized() * 20
	velocity += -marker.position
