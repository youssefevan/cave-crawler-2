extends InteractableGUI

var path = "res://scenes/levels/"
var level
var level_id : int

signal level_selected(level)

var music_w1 = preload("res://audio/music/world1.ogg")
var music_w2 = preload("res://audio/music/world2.ogg")

func _ready():
	var world_number = str(name)[0]
	var level_number = str(name)[0] + "_" + str(name)[2]
	var level_path = path + "world" + world_number + "/level_" + level_number + ".tscn"
	
	match int(world_number):
		1:
			level_id = int(level_number[2])
		2:
			level_id = 5 + int(level_number[2])
		3:
			level_id = 10 + int(level_number[2])
	
	if OptionsHandler.levels_unlocked < level_id:
		disabled = true
	else:
		disabled = false
	
	level = load(level_path)
	connect("pressed", _on_pressed)

func _on_pressed():
	super._on_pressed()
	var world_number = str(name)[0]
	if world_number == "1":
		AudioHandler.play_music(music_w1, false)
	elif world_number == "2":
		AudioHandler.play_music(music_w2, false)
	
	emit_signal("level_selected", level)

