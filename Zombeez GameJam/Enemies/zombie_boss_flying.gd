extends CharacterBody2D

const SPEED = 50.0
const ACCEL = 10.0

@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var zombie_animation = $AnimatedSprite2D
@onready var timer = Timer.new()

var player_detected : bool
var attacking_player : bool
var can_update_animation : bool

var player_body

func _ready():
	add_child(timer)
	#nav_agent.target_position = Vector2(-100, -100)
	print(nav_agent)

func _physics_process(delta):
	if player_detected:
		position += (player_body.position - position).normalized()
	#velocity = to_local(nav_agent.get_next_path_position()).normalized() * SPEED
	#print(velocity)
	move_and_slide()

func instantiated(TrueOrFalse):
	timer.autostart = TrueOrFalse
	if TrueOrFalse == false:
		return
	timer.wait_time = 1
	if timer.timeout:
		_on_timer_timeout()

func _on_timer_timeout():
	print(player_body.position)
	nav_agent.target_position = player_body.position

func player_is_detected(body, TrueOrFalse):
	player_body = body
	player_detected = TrueOrFalse
	can_update_animation = TrueOrFalse
	instantiated(TrueOrFalse)

func _process(delta):
	if can_update_animation:
		update_animation()

func attack_player(TrueOrFalse):
	attacking_player = TrueOrFalse

func damage_player():
	if zombie_animation.animation == "attack" && zombie_animation.frame != 1: # check if the frame is on the attack frame
		return true

func dealt_damage(damage):
	print("DEAD Flying zombie")
	#can_update_animation = false
	#zombie_animation.play("death")
	#await get_tree().create_timer(3).timeout
	#zombie_animation.play("revive")

func update_animation():
	if attacking_player:
		zombie_animation.play("attack")
	else:
		if zombie_animation.is_playing() == false:
			zombie_animation.play("default")
