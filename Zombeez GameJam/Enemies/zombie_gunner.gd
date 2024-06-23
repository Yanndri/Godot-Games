extends CharacterBody2D

@export var zombie_animation : AnimationPlayer
@export var zombie_sprite : Sprite2D

const SPEED = 20.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player_detected : bool # detect if player on vicinity
var attacking_player : bool # detect if it is attacking
var can_update_animation : bool = true

var rate_of_fire = Timer.new()
var player_body
var near_player : bool

func _ready():
	rate_of_fire.one_shot = true
	add_child(rate_of_fire)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

func _process(_delta):
	if player_detected:
		gun_direction()
		change_facing_direction()
		if near_player:
			if rate_of_fire.time_left == 0:
				velocity.x = 0
				get_node("%drone_gun").shoot()
				zombie_animation.play("attack")
				rate_of_fire.wait_time = 3
				rate_of_fire.start()
		if attacking_player:
			velocity.x = 0
		else:
			zombie_animation.play("walking")
			movement(to_local(player_body.position).x)

func movement(target_pos):
	if target_pos > 0:
		velocity.x = SPEED
	elif target_pos < 0:
		velocity.x = -SPEED

func player_is_detected(body, TrueOrFalse):
	player_body = body
	player_detected = TrueOrFalse
	near_player = TrueOrFalse

func attack(TrueOrFalse):
	attacking_player = TrueOrFalse
	print("attacking player")

func dealt_damage():
	print("damaged player")

func took_damage(_damage):
	pass

func change_facing_direction():
	var direction = 1
	if to_local(player_body.position).x > 0:
		direction = 1
	elif to_local(player_body.position).x < 0:
		direction = -1
	zombie_sprite.scale.x = direction
	get_node("%detection").scale.x = direction
	get_node("%attack").scale.x = direction
	get_node("%health").scale.x = direction

func gun_direction():
	var aim_dir = get_node("%aim_direction")
	aim_dir.position = to_local(Vector2(player_body.position.x, player_body.position.y))
	var x = clamp(aim_dir.position.x, -128, 128)
	var y = clamp(aim_dir.position.y, -128, 128)
	aim_dir.position = Vector2(x, y).normalized() * 1000
	get_node("%drone_gun").look_at(aim_dir.global_position)
