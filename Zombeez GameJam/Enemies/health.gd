extends Node2D

@onready var parent = $".."

func _on_detect_attacks_body_entered(body):
	if body.is_in_group("attack"):
		parent.dealt_damage(body.damage)
