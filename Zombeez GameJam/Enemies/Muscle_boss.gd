extends CharacterBody2D

const SPEED = 30.0

@export var zombie_sprite : Sprite2D
@export var zombie_animation : AnimationPlayer
@export var zombie_flying : PackedScene

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player_detected : bool # detect if player on vicinity
var attacking_player : bool # detect if it is attacking
var can_update_animation : bool = true
var is_near_spawn : bool
var can_move : bool = true

var direction = 1
var player_body 
var spawn_location : Vector2

func _ready():
	player_body = Vector2(500, 0)
	spawn_location = position

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if player_detected:
		if can_move:
			movement(to_local(player_body.position).x)
		else:
			velocity.x = 0
	else:
		if can_move:
			wander()
		else:
			velocity.x = 0

	move_and_slide()

func _process(_delta):
	if can_update_animation: # will not update animation for conditions like death, etc.
		update_animation()
		change_facing_direction()

func wander():
	if position.distance_to(spawn_location) > 200: # checks if distance to spawn is more than 100
		is_near_spawn = false
		movement(-(position.x - spawn_location.x))
	else:
		if !is_near_spawn:
			movement(-(position.x - spawn_location.x))
			is_near_spawn = true

func movement(target_pos):
	if target_pos > 0:
		velocity.x = SPEED
		direction = -1
	elif target_pos < 0:
		velocity.x = -SPEED
		direction = 1

func player_is_detected(body, TrueOrFalse):
	player_body = body
	player_detected = TrueOrFalse
	if TrueOrFalse == false && can_update_animation:
		zombie_animation.queue("RESET")
		await get_tree().create_timer(2).timeout
		zombie_animation.queue("running")
		can_move = true
		is_near_spawn = false # will move if it is not near its spawn location

func attack(TrueOrFalse):
	attacking_player = TrueOrFalse
	print("attacking player")

func dealt_damage():
	print("damaged player")

func damage_player():
	if zombie_animation.current_animation == "attack": # check if the frame is on the attack frame
		return true

func took_damage(_damage):
	zombie_animation.play("death")

func change_facing_direction():
	zombie_sprite.flip_h = direction == -1
	get_node("%detection").scale.x = direction
	get_node("%attack").scale.x = direction
	get_node("%health").scale.x = direction

func update_animation():
	if zombie_animation.current_animation == "death":
		can_update_animation = false
		can_move = false
		
		# disable area detections
		get_node("%detection").turn_off() 
		get_node("%attack").turn_off()
		get_node("%health").turn_off()
		for i in range(32): 
			#print(get_collision_mask_value(i + 1))
			if get_collision_mask_value(i + 1) == true || get_collision_layer_value(i + 1) == true:
				set_collision_mask_value(i + 1, false)
				set_collision_layer_value(i + 1, false)
		set_collision_mask_value(8, true)
		
		await get_tree().create_timer(3).timeout
		zombie_animation.play("revive")
		return
	
	if zombie_animation.current_animation == "attack":
		can_move = false
	elif zombie_animation.current_animation == "running":
		can_move = true

	if attacking_player:
		zombie_animation.play("attack")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "revive":
		zombie_animation.play("detach")
		var flying_zombie = zombie_flying.instantiate()
		flying_zombie.position = self.position
		get_parent().add_child(flying_zombie)
	if anim_name == "attack":
		zombie_animation.play("running")
