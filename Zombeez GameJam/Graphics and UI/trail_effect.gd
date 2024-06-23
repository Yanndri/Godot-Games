extends Line2D

var queue : Array
@export var max_length : int
@export var parent_texture : Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var pos = to_global(get_parent().position) 
	
	#var pos = get_global_mouse_position()
	#add_point(pos)
	#texture = parent_texture.texture
	width = parent_texture.texture.get_width() - 1
	
	queue.push_front(pos)
	
	if queue.size() > max_length:
		queue.pop_back()
	
	clear_points()
	
	for point in queue:
		add_point(point)
	
