extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func show_damage(damage):
	self.text = "[center]"
	self.text += "[nervous]" 
	self.text += "-" + str(damage)
	self.modulate.a = 255
	var tween = create_tween().bind_node(self)
	tween.tween_property(self, "position:y", self.position.y + -5, 0.3)
	tween.tween_property(self, "modulate:a", 0, 0.2)
	await tween.finished
	queue_free()
