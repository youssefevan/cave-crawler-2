extends Control

@onready var item_list = $ItemList
@onready var details = $Details
@onready var details_info = $Details/VBoxContainer
@onready var details_name = $Details/VBoxContainer/Name
@onready var new_level_panel = $NewLevel
@onready var new_level_line_edit = $NewLevel/VBoxContainer/LineEdit
@onready var delete_panel = $DeleteConfirm
@onready var delete_cancel = $DeleteConfirm/VBoxContainer/Buttons/CancelDelete

var levels = []
var selected_item = null
@onready var path = Global.level_path

func _ready():
	Global.checkpoint_passed = false
	
	if OptionsHandler.cursor_visible == false:
		item_list.grab_focus()
	#OptionsHandler.set_cursor(true)
	
	get_levels()
	
	selected_item = 0
	var item_name = item_list.get_item_text(selected_item)
	details_name.text = str(item_name)
	
	new_level_panel.visible = false
	delete_panel.visible = false

func get_levels():
	clear_levels()
	
	var dir = DirAccess.open(Global.level_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "" and file_name.get_extension() == "cc2":
			if dir.current_is_dir() == false:
				var loc = path + file_name
				levels.append(loc)
				item_list.add_item(file_name)
			
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	for i in range(0, item_list.item_count):
		item_list.set_item_tooltip_enabled(i, false)

func clear_levels():
	levels = []
	item_list.clear()

func _on_item_list_item_selected(index):
	selected_item = index
	var item_name = item_list.get_item_text(index)
	details_name.text = str(item_name)

func _on_play_pressed():
	Global.level_to_load = levels[selected_item]
	get_tree().change_scene_to_packed(Global.custom_level_loader_scene)

func _on_edit_pressed():
	Global.creating_new_level = false
	Global.level_to_load = levels[selected_item]
	get_tree().change_scene_to_packed(Global.level_editor_scene)

func _on_back_pressed():
	get_tree().change_scene_to_packed(Global.main_menu_scene)

func _on_new_pressed():
	if OptionsHandler.cursor_visible == false:
		OptionsHandler.set_cursor(true)
	
	new_level_panel.visible = true
	new_level_line_edit.grab_focus()

func _on_cancel_pressed():
	new_level_line_edit.text = ""
	new_level_panel.visible = false
	$NewLevel/Error.visible = false

func _on_create_pressed():
	if str(path + new_level_line_edit.text + ".cc2") in levels:
		$NewLevel/Error.visible = true
	else:
		Global.creating_new_level = true
		Global.level_to_load = path + new_level_line_edit.text + ".cc2"
		get_tree().change_scene_to_packed(Global.level_editor_scene)

func _on_delete_pressed():
	delete_panel.visible = true
	delete_cancel.grab_focus()

func _on_cancel_delete_pressed():
	delete_panel.visible = false

func _on_confirm_delete_pressed():
	var dir = DirAccess.open(Global.level_path)
	dir.remove(levels[selected_item])
	#print(levels[selected_item])
	delete_panel.visible = false
	get_levels()
