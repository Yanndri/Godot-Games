extends GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	emitting = true
	one_shot= true
	
func _on_finished():
	queue_free()
