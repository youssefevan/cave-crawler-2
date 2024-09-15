extends Node2D
class_name Level

@export var music : AudioStreamOggVorbis

func _ready():
	AudioHandler.play_music(music, false)
