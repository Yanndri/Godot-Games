extends RigidBody2D

var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction
	#position.x += 10

func move_direction(aim_direction):
	direction = -aim_direction / 100
