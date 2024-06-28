extends Node2D

@onready var parent = $".."
@export var damage_label_scene : PackedScene
@onready var hit_box : CollisionShape2D = $detect_attacks/CollisionShape2D

func _on_detect_attacks_body_entered(body):
	if body.is_in_group("attack"):
		instantiate_damage(body.damage)
		
	if body.is_in_group("bullet"):
		body.queue_free()

func _on_detect_attacks_area_entered(area):
	var damage = area.get_parent().damage # get the damage of the node that attacked this node
	instantiate_damage(damage)
	

func turn_off():
	for child in get_children():
		var split_text = str(child).split('<') # splits texts that has '<' in between
		var child_type = str(split_text[1]).split('#')
		if child_type[0] == "Area2D": # check if child is area 2d
			child.set_deferred("monitoring", false)

func delete_all():
	for child in get_children():
		child.queue_free()

func instantiate_damage(damage):
	damage = parent.took_damage(damage)
	var damage_label = damage_label_scene.instantiate()

	var hit_size = hit_box.shape.size # how big the health hitbox of the parent is
	damage_label.position += Vector2(randi_range(-hit_size.x / 2, hit_size.x / 2), randi_range(-hit_size.y / 2, 0))
	
	get_parent().add_child(damage_label) # so that any transform of this node doesn't affect this child
	damage_label.show_damage(damage)
