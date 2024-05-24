extends CanvasLayer

# This Script loads particles so that they can be instantiated before being used to reduce lag, this script also autoloads when the game runs

var BlackSmoke = preload("res://Particles/BlackSmoke.tres")
var FireSpread = preload("res://Particles/FireSpread.tres")
var turnedintomushroom = preload("res://Particles/turnedintomushroom.tres")

var materials = [
	BlackSmoke,
	FireSpread,
	turnedintomushroom
]

var frames = 0
var loaded = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for material in materials:
		var particles_instance = GPUParticles2D.new()
		particles_instance.set_process_material(material)
		particles_instance.set_one_shot(true)
		particles_instance.set_modulate(Color(1, 1, 1, 0))
		particles_instance.set_emitting(true)
		self.add_child(particles_instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (frames >= 3):
		set_physics_process(false)
		loaded = true
	frames += 1
