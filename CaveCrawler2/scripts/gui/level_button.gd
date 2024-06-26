extends InteractableGUI

var path = "res://scenes/levels/"
var level
var level_id : int

signal level_selected(level)

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
	emit_signal("level_selected", level)

