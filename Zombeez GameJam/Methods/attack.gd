extends Node2D

@onready var parent = $".."

func _on_area_attack_body_entered(body): # area that will damage the player, will detect if made contact
	if body.is_in_group("player"):
		print("dealt damage")
		parent.dealt_damage() # damage the player

func _on_area_attack_body_exited(body):
	if body.is_in_group("player"):
		pass

func _on_attack_range_body_entered(body): # start attacking when on range
	if body.is_in_group("player"):
		parent.attack(true)

func _on_attack_range_body_exited(body): 
	if body.is_in_group("player"):
		parent.attack(false)

func turn_off():
	for child in get_children():
		var split_text = str(child).split('<') # splits texts that has '<' in between
		var child_type = str(split_text[1]).split('#')
		if child_type[0] == "Area2D": # check if child is area 2d
			child.set_deferred("monitoring", false)

func delete_all():
	for child in get_children():
		child.queue_free()
