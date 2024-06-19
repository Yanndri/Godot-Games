extends Node2D

@onready var parent = $".."

var attacking_player : bool

func _on_area_attack_body_entered(body):
	if body.is_in_group("player"):
		parent.attack_player(true)
		attacking_player = true

func _on_area_attack_body_exited(body):
	if body.is_in_group("player"):
		parent.attack_player(false)
		attacking_player = false

func _on_attack_range_body_entered(body):
	if body.is_in_group("player"):
		print("damaged_player")

func _on_attack_range_body_exited(body):
	if body.is_in_group("player"):
		pass

func _ready():
	$attack_range.set_deferred("monitoring", false)
	$attack_range.set_deferred("monitorable", false)

func _process(delta):
	if attacking_player:
		if parent.damage_player(): # returns true once the Parent node's attack can deal damage
			$attack_range.set_deferred("monitoring", true)
			$attack_range.set_deferred("monitorable", true)
		else:
			$attack_range.set_deferred("monitoring", false)
			$attack_range.set_deferred("monitorable", false)
