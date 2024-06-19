extends Marker2D

@onready var effects = $firing_effects

func _ready():
	effects.visible = false

func fire():
	effects.visible = true
	effects.play()
	effects.animation_finished

func update_gun(gun_type):
	effects.animation = gun_type

func _on_firing_effects_animation_finished():
	effects.visible = false
