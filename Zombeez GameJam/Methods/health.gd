extends Node2D

@onready var parent = $".."

func _on_detect_attacks_body_entered(body):
	if body.is_in_group("attack"):
		parent.took_damage(body.damage)
	if body.is_in_group("bullet"):
		body.queue_free()

func turn_off():
	for child in get_children():
		var split_text = str(child).split('<') # splits texts that has '<' in between
		var child_type = str(split_text[1]).split('#')
		if child_type[0] == "Area2D": # check if child is area 2d
			child.set_deferred("monitoring", false)

func delete_all():
	for child in get_children():
		child.queue_free()
