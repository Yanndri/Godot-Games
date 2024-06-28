extends Node2D

@export var Subway_position : Vector2 = Vector2(-235, 1712)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_subway_entrance_body_entered(body):
	get_node("%Player").position = Subway_position
