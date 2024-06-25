extends Node

var levels_unlocked : int

func _ready():
	load_data()

func save_data():
	var file = FileAccess.open(Global.save_path, FileAccess.WRITE)
	file.store_var(levels_unlocked)

func load_data():
	if FileAccess.file_exists(Global.save_path):
		var file = FileAccess.open(Global.save_path, FileAccess.READ)
		levels_unlocked = file.get_var(levels_unlocked)
