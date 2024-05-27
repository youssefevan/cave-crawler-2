extends Control

@onready var item_list = $ItemList
@onready var details = $Details
@onready var details_info = $Details/VBoxContainer
@onready var details_name = $Details/VBoxContainer/Name
@onready var new_level_panel = $NewLevel
@onready var new_level_line_edit = $NewLevel/VBoxContainer/LineEdit

var levels = []
var selected_item = null
@onready var path = "res://custom_levels/"

func _ready():
	if OptionsHandler.cursor_visible == false:
		item_list.grab_focus()
	Global.checkpoint_passed = false
	
	OptionsHandler.set_cursor(true)
	
	get_levels()
	
	selected_item = 0
	var name = item_list.get_item_text(selected_item)
	details_name.text = str(name)
	
	new_level_panel.visible = false

func get_levels():
	levels = []
	
	var dir = DirAccess.open("res://custom_levels/")
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

func _on_item_list_item_selected(index):
	selected_item = index
	var name = item_list.get_item_text(index)
	details_name.text = str(name)

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
	new_level_panel.visible = true
	new_level_line_edit.grab_focus()

func _on_cancel_pressed():
	new_level_line_edit.text = ""
	new_level_panel.visible = false

func _on_create_pressed():
	Global.creating_new_level = true
	Global.level_to_load = path + new_level_line_edit.text + ".cc2"
	get_tree().change_scene_to_packed(Global.level_editor_scene)
