extends RigidBody2D

@onready var main : Node2D = $"."
@onready var detectPlayer = $detectPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if body.position.x > position.x:
			$texture.flip_h = true
		elif body.position.x < position.x:
			$texture.flip_h = false
		detectPlayer.set_deferred("monitoring", false)
		await get_tree().create_timer(.5).timeout
		detectPlayer.set_deferred("monitoring", true)

