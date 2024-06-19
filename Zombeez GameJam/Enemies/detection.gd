extends Node2D

@onready var parent = $".."

func _on_detect_player_body_entered(body):
	if body.is_in_group("player"):
		parent.player_is_detected(body, true)

func _on_detect_player_body_exited(body):
	if body.is_in_group("player"):
		parent.player_is_detected(null, false)
