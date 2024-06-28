extends CharacterBody2D

const SPEED = 50.0
const ACCEL = 10.0

@export var zombie_sprite : Sprite2D
@export var zombie_animation : AnimationPlayer
@export var hit_flash_effect : AnimationPlayer
@export var enemy_data : Resource

@onready var timer = Timer.new()

var player_detected : bool # detect if player on vicinity
var attacking_player : bool # detect if it is attacking
var can_update_animation : bool = true
var return_to_spawn : bool

var player_body
var spawn_location : Vector2


func _ready():
	spawn_location = position

func _physics_process(_delta):
	change_facing_direction()
	if player_detected:
		#zombie_sprite.look_at(-to_local(player_body.position))
		return_to_spawn = false
		var y = clamp(to_local(player_body.position).y - position.y, to_local(player_body.position).y - 100, to_local(player_body.position).y + 100)
		var x = clamp(to_local(player_body.position).x - position.x, to_local(player_body.position).x - 100, to_local(player_body.position).x + 100)
		velocity += Vector2(x, y).normalized()
	else:
		if return_to_spawn && position.distance_to(spawn_location) > 100:
			velocity = (spawn_location - position).normalized() * SPEED
		else:
			velocity = Vector2(lerp(velocity.x, 0.0, 0.1), 0)
			if velocity.y == 0:
				return_to_spawn = true

	move_and_slide()

func instantiated(TrueOrFalse):
	pass

func _on_timer_timeout():
	pass

func player_is_detected(body, TrueOrFalse):
	player_body = body
	player_detected = TrueOrFalse
	instantiated(TrueOrFalse)

func _process(_delta):
	if can_update_animation:
		update_animation()

func attack(TrueOrFalse):
	attacking_player = TrueOrFalse

func damage_player():
	#if zombie_animation.animation == "attack" && zombie_animation.frame != 1: # check if the frame is on the attack frame
		#return true
	pass

func dealt_damage():
	pass

func took_damage(damage):
	damage = floor(damage / enemy_data.ARMOR)
	enemy_data.HEALTH -= damage
	hit_flash_effect.play("hit")
	if enemy_data.HEALTH <= 0:
		death()
	return damage

func change_facing_direction():
	var direction
	if velocity.x > 0:
		direction = -1
	else:
		direction = 1
	zombie_sprite.flip_h = direction == -1
	get_node("%detection").scale.x = direction
	get_node("%attack").scale.x = direction
	get_node("%health").scale.x = direction

func update_animation():
	if attacking_player:
		zombie_animation.play("attack")
	else:
		if zombie_animation.is_playing() == false:
			zombie_animation.play("flying")

func death():
	set_physics_process(false)
	set_process(false)
	zombie_animation.play("death")
	#queue_free()
