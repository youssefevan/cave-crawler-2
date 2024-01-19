extends Control

@onready var file_dialog = $FileSystem/FileDialog
@onready var save_dialog = $FileSystem/SaveDialog

var selected_level

var playing := false

func _ready():
	if OptionsHandler.cursor_visible == false:
		$Main/Items/Play.grab_focus()
	Global.checkpoint_passed = false

func _on_play_pressed():
	OptionsHandler.set_cursor(true)
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
		
		Global.level_to_load = selected_level
		get_tree().change_scene_to_packed(Global.custom_level_loader_scene)
		visible = false
	else:
		$Main/FileTypeError.visible = true

func _on_edit_pressed():
	OptionsHandler.set_cursor(true)
	playing = false
	file_dialog.visible = true

func load_level():
	if selected_level.get_extension() == "cc2":
		
		Global.creating_new_level = false
		Global.level_to_load = selected_level
		get_tree().change_scene_to_packed(Global.level_editor_scene)
		visible = false
	else:
		$Main/FileTypeError.visible = true

func _on_new_pressed():
	OptionsHandler.show_cursor()
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
	get_tree().change_scene_to_packed(Global.main_menu_scene)
