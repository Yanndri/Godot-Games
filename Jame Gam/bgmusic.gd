extends AudioStreamPlayer2D

const bg = preload("res://music/2022-10-19_-_No_Way_Out_-_www.FesliyanStudios.com.mp3")
@onready var timer : Timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	musicplayer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func musicplayer():
	stream = bg
	play()
	timer.start(204)


func _on_timer_timeout():
	musicplayer()
