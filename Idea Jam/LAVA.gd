extends GPUParticles2D

var lavaNoise : FastNoiseLite = preload("res://Resources/LavaNoise.tres")
var lavaTexture : NoiseTexture2D = preload("res://Resources/lavaTexture.tres")
# Called when the node enters the scene tree for the first time.
func _ready():
	texture = lavaTexture
	lavaTexture.noise = lavaNoise

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lavaNoise.offset.x += 0.5
	lavaNoise.offset.y +=0.1
