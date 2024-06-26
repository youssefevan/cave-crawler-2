extends Node

var bus_index_sfx = AudioServer.get_bus_index("SFX")
var bus_index_music = AudioServer.get_bus_index("Music")

var current_streams = []

@onready var music_player = $MusicPlayer

func _ready():
	music_player.set_bus("Music")
	
	OptionsHandler.connect("volume_music_changed", volume_music_changed)
	volume_music_changed()
	
	OptionsHandler.connect("volume_sfx_changed", volume_sfx_changed)
	volume_sfx_changed()

func play_sfx(sound: AudioStream, parent := get_tree().current_scene):
	var stream = AudioStreamPlayer.new()
	
	stream.set_bus("SFX")
	stream.stream = sound
	
	stream.connect("finished", Callable(stream, "queue_free"))
	
	var can_play = true
	for i in parent.get_children():
		if i is AudioStreamPlayer and i.stream == sound:
			can_play = false
	if can_play:
		parent.add_child(stream)
		stream.play()

func play_music(music: AudioStream):
	if music_player.stream != music:
		music_player.stream = music
		music_player.play()
		

func volume_music_changed():
	var vol = (OptionsHandler.volume_music/10) * 2
	AudioServer.set_bus_volume_db(bus_index_music, linear_to_db(vol))

func volume_sfx_changed():
	# 10 steps on slider
	#print("O ", OptionsHandler.volume_sfx)
	var vol = (OptionsHandler.volume_sfx/10) * 2
	#print("V ", vol)
	AudioServer.set_bus_volume_db(bus_index_sfx, linear_to_db(vol))
	#print("B ", linear_to_db(vol))
