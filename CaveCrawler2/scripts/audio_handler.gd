extends Node

func play_sfx(sound: AudioStream, parent := get_tree().current_scene):
	var stream = AudioStreamPlayer.new()
	
	stream.set_bus("SFX")
	stream.stream = sound
	stream.connect("finished", Callable(stream, "queue_free"))
	
	parent.add_child(stream)
	stream.play()
