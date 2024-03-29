extends CharacterBody2D

@export var smoke : PackedScene
const smokesfx = preload("res://music/audiomass-output.mp3")
const SPEED = 50.0
var attacking = false
var teleported = false
var smokeoutput = 0
signal mirror
signal win

@onready var playerSprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Change Direction Facing
	var direction = Input.get_axis("ui_left", "ui_right")
	if Input.is_action_just_pressed("ui_right"):
		scale.y = 1.0
		rotation = 0
	elif Input.is_action_just_pressed("ui_left"):
		scale.y = -1.0
		rotation = 22.0 # flip sprite
	if direction != 0:
		playerSprite.play("running")
		velocity.x = direction * SPEED
		if attacking:
			playerSprite.play("running")
			velocity.x = direction * (SPEED/2)
	else:
		if attacking:
			playerSprite.play("attack")
		else:
			playerSprite.play("default")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	Attack(direction)

	move_and_slide()

func Attack(direction):
	if Input.is_key_pressed(KEY_F):
		if smokeoutput > 30:
			await get_tree().create_timer(1).timeout
			smokeoutput = 0
		else:
			$AudioStreamPlayer2D.stream = smokesfx
			$AudioStreamPlayer2D.play()
			attacking = true
			var blacksmoke = smoke.instantiate()
			add_child(blacksmoke)
			smokeoutput += 1
	else:
		attacking = false

func _on_detect_area_entered(area):
	if area.is_in_group("mirror"):
		if teleported:
			await get_tree().create_timer(1).timeout
			teleported = false
		elif !teleported:
			emit_signal("mirror")
			teleported = true
	elif area.is_in_group("enemy"):
		await get_tree().create_timer(1).timeout
		get_tree().reload_current_scene()
	elif area.is_in_group("finish"):
		emit_signal("win")
