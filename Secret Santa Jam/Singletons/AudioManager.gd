extends AudioStreamPlayer

#Play a sound
func play_sound(stream: AudioStream):
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = stream
	add_child(audioPlayer)
	audioPlayer.play()
	audioPlayer.finished.connect(_remove_node.bind(audioPlayer)) #delete after done playing

#Seek a sound
func play_until(stream: AudioStream , to_pos: float):
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = stream
	add_child(audioPlayer)
	audioPlayer.play()
	
	var audioStopTimer = Timer.new()
	audioPlayer.add_child(audioStopTimer)
	audioStopTimer.one_shot = true
	audioStopTimer.start(to_pos)
	audioStopTimer.timeout.connect(_stop_audio.bind(audioPlayer)) #stop playing after done seeking

# functions that starts with '_' are indication that it's private and shouldn't be called globally
func _stop_audio(audioPlayer: AudioStreamPlayer): 
	audioPlayer.stop()
	_remove_node(audioPlayer) #delete the audio player

func _remove_node(audioPlayer: AudioStreamPlayer): 
	audioPlayer.queue_free()
