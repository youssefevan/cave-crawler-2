extends Node

var bus_index_sfx = AudioServer.get_bus_index("SFX")
var bus_index_music

func _ready():
	OptionsHandler.connect("volume_sfx_changed", volume_sfx_changed)
	volume_sfx_changed()

func play_sfx(sound: AudioStream, parent := get_tree().current_scene):
	var stream = AudioStreamPlayer.new()
	
	stream.set_bus("SFX")
	stream.stream = sound
	stream.connect("finished", Callable(stream, "queue_free"))
	
	parent.add_child(stream)
	stream.play()

func volume_sfx_changed():
	# 10 steps on slider
	#print("O ", OptionsHandler.volume_sfx)
	var vol = (OptionsHandler.volume_sfx/10) * 2
	#print("V ", vol)
	AudioServer.set_bus_volume_db(bus_index_sfx, linear_to_db(vol))
	#print("B ", linear_to_db(vol))
