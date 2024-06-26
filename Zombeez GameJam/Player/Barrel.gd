extends Marker2D

@onready var effects = $firing_effects

func _ready():
	effects.visible = false

func fire():
	effects.visible = true
	effects.play()

func update_gun(gun_name):
	effects.animation = gun_name

func _on_firing_effects_animation_finished():
	effects.visible = false
