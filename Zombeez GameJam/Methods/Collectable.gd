extends Node2D

@onready var parent = get_parent()

@export var resource_data : Resource # data of the collectable

# Called when the node enters the scene tree for the first time.
func _ready():
	move_UpAndDown()

func move_UpAndDown():
	var tween = get_tree().create_tween().bind_node(parent)
	tween.tween_property(parent, "position", Vector2(parent.position.x, parent.position.y + -10), 1)
	tween.tween_property(parent, "position", Vector2(parent.position.x, parent.position.y), 1)
	await tween.finished
	move_UpAndDown()

func _on_collect_range_body_entered(body):
	if body.is_in_group("player"):
		body.collect_collectable(resource_data)
		parent.queue_free()
