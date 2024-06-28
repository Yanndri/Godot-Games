extends CharacterBody2D


const SPEED = 10.0
const JUMP_VELOCITY = -400.0

@export var zombie_sprite : Sprite2D
@export var zombie_animation : AnimationPlayer
@export var hit_flash_effect : AnimationPlayer
@export var enemy_data : Resource

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player_detected : bool
var attacking_player : bool

var direction = 1
var player_body

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if player_detected:
		if !attacking_player:
			movement(to_local(player_body.position).x)
		else:
			zombie_animation.play("attack")
			velocity.x = 0
	else:
		zombie_animation.play("idle")
		velocity.x = 0

	change_facing_direction()
	move_and_slide()

func movement(target_pos):
	zombie_animation.play("running")
	if target_pos > 0:
		velocity.x = enemy_data.SPEED
		direction = -1
	elif target_pos < 0:
		velocity.x = -enemy_data.SPEED
		direction = 1

func player_is_detected(body, TrueOrFalse):
	player_body = body
	player_detected = TrueOrFalse

func attack(TrueOrFalse):
	attacking_player = TrueOrFalse

func dealt_damage():
	pass

func damage_player():
	pass

func took_damage(damage):
	damage = floor(damage / enemy_data.ARMOR)
	enemy_data.HEALTH -= damage
	hit_flash_effect.play("hit")
	if enemy_data.HEALTH <= 0:
		death()
	return damage

func death():
	set_process(false)
	set_physics_process(false)
	zombie_animation.play("death")

func change_facing_direction():
	zombie_sprite.flip_h = direction == -1
	get_node("%detection").scale.x = direction
	get_node("%attack").scale.x = direction
	get_node("%health").scale.x = direction
