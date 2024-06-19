extends CharacterBody2D


const SPEED = 30.0

@onready var zombie_animation = $AnimatedSprite2D

@export var zombie_flying : PackedScene

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player_detected : bool
var attacking_player : bool
var can_update_animation : bool

var player_body

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if player_detected:
		if zombie_animation.animation == "default":
			move_direction(to_local(player_body.position))
		else:
			velocity.x = 0

	move_and_slide()

func player_is_detected(body, TrueOrFalse):
	player_body = body
	player_detected = TrueOrFalse
	can_update_animation = TrueOrFalse

func _process(delta):
	if can_update_animation:
		update_animation()

func move_direction(player_pos):
	if player_pos.x > 0:
		velocity.x = SPEED
	elif player_pos.x < 0:
		velocity.x = -SPEED

func attack_player(TrueOrFalse):
	attacking_player = TrueOrFalse

func damage_player():
	if zombie_animation.animation == "attack" && zombie_animation.frame == 3: # check if the frame is on the attack frame
		return true

func dealt_damage(damage):
	can_update_animation = false
	zombie_animation.play("death")
	await get_tree().create_timer(3).timeout
	zombie_animation.play("revive")

func update_animation():
	if attacking_player:
		zombie_animation.play("attack")
	else:
		if zombie_animation.is_playing() == false:
			zombie_animation.play("default")

func _on_animated_sprite_2d_animation_finished():
	if zombie_animation.animation == "revive":
		zombie_animation.play("detached")

		var flying_zombie = zombie_flying.instantiate()
		flying_zombie.position = self.position
		get_parent().add_child(flying_zombie)
	#if zombie_animation.animation == "detached":
		#await get_tree().create_timer(3).timeout
		#queue_free()

