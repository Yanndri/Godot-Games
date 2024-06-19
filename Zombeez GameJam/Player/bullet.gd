extends RigidBody2D

@onready var bullet_timer = Timer.new()
@onready var bullet_sprite = $BulletType

var is_instantiate : bool
var damage : int

# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_timer.one_shot = true
	add_child(bullet_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if bullet_timer.time_left == 0:
		queue_free()

func shoot(bullet_life_time, bullet_type):
	bullet_sprite.texture = bullet_type
	bullet_timer.wait_time = bullet_life_time
	bullet_timer.start()

