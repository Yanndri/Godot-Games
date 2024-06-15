extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	interval_1st()
	#var tween = create_tween()
	#tween.tween_property(self, "position", Vector2(position.x, position.y - 5), 1) # This goes upward ex: (position.y - 5)
	#tween.tween_property(self, "position", Vector2(position.x, position.y), 2) # To get back from it's normal position you don't need to add values ex: (position.y) 
	#since they are in the same scope and they are ran at the same time but the animation, so if you add values ex: (position.y + 5) it will add 5 to the normal POS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interval_1st():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(position.x, position.y - 5), 1) # This goes upward
	await get_tree().create_timer(1).timeout
	interval_2nd()

func interval_2nd():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(position.x, position.y + 5), 1) # If they are not in the same scope you have to add the values, This goes downward to go back to it's normal POS
	await get_tree().create_timer(1).timeout
	interval_1st()
