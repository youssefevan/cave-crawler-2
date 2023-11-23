extends Node2D

@export var main_menu : PackedScene
@export var custom_level_loader : PackedScene
@export var level_editor : PackedScene

@onready var file_dialog = $FileSystem/FileDialog
@onready var save_dialog = $FileSystem/SaveDialog

var selected_level

var playing := false

func _on_play_pressed():
	file_dialog.visible = true
	playing = true

func _on_file_dialog_file_selected(path):
	selected_level = path

func _on_file_dialog_confirmed():
	if playing == true:
		play_level()
	else:
		load_level()

func _on_file_dialog_canceled():
	selected_level = null
	playing = false

func play_level():
	if selected_level.get_extension() == "cc2":
		var cll = custom_level_loader.instantiate()
		cll.level_path = selected_level
		get_tree().get_root().add_child(cll)
		visible = false
	else:
		$Main/FileTypeError.visible = true

func _on_edit_pressed():
	playing = false
	file_dialog.visible = true

func load_level():
	if selected_level.get_extension() == "cc2":
		var le = level_editor.instantiate()
		le.new_level = false
		le.level_path = selected_level
		get_tree().get_root().add_child(le)
		visible = false
	else:
		$Main/FileTypeError.visible = true

func _on_new_pressed():
	save_dialog.visible = true
	file_dialog.visible = false

func _on_save_dialog_confirmed():
	selected_level = save_dialog.current_path
	
	if selected_level.get_extension() == "cc2":
		var file = FileAccess.open(selected_level, FileAccess.WRITE)
		file.close()
		load_level()
	else:
		$Main/FileTypeError.visible = true

func _on_save_dialog_canceled():
	save_dialog.visible = false

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/gui/menus/menu_main.tscn")
	call_deferred("queue_free")
