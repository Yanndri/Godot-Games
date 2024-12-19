extends AnimationPlayer

#any type of texture button when their signal pressed() is true
func _on_texture_button_pressed() -> void:
	play("buttonPressed")
