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
func _process(_delta):
	if bullet_timer.time_left == 0:
		queue_free()

func shoot(gun_data):
	damage = gun_data.damage + randi_range(-(gun_data.damage / 5), (gun_data.damage / 5))
	bullet_sprite.texture = gun_data.bullet_texture
	bullet_timer.wait_time = gun_data.bullet_life_time
	bullet_timer.start()

func detect_layer(layer): # che ck what the bulle should detect
	set_collision_layer_value(layer, true)
