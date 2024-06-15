extends CharacterBody2D

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var timer : Timer = $"../Timer"
@onready var main = $".."
@onready var flashlight : PointLight2D = $PlayerLight/Flashlight
@onready var playerlight : PointLight2D = $PlayerLight

const SPEED = 70.0

var blending_position : Vector2 = Vector2.ZERO
var cutscene_is_playing : bool
var main_cutscene : bool

var iteration = 0

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	if cutscene_is_playing:
		cutscene()
	else:
		movement()
	update_light()

func movement():
	var direction = Input.get_vector("Left", "Right", "Up", "Down").normalized()
	if direction:
		velocity = direction * SPEED
		blending_position = direction
	else:
		velocity = Vector2.ZERO
	animation_tree.set("parameters/conditions/is_idle", direction == Vector2.ZERO)
	animation_tree.set("parameters/conditions/is_running", direction != Vector2.ZERO)
	animation_tree.set("parameters/Running/blend_position", blending_position)
	animation_tree.set("parameters/Default/blend_position", blending_position)

func update_light():
	if blending_position == Vector2(0, 1):
		flashlight.rotation_degrees = 0
	elif blending_position == Vector2(0, -1):
		flashlight.rotation_degrees = 180
	else:
		var facing_direction = 45
		if blending_position.x > 0:
			flashlight.rotation_degrees = 270
		elif blending_position.x < 0:
			flashlight.rotation_degrees = 90
			facing_direction = -facing_direction
		if blending_position.y > 0:
			flashlight.rotation_degrees += facing_direction
		elif blending_position.y < 0:
			flashlight.rotation_degrees -= facing_direction

	move_and_slide()

func play_cutscene(t_or_f):
	cutscene_is_playing = t_or_f
	if !cutscene_is_playing:
		return
	main_cutscene = false
	timer.start(3.5)

func cutscene():
	flashlight.visible = false
	if !timer.is_stopped():
		blending_position = Vector2(1, 0)
	else:
		blending_position = Vector2(-1, 0)
		if !main_cutscene:
			main.cutscene_finished()
			main_cutscene = true
	animation_tree.set("parameters/Running/blend_position", blending_position)
	velocity = blending_position * (SPEED / 2)
	move_and_slide()

func _on_lava_detect_body_entered(body):
	if body is TileMap:
		print("lava touched")
		main.reset()

func darkness(ToF):
	flashlight.visible = ToF
	playerlight.visible = ToF
	
func reset():
	position = Vector2(-88, -48)
	darkness(false)
